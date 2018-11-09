extends RigidBody2D

onready var web_scene = preload("res://web//Web.tscn")
onready var webNode
onready var spiderCollisionNode = $SpiderCollisionShape
onready var stonePinJointNode
onready var webPinJointNode
onready var bottomNode

var angle
var webInstance
var spiderInArea = true
var spiderOnWeb = false
var spiderIsLaunchingWeb = false
var properlyAligned = false

var fallInit = true
var fall = false
var init = false

export (int) var speed = 300
var direction = Vector2(0,-1)
var moving #verifica se o player está andando nesse momento
var swingImpulse = 400

var dirKeys = [0, 0, 0, 0]
#Guarda as teclas direcionais que estão sendo apertadas (1: apertado 0: não)
#up, down, left, right, nessa ordem

var velocidadeDeLancamento = 500
var lancamento = false
var webAngular

var x = 1
var y = 1
var webLength = 1

func _ready():
	if spiderOnWeb:
		loadWebNodes()
		
	init = true
	
func _integrate_forces(state):
	if spiderOnWeb:
		loadWebNodes()
		var bottomPosition = bottomNode.get_global_position()
		var xform = state.get_transform()
			
		webPinJointNode.set_node_b("")
		xform.origin = bottomPosition
		state.set_transform(xform)
		webPinJointNode.set_node_b("../../Spider")
		
		if dirKeys[2] and abs(self.rotation_degrees) <= 45:
			webNode.apply_impulse(webNode.position,Vector2(-swingImpulse,0))
		if dirKeys[3] and abs(self.rotation_degrees) <= 45:
			webNode.apply_impulse(webNode.position,Vector2(swingImpulse,0))
			
	if lancamento: #calcular velocidade de lançamento
		if y > 0:
			y*=-1 #dark magic
		set_linear_velocity(Vector2(x*-1,y)*webLength*velocidadeDeLancamento)
#		print(linear_velocity.x)
#		print(linear_velocity.y)
#		print("pausa")
		lancamento = false
	
func _physics_process(delta):
	disableCollisionIfOnWeb()
	
	if fall:
		$SpiderCollisionShape.rotation_degrees = 90
		$SpiderFallingArea/CollisionShape2D.rotation_degrees = 90
		
		var sinal 
		if linear_velocity.x > 0:
			sinal = 1
		elif linear_velocity.x < 0:
			sinal = -1
		else:
			sinal = 0
		set_angular_velocity(5*sinal) #determina rodopio da aranha ao cair
		gravity_scale = 16
		
	if fall or spiderIsLaunchingWeb:
		resetInput()
	elif not spiderOnWeb:
		$SpiderCollisionShape.rotation_degrees = 0
		$SpiderFallingArea/CollisionShape2D.rotation_degrees = 0
		
		gravity_scale = 0
		fallInit = true
		set_angular_velocity(0)
		
	update_rotation()
	
	if not spiderIsLaunchingWeb:
		checkAttachOrDettach()
		if not fall:
			update_direction()
			if 1 in dirKeys:
				#Verifica se alguma das teclas direcionais está apertada 
				#e processa o movimento
				set_linear_velocity(direction.normalized()*speed)
				moving = true
			else:
				set_linear_velocity(Vector2(0,0))
				moving = false
	
	if not spiderOnWeb:
		if Input.is_action_pressed("launchWeb"):
			if spiderIsLaunchingWeb:
				webNode.stretch("launch")
				$AnimatedSprite.playing = true
				webNode.show()
			else:
				if moving:
					moving = false
					resetInput()
				set_linear_velocity(Vector2(0,0))
				spiderIsLaunchingWeb = true
				webInstance = web_scene.instance()
				get_parent().add_child(webInstance)
				loadWebNodes()
				webNode.hide()
				var webPosition = self.global_position
				webPosition.y -= 56
				webNode.set_global_position(webPosition)
				
				webNode.set_gravity_scale(0)
		elif Input.is_action_just_released("launchWeb"):
			properlyAligned = false
			if spiderIsLaunchingWeb:
				spiderIsLaunchingWeb = false
				webInstance.queue_free()
	
