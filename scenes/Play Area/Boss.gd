extends RigidBody2D

@export var projectile: PackedScene

@onready var char = get_tree().get_first_node_in_group("Character")

var rng
var prevPause

var projectileNum
var projectiles

var speed

func _ready():
	rng = RandomNumberGenerator.new()
	projectiles = 0

func _process(delta):
	if get_tree().paused == true:
		hide()
	else:
		show()
		
		if char.global_position.x - self.global_position.x < 0:
			$Sprite2D.set_flip_h(true)
		else:
			$Sprite2D.set_flip_h(false)
			
		self.global_position = self.global_position.move_toward(char.global_position, speed*delta)
	
	if get_tree().paused == false and prevPause != get_tree().paused:
		$ProjectileTimer.start()
	prevPause = get_tree().paused

func SetBossDifficulty(num):
	var numDiff = num % 3
	$Sprite2D.set_frame(numDiff)
	if numDiff == 0:
		projectileNum = num + 1
		speed = 100.0 + (num * 50)
		$CooldownTimer.wait_time = 5 - (num * 0.25)
	elif numDiff == 1:
		projectileNum = num + 2
		speed = 150.0 + (num * 50)
		$CooldownTimer.wait_time = 4 - (num * 0.25)
	else:
		projectileNum = num + 3
		speed = 200.0 + (num * 50)
		$CooldownTimer.wait_time = 3 - (num * 0.25)

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
	get_parent().add_child(spawnedProjectile)
	spawnedProjectile.global_position = self.global_position
	
	projectiles += 1
	if projectiles < projectileNum:
		$ProjectileTimer.start()
	else:
		$CooldownTimer.start()
		projectiles = 0


func _on_cooldown_timer_timeout():
	$ProjectileTimer.start()


func _on_body_entered(body):
	if body.is_in_group("food"):
		body.queue_free()
	print("ouch")
