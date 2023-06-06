extends StaticBody2D

const COMPLEXITY_ADD_PR = 3
const PERCENTAGE_HELP_PR = 0.33

var complexity_points = 10
var complexity = 1
var limit = 0
var Main

var PRS:Array

func init(totals):
	complexity = totals.complexity
	totals.complexity += complexity_points

func is_complete():
	return $BuildingBase.is_complete()

func enter() :
	$BuildingBase.enter()

func exit() :
	$BuildingBase.exit()
	
func _ready():
	$BuildingBase.init(complexity_points + complexity * complexity_points)
	Main = get_parent()
	$DebugPR.text = ""

func add_pr(pr):
	PRS.push_back(pr)
	$DebugPR.text = "PRs: %d" % PRS.size()

func action(totals):
	while(!PRS.is_empty()):
		
		if(is_complete()):
			totals.complexity += COMPLEXITY_ADD_PR
		else:
			$BuildingBase.current_tick = $BuildingBase.current_tick * PERCENTAGE_HELP_PR
			
		PRS.pop_back().queue_free()
		
	$DebugPR.text = ""
		
	$BuildingBase.action(totals)

func daily(totals):
	$BuildingBase.daily(totals)
