extends StaticBody2D

const BUILD_SPEED = 50
var limit = 0
var Main

var screen_size

func _ready():
	visible = false

	Main = get_parent()
	screen_size = get_viewport_rect().size
	position = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))

func is_complete():
	return $BuildingBase.is_complete()
	
func enter():
	visible = true

	
	$BuildingBase.init(BUILD_SPEED)
	$BuildingBase.enter()
	Main.add_user_target(self)
