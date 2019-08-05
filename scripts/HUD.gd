extends Control

onready var score = get_node("score")
onready var combo = get_node("combo")
onready var wave_title = get_node("CenterContainer/wave_number")
onready var wave_subtitle = get_node("CenterContainer2/subtext")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Update the score text with the given input
func _on_level_score_changed(score_amount):
	score.text = "SCORE: " + String(score_amount)


# Update the combo text with the given input
func _on_level_combo_changed(combo_amount):
	combo.text = String(combo_amount) + "x COMBO"


# Update the next wave text and the subtext below
func _on_level_wave_changed(wave_number, increased_spawn_number):
	wave_title.text = "Wave " + String(wave_number)
	if wave_number != 1:
		var subtitle = "+"
		if wave_number > 9:
			subtitle += String(increased_spawn_number) + " Enemies"
		else:
			subtitle += String(1) + " Enemy"
		if wave_number == 5:
			subtitle += ", capital letters now spawn"
		elif wave_number == 10:
			subtitle += ", symbols now spawn"
		elif wave_number > 10 and wave_number % 5 == 0:
			subtitle += ", enemy speed up"
		
		wave_subtitle.text = subtitle
	get_node("AnimationPlayer").play("next_wave")

# Update the bomb count with the given input
func _on_level_bomb_changed(bomb_amount):
	get_node("VBoxContainer/bomb_count").text = "BOMB: " + String(bomb_amount) + "x"
