extends Node2D

enum {
	START_STATE,
	STOP_STATE,
	RANDOM_STATE_IN,
	RANDOM_STATE_OUT,
	RANDOM_STATE_ZERO_IN,
	RANDOM_STATE_ZERO_OUT,
}

const CLOUD1_IN = 2.0
const CLOUD1_OUT = 1.5

const CLOUD2_IN = 1.5
const CLOUD2_OUT = 1.0

const CLOUD1_DISTANCE = 128 * CLOUD1_IN
const CLOUD2_DISTANCE = 128 * CLOUD2_IN

const ACCEL = 0.2
const ACCEL_CLOUD2 = 0.14

var state = RANDOM_STATE_IN

var cloud1_scale = CLOUD1_OUT
var cloud2_scale = CLOUD2_OUT

var cloud1_velocity = Vector2.ZERO
var cloud2_velocity = Vector2.ZERO

var cloud1_pos = Vector2.ZERO
var cloud2_pos = Vector2.ZERO

func _ready():
	cloud1_pos = $Clouds1.position
	cloud2_pos = $Clouds2.position

func _process(delta):
	match(state):
		RANDOM_STATE_IN:
			cloud2_scale = lerp(cloud2_scale, CLOUD2_IN, ACCEL_CLOUD2 * delta)
			cloud1_scale = lerp(cloud1_scale, CLOUD1_IN, ACCEL * delta)
			
			if(cloud1_scale >= CLOUD1_IN - 0.05):
				state = RANDOM_STATE_ZERO_OUT
				cloud1_velocity = Vector2(0,0)
				cloud2_velocity = Vector2(0,0)
		RANDOM_STATE_ZERO_IN:
			cloud1_velocity = Vector2(randi_range(-1, 1),randi_range(-1, 1))
			cloud2_velocity = -cloud1_velocity
			state = RANDOM_STATE_IN
		RANDOM_STATE_ZERO_OUT:
			state = RANDOM_STATE_OUT
			cloud1_velocity = Vector2(randi_range(-1, 1),randi_range(-1, 1))
			cloud2_velocity = -cloud1_velocity
		RANDOM_STATE_OUT:
			cloud2_scale = lerp(cloud2_scale, CLOUD2_OUT, ACCEL_CLOUD2 * delta)
			cloud1_scale = lerp(cloud1_scale, CLOUD2_OUT, ACCEL * delta)

			if(cloud1_scale <= CLOUD2_OUT + 0.5):
				state = RANDOM_STATE_ZERO_IN
				cloud1_velocity = Vector2(0,0)
				cloud2_velocity = Vector2(0,0)

	$Clouds1.scale = Vector2(cloud1_scale,cloud1_scale)
	$Clouds2.scale = Vector2(cloud2_scale,cloud2_scale)
	$Clouds1.position = lerp($Clouds1.position, cloud1_pos + cloud1_velocity * CLOUD1_DISTANCE, ACCEL_CLOUD2 * delta)
	$Clouds2.position = lerp($Clouds2.position, cloud2_pos + cloud2_velocity * CLOUD2_DISTANCE, ACCEL * delta)
	
	
	
