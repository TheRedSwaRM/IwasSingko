extends RigidBody2D

@export var projectile: PackedScene
var rng
var curPos
var prevPause

@onready var char = get_tree().get_first_node_in_group("Character")

var removeObject = false

func _ready():
	rng = RandomNumberGenerator.new()
	$ProjectileTimer.wait_time = SingletonScript.playAreaProjWaitTime

func _process(delta):
	if get_tree().paused == true:
		$ProjectileTimer.stop()
		hide()
	else:
		show()
	
	if get_tree().paused == false and prevPause != get_tree().paused:
		$ProjectileTimer.start()
	prevPause = get_tree().paused
	
func _on_projectile_timer_timeout():
	var spawnedProjectile = projectile.instantiate()
	spawnedProjectile.hide()
	spawnedProjectile.get_node("Sprite2D").set_frame(rng.randi_range(0, 15.0))
	
	# slightly varies rotation of projectile
	
	var direction = self.global_position.direction_to(char.global_position)
	spawnedProjectile.rotation = direction.angle()
	# randomly sets projectile velocity
	var velocity = Vector2(randf_range(SingletonScript.playAreaProjMinSpeed, SingletonScript.playAreaProjMaxSpeed), 0.0)
	# launches projectile at the direction
	spawnedProjectile.linear_velocity = velocity.rotated(direction.angle())
	# adds projectile to scene
	spawnedProjectile.show()
	add_child(spawnedProjectile)


func _on_existence_timer_timeout():
	removeObject = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	if removeObject == true:
		queue_free()
