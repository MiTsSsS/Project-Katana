extends CharacterBody2D

const BULLET = preload("res://Scenes/Items/Bullet.tscn")

const baseSpeed = 400
@export var speed = 400
@export var dashSpeedScalar = 1.2
@export var dashDuration = 0.2

@onready var attackTimer = $AttackCooldown
@onready var dash = $Dash

func _ready():
	var durationTimer = dash.get_node("DurationTimer")
	durationTimer.timeout.connect(_on_timer_timeout)

func get_input():
	$Gun.look_at(get_global_mouse_position())
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		shoot()
		
	if Input.is_action_just_pressed("dash"):
		dash.startDash(dashDuration)
	
	if dash.isDashing():
		speed = speed * dashSpeedScalar

# Called every frame. 'delta' is the elapsed time since the previous fram
func _physics_process(delta):
	get_input()
	move_and_slide()
	
func shoot():
	get_node("Gun").shoot(attackTimer)
		
func _on_timer_timeout():
	speed = baseSpeed
