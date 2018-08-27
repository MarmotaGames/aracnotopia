extends Area2D

var spiderInArea = false
var velocity = Vector2()

func _physics_process(delta):
	if get_overlapping_areas():
		spiderInArea = true
		#print(get_overlapping_bodies())
	else:
		spiderInArea = false

func _on_Area2D_body_exited(body):
	body.fall = true
	if body.position.y > 700:
		body.fall = false