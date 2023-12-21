extends CharacterBody2D

class_name Player

const BULLET = preload("res://Scenes/Items/Bullet.tscn")

const baseSpeed = 500
@export var speed = 500
@export var dashSpeedScalar = 1.2
@export var dashDuration = 0.2

@onready var attackTimer = $AttackCooldown
@onready var dash = $Dash
@onready var katana = $Sprite2D/Katana
@onready var hp = 100

var canPerformNextAttack = true

func _ready():
	var durationTimer = dash.get_node("DurationTimer")
	durationTimer.timeout.connect(_on_timer_timeout)
	
# Called every frame. 'delta' is the elapsed time since the previous fram
func _physics_process(delta):
	get_input()
	move_and_slide()
	#look_at(get_global_mouse_position())

func get_input():
	if Input.is_action_just_pressed("attack"):
		if canPerformNextAttack:
			canPerformNextAttack = false
			katana.swing()

	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if not dash.isDashing():
		if Input.is_action_just_pressed("left"):
			$Sprite2D.rotation = deg_to_rad(-90)
		elif Input.is_action_just_pressed("right"):
			$Sprite2D.rotation = deg_to_rad(90)
		elif Input.is_action_just_pressed("down"):
			$Sprite2D.rotation = deg_to_rad(180)
		elif Input.is_action_just_pressed("up"):
			$Sprite2D.rotation = 0

	if Input.is_action_just_pressed("dash"):
		dash.startDash(dashDuration)
	
	if dash.isDashing():
		speed = speed * dashSpeedScalar
		
func _on_timer_timeout():
	speed = baseSpeed

func _on_katana_completed_current_attack_animation():
	canPerformNextAttack  = true
	
func takeDamage(value):
	hp -= value
	print(hp)
	
	if(hp <= 0):
		queue_free()
