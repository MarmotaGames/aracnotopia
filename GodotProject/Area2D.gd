extends Area2D

var spiderInArea = false
var velocity = Vector2()
var init = true
var array = [0, 0]
var index = 0

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
	
	var array = [0, 0]
	var index = 0
	for x in get_overlapping_areas():
		if x.name == "FrontArea":
			array[index] = 1
		index += 1
	if 1 in array:
		$"/root/Root/Spider".fora = false
	else:
		$"/root/Root/Spider".fora = true