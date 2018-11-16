extends Line2D
var webAngle = 0
func _ready():
	self.points[1] = get_node("../Stone").get_global_position()	

func _process(delta):
	self.points[0] = get_node("../KinematicBody2D").get_global_position()	
	webAngle = self.points[0].angle_to_point(self.points[1])
	#print(webAngle)


