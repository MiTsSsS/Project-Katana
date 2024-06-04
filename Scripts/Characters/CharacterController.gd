extends CharacterBody2D

class_name Player

@onready var yoooo = $AudioStreamPlayer2D

const BULLET = preload("res://Scenes/Items/Bullet.tscn")
const KATANA = preload("res://Scripts/Items/Weapons/Katana.gd")
const KATANABOOMERANG = preload("res://Scenes/Items/Weapons/BoomerangKatana.tscn")
const FLOATINGDAMAGE = preload("res://Scenes/UI/FloatingText.tscn")
const DASHGHOST = preload("res://Scenes/Characters/CharacterGhost.tscn")
const floatingDamageSpawnRangeMin = -30
const floatingDamageSpawnRangeMax = 30
const MAXHP = 100

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

@onready var hitFlash:ShaderMaterial = $FlipMarker/Sprite2D.material

@onready var hp = 100
var katanaObj:Katana
var canPerformNextAttack = true

#Collectibles
@onready var gold:int = 0

#Interact
@onready var interactLabel:Label = $FToInteract
@onready var canInteract:bool = false
@onready var interactableObject:Interactable = null

signal positionChanged(newPos)
signal fireSkillActivated(isActive)
signal windSkillActivated(isActive)
signal healthChanged(newHp)
signal skillChanged(skill)
signal dashed(cooldown:float)
signal goldModified(newValue:int)

var isKatanaFlying = false
var minimapIcon = "player"

func _ready():
	var durationTimer = dash.get_node("DurationTimer")
	durationTimer.timeout.connect(_on_timer_timeout)
	katanaObj = KATANA.new()

	#HUD setup
	var hud:HUDManager = get_node("../Hud")
	if hud:
		healthChanged.connect(hud.updateHpBar)
		skillChanged.connect(hud.updateSelectedSkill)
		dashed.connect(hud.showDashSkillCooldown)
		goldModified.connect(hud.updateGoldValue)
		hud.startingHp = hp
		await get_tree().process_frame
		hud.minimap.player = self
	
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
		
	if Input.is_action_just_pressed("dash"):
		dash.startDash(dashDuration)
		dashed.emit(dashDuration)
	
	if dash.isDashing():
		var ghost = DASHGHOST.instantiate()
		ghost.position = position

		if(direction.x < 0):
			ghost.get_node("Sprite2D").flip_h = true
		
		get_parent().add_child(ghost)
		speed = speed * dashSpeedScalar

	if Input.is_action_just_pressed("interact") and canInteract:
		interactableObject.interactedWith()
		
func _on_timer_timeout():
	speed = baseSpeed

func takeDamage(value):
	hp -= value
	animStateMachine.travel("get_hit")
	healthChanged.emit(hp)

	if(hp <= 0):
		yoooo.play()
		GameManager.gameEnded.emit(false)

	hitFlash.set_shader_parameter("active", true)
	await get_tree().create_timer(.1, false).timeout
	hitFlash.set_shader_parameter("active", false)
	createFloatingText(value, Color.RED)

func heal(value):
	var newHp = hp + value
	hp = clampi(newHp, 0, MAXHP)
	healthChanged.emit(hp)

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
		hitObj.takeDamage(1000)
		
func setKatanaArrived():
	isKatanaFlying = false
	
func modifyGold(value):
	gold += value
	clampi(gold, 0, 999)
	goldModified.emit(gold)
	createFloatingText(value, Color.YELLOW)

func emitSkillActivationSignals(isWindActive, isFireActive):
	windSkillActivated.emit(isWindActive)
	fireSkillActivated.emit(isFireActive)

func createFloatingText(value:int, color:Color):
	var fd = FLOATINGDAMAGE.instantiate()
	fd.position.x = randf_range(floatingDamageSpawnRangeMin, floatingDamageSpawnRangeMax)
	add_child(fd)
	fd.updateValue(value, color)

#Interact
func setupInteractionProperties():
	interactLabel.visible = not interactLabel.visible
	canInteract = not canInteract
