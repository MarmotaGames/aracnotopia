extends Area2D


var velocity = Vector2()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_Area2D_body_exited(body):
	body.fall = true
	if body.position.y > 700:
		body.fall = false