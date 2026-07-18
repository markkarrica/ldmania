extends Node2D

@export var minigames: Array[PackedScene]
@onready var state_machine = $"/root/StateMachine"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.set_minigames(minigames)
	state_machine.reset_state()
	state_machine.gen_minigames_order()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
