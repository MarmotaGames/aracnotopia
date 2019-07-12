extends KinematicBody2D

var flyingSpeed = Vector2(0,0)
var velocity = Vector2(0,500)
var gravity = Vector2(0,500)
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

#NOVAS VARS
var radius
var center
var radiusOffset = 14
var maxLength = 800
var minLength = 60
var web_step = 5

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
			#get_node("../Node2D").shouldCreate = true
			#get_node("../Node2D").center = result.position
			center = result.position
			attach()


func _physics_process(delta):
	processAttachOrDetachInput()
	processDropFromWebInput()
	processLaunchWebInput()
	updateSpeed()

	#start of the old code(spider movement)
	if not spiderOnWeb:
		direction = Vector2(0,0)
		rotateSpider()

	move_and_collide(velocity)
	#print(get_node("../Line2D").webAngle)

	get_node("Camera2D").align()


# seta a direction dependendo do input
# tb seta a dirKeys que eh usada na 
# movimentacao da spider
func updateSpeed():
	if Input.is_action_pressed("ui_up"): 
		dirKeys[0] = 1
		if not spiderIsFalling:
			direction.y = -1
			if not dirKeys[2] and not dirKeys[3]:
				direction.x = 0
			#$AnimatedSprite.playing = true
		if spiderOnWeb and radius > minLength:
			radius -= web_step
		
	if Input.is_action_pressed("ui_down"): 
		dirKeys[1] = 1
		if not spiderIsFalling:
			direction.y = 1
			if not dirKeys[2] and not dirKeys[3]:
				direction.x = 0
			#$AnimatedSprite.playing = true
		if spiderOnWeb and radius < maxLength:
			radius += web_step
	
	if Input.is_action_pressed("ui_left"): 
		dirKeys[2] = 1
		if not spiderIsFalling:
			direction.x = -1
			
			if not dirKeys[0] and not dirKeys[1]:
				direction.y = 0
			#$AnimatedSprite.playing = true
		if spiderOnWeb:
			#Dar impulso
			pass
	
	if Input.is_action_pressed("ui_right"):
		dirKeys[3] = 1
		if not spiderIsFalling:
			direction.x = 1
			if not dirKeys[0] and not dirKeys[1]:
				direction.y = 0
			#$AnimatedSprite.playing = true
		if spiderOnWeb:
			#Dar impulso
			pass
		
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
		
	if 1 in dirKeys and not spiderIsFalling:
		velocity = direction.normalized()*speed
		
	if spiderOnWeb:
		velocity = gravity * -1 * cos(get_node("../Line2D").webAngle)

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
		spiderIsFalling = true

func calculateInstantSpeedVector():
	var x = get_node("../Line2D").points[0]
	var y = get_node("../Line2D").points[1]

	var lineVector = x-y
	return lineVector.tangent()
		
func attach():
	get_node("../Line2D").points[1] = center
	radius = center.distance_to(self.get_global_position()) + radiusOffset
	get_node("../Line2D").show() #the Line2D exhists at all times, but is only shown when needed
	spiderOnWeb = true
	spiderIsFalling = false
	rotation_degrees = 0