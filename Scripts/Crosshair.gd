extends Area2D

@export var user_ammo : PackedScene

var can_build = true
var is_move = false
var selected
var has_target = null
var max_speed = 800
var acceleration = 25

var velocity = Vector2.ZERO
var rel_pos = Vector2(0, 0)

const MAX_DISTANCE = 200
const FRICTION = 1

var intersecting_objects:Array

	

func spawn_attack(totals, target):
	var Main = self.get_parent()
	var new_attack = user_ammo.instantiate()
	new_attack.position = Main.get_player().position
	new_attack.init(Main, totals, target)
	Main.add_child(new_attack)
	
	return new_attack

func handle_move(delta, player):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if(input_direction):
		velocity = (velocity + input_direction.normalized() * acceleration * delta).limit_length(max_speed)
		velocity = lerp(velocity, velocity + input_direction.normalized(), acceleration * delta)
	else:
		velocity = lerp(velocity, Vector2.ZERO, FRICTION)

	rel_pos = (rel_pos + velocity).limit_length(MAX_DISTANCE)
	position = player.position + rel_pos
		
func handle_input(totals):
	update_selected()
	
		
	if(Input.is_action_just_released("action_b")):

		if(is_move && can_build):
			is_move.position = position
			is_move = null
			update_selected()
		if(selected && selected.is_in_group("Confirm")):
			selected.deny(totals)
		elif(selected && selected.is_in_group("Buildings")):
			is_move = selected
			$CanvasLayer/Ptr2.visible = true
			$CanvasLayer/Ptr2.position = is_move.position
		
			
	if(Input.is_action_just_released("action_a")):
		if(has_target):
			var Main = get_parent()
			Main.get_bullets().push_back(spawn_attack(totals, has_target))
		elif(selected && !is_build_enabled() && selected.is_in_group("Action")):
			selected.action(totals)
	
	
func update_selected():
	if(!is_move):
		if(has_target):
			$CanvasLayer/Ptr2.position = has_target.position
			$CanvasLayer/Ptr2.visible = true
			return

		if(intersecting_objects.is_empty()):
			$CanvasLayer/Ptr2.visible = false
			selected = null
			return
			
		
		selected = intersecting_objects.front()
		if(is_instance_valid(selected)):
			$CanvasLayer/Ptr2.visible = true
			$CanvasLayer/Ptr2.position = selected.position


func _on_body_entered(body):
	intersecting_objects = get_overlapping_bodies().filter(func(body2): return body2.is_in_group("NoBuild") || body2.is_in_group("Action"))
	
	if(!intersecting_objects.is_empty()):
		can_build = false;
		
	if(!is_move):
				
		if(body.is_in_group("Action")):
			body.enter()
		
	update_selected()

func _on_body_exited(body):
	intersecting_objects = get_overlapping_bodies()
	
	if(intersecting_objects.is_empty()):
		can_build = true;
		
	if(body.is_in_group("Action")):
		body.exit()
	
	update_selected()

func relative_pos():
	return rel_pos

func is_build_enabled():
	return !is_move && can_build

func _on_area_entered(area):
	if(!has_target && area.is_in_group("EvilCollab")):
		has_target = area
		update_selected()

func _on_area_exited(area):
	if(has_target == area):
		has_target = null
		update_selected()
