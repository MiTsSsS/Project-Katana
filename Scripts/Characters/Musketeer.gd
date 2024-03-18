extends Enemy

@onready var animStateMachine = $AnimationTree
@onready var attackCooldownTimer = $AttackCooldown
@onready var specialAttackCooldownTimer = $SpecialAttackCooldown
@onready var attackCooldown = 1
@onready var specialAttackCooldown = 5
@onready var musket = $Gun

var speed = 200
var player
var dead = false

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
	
		if state == State.CHASING:
			var dir = (player.global_position - global_position).normalized()
			move_and_collide(dir * speed * delta)
			animStateMachine["parameters/conditions/running"] = true
		
	if not player == null and global_position.distance_to(player.global_position) < targetDistanceToPlayer:
		animStateMachine["parameters/conditions/running"] = false
		state = State.ATTACKING
	else:
		state = State.CHASING
		
func attack():
	if not player == null and attackCooldownTimer.is_stopped() and not dead:
		animStateMachine["parameters/playback"].travel("attack_1")
		musket.shoot(attackCooldownTimer)
		
func takeDamage(damage):
	animStateMachine["parameters/conditions/running"] = false
	animStateMachine["parameters/conditions/attack_1"] = false
	hp -= damage
	print("Samurai HP: ")
	print(hp)
	if hp <= 0 and not dead:
		dead = true
		animStateMachine["parameters/conditions/died"] = true

func specialAttack():
	if not dead:
		musket.specialAttack(specialAttackCooldownTimer)
	
func _on_attack_cooldown_timeout():
	attackCooldownTimer.wait_time = attackCooldown

func _on_special_attack_cooldown_timeout():
	specialAttackCooldownTimer.wait_time = specialAttackCooldown
	
func attackAnimationEnded():
	animStateMachine["parameters/conditions/attack_1"] = false
	
func destroyMusketeer():
	queue_free()
