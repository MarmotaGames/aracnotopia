extends Area2D

var spiderInArea = false
var init = true
var index = 0

func _physics_process(delta):
	
	if get_overlapping_areas():
		spiderInArea = true
		if init: #Semi-gambiarra. Precisa inicializar como falso
			$"/root/Root/Spider2".fall = false
			init = false
	else:
		spiderInArea = false
		$"/root/Root/Spider2".fall = true
		#$"/root/Root/Spider2".direction = Vector2(0, 1)

