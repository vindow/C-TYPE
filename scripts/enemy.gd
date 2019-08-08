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
	# Turn off the thruster animation when not moving
	if velocity < 50.0:
		get_node("sprite/thruster").set_visible(false)
	# Move towards the player as long as the enemy is not in a dead/dying state
	if not dying:
		var pos_difference = get_parent().get_node("player").get_position() - position
		position += velocity * pos_difference.normalized() * delta
		get_node("sprite").rotation = atan2(pos_difference.y, pos_difference.x) + PI / 2


# Changes the enemy text to red to indicate they are marked for death
func mark():
	get_node("character").add_color_override("font_color", Color("ff5050"))
	set_z_index(-10)
	
	
func set_velocity(v):
	velocity = v
	
	
# Kills the enemy, but plays the death animation first
func kill():
	velocity = 5.0
	dying = true
	get_node("bullet_impact").play()
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


# Kills the enemy without playing the bullet hit noise (for bomb kills)
func kill_no_sound():
	velocity = 5.0
	dying = true
	get_node("death_timer").start()
	
	explosion_timer = Timer.new()
	explosion_timer.one_shot = true
	explosion_timer.connect("timeout", self, "_on_explosion_timer_timeout")
	add_child(explosion_timer)
	
	# Pick a between the two explosion animations to play
	if randi() % 2 == 0:
		get_node("explosion1").rotation = rand_range(0, 2 * PI)
		get_node("AnimationPlayer").play("explode1")
		explosion_timer.set_wait_time(0.26)
	else:
		get_node("explosion2").rotation = rand_range(0, 2 * PI)
		get_node("AnimationPlayer").play("explode2")
		explosion_timer.set_wait_time(0.38)
	
	# Tell the level to remove the enemy from it's array
	get_parent().remove_enemy(get_node("."))
	explosion_timer.start()

# Checks collisions strictly with the player (bullet collision is in the bullet script)
func _on_enemy_area_entered(area):
	if area.has_method("die"):
		if not area.dying:
			kill()
			area.die()


# Finally remove itself from the game completely when the animation ends
func _on_death_timer_timeout():
	queue_free()
	

# Sync the screen shake to when the explosion actually happens (a little later than impact)
func _on_explosion_timer_timeout():
	get_parent().shake_camera_clamped(0.35)
