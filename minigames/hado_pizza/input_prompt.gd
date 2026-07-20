extends Node2D

enum Direction {
	up = 1,
	down = 2,
	left = 3,
	right = 4,
	
	OneDirection = 999
}

var directions: Array[Direction]

func init(directions: Array[Direction]):
	self.directions = directions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for dir in directions:
		print(dir)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
