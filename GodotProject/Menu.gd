extends Control

func _ready():
	$Center/Menu/Play.grab_focus()

func _on_Play_pressed():
	var global = get_tree().get_root()
	print(global)
	global.load_scn(global.Root)