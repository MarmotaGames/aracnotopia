extends KinematicBody2D

var speed = 300
var direction = Vector2(0,-1)
var angle = 0
var fall = false
var velocity = Vector2(0, 250)
var gravity = 600
var front = 0
var back = 180
var step = 1
var rotationSpeed = 15
var mustRotate = true 
var isRotating = false

func _physics_process(delta):
	direction = Vector2(0,0)
	
	update_direction()
	if mustRotate:
		getRotation()
		mustRotate = false
	evalRotation()

	if angle == -179:
		if front < -165 or front > 170:
			self.rotation_degrees = -179	
	if front < (angle-5) or front > (angle+5):
		isRotating = true
		self.rotation_degrees += (step * rotationSpeed)
		$AnimatedSprite.playing = true
	else:
		self.rotation_degrees = angle
		isRotating = false
	move_and_slide(direction*speed)
	
	if fall:
		#velocity.y += gravity * delta
		#velocity = move_and_slide(velocity, Vector2(0, -1))
		velocity.y = gravity
		move_and_slide(velocity, Vector2(0, -1))
		
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
		
	if Input.is_action_just_pressed("ui_accept") and not $StickTimer.time_left:
		if fall:
			if $"/root/Root/BackgroundSprite/Area2D".spiderInArea == true:
				fall = false
				$StickTimer.start()
		else:
			fall = true
			$StickTimer.start()
	

func getRotation():
	if direction.x == 0:
		if direction.y == -1:
			#angle = 180
			angle = -179
		if direction.y == 1:
			angle = 0

	if direction.x == 1:
		if direction.y == -1:
			#angle = 225
			angle = -135
		if direction.y == 0:
			#angle = 270
			angle = -90
		if direction.y == 1:
			#angle = 315
			angle = -45
			

	if direction.x == -1:
		if direction.y == -1:
			angle = 135
		if direction.y == 0:
			angle = 90
		if direction.y == 1:
			angle = 45

func evalRotation():
	front = int(self.rotation_degrees)
	
	var fator
	if front >= 0:
		fator = -1
	else:
		fator = 1
	back = front+(180 * fator)

	if front >= 0:
		if angle > 0:
			if angle < front:
				step = -1
			else:
				step = 1
		else:
			if angle < back:
				step = 1
			else:
				step = -1
	else:
		if angle > 0:
			if angle > back:
				step = -1
			else:
				step = 1
		else:
			if angle < front:
				step = -1
			else:
				step = 1
	
