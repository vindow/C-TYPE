extends Control

onready var score = get_node("score")
onready var combo = get_node("combo")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_level_score_changed(score_amount):
	score.text = "SCORE: " + String(score_amount)


func _on_level_combo_changed(combo_amount):
	combo.text = String(combo_amount) + "x COMBO"
