extends Control

@export var minigames: Array[PackedScene]
@onready var slot_machine = $SlotMachine

func _ready() -> void:
	StateMachine.set_minigames(minigames)
	StateMachine.gen_minigames_order()
	# We wait for input/animations
	_animate_slot_in()
	
	await slot_machine.animation_finished
	
	_animate_slot_out()
	
	await slot_machine.animation_finished
	
	# Animations over
	_load_next_minigame()
	
func _animate_slot_in():
	var slot_tween = create_tween()
	slot_tween.tween_property(slot_machine, "position:y", 207, 1.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	await slot_tween.finished
	
	slot_machine.start()

func _animate_slot_out():
	var slot_tween = create_tween()
	slot_tween.tween_property(slot_machine, "position:y", 1000, 1.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	await slot_tween.finished
	
	slot_machine.emit_signal("animation_finished")
	slot_machine.reset_state()

func _load_next_minigame():
	var current_minigame_scene: PackedScene = StateMachine.get_current_minigame_if_available()
	
	if current_minigame_scene == null:
		#end of round
		StateMachine.goto_next_round()
		current_minigame_scene = StateMachine.get_current_minigame_if_available()
	
	var current_minigame: Minigame = current_minigame_scene.instantiate()
	current_minigame.on_minigame_end.connect(_on_minigame_end)
	add_child(current_minigame)
	move_child(current_minigame, 1)
	current_minigame.position.x = 254
	current_minigame.position.y = 94
	current_minigame.scale.x = 4
	current_minigame.scale.y = 4


func _on_minigame_end(is_success: bool, bonus_time_gained: int):
	if is_success:
		StateMachine.score += StateMachine.difficulty
		# We wait for input/animations
	_animate_slot_in()
	
	await slot_machine.animation_finished
	
	_animate_slot_out()
	
	await slot_machine.animation_finished
	
	# Animations over
	
	_load_next_minigame()


func _on_slot_machine_animation_over() -> void:
	return
