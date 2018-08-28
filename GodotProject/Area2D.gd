extends Area2D

var spiderInArea = false
var velocity = Vector2()
var init = true

func _physics_process(delta):
	if get_overlapping_areas():
		spiderInArea = true
		if init: #Semi-gambiarra. Precisa inicializar como falso
			$"/root/Root/Spider".fall = false
			init = false
	else:
		spiderInArea = false
		$"/root/Root/Spider".fall = true

#func _on_Area2D_body_exited(body):
#	body.fall = true
#	if body.position.y > 700:
#		body.fall = false