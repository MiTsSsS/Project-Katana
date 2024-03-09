extends Enemy

@onready var animStateMachine = $AnimationTree.get("parameters/playback")
@onready var attackCooldownTimer = $AttackCooldown
@onready var attackCooldown = 0.2

var speed = 200
var player

func _ready():
	player = get_parent().get_node("Character")
	targetDistanceToPlayer = 80
	
func _process(delta):
	if state == State.ATTACKING:
		attack()

func _physics_process(delta):
	if not player == null and state == State.CHASING:
		animStateMachine.travel("run")
		var dir = (player.global_position - global_position).normalized()
		move_and_collide(dir * speed * delta)
		
	if not player == null and global_position.distance_to(player.global_position) < targetDistanceToPlayer:
		state = State.ATTACKING
	else:
		state = State.CHASING
		
func attack():
	if not player == null and attackCooldownTimer.is_stopped():
		animStateMachine.travel("attack_1")
		attackCooldownTimer.start()
		player.takeDamage(1)
		
func takeDamage(damage):
	animStateMachine.travel("get_hit")
	hp -= damage
	print(hp)
	
	if hp <= 0:
		animStateMachine.travel("die")
	
func _on_attack_cooldown_timeout():
	attackCooldownTimer.wait_time = attackCooldown
	
func destroySamurai():
	queue_free()
