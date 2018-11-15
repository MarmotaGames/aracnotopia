extends RigidBody2D

onready var webNode
onready var bottomNode
onready var webPinJointNode
onready var stonePinJointNode
onready var web_scene = preload("res://web//Web.tscn")
onready var spiderCollisionNode = $SpiderCollisionShape

export (int) var launchSpeed = 400
export (int) var swingImpulse = 500
export (float) var fallingGravity = 10


var webLength = 1
var movementSpeed = 300
var maxImpulseAngle = 45
var lastWebRotationDegrees = 0

var spiderOnWeb = false
var spiderInArea = true
var spiderIsMoving = false
var spiderIsFalling = false
var spiderIsLaunchingWeb = false
var spiderIsBeingLaunched = false
var failedLaunch = false

var justAttached = false
var justLaunchedWeb = false
var properlyAligned = false

var direction = Vector2(0, -1)
var dirKeys = [0, 0, 0, 0]
#Guarda as teclas direcionais que estao sendo apertadas (1: apertado 0: nao)
#up, down, left, right, nessa ordem

var webInstance
var launchSpeedVector
var target

var pos
var stone
var lengthToTarget
var result
var webInit = false


""" 
******************

  Native Methods

******************
""" 

func _ready():
	if spiderOnWeb:
		loadWebNodes()
		
func _integrate_forces(state):
	repositionSpiderWhenStretchingWeb(state)
		
func _physics_process(delta):
	processInputs()
	
	disableSpiderCollisionIfOnWeb()
	setPhysicsPropertiesWhenAttached()
	
	setCollisionAreaRotationIfFalling()
	setAngularVelocityIfFalling()
	
	applyImpulseWhenBeingLaunched()
	setLinearVelocityWhenBeingLaunched()
	
	updateRotation()
	updateDirection()
	resetPressedDirKeys()
	

""" 
*****************

  Input Methods

*****************
""" 

func processDropFromWebInput():
	webInit = false
	if Input.is_action_just_pressed("dropFromWeb") and canDropFromWeb():
		spiderIsFalling = true
		properlyAligned = false
		spiderIsBeingLaunched = true
		var webAngularVelocity = webNode.angular_velocity
		webLength = webNode.spriteScale.y
		var xSpeedComponent = -webAngularVelocity*cos(webNode.rotation)
		var ySpeedComponent = -abs(webAngularVelocity*sin(webNode.rotation))
		launchSpeedVector = Vector2(xSpeedComponent, ySpeedComponent)
		#The "abs" on the yComponent makes the spider go up even
		#if the web is going down
		
func processAttachOrDetachInput():
	if Input.is_action_just_pressed("attachOrDetachFromArea") and canAttachOrDettach():
		if spiderIsFalling or spiderOnWeb:
			properlyAligned = false
			set_linear_velocity(Vector2(0,0))
			spiderIsFalling = false
			direction.x = 0
			direction.y = -1
			$AnimatedSprite.playing = false
			$StickTimer.start()
			if spiderOnWeb:
				justAttached = true
				spiderOnWeb = false
				webPinJointNode.set_node_b("")
				stonePinJointNode.set_node_b("")
				webNode.queue_free()
		else:
			spiderIsFalling = true
			$StickTimer.start()

func processMovementInput():
	if canWalk():
		if 1 in dirKeys:
			#Verifica se alguma das teclas direcionais está apertada 
			#e processa o movimento
			set_linear_velocity(direction.normalized() * movementSpeed)
			spiderIsMoving = true
		else:
			set_linear_velocity(Vector2(0, 0))
			spiderIsMoving = false
		
func processLaunchWebInput():
	updateRotation()
	if not spiderOnWeb:
		if Input.is_action_pressed("launchWeb"):
			justAttached = false
			justLaunchedWeb = true
			
			if spiderIsLaunchingWeb:
				webNode.stretch("launch")
				$AnimatedSprite.playing = true
				webNode.show()
			else:
				if spiderIsMoving and not spiderIsFalling:
					spiderIsMoving = false
					resetPressedDirKeys()
					set_linear_velocity(Vector2(0,0))
				if not failedLaunch:
					spiderIsLaunchingWeb = true
					webInstance = web_scene.instance()
					get_parent().add_child(webInstance)
					loadWebNodes()
					webNode.hide()
				
					var webPosition = self.global_position
					webNode.set_global_position(webPosition)
					
					webNode.set_gravity_scale(0)
					
					if not webInit:
						target = get_global_mouse_position()
						var space_state = get_world_2d().direct_space_state
						result = space_state.intersect_ray(position,target, [self], collision_mask)
					if result and not webInit:
						pos = result.position
						#stone = result.collider
						#makeWeb(pos,stone)
						webInit = true
				
				
				
				
				
				
				
		elif Input.is_action_just_released("launchWeb"):
			properlyAligned = false
			webInit = false
			if spiderIsLaunchingWeb:
				spiderIsLaunchingWeb = false
				webInstance.queue_free()
			if failedLaunch:
				failedLaunch = false
				
func makeWeb(pos,stone):
	stonePinJointNode = stone.get_child(2)
	webNode.stonePinJointNode = stonePinJointNode
	webNode.positionSprite("down")
	stonePinJointNode.set_global_position(pos)
	

				
func processInputs():
	processLaunchWebInput()
	processAttachOrDetachInput()
	processDropFromWebInput()
	processMovementInput()


""" 
****************************

  Property Control Methods

****************************
""" 

