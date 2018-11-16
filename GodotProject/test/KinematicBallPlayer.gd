extends KinematicBody2D

var x_speed = Vector2(0,0)
var gravity = Vector2(0,500)
var ballSpeed = 900
	
func _physics_process(delta):
	if get_node("../Line2D").webAngle > 0.7 and get_node("../Line2D").webAngle  <2.3:
		if Input.is_action_pressed("ui_right"):
			x_speed=Vector2(ballSpeed,0)
		if Input.is_action_pressed("ui_left"):
			x_speed=Vector2(-ballSpeed,0)
	if Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
		x_speed=Vector2(0,0)
		
#	if Input.is_action_pressed("ui_down"):
#		get_node("../Node2D").radius += get_node("../Node2D").web_step
#		get_node("../Node2D").reposition()
#	if Input.is_action_pressed("ui_up"):
#		get_node("../Node2D").radius -= get_node("../Node2D").web_step
#		get_node("../Node2D").reposition()
	
	move_and_slide(x_speed+gravity)
		
