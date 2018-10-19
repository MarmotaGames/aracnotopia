extends RigidBody2D

onready var spiderNode = get_node("../Spider")

var isStretching = false

export var stretchSpeed = 5
export var inferiorStretchLimit = 0.35
export var superiorStretchLimit = 1.5

func _ready():
	spiderNode.spiderOnWeb = true
	
func _physics_process(delta):
	if spiderNode.spiderOnWeb:
		if Input.is_action_pressed("ui_down"):
			stretch("down")
		elif Input.is_action_pressed("ui_up"):
			stretch("up")
		else:
			isStretching = false
		
	if Input.is_action_just_pressed("excreteOrLeaveWeb"):
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
		
	$Sprite.set_scale(scale)
	$CollisionShape2D.set_scale(scale)
	
	positionSprite(direction, scale)
	
	var pointPosition = $Sprite/Position2D.get_global_position()
	$PinJoint2D.set_global_position(pointPosition)
	
func positionSprite(direction, spriteScale):
	if spriteScale.y > superiorStretchLimit or spriteScale.y < inferiorStretchLimit:
		return

#	var yMagicNumber = (0.116-((abs(rot)/10)*0.0130 - 0.022))*3
#	var xMagicNumber = (0.0055-(((abs(rot)/10)*0.0115 - 0.040)/100)*1.3)*rot
	
#	var bottomPosition = $Sprite/Position2DBottom.get_global_position()
#	var rayVector = spritePosition - topPosition
#	var rayModule = sqrt(pow(rayVector.x, 2) + pow(rayVector.y, 2))
#	var webVector = bottomPosition - topPosition
	
	var topPosition = $Sprite/Position2DTop.get_global_position()
	var stonePinJointPosition = get_node("../Stone/PinJoint2D").get_global_position()
	var topDifference = stonePinJointPosition - topPosition
	
	var spritePosition = $Sprite.get_global_position()
	if direction == "down":
		spritePosition.y += topDifference.y
		spritePosition.x += topDifference.x
	elif direction == "up":
		spritePosition.y += topDifference.y
		spritePosition.x += topDifference.x

	$Sprite.set_global_position(spritePosition)
	$CollisionShape2D.set_global_position(spritePosition)