func disableSpiderCollisionIfOnWeb():
	if spiderOnWeb:
		spiderCollisionNode.set_disabled(true)
	else:
		spiderCollisionNode.set_disabled(false)

func matchWebRotationWhenAttaching():
	pass
#	if justAttached:
#		self.rotation_degrees = lastWebRotationDegrees

func setPhysicsPropertiesWhenAttached():
	if isAttached():
		self.gravity_scale = 0
		#set_angular_velocity(0)

func resetPressedDirKeys():
	if spiderIsFalling or spiderIsLaunchingWeb:
		for i in range(0,4):
			dirKeys[i] = 0

func loadWebNodes():
	webNode = get_node("../Web")
	webPinJointNode = get_node("../Web/PinJoint2D")
	bottomNode = get_node("../Web/Sprite/Position2DBottom")

func setCollisionAreaRotationIfFalling():
	if spiderIsFalling:
		$SpiderCollisionShape.rotation_degrees = 90
		$SpiderFallingArea/CollisionShape2D.rotation_degrees = 90
		$AnimatedSprite/SpiderArea/CollisionShape2D.rotation_degrees = 90
		
	elif not spiderOnWeb:
		$SpiderCollisionShape.rotation_degrees = 0
		$SpiderFallingArea/CollisionShape2D.rotation_degrees = 0
		$AnimatedSprite/SpiderArea/CollisionShape2D.rotation_degrees = 0


""" 
*********************

  Transform Methods

*********************
""" 

func setAngularVelocityIfFalling():
	if spiderIsFalling:
		var sinal
		if self.linear_velocity.x > 0:
			sinal = 1
		elif self.linear_velocity.x < 0:
			sinal = -1
		else:
			sinal = 0
		self.set_angular_velocity(5 * sinal)
		self.gravity_scale = fallingGravity
	
func setLinearVelocityWhenBeingLaunched():
	if spiderIsBeingLaunched:
		set_linear_velocity(launchSpeedVector * webLength * launchSpeed)
		spiderIsBeingLaunched = false

func applyImpulseWhenBeingLaunched():
	if spiderOnWeb:
		if dirKeys[2] and abs(self.rotation_degrees) <= maxImpulseAngle:
			webNode.apply_impulse(position,Vector2(-swingImpulse,0))
			#apply_impulse(position,Vector2(-swingImpulse,0))
		if dirKeys[3] and abs(self.rotation_degrees) <= maxImpulseAngle:
			webNode.apply_impulse(position,Vector2(swingImpulse,0))
			#apply_impulse(position,Vector2(swingImpulse,0))
		webNode.stretch("up")
		webNode.stretch("down")

func repositionSpiderWhenStretchingWeb(state):
	if spiderOnWeb:
		loadWebNodes()
		var bottomPosition = bottomNode.get_global_position()
		var xform = state.get_transform()
			
		webPinJointNode.set_node_b("")
		xform.origin = bottomPosition
		state.set_transform(xform)
		webPinJointNode.set_node_b("../../Spider")

func updateRotation():
	if spiderOnWeb:
		self.rotation_degrees = webNode.rotation_degrees
		lastWebRotationDegrees = webNode.rotation_degrees
	
	elif spiderIsLaunchingWeb:
		if not properlyAligned:
			target = get_global_mouse_position()
			properlyAligned = true			
		look_at(target)
		#if not spiderIsFalling:
		self.rotation_degrees += 90
		webInstance.rotation_degrees = self.rotation_degrees

		
	elif not spiderIsFalling and not justLaunchedWeb:
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

	matchWebRotationWhenAttaching()
				 
func updateDirection():
	if not spiderIsLaunchingWeb and not spiderIsFalling:
		if Input.is_action_pressed("ui_up"):
			direction.y = -1
			dirKeys[0] = 1
			if not dirKeys[2] and not dirKeys[3]:
				direction.x = 0
			$AnimatedSprite.playing = true
			justLaunchedWeb = false
			justAttached = false
			
		if Input.is_action_pressed("ui_down"):
			direction.y = 1
			dirKeys[1] = 1
			if not dirKeys[2] and not dirKeys[3]:
				direction.x = 0
			$AnimatedSprite.playing = true
			justLaunchedWeb = false
			justAttached = false
			
		if Input.is_action_pressed("ui_left"):
			direction.x = -1
			dirKeys[2] = 1
			if not dirKeys[0] and not dirKeys[1]:
				direction.y = 0
			$AnimatedSprite.playing = true
			justLaunchedWeb = false
			justAttached = false
			
		if Input.is_action_pressed("ui_right"):
			direction.x = 1
			dirKeys[3] = 1
			if not dirKeys[0] and not dirKeys[1]:
				direction.y = 0
			$AnimatedSprite.playing = true
			justLaunchedWeb = false
			justAttached = false
			
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
		
		if (!Input.is_action_pressed("ui_up") and 
		!Input.is_action_pressed("ui_right") and 
		!Input.is_action_pressed("ui_left") and 
		!Input.is_action_pressed("ui_down")):
			$AnimatedSprite.playing = false


""" 
*****************

  Check Methods

*****************
""" 

func canDropFromWeb():
	return (spiderOnWeb and 
			not spiderIsLaunchingWeb and
			not spiderIsFalling)

func canAttachOrDettach():
	return (spiderInArea and 
			not spiderIsLaunchingWeb and
			not $StickTimer.time_left)

func canWalk():
	return (not spiderIsLaunchingWeb and 
			not spiderIsFalling)

func isAttached():
	return (not spiderIsFalling and 
			not spiderIsLaunchingWeb and 
			not spiderOnWeb)