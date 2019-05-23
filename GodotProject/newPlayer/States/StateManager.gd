extends Node

var state = null

onready var ground = $Ground #fix it later
onready var player = get_parent()

func _ready():
	ground.setup(player)

func _input(event):
	if Input.is_action_just_pressed("launchWeb"):
		var mouse_position = player.get_global_mouse_position()
		