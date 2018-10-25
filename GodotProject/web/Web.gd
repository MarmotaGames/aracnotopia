extends RigidBody2D

onready var spiderNode = get_node("../Spider")
onready var stonePinJointNode = null
#onready var bundaPositionNode = get_node("../Spider/BundaPosition")

var isStretching = false
onready var topPosition = $Sprite/Position2DTop.get_global_position()
onready var bottomPosition = $Sprite/Position2DBottom.get_global_position()

export var stretchSpeed = 5
export var webLaunchSpeed = 20
export var inferiorStretchLimit = 0.05
export var superiorStretchLimit = 30
export var launchLimit = 30

#func _ready():
#	spiderNode.spiderOnWeb = true
#	spiderNode.spiderIsLaunchingWeb = true
	
func _physics_process(delta):
	if spiderNode.spiderOnWeb:
		if Input.is_action_pressed("ui_down"):
			stretch("down")
		elif Input.is_action_pressed("ui_up"):
			stretch("up")
		else:
			isStretching = false
	
	if Input.is_action_just_pressed("dropFromWeb"):
		if spiderNode.spiderOnWeb:
			isStretching = false
			spiderNode.spiderOnWeb = false
			spiderNode.fall = true
			
			$PinJoint2D.set_node_b("")
			stonePinJointNode.set_node_b("")
			self.queue_free()
			
func stretch(direction):
	isStretching = true

	var scale = $Sprite.get_scale()
	
	if direction == "down" and scale.y < superiorStretchLimit:
		scale.y += 0.001*stretchSpeed
	elif direction == "up" and scale.y > inferiorStretchLimit:
		scale.y -= 0.001*stretchSpeed
	elif direction == "launch" and scale.y < launchLimit:
		scale.y += 0.01*webLaunchSpeed
		
	$Sprite.set_scale(scale)
	$CollisionShape2D.set_scale(scale)
	
	positionSprite(direction, scale)
	
	var pointPosition = $Sprite/Position2D.get_global_position()
	$PinJoint2D.set_global_position(bottomPosition)
	
func positionSprite(direction, spriteScale):
	if spriteScale.y > superiorStretchLimit or spriteScale.y < inferiorStretchLimit:
		print("ta retornando nadaaa")
		return

#	var rayVector = spritePosition - topPosition
#	var rayModule = sqrt(pow(rayVector.x, 2) + pow(rayVector.y, 2))
#	var webVector = bottomPosition - topPosition
	
	var spiderPosition = spiderNode.get_global_position()
	var spritePosition = $Sprite.get_global_position()
	
	topPosition = $Sprite/Position2DTop.get_global_position()
	bottomPosition = $Sprite/Position2DBottom.get_global_position()
	
	if spiderNode.spiderOnWeb:
		var stonePinJointPosition = stonePinJointNode.get_global_position()
		var topDifference = stonePinJointPosition - topPosition
		
		if direction == "down" or direction == "up":
			spritePosition.y += topDifference.y
			spritePosition.x += topDifference.x
	else:
#		var bundaPosition = bundaPositionNode.get_global_position()
#		var botDifference = bundaPosition - bottomPosition
		var botDifference = spiderPosition - bottomPosition
		
		if direction == "launch":
			spritePosition.y += botDifference.y
			spritePosition.x += botDifference.x

	$Sprite.set_global_position(spritePosition)
	$CollisionShape2D.set_global_position(spritePosition)