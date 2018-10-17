extends Area2D

onready var spiderNode = get_node("../../Spider")

var init = true
var index = 0

func _ready():
	spiderNode.spiderInArea = false
	spiderNode.fall = false
	
func _physics_process(delta):
	if spiderNode.spiderOnWeb:
		init = false
	
	if get_overlapping_areas():
		spiderNode.spiderInArea = true
		if init: #Semi-gambiarra. Precisa inicializar como falso
			spiderNode.fall = false
			init = false
	else:
		spiderNode.spiderInArea = false
		if not spiderNode.spiderOnWeb:
			spiderNode.fall = true

