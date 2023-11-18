extends Node2D

const BULLET = preload("res://Scenes/Items/Bullet.tscn")

func shoot(attackTimer):
	if attackTimer.is_stopped():
		var bullet = BULLET.instantiate()
		get_parent().get_parent().add_child(bullet)
		bullet.transform = $Muzzle.global_transform
		attackTimer.start()
	else:
		pass
