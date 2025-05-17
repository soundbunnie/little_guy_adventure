extends Node2D
class_name PlayerAnimator

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D

func _process(delta):
	# Flip sprite based on the direction the player is facing
	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true

func play_anim(anim):
	animation_player.play(anim)
