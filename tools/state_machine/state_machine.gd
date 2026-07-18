extends Node

var time_left_ms = 0
var debug_code = 999999
var difficulty = 1
var score = 0
var shuffled_games: Array[PackedScene]
@onready var util = $/root/Util
var minigames: Array[PackedScene]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reset_state():
	time_left_ms = 20*1000
	debug_code = 0
	difficulty = 1

func gen_minigames_order():
	shuffled_games = util.deterministic_shuffle(minigames)
	print(util.random.get_seed())
	
func set_minigames(games):
	minigames = games

func _input(event):
	if event.is_action_pressed("debug_key_1"):
		print("Hello")
		gen_minigames_order()

 #Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
