extends Interactable

@onready var shopUI = $CanvasLayer/PanelContainer

#Interactibility
@onready var isLeaving:bool = false

#Shop Functionatily
var randomizedItems

func _ready():
	var collection: Collection = Collection.new("res://Tables/ShopItems.tableCollection.res")
	
	if !collection.has_table("ShopItem"):
		push_error("The table 'ShopItem' doesn't exist!")
		return
	 
	var datatable: Datatable = collection.get_table("ShopItem")
	 
	if !datatable.has_item("Speed"):
		push_error("The table 'ShopItem' doesn't have 'Speed' key!")
		return
	
	var speed: Dictionary = datatable.get_item("Speed")	
	var damage: Dictionary = datatable.get_item("Damage")
	var dashCooldown: Dictionary = datatable.get_item("DashCooldown") 
	var maxHp: Dictionary = datatable.get_item("MaxHp") 
	var heal: Dictionary = datatable.get_item("Heal") 
	
	var allItems = [speed, damage, dashCooldown, maxHp, heal]
	allItems.shuffle()
	
	randomizedItems = [allItems[0], allItems[1], allItems[3]]

	initItemsUi()

#Merchant Interact
func _on_interact_body_entered(body:Node2D):
	interactionProperties(body, false)

func _on_interact_body_exited(body:Node2D):
	interactionProperties(body, true)
	shopUI.visible = false

func _on_leave_interact_body_entered(body):
	interactionProperties(body, false)
	isLeaving = true
	Globals.updateTimeBetweenWaves(4)

func _on_leave_interact_body_exited(body):
	interactionProperties(body, true)
	isLeaving = false

func interactedWith():
	print(isLeaving)
	if not isLeaving:
		shopUI.visible = true
	else:
		Globals.setShouldShowWaveRelatedUi(true)
		SceneTransitioner.transitionToScene("res://Scenes/TestScene.tscn")

func interactionProperties(body, exiting):
	if body.is_in_group("player"):
		var player:Player = body as Player
		player.setupInteractionProperties()
		if exiting:
			player.interactableObject = null
		else:
			player.interactableObject = self
	
func initItemsUi():
	var itemsHolder:HBoxContainer = $CanvasLayer/PanelContainer/ShopItems_HB

	for n in 3:
		var shopItemUi = itemsHolder.get_children()[n]
		shopItemUi.get_node("ItemName").text = randomizedItems[n]["itemname"]
		shopItemUi.get_node("ItemDescription").text = "Increase by " + str(randomizedItems[n]["itemvalue"])
		shopItemUi.get_node("Button").text = "Buy for " + str(randomizedItems[n]["cost"])
		shopItemUi.get_node("Button").disabled =  randomizedItems[n]["cost"] > Globals.gold

func onButtonClick(chosenItemPos:int):
	var itemId:String = randomizedItems[chosenItemPos]["id"]
	var itemCost:int = randomizedItems[chosenItemPos]["cost"]
	Globals.updateGold(-itemCost)
	checkPurchasableItems()
	
	match itemId:
		"MH":
			Globals.updateMaxHp(5)
		"SP":
			Globals.updateSpeed(500)
		"DC":
			Globals.updateDashCooldown(1)
		"HE":
			Globals.heal(20)
		"DA":
			Globals.updateDamage(1000)

func checkPurchasableItems():
	var itemsHolder:HBoxContainer = $CanvasLayer/PanelContainer/ShopItems_HB
	for n in 3:
		var shopItemUi = itemsHolder.get_children()[n]
		shopItemUi.get_node("Button").disabled =  randomizedItems[n]["cost"] > Globals.gold

func _on_first_item_button_down():
	onButtonClick(0)
	
func _on_second_item_button_down():
	onButtonClick(1)
	
func _on_third_item_button_down():
	onButtonClick(2)

