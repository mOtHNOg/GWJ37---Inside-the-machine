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

const MIN_DASH_VOLUME = 26.0 # as absolute value 

# motion blur
onready var motion_blur := $MotionBlur
onready var blur_mat = motion_blur.get_material()
var blur_strength: float = 0
const MAX_BLUR_STRENGTH = 0.09
const UNBLUR_SPEED = 6.0

# settings

# nauseating camera
var rotation_directions: Array = [-1, 1]
var rand_rotation_dir: int = 0
var nauseating_rotation: float = 0.0
const ROTATION_AMOUNT_PER_FRAME = 300.0
const ROTOFUDGE = 8.0
const ZOOM_DETERIATION_TO_EYES = 5.0
const ROTATION_DETERIATION_TO_EYES = 12.0


func _physics_process(delta) -> void:
	
	# apply movement
	
	if ! dashing: # movement direction is locked while dashing
		movement_direction = get_movement_direction()
	
	move_vec = movement_direction * move_speed * Settings.cam_speed_multiplier * delta
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
	if Input.is_action_just_pressed("Dash") and movement_direction != Vector2.ZERO and move_vec != Vector2.ZERO:
		if ! dashing:
			dash()
		else:
			# start input buffer timer
			dash_buffer_time_left = DASH_BUFFER_TIME
	
	# apply blur strength 
	blur_mat.set_shader_param("strength", blur_strength)
	
	
	# NAUSEATING CAMERA WOOOOOOOOO!!!!!
	
	if Settings.nauseating_camera:
		
		if rand_rotation_dir == 0:
			rand_rotation_dir = rotation_directions[int(rand_range(0, rotation_directions.size()))]
			print(rand_rotation_dir)
		
		nauseating_rotation = lerp(nauseating_rotation, 
			0 + ( rand_range(-ROTATION_AMOUNT_PER_FRAME, ROTATION_AMOUNT_PER_FRAME) * rand_rotation_dir * delta ),
			ROTATION_DETERIATION_TO_EYES * delta)
		
		rotation_degrees =  nauseating_rotation
		
		# lerp zoom to make the changes slightly more gradual (you're welcome)
		zoom = lerp(zoom, Vector2(rand_range(0.5, 2), rand_range(0.25, 2)), ZOOM_DETERIATION_TO_EYES * delta)
	
	else:
		rand_rotation_dir = 0
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
	# dash volume is effected by speed multiplier
	
	var dash_volume = 0 if Settings.cam_speed_multiplier > 1.0 else MIN_DASH_VOLUME * Settings.cam_speed_multiplier - MIN_DASH_VOLUME
	AudioManager.play("res://assets/sound/dash1.ogg", {"volume_db" : dash_volume, "pitch_scale" : rand_range(0.933, 1.072)})
	
	
	dashing = true
	move_speed = BASE_MOVE_SPEED * DASH_SPEED_MULTIPLTER
	
	# apply motion blur
	var movement_angle: float = -rad2deg(movement_direction.angle())
	blur_mat.set_shader_param("angle_degrees", movement_angle)
	
	blur_strength = MAX_BLUR_STRENGTH * Settings.cam_speed_multiplier
