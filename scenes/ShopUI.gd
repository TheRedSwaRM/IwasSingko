extends Node2D

var shopItem = ""
var itemCost = 0

@export var maxEnergy = 200 # blue bar; how much the character can move before losing stamina
@export var maxSpeed = 700 # how fast the character moves
@export var maxStamina = 300 # green bar; how much the character can take
@export var maxFoodRate = 2 # how fast the food spawns
@export var maxNapInc = 10 # how much napping increases the stamina
@export var maxReqTimer = 60 # how much time before the requirement expires
@export var maxReqScore = 50 # how much score is increased by picking up requirements
@export var maxFoodInc = 50 # how much stamina is restored by picking up food

# purchase increments for each stat
# used to increment values after purchasing
@export var maxEnergyPurch = 10
@export var maxSpeedPurch = 20
@export var maxStaminaPurch = 20
@export var maxFoodRatePurch = 1
@export var maxNapIncPurch = 1
@export var maxReqTimerPurch = 10
@export var maxReqScorePurch = 10
@export var maxFoodIncPurch = 10

# how much upgrading each stat costs
# used in purchasing
@export var maxEnergyCost = 150
@export var maxSpeedCost = 350
@export var maxStaminaCost = 300
@export var maxFoodRateCost = 100
@export var maxNapIncCost = 100
@export var maxReqTimerCost = 150
@export var maxReqScoreCost = 200
@export var maxFoodIncCost = 100
func _ready():
	# sets the text labels
	$CoinsLabel.text = "Coins: " + str(SingletonScript.playerData["player"]["playerCoins"])
	$PlayerStatsLabel/EnergyConLabel.text = "Max Energy: " + str(SingletonScript.playerData["character"]["charEnergyConsumption"])
	$PlayerStatsLabel/SpeedLabel.text = "Speed: " + str(SingletonScript.playerData["player"]["playerMovementSpeed"])
	$PlayerStatsLabel/MaxEnergyLabel.text = "Max Stamina: " + str(SingletonScript.playerData["player"]["playerMaxEnergy"])
	$PlayerStatsLabel/FoodRateLabel.text = "Food Spawn Rate: " + str(SingletonScript.playerData["player"]["playerRateFood"])
	$PlayerStatsLabel/ReqTimerLabel.text = "Requirement Timer: " + str(SingletonScript.playerData["player"]["playerRateReq"])
	$PlayerStatsLabel/NapEnergyLabel.text = "Nap Stamina Increase: " + str(SingletonScript.playerData["character"]["charNapIncrease"])
	$PlayerStatsLabel/ReqScoreLabel.text = "Requirement Score Increase: " + str(SingletonScript.playerData["player"]["playerScoreInc"])
	$PlayerStatsLabel/FoodStamLabel.text = "Food Stamina Increase: " + str(SingletonScript.playerData["player"]["playerFoodInc"])
	
	# sets the sprites of buttons
	CheckMaxVal("Gatorade")
	CheckMaxVal("Candy")
	CheckMaxVal("Kopiko")
	CheckMaxVal("Taho")
	CheckMaxVal("Milk")
	CheckMaxVal("SourStrips")
	CheckMaxVal("Sardinas")
	CheckMaxVal("Toyo-Kalamansi")
	
	#initial text values
	$ItemLabel.text = ""
	$ItemStatsLabel.text = ""
	$ItemCostLabel.text = ""
	$"Purchase Button".disabled = true
	$"Purchase Button".hide()

