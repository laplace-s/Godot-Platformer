extends Node2D

var SPEED = 20
var direction = 1
@onready var left = $left
@onready var right = $right
@onready var animated_sprite_2d = $AnimatedSprite2D

func _process(delta):
	if left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = true
	elif right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("moving")
	if animated_sprite_2d.animation!="default" && SPEED!=0:
		animated_sprite_2d.play("moving")
	position.x += direction*SPEED*delta
	
