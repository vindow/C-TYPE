extends Control

onready var score = get_node("score")
onready var combo = get_node("combo")
onready var wave_title = get_node("CenterContainer/wave_number")
onready var wave_subtitle = get_node("CenterContainer2/subtext")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_level_score_changed(score_amount):
	score.text = "SCORE: " + String(score_amount)


func _on_level_combo_changed(combo_amount):
	combo.text = String(combo_amount) + "x COMBO"


func _on_level_wave_changed(wave_number):
	wave_title.text = "Wave " + String(wave_number)
	if wave_number != 1:
		var subtitle = "+"
		if wave_number > 9:
			subtitle += String(2) + " Enemies"
		else:
			subtitle += String(1) + " Enemy"
		if wave_number == 5:
			subtitle += ", capital letters now spawn"
		if wave_number == 10:
			subtitle += ", symbols now spawn"
		wave_subtitle.text = subtitle
	get_node("AnimationPlayer").play("next_wave")