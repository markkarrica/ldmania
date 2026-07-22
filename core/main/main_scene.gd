extends Node2D
@onready var slot_machine = $SlotMachine
@onready var slot_machine_resource = preload("res://core/slot/slot-machine.tscn")
@onready var timer = $Timers/SlotTimer
var minigames: Array[int] = []
var should_take_slot_input = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
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
	StateMachine.set_minigames(minigames)
	StateMachine.difficulty = 1
	animation_player.play("added_diff")
	
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

func _to_scientific_string(given_num: float, max_len: int) -> String:
	var num
	var extra = 0
	if given_num > 1000000000000000000:
		num = given_num
		extra = 2
	else:
		num = int(given_num)
	var num_str = str(num)
	var n_len = num_str.length()
	if n_len <= max_len:
		return num_str
	var fl = num/pow(10, n_len-1-extra)
	var integer_part = str(int(fl))
	var decimals = str(fl).split(".")[1]
	var exponent = "e%d" % (n_len-1)
	var final_number = "%s . %s %s" % [integer_part, decimals.left(7-2-exponent.length()), exponent]
	final_number = final_number.replace(" ", "")
	return final_number



func _process(_delta: float) -> void:
	# We shouldn't update these every frame because performance, still i don't care
	time_label.text = str(StateMachine.time_left).substr(0,7)
	diff_label.text = str(StateMachine.difficulty).substr(0,7)
	#print(StateMachine.score)
	score_label.text = StateMachine.exp_score
	# We should actually show the scientific notation if the numberis
	# too big but idk how to do it properly yet

func _on_minigame_end(is_success: bool, bonus_time_gained: int):
	StateMachine.current_minigame_index += 1
	if is_success:
		StateMachine.score += StateMachine.difficulty
		animation_player.play("added_score")
		StateMachine.exp_score = str(_to_scientific_string(pow(Util.CONSTANT_E, StateMachine.score)-1, 7))
	if StateMachine.current_minigame_index == Games.GAMES_AMOUNT:
		# Do stuff for next round, then reset index and generate new games order
		
		StateMachine.difficulty += 1
		animation_player.play("added_diff")
		StateMachine.current_minigame_index = 0
		StateMachine.gen_minigames_order()


	_animate_slot_and_load_minigame()

func _input(event: InputEvent) -> void:
	if should_take_slot_input && event.is_action_pressed("interact"):
		slot_machine.stop(StateMachine.shuffled_games[StateMachine.current_minigame_index], 1.5)
		should_take_slot_input = false
