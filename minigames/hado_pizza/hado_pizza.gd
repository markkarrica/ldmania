extends Minigame

var actions: Array[String] = ["mode_down", "move left", "move right", "move_up"]
var shuffled_actions: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shuffled_actions = Util.deterministic_shuffle(actions)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"): #Debug win condition
		minigame_end(true, StateMachine.difficulty)
	if event.is_action_pressed("jump"): # Debug loss
		minigame_end(false, 0)
