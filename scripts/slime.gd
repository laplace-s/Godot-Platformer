extends Node2D

var SPEED = 20
var direction = 1
var isded = false
@export var drop : Area2D;
@onready var left = $left
@onready var right = $right
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var kill_zone = $KillZone

func _physics_process(delta):
	if isded :
		if animated_sprite_2d.animation == "death" and animated_sprite_2d.frame_progress == 1:
			queue_free()
		return
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
	
func die():
	kill_zone.queue_free()
	isded = true
	if drop:
		var item = load("res://scenes/powerups/doublejump.tscn")
		var instance = item.instantiate()
		instance.position = position + Vector2(0, -10)
		add_sibling(instance)
	animated_sprite_2d.play("death")
	
	
