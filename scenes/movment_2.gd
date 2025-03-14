extends CharacterBody2D

@export var SPEED := 200
@export var JUMP_SPEED := -500
@export var GRAVITY := 800
@onready var animplayer = $Kunoichi
@onready var jump_sound = $SFX
var animation;

const UP = Vector2(0,-1)

func _get_input():
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		animation = "jump"
		velocity.y = JUMP_SPEED
		jump_sound.play()

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	animation = "idle"
	if direction:
		if not is_on_floor():
			animation = "jump"
			velocity.x = direction * SPEED
			if direction<0:
				animplayer.flip_h = false
			else:
				animplayer.flip_h = true
		else:
			animation = "walk"
		velocity.x = direction * SPEED
		if direction>0:
			animplayer.flip_h = false
		else:
			animplayer.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
		
	if animplayer.animation!=animation:
		animplayer.play(animation)

	move_and_slide()


func _physics_process(delta: float) -> void:
	velocity.y += delta*GRAVITY
	_get_input()
	move_and_slide()
