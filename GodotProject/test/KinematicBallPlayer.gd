extends KinematicBody2D

var x_speed = Vector2(0,0)
var gravity = Vector2(0,500)
var ballSpeed = 5
var remainingSpeed = Vector2(0,0)
var normal = 0
var remainingSpeedStep = 50
var move
var previousAngle = 0.0
var phase
var angle

var spiderOnWeb = true

func _physics_process(delta):
	phase = calculateMotion()
	previousAngle = angle
	if get_node("../Line2D").webAngle > 0.7 and get_node("../Line2D").webAngle  <2.3:
		if Input.is_action_pressed("ui_right") and spiderOnWeb:
			x_speed=Vector2(ballSpeed*get_node("../Node2D").radius,0)
		if Input.is_action_pressed("ui_left") and spiderOnWeb:
			x_speed=Vector2(-ballSpeed*get_node("../Node2D").radius,0)
	if Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
		remainingSpeed = x_speed
		
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
		x_speed = remainingSpeed
	if Input.is_action_just_pressed("attachOrDetachFromArea") and spiderOnWeb:
		#LAUNCHING FROM WEB
		var launchAngle = move.collider.rotation
		if phase == "leftGoingLeft" or phase == "rightGoingLeft": 
			launchAngle += PI/2
		if phase == "leftGoingRight" or phase == "rightGoingRight": 
			launchAngle -= PI/2

		x_speed = Vector2(cos(launchAngle), sin(launchAngle))*2500
		
		if phase == "still":
			x_speed = (Vector2(0,0))
		#x_speed.y *= -1
		remainingSpeed = x_speed
		spiderOnWeb = false
		
	if Input.is_action_just_pressed("launchWeb"):
		var target = get_global_mouse_position()
		
		#Raytrace to check for a valid attach point in the direction of the mouse
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(position,target, [self], collision_mask)
		if result:
			get_node("../Node2D").shouldCreate = true
			get_node("../Node2D").center = result.position
			spiderOnWeb = true	

	
	move_and_slide(x_speed+gravity)
	move = get_slide_collision(0)
	if move:
		normal = move.remainder
		
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
		
	
		
