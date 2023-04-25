extends Node

var playerData = {
	"player" : {
		"playerCoins" : 0,
		"playerHighScore" : 0,
		"playerMaxEnergy" : 100,
		"playerMovementSpeed" : 400,
		"playerRateFood" : 1,
		"playerRateReq" : 1
	},
	"controls" : {
		"playerWalkUp" : "Up",
		"playerWalkDown" : "Down",
		"playerWalkRight" : "Right",
		"playerWalkLeft" : "Left",
		"playerSprint" : "Z",
		"playerNap" : "X",
		"playerVolume" : 100
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
		"playerRateFood" : 1,
		"playerRateReq" : 1
	},
	"controls" : {
		"playerWalkUp" : "Up",
		"playerWalkDown" : "Down",
		"playerWalkRight" : "Right",
		"playerWalkLeft" : "Left",
		"playerSprint" : "Z",
		"playerNap" : "X",
		"playerVolume" : 100
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
