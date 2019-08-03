extends Area2D

var bullet = preload("res://scenes/units/bullet.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func shoot(enemy):
	var pos_difference = enemy.get_position() - position
	var angle = atan2(pos_difference.y, pos_difference.x)
	set_rotation(angle + PI / 2)
	var b_instance = bullet.instance()
	b_instance.set_position(get_node("bullet_spawn").get_global_position())
	b_instance.direction = angle
	print(b_instance.position)
	get_parent().add_child(b_instance)