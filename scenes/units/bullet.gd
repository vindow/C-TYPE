extends Area2D

export var velocity = 500.0
var direction = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("bullet_tumble")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction_vector = Vector2(cos(direction), sin(direction)).normalized()
	position += velocity * direction_vector * delta
