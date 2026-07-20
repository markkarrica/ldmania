extends Node2D

@export var minigames: Array[PackedScene]
@onready var slot_machine = $SlotMachine
@onready var slot_machine_resource = preload("res://core/slot/slot-machine.tscn")
@onready var timer = $Timers/SlotTimer
var should_take_slot_input = false
func _animate_slot_and_load_minigame():
	# We wait for input/animations
	_animate_slot_in()
	timer.start()
	await timer.timeout
	should_take_slot_input = true
	await slot_machine.animation_finished
	
	
	_animate_slot_out()
	
	await slot_machine.animation_finished
	
	# Animations over
	_load_next_minigame()

func _ready() -> void:
	StateMachine.set_minigames(minigames)
	StateMachine.gen_minigames_order()
	_animate_slot_and_load_minigame()

	
func _animate_slot_in():
	if not slot_machine:
		slot_machine = slot_machine_resource.instantiate()
		add_child(slot_machine)
		slot_machine.position.x = 65
		slot_machine.position.y = 200
		slot_machine.scale.x = 1
		slot_machine.scale.y = 1
	var slot_tween = create_tween()
	slot_tween.tween_property(slot_machine, "position:y", 55, 1.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	await slot_tween.finished
	
	slot_machine.start()

func _animate_slot_out():
	var slot_tween = create_tween()
	slot_tween.tween_property(slot_machine, "position:y", 200, 1.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	await slot_tween.finished
	
	
	slot_machine.emit_signal("animation_finished")
	slot_machine.queue_free()

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
	current_minigame.position.x = 64
	current_minigame.position.y = 24


func _on_minigame_end(is_success: bool, bonus_time_gained: int):
	if is_success:
		StateMachine.score += StateMachine.difficulty
		# We wait for input/animations
	_animate_slot_and_load_minigame()

func _input(event: InputEvent) -> void:
	if should_take_slot_input && event.is_action_pressed("interact"):
		slot_machine.stop(1, 1.5)
		should_take_slot_input = false
