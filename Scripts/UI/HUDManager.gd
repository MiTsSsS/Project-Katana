extends Control

class_name HUDManager 

@onready var characterHpBar:ProgressBar = $CanvasLayer/CharacterHealthBar
@onready var selectedSkillsBox:HBoxContainer = $CanvasLayer/SelectedSkills_HB
var lastSelectedSkill:int = 0 

func updateHpBar(newHp):
	characterHpBar.set_value_no_signal(newHp)

func updateSelectedSkill(skill:int):
	var abilityRect = selectedSkillsBox.get_children()

	abilityRect[lastSelectedSkill].set_color(Color(1.0, 1.0, 1.0))
	abilityRect[skill].set_color(Color(0.5, 0.5, 0.5))
	lastSelectedSkill = skill