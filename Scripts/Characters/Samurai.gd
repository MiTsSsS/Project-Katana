extends Enemy

var speed = 200
var player

func _ready():
	player = get_parent().get_node("Character")
	
	#targetDistanceToPlayer = 50

func _physics_process(delta):
	if not player == null:
		look_at(player.global_position)
		var dir = (player.global_position - global_position).normalized()
		move_and_collide(dir * speed * delta)
		
		if global_position.distance_to(player.global_position) < 100:
			attack()
		
func attack():
	player.takeDamage(1)
