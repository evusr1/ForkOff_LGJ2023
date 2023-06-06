extends Area2D
const DISTANCE = 200.0
const SPEED = 3.5

var Main
var worth
var target

var t = 0.0
var p0 = Vector2.ZERO
var p1 = Vector2.ZERO

func init(_Main, _worth, _target):
	Main = _Main
	worth = _worth
	target = _target
	
func _ready():
	
	if(!target):
		queue_free()
	p0 = position
	p1 = Vector2(position.x + randf_range(-DISTANCE, DISTANCE), position.y + randf_range(-DISTANCE, DISTANCE))
	
func _process(delta):
	t += delta / SPEED
	if(!is_instance_valid(target) || t > 1.5):
		queue_free()
	position = $UserUtils._quadratic_bezier(p0, p1, target.position, t)

		
func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(body == target):
		var totals = Main.create_totals()
		
		if(body.is_in_group("Function")):
			if(body.is_complete()):
				totals.clout += worth
			else:
				totals.clout -= worth
		elif(body.is_in_group("Fork")):
			if(body.is_complete()):
				totals.clout -= worth
			else:
				totals.clout += worth
		
		Main.update_totals(totals)
		queue_free()
