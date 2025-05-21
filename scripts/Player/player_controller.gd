extends CharacterBody2D
class_name PlayerController

@export var stats : PlayerParameters
@export var animator : PlayerAnimator
@export var ui : Control

# Magic Math I stole
@onready var jump_velocity:float = ((2.0 * stats.jump_height) / stats.jump_time_to_peak) * -1.0 
@onready var jump_gravity:float = ((-2.0 * stats.jump_height) / (stats.jump_time_to_peak * stats.jump_time_to_peak)) * -1.0
@onready var fall_gravity:float = ((-2.0 * stats.jump_height) / (stats.jump_time_to_peak * stats.jump_time_to_descent)) *-1.0
@onready var coyote_time = stats.coyote_frames / 60.0
var last_floor = false # Last frame's on-floor state
var direction = 0

var prev_state

enum PlayerState {
	IDLE,
	RUNNING,
	CROUCHING,
	JUMPING,
	FALLING,
	COYOTE
}

var _state: PlayerState = PlayerState.IDLE

func _physics_process(delta):
	print(_state)
	check_state()
	if not is_on_floor():
		velocity.y += return_gravity() * delta # Apply gravity when airborne
	# Jump Input
	if Input.is_action_just_pressed("jump") and _state != PlayerState.JUMPING and _state != PlayerState.FALLING:
		jump()
	# Fast fall input
	if Input.is_action_just_released("jump"): # Fast Fall
		velocity.y *= stats.fast_fall_multiplier 
	# Crouch Input
	if Input.is_action_pressed("crouch") and is_on_floor(): # Make player stop when crouching
		velocity.x = 0
	# Move input
	# Direction will be equal to 1 if moving right and -1 if moving left
	direction = Input.get_axis("move_left", "move_right") 
	if direction and _state != PlayerState.CROUCHING:
		# The run will make the player move towards their inputted direction by the acceleration value
		# The run will never exceed the top speed
		# We multiply the top speed with direction to determine if they're moving right or left, based on
		# if direction is negative or positive
		velocity.x = move_toward(velocity.x, (direction * stats.run_top_speed), stats.run_acceleration)
	else:
		# When the player stops inputting a direction, they will move to a stop (0) by the deceleration value
		velocity.x = move_toward(velocity.x, 0, stats.run_deceleration)
	last_floor = is_on_floor()
	move_and_slide()
	# Coyote Time
	if !is_on_floor() and last_floor:
		prev_state = _state
		set_state(PlayerState.COYOTE)

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
		PlayerState.COYOTE:
			var coyote_timer := Timer.new()
			add_child(coyote_timer)
			coyote_timer.wait_time = coyote_time
			coyote_timer.one_shot = true
			coyote_timer.timeout.connect(coyote_end.bind(coyote_timer))
			coyote_timer.start()
			
func coyote_end(timer):
	_state = prev_state
	timer.queue_free()

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
	if velocity.y > 0 && _state != PlayerState.COYOTE:
		set_state(PlayerState.FALLING)
