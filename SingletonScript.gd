extends Node

var playerData = {
	"player" : {
		"playerCoins" : 0,
		"playerHighScore" : 0,
		"playerMaxEnergy" : 100,
		"playerMovementSpeed" : 400,
		"playerRateFood" : 10,
		"playerRateReq" : 1,
		"playerScoreInc" : 10,
		"playerFoodInc" : 10
	},
	"character" : {
		"charEnergyConsumption" : 50,
		"charNapIncrease" : 3
	},
	"controls" : {
		"playerWalkUp" : 0,
		"playerWalkDown" : 0,
		"playerWalkRight" : 0,
		"playerWalkLeft" : 0,
		"playerSprint" : 0,
		"playerNap" : 0,
		"playerVolume" : 0
	}
}

# play area stats
var playAreaDifficulty
var playAreaScore
var playAreaCoins

func _ready():
	LoadPlayerData()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# takes player data from save file
# currently hardcoded
func NewPlayerData():
	return {
	"player" : {
		"playerCoins" : 0,
		"playerHighScore" : 0,
		"playerMaxEnergy" : 100,
		"playerMovementSpeed" : 400,
		"playerRateFood" : 10,
		"playerRateReq" : 1,
		"playerScoreInc" : 10,
		"playerFoodInc" : 10
	},
	"character" : {
		"charEnergyConsumption" : 50,
		"charNapIncrease" : 3
	},
	"controls" : {
		"playerWalkUp" : 0,
		"playerWalkDown" : 0,
		"playerWalkRight" : 0,
		"playerWalkLeft" : 0,
		"playerSprint" : 0,
		"playerNap" : 0,
		"playerVolume" : 0
	}
}

func SavePlayerData():
	var playerSaveFile = FileAccess.open("user://player.save", FileAccess.WRITE)
	playerSaveFile.store_var(playerData)

func LoadPlayerData():
	if FileAccess.file_exists("user://player.save"):
		print("file found")
		var playerSaveFile = FileAccess.open("user://player.save", FileAccess.READ)
		playerData = playerSaveFile.get_var()
	else:
		print("file not found")
		playerData = NewPlayerData()

func ResetPlayerData():
	playerData = NewPlayerData()
	SavePlayerData()

# sets play area difficulty from select difficulty scene
func SetPlayAreaDifficulty(diff):
	playAreaDifficulty = diff
	
# sets play area score from play area scene
func SetPlayAreaScore(score):
	playAreaScore = score
	
# sets play area coins from play area scene
func SetPlayAreaCoins(coins):
	playAreaCoins = coins
	
# set player coins
func SetPlayerCoins(coins):
	playerData["player"]["playerCoins"] = coins
	
# set player high score
func SetPlayerHighScore(score):
	playerData["player"]["playerHighScore"] = score
	
func SetCharEnergyConsumption(val):
	playerData["character"]["charEnergyConsumption"] = val
	
func SetCharNapIncrease(val):
	playerData["character"]["charNapIncrease"] = val

func SetPlayerMovementSpeed(val):
	playerData["player"]["playerMovementSpeed"] = val
	
func SetPlayerMaxEnergy(val):
	playerData["player"]["playerMaxEnergy"] = val
	
func SetPlayerFoodRate(val):
	playerData["player"]["playerRateFood"] = val
	
func SetPlayerReqRate(val):
	playerData["player"]["playerRateReq"] = val
	
func SetPlayerScoreInc(val):
	playerData["player"]["playerScoreInc"] = val

func SetPlayerFoodInc(val):
	playerData["player"]["playerFoodInc"] = val

func SetControlsPlayerVolume(val):
	playerData["controls"]["playerVolume"] = val

func SetControlsPlayerWalkUp(val):
	playerData["controls"]["playerWalkUp"] = val
	
func SetControlsPlayerWalkDown(val):
	playerData["controls"]["playerWalkDown"] = val

func SetControlsPlayerWalkLeft(val):
	playerData["controls"]["playerWalkLeft"] = val
	
func SetControlsPlayerWalkRight(val):
	playerData["controls"]["playerWalkRight"] = val
	
func SetControlsPlayerSprint(val):
	playerData["controls"]["playerSprint"] = val
	
func SetControlsPlayerNap(val):
	playerData["controls"]["playerNap"] = val