#called whenever an item description is changed
func ChangeItemDesc(item, cost):
	$"Purchase Button".show()
	$ItemLabel.text = item
	$ItemCostLabel.text = "Cost: " + str(cost)
	if item == "Gatorade":
		$ItemStatsLabel.text = "Increase Max Energy"
		# item does not have max value and can be purchased
		if CheckMaxVal(item) == false:
			$"Purchase Button".disabled = false
			$"Purchase Button/PurchaseLabel".text = "Purchase"
	elif item == "Candy":
		$ItemStatsLabel.text = "Increase Speed"
		# item does not have max value and can be purchased
		if CheckMaxVal(item) == false:
			$"Purchase Button".disabled = false
			$"Purchase Button/PurchaseLabel".text = "Purchase"
	elif item == "Kopiko":
		$ItemStatsLabel.text = "Increase Max Stamina"
		# item does not have max value and can be purchased
		if CheckMaxVal(item) == false:
			$"Purchase Button".disabled = false
			$"Purchase Button/PurchaseLabel".text = "Purchase"
	elif item == "Taho":
		$ItemStatsLabel.text = "Increase Rate of Food Spawn"
		# item does not have max value and can be purchased
		if CheckMaxVal(item) == false:
			$"Purchase Button".disabled = false
			$"Purchase Button/PurchaseLabel".text = "Purchase"
	elif item == "Milk":
		$ItemStatsLabel.text = "Increase Nap Energy Rate"
		# item does not have max value and can be purchased
		if CheckMaxVal(item) == false:
			$"Purchase Button".disabled = false
			$"Purchase Button/PurchaseLabel".text = "Purchase"
	elif item == "Sour Strips":
		$ItemStatsLabel.text = "Lengthen Requirement Timer"
		# item does not have max value and can be purchased
		if CheckMaxVal(item) == false:
			$"Purchase Button".disabled = false
			$"Purchase Button/PurchaseLabel".text = "Purchase"
	elif item == "Sardinas":
		$ItemStatsLabel.text = "Increase Requirement Score"
		# item does not have max value and can be purchased
		if CheckMaxVal(item) == false:
			$"Purchase Button".disabled = false
			$"Purchase Button/PurchaseLabel".text = "Purchase"
	elif item == "Toyo-Kalamansi":
		$ItemStatsLabel.text = "Increase Food Stamina"
		# item does not have max value and can be purchased
		if CheckMaxVal(item) == false:
			$"Purchase Button".disabled = false
			$"Purchase Button/PurchaseLabel".text = "Purchase"
	# changes button to be unclickable if not enough coins
	if SingletonScript.playerData["player"]["playerCoins"] < cost:
		$"Purchase Button".disabled = true
		$"Purchase Button/PurchaseLabel".text = "Not Enough Coins"
# called when item is purchased
# check for cost and coin value is already done beforehand
func PurchaseItem(item, cost):
	#changes values for player's coins
	var newCoins = SingletonScript.playerData["player"]["playerCoins"] - cost
	SingletonScript.SetPlayerCoins(newCoins)
	$CoinsLabel.text = "Coins: " + str(SingletonScript.playerData["player"]["playerCoins"])
	
	var newVal = 0
	# adds from singleton script value
	# changes the text of labels
	# checks if the max value has been reached after purchasing
	if item == "Gatorade":
		newVal = SingletonScript.playerData["character"]["charEnergyConsumption"] + maxEnergyPurch
		SingletonScript.SetCharEnergyConsumption(newVal)
		$PlayerStatsLabel/EnergyConLabel.text = "Max Energy: " + str(SingletonScript.playerData["character"]["charEnergyConsumption"])
		CheckMaxVal(item)
		
	elif item == "Candy":
		newVal = SingletonScript.playerData["player"]["playerMovementSpeed"] + maxSpeedPurch
		SingletonScript.SetPlayerMovementSpeed(newVal)
		$PlayerStatsLabel/SpeedLabel.text = "Speed: " + str(SingletonScript.playerData["player"]["playerMovementSpeed"])
		CheckMaxVal(item)
		
	elif item == "Kopiko":
		newVal = SingletonScript.playerData["player"]["playerMaxEnergy"] + maxStaminaPurch
		SingletonScript.SetPlayerMaxEnergy(newVal)
		$PlayerStatsLabel/MaxEnergyLabel.text = "Max Stamina: " + str(SingletonScript.playerData["player"]["playerMaxEnergy"])
		CheckMaxVal(item)
		
	elif item == "Taho":
		newVal = SingletonScript.playerData["player"]["playerRateFood"] - maxFoodRatePurch
		SingletonScript.SetPlayerFoodRate(newVal)
		$PlayerStatsLabel/FoodRateLabel.text = "Food Spawn Rate: " + str(SingletonScript.playerData["player"]["playerRateFood"])
		CheckMaxVal(item)
		
	elif item == "Milk":
		newVal = SingletonScript.playerData["character"]["charNapIncrease"] + maxNapIncPurch
		SingletonScript.SetCharNapIncrease(newVal)
		$PlayerStatsLabel/NapEnergyLabel.text = "Nap Stamina Increase: " + str(SingletonScript.playerData["character"]["charNapIncrease"])
		CheckMaxVal(item)
		
	elif item == "Sour Strips":
		newVal = SingletonScript.playerData["player"]["playerRateReq"] + maxReqTimerPurch
		SingletonScript.SetPlayerReqRate(newVal)
		$PlayerStatsLabel/ReqTimerLabel.text = "Requirement Timer: " + str(SingletonScript.playerData["player"]["playerRateReq"])
		CheckMaxVal(item)
		
	elif item == "Sardinas":
		newVal = SingletonScript.playerData["player"]["playerScoreInc"] + maxReqScorePurch
		SingletonScript.SetPlayerScoreInc(newVal)
		$PlayerStatsLabel/ReqScoreLabel.text = "Requirement Score Increase: " + str(SingletonScript.playerData["player"]["playerScoreInc"])
		CheckMaxVal(item)
		
	elif item == "Toyo-Kalamansi":
		newVal = SingletonScript.playerData["player"]["playerFoodInc"] + maxFoodIncPurch
		SingletonScript.SetPlayerFoodInc(newVal)
		$PlayerStatsLabel/FoodStamLabel.text = "Food Stamina Increase: " + str(SingletonScript.playerData["player"]["playerFoodInc"])
		CheckMaxVal(item)
	
	# saves player data after having purchased item
	SingletonScript.SavePlayerData()

