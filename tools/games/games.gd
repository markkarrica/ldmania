extends Node

enum GAMES {
	moving_bar,
	select_to_win,
	hado_pizza
}

func get_packed_scene(game_enum):
	return load("res://minigames/moving_bar/moving_bar.tscn")
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
			return load("res://core/main/assets/border.png")
		GAMES.hado_pizza:
			return load("res://minigames/demo_payline_tokens/demo-token-2.png")
		GAMES.select_to_win:
			return load("res://minigames/demo_payline_tokens/demo-token-3.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
