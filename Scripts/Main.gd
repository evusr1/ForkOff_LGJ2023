extends Node

@export var building_scenes: Array[PackedScene]
var building_scenes_count: Array[int]

var current_building = 0

var total_clout = 0
var total_complexity = 0
var total_social_posts = 0

var is_github = false

@export var day_length: int
var current_tick = day_length
var current_day = 0

var user_targets:Array
var bullets:Array

func get_bullets():
	return bullets


func kill_evil_collab(evil):
	for bullet in bullets:
		if(bullet.target == evil):
			bullet.target = $Player

	evil.queue_free()

func remove_bullet(bullet):
	bullets = bullets.filter(func(b): return bullet != b)
	bullet.queue_free()

func remove_target(code):
	user_targets = user_targets.filter(func(c): return code != c)
	code.queue_free()

func get_player():
	return $Player

func get_random_function():
	if(user_targets.size()>0):
		return user_targets.pick_random()
	return null
	
func get_random_function_sanitized():
	if(!user_targets.is_empty()):
		var user_targets_buildings = user_targets.filter(func(code): return code.is_in_group("Buildings"))
		return user_targets_buildings.pick_random()
	return null

func get_functions():
	return user_targets.duplicate()

func update_screen():
	$GUI.display_complexity = total_complexity
	$GUI.display_clout = total_clout
	$GUI.display_day = current_day
	$GUI.display_time = current_tick
	$GUI.display_selected = ['New Function', 'New Git', 'New Social'][current_building]

func create_totals():
	return {
		'day': current_day,
		'clout': total_clout,
		'complexity': total_complexity,
		'time': current_tick,
		'socials': total_social_posts,
		'building_amnt': building_scenes_count
	}

func update_totals(totals):
	total_clout = totals.clout
	total_complexity = totals.complexity

func handle_new_day():
	var totals = create_totals()
	
	get_tree().call_group("Buildings","daily", totals)
	
	update_totals(totals)

func add_user_target(target):

	user_targets.push_back(target)

func spawn():
	if(!$Crosshair.is_build_enabled()):
		return
		
	var building_amt = building_scenes_count[current_building]
	var new_spawn = building_scenes[current_building].instantiate()
	
	if(new_spawn.limit && building_amt >= new_spawn.limit):
		new_spawn.queue_free()
		return;
		
	building_scenes_count[current_building] += 1
	
	if(new_spawn.is_in_group("Function")):
		add_user_target(new_spawn)
	
	new_spawn.position = $Player.position + $Crosshair.relative_pos()
	
	var totals = create_totals()
	
	new_spawn.init(totals)
	
	update_totals(totals)
	
	add_child(new_spawn)
	

func _process(delta):
	var totals = create_totals()
	$Crosshair.handle_input(totals)
	update_totals(totals)
	
	$Crosshair.handle_move(delta, $Player)
	if(Input.is_action_just_released("action_y")):
		spawn()
		
	if(Input.is_action_just_pressed("action_x")):
		update_screen()
		if(current_building < building_scenes.size() - 1):
			current_building += 1
		else:
			current_building = 0

func _ready():
	building_scenes_count.resize(building_scenes.size())
	
func _on_day_timer_timeout():
	current_tick -= 1

	if(current_tick < 0):
		current_tick = day_length
		current_day += 1
		handle_new_day()
	update_screen()
		
