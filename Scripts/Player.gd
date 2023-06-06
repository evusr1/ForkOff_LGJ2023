extends CharacterBody2D

@export var max_speed = 400
@export var acceleration = 15
const FRICTION = 0.1

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(input_direction):
		velocity += input_direction * acceleration
	else:
		velocity = lerp(velocity, Vector2.ZERO, FRICTION)

func _physics_process(delta):
	get_input()
	move_and_slide()
	velocity = velocity.limit_length(max_speed)
	

