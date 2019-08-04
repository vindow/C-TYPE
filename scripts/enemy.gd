extends Area2D

export var velocity = 50.0
var ascii_code = 65
var dying = false
var explosion_timer


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var character = PoolByteArray([ascii_code]).get_string_from_ascii()
	get_node("character").set_text(character)
	get_node("AnimationPlayer").play("thruster")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity < 50.0:
		get_node("Sprite/thruster").set_visible(false)
	if not dying:
		var pos_difference = get_parent().get_node("player").get_position() - position
		position += velocity * pos_difference.normalized() * delta
		get_node("Sprite").rotation = atan2(pos_difference.y, pos_difference.x) + PI / 2


# Changes the enemy text to red to indicate they are marked for death
func mark():
	get_node("character").add_color_override("font_color", Color("ff5050"))
	set_z_index(-10)
	
	
func set_velocity(v):
	velocity = v
	
func kill():
	velocity = 5.0
	dying = true
	#get_node("bullet_impact").play()
	get_node("death_timer").start()
	
	explosion_timer = Timer.new()
	explosion_timer.one_shot = true
	explosion_timer.connect("timeout", self, "_on_explosion_timer_timeout")
	add_child(explosion_timer)
	
	if randi() % 2 == 0:
		get_node("explosion1").rotation = rand_range(0, 2 * PI)
		get_node("AnimationPlayer").play("explode1")
		explosion_timer.set_wait_time(0.26)
	else:
		get_node("explosion2").rotation = rand_range(0, 2 * PI)
		get_node("AnimationPlayer").play("explode2")
		explosion_timer.set_wait_time(0.38)
	get_parent().remove_enemy(get_node("."))
	
	explosion_timer.start()

func kill_no_sound():
	velocity = 5.0
	dying = true
	get_node("death_timer").start()
	
	explosion_timer = Timer.new()
	explosion_timer.one_shot = true
	explosion_timer.connect("timeout", self, "_on_explosion_timer_timeout")
	add_child(explosion_timer)
	
	if randi() % 2 == 0:
		get_node("explosion1").rotation = rand_range(0, 2 * PI)
		get_node("AnimationPlayer").play("explode1_no_sound")
		explosion_timer.set_wait_time(0.26)
	else:
		get_node("explosion2").rotation = rand_range(0, 2 * PI)
		get_node("AnimationPlayer").play("explode2_no_sound")
		explosion_timer.set_wait_time(0.38)
	get_parent().remove_enemy(get_node("."))
	
	explosion_timer.start()

func _on_enemy_area_entered(area):
	if area.has_method("die"):
		if not area.dying:
			kill()
			area.die()


func _on_death_timer_timeout():
	queue_free()
	

func _on_explosion_timer_timeout():
	get_parent().shake_camera_clamped(0.35)
