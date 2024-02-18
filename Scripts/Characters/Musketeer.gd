extends Enemy

@onready var attackCooldownTimer = $AttackCooldown
@onready var specialAttackCooldownTimer = $SpecialAttackCooldown
@onready var attackCooldown = 1
@onready var specialAttackCooldown = 5
@onready var musket = $Gun

var speed = 200
var player

func _ready():
	speed = 200
	player = get_parent().get_node("Character")
	targetDistanceToPlayer = 500
	
func _process(delta):
	if state == State.ATTACKING:
		if not player == null and specialAttackCooldownTimer.is_stopped():
			specialAttack()
		else:
			attack()

func _physics_process(delta):
	if not player == null:
		look_at(player.global_position)
	
		if state == State.CHASING:
			var dir = (player.global_position - global_position).normalized()
			move_and_collide(dir * speed * delta)
		
	if not player == null and global_position.distance_to(player.global_position) < targetDistanceToPlayer:
		state = State.ATTACKING
	else:
		state = State.CHASING
		
func attack():
	if not player == null and attackCooldownTimer.is_stopped():
		musket.shoot(attackCooldownTimer)

func specialAttack():
		musket.specialAttack(specialAttackCooldownTimer)
	
func _on_attack_cooldown_timeout():
	attackCooldownTimer.wait_time = attackCooldown

func _on_special_attack_cooldown_timeout():
	specialAttackCooldownTimer.wait_time = specialAttackCooldown
