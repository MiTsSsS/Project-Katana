extends Enemy

var speed = 200
var player

func _ready():
	speed = 200
	player = get_parent().get_node("Character")
	targetDistanceToPlayer = 80

