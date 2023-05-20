extends CanvasLayer

func _ready():
	$StaminaProgressBar.max_value = SingletonScript.playerData["player"]["playerMaxEnergy"]
	$EnergyProgressBar.max_value = SingletonScript.playerData["character"]["charEnergyConsumption"]
	
# updates Score text
func updateScore(score):
	$ScoreLabel.text = "Score: " + str(score)

# updates Stamina text
func updateStamina(stamina):
	$StaminaProgressBar.value = stamina

# updates coins text
func updateCoins(coins):
	$CoinsLabel.text = "Coins: " + str(coins)
	
# updates difficulty text
func updateDiff(diff):
	$DiffLabel.text = str(diff)

func updateEnergy(energy):
	$EnergyProgressBar.value = energy
