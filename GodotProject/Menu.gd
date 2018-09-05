extends Control

func _ready():
	$Center/Menu/Play.grab_focus()

func _on_Play_pressed():
	get_tree().change_scene("res://GreatWeb.tscn")