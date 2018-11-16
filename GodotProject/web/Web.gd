extends RigidBody2D

onready var spiderNode = get_node("../Spider")
onready var spinneretNode = get_node("../Spider/Spinneret")
onready var stonePinJointNode = null

onready var spriteScale = $Sprite.get_scale()
onready var topPosition = $Sprite/Position2DTop.get_global_position()
onready var bottomPosition = $Sprite/Position2DBottom.get_global_position()

#var stretchSpeed = 0.015
#var webLaunchSpeed = 0.06
var stretchSpeed = 0.015
var webLaunchSpeed = 0.3
var inferiorStretchLimit = 0.3
var superiorStretchLimit = 2
var launchLimit = 3
var maxStretchAngle = 80

func _physics_process(delta):
	processStrechInput()
	processDropFromWebInput()
	
func stretch(direction):
	spriteScale = $Sprite.get_scale()
	if direction == "down" and spriteScale.y < superiorStretchLimit:
		spriteScale.y += stretchSpeed
	elif direction == "up" and spriteScale.y > inferiorStretchLimit:
		spriteScale.y -= stretchSpeed
	elif direction == "launch" and spriteScale.y < launchLimit:
		spriteScale.y += webLaunchSpeed
	elif spriteScale.y > launchLimit: #atirou e não attachou em nada
		if spiderNode.spiderIsLaunchingWeb:
			# desinstanciar a teia
			spiderNode.spiderIsLaunchingWeb = false
			spiderNode.spiderOnWeb = false
			spiderNode.failedLaunch = true
			if not spiderNode.spiderInArea:
				spiderNode.spiderIsFalling = true
			self.queue_free()
			return
		else:
			pass
			return
		
	$Sprite.set_scale(spriteScale)
	$CollisionShape2D.set_scale(spriteScale)
	
	positionSprite(direction)
	
	#$PinJoint2D.set_global_position(bottomPosition)	
	
func positionSprite(direction):
#	if spiderNode.spiderIsLaunchingWeb:
#		if spriteScale.y > launchLimit:
#			return

	"""
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
	$Polygon2D.set_global_position(spritePosition)
	"""
	var offset
	if direction == "launch":
		offset = spiderNode.position - $Sprite/Position2DBottom.get_global_position()
		
	if direction == "down" or direction == "up":
		offset = stonePinJointNode.get_global_position() - $Sprite/Position2DTop.get_global_position()
	
	var spritePosition = $Sprite.get_global_position()
	spritePosition += offset
	$Sprite.set_global_position(spritePosition)
	$CollisionShape2D.set_global_position(spritePosition)
	
	if not direction == "launch":
		$PinJoint2D.set_global_position($Sprite/Position2DBottom.get_global_position())
		
#		webPinJointNode.set_node_b("")
#		xform.origin = bottomPosition
#		state.set_transform(xform)
#		webPinJointNode.set_node_b("../../Spider")
	
func processStrechInput():
	if spiderNode.spiderOnWeb:
		if Input.is_action_pressed("ui_down") and abs(self.rotation_degrees) <= maxStretchAngle:
			stretch("down")
		elif Input.is_action_pressed("ui_up") and abs(self.rotation_degrees) <= maxStretchAngle:
			stretch("up")
		else:
			pass
			
func processDropFromWebInput():
	if Input.is_action_just_pressed("dropFromWeb"):
		if spiderNode.spiderOnWeb:
			spiderNode.spiderOnWeb = false
			$PinJoint2D.set_node_b("")
			stonePinJointNode.set_node_b("")
			self.queue_free()