extends Node

var time_left_ms = 0
var debug_code = 999999
var difficulty = 0
var score = 0
var shuffled_games: Array[PackedScene]
var minigames: Array[PackedScene]
var current_minigame_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func log_diff_scale():
	return log(StateMachine.difficulty +1)

func reset_state():
	time_left_ms = 20*1000
	debug_code = 0
	difficulty = 1

func gen_minigames_order():
	shuffled_games = Util.deterministic_shuffle(minigames)
	print(Util.random.get_seed())
	
func set_minigames(games: Array[PackedScene]):
	minigames = games

func _input(event: InputEvent):
	if event.is_action_pressed("debug_key_1"):
		print("Hello")
		gen_minigames_order()

func get_current_minigame_if_available() -> PackedScene:
	print(current_minigame_index)
	print(shuffled_games.size())
	# we check if we have done all minigames:
	if current_minigame_index == shuffled_games.size():
		return null
	else:
		current_minigame_index += 1
		return shuffled_games[current_minigame_index - 1]

func goto_next_round():
	current_minigame_index = 0
	gen_minigames_order()
	difficulty += 1

 #Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
