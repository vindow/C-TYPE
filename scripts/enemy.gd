extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
	
func set_char(character):
	var character_label = get_parent().get_node("character")
	character_label.set_text(character)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
