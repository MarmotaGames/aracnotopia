extends Node2D

var piece_scene = preload("res://web//smallPiece.tscn")

#export (int) var pieces = 1
#func _ready():
#	var parent = $Anchor
#	for i in range(pieces):
#		parent = addPiece(parent)
		
func addPiece(parent):
	var joint = parent.get_node("CollisionShape2D/Joint")
	var new_piece = piece_scene.instance()
	joint.add_child(new_piece)
	joint.node_a = parent.get_path()
	joint.node_b = new_piece.get_path()
	return new_piece
