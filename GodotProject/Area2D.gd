extends Area2D

var spiderInArea = false
var velocity = Vector2()
var init = true
#var array = [0, 0, 0]
var index = 0

func _physics_process(delta):
	
	var array = [0, 0, 0, 0, 0]
	var index = 0
	for x in get_overlapping_areas():
		if x.name == "DetectBranch":
			array[index] = 5
		if x.name == "FrontArea":
			array[index] = 1
		if x.name == "RightArea":
			array[index] = 2
		if x.name == "LeftArea":
			array[index] = 3
		if x.name == "BackArea":
			array[index] = 4
		index += 1
	if 1 in array:
		$"/root/Root/Spider".fora = false
	else:
		$"/root/Root/Spider".fora = true
		
	if 2 in array:
		$"/root/Root/Spider".foraRight = false
	else:
		$"/root/Root/Spider".foraRight = true
		
	if 3 in array:
		$"/root/Root/Spider".foraLeft = false
	else:
		$"/root/Root/Spider".foraLeft = true
		
	if 4 in array:
		$"/root/Root/Spider".foraBack = false
	else:
		$"/root/Root/Spider".foraBack = true
		
	if 5 in array:
		spiderInArea = true
		if init: #Semi-gambiarra. Precisa inicializar como falso
			$"/root/Root/Spider".fall = false
			init = false
	else:
		spiderInArea = false
		$"/root/Root/Spider".fall = true
		$"/root/Root/Spider".direction = Vector2(0, 1)