func update_direction():
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
		dirKeys[0] = 1
		if not dirKeys[2] and not dirKeys[3]:
			direction.x = 0
		$AnimatedSprite.playing = true
		
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
		dirKeys[1] = 1
		if not dirKeys[2] and not dirKeys[3]:
			direction.x = 0
		$AnimatedSprite.playing = true
		
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
		dirKeys[2] = 1
		if not dirKeys[0] and not dirKeys[1]:
			direction.y = 0
		$AnimatedSprite.playing = true
		
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
		dirKeys[3] = 1
		if not dirKeys[0] and not dirKeys[1]:
			direction.y = 0
		$AnimatedSprite.playing = true
	if Input.is_action_pressed("debug"):
		self.rotation = PI	
		
	if Input.is_action_just_released("ui_up"):
		dirKeys[0] = 0
	if Input.is_action_just_released("ui_down"):
		dirKeys[1] = 0
	if Input.is_action_just_released("ui_left"):
		dirKeys[2] = 0
	if Input.is_action_just_released("ui_right"):
		dirKeys[3] = 0
	
	if !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down"):
		$AnimatedSprite.playing = false
		
	if Input.is_action_just_pressed("dropFromWeb"):
		lancamento = true
		webAngular = webNode.angular_velocity
		webLength = webNode.spriteScale.y
		x = webAngular*cos(webNode.rotation)
		y = webAngular*sin(webNode.rotation)
		fall = true	

func checkAttachOrDettach():
	if Input.is_action_just_pressed("attachOrDetachFromArea") and spiderInArea and not $StickTimer.time_left:
		if fall or spiderOnWeb:
			properlyAligned = false
			set_linear_velocity(Vector2(0,0))
			fall = false
			direction.x = 0
			direction.y = -1
			rotation_degrees = 180
			$AnimatedSprite.playing = false
			$StickTimer.start()
			if spiderOnWeb:
				spiderOnWeb = false
				webPinJointNode.set_node_b("")
				stonePinJointNode.set_node_b("")
				webNode.queue_free()
		else:
			fall = true
			$StickTimer.start()
				
func update_rotation():
	if spiderOnWeb:
		if init:
			self.rotation_degrees = webNode.rotation_degrees
		else:
			self.rotation_degrees = 0
	
	elif spiderIsLaunchingWeb:
		if not properlyAligned:
			look_at(get_global_mouse_position())
			self.rotation_degrees += 90
			webInstance.rotation_degrees = self.rotation_degrees
			properlyAligned = true
		else:
			#bloqueia (ignora) a rotação enquanto lança teia
			pass
		
	elif not fall:
		if direction.x == 0:
			if direction.y == -1:
				#angle = 180
				self.rotation_degrees = -179
			if direction.y == 1:
				self.rotation_degrees = 0
	
		if direction.x == 1:
			if direction.y == -1:
				#angle = 225
				self.rotation_degrees = -135
			if direction.y == 0:
				#angle = 270
				self.rotation_degrees = -90
			if direction.y == 1:
				#angle = 315
				self.rotation_degrees = -45
	
		if direction.x == -1:
			if direction.y == -1:
				self.rotation_degrees = 135
			if direction.y == 0:
				self.rotation_degrees = 90
			if direction.y == 1:
				self.rotation_degrees = 45
				 
func loadWebNodes():
	webNode = get_node("../Web")
	webPinJointNode = get_node("../Web/PinJoint2D")
	bottomNode = get_node("../Web/Sprite/Position2DBottom")
	
func resetInput():
	for i in range(0,4):
		dirKeys[i] = 0
		
func disableCollisionIfOnWeb():
	if spiderOnWeb:
		spiderCollisionNode.set_disabled(true)
	else:
		spiderCollisionNode.set_disabled(false)		
	