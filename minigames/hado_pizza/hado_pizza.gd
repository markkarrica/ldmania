extends Minigame


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var difficulty: int = StateMachine.difficulty
	var directions: Array[InputPrompt.Direction] = []
	for i in range(0, difficulty):
		var dir = Util.random.randi_range(1, 4)
		directions.append(dir)
	$InputPrompt.init(directions)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	pass
	#if event.is_action_pressed("interact"): #Debug win condition
		#minigame_end(true, StateMachine.difficulty)
	#if event.is_action_pressed("jump"): # Debug loss
		#minigame_end(false, 0)
	


func _on_input_prompt_end(success: bool) -> void:
	minigame_end(success, 10 if success else 0)
