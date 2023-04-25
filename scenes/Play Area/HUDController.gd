extends CanvasLayer

# updates Score text
func updateScore(score):
	$ScoreLabel.text = "Score: " + str(score)

# updates Stamina text
func updateStamina(stamina):
	$StaminaLabel.text = "Stamina: " + str(stamina)

# updates coins text
func updateCoins(coins):
	$CoinsLabel.text = "Coins: " + str(coins)
	
# updates difficulty text
func updateDiff(diff):
	$DiffLabel.text = str(diff)
