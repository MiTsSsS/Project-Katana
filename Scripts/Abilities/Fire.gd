extends Node

class_name Fire

var target:Enemy

@onready var burnTickTimer := Timer.new()
@onready var burnTimer := Timer.new()

func _init(enemy:Enemy = null):
	target = enemy

func _ready():
	add_child(burnTimer)
	add_child(burnTickTimer)
	
	burnTimer.wait_time = 1.01
	burnTickTimer.wait_time = 0.1
	
	burnTimer.one_shot = true
	burnTickTimer.one_shot = false
	
	burnTimer.timeout.connect(_on_burnTimer_timeout)
	burnTickTimer.timeout.connect(_on_burnTickTimer_timeout)
	
	burn()
	
func burn():
	burnTickTimer.start()
	burnTimer.start()
	
func resetBurnDuration():
	burnTickTimer.start()
	burnTimer.start()
	
func _on_burnTimer_timeout():
	target.setIsOnFire(false)
	queue_free()

func _on_burnTickTimer_timeout():
	target.takeDamage(1)
