extends StaticBody2D
@export var user_spawn : PackedScene
var complexity_points = 1

var limit = 1

var last_post_difference = 0
var last_complexity_difference = 0

var last_post_day = 0
var last_complexity = 0

var users_to_send = 0

var posted = false

func init(totals):
	totals.complexity += complexity_points
	
func enter():
	$BuildingBase.enter()
	
func exit() :
	$BuildingBase.exit()

func _ready():
	$BuildingBase.init(complexity_points)
	
func action(totals):
	if(!posted && !$BuildingBase.is_complete()):
		return
		
	$UserTimer.stop()
	
	if(totals.clout > 5):
		totals.clout -= 5
	
	last_post_difference = totals.day - last_post_day
	last_complexity_difference = totals.complexity - last_complexity
	
	users_to_send += (totals.day - last_post_day + last_complexity_difference) 
	if(totals.clout > 0):
		users_to_send += users_to_send * totals.clout
	
	last_complexity = totals.complexity
	last_post_day = totals.day
	$DebugPosted.text = "Posted!"
	
	totals.socials += 1
	posted = true
	
func daily(totals):
	if(!$BuildingBase.is_complete()):
		return
		
	$DebugPosted.text = ""
	posted = false
	
	users_to_send +=  last_complexity_difference / (totals.day - last_post_day)
	print(users_to_send)
	
	var user_slices = users_to_send / ( log(users_to_send) / log(2) )
	print("userslice %f" % user_slices)
	
	$UserTimer.wait_time = totals.time / pow(2 , user_slices - 1)
	if($UserTimer.wait_time <= 0.000001 || $UserTimer.wait_time >= 30):
		$UserTimer.wait_time = 1
		
	print("waittime %f" % $UserTimer.wait_time)
	
	$UserTimer.start()
	
func _on_user_timer_timeout():
	var users_on_tick = round(users_to_send / 2)
	var Main = self.get_parent()
	var target = Main.get_random_function()
	
	if(users_on_tick > 100):
		var user_amt = round(100 / users_on_tick)
		var user_worth = round(users_on_tick / 100)
		
		for n in range(0, user_amt):
			var new_user = user_spawn.instantiate()
			new_user.position = position
			new_user.init(Main, user_worth, target)
			Main.add_child(new_user)
	else:
		for n in range(0, users_on_tick):
			var new_user = user_spawn.instantiate()
			new_user.position = position
			new_user.init(Main, 1, target)
			Main.add_child(new_user)
		
	users_to_send = users_on_tick
	
	print($UserTimer.wait_time)
	
	if($UserTimer.wait_time != 1):
		$UserTimer.wait_time *= 2 
	
	if(users_to_send <= 0):
		users_to_send = 0
		$UserTimer.stop()

	
	
