extends AnimatedSprite

var fallRotInit = true

func _process(delta):
	if get_parent().spiderIsFalling:
		self.animation = "falling"
		self.playing = true
		if fallRotInit:
			#get_parent().rotation = -179
			#get_parent().angle = -179
			fallRotInit = false
	else:
		self.animation = "default"
