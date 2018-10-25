extends RigidBody2D

onready var spiderNode = get_node("../Spider")
onready var stonePinJointNode = get_node("../Stone/PinJoint2D")

var isStretching = false

export var stretchSpeed = 5
export var inferiorStretchLimit = 0.35
export var superiorStretchLimit = 1.5
export var launchLimit = 50

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
#	elif spiderNode.spiderIsLaunchingWeb:
#		stretch("launch")
	
	if Input.is_action_just_pressed("dropFromWeb"):
		if spiderNode.spiderOnWeb:
			isStretching = false
			$PinJoint2D.set_node_b("")
			spiderNode.spiderOnWeb = false
			spiderNode.fall = true
		elif not spiderNode.fall: 
			#iniciar secrecão
			#spiderNode.spiderOnWeb = true DESCOMENTAR QUANDO IMPLEMENTAR
			pass
			
func stretch(direction):
	isStretching = true

	var scale = $Sprite.get_scale()
	
	if direction == "down" and scale.y < superiorStretchLimit:
		scale.y += 0.001*stretchSpeed
	elif direction == "up" and scale.y > inferiorStretchLimit:
		scale.y -= 0.001*stretchSpeed
	elif direction == "launch" and scale.y < launchLimit:
		scale.y += 0.001*stretchSpeed
		
	$Sprite.set_scale(scale)
	$CollisionShape2D.set_scale(scale)
#	$WebArea/CollisionShape2D.set_scale(scale)
	
	positionSprite(direction, scale)
	
	var pointPosition = $Sprite/Position2D.get_global_position()
	$PinJoint2D.set_global_position(pointPosition)
	
func positionSprite(direction, spriteScale):
	if spriteScale.y > superiorStretchLimit or spriteScale.y < inferiorStretchLimit:
		return

#	var rayVector = spritePosition - topPosition
#	var rayModule = sqrt(pow(rayVector.x, 2) + pow(rayVector.y, 2))
#	var webVector = bottomPosition - topPosition
	
	var stonePinJointPosition = stonePinJointNode.get_global_position()
	var spiderPosition = spiderNode.get_global_position()
	
	var bottomPosition = $Sprite/Position2DBottom.get_global_position()
	var topPosition = $Sprite/Position2DTop.get_global_position()
	
	var topDifference = stonePinJointPosition - topPosition
	var botDifference = spiderPosition - bottomPosition
	
	var spritePosition = $Sprite.get_global_position()
	if direction == "down" or direction == "up":
		spritePosition.y += topDifference.y
		spritePosition.x += topDifference.x
	elif direction == "launch":
		spritePosition.y += botDifference.y
		spritePosition.x += botDifference.x

	$Sprite.set_global_position(spritePosition)
	$CollisionShape2D.set_global_position(spritePosition)