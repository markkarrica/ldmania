extends Node2D

@export var minigames: Array[PackedScene]
@onready var state_machine = $"/root/StateMachine"
@onready var label = $Wheel/NextGame
@onready var start_label = $Wheel/PressSpace
@onready var subviewport = $Minigame/Control/MarginContainer/SubViewportContainer/SubViewport
"res://scene.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.set_minigames(minigames)
	state_machine.reset_state()
	state_machine.gen_minigames_order()
	
	label.visible = true
	label.max_lines_visible = 17
	var label_tween = create_tween()
	label_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)\
	.tween_property(label, "visible_characters", 35, 1.5)
	
	label_tween.tween_callback(_wheel_tween_over)
	

func _wheel_tween_over():
	label.visible = false
	label.visible_characters = 17
	
	start_label.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") && start_label.visible:
		start_label.visible = false
		var next_game = state_machine.get_current_minigame_if_available()
		print(next_game)
		if next_game == null:
			print("We done")
			 # We are done with the minigames, we finished a round
			pass
		else:
			print("We back")
			var child: Minigame = next_game.instantiate()
			
			child.load(1)
			child.on_minigame_end.connect(print)
			
			subviewport.add_child(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
