extends Node2D


@export var projectile: PackedScene
@export var food: PackedScene
@export var coin: PackedScene
@export var req: PackedScene

var surviveScore = 5 # passive score increase the player gets through surviving
var coinValue = 5 # how much coins the player gets when collecting
var reqScore = 20 # how much points the player gets when collecting
var projMinSpeed = 400.0 # minimum projectile speed
var projMaxSpeed = 700.0 # maximum projectile speed

var score
var coins
var rng

var paused

signal pause

# Called when the node enters the scene tree for the first time.
# calls new game function to start the timers for the game
func _ready():
	rng = RandomNumberGenerator.new()
	newGame()
	paused = false

func _process(delta):
	if Input.is_action_just_released("pause"):
		if paused == false:
			paused = true
			pauseGame()
		else:
			paused = false
			resumeGame()
			

func pauseGame():
	emit_signal("pause")
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$CoinTimer.stop()
	$FoodTimer.stop()
	$ReqTimer.stop()
	get_tree().paused = true
	$Character/PauseScene.show()
	$HUD.hide()
	
func resumeGame():
	emit_signal("pause")
	$ScoreTimer.start()
	$EnemyTimer.start()
	$CoinTimer.start()
	$FoodTimer.start()
	$ReqTimer.start()
	get_tree().paused = false
	$Character/PauseScene.hide()
	$HUD.show()

# new game function
# sets score to 0 and starts the start timer
# delay is given so that the player is able to settle into the game before projectiles spawn
func newGame():
	score = 0
	coins = 0
	$FoodTimer.wait_time = SingletonScript.playerData["player"]["playerRateFood"]
	$HUD.updateScore(score)
	$HUD.updateCoins(coins)
	SingletonScript.SetPlayAreaCoins(coins)
	$HUD.updateDiff(SingletonScript.playAreaDifficulty)
	playAreaSetDifficulty(SingletonScript.playAreaDifficulty)
	$StartTimer.start()


# called when start timer timeouts
# starts other timers
func _on_start_timer_timeout():
	$EnemyTimer.start()
	$CoinTimer.start()
	$FoodTimer.start()
	$ReqTimer.start()
	$ScoreTimer.start()

# score is increased based on how long the player has survived
func _on_score_timer_timeout():
	score += surviveScore
	$HUD.updateScore(score)
	SingletonScript.SetPlayAreaScore(score)

# selectsts a random position offscreen to spawn
func getRandomPosition():
	# used to get random distance away from screen
	var vpr = get_viewport_rect().size * randf_range(1.2, 1.5)
	# left or right side spawn with slight variance
	var x_choices = [($Character.global_position.x - vpr.x/2) * randf_range(1.2, 1.5),  ($Character.global_position.x + vpr.x/2) * randf_range(1.2, 1.5)]
	# up or down side spawn with slight variance
	var y_choices = [($Character.global_position.y - vpr.y/2) * randf_range(1.2, 1.5),  ($Character.global_position.y + vpr.y/2) * randf_range(1.2, 1.5)]
	
	# randomly chooses which combination of sides
	var x_spawn = x_choices[randi_range(-1,1)]
	var y_spawn = y_choices[randi_range(-1,1)]
	
	# returns coordinates
	return Vector2(x_spawn,y_spawn)

# signal reciever for object from character; used to modify score and coins
func _on_character_obj(type):
	if type == "req":
		score += reqScore
		$HUD.updateScore(score)
		SingletonScript.SetPlayAreaScore(score)
	if type == "coin":
		coins += coinValue
		$HUD.updateCoins(coins)
		SingletonScript.SetPlayerCoins(SingletonScript.playerData["player"]["playerCoins"] + coinValue)

# character sends game over signal and UI changes to gameover
func _on_character_game_over():
	get_tree().change_scene_to_file("res://scenes/GameOverUI.tscn")

# character has a change in stamina value and needs to update HUD
func _on_character_stamina_changed(stamina):
	if stamina <= 0:
		_on_character_game_over()
	$HUD.updateStamina(stamina)


func _on_resume_button_down():
	resumeGame()
	
func playAreaSetDifficulty(diff):
	if diff == "Easy":
		surviveScore = 5
		coinValue = 5
		reqScore = 20 + SingletonScript.playerData["player"]["playerScoreInc"]
		SingletonScript.SetPlayAreaProjMinSpeed(200.0)
		SingletonScript.SetPlayAreaProjMaxSpeed(500.0)
		SingletonScript.SetPlayAreaProjWaitTime(3)
	elif diff == "Normal":
		surviveScore = 10
		coinValue = 10
		reqScore = 30 + SingletonScript.playerData["player"]["playerScoreInc"]
		SingletonScript.SetPlayAreaProjMinSpeed(500.0)
		SingletonScript.SetPlayAreaProjMaxSpeed(700.0)
		SingletonScript.SetPlayAreaProjWaitTime(2)
	elif diff == "Hard":
		surviveScore = 15
		coinValue = 15
		reqScore = 40 + SingletonScript.playerData["player"]["playerScoreInc"]
		SingletonScript.SetPlayAreaProjMinSpeed(700.0)
		SingletonScript.SetPlayAreaProjMaxSpeed(1000.0)
		SingletonScript.SetPlayAreaProjWaitTime(1)


func _on_coin_timer_timeout():
		# spawns object
	var spawnedCoin = coin.instantiate()
	
	#sets random position for object to spawn
	spawnedCoin.global_position = getRandomPosition()
	
	# adds object to scene
	add_child(spawnedCoin)


func _on_food_timer_timeout():
	var spawnedFood = food.instantiate()
	
	#sets random position for object to spawn
	spawnedFood.global_position = getRandomPosition()
	spawnedFood.get_node("Sprite2D").set_frame(rng.randi_range(0, 15.0))
	
	# adds object to scene
	add_child(spawnedFood)


func _on_req_timer_timeout():
	var spawnedReq = req.instantiate()
	
	#sets random position for object to spawn
	spawnedReq.global_position = getRandomPosition()
	spawnedReq.get_node("Sprite2D").set_frame(rng.randi_range(0, 11.0))
	
	# adds object to scene
	add_child(spawnedReq)


func _on_enemy_timer_timeout():
	# spawns projectile
	var spawnedProjectile = projectile.instantiate()
	spawnedProjectile.hide()
	# sets random position for the projectile
	spawnedProjectile.global_position = getRandomPosition()
	
	# points projectile towards character
	var direction = spawnedProjectile.global_position.direction_to($Character.global_position)
	
	# slightly varies rotation of projectile
	var randomRotation = randf_range(-PI/4, PI/4)
	spawnedProjectile.rotation = direction.rotated(randomRotation).angle()
	# randomly sets projectile velocity
	var velocity = Vector2(randf_range(projMinSpeed, projMaxSpeed), 0.0)
	# launches projectile at the direction
	spawnedProjectile.linear_velocity = velocity.rotated(direction.rotated(randomRotation).angle())
	
	# adds projectile to scene
	spawnedProjectile.show()
	add_child(spawnedProjectile)
