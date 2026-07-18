extends Minigame

@onready var state_machine = $"/root/StateMachine"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func load(difficulty: int):
	emit_signal("on_minigame_end", true, difficulty)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
