extends Position2D
var ready
var x = "x"
var y = "y"

func _ready():
	ready = 1

func _process(delta):
	if ready:
		self.position.x = get_node("../Player").position.x
		self.position.y = get_node("../Player").position.y - 50
		
		var up = str(get_node("../Line2D").webAngle)
		#	var up = str(get_node("../Spider").angular_velocity)
		#	var down = str(get_node("../Spider").dirKeys[1])
		#	var left = str(get_node("../Spider").dirKeys[2])
		#	var right = str(get_node("../Spider").dirKeys[3])
		
		
		get_node("Label_up").set_text(up)
		#	get_node("Label_down").set_text(y)
		#	get_node("Label_left").set_text(left)
		#	get_node("Label_right").set_text(right)

	

