extends Node2D

signal animation_finished

@onready var reels: Array[Node2D] = [$Reel1, $Reel2, $Reel3] #In order Left to Right
var reels_stopped: Array[bool] = [false, false, false]
@export var regimen_speed: int = 500
@export var base_spin_up_time: float = 1.5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func reset_state() -> void:
	for reel in reels:
		reel.reset_state()
	
func start() -> void:
	for reel in reels:
		reel.start(regimen_speed, base_spin_up_time)
		

func stop(index, stop_time):
	for reel in reels:
		reel.stop_at(index, stop_time)
	
	await get_tree().create_timer(stop_time +0.5).timeout
	
	emit_signal("animation_finished")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_key_1"):
		stop(2, 0.5)
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
