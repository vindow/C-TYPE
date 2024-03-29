extends Area2D

export var velocity = 900.0
var direction = 0
var target_to_kill = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction_vector = Vector2(cos(direction), sin(direction)).normalized()
	position += velocity * direction_vector * delta
	rotation = direction - PI / 2


# Check collision with the enemy. Only checks for the enemy this bullet is initiated to look for in target_to_kill
func _on_bullet_area_entered(area):
	if area == target_to_kill:
		area.kill()
		get_parent().add_score(true)
		queue_free()
