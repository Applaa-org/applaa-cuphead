extends CharacterBody2D

const SPEED = 320.0
const JUMP_VELOCITY = -600.0
const DASH_SPEED = 900.0
const GRAVITY = 1900.0

var is_dashing = false
var dash_timer = 0.0
var can_parry = false
var aim_dir = Vector2.RIGHT

@onready var sprite = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# 1. WASD Movement & Aiming
	var input_dir = Vector2.ZERO
	if Input.is_key_pressed(KEY_W): input_dir.y -= 1
	if Input.is_key_pressed(KEY_S): input_dir.y += 1
	if Input.is_key_pressed(KEY_A): input_dir.x -= 1
	if Input.is_key_pressed(KEY_D): input_dir.x += 1

	if input_dir != Vector2.ZERO:
		aim_dir = input_dir.normalized()

	# 2. SPACE: Jump / Parry
	if Input.is_key_pressed(KEY_SPACE):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			can_parry = true
		elif can_parry:
			perform_parry()

	# 3. SHIFT: Dash
	if Input.is_key_pressed(KEY_SHIFT) and dash_timer <= 0:
		start_dash()

	# 4. CLICK: Shoot
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and shoot_timer.is_stopped():
		shoot()

	# Apply Movement
	if not is_dashing:
		velocity.x = input_dir.x * SPEED
	
	move_and_slide()
	
	# Timers
	if dash_timer > 0: dash_timer -= delta
	
	# Rubber-hose jitter
	sprite.position = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	update_animations(input_dir)

func start_dash():
	is_dashing = true
	dash_timer = 0.7 # Cooldown
	velocity.x = (1 if not sprite.flip_h else -1) * DASH_SPEED
	await get_tree().create_timer(0.2).timeout
	is_dashing = false

func perform_parry():
	can_parry = false
	sprite.modulate = Color.PINK
	velocity.y = JUMP_VELOCITY * 0.8 # Bounce up
	Global.score += 100
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color.WHITE

func shoot():
	shoot_timer.start(0.15)
	# Bullet logic would go here
	Global.score += 10

func update_animations(dir):
	if not is_on_floor():
		sprite.play("jump")
	elif dir.x != 0:
		sprite.play("run")
		sprite.flip_h = dir.x < 0
	else:
		sprite.play("idle")