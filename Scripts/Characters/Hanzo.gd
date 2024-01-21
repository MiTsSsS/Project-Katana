extends Enemy

var speed = 200
var player

#Teleport Properties
@onready var teleportTimer = $TeleportCooldown
const teleportRadius = 80
const teleportTimerCooldown = 15

#Shuriken Throw Properties
@onready var shurikenSpawnPoint = $Muzzle
@onready var shurikenThrowTimer = $SpecialAttackCooldown
const shurikenThrowCooldown = 1
const SHURIKEN = preload("res://Scenes/Items/Bullet.tscn")

#Clones Cooldown
@onready var clonesTimer = $ClonesCooldown
const clonesCooldown = 30

func _ready():
	speed = 200
	player = get_parent().get_node("Character")
	targetDistanceToPlayer = 80
	
func _process(delta):
	print(shurikenThrowTimer.time_left)
	if teleportTimer.is_stopped():
		teleport()
	if shurikenThrowTimer.is_stopped():
		throwShuriken()

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

func _on_special_attack_cooldown_timeout():
	shurikenThrowTimer.wait_time = shurikenThrowCooldown

#Create Clones
func createClones():
	pass

func _on_clones_cooldown_timeout():
	clonesTimer.wait_time = clonesCooldown
