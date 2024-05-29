extends Control

@onready var outcomeText = $VBoxContainer/Label
@onready var animPlayer = $AnimationPlayer

func _ready():
	hide()
	GameManager.gameEnded.connect(showOutcome)
	
func showOutcome(isVictory):
	get_tree().paused = true

	if isVictory:
		outcomeText.text = "YOU DID NOT DIE!"
		animPlayer.play("glow_victory")
	
	show()

func _on_restart_btn_button_down():
	SceneTransitioner.restartGame()

func _on_back_to_main_menu_btn_button_down():
	SceneTransitioner.transitionFromGameplayToMainMenu()

