extends CanvasLayer

@export var display_time = 0
@export var display_day = 0
@export var display_complexity = 0
@export var display_clout = 0
@export var display_selected = "NONE"

func update_display():
	var temp_text = """
	Day: %d
	Time: %d
	Clout: %d
	Complexity: %d
	Selected: %s
	"""
	$DisplayStatus.text = temp_text % [display_day, display_time, display_clout, display_complexity, display_selected]
	
func _process(delta):
	update_display()
