extends Node2D

@onready var regular_scores: Label = $Label/NormalSizedScores
@onready var full_score: Label = $Label/FullScore
@onready var inf_label: Label = $InfLabel
@onready var particle_timer_on: Timer = $ParticlesTimerOn
@onready var particle_timer_off: Timer = $ParticlesTimerOff
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StateMachine.score = 760
	var exp_score = pow(Util.CONSTANT_E, StateMachine.score)-1
	var sci_score = Util.to_scientific_string(exp_score, 7)
	if sci_score != "inf":
		regular_scores.visible = true
		full_score.visible = true
		inf_label.visible = false
		var r_text = regular_scores.text
		regular_scores.text = r_text.replace("YYY", sci_score).replace("XXX", "eXP(%d) -1" % StateMachine.score)
		var f_text = full_score.text
		full_score.text = f_text.replace("XXX", str(exp_score))
		return
	
	particle_timer_on.start(0.1)
	regular_scores.visible = false
	full_score.visible = false
	inf_label.visible = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_particles_timer_timeout() -> void:
	for particle in inf_label.get_children():
		particle.emitting = false
	particle_timer_off.start()


func _on_particles_timer_off_timeout() -> void:
	for particle in inf_label.get_children():
		particle.emitting = true
	particle_timer_on.start()
