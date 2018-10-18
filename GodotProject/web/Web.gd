extends RigidBody2D

onready var spiderNode = get_node("../Spider")

var isStretching = false
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
		scale.y += 0.001*3
	elif direction == "up" and scale.y > inferiorStretchLimit:
		scale.y -= 0.001*3
		
	$Sprite.set_scale(scale)
	$CollisionShape2D.set_scale(scale)
	
	positionSprite(direction, scale)
	
	var pointPosition = $Sprite/Position2D.get_global_position()
	$PinJoint2D.set_global_position(pointPosition)
	
func positionSprite(direction, spriteScale):
	if spriteScale.y > superiorStretchLimit or spriteScale.y < inferiorStretchLimit:
		return
		
	var yPercentage = 1
	var xPercentage = 1
	var spritePosition = $Sprite.get_global_position()
	var rot = self.rotation_degrees
	
	if abs(rot) > 60:
		yPercentage = 0.94
		xPercentage = 0.93
	elif abs(rot) > 30:
		yPercentage = 1
		xPercentage = 0.98
	else:
		yPercentage = 0.85
		xPercentage = 1
		
	var yMagicNumber = (0.116-((abs(rot)/10)*0.0130 - 0.022))*3
	var xMagicNumber = (0.0055-(((abs(rot)/10)*0.0115 - 0.040)/100)*1.3)*rot
	
	if direction == "down":
		spritePosition.y += yMagicNumber*yPercentage
		spritePosition.x -= xMagicNumber*xPercentage
	elif direction == "up":
		spritePosition.y -= yMagicNumber*yPercentage
		spritePosition.x += xMagicNumber*xPercentage
	
	$Sprite.set_global_position(spritePosition)
	$CollisionShape2D.set_global_position(spritePosition)