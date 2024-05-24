extends CharacterBody2D

const SPEED = 100.0
@export var firstmove = -1

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var detection_range = $DetectionRange
@onready var left = $DetectionRange/Left
@onready var right = $DetectionRange/Right
@onready var atck = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var timer = $Timer
@onready var player = get_tree().current_scene.get_node("Player")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var mov:= 0
var free := true
var goto = null

func _ready():
	timer.start()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		mov = 0
	left.disabled = not animated_sprite_2d.flip_h
	right.disabled = animated_sprite_2d.flip_h
	if(detection_range.get_overlapping_bodies().has(player)):
		goto = player.position
		free = false
		
	if goto:
		if abs(position.x-goto.x)<20:
			velocity.x = 0
			goto = null
		
		elif position.x < goto.x:
			velocity.x = SPEED
		else:
			velocity.x = -SPEED
	if free:
		if mov == 0:
			velocity.x = 0
		else :
			velocity.x = mov*SPEED
	if velocity.x == 0:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("move")
		animated_sprite_2d.flip_h = velocity.x<0
	move_and_slide()

func decidemovement():
	pass

func die():
	queue_free()

func _on_timer_timeout():
	mov = firstmove
