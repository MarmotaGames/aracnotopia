extends Node
class_name BaseState

#var active : bool = false
var player : RigidBody2D

signal finished(next_state)

func handle_input(event):
	return