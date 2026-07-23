extends Node

var override_seed = 0
@onready var random = RandomNumberGenerator.new()

const CONSTANT_E = 2.718281828459045
func _ready() -> void:
	random.randomize()
	if override_seed != 0:
		random.set_seed(override_seed)

func to_scientific_string(given_num: float, max_len: int) -> String:
	var num
	var extra = 0
	if given_num > 1000000000000000000:
		num = given_num
		extra = 2
	else:
		num = int(given_num)
	var num_str = str(num)
	var n_len = num_str.length()
	if n_len <= max_len:
		return num_str
	var fl = num/pow(10, n_len-1-extra)
	var integer_part = str(int(fl))
	var decimals = str(fl).split(".")[1]
	var exponent = "e%d" % (n_len-1)
	var final_number = "%s . %s %s" % [integer_part, decimals.left(7-2-exponent.length()), exponent]
	final_number = final_number.replace(" ", "")
	return final_number

func deterministic_shuffle(array: Array, custom_rng: RandomNumberGenerator = random) -> Array:
	# Loop backwards through the array
	var shuffled_array = array.duplicate()
	for i in range(shuffled_array.size() - 1, 0, -1):
		# Pick a random index from 0 to i using YOUR specific RNG
		var j = custom_rng.randi_range(0, i)
		
		# Swap the elements at i and j
		var temp = shuffled_array[i]
		shuffled_array[i] = shuffled_array[j]
		shuffled_array[j] = temp
	return shuffled_array

## Takes in a string and returns only chars matching from 0..9, for example "12df43." -> "1243"
func string_to_valid_int(string: String) -> String:
	if string.is_valid_int():
		return string
	var new_string = "" 
	for character in string:
		if character.is_valid_int():
				new_string += character
	
	return new_string
	
	
