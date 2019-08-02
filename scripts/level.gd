extends Node2D

var rng = RandomNumberGenerator.new()
var enemy = preload("res://scenes/units/enemy.tscn")
var enemies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func _input(event):
	if event is InputEventKey and event.pressed:
		var ascii_check = event.scancode
		# Convert scancode to ASCII
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
			if ascii_check == enemies[i].ascii_code:
				get_node("player").shoot(enemies[i])
				enemies.remove(i)
				break


func _on_spawn_timer_timeout():
	# Instantiate the enemy and set its position
	var enemy_instance = enemy.instance()
	enemy_instance.position.y = rng.randi_range(25, 875)
	enemy_instance.position.x = rng.randi_range(25, 1175)
	
	# Generate the random ASCII number to convert into a character for the enemy text
	var ascii = rng.randi_range(33, 126)
	enemy_instance.ascii_code = ascii
	enemies.append(enemy_instance)
	add_child(enemy_instance)
	