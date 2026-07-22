extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _to_scientific_string(num: int, max_len: int) -> String:
	var num_str = str(num)
	var n_len = num_str.length()
	if n_len <= max_len:
		return num_str
	var fl = num/pow(10, n_len-1)
	print(num)
	var integer_part = str(int(fl))
	var decimals = str(fl).split(".")[1]
	var exponent = "e%d" % (n_len-1)
	var final_number = "%s . %s %s" % [integer_part, decimals.left(7-2-exponent.length()), exponent]
	final_number = final_number.replace(" ", "")
	print(integer_part)
	return final_number

func _on_button_pressed() -> void:
	var score = 36
	print(_to_scientific_string(pow(Util.CONSTANT_E, score), 7))
