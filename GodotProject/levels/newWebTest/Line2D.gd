extends Line2D
var webAngle = 0
func _ready():
	#Only for the test scene
	#Spider spawns connected to first stone
	self.points[1] = get_node("../Stone").get_global_position()	

func _process(delta):
	#Point 0 of the web is always the center of the spider
	self.points[0] = get_node("../Player").get_global_position()	
	webAngle = self.points[0].angle_to_point(self.points[1]) #var for calculating launch stuff
	#print(webAngle)
