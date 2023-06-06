extends Area2D

const DISTANCE = 200.0
const SPEED = 3.5

var Main
var target
var added = false

var t = 0.0
var p0 = Vector2.ZERO
var p1 = Vector2.ZERO


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

func _on_body_entered(body):
	if(body == target):
		if(!added):
			added = true
			body.add_pr(self)
			body.visible = true

			if(body.is_in_group("CollabCode")):
				Main.add_user_target(target)
				
