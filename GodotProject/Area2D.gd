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
		$"/root/Root/Spider".direction = Vector2(0, 1)
	