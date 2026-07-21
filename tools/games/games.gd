extends Node

enum GAMES {
	moving_bar,
	hado_pizza,
	select_to_win
}

const GAMES_AMOUNT = 3

func get_packed_scene(game_enum):
	match game_enum:
		GAMES.moving_bar:
			return load("res://minigames/moving_bar/moving_bar.tscn")
		GAMES.hado_pizza:
			return load("res://minigames/hado_pizza/hado_pizza.tscn")
		GAMES.select_to_win:
			return load("res://minigames/select_to_win/select_to_win.tscn")
	
func get_ctx2d(game_enum):
	match game_enum:
		GAMES.moving_bar:
			return load("res://minigames/moving_bar/assets/slot_icon.png")
		GAMES.hado_pizza:
			return load("res://minigames/hado_pizza/assets/slot_icon.png")
		GAMES.select_to_win:
			return load("res://minigames/select_to_win/assets/slot-icon.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
