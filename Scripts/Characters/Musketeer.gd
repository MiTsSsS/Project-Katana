extends Enemy

@onready var animStateMachine = $AnimationTree
@onready var attackCooldownTimer = $AttackCooldown
@onready var attackCooldown = 1
@onready var specialAttackCooldownTimer = $SpecialAttackCooldown
@onready var specialAttackCooldown = 5
@onready var musket = $Gun

var speed = 200
var player
var dead = false
var canAttack = true

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
	if player == null:
		return
	
	if state == State.CHASING:
		var dir = (player.global_position - global_position).normalized()
		move_and_collide(dir * speed * delta)
		animStateMachine["parameters/conditions/running"] = true
		
	if not player == null and global_position.distance_to(player.global_position) < targetDistanceToPlayer:
		animStateMachine["parameters/conditions/running"] = false
		state = State.ATTACKING
	else:
		state = State.CHASING
	
	musket.look_at(player.global_position)
		
func attack():
	if not player == null and not dead and attackCooldownTimer.is_stopped():
		canAttack = false
		musket.shoot(attackCooldownTimer)
		animStateMachine["parameters/playback"].travel("attack_1")
	else:
		animStateMachine["parameters/conditions/running"] = true
		
func takeDamage(damage):
	animStateMachine["parameters/conditions/get_hit"] = true

	hp -= damage
	print("Archer HP: ")
	print(hp)
	if hp <= 0 and not dead:
		dead = true
		animStateMachine["parameters/conditions/died"] = true

func specialAttack():
	if not dead:
		musket.specialAttack(specialAttackCooldownTimer)

func _on_special_attack_cooldown_timeout():
	specialAttackCooldownTimer.wait_time = specialAttackCooldown
	
func attackAnimationEnded():
	canAttack = true
	
func destroyMusketeer():
	queue_free()

func _on_animation_tree_animation_finished(get_hit):
		animStateMachine["parameters/conditions/get_hit"] = false
