extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("explosion")
	get_parent().shake_camera(1)


func _process(delta):
	if not get_node("AnimationPlayer").is_playing():
		queue_free()


func _on_bomb_area_entered(area):
	if area.has_method("kill"):
		area.kill()
		get_parent().add_score(false)


func _on_active_time_timeout():
	get_node("CollisionShape2D").disabled = true
