extends CharacterBody2D


#MOVEMENT PARAMETERS
var SPEED = 200.0
const JUMP_VELOCITY = -350.0
const MAX_SPEED_X = 300
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var debugMode = false

#STATE PARAMETERS
var dead = false
var crouching = false
var aircontrol = true
var doublejumped = false
var nocontrol = false

#ABILITIES
var walljump = false:
	set(value):
		walljump = value
		ui.notify("You can now jump while sliding on walls")
var attack = false:
	set(value):
		attack = value
		ui.notify("Attack with the spacebar button")
var doublejump = false:
	set(value):
		doublejump = value
		ui.notify("You can now jump again midair.")

#Attack hitboxes
@onready var attack_1_l = $Attacks/attack1_L
@onready var attack_1_r = $Attacks/attack1_R
@onready var attacks = $Attacks

#Player hitboxes
@onready var standingcol = $standingcol
@onready var crouchingcol = $crouchingcol

#Proximity raychecks (for walls and roofs)
@onready var uncrouchcheck = $uncrouchcheck
@onready var leftwall = $leftwall
@onready var rightwall = $rightwall

@onready var timer = $dedtime
@onready var anim = $anim
@onready var ui = get_tree().current_scene.get_node("UI")



func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if dead or nocontrol:
		move_and_slide()
		return
		
	if Input.is_action_just_pressed("dash"):
		if anim.animation == "crouching":
			dash()
			pass
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		uncrouch()
	if velocity.y>-100 and Input.is_action_just_pressed("jump") and not doublejumped and doublejump:
		doublejumped = true
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		standingcol.disabled = true
		crouchingcol.disabled = false
		crouching = true
		SPEED = 50
		
	if Input.is_action_just_released("crouch") and is_on_floor():
		uncrouch()
		
	if Input.is_action_just_pressed("attack") and attack and anim.animation !="attack2":
		attackAct()
		
	var direction = Input.get_axis("mleft", "mright")
	if direction>0:
		anim.flip_h = false
	elif direction<0:
		anim.flip_h = true
	if (anim.animation == "attack1" or anim.animation == "attack2") and anim.frame_progress < 1:
		attackanim()
	elif is_on_floor():
		doublejumped = false
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
				velocity.x = MAX_SPEED_X
				aircontrol = false
			anim.flip_h = false
			anim.play("wallslide")
			if velocity.y > 100:
				velocity.y = lerp(velocity.y, 100.0, 0.1)
		elif rightwall.is_colliding() and walljump:
			if Input.is_action_just_pressed("jump"):
				velocity.y = 2*JUMP_VELOCITY/3
				velocity.x = -MAX_SPEED_X
				aircontrol = false
			anim.flip_h = true
			anim.play("wallslide")
			if velocity.y > 100:
				velocity.y = lerp(velocity.y, 100.0, 0.1)
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
	velocity.x=clamp(velocity.x, -MAX_SPEED_X, MAX_SPEED_X)
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

func attackAct():
	anim.play("attack1")
	
func attackanim():
	if anim.animation=="attack1":
		if anim.frame == 1:
			attacks.detecting = true
			if anim.flip_h :
				attack_1_l.disabled = false
			else:
				attack_1_r.disabled = false
		else:
			attack_1_r.disabled = true
			attack_1_l.disabled = true
			attacks.detecting = true
		if anim.frame > 1 and Input.is_action_just_pressed("attack"):
			anim.play("attack2")
	elif anim.animation=="attack2":
		if anim.frame == 2:
			attacks.detecting = true
			if anim.flip_h :
				attack_1_l.disabled = false
			else:
				attack_1_r.disabled = false
		else:
			attacks.detecting = false
			attack_1_l.disabled = true
			attack_1_r.disabled = true

func dash():
	nocontrol = true
	anim.play("slide")
	
