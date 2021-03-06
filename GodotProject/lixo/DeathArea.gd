extends Area2D

onready var spiderNode = get_node("/root/Player")

export (Vector2) var spawn = Vector2(1900, 950)
var gameover = false
var timer = false

func _process(delta):
	if spiderNode.spiderIsFalling:
		if not timer:
			# O tempo desse timer é o tempo máximo de queda
			$Timer.start()
			timer = true
	else:
		$Timer.stop()
		timer = false
		gameover = false
	
	if gameover:
		spiderNode.position.x = spawn.x
		spiderNode.position.y = spawn.y
		spiderNode.spiderIsFalling = false
		spiderNode.rotation = 0
		spiderNode.properlyAligned = 0

func _on_Timer_timeout():
	gameover = true

func _on_DeathArea_area_exited(area):
	if area.name == "SpiderArea":
		gameover=true
