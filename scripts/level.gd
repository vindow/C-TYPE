extends Node2D

var rng = RandomNumberGenerator.new()
var enemy = preload("res://scenes/units/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_spawn_timer_timeout():
	# Instantiate the enemy and set its position
	var enemy_instance = enemy.instance()
	enemy_instance.position.y = rng.randi_range(25, 875)
	enemy_instance.position.x = rng.randi_range(25, 1175)
	
	# Generate the random ASCII number to convert into a character for the enemy text
	var character = PoolByteArray([rng.randi_range(33, 126)]).get_string_from_ascii()
	enemy_instance.set_char(character)
	