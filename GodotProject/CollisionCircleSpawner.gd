extends StaticBody2D

onready var collider_scene = preload("res://test//Envoltorio.tscn")
var radius = 300.0
var center
var count = 360
var angle_step = 2.0*PI / count
var web_step = 5

func _ready():
	center = get_node("../Stone").position
	create()


func _process(delta):
	if Input.is_action_pressed("ui_down"):
		radius += web_step
		reposition()
	if Input.is_action_pressed("ui_up"):
		radius -= web_step
		reposition()
	if Input.is_action_pressed("attachOrDetachFromArea"):
		killCircle()
		get_node("../Line2D").hide()
		
	if Input.is_action_just_pressed("launchWeb"):
		center = get_global_mouse_position()
		get_node("../Line2D").points[1] = center
		radius = center.distance_to(get_node("../KinematicBody2D").get_global_position())+14
		create()
		get_node("../Line2D").show()

func create():
	var angle = 0
	# For each node to spawn
	for i in range(0, count):

		var direction = set_direction(angle)
		var pos = set_position(direction)
		
		var node = collider_scene.instance()
		node.set_global_position(pos)
		node.rotation_degrees = i
		self.add_child(node)
		
		# Rotate one step
		angle += angle_step

func reposition():
	var angle = 0
	for x in get_children():
		var direction = set_direction(angle)
		var pos = set_position(direction)
		x.set_global_position(pos)
		angle += angle_step
		
func set_direction(angle):
	return Vector2(cos(angle), sin(angle))
func set_position(direction):
	return center + direction * radius
func killCircle():
	for x in get_children():
		x.queue_free()
