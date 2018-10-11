extends RigidBody2D

func _ready():
	initialMotion(false)

func _process(delta):
	stretchDownwards(false)

func stretchDownwards(turnedOn):
	if turnedOn:
		var scale = $Sprite.get_scale()
		scale.y += 0.001
		$Sprite.set_scale(scale)
		$CollisionShape2D.set_scale(scale)
		
		var spritePosition = $Sprite.get_global_position()
		spritePosition.y += 0.117
		$Sprite.set_global_position(spritePosition)
		$CollisionShape2D.set_global_position(spritePosition)
		
		var jointPosition = $PinJoint2D.get_global_position()
		jointPosition.y += 0.25
		$PinJoint2D.set_global_position(jointPosition)
	#	get_node("../SpiderDummy").set_global_position(jointPosition)
		get_node("../Spider").set_global_position(jointPosition)


func initialMotion(turnedOn):
	if turnedOn:
		var velocity = Vector2(90,0)
		self.set_linear_velocity(velocity)
	