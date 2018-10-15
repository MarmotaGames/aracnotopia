extends RigidBody2D

var spiderInArea = true
var spiderOnWeb = false

var speed = 300
var direction = Vector2(0,-1)
var angle = 0
var fall = false
var front = 0
var back = 180
var step = 1
#var rotationSpeed = 15
#var mustRotate = true 
#var isRotating = false
var dirKeys = [0, 0, 0, 0]
var fallInit = true

func _physics_process(delta):
	if fall:
		if fallInit:
#			set_linear_velocity(Vector2(0,0))
			fallInit = false
		gravity_scale = 8
#		self.rotation = 5
		self.angle = 0
	else:
		gravity_scale = 0
		fallInit = true
	
	update_direction()
#	getRotation()
		
#	if mustRotate:
#		getRotation()
#		mustRotate = false
#	evalRotation()

#	#Esse bloco elimina ambiguidades, pois a direcao Cima pode ser
#	#tanto 180 como -180
#	if angle == -179:
#		if front < -165 or front > 170:
#			self.rotation_degrees = -179
#
#	#Rotaciona a aranha	
#	if front < (angle-5) or front > (angle+5):
#		isRotating = true
#		self.rotation_degrees += (step * rotationSpeed)
#		$AnimatedSprite.playing = true
#	else:
#		self.rotation_degrees = angle
#		isRotating = false
		
	if 1 in dirKeys and not fall:
		#Verifica se alguma das teclas direcionais está apertada e processa o movimento
		set_linear_velocity(direction.normalized()*speed)
	else:
		if not fall:
			set_linear_velocity(Vector2(0,0))
	
	
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
		
	if !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down") and !fall:
		$AnimatedSprite.playing = false
	
	if spiderInArea and not $StickTimer.time_left and Input.is_action_just_pressed("attachOrDetach"):
			if fall:
				set_linear_velocity(Vector2(0,0))
				fall = false
				direction.x = 0
				direction.y = -1
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