# checks if maximum value of an item has been reached
# disables purchase button
# changes sprite of button to powered up version
# returns true if max value has been reached; false otherwise
func CheckMaxVal(item):
	if item == "Gatorade":
		if SingletonScript.playerData["character"]["charEnergyConsumption"] >= maxEnergy:
			$"Purchase Button".disabled = true
			$"Purchase Button/PurchaseLabel".text = "Maximum Value Reached"
			$"Gatorade Button/Gatorade Sprite".set_frame(1)
			return true
	elif item == "Candy":
		if SingletonScript.playerData["player"]["playerMovementSpeed"] >= maxSpeed:
			$"Purchase Button".disabled = true
			$"Purchase Button/PurchaseLabel".text = "Maximum Value Reached"
			$"Candy Button/Candy Sprite".set_frame(3)
			return true
	elif item == "Kopiko":
		if SingletonScript.playerData["player"]["playerMaxEnergy"] >= maxStamina:
			$"Purchase Button".disabled = true
			$"Purchase Button/PurchaseLabel".text = "Maximum Value Reached"
			$"Kopiko Button/Kopiko Sprite".set_frame(5)
			return true
	elif item == "Taho":
		if SingletonScript.playerData["player"]["playerRateFood"] <= maxFoodRate:
			$"Purchase Button".disabled = true
			$"Purchase Button/PurchaseLabel".text = "Maximum Value Reached"
			$"Taho Button/Taho Sprite".set_frame(7)
			return true
	elif item == "Milk":
		if SingletonScript.playerData["character"]["charNapIncrease"] >= maxNapInc:
			$"Purchase Button".disabled = true
			$"Purchase Button/PurchaseLabel".text = "Maximum Value Reached"
			$"Milk Button/Milk Sprite".set_frame(9)
			return true
	elif item == "Sour Strips":
		if SingletonScript.playerData["player"]["playerRateReq"] >= maxReqTimer:
			$"Purchase Button".disabled = true
			$"Purchase Button/PurchaseLabel".text = "Maximum Value Reached"
			$"Strips Button/Strips Sprite".set_frame(11)
			return true
	elif item == "Sardinas":
		if SingletonScript.playerData["player"]["playerScoreInc"] >= maxReqScore:
			$"Purchase Button".disabled = true
			$"Purchase Button/PurchaseLabel".text = "Maximum Value Reached"
			$"Sardinas Button/Sardinas Sprite".set_frame(13)
			return true
	elif item == "Toyo-Kalamansi":
		if SingletonScript.playerData["player"]["playerFoodInc"] >= maxFoodInc:
			$"Purchase Button".disabled = true
			$"Purchase Button/PurchaseLabel".text = "Maximum Value Reached"
			$"Toyo Button/Toyo Sprite".set_frame(15)
			return true
	return false
	
