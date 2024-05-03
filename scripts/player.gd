extends CharacterBody2D


var SPEED = 200.0
const JUMP_VELOCITY = -350.0
var dead = false
var crouching = false
var aircontrol = true
var walljump = false

@onready var timer = $dedtime
@onready var anim = $anim
@onready var standingcol = $standingcol
@onready var crouchingcol = $crouchingcol
@onready var uncrouchcheck = $uncrouchcheck
@onready var leftwall = $leftwall
@onready var rightwall = $rightwall

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if dead :
		return
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		uncrouch()

	if Input.is_action_just_pressed("crouch") and is_on_floor():
		standingcol.disabled = true
		crouchingcol.disabled = false
		crouching = true
		SPEED = 50
		
	if Input.is_action_just_released("crouch") and is_on_floor():
		uncrouch()
		
	var direction = Input.get_axis("mleft", "mright")
	if direction>0:
		anim.flip_h = false
	elif direction<0:
		anim.flip_h = true
	
	if is_on_floor():
		aircontrol = true
		if crouching:
			if direction==0:
				anim.play("crouch_idle")
			else:
				anim.play("crouch_move")
		else:
			if direction==0:
				anim.play("Idle")
			else:
				anim.play("move")
	else:
		if leftwall.is_colliding() and walljump:
			if Input.is_action_just_pressed("jump"):
				velocity.y = 2*JUMP_VELOCITY/3
				velocity.x = 300
				aircontrol = false
			anim.flip_h = false
			anim.play("wallslide")
		elif rightwall.is_colliding() and walljump:
			if Input.is_action_just_pressed("jump"):
				velocity.y = 2*JUMP_VELOCITY/3
				velocity.x = -300
				aircontrol = false
			anim.flip_h = true
			anim.play("wallslide")
		elif velocity.y>0:
			anim.play("fall")
		else:
			anim.play("jump")
		
	if aircontrol:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		if direction:
			velocity.x += direction * 5
		else:
			velocity.x = move_toward(velocity.x, 0, 5)
	velocity.x=clamp(velocity.x, -300, 300)
	move_and_slide()
	
	
func die():
	Engine.time_scale = 0.5
	dead = true
	anim.play("death")
	timer.start()
	
func uncrouch():
	if uncrouchcheck.is_colliding():
		return
	standingcol.disabled = false
	crouchingcol.disabled = true
	crouching = false
	SPEED = 200



func _on_dedtime_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
