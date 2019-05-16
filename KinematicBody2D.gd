extends KinematicBody2D

const GRAVITY = 10
const BOUNCE_VELOCITY = 200
const BOUNCE_FACTOR = .5

var motion = Vector2()
var moving = true

var color = null

func _physics_process(delta):
	#motion.y += 10
	move_and_slide(motion, Vector2(0, -1))
	
	if is_on_floor():
		#if motion.y > BOUNCE_VELOCITY:
			#motion.y = -motion.y * BOUNCE_FACTOR
			#pass
		#else:
			motion.y = 0
			moving = false
	else:
		moving = true
		
		
