extends Node

class_name Fire

@export var target:Enemy

@onready var burnTickTimer := Timer.new()
@onready var burnTimer := Timer.new()

func _init(enemy:Enemy = null):
	target = enemy
	
func _process(delta):
	print(burnTickTimer.time_left)
	if burnTickTimer.time_left == 0:
		target.takeDamage(1)

func _ready():
	add_child(burnTimer)
	add_child(burnTickTimer)
	
	burnTimer.wait_time = 1.0
	burnTickTimer.wait_time = 0.1
	
	burnTimer.one_shot = true
	burnTickTimer.one_shot = false
	
	burnTimer.timeout.connect(_on_burnTimer_timeout)
	#burnTimer.timeout.connect(_on_burnTickTimer_timeout)
	
	burn()
	
func burn():
	burnTimer.start()
	burnTickTimer.start()
	
func _on_burnTimer_timeout():
	pass

#func _on_burnTickTimer_timeout():
	
