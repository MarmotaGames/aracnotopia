extends Area2D

var spawn = Vector2(800, 600)
var gameover = false
var timer = false

func _process(delta):
	if $"/root/Root/Spider".fall:
		if not timer:
			# O tempo desse timer é o tempo máximo de queda
			# Teste
			$Timer.start()
			timer = true
	else:
		$Timer.stop()
		timer = false
		gameover = false
	
	
	if gameover:
		$"/root/Root/Spider".position.x = spawn.x
		$"/root/Root/Spider".position.y = spawn.y
		$"/root/Root/Spider".fall = false
		$"/root/Root/Spider".rotation = 0
		$"/root/Root/Spider".angle = 0

func _on_DeathArea_body_exited(body):
	gameover = true


func _on_Timer_timeout():
	gameover = true
