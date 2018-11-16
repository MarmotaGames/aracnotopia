extends Area2D

onready var spiderNode = get_node("../../Spider")
onready var stonePinJointNode
onready var webNode
onready var webPinJointNode
onready var webBottom

var polygon_shape
var list

func _on_ContactArea_area_entered(area):
	if area.name == "SpiderArea":
		spiderNode.spiderInArea = true
		
func _on_ContactArea_area_exited(area):
	if area.name == "SpiderArea":
		spiderNode.spiderInArea = false
		if not spiderNode.spiderOnWeb:
			spiderNode.spiderIsFalling = true

func loadNodes():
	webNode = get_node("../../Web")
	webBottom = get_node("../../Web/Sprite/Position2DBottom")
	webPinJointNode = get_node("../../Web/PinJoint2D")
	stonePinJointNode = get_node("../PinJoint2D")
	
func _on_StoneArea_area_entered(area):
	var objeto = null
	if spiderNode.result:
		objeto = spiderNode.result.collider
	if area.name == "WebArea" and not spiderNode.spiderOnWeb and objeto and objeto == get_parent():#spiderNode.result:
		#break aqui para debug
		if spiderNode.result != null:
			loadNodes()
			spiderNode.spiderOnWeb = true
			spiderNode.spiderIsLaunchingWeb = false
			if spiderNode.spiderIsFalling:
				spiderNode.spiderIsFalling = false
				
			webNode.stonePinJointNode = stonePinJointNode
			spiderNode.stonePinJointNode = stonePinJointNode
			#webNode.positionSprite("down")
			var stonePinJointPosition
			var webPosition2DTop = get_node("../../Web/Sprite/Position2DTop").get_global_position()
			if webTopInStone(webPosition2DTop):
				stonePinJointPosition = webPosition2DTop
			else:
				stonePinJointPosition = spiderNode.result.position
			
			
			stonePinJointNode.set_global_position(spiderNode.result.position)
			webNode.positionSprite("up")
			stonePinJointNode.set_node_b("../../Web")
			webPinJointNode.set_node_b("../../Spider")
			
			#webNode.stretch("up")
			#webNode.stretch("down")
			
			
			webNode.set_gravity_scale(5)
			
func webTopInStone(webPosition2DTop):
	var stonePosition = get_parent().get_global_position()
	var halfsize = get_parent().scale.x * 512 / 2
	if webPosition2DTop.x < stonePosition.x + halfsize and webPosition2DTop.x > stonePosition.x - halfsize and webPosition2DTop.y < stonePosition.y + halfsize and webPosition2DTop.y > stonePosition.y - halfsize:
		return true
	else:
		return false