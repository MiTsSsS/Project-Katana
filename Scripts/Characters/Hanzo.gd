extends Enemy

class_name Hanzo

var speed = 200
var player
var isClone = false

#Teleport Properties
@onready var teleportTimer = $TeleportCooldown
const teleportRadius = 80
const teleportTimerCooldown = 15

#Shuriken Throw Properties
@onready var shurikenSpawnPoint = $Muzzle
@onready var shurikenThrowTimer = $SpecialAttackCooldown
const shurikenThrowCooldown = 1
const SHURIKEN = preload("res://Scenes/Items/Bullet.tscn")

#Clones Ability Properties
@onready var clonesTimer = $ClonesCooldown
const clonesCooldown = 30

func _ready():
	speed = 200
	player = get_parent().get_node("Character")
	targetDistanceToPlayer = 80
	if isClone:
		print("hello this clone ready")
		print(player == null)
	
func _process(delta):
	if teleportTimer.is_stopped():
		teleport()
	if shurikenThrowTimer.is_stopped():
		throwShuriken()
	if clonesTimer.is_stopped():
		createClones()

func _physics_process(delta):
	if not player == null and state == State.CHASING:
		look_at(player.global_position)
		var dir = (player.global_position - global_position).normalized()
		move_and_collide(dir * speed * delta)

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
	
	state = State.ATTACKING
	
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
	
	await get_tree().create_timer(0.2).timeout
	state = State.CHASING

func _on_special_attack_cooldown_timeout():
	shurikenThrowTimer.wait_time = shurikenThrowCooldown

#Create Clones
func createClones():
	if not isClone:
		state = State.ATTACKING
		
		clonesTimer.start()
		
		var clone = duplicate(8)
		print("created")
		clone.isClone = true
		clone.setHp(5)
		clone.modulate.a = 0.5
		
		get_parent().add_child(clone)
		clone.transform = $Muzzle.global_transform
		
		state = State.CHASING

func _on_clones_cooldown_timeout():
	clonesTimer.wait_time = clonesCooldown
