extends Node2D
@onready var slot_machine = $SlotMachine
@onready var slot_machine_resource = preload("res://core/slot/slot-machine.tscn")
@onready var timer = $Timers/SlotTimer
var minigames: Array[int] = []
var should_take_slot_input = false

@onready var score_label: Label = $Cabinet/ScoreLabel2/ScoreLabelNumber
@onready var time_label: Label = $Cabinet/TimeLabel/TimeLabelNumber
@onready var diff_label: Label = $Cabinet/DiffLabel/DiffLabelNumber

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
	for i in range(Games.GAMES_AMOUNT):
		minigames.append(i)
	print(minigames)
	StateMachine.set_minigames(minigames)
	StateMachine.difficulty = 1
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
	
	
	var current_minigame: Minigame = Games.get_packed_scene(StateMachine.shuffled_games[StateMachine.current_minigame_index]).instantiate()
	current_minigame.on_minigame_end.connect(_on_minigame_end)
	add_child(current_minigame)
	move_child(current_minigame, 1)
	current_minigame.position.x = 64
	current_minigame.position.y = 24



func _process(_delta: float) -> void:
	print(StateMachine.current_minigame_index)
	# We shouldn't update these every frame because performance, still i don't care
	time_label.text = str(StateMachine.time_left).substr(0,7)
	diff_label.text = str(StateMachine.difficulty).substr(0,7)
	score_label.text = str(StateMachine.score).substr(0,7)
	# We should actually show the scientific notation if the numberis
	# too big but idk how to do it properly yet
	var exp_score_str = String.num_scientific(pow(Util.CONSTANT_E, 15))

func _on_minigame_end(is_success: bool, bonus_time_gained: int):
	StateMachine.current_minigame_index += 1
	if is_success:
		StateMachine.score += StateMachine.difficulty
	if StateMachine.current_minigame_index == Games.GAMES_AMOUNT:
		# Do stuff for next round, then reset index and generate new games order
		
		StateMachine.difficulty += 1
		StateMachine.current_minigame_index = 0
		StateMachine.gen_minigames_order()


	_animate_slot_and_load_minigame()

func _input(event: InputEvent) -> void:
	if should_take_slot_input && event.is_action_pressed("interact"):
		slot_machine.stop(StateMachine.shuffled_games[StateMachine.current_minigame_index], 1.5)
		should_take_slot_input = false
