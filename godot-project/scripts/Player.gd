extends CharacterBody2D

const SPEED = 350.0
const JUMP_VELOCITY = -650.0
const DASH_SPEED = 900.0
const GRAVITY = 2000.0

var is_dashing = false
var dash_cooldown = 0.0
var look_dir = Vector2.RIGHT
var is_parrying = false

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# 1. Movement Controls (Direct Key Detection)
	var move_input = Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): move_input.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): move_input.x += 1
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): move_input.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): move_input.y += 1

	# 2. 8-Way Aiming Logic
	if move_input != Vector2.ZERO:
		look_dir = move_input.normalized()

	# 3. Jump & Parry
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_key_pressed(KEY_SPACE) and not is_on_floor() and not is_parrying:
		start_parry()

	# 4. Dash
	if Input.is_key_pressed(KEY_SHIFT) and dash_cooldown <= 0:
		perform_dash()

	# Apply Movement
	if not is_dashing:
		velocity.x = move_input.x * SPEED
	
	move_and_slide()
	dash_cooldown -= delta
	
	# Rubber-hose visual jitter
	sprite.position = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	update_animations(move_input)

func perform_dash():
	is_dashing = true
	dash_cooldown = 0.8
	velocity.x = (1 if sprite.flip_h == false else -1) * DASH_SPEED
	await get_tree().create_timer(0.2).timeout
	is_dashing = false

func start_parry():
	is_parrying = true
	sprite.modulate = Color.PINK
	# Check for pink objects in Area2D (omitted for brevity)
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color.WHITE
	is_parrying = false

func update_animations(dir):
	if not is_on_floor():
		sprite.play("jump")
	elif dir.x != 0:
		sprite.play("run")
		sprite.flip_h = dir.x < 0
	else:
		sprite.play("idle")