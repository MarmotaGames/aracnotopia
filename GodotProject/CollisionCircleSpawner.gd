extends StaticBody2D

onready var collider_scene = preload("res://test//Envoltorio.tscn")
onready var spider_node = get_node("../Player")
var radius = 300.0
var center
var count = 360
var angle_step = 2.0*PI / count
var web_step = 5
var maxLength = 800
var minLength = 60
var shouldCreate = false

func _ready():
	#Only for the test scene
	#Spider spawns connected to first stone
	center = get_node("../Stone").position
	create()


func _process(delta):
	if spider_node.spiderOnWeb:
		#Change lenght of web
		if Input.is_action_pressed("ui_down") and radius < maxLength:
			radius += web_step
			reposition()
		if Input.is_action_pressed("ui_up") and radius > minLength:
			radius -= web_step
			reposition()
		#Dettach from web
		if Input.is_action_just_pressed("attachOrDetachFromArea"):
			killCircle()
			get_node("../Line2D").hide()
			spider_node.spiderOnWeb = false
		
	if shouldCreate:
		if spider_node.spiderOnWeb:
			shouldCreate = false
		else:
			get_node("../Line2D").points[1] = center
			radius = center.distance_to(get_node("../Player").get_global_position())+14
			create()
			get_node("../Line2D").show() #the Line2D exhists at all times, but is only shown when needed
			shouldCreate = false
			spider_node.spiderOnWeb = true

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
