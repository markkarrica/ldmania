extends Node2D

@export var next_scene: PackedScene
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("transition")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_timer_timeout() -> void:
	animation_player.play_backwards("transition")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(next_scene)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		get_tree().change_scene_to_packed(next_scene)
