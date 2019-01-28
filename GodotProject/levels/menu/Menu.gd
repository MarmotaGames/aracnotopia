extends Control

const GAME_PATH = "res://levels/hub/GreatWeb.tscn"

func _on_Play_pressed():
	get_tree().change_scene(GAME_PATH)