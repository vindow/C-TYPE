extends Node2D

var rng = RandomNumberGenerator.new()
var enemy = preload("res://scenes/units/enemy.tscn")
var bomb = preload("res://scenes/bomb.tscn")

var enemies = []
var wave = 0
var difficulty = 0
var current_z_index = -1
var spawn_counter = 20
var score = 0
var combo = 1
var bomb_count = 3
var bomb_cooldown = 5.0
var num_to_spawn = 9
var increase_spawn_per_wave = 1
var enemy_speed = 50.0
var game_ending = false

signal score_changed(score_amount)
signal combo_changed(combo_amount)
signal wave_changed(wave_number)
signal bomb_changed(bomb_amount)
signal out_of_bombs()


func _ready():
	rng.randomize()
	
func _process(delta):
	bomb_cooldown -= delta
	
	# Ramp up the difficulty depending on the wave
	# TODO: Enemy spawn rate should be increased with difficulty (time between enemy spawns in a wave)
	if wave > 9:
		difficulty = 2
	elif wave > 4:
		difficulty = 1
	
	# Check if spawning for the wave is done
	if spawn_counter >= num_to_spawn:
		get_node("spawn_timer").stop()
		
		var wave_timer = get_node("wave_timer")
		# Check if the wave is completely destroyed
		if enemies.size() == 0 and wave_timer.is_stopped():
			wave += 1
			# More difficulty scaling depending on wave
			if wave % 5 == 0:
				if wave > 5:
					increase_spawn_per_wave += 1
				if wave > 10:
					enemy_speed += 25.0
			num_to_spawn += increase_spawn_per_wave
			emit_signal("wave_changed", wave, increase_spawn_per_wave)
			wave_timer.start()
		

# Spawn a single enemy in a random valid location
func spawn_enemy(difficulty, z_index):
	if not game_ending:
		# Instantiate the enemy and set its position
		var enemy_instance = enemy.instance()
		# Pick a random side of the window to spawn
		var quadrant_to_spawn = rng.randi_range(0, 3)
		match quadrant_to_spawn:
			0:
				enemy_instance.position = Vector2(rng.randi_range(0, 1600), -25)
			1:
				enemy_instance.position = Vector2(1650, rng.randi_range(0, 900))
			2: 
				enemy_instance.position = Vector2(rng.randi_range(0, 1600), 950)
			3:
				enemy_instance.position = Vector2(-50, rng.randi_range(0, 900))
		
		# Generate the random ASCII number to convert into a character for the enemy text
		enemy_instance.ascii_code = generate_ascii(difficulty)
		enemy_instance.set_z_index(z_index)
		enemy_instance.set_velocity(enemy_speed)
		# Add enemy to array to track end of wave
		enemies.append(enemy_instance)
		add_child(enemy_instance)
		spawn_counter +=1


# Generate an ASCII number of a valid character for set difficulty
# Difficulty of 0: a-z and 0-9
# Difficulty of 1: a-z, A-Z, and 0-9
# Difficulty of 2: a-z, A-Z, 0-9, and all symbols
func generate_ascii(difficulty):
	if difficulty == 0:
		var rand_num = rng.randi_range(1, 36)
		if rand_num < 11:
			return rand_num + 47
		else:
			return rand_num + 86
	elif difficulty == 1:
		var rand_num = rng.randi_range(1, 62)
		if rand_num < 11:
			return rand_num + 47
		elif rand_num > 10 and rand_num < 37:
			return rand_num + 54
		else:
			return rand_num + 60
	else:
		return rng.randi_range(33, 126)


