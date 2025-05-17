extends CharacterBody2D
class_name PlayerController

@export var stats : PlayerParameters
@export var animator : PlayerAnimator
@export var ui : Control

# Magic Math I stole
@onready var jump_velocity:float = ((2.0 * stats.jump_height) / stats.jump_time_to_peak) * -1.0 
@onready var jump_gravity:float = ((-2.0 * stats.jump_height) / (stats.jump_time_to_peak * stats.jump_time_to_peak)) * -1.0
@onready var fall_gravity:float = ((-2.0 * stats.jump_height) / (stats.jump_time_to_peak * stats.jump_time_to_descent)) *-1.0

var direction = 0

enum PlayerState {
	IDLE,
	RUNNING,
	CROUCHING,
	JUMPING,
	FALLING
}

var _state: PlayerState = PlayerState.IDLE

func _physics_process(delta):
	check_state()
	if not is_on_floor():
		velocity.y += return_gravity() * delta # Apply gravity when airborne
		
	if Input.is_action_just_pressed("jump") and _state != PlayerState.JUMPING:
		jump()
		
	if Input.is_action_just_released("jump"): # Fast Fall
		velocity.y *= stats.fast_fall_multiplier 
		
	if Input.is_action_pressed("crouch") and is_on_floor(): # Make player stop when crouching
		velocity.x = 0
	# Direction will be equal to 1 if moving right and -1 if moving left
	direction = Input.get_axis("move_left", "move_right") 
	if direction:
		# The run will make the player move towards their inputted direction by the acceleration value
		# The run will never exceed the top speed
		# We multiply the top speed with direction to determine if they're moving right or left, based on
		# if direction is negative or positive
		velocity.x = move_toward(velocity.x, (direction * stats.run_top_speed), stats.run_acceleration)
	else:
		# When the player stops inputting a direction, they will move to a stop (0) by the deceleration value
		velocity.x = move_toward(velocity.x, 0, stats.run_deceleration)
	move_and_slide()

func return_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func jump():
	velocity.y = jump_velocity
	
func set_state(new_state: PlayerState):
	if new_state == _state:
		return
	_state = new_state
	match _state:
		PlayerState.IDLE:
			animator.play_anim("idle")
		PlayerState.RUNNING:
			animator.play_anim("run")
		PlayerState.CROUCHING:
			pass
		PlayerState.JUMPING:
			pass
		PlayerState.FALLING:
			pass

func check_state():
	if is_on_floor():
		if velocity.x == 0:
			set_state(PlayerState.IDLE)
		elif velocity.x != 0:
			set_state(PlayerState.RUNNING)
	if Input.is_action_pressed("crouch") and is_on_floor():
		set_state(PlayerState.CROUCHING)
	if velocity.y < 0:
		set_state(PlayerState.JUMPING)
	if velocity.y > 0:
		set_state(PlayerState.FALLING)
