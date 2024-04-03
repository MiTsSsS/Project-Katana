extends Enemy

class_name Hanzo

var speed = 200
var player
var isClone = false

#Attack
@onready var attackCooldownTimer:Timer = $AttackCooldown
@onready var attackCooldown:float = 1.1

#Flip
@onready var muzzle:Marker2D = $Muzzle
@onready var flipMarker:Marker2D = $FlipMarker

#Teleport Properties
@onready var teleportTimer = $TeleportCooldown
const teleportRadius = 80
const teleportTimerCooldown = 15

#Shuriken Throw Properties
@onready var shurikenSpawnPoint = $Muzzle
@onready var shurikenThrowTimer = $SpecialAttackCooldown
const shurikenThrowCooldown = 10
const SHURIKEN = preload("res://Scenes/Items/Bullet.tscn")

#Clones Ability Properties
@onready var clonesTimer:Timer = $ClonesCooldown
const clonesCooldown = 30

#Animations
@onready var animStateMachine:AnimationTree = $AnimationTree

func _ready():
	speed = 200
	player = get_parent().get_node("Character")
	targetDistanceToPlayer = 80

func _process(delta):
	if teleportTimer.is_stopped():
		teleport()
	if shurikenThrowTimer.is_stopped():
		throwShuriken()
	if clonesTimer.is_stopped():
		createClones()
	if(state == State.ATTACKING):
		attack()

	print(shurikenThrowTimer.time_left)
		
func _physics_process(delta):
	if player == null:
		return 
	if state == State.CHASING:
		animStateMachine["parameters/conditions/running"] = true
		var dir = (player.global_position - global_position).normalized()
		if dir.x < 0:
			flipMarker.scale = Vector2(-1, 1)
			muzzle.position = Vector2(-9, 23)
			sprite.flip_h = true
		else:
			flipMarker.scale = Vector2(1, 1)
			muzzle.position = Vector2(9, 23)
			sprite.flip_h = false
		move_and_collide(dir * speed * delta)
	if global_position.distance_to(player.global_position) < targetDistanceToPlayer:
		state = State.ATTACKING
		animStateMachine["parameters/conditions/running"] = false
	else:
		state = State.CHASING

#Attack
func attack():
	if not player == null and attackCooldownTimer.is_stopped():
		animStateMachine["parameters/playback"].travel("attack_1")
		attackCooldownTimer.start()

#Teleport
func teleport():
	teleportTimer.start()
	var newRandPos = position + Vector2(randi_range(-teleportRadius, teleportRadius), randi_range(-teleportRadius, teleportRadius))

	if newRandPos.x > Globals.WORLD_X or newRandPos.x < Globals.WORLD_X or newRandPos.y > Globals.WORLD_Y or newRandPos.y < Globals.WORLD_Y:
		teleportTimer.wait_time = teleportTimerCooldown
		return
		
	position = newRandPos

func _on_teleport_timeout():
	teleportTimer.wait_time = teleportTimerCooldown
	
#Shuriken
func throwShuriken():
	shurikenThrowTimer.start()

	animStateMachine["parameters/playback"].travel("shuriken_toss")
	#TODO: Create new state for special attacks, using idle state temporarily to make this work
	state = State.IDLE

	await get_tree().create_timer(0.2).timeout

func launchProjectiles():
	var shuriken1 = SHURIKEN.instantiate()
	var shuriken2 = SHURIKEN.instantiate()
	var shuriken3 = SHURIKEN.instantiate()
	
	get_parent().get_parent().add_child(shuriken1)
	get_parent().get_parent().add_child(shuriken2)
	get_parent().get_parent().add_child(shuriken3)
	
	shuriken1.transform = shurikenSpawnPoint.global_transform
	shuriken2.transform = shurikenSpawnPoint.global_transform
	shuriken2.global_rotation_degrees = shurikenSpawnPoint.global_rotation_degrees + 30
	shuriken3.transform = shurikenSpawnPoint.global_transform
	shuriken3.global_rotation_degrees = shurikenSpawnPoint.global_rotation_degrees - 30
	
	animStateMachine["parameters/conditions/running"] = true

func _on_special_attack_cooldown_timeout():
	shurikenThrowTimer.wait_time = shurikenThrowCooldown

#Create Clones
func createClones():
	if not isClone:
		state = State.ATTACKING 
		
		clonesTimer.start()
		
		var clone = duplicate(8)
		clone.isClone = true
		clone.setHp(5)
		clone.modulate.a = 0.5
		
		get_parent().add_child(clone)
		
		state = State.CHASING

func _on_clones_cooldown_timeout():
	clonesTimer.wait_time = clonesCooldown

func _on_attack_cooldown_timeout():
	attackCooldownTimer.wait_time = attackCooldown
	animStateMachine["parameters/conditions/running"] = true

func _on_first_attack_body_entered(body):
	if body.is_in_group("player"):
		var hitObj := body as Player
		hitObj.takeDamage(15)

func _on_second_attack_body_entered(body):
	if body.is_in_group("player"):
		var hitObj := body as Player
		hitObj.takeDamage(15)
