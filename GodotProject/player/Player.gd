extends KinematicBody2D

var speed = 200
#var lastDirection = Vector2(0,1)
var direction = Vector2(0,0)

func _physics_process(delta):
	direction = Vector2(0,0)
	
	update_direction()
	
	move_and_slide(direction*speed)
	
func update_direction():
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1