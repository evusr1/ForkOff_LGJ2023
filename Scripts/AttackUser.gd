extends Area2D
const DISTANCE = 200.0

var Main
var worth
var target

var t = 0.0
var p0 = Vector2.ZERO
var p1 = Vector2.ZERO

var clout = 0

var dead = false

func reset_curve():
	t = 0
	p0 = position
	p1 = Vector2(position.x + randf_range(-DISTANCE, DISTANCE), position.y + randf_range(-DISTANCE, DISTANCE))


func init(_Main, totals, _target):
	Main = _Main
	target = _target
	clout = totals.clout
	
func _ready():
	
	if(!target):
		queue_free()
	p0 = position
	p1 = Vector2(position.x + randf_range(-DISTANCE, DISTANCE), position.y + randf_range(-DISTANCE, DISTANCE))
	
func _process(delta):
	t += delta
	if(dead):
		Main.remove_bullet(self)
	if(is_instance_valid(target)):	
		position = $UserUtils._quadratic_bezier(p0, p1, target.position, t)
	else:
		target = Main.get_player()
		reset_curve()
	if(t>1.5):
		dead = true


func _on_body_entered(body):
	if(target == body && body.is_in_group("Player")):
		var totals = Main.create_totals()
		totals.clout += 1
		Main.update_totals(totals)
		dead = true
