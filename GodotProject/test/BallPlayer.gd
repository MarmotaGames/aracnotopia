extends RigidBody2D
	
func _integrate_forces(state):
	if Input.is_action_pressed("ui_right"):
		#set_linear_velocity(Vector2(500,linear_velocity.y))
		apply_impulse(position,Vector2(20,0))
		
	if Input.is_action_pressed("ui_left"):
		#set_linear_velocity(Vector2(-500,linear_velocity.y))
		apply_impulse(position,Vector2(-20,0))
#	if Input.is_action_just_released("ui_right"):
		#set_linear_velocity(Vector2(0,linear_velocity.y))
		
#	if Input.is_action_just_released("ui_left"):
		#set_linear_velocity(Vector2(0,linear_velocity.y))

func _on_Area2D_body_entered(body):
	print("entrou")


func _on_Area2D_body_exited(body):
	apply_impulse(position, Vector2(-linear_velocity.x,-linear_velocity.y))
