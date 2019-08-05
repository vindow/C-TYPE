extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Begin playing the game over text
func display(wave, score):
	get_node("VBoxContainer/max_wave").text = "Wave Reached: " + String(wave)
	get_node("VBoxContainer/score").text = "Score: " + String(score)
	set_visible(true)
	get_node("AnimationPlayer").play("game_over")


# Reloads the game
# TODO: Find a way to reload the game without restarting the music
func _on_Button_pressed():
	get_tree().change_scene("res://scenes/level.tscn")
