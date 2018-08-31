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
var web_scene = preload("res://web//web.tscn")
var web_resource = 0
var web_parent = null
var web = null
var bunda_position = Vector2(800, 600-45)
var dirKeys = [0, 0, 0, 0]
var fora = false

func _physics_process(delta):
	if fora and dirKeys[0]:
		speed = 0
	else:
		speed = 300
	
	direction = Vector2(0,0)
	
	update_direction()
	getRotation()
	
	if direction != Vector2(0,0):
		bunda_position.x = self.position.x + direction.x*-50
		bunda_position.y = self.position.y + direction.y*-50
		
	if mustRotate:
		getRotation()
		mustRotate = false
	evalRotation()
	excretWeb(web_parent)
	

	#Esse bloco elimina ambiguidades, pois a direcao Cima pode ser
	#tanto 180 como -180
	if angle == -179:
		if front < -165 or front > 170:
			self.rotation_degrees = -179
			
	#Rotaciona a aranha	
	if front < (angle-5) or front > (angle+5):
		isRotating = true
		self.rotation_degrees += (step * rotationSpeed)
		$AnimatedSprite.playing = true
	else:
		self.rotation_degrees = angle
		isRotating = false
		
	if 1 in dirKeys and not fall:
		#Verifica se alguma das teclas direcionais está apertada e processa o movimento
		move_and_slide(direction.normalized()*speed)
	
	if fall:
		direction.x = 0
		direction.y = 1
		#velocity.y += gravity * delta
		#velocity = move_and_slide(velocity, Vector2(0, -1))
		velocity.y = gravity
		move_and_slide(direction.normalized()*velocity)
		
func update_direction():
	if Input.is_action_pressed("ui_up") and not fall:
		direction.y = -1
		dirKeys[0] = 1
		if not dirKeys[2] and not dirKeys[3]:
			direction.x = 0
		$AnimatedSprite.playing = true
		
	if Input.is_action_pressed("ui_down") and not fall:
		direction.y = 1
		dirKeys[1] = 1
		if not dirKeys[2] and not dirKeys[3]:
			direction.x = 0
		$AnimatedSprite.playing = true
	
	if Input.is_action_pressed("ui_left") and not fall:
		direction.x = -1
		dirKeys[2] = 1
		if not dirKeys[0] and not dirKeys[1]:
			direction.y = 0
		$AnimatedSprite.playing = true
	
	if Input.is_action_pressed("ui_right") and not fall:
		direction.x = 1
		dirKeys[3] = 1
		if not dirKeys[0] and not dirKeys[1]:
			direction.y = 0
		$AnimatedSprite.playing = true
		
	if Input.is_action_just_released("ui_up"):
		dirKeys[0] = 0

	if Input.is_action_just_released("ui_down"):
		dirKeys[1] = 0

	if Input.is_action_just_released("ui_left"):
		dirKeys[2] = 0

	if Input.is_action_just_released("ui_right"):
		dirKeys[3] = 0
		
	if !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down") and !isRotating and !fall:
		$AnimatedSprite.playing = false
		
	if Input.is_action_just_pressed("ui_accept") and not $StickTimer.time_left:
		if fall:
			if $"/root/Root/BackgroundSprite/Area2D".spiderInArea == true:
				fall = false
				direction.x = 0
				direction.y = 1
				angle = 0
				$AnimatedSprite.playing = false
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

func stickWeb():
	web = web_scene.instance()
	web.position = bunda_position
	get_node("/root/Root/").add_child(web)
	
	web_resource += 1
	
	var anchor = get_node("/root/Root/Web/Anchor")
	web_parent = web.addPiece(anchor)
	
func excretWeb(parent):
	if Input.is_action_just_pressed("excret_web"):
		if web_resource == 0:
			stickWeb()
			
		else:
			web_parent = web.addPiece(parent)
			web_resource += 1

