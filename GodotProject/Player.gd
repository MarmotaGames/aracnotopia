extends KinematicBody2D

const CLANG_SCN = preload("res://fx/Clang.tscn")
const SLASH_SCN = preload("res://fx/slash/SlashFX.tscn")
const DEATH_THRESHOLD = 2

var speed = 200
export var attack_power = 110
var lastDirection = Vector2(0,1)
var direction = Vector2(0,0)
var dashDir = Vector2()
var slashing = false
var isDead = false

# we USE this
var velocity = Vector2()

onready var shape_radius = $CollisionShape2D.shape.radius
onready var win_manager = get_node("../..")

func move_blocked():
	return $AttackTimer.time_left or $DashTimer.time_left or $StunTimer.time_left

func _input(event):
	if isDead or move_blocked():
		return
	
	if event.is_action_pressed("dash_action"):
		dash()
	
	if event.is_action_pressed("attack_action"):
		attack()

func _physics_process(delta):
		
	direction = Vector2(0,0)
	
	if not move_blocked() and $Sprite/AnimationPlayer.current_animation != "attack-right" \
	                      and $Sprite/AnimationPlayer.current_animation != "attack-left" \
						  and $Sprite/AnimationPlayer.current_animation != "attack-down" \
						  and $Sprite/AnimationPlayer.current_animation != "attack-up":
							 update_direction()
	
	if direction != Vector2(0,0):
		lastDirection = direction
		$AttackArea.rotation = lastDirection.angle() - PI/2

	if isDead:
		$Sprite.set_motion(Vector2())
		return

	if $DashTimer.time_left > 0:
		velocity = dashDir.normalized()*speed*2
		move_and_slide(velocity)
		$Sprite.set_motion(velocity)
	elif not move_blocked():
		velocity = direction.normalized()*speed
		move_and_slide(velocity)
		$Sprite.set_motion(velocity)
	
	# Is player being gruesomely crushed to death?
	var bodies = $DeathArea.get_overlapping_bodies()
	var touched_left = false
	var touched_right = false
	var touched_top = false
	var touched_bottom = false
	for body in bodies:
		if body == self:
			continue
		var other_shape = body.get_node("CollisionShape2D").shape
		if other_shape.get("radius"):
			var limit = self.shape_radius + other_shape.radius - DEATH_THRESHOLD
			if position.distance_to(body.position) < limit:
				die()
		elif other_shape.get("extents"):
			var shapenode = body.get_node("CollisionShape2D")
			var topleft = shapenode.global_position - other_shape.extents/2
			var bottomright = shapenode.global_position + other_shape.extents/2
			var nearest = Vector2(
				max(topleft.x, min(bottomright.x, position.x)),
				max(topleft.y, min(bottomright.y, position.y))
			)
			var limit = self.shape_radius - DEATH_THRESHOLD
			if position.distance_to(body.position) < limit:
				die()
		if body.name == "Left":
			touched_left = true
		if body.name == "Right":
			touched_right = true
		if body.name == "Top":
			touched_top = true
		if body.name == "Bottom":
			touched_bottom = true
	if touched_left and touched_right:
		die()
	if touched_top and touched_bottom:
		die()

func die():
	isDead = true
	win_manager.reset_window()
	var corpse_scn = preload("res://penguin-sprite/sensei/PenguinGore.tscn")
	var corpse = corpse_scn.instance()
	corpse.position = self.position
	$CollisionShape2D.disabled = true
	get_parent().add_child(corpse)
	self.visible = false
	var bodies = get_parent()
	for body in bodies.get_children():
		if body.is_in_group('spawner'):
			body.get_node('Timer').disconnect('timeout', body, '_spawn')

func dash():
	if $DashTimer.time_left == 0 and direction != Vector2():
		self.dashDir = self.direction
		$DashTimer.start()
		$Sprite.dash(dashDir)

func update_direction():
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1

func _on_AttackTimer_timeout():
	update_direction()

func attack():
	direction = Vector2()
	$Sprite.start_attack()
	$AttackTimer.start()
	#now we wait for the slash signal

func spawn_clang(target):
	var clang = CLANG_SCN.instance()
	clang.position = (self.position + 3 * target.position) / 4.0
	get_parent().add_child(clang)

func _slash():
	self.slashing = true
	while self.slashing:
		var bodies = get_node("AttackArea").get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group('wall'):
				body.attacked(attack_power)
				self.slashing = false
			elif body.is_in_group('enemies'):
				if not body.isDead:
					var slash = SLASH_SCN.instance()
					slash.position = body.position + Vector2(0, -24)
					get_parent().add_child(slash)
					$ShatterSFX.play()
					$Camera.focus()
				body.attacked(self)
				spawn_clang(body)
			elif body.is_in_group('props'):
				spawn_clang(body)
				self.slashing = false
		yield(get_tree(), "physics_frame")

func stun(stunDuration):
	if $StunTimer.time_left == 0 and $StunCooldown.time_left == 0:
		self.direction = Vector2()
		self.dashDir = Vector2()
		$StunTimer.wait_time = stunDuration
		$StunTimer.start()
		$Sprite.start_stun()

func blink():
	$BlinkTimer.start()
	if $Sprite.modulate == Color(1, 1, 1, 1):
		$Sprite.modulate = Color(1, 1, 1, .5)
	else:
		$Sprite.modulate = Color(1, 1, 1, 1)

func _on_BlinkTimer_timeout():
	if $StunCooldown.time_left != 0:
		blink()

func _on_StunTimer_timeout():
	blink()
	$Sprite.end_stun()
	$StunCooldown.start()

func _on_StunCooldown_timeout():
	$Sprite.modulate = Color(1, 1, 1, 1)

func _on_Sprite_slash_started():
	_slash()

func _on_Sprite_slash_ended():
	self.slashing = false
