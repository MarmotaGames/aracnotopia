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
var dirKeys = [0, 0, 0, 0]
var fallInit = true
var test = true

func _integrate_forces(state):
	var positionNode = get_node("../Web/Sprite/Position2D")
	var webNode = get_node("../Web")
	var pointPosition = positionNode.get_global_position()
	var xform = state.get_transform()
	
	
	if webNode.isStretching:
#	if test:
		get_node("../Web/PinJoint2D").set_node_b("")
		print("lul")
#		xform.origin.x = 788
#		xform.origin.y = 500
		xform.origin = pointPosition
		print("spider point: ", pointPosition)
#		print(xform.origin)
		state.set_transform(xform)
		get_node("../Web/PinJoint2D").set_node_b("../../Spider")
#		test = false
	
	
func _physics_process(delta):
	if fall:
		if fallInit:
			fallInit = false
		gravity_scale = 8
		self.angle = 0
	else:
		gravity_scale = 0
		fallInit = true
	
	update_direction()
	
	
		
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