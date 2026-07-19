extends Minigame

@onready var sm = $"/root/StateMachine"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_win_button_pressed() -> void:
	minigame_end(true, sm.difficulty)

func _on_lose_button_pressed() -> void:
	minigame_end(false, sm.difficulty)
