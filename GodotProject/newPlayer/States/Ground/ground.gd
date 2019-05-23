extends BaseState

var speed = 200
var direction = Vector2(0,0)

func _ready():
	owner.gravity_scale = 0

func _input(event):
	direction = Vector2(0,0)
	if Input.is_action_just_pressed("drop"):
		emit_signal("finished", "drop")
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	if Input.is_action_pressed("ui_right"):
		direction.x = 1

	owner.set_linear_velocity(direction.normalized()*speed)