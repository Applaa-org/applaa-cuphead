extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const DASH_SPEED = 800.0
const GRAVITY = 1800.0

var is_dashing = false
var dash_timer = 0.0
var can_parry = false
var look_direction = Vector2.RIGHT

@onready var sprite = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		# Parry window logic
		can_parry = true
		get_tree().create_timer(0.3).timeout.connect(func(): can_parry = false)

	# Handle Dash
	if Input.is_action_just_pressed("ui_select") and not is_dashing:
		is_dashing = true
		dash_timer = 0.2
		velocity.x = look_direction.x * DASH_SPEED

	# Movement & 8-Way Aiming
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir != Vector2.ZERO:
		look_direction = input_dir.normalized()
		if not is_dashing:
			velocity.x = input_dir.x * SPEED
	else:
		if not is_dashing:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	move_and_slide()
	update_animations(input_dir)
	
	# Shooting
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and shoot_timer.is_stopped():
		shoot()

func shoot():
	shoot_timer.start()
	# Instantiate bullet and set direction to look_direction
	# (Simplified for logic)
	Global.add_score(1) 

func update_animations(dir):
	# Rubber-hose jitter effect
	sprite.position = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
	if not is_on_floor():
		sprite.play("jump")
	elif dir.x != 0:
		sprite.play("run")
		sprite.flip_h = dir.x < 0
	else:
		sprite.play("idle")

func take_damage():
	Global.health -= 1
	if Global.health <= 0:
		get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")