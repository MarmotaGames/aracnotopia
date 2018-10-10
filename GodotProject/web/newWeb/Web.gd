extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	var scale = Vector2(1,0.1)
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
	get_node("../SpiderDummy").set_global_position(jointPosition)
