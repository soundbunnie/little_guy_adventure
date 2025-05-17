class_name PlayerParameters
extends Resource

@export_group("Jump Parameters")
@export var jump_height:float = 100.0 # Height in pixels
@export var jump_time_to_peak:float = 0.5 # Time in seconds
@export var jump_time_to_descent:float = 0.4
@export var fast_fall_multiplier: float = 0.5
# Magic Math I stole
@export var jump_velocity:float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0 
@export var jump_gravity:float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@export var fall_gravity:float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_descent)) *-1.0

@export_group("Run Parameters")
@export var run_top_speed:float = 350.0
@export var run_acceleration:float = 30.0
@export var run_deceleration:float = 40.0
