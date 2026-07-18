extends Node

var override_seed = 123456
@onready var random = RandomNumberGenerator.new()

func _ready() -> void:
	if override_seed != null:
		random.set_seed(override_seed)

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
