extends Area2D

var spawn = Vector2(800, 600)
var gameover = false
var timer = false

func _process(delta):
	if $"/root/Root/Spider2".fall:
		if not timer:
			# O tempo desse timer é o tempo máximo de queda
			$Timer.start()
			timer = true
	else:
		$Timer.stop()
		timer = false
		gameover = false
	
	
	if gameover:
		$"/root/Root/Spider2".position.x = spawn.x
		$"/root/Root/Spider2".position.y = spawn.y
		$"/root/Root/Spider2".fall = false
		$"/root/Root/Spider2".rotation = 0
		$"/root/Root/Spider2".angle = 0
		
func _on_DeathArea_body_exited(body):
	gameover = true


func _on_Timer_timeout():
	gameover = true
