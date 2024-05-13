extends Control

class_name HUDManager 

@onready var characterHpBar:ProgressBar = $CanvasLayer/CharacterHealthBar
@onready var selectedSkillsBox:HBoxContainer = $CanvasLayer/SelectedSkills_HB
var lastSelectedSkill:int = 0 
var startingHp = 100

func _ready():
	characterHpBar.set_value_no_signal(startingHp)

func updateHpBar(newHp):
	if(characterHpBar):
		characterHpBar.set_value_no_signal(newHp)

func updateSelectedSkill(skill:int):
	var abilityRect = selectedSkillsBox.get_children()

	abilityRect[lastSelectedSkill].set_color(Color(1.0, 1.0, 1.0))
	abilityRect[skill].set_color(Color(0.5, 0.5, 0.5))
	lastSelectedSkill = skill

func showDashSkillCooldown(cooldown:float):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = cooldown
	timer.one_shot = true
	timer.start()
	selectedSkillsBox.get_children()[4].visible = true
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	selectedSkillsBox.get_children()[4].visible = false
