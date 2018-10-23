extends Area2D

onready var spiderNode = get_node("../../Spider")

func _on_ContactArea_area_entered(area):
#	print(area.name, " entrouuu")
	if area.name == "SpiderArea":
		spiderNode.spiderInArea = true
		
func _on_ContactArea_area_exited(area):
#	print(area.name, " saiuuu")
	if area.name == "SpiderArea":
		spiderNode.spiderInArea = false
		if not spiderNode.spiderOnWeb:
			spiderNode.fall = true
