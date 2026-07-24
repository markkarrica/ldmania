extends Node

enum GAMES {
	moving_bar,
	hado_pizza,
	select_to_win,
	color_match
}

const GAMES_AMOUNT = 4

func get_packed_scene(game_enum):
	match game_enum:
		GAMES.moving_bar:
			return load("res://minigames/moving_bar/moving_bar.tscn")
		GAMES.hado_pizza:
			return load("res://minigames/pizza/pizza.tscn")
		GAMES.select_to_win:
			return load("res://minigames/select_to_win/select_to_win.tscn")
		GAMES.color_match:
			return load("res://minigames/color_match/color_match.tscn")
	
func get_ctx2d(game_enum):
	match game_enum:
		GAMES.moving_bar:
			return load("res://minigames/moving_bar/assets/slot_icon.png")
		GAMES.hado_pizza:
			return load("res://minigames/pizza/assets/slot_icon.png")
		GAMES.select_to_win:
			return load("res://minigames/select_to_win/assets/slot-icon.png")
		GAMES.color_match:
			return load("res://minigames/color_match/assets/slot-icon.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
