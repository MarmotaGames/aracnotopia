extends RigidBody2D

onready var spiderNode = get_node("../Spider")
onready var stonePinJointNode = null

onready var spriteScale = $Sprite.get_scale()
onready var topPosition = $Sprite/Position2DTop.get_global_position()
onready var bottomPosition = $Sprite/Position2DBottom.get_global_position()

var isStretching = false
var stretchSpeed = 10
var webLaunchSpeed = 7
var inferiorStretchLimit = 0.3
var superiorStretchLimit = 2
var launchLimit = 3

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

	spriteScale = $Sprite.get_scale()
	
	if direction == "down" and spriteScale.y < superiorStretchLimit:
		spriteScale.y += 0.001*stretchSpeed
	elif direction == "up" and spriteScale.y > inferiorStretchLimit:
		spriteScale.y -= 0.001*stretchSpeed
	elif direction == "launch" and spriteScale.y < launchLimit:
		spriteScale.y += 0.01*webLaunchSpeed
		
	$Sprite.set_scale(spriteScale)
	$CollisionShape2D.set_scale(spriteScale)
	
	positionSprite(direction)
	
	var pointPosition = $Sprite/Position2D.get_global_position()
	$PinJoint2D.set_global_position(bottomPosition)
	
func positionSprite(direction):
	if spiderNode.spiderIsLaunchingWeb:
		if spriteScale.y > launchLimit:
			return

	var spiderPosition = spiderNode.get_global_position()
	var spritePosition = $Sprite.get_global_position()
	
	topPosition = $Sprite/Position2DTop.get_global_position()
	bottomPosition = $Sprite/Position2DBottom.get_global_position()
	
	if spiderNode.spiderOnWeb:
		var stonePinJointPosition = stonePinJointNode.get_global_position()
		var topDifference = stonePinJointPosition - topPosition
		
		if direction == "down" or direction == "up":
			spritePosition += topDifference
	else:
		var botDifference = spiderPosition - bottomPosition
		
		if direction == "launch":
			spritePosition += botDifference

	$Sprite.set_global_position(spritePosition)
	$CollisionShape2D.set_global_position(spritePosition)