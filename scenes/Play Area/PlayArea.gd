extends Node2D


@export var projectile: PackedScene
@export var food: PackedScene
@export var coin: PackedScene
@export var req: PackedScene

var score

var pause_scene = load("res://scenes/Play Area/PauseUI.tscn")

# Called when the node enters the scene tree for the first time.
# calls new game function to start the timers for the game
func _ready():
	new_game()

# called when game over state is reached
# unused
func game_over():
	$ScoreTimer.stop()
	$ProjectileTimer.stop()
	$ObjectTimer.stop()

# new game function
# sets score to 0 and starts the start timer
# delay is given so that the player is able to settle into the game before projectiles spawn
func new_game():
	score = 0
	$StartTimer.start()


# called when start timer timeouts
# starts other timers
func _on_start_timer_timeout():
	$ProjectileTimer.start()
	$ObjectTimer.start()
	$ScoreTimer.start()

# score is increased based on how long the player has survived
func _on_score_timer_timeout():
	score += 1

# spawns a projectile for every timeout
func _on_projectile_timer_timeout():
	# spawns projectile
	var spawnedProjectile = projectile.instantiate()
	
	# set location of projectile based on path
	var projectileSpawnLocation = get_node("Character/ProjectilePath/ProjectileSpawnLocation")
	
	# randomizes spawnlocation along path
	projectileSpawnLocation.progress_ratio = randf()
	
	# rotates projectile perpendicular to path
	var direction = projectileSpawnLocation.rotation + PI / 2
	
	# changes projectile position to randomly chosen location
	spawnedProjectile.position = projectileSpawnLocation.position
	
	# randomly changes the direction of projectile
	direction += randf_range(-PI / 4, PI / 4)
	spawnedProjectile.rotation = direction
	
	# randomly sets projectile velocity
	var velocity = Vector2(randf_range(300.0, 700.0), 0.0)
	spawnedProjectile.linear_velocity = velocity.rotated(direction)
	
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
	
	# randomizes object spawn location along object path
	var objSpawnLocation = get_node("Character/ObjectPath/ObjectSpawnLocation")
	objSpawnLocation.progress_ratio = randf()
	spawnedObj.position = objSpawnLocation.position
	
	# adds object to scene
	add_child(spawnedObj)
