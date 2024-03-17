extends Enemy

@onready var flipMarker:Marker2D = $FlipMarker

@onready var animStateMachine = $AnimationTree
@onready var attackCooldownTimer = $AttackCooldown
@onready var attackCooldown = 0.2

var speed = 200
var dead = false

var player

func _ready():
	player = get_parent().get_node("Character")
	targetDistanceToPlayer = 80
	
func _process(delta):
	if state == State.ATTACKING:
		attack()

func _physics_process(delta):
	if not player == null and state == State.CHASING and not dead:
		animStateMachine["parameters/conditions/running"] = true
		var dir = (player.global_position - global_position).normalized()
		print(dir) 
		if dir.x < 0:
			flipMarker.scale = Vector2(-1, 1)
			sprite.flip_h = true
		else:
			flipMarker.scale = Vector2(1, 1)
			sprite.flip_h = false
		
		move_and_collide(dir * speed * delta)
			
	if not player == null and global_position.distance_to(player.global_position) < targetDistanceToPlayer and not dead:
		state = State.ATTACKING
		animStateMachine["parameters/conditions/running"] = false
	else:
		state = State.CHASING
		
func attack():
	if not player == null and attackCooldownTimer.is_stopped():
		animStateMachine["parameters/playback"].travel("attack_1")
		attackCooldownTimer.start()
		
func takeDamage(damage):
	animStateMachine["parameters/conditions/running"] = false
	animStateMachine["parameters/conditions/attack_1"] = false
	hp -= damage
	print("Samurai HP: ")
	print(hp)
	if hp <= 0 and not dead:
		dead = true
		animStateMachine["parameters/conditions/died"] = true

func _on_attack_cooldown_timeout():
	attackCooldownTimer.wait_time = attackCooldown
	 
func destroySamurai():
	queue_free()

func _on_first_attack_body_entered(body):
	if body.is_in_group("player"):
		var hitObj := body as Player
		hitObj.takeDamage(15)

func _on_second_attack_body_entered(body):
	if body.is_in_group("player"):
		var hitObj := body as Player
		hitObj.takeDamage(15)

func attackAnimationEnded():
	animStateMachine["parameters/conditions/attack_1"] = false
