extends StaticBody2D

@export var collab_req : PackedScene
@export var evil_collab : PackedScene

const CLOUT_REQ = 100.0
const COLLAB_SCALE = 0.50
const CLOUT_EVIL_REQ = 250.0

const COLLAB_CHANCE = 0.35
const EVIL_CHANCE = 0.35

var complexity_points = 1
var complexity = 1
var limit = 1

var collab_limit = 0
var collab_count = 0

var Main

var collabs:Array
var evil_collabs:Array

func init(totals):
	complexity = totals.complexity
	totals.complexity += complexity_points

func enter() :
	$BuildingBase.enter()
	
func exit() :
	$BuildingBase.exit()

func _ready():
	Main = self.get_parent()
	$BuildingBase.init(complexity_points + complexity * complexity_points)

func spawn_evil(totals):
	var new_collab = evil_collab.instantiate()
	new_collab.init(self,totals)
	new_collab.position = position
	Main.add_child(new_collab)

func spawn_collab():
	var target = self

	var new_collab = collab_req.instantiate()
	new_collab.position = position
	new_collab.init(Main, target)
	Main.add_child(new_collab)
	
	collabs.push_back(new_collab)
	collab_count += 1

func action(totals):
	#spawn_evil(totals)
	#spawn_collab()
	$BuildingBase.action(totals)

func evil_daily_roll(totals):

	if(randf() > EVIL_CHANCE):
		spawn_evil(totals)

func evil_roll(collab, totals):
	if(collab.roll_angry && randf() < EVIL_CHANCE):
		
		spawn_evil(totals)
		collabs = collabs.filter(func(c): return c != collab)
		collab.queue_free()
		return true
	else:
		collab.roll_angry = false
	return false

func daily(totals):
	if(!$BuildingBase.is_complete()):
		return
		
	
	
	collab_limit = round(totals.clout / (CLOUT_REQ * (collab_count + 1) * COLLAB_SCALE))
	
	if(collab_count <= collab_limit):
		if(randf() < COLLAB_CHANCE):
			spawn_collab()
			evil_daily_roll(totals)
			
#	elif(!collabs.is_empty()):
#		collabs.pop_back().queue_free()
#		collab_count -= 1

	for collab in collabs:
		if(!evil_roll(collab, totals)):
			collab.daily(totals)

	$BuildingBase.daily(totals)

