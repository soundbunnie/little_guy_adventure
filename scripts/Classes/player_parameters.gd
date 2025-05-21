class_name PlayerParameters
extends Resource

@export_group("Jump Parameters")
@export var jump_height:float = 100.0 # Height in pixels
@export var jump_time_to_peak:float = 0.5 # Time in seconds
@export var jump_time_to_descent:float = 0.4
@export var fast_fall_multiplier: float = 0.5
@export var coyote_frames: float = 7 # Time in frames

@export_group("Run Parameters")
@export var run_top_speed:float = 350.0
@export var run_acceleration:float = 30.0
@export var run_deceleration:float = 40.0
