extends Minigame

var difficulty: int = StateMachine.difficulty

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var directions: Array[InputPrompt.Direction] = []
	for i in range(0, difficulty * 3):
		var dir = Util.random.randi_range(1, 4)
		directions.append(dir)
	$InputPrompt.init(directions)

func _cut_pizza(slice_number: int):
	var whole_pizza := PI
	var slices: int = difficulty * 3
	
	var pizza_texture: Texture2D = $Pizza.texture
	var pizza_position: Vector2 = $Pizza.position
	var pizza_radius := pizza_texture.get_height() / 2
	var pizza_x_start := pizza_position.x
	var pizza_y_start := pizza_position.y
	
	var slice := whole_pizza / slices
	var x = cos(slice * slice_number) * pizza_radius
	var y = sin(slice * slice_number) * pizza_radius
	
	var line2D = Line2D.new()
	line2D.width = 1
	line2D.default_color = "#000000"
	line2D.add_point(Vector2(pizza_x_start - x, pizza_y_start - y))
	line2D.add_point(Vector2(pizza_x_start + x, pizza_y_start + y))
	add_child(line2D)

func _on_input_prompt_end(success: bool) -> void:
	minigame_end(success, 10 if success else 0)