func _on_goToMainMenu_button_down():
	get_tree().change_scene_to_file("res://scenes/MainMenuUI.tscn")

func _on_gatorade_button_pressed():
	shopItem = "Gatorade"
	itemCost = maxEnergyCost
	ChangeItemDesc(shopItem, itemCost)

func _on_candy_button_pressed():
	shopItem = "Candy"
	itemCost = maxSpeedCost
	ChangeItemDesc(shopItem, itemCost)


func _on_kopiko_button_pressed():
	shopItem = "Kopiko"
	itemCost = maxStaminaCost
	ChangeItemDesc(shopItem, itemCost)


func _on_taho_button_pressed():
	shopItem = "Taho"
	itemCost = maxFoodRateCost
	ChangeItemDesc(shopItem, itemCost)


func _on_milk_button_pressed():
	shopItem = "Milk"
	itemCost = maxNapIncCost
	ChangeItemDesc(shopItem, itemCost)


func _on_strips_button_pressed():
	shopItem = "Sour Strips"
	itemCost = maxReqTimerCost
	ChangeItemDesc(shopItem, itemCost)


func _on_sardinas_button_pressed():
	shopItem = "Sardinas"
	itemCost = maxReqScoreCost
	ChangeItemDesc(shopItem, itemCost)


func _on_toyo_button_pressed():
	shopItem = "Toyo-Kalamansi"
	itemCost = maxFoodIncCost
	ChangeItemDesc(shopItem, itemCost)

# called when purchase button is pressed
# checks if coins are enough
func _on_purchase_button_pressed():
	if shopItem != "":
		if SingletonScript.playerData["player"]["playerCoins"] < itemCost:
			$"Purchase Button".disabled = true
			$"Purchase Button/PurchaseLabel".text = "Not Enough Coins"
		else:
			PurchaseItem(shopItem, itemCost)

# for testing purposes only; will remove when testing is finished
func _on_reset_data_button_pressed():
	SingletonScript.ResetPlayerData()
	$CoinsLabel.text = "Coins: " + str(SingletonScript.playerData["player"]["playerCoins"])
	$PlayerStatsLabel/EnergyConLabel.text = "Max Energy: " + str(SingletonScript.playerData["character"]["charEnergyConsumption"])
	$PlayerStatsLabel/SpeedLabel.text = "Speed: " + str(SingletonScript.playerData["player"]["playerMovementSpeed"])
	$PlayerStatsLabel/MaxEnergyLabel.text = "Max Stamina: " + str(SingletonScript.playerData["player"]["playerMaxEnergy"])
	$PlayerStatsLabel/FoodRateLabel.text = "Food Spawn Rate: " + str(SingletonScript.playerData["player"]["playerRateFood"])
	$PlayerStatsLabel/ReqTimerLabel.text = "Requirement Timer: " + str(SingletonScript.playerData["player"]["playerRateReq"])
	$PlayerStatsLabel/NapEnergyLabel.text = "Nap Stamina Increase: " + str(SingletonScript.playerData["character"]["charNapIncrease"])
	$PlayerStatsLabel/ReqScoreLabel.text = "Requirement Score Increase: " + str(SingletonScript.playerData["player"]["playerScoreInc"])
	$PlayerStatsLabel/FoodStamLabel.text = "Food Stamina Increase: " + str(SingletonScript.playerData["player"]["playerFoodInc"])
	$ItemLabel.text = ""
	$ItemStatsLabel.text = ""
	$ItemCostLabel.text = ""
