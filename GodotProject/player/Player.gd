extends KinematicBody2D

var speed = 300
var direction = Vector2(0,0)
var angle = 0
var front = 0
var back = 180
var step = 1
var rotationSpeed = 15
var mustRotate = false 

func _physics_process(delta):
	direction = Vector2(0,0)
	
	update_direction()
	if mustRotate:
		getRotation()
		mustRotate = false
	evalRotation()
		
	if front < (angle-5) or front > (angle+5):
		$SpiderSprite.rotation_degrees += (step * rotationSpeed)
	else:
		$SpiderSprite.rotation_degrees = angle
	move_and_slide(direction*speed)
	
	
		
func update_direction():
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		mustRotate = true
		
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
		mustRotate = true
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		mustRotate = true
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		mustRotate = true


#GRAUS

func getRotation():
	if direction.x == 0:
		if direction.y == -1:
			angle = 180
		if direction.y == 1:
			angle = 0

	if direction.x == 1:
		if direction.y == -1:
			angle = 225
		if direction.y == 0:
			angle = 270
		if direction.y == 1:
			angle = 315

	if direction.x == -1:
		if direction.y == -1:
			angle = 135
		if direction.y == 0:
			angle = 90
		if direction.y == 1:
			angle = 45

func evalRotation():
	front = int($SpiderSprite.rotation_degrees)%360
	back = (front+180)%360

	print("Angulo desejado:", angle, "Angulo atual:", front, "Rotation:", $SpiderSprite.rotation_degrees)

	if front < 180:
		if angle <= back and angle > front:
			step = 1
		else:
			step = -1
			#angle = (360 - angle)%360 * -1
	else:
		if angle >= back and angle < front:
			step = -1
			#angle = (360 - angle)%360 * -1
		else:
			step = 1
	
	if $SpiderSprite.rotation_degrees == 0 and step == -1:
		$SpiderSprite.rotation_degrees = 360

		
