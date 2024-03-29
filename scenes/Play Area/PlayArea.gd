extends Node2D


@export var enemies: Array[PackedScene]
@export var food: PackedScene
@export var coin: PackedScene
@export var req: PackedScene
@export var boss: PackedScene

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

var bossDiff

var tilemap1
var tilemap2

# Called when the node enters the scene tree for the first time.
# calls new game function to start the timers for the game
func _ready():
	rng = RandomNumberGenerator.new()
	newGame()
	paused = false
	bossDiff = 0
	$FoodTimer.wait_time = SingletonScript.playerData["player"]["playerRateFood"]
	tilemap1 = $TileMapBackground1
	tilemap2 = $TileMapBackground2

func _process(delta):
	if Input.is_action_just_released("pause"):
		if paused == false:
			paused = true
			pauseGame()
		else:
			paused = false
			resumeGame()
	var req = get_tree().get_first_node_in_group("req")
	if req == null:
		spawnReq()

func pauseGame():
	emit_signal("pause")
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$CoinTimer.stop()
	$FoodTimer.stop()
	get_tree().paused = true
	$Character/PauseScene.show()
	$HUD.hide()
	
func resumeGame():
	emit_signal("pause")
	$ScoreTimer.start()
	$EnemyTimer.start()
	$CoinTimer.start()
	$FoodTimer.start()
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
	$HUD.updateEnergy(SingletonScript.playerData["character"]["charEnergyConsumption"])
	$HUD.updateStamina(SingletonScript.playerData["player"]["playerMaxEnergy"])

# called when start timer timeouts
# starts other timers
func _on_start_timer_timeout():
	$EnemyTimer.start()
	$CoinTimer.start()
	$FoodTimer.start()
	$ScoreTimer.start()

# score is increased based on how long the player has survived
func _on_score_timer_timeout():
	score += surviveScore
	$HUD.updateScore(score)
	SingletonScript.SetPlayAreaScore(score)

# selectsts a random position offscreen to spawn
func getRandomPosition(up = true, down = true, left = true, right = true):
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	var top_left = Vector2($Character.global_position.x - vpr.x/2, $Character.global_position.y - vpr.y/2)
	var bottom_right = Vector2($Character.global_position.x + vpr.x/2, $Character.global_position.y + vpr.y/2)
	var pos_side = []
	if up:
		pos_side.append("up")
	if down:
		pos_side.append("down")
	if right:
		pos_side.append("right")
	if left:
		pos_side.append("left")
	
	var get_rand = randi() % pos_side.size()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side[get_rand]:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = Vector2(bottom_right.x, top_left.y)
		"down":
			spawn_pos1 = Vector2(top_left.x, bottom_right.y)
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = Vector2(bottom_right.x, top_left.y)
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = Vector2(top_left.x, bottom_right.y)
	
	var x_spawn = clampf(randf_range(spawn_pos1.x, spawn_pos2.x), -6000.0, 7000.0)
	var y_spawn = clampf(randf_range(spawn_pos2.y, spawn_pos2.y), -3500.0, 4300.0)
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

# function that sets the values of the play area depending on the difficulty set
func playAreaSetDifficulty(diff):
	if diff == "Easy":
		surviveScore = 5
		coinValue = 5
		reqScore = 20 + SingletonScript.playerData["player"]["playerScoreInc"]
		SingletonScript.SetPlayAreaProjMinSpeed(200.0)
		SingletonScript.SetPlayAreaProjMaxSpeed(300.0)
		SingletonScript.SetPlayAreaProjWaitTime(3)
	elif diff == "Normal":
		surviveScore = 10
		coinValue = 10
		reqScore = 30 + SingletonScript.playerData["player"]["playerScoreInc"]
		SingletonScript.SetPlayAreaProjMinSpeed(500.0)
		SingletonScript.SetPlayAreaProjMaxSpeed(700.0)
		SingletonScript.SetPlayAreaProjWaitTime(2)
	elif diff == "Hard":
		surviveScore = 20
		coinValue = 20
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


func spawnReq():
	var spawnedReq = req.instantiate()
	
	#sets random position for object to spawn
	spawnedReq.global_position = getRandomPosition()
	spawnedReq.get_node("Sprite2D").set_frame(rng.randi_range(0, 11.0))
	
	# adds object to scene
	add_child(spawnedReq)


func _on_enemy_timer_timeout():
	# spawns projectile
	var spawnedEnemy = enemies[randi() % enemies.size()].instantiate()
	spawnedEnemy.hide()
	# sets random position for the projectile
	spawnedEnemy.global_position = getRandomPosition()
	
	# points projectile towards character
	var direction = spawnedEnemy.global_position.direction_to($Character.global_position)
	
	# slightly varies rotation of projectile
	var randomRotation = randf_range(-PI/8, PI/8)
	spawnedEnemy.rotation = direction.rotated(randomRotation).angle()
	# randomly sets projectile velocity
	var velocity = Vector2(randf_range(projMinSpeed, projMaxSpeed), 0.0)
	# launches projectile at the direction
	spawnedEnemy.linear_velocity = velocity.rotated(direction.rotated(randomRotation).angle())
	if $Character.global_position.x - spawnedEnemy.global_position.x < 0:
		spawnedEnemy.get_node("Sprite2D").set_flip_h(true)
	if $Character.global_position.y - spawnedEnemy.global_position.y < 0:
		spawnedEnemy.get_node("Sprite2D").set_flip_v(true)
	
	# adds projectile to scene
	spawnedEnemy.show()
	add_child(spawnedEnemy)


func _on_boss_timer_timeout():
	var spawnedBoss = boss.instantiate()
	spawnedBoss.hide()
	# sets random position for the projectile
	spawnedBoss.global_position = getRandomPosition()
	spawnedBoss.SetBossDifficulty(bossDiff)
	bossDiff += 1
	# adds projectile to scene
	spawnedBoss.show()
	add_child(spawnedBoss)


func _on_character_energy_changed(energy):
	$HUD.updateEnergy(energy)


func _on_move_tile_map_area_exited(area):
	if area.is_in_group("Character"):
		tilemap2.global_position = $Character.global_position
		self.move_child(tilemap2, 0)
		self.move_child(tilemap1, 1)


func _on_move_tile_map2_area_exited(area):
	if area.is_in_group("Character"):
		tilemap1.global_position = $Character.global_position
		self.move_child(tilemap1, 0)
		self.move_child(tilemap2, 1)
