extends Area2D

var bullet = preload("res://scenes/units/bullet.tscn")
var dying = false;
var explosion_timers = []


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize some timers for the screen shake timing on player death
	# Loop variables are the wait times for the timers
	for i in [0.02, 0.22, 0.42, 0.72, 1.6]:
		var explosion_timer = Timer.new()
		explosion_timer.one_shot = true
		explosion_timer.connect("timeout", self, "_on_explosion_timer_timeout")
		add_child(explosion_timer)
		explosion_timer.set_wait_time(i)
		explosion_timers.append(explosion_timer)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Shoot a bullet at a specific enemy node
func shoot(enemy):
	# Disable shooting if player has died
	if not dying:
		# Calculate the angle of travel for the bullet
		var pos_difference = enemy.get_position() - position
		var angle = atan2(pos_difference.y, pos_difference.x)
		set_rotation(angle + PI / 2)
		var b_instance = bullet.instance()
		# Set the bullet position to the empty bullet_spawn node so that it spawns in front of the player ship
		b_instance.set_position(get_node("bullet_spawn").get_global_position())
		b_instance.direction = angle
		b_instance.target_to_kill = enemy
		get_parent().add_child(b_instance)
		get_node("shoot").play()
	
	
# Begin the death animation for the player
func die():
	# Ensure die() doesn't proc again during death animation
	if not dying:
		get_node("AnimationPlayer").play("explode")
		for timer in explosion_timers:
			timer.start()
		dying = true
		get_parent().game_over()
		
		
	
# Called when explosion timers activate to shake the screen
func _on_explosion_timer_timeout():
	get_parent().shake_camera(0.4)