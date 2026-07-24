extends Minigame

const MAX_PROMPTS_X = 5
const MAX_PROMPTS_Y = 5
const SPACING = 2
@export var min_wrong_nodes: int = 4 # Set your minimum required wrong nodes here
@export var textures: Array[CompressedTexture2D]
@onready var num_prompts = min(MAX_PROMPTS_X*MAX_PROMPTS_Y, max(StateMachine.log_diff_scale(), 2))
@onready var target_texture = textures[Util.random.randi_range(0, textures.size()-1)]
@onready var first_prompt_position = $Grid/Prompt.position
@onready var grid = $Grid
@onready var target_node = $Target
var prompts: Array[ColorMatchPrompt]
# Called when the node enters the scene tree for the first time.
func _on_button_pressed(prompt):
	if prompt.texture_normal == target_texture:
		minigame_end(false, 0)
	
	var current_index = textures.find(prompt.texture_normal)
	var index
	if current_index == textures.size() -1:
		index = 0
	else:
		index = current_index + 1
	
	prompt.texture_normal = textures[index]

func _ready() -> void:
	target_node.texture = target_texture
	for j in range (1, MAX_PROMPTS_Y):
		for i in range(1, MAX_PROMPTS_X):
			var prompt = ColorMatchPrompt.new()
			grid.add_child(prompt)
			prompt.position = first_prompt_position
			prompt.position.x += i*target_texture.get_width() + i* SPACING
			prompt.position.y = j*target_texture.get_height() + j*SPACING
			# TEMP
			prompt.texture_normal = textures[Util.random.randi_range(0, textures.size()-1)]
			prompt.visible = true
			prompt.pressed.connect(_on_button_pressed.bind(prompt))
			prompts.append(prompt)
			if prompts.size() == num_prompts:
				_verify_board()
				return
	
	
	
func _verify_board():
	var wrong_count = 0
	var correct_prompts = []
	
	# 1. Count how many are wrong, and keep track of the ones that are right
	for prompt in prompts:
		if prompt.texture_normal != target_texture:
			wrong_count += 1
		else:
			correct_prompts.append(prompt)
			
	# 2. If we don't have enough wrong nodes, change some correct ones
	while wrong_count < min_wrong_nodes and correct_prompts.size() > 0:
		print("Hello")
		# Pick a random correct prompt and remove it from our temporary list
		var random_index = Util.random.randi_range(0, correct_prompts.size() - 1)
		var prompt_to_change = correct_prompts.pop_at(random_index)
		
		# Give it a random texture that is NOT the target texture
		var new_texture = target_texture
		while new_texture == target_texture:
			new_texture = textures[Util.random.randi_range(0, textures.size() - 1)]
			
		prompt_to_change.texture_normal = new_texture
		wrong_count += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var one_wrong = false
	for prompt in prompts:
		if prompt.texture_normal != target_texture:
			one_wrong = true
	if !one_wrong:
		minigame_end(true, StateMachine.log_diff_scale()*2.5)
