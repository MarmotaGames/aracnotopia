extends KinematicBody2D

var speed = 200
var direction = Vector2(0,0)
var angle = 0
var spiderAngle = 0
var fall = false
var velocity = Vector2(0, 250)
var gravity = 300

func _physics_process(delta):
	direction = Vector2(0,0)
	
	update_direction()
	
	move_and_slide(direction*speed)
	
	if fall:
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity, Vector2(0, -1))
	
func update_direction():
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		
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
			
 
	spiderAngle = int($SpiderSprite.rotation_degrees)%360
	if spiderAngle < 0:
		spiderAngle += 360
	
	if  spiderAngle != angle:
		var fator = 1
		if angle - spiderAngle < 0 or (angle >= 225 and spiderAngle <= 90):
			fator = -1
			if (0 <= angle and angle < 90) and (spiderAngle > 180):
				fator = 1
		$SpiderSprite.rotation_degrees += 5*fator
