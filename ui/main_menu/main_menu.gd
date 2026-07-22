extends Control

@export_file("*.tscn") var play_scene: String
@onready var seed_text = $"MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Seed text"
@onready var seed_wrong_timer = $SeedWrongTimer
@onready var title = $Title
@export_file("*.tscn") var settings_scene: String

@export_category("Title animation")
@export var max_rotation: float = 15.0
@export var swing_duration: float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.rotation_degrees = max_rotation
	
	var title_tween = create_tween().set_loops()
	
	title_tween.tween_property(title, "rotation_degrees", -max_rotation, swing_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
		
	title_tween.tween_property(title, "rotation_degrees", max_rotation, swing_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_play_button_pressed() -> void:
	if !seed_text.text.is_valid_int():
		seed_text.text = ""
		seed_text.placeholder_text = "SEED NOT VALID"
		seed_text.modulate = Color.RED
		seed_wrong_timer.start()
		return
	Util.random.set_seed(int(seed_text.text))
	get_tree().change_scene_to_file(play_scene)

func _on_seed_text_text_changed(new_text: String) -> void:
	# If empty, allow it
	if new_text.is_empty():
		return
	
	# Check if the new text is a valid number
	if !new_text.is_valid_int():
		# Revert to previous valid text
		seed_text.text = Util.string_to_valid_int(new_text)
		seed_text.caret_column = seed_text.text.length()
		


func _on_seed_wrong_timer_timeout() -> void:
	seed_text.placeholder_text = "NUMERIC SEED"
	seed_text.modulate = Color.WHITE

func _on_dice_button_pressed() -> void:
	seed_text.text = str(int(Util.random.randi()/(Util.random.randi() / 6734.0)))

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file(settings_scene)
