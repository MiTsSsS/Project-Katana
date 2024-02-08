extends CharacterBody2D

class_name Player

const BULLET = preload("res://Scenes/Items/Bullet.tscn")
const KATANA = preload("res://Scripts/Items/Weapons/Katana.gd")
const KATANABOOMERANG = preload("res://Art/VFX/Items/Katana/KatanaBoomerang.png")

const baseSpeed = 500
@export var speed = 500
@export var dashSpeedScalar = 1.2
@export var dashDuration = 0.2

@onready var animations = $AnimationPlayer
@onready var attackTimer = $AttackCooldown
@onready var animStateMachine = $AnimationTree.get("parameters/playback")
@onready var dash = $Dash
@onready var hp = 100
var katanaObj:Katana

var canPerformNextAttack = true

func _ready():
	var durationTimer = dash.get_node("DurationTimer")
	durationTimer.timeout.connect(_on_timer_timeout)
	katanaObj = KATANA.new()
	
# Called every frame. 'delta' is the elapsed time since the previous fram
func _physics_process(delta):
	get_input()
	move_and_slide()

func get_input():
	if Input.is_action_just_pressed("attack"):
		animStateMachine.travel("attack_1")
		#TODO: Move following code to a function in Katana script
		if katanaObj.appliedSkill == katanaObj.AppliedSkill.WIND:
			var ws = katanaObj.WINDSKILL.instantiate()
			get_parent().get_parent().add_child(ws)
			ws.transform = $WindSpawnPoint.global_transform
		return

	#TODO: Move following code to a function in Katana script 
	if Input.is_action_just_pressed("select_normal_melee"):
		katanaObj.appliedSkill = katanaObj.AppliedSkill.NONE
	if Input.is_action_just_pressed("select_fire_skill"):
		katanaObj.appliedSkill = katanaObj.AppliedSkill.FIRE
	if Input.is_action_just_pressed("select_wind_skill"):
		katanaObj.appliedSkill = katanaObj.AppliedSkill.WIND
	if Input.is_action_just_pressed("select_boomerang_skill"):
		katanaObj.appliedSkill = katanaObj.AppliedSkill.BOOMERANG

	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if not dash.isDashing():
		if Input.is_action_just_pressed("left"):
			$Sprite2D.flip_h = true
			$WindSpawnPoint.position = Vector2(-35, 0)
			$WindSpawnPoint.scale.x = -1
		elif Input.is_action_just_pressed("right"):
			$WindSpawnPoint.position = Vector2(35, 0)
			$WindSpawnPoint.scale.x = 1
			$Sprite2D.flip_h = false
	
	if velocity == Vector2.ZERO:
		animStateMachine.travel("idle")
	elif velocity != Vector2.ZERO:
		animStateMachine.travel("run")
		
	if Input.is_action_just_pressed("dash"):
		dash.startDash(dashDuration)
	
	if dash.isDashing():
		speed = speed * dashSpeedScalar
		
func _on_timer_timeout():
	speed = baseSpeed

func takeDamage(value):
	hp -= value
	
	if(hp <= 0):
		queue_free()

func _on_first_strike_area_body_entered(body):
		if body.is_in_group("mobs"):
			var hitObj := body as Enemy
			hitObj.takeDamage(15)
			#TODO: Move following code to a function in Katana script
			if katanaObj.appliedSkill == katanaObj.AppliedSkill.FIRE:
				var fs = katanaObj.FIRESKILL.new(hitObj)
				hitObj.add_child(fs)
				hitObj.fireNode = fs
				hitObj.setIsOnFire(true)

func _on_second_strike_area_body_entered(body):
		if body.is_in_group("mobs"):
			var hitObj := body as Enemy
			hitObj.takeDamage(15)
