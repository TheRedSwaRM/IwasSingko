extends Node2D

var shopItem = ""
var itemCost = 0

func _ready():
	$CoinsLabel.text = "Coins: " + str(SingletonScript.playerData["player"]["playerCoins"])
	$PlayerStatsLabel/EnergyConLabel.text = "Energy Consumption: " + str(SingletonScript.playerData["character"]["charEnergyConsumption"])
	$PlayerStatsLabel/SpeedLabel.text = "Speed: " + str(SingletonScript.playerData["player"]["playerMovementSpeed"])
	$PlayerStatsLabel/MaxEnergyLabel.text = "Max Energy: " + str(SingletonScript.playerData["player"]["playerMaxEnergy"])
	$PlayerStatsLabel/FoodRateLabel.text = "Food Spawn Rate: " + str(SingletonScript.playerData["player"]["playerRateFood"])
	$PlayerStatsLabel/ReqTimerLabel.text = "Requirement Timer: " + str(SingletonScript.playerData["player"]["playerRateReq"])
	$PlayerStatsLabel/NapEnergyLabel.text = "Nap Energy Increase: " + str(SingletonScript.playerData["character"]["charNapIncrease"])
	$PlayerStatsLabel/ReqScoreLabel.text = "Requirement Score Increase: " + str(SingletonScript.playerData["player"]["playerScoreInc"])
	$PlayerStatsLabel/FoodStamLabel.text = "Food Stamina Increase: " + str(SingletonScript.playerData["player"]["playerFoodInc"])
	$ItemLabel.text = ""
	$ItemStatsLabel.text = ""
	$ItemCostLabel.text = ""
	
func ChangeItemDesc(item, cost):
	$ItemLabel.text = item
	$ItemCostLabel.text = "Cost: " + str(cost)
	if item == "Gatorade":
		$ItemStatsLabel.text = "Lessen Energy Consumption"
	elif item == "Candy":
		$ItemStatsLabel.text = "Increase Speed"
	elif item == "Kopiko":
		$ItemStatsLabel.text = "Increase Max Energy"
	elif item == "Taho":
		$ItemStatsLabel.text = "Increase Food Spawn Rate"
	elif item == "Milk":
		$ItemStatsLabel.text = "Increase Nap Energy Rate"
	elif item == "Sour Strips":
		$ItemStatsLabel.text = "Lengthen Requirement Timer"
	elif item == "Sardinas":
		$ItemStatsLabel.text = "Increase Requirement Score"
	elif item == "Toyo-Kalamansi":
		$ItemStatsLabel.text = "Increase Food Stamina"

func PurchaseItem(item, cost):
	var newCoins = SingletonScript.playerData["player"]["playerCoins"] - cost
	SingletonScript.SetPlayerCoins(newCoins)
	$CoinsLabel.text = "Coins: " + str(SingletonScript.playerData["player"]["playerCoins"])
	
	var newVal = 0
	
	if item == "Gatorade":
		newVal = SingletonScript.playerData["character"]["charEnergyConsumption"] + 10
		SingletonScript.SetCharEnergyConsumption(newVal)
		$PlayerStatsLabel/EnergyConLabel.text = "Energy Consumption: " + str(SingletonScript.playerData["character"]["charEnergyConsumption"])
	elif item == "Candy":
		newVal = SingletonScript.playerData["player"]["playerMovementSpeed"] + 50
		SingletonScript.SetPlayerMovementSpeed(newVal)
		$PlayerStatsLabel/SpeedLabel.text = "Speed: " + str(SingletonScript.playerData["player"]["playerMovementSpeed"])
	elif item == "Kopiko":
		newVal = SingletonScript.playerData["player"]["playerMaxEnergy"] + 25
		SingletonScript.SetPlayerMaxEnergy(newVal)
		$PlayerStatsLabel/MaxEnergyLabel.text = "Max Energy: " + str(SingletonScript.playerData["player"]["playerMaxEnergy"])
	elif item == "Taho":
		newVal = SingletonScript.playerData["player"]["playerRateFood"] - 0.1
		SingletonScript.SetPlayerFoodRate(newVal)
		$PlayerStatsLabel/FoodRateLabel.text = "Food Spawn Rate: " + str(SingletonScript.playerData["player"]["playerRateFood"])
	elif item == "Milk":
		newVal = SingletonScript.playerData["character"]["charNapIncrease"] + 1
		SingletonScript.SetCharNapIncrease(newVal)
		$PlayerStatsLabel/NapEnergyLabel.text = "Nap Energy Increase: " + str(SingletonScript.playerData["character"]["charNapIncrease"])
	elif item == "Sour Strips":
		newVal = SingletonScript.playerData["player"]["playerRateReq"] + 1
		SingletonScript.SetPlayerReqRate(newVal)
		$PlayerStatsLabel/ReqTimerLabel.text = "Requirement Timer: " + str(SingletonScript.playerData["player"]["playerRateReq"])
	elif item == "Sardinas":
		newVal = SingletonScript.playerData["player"]["playerScoreInc"] + 10
		SingletonScript.SetPlayerScoreInc(newVal)
		$PlayerStatsLabel/ReqScoreLabel.text = "Requirement Score Increase: " + str(SingletonScript.playerData["player"]["playerScoreInc"])
	elif item == "Toyo-Kalamansi":
		newVal = SingletonScript.playerData["player"]["playerFoodInc"] + 10
		SingletonScript.SetPlayerFoodInc(newVal)
		$PlayerStatsLabel/FoodStamLabel.text = "Food Stamina Increase: " + str(SingletonScript.playerData["player"]["playerFoodInc"])
	
	SingletonScript.SavePlayerData()
	
