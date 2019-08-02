extends Area2D

var character = "a"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("character").set_text(character)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
