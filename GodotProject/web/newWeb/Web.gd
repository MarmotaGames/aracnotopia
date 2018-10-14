extends RigidBody2D

onready var spiderNode = get_node("../Spider")
var initialMotionBoolean = false
var stretchAlways = false
var motionVelocity = Vector2(400,0)
#var stretchSpeed = 3

func _ready():
	initialMotion(initialMotionBoolean)
	spiderNode.spiderOnWeb = true
	
	#testing
#	$PinJoint2D.set_node_b("")
	
func _process(delta):
#	print("Web: ", self.linear_velocity)
#	print("Spider: ", spiderNode.linear_velocity)
#	print("rot: ", self.rotation_degrees)
#	self.rotation_degrees = 45

	if spiderNode.spiderOnWeb:
		if not stretchAlways:
			if Input.is_action_pressed("stretchWeb"):
				stretchDownwards()
		else:
			stretchDownwards()
		
		var jointPosition = $PinJoint2D.get_global_position()
		spiderNode.set_global_position(jointPosition)
	
	if Input.is_action_just_pressed("attachOrDetach") and spiderNode.spiderOnWeb:
		spiderNode.spiderOnWeb = false
		$PinJoint2D.set_node_b("")
		spiderNode.fall = true
		
func stretchDownwards():
	var rot = self.rotation_degrees
	var yPercentage = 1
	var xPercentage = 1
	
	var scale = $Sprite.get_scale()
	scale.y += 0.001*3
	$Sprite.set_scale(scale)
	$CollisionShape2D.set_scale(scale)
	
	var spritePosition = $Sprite.get_global_position()
	var yMagicNumber = (0.116-((abs(rot)/10)*0.0130 - 0.022))*3
	if abs(rot) > 60:
		yPercentage = 0.94
		xPercentage = 0.93
	elif abs(rot) > 30:
		yPercentage = 1
		xPercentage = 0.98
	else:
		yPercentage = 0.85
		xPercentage = 1
		
	print("rot: ", rot)
	spritePosition.y += yMagicNumber*yPercentage
	
	var xMagicNumber = (0.0055-(((abs(rot)/10)*0.0115 - 0.040)/100)*1.3)*rot
	print("xRotValue: ", xMagicNumber)
	spritePosition.x -= xMagicNumber*xPercentage
		
	$Sprite.set_global_position(spritePosition)
	$CollisionShape2D.set_global_position(spritePosition)
	
	
	var jointPosition = $PinJoint2D.get_global_position()
	jointPosition.y += 0.20*3
	
	jointPosition.x += 0.012*abs(rot)*xPercentage
	
	$PinJoint2D.set_global_position(jointPosition)
	spiderNode.set_global_position(jointPosition)


func initialMotion(turnedOn):
	if turnedOn:
		self.set_linear_velocity(motionVelocity)
	