extends RigidBody2D

onready var spiderNode = get_node("../Spider")
onready var spiderDummyNode = get_node("../SpiderDummy")

#var whichSpider = "dummy"
var whichSpider = "spider"
var hasStretched = false

func _ready():
	spiderNode.spiderOnWeb = true
	

func _physics_process(delta):
	if spiderNode.spiderOnWeb:
		if Input.is_action_pressed("ui_down"):
			stretch("down")
		elif Input.is_action_pressed("ui_up"):
			stretch("up")
		
		if hasStretched:
			var jointPosition = $PinJoint2D.get_global_position()
			
			if whichSpider == "spider":
				spiderNode.set_global_position(jointPosition)
			elif whichSpider == "dummy":
				spiderDummyNode.set_global_position(jointPosition)
	
	if Input.is_action_just_pressed("attachOrDetach") and spiderNode.spiderOnWeb:
		$PinJoint2D.set_node_b("")
		spiderNode.spiderOnWeb = false
		spiderNode.fall = true
		
		
#func _integrate_forces(state):
#	if Input.is_action_pressed("ui_right"):
#
#	elif Input.is_action_pressed("ui_left"):
	
func stretch(direction):
	hasStretched = true
	
	var rot = self.rotation_degrees
	var yPercentage = 1
	var xPercentage = 1
	var inferiorLimit = 0.22
	var superiorLimit = 1.5
	
	print("rot: ", rot)
	
	var scale = $Sprite.get_scale()
	print("scale: ", scale)
	
	if direction == "down" and scale.y < superiorLimit:
		scale.y += 0.001*3
	elif direction == "up" and scale.y > inferiorLimit:
		scale.y -= 0.001*3
		
	$Sprite.set_scale(scale)
	$CollisionShape2D.set_scale(scale)
	var spritePosition = $Sprite.get_global_position()
	
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
	
	if direction == "down" and scale.y < superiorLimit:
		spritePosition.y += yMagicNumber*yPercentage
		spritePosition.x -= xMagicNumber*xPercentage
	if direction == "up" and scale.y > inferiorLimit:
		spritePosition.y -= yMagicNumber*yPercentage
		spritePosition.x += xMagicNumber*xPercentage
		
	$Sprite.set_global_position(spritePosition)
	$CollisionShape2D.set_global_position(spritePosition)
	
	var jointPosition = $PinJoint2D.get_global_position()
	
	var pointPosition = $Sprite/Position2D.get_global_position()
	$PinJoint2D.set_global_position(pointPosition)
	if whichSpider == "spider":
		spiderNode.set_global_position(pointPosition)
	elif whichSpider == "dummy":
		spiderDummyNode.set_global_position(pointPosition)