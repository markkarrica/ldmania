extends Node2D
@onready var slot_machine = $SlotMachine
@onready var slot_machine_resource = preload("res://core/slot/slot-machine.tscn")
@onready var timer = $Timers/SlotTimer
var minigames: Array[int] = []
var should_take_slot_input = false

@export var game_over_scene: PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_time: AnimationPlayer = $AnimationPlayerTime
@onready var score_label: Label = $Cabinet/ScoreLabel2/ScoreLabelNumber
@onready var time_label: Label = $Cabinet/TimeLabel/TimeLabelNumber
@onready var diff_label: Label = $Cabinet/DiffLabel/DiffLabelNumber

@onready var win_player: AudioStreamPlayer = $PlayerWinMinigame
@onready var lose_player: AudioStreamPlayer = $PlayerLoseMinigame
@onready var round_player: AudioStreamPlayer = $PlayerRoundCompleted
@onready var transition_player: AnimationPlayer = $TransitionAnimation

var is_failed = false
const BASE_TIME: float = 100
var counting = false

func _animate_slot_and_load_minigame():
	# We wait for input/animations
	if StateMachine.current_minigame_index == 0:
		# new round
		animation_player.play("new_round")
		await animation_player.animation_finished
		animation_player.play_backwards("new_round")
		await animation_player.animation_finished
		
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
	var vol = float(Settings.effects_volume) / 100
	
	$PlayerLoseMinigame.volume_linear = vol
	$PlayerRoundCompleted.volume_linear = vol
	$PlayerWinMinigame.volume_linear = vol
	
	StateMachine.time_left = BASE_TIME 
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
	counting = true



func _process(delta: float) -> void:
	if counting:
		StateMachine.time_left -= delta
	if StateMachine.time_left <= 0:
		StateMachine.time_left = 0
		transition_player.play("transition")
		await transition_player.animation_finished
		if !is_failed:
			is_failed = true
			get_tree().change_scene_to_packed(game_over_scene)

	# We shouldn't update these every frame because performance, still i don't care
	time_label.text = str(StateMachine.time_left).substr(0,7)
	diff_label.text = str(StateMachine.difficulty).substr(0,7)
	#print(StateMachine.score)
	score_label.text = StateMachine.exp_score
	# We should actually show the scientific notation if the numberis
	# too big but idk how to do it properly yet

func _on_minigame_end(is_success: bool, bonus_time_gained: int):
	counting = false
	StateMachine.current_minigame_index += 1
	if is_success:
		win_player.play()
		StateMachine.score += StateMachine.difficulty
		StateMachine.time_left += bonus_time_gained
		animation_player_time.play("added_time")
		animation_player.play("added_score")
		StateMachine.exp_score = Util.to_scientific_string(pow(Util.CONSTANT_E, StateMachine.score)-1, 7)
	else:
		lose_player.play()
	if StateMachine.current_minigame_index == Games.GAMES_AMOUNT:
		# Do stuff for next round, then reset index and generate new games order
		
		StateMachine.difficulty += 1
		animation_player.play("added_diff")
		StateMachine.current_minigame_index = 0
		StateMachine.gen_minigames_order()
		if is_success:
			await win_player.finished
			round_player.play()
		else:
			await lose_player.finished
			round_player.play()

	_animate_slot_and_load_minigame()

func _input(event: InputEvent) -> void:
	if should_take_slot_input && event.is_action_pressed("interact"):
		slot_machine.stop(StateMachine.shuffled_games[StateMachine.current_minigame_index], 1.5)
		should_take_slot_input = false
	if event.is_action_pressed("debug_key_1"):
		transition_player.play("transition")
		await transition_player.animation_finished
		get_tree().change_scene_to_packed(game_over_scene)
