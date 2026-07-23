extends Node2D

class_name InputPrompt
signal end(success: bool)
signal cut_pizza(slice_number: int)

enum Direction {
	up = 1,
	down = 2,
	left = 3,
	right = 4,
	
	OneDirection = 999
}

var _directions: Array[Direction]
var wrap_after: int = 10
@onready var up_arrow: Sprite2D = $UpArrow
@onready var xoffset: float = up_arrow.texture.get_size().x + 4 # 4 is a bit of margin
@onready var yoffset: float = up_arrow.texture.get_size().y + 4 # 4 is a bit of margin

var correct_guesses: int = 0

func init(directions: Array[Direction]):
	_directions = directions
	var x: float = xoffset / 2
	var y: float = yoffset / 2
	var index: int = 0
	for dir in directions:
		var current_dir = Sprite2D.new()
		current_dir.texture = up_arrow.texture
		current_dir.name = "Direction" + str(index)
		match dir:
			Direction.down:
				current_dir.transform = current_dir.transform.rotated(PI)
			Direction.left:
				current_dir.transform = current_dir.transform.rotated(-PI / 2)
			Direction.right:
				current_dir.transform = current_dir.transform.rotated(PI / 2)
				
		add_child(current_dir)
		current_dir.position.x = x
		current_dir.position.y = y
		x += xoffset
		index += 1
		if(index % wrap_after == 0):
			x = xoffset / 2
			y += yoffset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("debug_key_1")):
		var mychild: Sprite2D = get_child(1)
		print(mychild.name)
		var mytween = create_tween()
		mytween.tween_property(mychild, "modulate:a", 0.6, 0.2).set_ease(Tween.EASE_IN_OUT)
	
	var is_dir_pressed: bool = false
	var correct_dir: bool = false
	if(event.is_action_pressed("move_down")):
		is_dir_pressed = true
		if(_directions[correct_guesses] == Direction.down):
			correct_dir = true
	elif(event.is_action_pressed("move_left")):
		is_dir_pressed = true
		if(_directions[correct_guesses] == Direction.left):
			correct_dir = true
	elif(event.is_action_pressed("move_right")):
		is_dir_pressed = true
		if(_directions[correct_guesses] == Direction.right):
			correct_dir = true
	elif(event.is_action_pressed("move_up")):
		is_dir_pressed = true
		if(_directions[correct_guesses] == Direction.up):
			correct_dir = true
	
	if(correct_dir):
		var current_direction: Sprite2D = get_child(correct_guesses + 1)
		var tween = create_tween()
		tween.tween_property(current_direction, "modulate:a", 0.6, 0.2).set_ease(Tween.EASE_IN_OUT)
		correct_guesses += 1
		emit_signal("cut_pizza", correct_guesses)
		if(correct_guesses == len(_directions)):
			emit_signal("end", true)
	elif(is_dir_pressed): emit_signal("end", false)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
