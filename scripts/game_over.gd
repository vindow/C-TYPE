extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/score").text = "Score: " + String(get_node("/root/global").final_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func display():
	set_visible(true)
	get_node("AnimationPlayer").play("game_over")


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/level.tscn")
