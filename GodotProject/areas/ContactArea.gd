extends Area2D

onready var spiderNode = get_node("../../Spider")
onready var stonePinJointNode
onready var webNode
onready var webPinJointNode

func _on_ContactArea_area_entered(area):
	if area.name == "SpiderArea":
		spiderNode.spiderInArea = true
		
func _on_ContactArea_area_exited(area):
	if area.name == "SpiderArea":
		spiderNode.spiderInArea = false
		if not spiderNode.spiderOnWeb:
			spiderNode.fall = true

func _on_StoneArea_area_entered(area):
	if area.name == "WebArea" and not spiderNode.spiderOnWeb:
		loadNodes()
		
		spiderNode.stonePinJointNode = stonePinJointNode
		webNode.stonePinJointNode = stonePinJointNode

		webNode.positionSprite("down")
		stonePinJointNode.set_global_position(webNode.topPosition)
		
		spiderNode.spiderOnWeb = true
		spiderNode.spiderIsLaunchingWeb = false
		stonePinJointNode.set_node_b("../../Web")
		webPinJointNode.set_node_b("../../Spider")
		
		webNode.set_gravity_scale(5)

func loadNodes():
	webNode = get_node("../../Web")
	webPinJointNode = get_node("../../Web/PinJoint2D")
	stonePinJointNode = get_node("../PinJoint2D")