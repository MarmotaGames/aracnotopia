extends Area2D

onready var spiderNode = get_node("../../Spider")
onready var stonePinJointNode
onready var webNode
onready var webPinJointNode

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
	webPinJointNode = get_node("../../Web/PinJoint2D")
	stonePinJointNode = get_node("../PinJoint2D")
	
func _on_StoneArea_area_entered(area):
	if area.name == "WebArea" and not spiderNode.spiderOnWeb:
		loadNodes()
		spiderNode.spiderOnWeb = true
		spiderNode.spiderIsLaunchingWeb = false
		if spiderNode.spiderIsFalling:
			spiderNode.spiderIsFalling = false
		stonePinJointNode.set_node_b("../../Web")
		webPinJointNode.set_node_b("../../Spider")
		
		webNode.stretch("up")
		webNode.stretch("down")
		
		
		webNode.set_gravity_scale(5)