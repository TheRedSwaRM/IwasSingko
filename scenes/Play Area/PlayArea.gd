extends Node2D


@export var projectile: PackedScene
var score

var pause_scene = load("res://scenes/Play Area/PauseUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	score = 0
	$StartTimer.start()

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout():
	score += 1


func _on_mob_timer_timeout():
	var spawnedProjectile = projectile.instantiate()
	var projectileSpawnLocation = get_node("Character/ProjectilePath/ProjectileSpawnLocation")
	projectileSpawnLocation.progress_ratio = randf()
	var direction = projectileSpawnLocation.rotation + PI / 2
	spawnedProjectile.position = projectileSpawnLocation.position
	direction += randf_range(-PI / 4, PI / 4)
	spawnedProjectile.rotation = direction
	var velocity = Vector2(randf_range(300.0, 700.0), 0.0)
	spawnedProjectile.linear_velocity = velocity.rotated(direction)
	add_child(spawnedProjectile)
