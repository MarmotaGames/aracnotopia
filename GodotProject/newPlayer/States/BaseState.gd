extends Node
class_name BaseState

var active : bool = false

signal finished(next_state)

func handle_input(event):
	return