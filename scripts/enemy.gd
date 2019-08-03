extends Area2D

export var velocity = 50.0
var ascii_code = 65
var dying = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var character = PoolByteArray([ascii_code]).get_string_from_ascii()
	get_node("character").set_text(character)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not dying:
		var pos_difference = get_parent().get_node("player").get_position() - position
		position += velocity * pos_difference.normalized() * delta
		get_node("Sprite").rotation = atan2(pos_difference.y, pos_difference.x) + PI / 2


# Changes the enemy text to red to indicate they are marked for death
func mark():
	get_node("character").add_color_override("font_color", Color("ff5050"))
	set_z_index(-10)
	
	
func kill():
	dying = true
	get_node("bullet_impact").play()
	get_node("death_timer").start()
	
	if randi() % 2 == 0:
		get_node("explosion1").rotation = rand_range(0, 2 * PI)
		get_node("AnimationPlayer").play("explode1")
	else:
		get_node("explosion2").rotation = rand_range(0, 2 * PI)
		get_node("AnimationPlayer").play("explode2")
	get_parent().remove_enemy(get_node("."))


func _on_enemy_area_entered(area):
	if area.has_method("die"):
		area.die()
		kill()


func _on_death_timer_timeout():
	queue_free()
