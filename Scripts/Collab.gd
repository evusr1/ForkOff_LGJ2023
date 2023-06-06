extends Area2D

@export var collab_code:PackedScene
@export var pullreq:PackedScene

const DISTANCE = 200.0
const SPEED = 3.5

const SPAWN_PR_CHANCE = 0.10
const SPAWN_CODE_CHANCE = 0.35

var Main
var target

var t = 0.0
var p0 = Vector2.ZERO
var p1 = Vector2.ZERO

var roll_angry = false

func spawn_pr(pr_target):
	var new_pr = pullreq.instantiate()
	new_pr.init(Main, pr_target)
	new_pr.position = position
	Main.add_child(new_pr)

func spawn_code(totals):
	var new_code = collab_code.instantiate()
	new_code.init(Main, totals, self)
	new_code.position = position
	Main.add_child(new_code)
	spawn_pr(new_code)

func daily(totals):
	var PR_ROLL = totals.complexity * SPAWN_PR_CHANCE
	var SPAWN_ROLL = totals.complexity * SPAWN_CODE_CHANCE
	
	if(randi_range(0, PR_ROLL) < 5):
		var pr_target = Main.get_random_function_sanitized()
		if(pr_target):
			spawn_pr(pr_target)
	if(randi_range(0, SPAWN_ROLL) < 5):
		spawn_code(totals)

func init(_Main, _target):
	Main = _Main
	target = _target

func _ready():
	if(!target):
		queue_free()
	p0 = position
	p1 = Vector2(position.x + randf_range(-DISTANCE, DISTANCE), position.y + randf_range(-DISTANCE, DISTANCE))

func _process(delta):
	t += delta / SPEED
	position = $UserUtils._quadratic_bezier(p0, p1, target.position, t)
	
	if(t > 1.1):
		t = 0
		p0 = position
		p1 = Vector2(position.x + randf_range(-DISTANCE, DISTANCE), position.y + randf_range(-DISTANCE, DISTANCE))
		target.position

