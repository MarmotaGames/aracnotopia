extends KinematicBody2D

var flyingSpeed = Vector2(0,0)
var velocity = Vector2(0,500)
var gravity = 500
var ballSpeed = 5
var remainingSpeed = Vector2(0,0)
var normal = 0
var remainingSpeedStep = 50
var move
var previousAngle = 0.0
var phase
var angle = 0

var spiderOnWeb = true
var spiderInArea = false

#old variables
var speed = 300
var direction = Vector2(0,-1)
var spiderIsFalling = false
var front = 0
var back = 180
var step = 1
var rotationSpeed = 15
var mustRotate = true 
var isRotating = false
var dirKeys = [0, 0, 0, 0]
var grudando = false

func processLaunchWebInput():
	if Input.is_action_just_pressed("launchWeb"):
		var target = get_global_mouse_position()
		
		#Raytrace to check for a valid attach point in the direction of the mouse
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(position,target, [self], collision_mask)
		if result:
			get_node("../Node2D").shouldCreate = true
			get_node("../Node2D").center = result.position

func _physics_process(delta):
	processAttachOrDetachInput()
	processDropFromWebInput()
	processLaunchWebInput()

	move_and_slide(flyingSpeed + velocity)
	move = get_slide_collision(0)
	if move:
		#print(move.collider.rotation)
		normal = move.remainder

	if spiderIsFalling or spiderOnWeb:
		velocity.y = gravity
	else:
		velocity.y = 0

	#start of the old code(spider movement)
	if not spiderOnWeb:
		direction = Vector2(0,0)

		rotateSpider()

		if 1 in dirKeys and not spiderIsFalling:
			#Verifica se alguma das teclas direcionais está apertada e processa o movimento
			move_and_slide(direction.normalized()*speed)


# seta a direction dependendo do input
func update_direction():
	if Input.is_action_pressed("ui_up") and not spiderIsFalling:
		direction.y = -1
		dirKeys[0] = 1
		if not dirKeys[2] and not dirKeys[3]:
			direction.x = 0
		#$AnimatedSprite.playing = true
		
	if Input.is_action_pressed("ui_down") and not spiderIsFalling:
		direction.y = 1
		dirKeys[1] = 1
		if not dirKeys[2] and not dirKeys[3]:
			direction.x = 0
		#$AnimatedSprite.playing = true
	
	if Input.is_action_pressed("ui_left") and not spiderIsFalling:
		direction.x = -1
		dirKeys[2] = 1
		if not dirKeys[0] and not dirKeys[1]:
			direction.y = 0
		#$AnimatedSprite.playing = true
	
	if Input.is_action_pressed("ui_right") and not spiderIsFalling:
		direction.x = 1
		dirKeys[3] = 1
		if not dirKeys[0] and not dirKeys[1]:
			direction.y = 0
		#$AnimatedSprite.playing = true
		
	if Input.is_action_just_released("ui_up"):
		dirKeys[0] = 0

	if Input.is_action_just_released("ui_down"):
		dirKeys[1] = 0

	if Input.is_action_just_released("ui_left"):
		dirKeys[2] = 0

	if Input.is_action_just_released("ui_right"):
		dirKeys[3] = 0
		
	if !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down") and !isRotating and !spiderIsFalling:
		pass
		#$AnimatedSprite.playing = false
	
	if Input.is_action_pressed("secretar"):
		grudando = true

func processAttachOrDetachInput():
	if Input.is_action_just_pressed("attachOrDetachFromArea"):
		if spiderInArea:
			if spiderIsFalling or spiderOnWeb:
				# attach
				spiderIsFalling = false
				direction.x = 0
				direction.y = 1
				angle = 0
				#$AnimatedSprite.playing = false
			else:
				spiderIsFalling = true

# seta o angulo, dependendo da direcao
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

# determina se a aranha deve rodar no sentido
# horario ou anti-horario
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

func rotateSpider():
	update_direction()
	getRotation()

	if mustRotate:
		getRotation()
		mustRotate = false
	evalRotation()

	#Esse bloco elimina ambiguidades, pois a direcao Cima pode ser
	#tanto 180 como -180
	if angle == -179:
		if front < -165 or front > 170:
			self.rotation_degrees = -179
			
	#Rotaciona a aranha	
	if front < (angle-5) or front > (angle+5):
		isRotating = true
		self.rotation_degrees += (step * rotationSpeed)
		#$AnimatedSprite.playing = true
	else:
		self.rotation_degrees = angle
		isRotating = false

func processDropFromWebInput():
	if Input.is_action_just_pressed("dropFromWeb") and spiderOnWeb:
		#LAUNCHING FROM WEB
		calculateDropVelocity()

		#verify in which phase of the pendulum the spider is at
		phase = calculateMotion()
		var launchAngle = move.collider.rotation
		if phase == "leftGoingLeft" or phase == "rightGoingLeft": 
			launchAngle += PI/2
		if phase == "leftGoingRight" or phase == "rightGoingRight": 
			launchAngle -= PI/2

		flyingSpeed = Vector2(cos(launchAngle), sin(launchAngle))*2500
		
		if phase == "still":
			flyingSpeed = (Vector2(0,0))
		#flyingSpeed.y *= -1
		remainingSpeed = flyingSpeed
		spiderOnWeb = false

func calculateDropVelocity():
	previousAngle = angle
	if get_node("../Line2D").webAngle > 0.7 and get_node("../Line2D").webAngle < 2.3:
		if Input.is_action_pressed("ui_right") and spiderOnWeb:
			flyingSpeed=Vector2(ballSpeed*get_node("../Node2D").radius,0)
		if Input.is_action_pressed("ui_left") and spiderOnWeb:
			flyingSpeed=Vector2(-ballSpeed*get_node("../Node2D").radius,0)

	if Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
		remainingSpeed = flyingSpeed
		
	if remainingSpeed != Vector2(0,0):
		if remainingSpeed.x > remainingSpeedStep:
			remainingSpeed.x -= remainingSpeedStep
		elif remainingSpeed.x < -remainingSpeedStep:
			remainingSpeed.x += remainingSpeedStep
		else:
			remainingSpeed.x = 0
			
		if remainingSpeed.y < 0:
			remainingSpeed.y += remainingSpeedStep
		else:
			remainingSpeed.y = 0

		flyingSpeed = remainingSpeed

func calculateMotion():
	#See at which phase of the "pendulum" the spider is
	angle = get_node("../Line2D").webAngle
	
	if abs(angle - previousAngle) < 0.01:
		return("still")

	if angle > previousAngle: #GOING LEFT
		if angle > PI / 2:
			return("leftGoingLeft")

		elif angle < PI / 2:
			return("rightGoingLeft")

		else:
			return("deadBottomGoingLeft")
	else: #GOING RIGHT
		if angle > PI / 2:
			return("leftGoingRight")

		elif angle < PI / 2:
			return("rightGoingRight")

		else:
			return("deadBottomGoingRight")