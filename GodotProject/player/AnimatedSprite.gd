extends AnimatedSprite

func _process(delta):
	if get_parent().fall == true:
		self.animation = "falling"
		self.playing = true
		get_parent().rotation = 0
		get_parent().angle = 0
	else:
		self.animation = "default"
