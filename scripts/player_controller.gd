extends CharacterBody2D
class_name PlayerController

@export var run_top_speed:float = 350.0
@export var JUMP_VELOCITY:float = 10.0

var run_acceleration = 30.0
var run_deceleration = 30.0
var jump_multiplier = -30.0

var direction = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta # Apply gravity when airborne
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * jump_multiplier 
		
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, (direction * run_top_speed), run_acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, run_deceleration)
		
	move_and_slide()
