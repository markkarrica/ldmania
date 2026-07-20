extends Minigame

var pill_speed: float
var is_hovering: bool
var pills_number: int = 2 # Plus the first one
var current_pill_number = 0
var pills_mult: Array[float] = [1.0, 0.9, 0.8]
@onready var pill = $"Bar/Pill"
@onready var pill_area: Area2D = $Cursor/Area2D
@onready var pill_direction = [-1.0,1.0][Util.random.randi_range(0,1)]
@onready var cursor_area = $Cursor/Area2D
@onready var bar_size = $Bar.size[0]
var base_speed: int = 70.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if StateMachine.difficulty == 0:
		StateMachine.difficulty = 1
	pill_speed = StateMachine.log_diff_scale()*base_speed
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pill.position += Vector2(pill_direction * pill_speed*delta, 0)

	

func _physics_process(delta: float) -> void:
	pass


func _on_right_boundry_area_entered(area: Area2D) -> void:
	if area.name == "PillArea":
		pill_direction *= -1


func _on_left_boundry_area_entered(area: Area2D) -> void:
	if area.name == "PillArea":
		pill_direction *= -1

func _input(event):
	if event.is_action_pressed("interact"):
		if cursor_area.has_overlapping_areas():
			if current_pill_number == pills_number:
				minigame_end(true, StateMachine.difficulty)
				return
			current_pill_number += 1
			pill.size[0] *= pills_mult[current_pill_number]
			pill_speed /= pills_mult[current_pill_number]
			pill.position = Vector2(Util.random.randi_range(0, bar_size - pill.size[0]), 0)
			
		else:
			minigame_end(false, 0)
