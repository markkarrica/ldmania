extends Control

@export_file("*.tscn") var main_menu_scene: String
@onready var settings: Node = $"/root/Settings"
@onready var music_volume_slider = $Layout/Settings/Audio/MusicVolumeBox/MusicVolumeSlider
@onready var effects_volume_slider = $Layout/Settings/Audio/EffectsVolumeBox/EffectsVolumeSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_effects_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		settings.effects_volume = effects_volume_slider.value



func _on_music_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		settings.music_volume = music_volume_slider.value


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_scene)