# Process player keyboard input
func _input(event):
	if event is InputEventKey and event.pressed and not game_ending:
		# Check for bomb input
		if event.scancode == KEY_SPACE:
			use_bomb()
		else:
			# Convert scancode to ASCII
			var ascii_check = event.scancode
			if event.shift:
				match event.scancode:
					KEY_1, KEY_3, KEY_4, KEY_5:
						ascii_check -= 16
					KEY_2:
						ascii_check = 64
					KEY_6:
						ascii_check = 94
					KEY_7:
						ascii_check = 38
					KEY_8:
						ascii_check = 42
					KEY_9:
						ascii_check = 40
					KEY_0:
						ascii_check = 41
					KEY_QUOTELEFT:
						ascii_check = 126
					KEY_MINUS:
						ascii_check = 95
					KEY_EQUAL:
						ascii_check = 43
					KEY_BACKSLASH:
						ascii_check += 32
					KEY_SEMICOLON:
						ascii_check = 58
					KEY_APOSTROPHE:
						ascii_check = 34
					KEY_COMMA:
						ascii_check = 60
					KEY_PERIOD:
						ascii_check = 62
					KEY_SLASH:
						ascii_check = 63
			else:
				match event.scancode:
					KEY_A, KEY_B, KEY_C, KEY_D, KEY_E, KEY_F, KEY_G, KEY_H, KEY_I, KEY_J, KEY_K, KEY_L, KEY_M, KEY_N, KEY_O, KEY_P, KEY_Q, KEY_R, KEY_S, KEY_T, KEY_U, KEY_V, KEY_W, KEY_X, KEY_Y, KEY_Z:
						ascii_check += 32
					KEY_BRACELEFT, KEY_BRACERIGHT:
						ascii_check -= 32
			# Check if enemy is a valid target for key pressed
			if (ascii_check <= 126):
				var closest_enemy_distance = 2000.0
				var closest_enemy_index = -1
				for i in range(0, enemies.size()):
					# Input has a valid enemy to kill
					if ascii_check == enemies[i].ascii_code: 
						var distance_to_player = enemies[i].get_position().distance_to(get_node("player").get_position())
						# Find the closest valid enemy to shoot
						if distance_to_player < closest_enemy_distance:
							closest_enemy_distance = distance_to_player
							closest_enemy_index = i
				# No valid enemy found for input
				if closest_enemy_index < 0:
					# Penalize player for typo by clearing their combo
					get_node("click").play()
					combo = 1
					emit_signal("combo_changed", combo)
				else:
					get_node("player").shoot(enemies[closest_enemy_index])
					enemies[closest_enemy_index].mark()
					enemies.remove(closest_enemy_index)


# Shake the camera with an intensity between 0 (no shake) and 1 (maximum shake)
func shake_camera(trauma):
	get_node("camera").add_trauma(trauma)
	
	
# Shake the camera but can't shake it as much as non clamped (for when multiple enemies die quickly)
func shake_camera_clamped(trauma):
	get_node("camera").add_clamped_trauma(trauma)


# Activate a bomb
# TODO: This should be refactored into the player class
func use_bomb():
	if bomb_count > 0 and bomb_cooldown <= 0.0 and not game_ending:
		var bomb_instance = bomb.instance()
		bomb_instance.set_position(Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2))
		add_child(bomb_instance)
		bomb_count -= 1
		bomb_cooldown = 5.0
		emit_signal("bomb_changed", bomb_count)
	elif bomb_count > 0 and bomb_cooldown > 0.0:
		# Play a click to notify the player the bomb is still on cooldown
		get_node("click").play()
	elif bomb_count <= 0:
		# Play an error noise to notify the player they are out of bombs
		get_node("error").play()
		emit_signal("out_of_bombs")
		

# Add to the player's score and notify the HUD to update
func add_score(add_combo):
	if add_combo:
		score += 100 * combo * (difficulty + 1)
		combo += 1
		emit_signal("combo_changed", combo)
	else:
		score += 100 * (difficulty + 1)
	emit_signal("score_changed", score)
	

# Remove a specific enemy. Called by the enemy class on death to make sure bomb kills properly remove the enemy
func remove_enemy(enemy):
	for i in range(0, enemies.size()):
		if enemies[i] == enemy:
			enemies.remove(i)
			break

# Begin the animation for the game over text
func game_over():
	# Add a dummy enemy so the last enemy dying while killing the player doesn't display next wave text
	enemies.append(enemy.instance())
	get_node("game_over_timer").start()
	# Stop all current enemies so that they don't continue flying into the center of the screen during the game over
	for i in range(0, enemies.size()):
		enemies[i].velocity = 0
	game_ending = true

# Countdown timer for the next enemy to spawn (staggered spawning)
func _on_spawn_timer_timeout():
	spawn_enemy(difficulty, current_z_index)


# Countdown timer for the next wave
func _on_wave_timer_timeout():
	spawn_counter = 0
	get_node("spawn_timer").start()
	

func _on_game_over_timer_timeout():
	get_node("CanvasLayer/game_over").display(wave, score)
