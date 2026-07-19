extends Control

@export var minigames: Array[PackedScene]

func _ready() -> void:
	StateMachine.set_minigames(minigames)
	StateMachine.gen_minigames_order()
	_load_next_minigame()
	
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
	print("New score is: " + str(StateMachine.score))
	_load_next_minigame()
