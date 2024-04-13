extends Control

class_name HUDManager 

@onready var characterHpBar:ProgressBar = $CanvasLayer/ProgressBar

func updateHpBar(oldHp, newHp):
	characterHpBar.set_value_no_signal(newHp)