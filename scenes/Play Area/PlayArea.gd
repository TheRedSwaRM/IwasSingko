extends Node2D


@export var projectile: PackedScene
@export var food: PackedScene
@export var coin: PackedScene
@export var req: PackedScene
@export var surviveScore = 5 # passive score increase the player gets through surviving
@export var coinValue = 5 # how much coins the player gets when collecting
@export var reqScore = 20 # how much points the player gets when collecting
@export var projMinSpeed = 400.0 # minimum projectile speed
@export var projMaxSpeed = 700.0 # maximum projectile speed

@onready var character = get_tree().get_first_node_in_group("character")

var score
var coins

var paused

signal pause

# Called when the node enters the scene tree for the first time.
# calls new game function to start the timers for the game
func _ready():
	randomize()
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
	$ProjectileTimer.stop()
	$ObjectTimer.stop()
	get_tree().paused = true
	$Character/PauseScene.show()
	$HUD.hide()
	
func resumeGame():
	emit_signal("pause")
	$ScoreTimer.start()
	$ProjectileTimer.start()
	$ObjectTimer.start()
	get_tree().paused = false
	$Character/PauseScene.hide()
	$HUD.show()

# new game function
# sets score to 0 and starts the start timer
# delay is given so that the player is able to settle into the game before projectiles spawn
func newGame():
	score = 0
	coins = 0
	$HUD.updateScore(score)
	$HUD.updateCoins(coins)
	$StartTimer.start()


# called when start timer timeouts
# starts other timers
func _on_start_timer_timeout():
	$ProjectileTimer.start()
	$ObjectTimer.start()
	$ScoreTimer.start()

# score is increased based on how long the player has survived
func _on_score_timer_timeout():
	score += surviveScore
	$HUD.updateScore(score)

# spawns a projectile for every timeout
func _on_projectile_timer_timeout():
	# spawns projectile
	var spawnedProjectile = projectile.instantiate()
	
	# sets random position for the projectile
	spawnedProjectile.position = getRandomPosition()
	
	# points projectile towards character
	var direction = spawnedProjectile.global_position.direction_to(character.global_position)
	
	# slightly varies rotation of projectile
	var randomRotation = randf_range(-PI/4, PI/4)
	spawnedProjectile.rotation = direction.rotated(randomRotation).angle()
	# randomly sets projectile velocity
	var velocity = Vector2(randf_range(projMinSpeed, projMaxSpeed), 0.0)
	# launches projectile at the direction
	spawnedProjectile.linear_velocity = velocity.rotated(direction.rotated(randomRotation).angle())
	
	# adds projectile to scene
	add_child(spawnedProjectile)

# spawns an object for every timeout
func _on_object_timer_timeout():
	# array of objects to spawn
	var objs = [food, coin, req]
	
	# randomly chooses object to spawn
	var chosenObj = objs[randi()% objs.size()]
	
	# spawns object
	var spawnedObj = chosenObj.instantiate()
	
	#sets random position for object to spawn
	spawnedObj.position = getRandomPosition()
	
	# adds object to scene
	add_child(spawnedObj)

# selectsts a random position offscreen to spawn
func getRandomPosition():
	# used to get random distance away from screen
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	# left or right side spawn with slight variance
	var x_choices = [(character.global_position.x - vpr.x/2) * randf_range(1.1, 1.4),  (character.global_position.x + vpr.x/2) * randf_range(1.1, 1.4)]
	# up or down side spawn with slight variance
	var y_choices = [(character.global_position.y - vpr.y/2) * randf_range(1.1, 1.4),  (character.global_position.y + vpr.y/2) * randf_range(1.1, 1.4)]
	
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
	if type == "coin":
		coins += coinValue
		$HUD.updateCoins(coins)

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
