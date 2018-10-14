extends RigidBody2D

onready var spiderNode = get_node("../Spider")
var initialMotionBoolean = false
var stretchAlways = false
var motionVelocity = Vector2(150,0)
var stretchSpeed = 1

func _ready():
	initialMotion(initialMotionBoolean)
	spiderNode.spiderOnWeb = true

func _process(delta):

	if spiderNode.spiderOnWeb:
		if not stretchAlways:
			if Input.is_action_pressed("stretchWeb"):
				stretchDownwards()
		else:
			stretchDownwards()
		
		var jointPosition = $PinJoint2D.get_global_position()
		spiderNode.set_global_position(jointPosition)
	
#	if Input.is_action_just_pressed("detachFromWeb"):
	if Input.is_action_just_pressed("attachOrDetach") and spiderNode.spiderOnWeb:
		spiderNode.spiderOnWeb = false
		$PinJoint2D.set_node_b("")
		spiderNode.fall = true
		
func stretchDownwards():
	var scale = $Sprite.get_scale()
	scale.y += 0.001*stretchSpeed
	$Sprite.set_scale(scale)
	$CollisionShape2D.set_scale(scale)
	
	var spritePosition = $Sprite.get_global_position()
	spritePosition.y += 0.116*stretchSpeed
	$Sprite.set_global_position(spritePosition)
	$CollisionShape2D.set_global_position(spritePosition)
	
	var jointPosition = $PinJoint2D.get_global_position()
	jointPosition.y += 0.23*stretchSpeed
	$PinJoint2D.set_global_position(jointPosition)
#	jointPosition.y += 50
	spiderNode.set_global_position(jointPosition)

#	var spiderPosition = jointPosition
#	spiderPosition.y += 5
#	get_node("../Spider").set_global_position(spiderPosition)


func initialMotion(turnedOn):
	if turnedOn:
		self.set_linear_velocity(motionVelocity)
	