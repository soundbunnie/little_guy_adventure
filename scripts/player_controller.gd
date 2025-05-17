extends CharacterBody2D
class_name PlayerController

@export var jump_multiplier = -30.0
@export var JUMP_VELOCITY:float = 10.0

@export var jump_height:float = 100.0 # Height in pixels
@export var jump_time_to_peak:float = 0.5 # Time in seconds
@export var jump_time_to_descent:float = 0.4
@export var fast_fall_multiplier: float = 0.5

# Magic Math I stole
@export var jump_velocity:float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0 
@export var jump_gravity:float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@export var fall_gravity:float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_descent)) *-1.0

@export var run_top_speed:float = 350.0
@export var run_acceleration:float = 30.0
@export var run_deceleration:float = 40.0

var direction = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta # Apply gravity when airborne
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		
	if Input.is_action_just_released("jump"): # Fast Fall
		velocity.y *= fast_fall_multiplier 
		
	if Input.is_action_pressed("crouch") and is_on_floor(): # Make player stop when crouching
		velocity.x = 0
	# Direction will be equal to 1 if moving right and -1 if moving left
	direction = Input.get_axis("move_left", "move_right") 
	if direction:
		# The run will make the player move towards their inputted direction by the acceleration value
		# The run will never exceed the top speed
		# We multiply the top speed with direction to determine if they're moving right or left, based on
		# if direction is negative or positive
		velocity.x = move_toward(velocity.x, (direction * run_top_speed), run_acceleration)
	else:
		# When the player stops inputting a direction, they will move to a stop (0) by the deceleration value
		velocity.x = move_toward(velocity.x, 0, run_deceleration)
	move_and_slide()

func get_jump_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func jump():
	velocity.y = jump_velocity
