extends Control

@onready var black = $BlackOverlay
@onready var anim = $SubViewport/CenterContainer/Control/AnimatedSprite2D

var initial_speed = 24.0
var slowdown_time = 3.0
var elapsed = 0.0
var fade_out_time = 1.0
var fade_in_delay = 2.0
var fade_in_time = 1.5

@export var next_scene: PackedScene

func _ready():
	# Play animation fast
	anim.speed_scale = initial_speed / anim.speed_scale
	anim.play()

	# Set initial black
	black.modulate.a = 1.0

	# Create a Tween and chain both fades
	var tween = create_tween()
	tween.tween_property(black, "modulate:a", 0.0, fade_out_time)  # fade out
	tween.tween_interval(fade_in_delay)  # wait before fade in
	tween.tween_property(black, "modulate:a", 1.0, fade_in_time)   # fade back in
	await tween.finished
	get_tree().change_scene_to_packed(next_scene)

func _process(delta):
	elapsed += delta
	if elapsed < slowdown_time:
		var t = elapsed / slowdown_time
		anim.speed_scale = initial_speed * (1.0 - t) / anim.speed_scale
	else:
		anim.speed_scale = 0
		
