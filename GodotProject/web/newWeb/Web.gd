extends RigidBody2D

var initialMotionBoolean = true
var stretchAlways = true
var motionVelocity = Vector2(250,0)

func _ready():
	initialMotion(initialMotionBoolean)

func _process(delta):
	if not stretchAlways:
		if Input.is_action_pressed("excret_web"):
			stretchDownwards()
	else:
		stretchDownwards()
		
		
	var jointPosition = $PinJoint2D.get_global_position()
	get_node("../Spider").set_global_position(jointPosition)
#	$Sprite.set_global_position(Vector2(354,161))
#	$CollisionShape2D.set_global_position(Vector2(354,161))
	
func stretchDownwards():
	var stretchSpeed = 2.5
	
	var scale = $Sprite.get_scale()
	scale.y += 0.001*stretchSpeed
	$Sprite.set_scale(scale)
	$CollisionShape2D.set_scale(scale)
	
	var spritePosition = $Sprite.get_global_position()
	spritePosition.y += 0.117*stretchSpeed
	$Sprite.set_global_position(spritePosition)
	$CollisionShape2D.set_global_position(spritePosition)
	
	var jointPosition = $PinJoint2D.get_global_position()
	jointPosition.y += 0.23*stretchSpeed
	$PinJoint2D.set_global_position(jointPosition)
#	jointPosition.y += 50
	get_node("../Spider").set_global_position(jointPosition)
#	get_node("../SpiderDummy").set_global_position(jointPosition)

#	var spiderPosition = jointPosition
#	spiderPosition.y += 5
#	get_node("../Spider").set_global_position(spiderPosition)


func initialMotion(turnedOn):
	if turnedOn:
		self.set_linear_velocity(motionVelocity)
	