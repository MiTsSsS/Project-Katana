extends Node2D

const BULLET = preload("res://Scenes/Items/Bullet.tscn")

func shoot(attackTimer):
	if attackTimer.is_stopped():
		var bullet = BULLET.instantiate()
		get_parent().get_parent().add_child(bullet)
		bullet.transform = $Muzzle.global_transform
		attackTimer.start()

func specialAttack(specialAttackTimer):
	if specialAttackTimer.is_stopped():
		specialAttackTimer.start()
		for n in range(4):
			var bullet = BULLET.instantiate()
			get_parent().get_parent().add_child(bullet)
			bullet.transform = $Muzzle.global_transform
			await get_tree().create_timer(0.2, false).timeout
	else:
		pass
