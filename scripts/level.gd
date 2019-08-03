extends Node2D

var rng = RandomNumberGenerator.new()
var enemy = preload("res://scenes/units/enemy.tscn")
var enemies = []
var wave = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	
func _process(delta):
	var spawn_timer = get_node("spawn_timer")
	if enemies.size() == 0 and spawn_timer.is_stopped():
		spawn_timer.start()
		
		
# Spawn a wave of enemies, amount varies based on current wave number
func spawn_wave():
	var num_to_spawn = 9 + wave
	var difficulty = 0
	if wave > 9:
		difficulty = 2
		num_to_spawn += wave - 10
	elif wave > 4:
		difficulty = 1
	for i in range (1, num_to_spawn):
		spawn_enemy(difficulty, num_to_spawn - i)
		
		
# Spawn a single enemy in a random valid location
func spawn_enemy(difficulty, z_index):
	# Instantiate the enemy and set its position
	var enemy_instance = enemy.instance()
	# Pick a random side of the window to spawn
	var quadrant_to_spawn = rng.randi_range(0, 3)
	match quadrant_to_spawn:
		0:
			enemy_instance.position = Vector2(rng.randi_range(25, 1575), rng.randi_range(-100, -25))
		1:
			enemy_instance.position = Vector2(rng.randi_range(1625, 1700), rng.randi_range(25, 875))
		2: 
			enemy_instance.position = Vector2(rng.randi_range(25, 1575), rng.randi_range(925, 1000))
		3:
			enemy_instance.position = Vector2(rng.randi_range(-100, -25), rng.randi_range(25, 875))
	
	# Generate the random ASCII number to convert into a character for the enemy text
	enemy_instance.ascii_code = generate_ascii(difficulty)
	enemy_instance.set_z_index(z_index)
	# Add enemy to array to track end of wave
	enemies.append(enemy_instance)
	add_child(enemy_instance)


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
	if event is InputEventKey and event.pressed:
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
		for i in range(0, enemies.size()):
			# TODO: add penalty for typo
			if ascii_check == enemies[i].ascii_code:
				get_node("player").shoot(enemies[i])
				enemies[i].mark()
				enemies.remove(i)
				break


func remove_enemy(enemy):
	for i in range(0, enemies.size()):
		if enemies[i] == enemy:
			enemies.remove(i)
			break


# Countdown timer for the next wave
func _on_spawn_timer_timeout():
	wave += 1
	spawn_wave()