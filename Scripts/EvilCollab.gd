extends Area2D

@export var fork_code : PackedScene
@export var user_ammo : PackedScene

const DISTANCE = 200
const SPEED = 3.5
const CODE_BUILDING_NUM = 0
const CLOUT_PER_FORK = 10

var Main
var target
var targets_copy:Array
var targets_monitor:Array
var t = 0.0
var p0 = Vector2.ZERO
var p1 = Vector2.ZERO
var clout = 0
var code_amt

var lose_user = 0
enum {
	COLLAB_START,
	COLLAB_COPY_TARGET,
	COLLAB_BUILD_TARGET,
	COLLAB_MONITOR_TARGET
}

var target_state = COLLAB_START
var next_state = true

func spawn_fork():
	var new_fork = fork_code.instantiate()
	Main.add_child(new_fork)

	return new_fork

func reset_curve():
	t = 0
	p0 = position
	p1 = Vector2(position.x + randf_range(-DISTANCE, DISTANCE), position.y + randf_range(-DISTANCE, DISTANCE))


func get_next_target():
	match(target_state):
		COLLAB_START:
			target_state = COLLAB_BUILD_TARGET
		COLLAB_BUILD_TARGET: #choose one of player's code to fork
			clout += CLOUT_PER_FORK
			while(!targets_copy.is_empty()):
				target = targets_copy.pop_front()
				if(target.is_in_group("Function") && target.is_complete()):
					break
			if(!(target.is_in_group("Function") && target.is_complete())):
				print('none found')
				target_state = COLLAB_MONITOR_TARGET
				target = null
				get_next_target()
			else:
				target_state = COLLAB_COPY_TARGET

		COLLAB_COPY_TARGET: #go spawn a code and go to it
			target = spawn_fork()
			targets_monitor.push_back(target)
			target_state = COLLAB_BUILD_TARGET
		
		COLLAB_MONITOR_TARGET:
			queue_free()
			target = targets_monitor.pop_front()
			targets_monitor.push_back(target)
			

func init(_target, totals):
	target = _target
	code_amt = totals.building_amnt[CODE_BUILDING_NUM]
	
func _ready():
	Main = get_parent()
	targets_copy = Main.get_functions()
	reset_curve()

func _process(delta):
	if(target):
		t += delta / SPEED
		position = $UserUtils._quadratic_bezier(p0, p1, target.position, t)
		if(next_state):
			get_next_target()
			reset_curve()
			next_state = false
	if(lose_user > 0):
		var totals = Main.create_totals()
		spawn_attack(totals)
		lose_user-=1
		Main.update_totals(totals)
	if(clout < 0):
		if(target && target.is_in_group("Fork")):
			Main.remove_target(target)
		Main.kill_evil_collab(self)

func daily(totals):
	if(code_amt < totals.building_amnt[CODE_BUILDING_NUM]):
		code_amt = totals.building_amnt[CODE_BUILDING_NUM]
	

func _on_body_entered(body):
	if(body == target && !next_state):
		next_state = true
		if(body.is_in_group("Fork")):
			target.enter()

func spawn_attack(totals):
	var new_attack = user_ammo.instantiate()
	new_attack.position = position
	new_attack.init(Main, totals, Main.get_player())
	Main.add_child(new_attack)


func _on_area_entered(area):
	if(area.is_in_group("AttackUser")):
		var totals = Main.create_totals()
		if(area.target==self):
			if(area.clout > clout):
				clout -=1
				lose_user += 1
				area.target = Main.get_player()
				area.reset_curve()
				
			else:
				clout +=1
				totals.clout -=1
				area.dead = true
				
		Main.update_totals(totals)
