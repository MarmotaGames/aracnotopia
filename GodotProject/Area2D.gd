extends Area2D

var spiderInArea = false
var velocity = Vector2()
var init = true
#var array = [0, 0, 0]
var index = 0

func _physics_process(delta):
	
	if get_overlapping_areas():
		spiderInArea = true
		$"/root/Root/Spider2".gravity_scale = 0
		if init: #Semi-gambiarra. Precisa inicializar como falso
			$"/root/Root/Spider2".fall = false
			init = false
	else:
		spiderInArea = false
		$"/root/Root/Spider2".fall = true
		#$"/root/Root/Spider2".direction = Vector2(0, 1)
		$"/root/Root/Spider2".gravity_scale = 10
	"""

	for x in get_overlapping_areas():
	
		if x.name == "DetectBranch":


		

			spiderInArea = true
			$"/root/Root/Spider2".gravity_scale = 0
			if init: #Semi-gambiarra. Precisa inicializar como falso
				$"/root/Root/Spider2".fall = false
				init = false
		else:
			spiderInArea = false
			$"/root/Root/Spider2".fall = true
			#$"/root/Root/Spider2".direction = Vector2(0, 1)
			$"/root/Root/Spider2".gravity_scale = 5
	"""