extends Area2D

export var velocity = 50.0
var ascii_code = 65

# Called when the node enters the scene tree for the first time.
func _ready():
	var character = PoolByteArray([ascii_code]).get_string_from_ascii()
	get_node("character").set_text(character)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos_difference = get_parent().get_node("player").get_position() - position
	position += velocity * pos_difference.normalized() * delta

# Changes the enemy text to red to indicate they are marked for death
func mark():
	get_node("character").add_color_override("font_color", Color("ff5050"))
	set_z_index(-10)
	
func kill():
	#TODO: Play death animation, queue up for deletion
	get_parent().remove_enemy(get_node("."))
	queue_free()

func _on_enemy_area_entered(area):
	if area.has_method("die"):
		area.die()
		kill()
