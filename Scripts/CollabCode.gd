extends StaticBody2D

var complexity_points = 10
var complexity = 1
var limit = 0
var Main

var built = false

var screen_size
var PR
var parent_collab
var accepted = false


func init(_Main, totals, _parent_collab):
	complexity = totals.complexity
	Main = _Main
	parent_collab = _parent_collab

func is_complete():
	return $BuildingBase.is_complete()

func add_pr(_PR):
	PR = _PR

func _ready():
	visible = false
	
	screen_size = get_viewport_rect().size
	position = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))
	$BuildingBase.init(complexity_points  * randf_range(0, 1) + complexity * randf_range(0, complexity_points))

func enter() :
	pass
	
func exit() :
	pass


func action(totals):
	print("action")
	if(PR && !accepted):
		$BuildingBase.is_selected = true
		PR.queue_free()
		PR = null
		totals.complexity += complexity_points
		$BuildingBase/BuildTimer.wait_time = 0.35
		accepted = true
	$BuildingBase.action(totals)
	
func deny(totals):
	print("deny")
	if(PR):
		PR.queue_free()
		PR = null
		parent_collab.roll_angry = true
		Main.remove_target(self)
	$BuildingBase.action(totals)

func daily(totals):
	$BuildingBase.daily(totals)
