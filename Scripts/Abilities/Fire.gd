extends Node

class_name Fire

var burnTickTimer := Timer.new()
var burnTimer := Timer.new()
var target:Enemy

#TODO Create constructor to initialize target enemy that will be taking the burn


func _ready():
	add_child(burnTimer)
	add_child(burnTickTimer)
	
	burnTimer.wait_time = 1.0
	burnTickTimer.wait_time = 0.1
	
	burnTimer.one_shot = true
	burnTickTimer.one_shot = false
	
	burnTimer.timeout.connect(_on_burnTimer_timeout)
	burnTimer.timeout.connect(_on_burnTickTimer_timeout)
	
func burn(target:Enemy):
	burnTimer.start()
	burnTickTimer.start()

func _on_burnTimer_timeout():
	queue_free()

func _on_burnTickTimer_timeout():
	pass
