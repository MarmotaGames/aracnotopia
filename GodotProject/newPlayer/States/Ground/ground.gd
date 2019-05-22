extends BaseState
class_name Ground

var speed = 0
var velocity = Vector2(0,0)

func handle_input(event):
	if event.is_action_just_pressed("drop"):
		emit_signal("finished", "drop")