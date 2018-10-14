extends Area2D

#var spiderInArea = false
#var init = true
var index = 0
onready var spiderNode = get_node("../../Spider")

func _ready():
#	if init:
	spiderNode.spiderInArea = false
	spiderNode.fall = false
#	init = false
func _physics_process(delta):
	if spiderNode.spiderOnWeb:
		spiderNode.spiderInArea = true
	
	else:
		if get_overlapping_areas():
			spiderNode.spiderInArea = true
#			if init: #Semi-gambiarra. Precisa inicializar como falso
#				spiderNode.fall = false
#				init = false
		else:
			spiderNode.spiderInArea = false
			spiderNode.fall = true

