extends CharacterBody2D

class_name Player

const BULLET = preload("res://Scenes/Items/Bullet.tscn")
const KATANA = preload("res://Scripts/Items/Weapons/Katana.gd")
const KATANABOOMERANG = preload("res://Scenes/Items/Weapons/BoomerangKatana.tscn")

const baseSpeed = 500
@export var speed = 500
@export var dashSpeedScalar = 1.2
@export var dashDuration = 0.2

@onready var animations = $AnimationPlayer
@onready var attackTimer = $AttackCooldown
@onready var animStateMachine = $AnimationTree.get("parameters/playback")

@onready var dash = $Dash
@onready var FlipMarker:Marker2D = $FlipMarker
@onready var projectileSpawnPoint = $FlipMarker/ProjectileSpawnPoint

@onready var hp = 100
var katanaObj:Katana
var canPerformNextAttack = true

signal positionChanged(newPos)
signal fireSkillActivated(isActive)
signal windSkillActivated(isActive)
signal healthChanged(newHp)
signal skillChanged(skill)
signal dashed(cooldown:float)

var isKatanaFlying = false

func _ready():
	var durationTimer = dash.get_node("DurationTimer")
	durationTimer.timeout.connect(_on_timer_timeout)
	katanaObj = KATANA.new()
	var hud:HUDManager = get_node("../Hud")
	healthChanged.connect(hud.updateHpBar)
	skillChanged.connect(hud.updateSelectedSkill)
	dashed.connect(hud.showDashSkillCooldown)
	
# Called every frame. 'delta' is the elapsed time since the previous fram
func _physics_process(delta):
	get_input()
	move_and_slide()

func get_input():
	if not isKatanaFlying:
		if Input.is_action_just_pressed("attack"):
			if katanaObj.appliedSkill == katanaObj.AppliedSkill.NONE or katanaObj.appliedSkill == katanaObj.AppliedSkill.FIRE:
				animStateMachine.travel("attack_1")
				
			#TODO: Move following code to a function in Katana script
			if katanaObj.appliedSkill == katanaObj.AppliedSkill.WIND:
				animStateMachine.travel("attack_1")
				var ws = katanaObj.WINDSKILL.instantiate()
				ws.transform = projectileSpawnPoint.global_transform
				get_parent().get_parent().add_child(ws)
			
			#TODO: Move following code to a function in Katana script
			if katanaObj.appliedSkill == katanaObj.AppliedSkill.BOOMERANG:
				var bk = KATANABOOMERANG.instantiate()
				bk.global_transform = projectileSpawnPoint.global_transform
				positionChanged.connect(bk.updatePlayerPosition)
				fireSkillActivated.connect(bk.setApplyFire)
				windSkillActivated.connect(bk.setCreateWind)
				bk.signalArrival.connect(setKatanaArrived)
				isKatanaFlying = true
				get_parent().get_parent().add_child(bk)
			
			return

	#TODO: Move following code to a function in Katana script 
	if Input.is_action_just_pressed("select_normal_melee"):
		katanaObj.appliedSkill = katanaObj.AppliedSkill.NONE
		emitSkillActivationSignals(false, false)
		skillChanged.emit(0)
	if Input.is_action_just_pressed("select_fire_skill"):
		katanaObj.appliedSkill = katanaObj.AppliedSkill.FIRE
		emitSkillActivationSignals(false, true)
		skillChanged.emit(1)
	if Input.is_action_just_pressed("select_wind_skill"):
		katanaObj.appliedSkill = katanaObj.AppliedSkill.WIND
		emitSkillActivationSignals(true, false)
		skillChanged.emit(2)
	if Input.is_action_just_pressed("select_boomerang_skill"):
		katanaObj.appliedSkill = katanaObj.AppliedSkill.BOOMERANG
		emitSkillActivationSignals(false, false)
		skillChanged.emit(3)

	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if not dash.isDashing():
		if Input.is_action_just_pressed("left"):
			FlipMarker.scale = Vector2(-1, 1)
		elif Input.is_action_just_pressed("right"):
			FlipMarker.scale = Vector2(1, 1)
	
	positionChanged.emit(global_position)
	
	if velocity == Vector2.ZERO:
		animStateMachine.travel("idle")
	elif velocity != Vector2.ZERO:
		animStateMachine.travel("run")
		
	if Input.is_action_just_presed("dash"):
		dash.startDash(dashDuration)
		dashed.emit(dashDuration)
	
	if dash.isDashing():
		speed = speed * dashSpeedScalar
		
func _on_timer_timeout():
	speed = baseSpeed

func takeDamage(value):
	hp -= value
	animStateMachine.travel("get_hit")
	healthChanged.emit(hp)

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
		
func setKatanaArrived():
	isKatanaFlying = false
	
func emitSkillActivationSignals(isWindActive, isFireActive):
	windSkillActivated.emit(isWindActive)
	fireSkillActivated.emit(isFireActive)
