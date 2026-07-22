extends Node2D

enum Direction {
	up = 1,
	down = 2,
	left = 3,
	right = 4,
	
	OneDirection = 999
}

@export var directions: Array[Direction]
@export var wrap_after: int = 20
@onready var up_arrow: Sprite2D = $UpArrow
@onready var xoffset: float = up_arrow.texture.get_size().x + 4 # 4 is a bit of margin
@onready var yoffset: float = up_arrow.texture.get_size().y + 4 # 4 is a bit of margin

func init(directions: Array[Direction]):
	self.directions = directions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var x: float = xoffset / 2
	var y: float = yoffset / 2
	var index: int = 0
	for dir in directions:
		var current_dir = Sprite2D.new()
		current_dir.texture = up_arrow.texture
		
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
		if(index == wrap_after):
			index = 0
			x = xoffset / 2
			y += yoffset
		print(dir)
		
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("debug_key_1")):
		var mychild: Sprite2D = get_child(2) # then sell it
		print(mychild.name)
		var mytween = create_tween()
		mytween.tween_property(mychild, "modulate:a", 0.6, 0.2).set_ease(Tween.EASE_IN_OUT)
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
