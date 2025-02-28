extends CharacterBody2D

const SPEED = 300.0
const CROUCH_SPEED = 100.0
const DASH_SPEED = 750.0
const DASH_DURATION = 0.2
const JUMP_VELOCITY = -500.0
const LOW_GRAVITY_DURATION = 2
const LOW_GRAVITY_MULTIPLIER = 0.05  

var dash_time_left = 0.0
var dash_charges = 2
var crouching = false
var facing_positive = true
var jump_charges := 2

var low_grav_time_left = 0.0
var float_charges = 1

var emote = 1
var first_time = true

@onready var anim_player = $Sprite2D/AnimationPlayer
@onready var anim_player2 =$AnimatedSprite2D

# Function to handle normal movement & dashing
func normal_move(direction: float) -> void:
	if dash_time_left > 0:
		velocity.x = (DASH_SPEED if facing_positive else -DASH_SPEED)
		anim_player.play("dash")
		return  

	if direction != 0:
		velocity.x = direction * SPEED
		facing_positive = direction > 0 
		if not is_on_floor():
			anim_player.play("jump_right" if facing_positive else "jump_left")
		else:
			anim_player.play("walk_right" if facing_positive else "walk_left")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			anim_player.play("Idle")

# Function to handle crouch movement
func crouch_move(direction: float) -> void:
	if direction != 0:
		velocity.x = direction * CROUCH_SPEED
		facing_positive = direction > 0
		anim_player.play("duck_right" if facing_positive else "duck_left")
	else:
		velocity.x = move_toward(velocity.x, 0, CROUCH_SPEED)
		anim_player.play("duck_right" if facing_positive else "duck_left")

# Function to handle jumping
func jump() -> void:
	if jump_charges > 0:
		velocity.y = JUMP_VELOCITY
		jump_charges -= 1
		anim_player.play("jump_right" if facing_positive else "jump_left")

# Function to enable floating (low gravity)
func activate_low_gravity() -> void:
	if float_charges > 0:
		low_grav_time_left = LOW_GRAVITY_DURATION
		float_charges -= 1
		print("Slow Fall Active")

func _physics_process(delta: float) -> void:
	# Apply gravity logic
	if first_time:
		anim_player2.hide()
		first_time = false
	if not is_on_floor():
		if low_grav_time_left > 0 and velocity.y>0:
			velocity += (get_gravity() * LOW_GRAVITY_MULTIPLIER) * delta  # Reduced gravity
			low_grav_time_left -= delta  # Reduce float time
		else:
			velocity += get_gravity() * delta  # Normal gravity
	
	
	if Input.is_action_just_pressed("gravity_control"):
		activate_low_gravity()

	
	if is_on_floor():
		jump_charges = 2
		dash_charges = 2
		float_charges = 1  

	# Handle input actions
	var direction := Input.get_axis("move_left", "move_right")

	if Input.is_action_pressed("crouch"):
		crouching = true
		jump_charges = 0
		crouch_move(direction)
	else:
		crouching = false
		normal_move(direction)

	if Input.is_action_just_pressed("move_up"):
		jump()

	# Handle dash
	if Input.is_action_just_pressed("dash") and dash_charges > 0:
		dash_time_left = DASH_DURATION
		dash_charges -= 1

	
	if dash_time_left > 0:
		dash_time_left -= delta
	else:
		dash_time_left = 0  
	
	if low_grav_time_left<0:
		print("slow fall Off")
	
	if Input.is_action_just_pressed("Emote"):
		emote= emote*-1
		anim_player2.play("default")
		if emote>0:
			anim_player2.hide()
		else:
			anim_player2.show()
		

	move_and_slide()
