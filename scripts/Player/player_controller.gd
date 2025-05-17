extends CharacterBody2D
class_name PlayerController

@export var stats : PlayerParameters

var direction = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta # Apply gravity when airborne
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
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

func get_jump_gravity() -> float:
	return stats.jump_gravity if velocity.y < 0.0 else stats.fall_gravity
	
func jump():
	velocity.y = stats.jump_velocity
