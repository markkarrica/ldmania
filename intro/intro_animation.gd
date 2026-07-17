extends AnimatedSprite2D

# initial speed (frames per second)
var initial_speed = 24.0
# time in seconds to slow down to zero
var slowdown_time = 3.0
var elapsed = 0.0

func _ready():
	speed_scale = initial_speed / speed_scale  # adjust if animation FPS is not 1
	play()  # ensure animation is playing

func _process(delta):
	elapsed += delta
	if elapsed < slowdown_time:
		# gradually reduce speed_scale from initial to 0
		var t = elapsed / slowdown_time
		speed_scale = initial_speed * (1.0 - t) / speed_scale
	else:
		speed_scale = 0  # fully stopped
