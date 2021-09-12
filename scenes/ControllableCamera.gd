extends Camera2D

# basic movement vars
var movement_direction: Vector2 = Vector2.ZERO
var move_vec: Vector2 = Vector2.ZERO

const BASE_MOVE_SPEED = 250
var move_speed: float = BASE_MOVE_SPEED

# dashing vars
var dashing: bool = false
const DASH_SPEED_MULTIPLTER = 20.0
const DASH_DECELERATE_SPEED = 18.0

const DASH_BUFFER_TIME = 8
var dash_buffer_time_left: int = 0

# motion blur
onready var motion_blur := $MotionBlur
onready var blur_mat = motion_blur.get_material()
var blur_strength: float = 0
const MAX_BLUR_STRENGTH = 0.09
const UNBLUR_SPEED = 6.0

# settings

# nauseating camera
var nauseating_rotation: float = 0.0
const ROTATION_AMOUNT_PER_FRAME = 200.0
const ROTOFUDGE = 8.0

func _physics_process(delta) -> void:
	
	# apply movement
	
	if ! dashing: # movement direction is locked while dashing
		movement_direction = get_movement_direction()
	
	move_vec = movement_direction * move_speed * Settings.move_speed_multiplier * delta
	position += move_vec
	
	# dashing stuff
	
	# decelerate to normal speed (also unblur)
	move_speed = lerp(move_speed, BASE_MOVE_SPEED, DASH_DECELERATE_SPEED * delta)
	blur_strength = lerp(blur_strength, 0, UNBLUR_SPEED * delta)
	
	if move_speed - BASE_MOVE_SPEED < 15.0:
		move_speed = BASE_MOVE_SPEED
		dashing = false
	
	# input buffering
	if dash_buffer_time_left != 0:
		dash_buffer_time_left -= 1
	
	if dashing == false and dash_buffer_time_left > 0:
		movement_direction = get_movement_direction()
		dash()
		dash_buffer_time_left = 0
	
	# detect dash input
	if Input.is_action_just_pressed("Dash") and movement_direction != Vector2.ZERO:
		if ! dashing:
			dash()
		else:
			# start input buffer timer
			dash_buffer_time_left = DASH_BUFFER_TIME
	
	# apply blur strength 
	blur_mat.set_shader_param("strength", blur_strength)
	
	
	# NAUSEATING CAMERA WOOOOOOOOO!!!!!
	
	if Settings.nauseating_camera:
		nauseating_rotation += rand_range(-ROTATION_AMOUNT_PER_FRAME, ROTATION_AMOUNT_PER_FRAME) * delta
		rotation_degrees = lerp(rotation_degrees, sin(global_position.length() * 0.01) * 360 + nauseating_rotation, ROTOFUDGE * 0.5 * delta)
		
		# lerp zoom to make the changes slightly more gradual (you're welcome)
		zoom = lerp(zoom, Vector2(rand_range(0.5, 2), rand_range(0.5, 2)), ROTOFUDGE * delta)
	else:
		zoom = lerp(zoom, Vector2(1, 1), ROTOFUDGE * delta)
		nauseating_rotation = 0
		
		var nearest_rotation = stepify(rotation_degrees, 360)
		rotation_degrees = lerp(rotation_degrees, nearest_rotation, ROTOFUDGE * delta)
		if rotation_degrees == nearest_rotation:
			rotation_degrees = 0

func get_movement_direction() -> Vector2:
	return Vector2(
			Input.get_action_strength("Right") - Input.get_action_strength("Left"),
			Input.get_action_strength("Down") - Input.get_action_strength("Up")
		).normalized()

func dash() -> void:
	AudioManager.play("res://assets/sound/dash1.ogg", {"pitch_scale" : rand_range(0.933, 1.072)})
	dashing = true
	move_speed = BASE_MOVE_SPEED * DASH_SPEED_MULTIPLTER
	
	# apply motion blur
	var movement_angle: float = -rad2deg(movement_direction.angle())
	blur_mat.set_shader_param("angle_degrees", movement_angle)
	
	blur_strength = MAX_BLUR_STRENGTH
