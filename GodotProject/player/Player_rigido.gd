extends RigidBody2D

onready var web_scene = preload("res://web//Web.tscn")
onready var webNode
onready var stonePinJointNode
onready var webPinJointNode
onready var positionNode

var webInstance
var spiderInArea = true
var spiderOnWeb = false
var spiderIsLaunchingWeb = false

var fallInit = true
var fall = false
var init = false

export (int) var speed = 300
var direction = Vector2(0,-1)
var angle = 0
var dirKeys = [0, 0, 0, 0]

func _ready():
	if spiderOnWeb:
		loadWebNodes()
		
	init = true
	
func _integrate_forces(state):
	if spiderOnWeb:
		loadWebNodes()
		var pointPosition = positionNode.get_global_position()
		var xform = state.get_transform()
			
#		if webNode.isStretching:
		webPinJointNode.set_node_b("")
		xform.origin = pointPosition
		state.set_transform(xform)
		webPinJointNode.set_node_b("../../Spider")
	
func _physics_process(delta):
	if fall:
		if fallInit:
			fallInit = false
			self.rotation_degrees = 0 
			set_linear_velocity(Vector2(self.linear_velocity.x,0)) 
		gravity_scale = 8
		
	else:
		gravity_scale = 0
		fallInit = true
	
	update_direction()
	update_rotation()
	
	if not fall:
		if 1 in dirKeys and not fall:
			#Verifica se alguma das teclas direcionais está apertada 
			#e processa o movimento
			set_linear_velocity(direction.normalized()*speed)
		else:
			set_linear_velocity(Vector2(0,0))
	
	if not spiderOnWeb:
		if Input.is_action_pressed("launchWeb"):
			if spiderIsLaunchingWeb:
				webNode.stretch("launch")
				$AnimatedSprite.playing = true
				webNode.show()
				
			else:
				spiderIsLaunchingWeb = true
				
				webInstance = web_scene.instance()
				get_parent().add_child(webInstance)
				loadWebNodes()
				webNode.hide()
					
				webNode.set_gravity_scale(0)
		elif Input.is_action_just_released("launchWeb"):
			spiderIsLaunchingWeb = false
			webInstance.queue_free()
	
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
	
	if not spiderIsLaunchingWeb:
		if !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down") and !fall:
			$AnimatedSprite.playing = false
	
	if Input.is_action_just_pressed("attachOrDetachFromArea") and spiderInArea and not $StickTimer.time_left:
		if fall or spiderOnWeb:
			set_linear_velocity(Vector2(0,0))
			fall = false
			direction.x = 0
			direction.y = -1
			angle = 0
			$AnimatedSprite.playing = false
			$StickTimer.start()
			if spiderOnWeb:
				webNode.isStretching = false
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
#	webNode = get_node("Web")
#	webPinJointNode = get_node("Web/PinJoint2D")
#	positionNode = get_node("Web/Sprite/Position2D")
	
	webNode = get_node("../Web")
	webPinJointNode = get_node("../Web/PinJoint2D")
	positionNode = get_node("../Web/Sprite/Position2D")