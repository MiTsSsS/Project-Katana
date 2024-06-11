extends Control

class_name HUDManager 

#Player character related
@onready var characterHpBar:ProgressBar = $CanvasLayer/CharacterHealthBar
@onready var selectedSkillsBox:HBoxContainer = $CanvasLayer/PanelContainer/SelectedSkills_HB

#Wave info
@onready var wavesRemainingHB:HBoxContainer = $CanvasLayer/WavesRemaining_HB
@onready var enemiesRemainingHB:HBoxContainer = $CanvasLayer/EnemiesRemaining_HB
@onready var waveCountdownHB:HBoxContainer = $CanvasLayer/WaveCountdown_HB

@onready var enemiesRemaining:Label = $CanvasLayer/EnemiesRemaining_HB/EnemiesRemaining
@onready var wavesRemaining:Label = $CanvasLayer/WavesRemaining_HB/WavesRemaining
@onready var maxWaves:Label = $CanvasLayer/WavesRemaining_HB/TotalWaves


#Wave Countdown
@onready var countdownTimerBox = $CanvasLayer/WaveCountdown_HB
@onready var countdownTime:Label = $CanvasLayer/WaveCountdown_HB/WaveCountdown
@onready var countdownTimer:Timer = $WaveCountdown

#Gold
@onready var goldAmnt:Label = $CanvasLayer/GoldCoinCount_HB/GoldAmount_LBL

#Minimap
@onready var minimap = $CanvasLayer/Minimap

var currWaveAmnt:int = 1
var lastSelectedSkill:int = 0 
var startingHp = 100

func _ready():
	GameManager.hudManager = self
	characterHpBar.set_value_no_signal(startingHp)
	wavesRemaining.text = str(currWaveAmnt)
	toggleWaveRelatedUi()

func _process(delta):
	if not countdownTimer.is_stopped():
		var timeLeft:int = ceili(countdownTimer.time_left)
		countdownTime.text = str(timeLeft)

func updateHpBar(newHp):
	if characterHpBar:
		characterHpBar.set_value_no_signal(newHp)

func updateSelectedSkill(skill:int):
	if skill == 1:
		var animText = selectedSkillsBox.get_children()[1] as TextureRect
		var anim = animText.get_texture() as AnimatedTexture
		anim.pause = not anim.pause
		return

	var abilityRect = selectedSkillsBox.get_children()

	abilityRect[lastSelectedSkill].set_color(Color(1.0, 1.0, 1.0))
	abilityRect[skill].set_color(Color(0.5, 0.5, 0.5))
	lastSelectedSkill = skill

func updateRemainingEnemies(enemiesAmnt):
	enemiesRemaining.text = str(enemiesAmnt)

func updateWavesNumber():
	currWaveAmnt += 1
	wavesRemaining.text = str(currWaveAmnt)
	
func setWavesNumber(waveNumb):
	wavesRemaining.text = str(waveNumb)

func setMaxWave(maxWaveAmnt):
	maxWaves.text = str(maxWaveAmnt)

func startCountdownTimer():
	countdownTimerBox.visible = true
	countdownTimer.start()

func showDashSkillCooldown(cooldown:float):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = cooldown
	timer.one_shot = true
	timer.start()
	selectedSkillsBox.get_children()[4].visible = true
	timer.timeout.connect(_on_timer_timeout)

func updateGoldValue(newValue:int):
	goldAmnt.text = str(newValue)

func _on_timer_timeout():
	selectedSkillsBox.get_children()[4].visible = false

func _on_wave_countdown_timeout():
	countdownTimerBox.visible = false
	countdownTimer.wait_time = 60

func toggleWaveRelatedUi():
	if Globals.shouldShowWaveRelatedUi:
		wavesRemainingHB.show()
		enemiesRemainingHB.show()
		waveCountdownHB.show()
	else:
		wavesRemainingHB.hide()
		enemiesRemainingHB.hide()
		waveCountdownHB.hide()
