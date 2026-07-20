extends Node2D

## Nodes
@onready var current_sprite = $SubViewportContainer/SubViewport/CurrentSprite
@onready var next_sprite = $SubViewportContainer/SubViewport/NextSprite
@onready var result_sprite = $SubViewportContainer/SubViewport/ResultSprite

## Token placement stuff
@onready var sprite_height = current_sprite.texture.get_height()
var tokens: Array[CompressedTexture2D]
var tokens_amount: int
var next_token = 2

## Animation stuff
var speed = 0
var tween: Tween
var physics_based = true
var stop_time: float
var should_stop: bool = false

func reset_state() -> void:
	next_token = 2
	current_sprite.visible = true
	next_sprite.visible = true
	result_sprite.visible = false
	current_sprite.texture = tokens[0]
	next_sprite.texture = tokens[1]
	if tween: tween.kill()
	should_stop = false
	physics_based = true
	current_sprite.position.y = 59
	next_sprite.position.y = 0
	result_sprite.position.y = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if tokens.size() == 0:
		tokens = [load("res://minigames/demo_payline_tokens/demo-token-1.png"),
		load("res://minigames/demo_payline_tokens/demo-token-2.png"),
		load("res://minigames/demo_payline_tokens/demo-token-3.png")]
	
	current_sprite.texture = tokens[0]
	next_sprite.texture = tokens[1]
	tokens_amount = tokens.size()
	
func start(regimen_speed: int, base_spin_up_time: float):
		tween = create_tween()
		tween.tween_property(self, "speed", regimen_speed,
		base_spin_up_time+Util.random.randf_range(-0.5, +0.5)).set_trans(Tween.TRANS_CIRC)

func stop_at(target_index: int, set_stop_time: float):
	result_sprite.texture = tokens[target_index]
	stop_time = set_stop_time
	should_stop = true
	

func raise_sprite_increase_token(sprite):
	sprite.position.y = -sprite_height
	sprite.texture = tokens[next_token]
	next_token += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:		
	if physics_based:
		current_sprite.position.y += speed * delta
		next_sprite.position.y += speed * delta
		result_sprite.position.y = next_sprite.position.y
		
		if current_sprite.position.y > sprite_height:
			raise_sprite_increase_token(current_sprite)
		
		if next_sprite.position.y > sprite_height:
			raise_sprite_increase_token(next_sprite)
		
		if next_token > tokens_amount-1:
			next_token = 0
		if not should_stop:
			return
	else:
		current_sprite.position.y = result_sprite.position.y  -59
	
	if next_sprite.texture == result_sprite.texture && next_sprite.position.y == -sprite_height:
		next_sprite.visible = false
		result_sprite.visible = true
		physics_based = false
		if tween: tween.kill()
		
		tween = create_tween()
		tween.tween_property(result_sprite, "position:y", 0, stop_time).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
