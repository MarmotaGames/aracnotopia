extends KinematicBody2D

var speed = 300
var direction = Vector2(0,0)
var angle = 0
var fall = false
var velocity = Vector2(0, 250)
var gravity = 300
var front = 0
var back = 180
var step = 1
var rotationSpeed = 15
var mustRotate = false 
var isRotating = false

func _physics_process(delta):
	direction = Vector2(0,0)
	
	update_direction()
	if mustRotate:
		getRotation()
		mustRotate = false
	evalRotation()

		
	if front < (angle-5) or front > (angle+5):
		isRotating = true
		$AnimatedSprite.rotation_degrees += (step * rotationSpeed)
		$AnimatedSprite.playing = true
	else:
		$AnimatedSprite.rotation_degrees = angle
		isRotating = false
	move_and_slide(direction*speed)
	
	if fall:
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity, Vector2(0, -1))
		
func update_direction():
	if Input.is_action_pressed("ui_up") and not fall:
		direction.y -= 1
		mustRotate = true
		$AnimatedSprite.playing = true
		
	if Input.is_action_pressed("ui_down") and not fall:
		direction.y += 1
		mustRotate = true
		$AnimatedSprite.playing = true
	
	if Input.is_action_pressed("ui_left") and not fall:
		direction.x -= 1
		mustRotate = true
		$AnimatedSprite.playing = true
	
	if Input.is_action_pressed("ui_right") and not fall:
		direction.x += 1
		mustRotate = true
		$AnimatedSprite.playing = true
		
	if !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down") and !isRotating:
		$AnimatedSprite.playing = false
		
	if Input.is_action_pressed("ui_accept") and fall:
		if $"/root/BackgroundSprite/Area2D".spiderInArea == true:
			fall = false

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
	front = int($AnimatedSprite.rotation_degrees)%360
	back = (front+180)%360

	if front < 180:
		if angle <= back and angle > front:
			step = 1
		else:
			step = -1
	else:
		if angle >= back and angle < front:
			step = -1
		else:
			step = 1
	
	if $AnimatedSprite.rotation_degrees == 0 and step == -1:
		$AnimatedSprite.rotation_degrees = 360
		
