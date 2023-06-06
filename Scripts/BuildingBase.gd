extends Node2D

var to_completion : int
var completed = false
var current_tick : int
var is_selected = false

func init(_to_completion):
	to_completion = _to_completion
	current_tick = to_completion
	$BuildTimer.start()

func is_complete():
	return completed

func update_status():
	if(!is_complete()):
		if(current_tick == 0):
			$DebugCompletion.text = "Hover to finish"
		else:
			$DebugCompletion.text = "%ds" % current_tick

func _process(delta):
	update_status()

func _on_build_timer_timeout():
	if(current_tick <= 0):
		if(is_selected):
			$DebugCompletion.text = ""
			completed = true
	else:
		current_tick-= 1
		update_status()

func daily(totals):
	pass

func enter():
	is_selected = true;
	$BuildTimer.wait_time = 0.025
	
func exit():
	is_selected = false;
	$BuildTimer.wait_time = 1

func action(totals):
	pass
