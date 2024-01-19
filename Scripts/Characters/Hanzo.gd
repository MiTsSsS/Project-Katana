extends Enemy

var speed = 200
var player

#Teleport Properties
@onready var teleportTimer = $TeleportCooldown
var teleportRadius = 50
var teleportTimerCooldown = 15

func _ready():
	speed = 200
	player = get_parent().get_node("Character")
	targetDistanceToPlayer = 80
	
func _process(delta):
	if teleportTimer.is_stopped():
		teleport()

func teleport():
	teleportTimer.start()
	var newRandPos = position + Vector2(randi_range(-teleportRadius, teleportRadius), randi_range(-teleportRadius, teleportRadius))

	if newRandPos.x > Globals.WORLD_X or newRandPos.y > Globals.WORLD_Y:
		teleportTimer.wait_time = teleportTimerCooldown
		return
		
	position = newRandPos

func _on_teleport_timeout():
	teleportTimer.wait_time = teleportTimerCooldown
