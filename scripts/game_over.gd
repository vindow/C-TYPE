extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func display(wave, score):
	get_node("VBoxContainer/max_wave").text = "Wave Reached: " + String(wave)
	get_node("VBoxContainer/score").text = "Score: " + String(score)
	set_visible(true)
	get_node("AnimationPlayer").play("game_over")


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/level.tscn")