func _on_goToMainMenu_button_down():
	get_tree().change_scene_to_file("res://scenes/MainMenuUI.tscn")
	pass # Replace with function body.


func _on_gatorade_button_pressed():
	shopItem = "Gatorade"
	itemCost = 500
	ChangeItemDesc(shopItem, itemCost)

func _on_candy_button_pressed():
	shopItem = "Candy"
	itemCost = 300
	ChangeItemDesc(shopItem, itemCost)


func _on_kopiko_button_pressed():
	shopItem = "Kopiko"
	itemCost = 250
	ChangeItemDesc(shopItem, itemCost)


func _on_taho_button_pressed():
	shopItem = "Taho"
	itemCost = 600
	ChangeItemDesc(shopItem, itemCost)


func _on_milk_button_pressed():
	shopItem = "Milk"
	itemCost = 500
	ChangeItemDesc(shopItem, itemCost)


func _on_strips_button_pressed():
	shopItem = "Sour Strips"
	itemCost = 150
	ChangeItemDesc(shopItem, itemCost)


func _on_sardinas_button_pressed():
	shopItem = "Sardinas"
	itemCost = 350
	ChangeItemDesc(shopItem, itemCost)


func _on_toyo_button_pressed():
	shopItem = "Toyo-Kalamansi"
	itemCost = 50
	ChangeItemDesc(shopItem, itemCost)


func _on_purchase_button_pressed():
	if shopItem != "":
		PurchaseItem(shopItem, itemCost)


func _on_reset_data_button_pressed():
	SingletonScript.ResetPlayerData()
	$CoinsLabel.text = "Coins: " + str(SingletonScript.playerData["player"]["playerCoins"])
	$PlayerStatsLabel/EnergyConLabel.text = "Energy Consumption: " + str(SingletonScript.playerData["character"]["charEnergyConsumption"])
	$PlayerStatsLabel/SpeedLabel.text = "Speed: " + str(SingletonScript.playerData["player"]["playerMovementSpeed"])
	$PlayerStatsLabel/MaxEnergyLabel.text = "Max Energy: " + str(SingletonScript.playerData["player"]["playerMaxEnergy"])
	$PlayerStatsLabel/FoodRateLabel.text = "Food Spawn Rate: " + str(SingletonScript.playerData["player"]["playerRateFood"])
	$PlayerStatsLabel/ReqTimerLabel.text = "Requirement Timer: " + str(SingletonScript.playerData["player"]["playerRateReq"])
	$PlayerStatsLabel/NapEnergyLabel.text = "Nap Energy Increase: " + str(SingletonScript.playerData["character"]["charNapIncrease"])
	$PlayerStatsLabel/ReqScoreLabel.text = "Requirement Score Increase: " + str(SingletonScript.playerData["player"]["playerScoreInc"])
	$PlayerStatsLabel/FoodStamLabel.text = "Food Stamina Increase: " + str(SingletonScript.playerData["player"]["playerFoodInc"])
	$ItemLabel.text = ""
	$ItemStatsLabel.text = ""
	$ItemCostLabel.text = ""
