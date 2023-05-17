extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var baseStamina = 100 # HP/Stamina

# tired values that can be easily changed
@export var baseTired = 50 # tired counter to count the distance from previous position to current
@export var tiredMultiplier = 0.2 # modifies distance to make it more reasonable
@export var tiredDec = 1 # stamina decreased when tired distance is filled

# nap increment to determine 
@export var napInc = 3

@export var hurtDamage = 10 # damage that projectile deals
@export var foodStamina = 20 # stamina that food restores
@export var reqStamina = 10 # stamina cost for collecting a requirement


@onready var collision = $CollisionShape2D
@onready var collisionTimer = $CollisionTimer

var stamina
var tired
var prevPosition
var napping
var paused

signal staminaChanged(stamina)
signal obj(type)
signal gameOver

# init variables
func _ready():
	baseStamina = SingletonScript.playerData["player"]["playerMaxEnergy"]
	speed = SingletonScript.playerData["player"]["playerMovementSpeed"]
	baseTired = SingletonScript.playerData["character"]["charEnergyConsumption"]
	napInc = SingletonScript.playerData["character"]["charNapIncrease"]
	foodStamina = SingletonScript.playerData["player"]["playerFoodInc"]
	stamina = baseStamina
	tired = baseTired
	prevPosition = position
	napping = false
	paused = false

func _process(delta):
	if paused == false:
		var velocity = Vector2.ZERO # The player's movement vector.
		# movement controls
		if napping == false:
			if Input.is_action_pressed("move_right"):
				velocity.x += 1
			if Input.is_action_pressed("move_left"):
				velocity.x -= 1
			if Input.is_action_pressed("move_down"):
				velocity.y += 1
			if Input.is_action_pressed("move_up"):
				velocity.y -= 1
			
		# animation
		if velocity == Vector2.ZERO:
			$AnimationTree.get("parameters/playback").travel("idle")
		else:
			$AnimationTree.get("parameters/playback").travel("walk")
			$AnimationTree.set("parameters/idle/blend_position", velocity)
			$AnimationTree.set("parameters/walk/blend_position", velocity)
			
		# sprint controls
		# doubles movement speed if sprint is held
		# tired bar is based off of position difference so no additional code for tiredness here
		var movementSpeed = speed
		if Input.is_action_pressed("sprint"):
			movementSpeed *= 2

		# nap controls
		if Input.is_action_pressed("nap"):
			# sets character to unable to move
			movementSpeed = 0
			$AnimationTree.get("parameters/playback").travel("nap")
			# checks if napping was set to true already so that nap timer does not constantly restart itself
			if napping == false:
				napping = true
				$NapTimer.start()
		# if nap button was released, nap timer is cancelled
		if Input.is_action_just_released("nap"):
			$NapTimer.stop()
			napping = false
		
		# velocity is used to implement diagonal movement
		# also covers the case where two keys towards the opposite direction are pressed at the same time
		if velocity.length() > 0:
			velocity = velocity.normalized() * movementSpeed
		position += velocity * delta
	
# if projectile hit character checker
func _on_body_entered(body):
	print("in")
	if body.is_in_group("enemy"):
		# since character is hit, rest is broken
		napping = false
		
		# temporarily gives character no collision to not instantly lose the game for the player
		collision.call_deferred("set","disabled",true)
		# cooldown for collision
		collisionTimer.start()
		
		# removes the projectile since it collided
		body.queue_free()
		
		# stamina is reduced and emits signal to modify HUD
		stamina -= hurtDamage
		emit_signal("staminaChanged", stamina)
		
		# game over checker
		# emits signal gameOver if stamina is below 0
		if stamina <= 0:
			emit_signal("gameOver")
		

# collision timer has run out which means character can collide with bullets again
func _on_collision_timer_timeout():
	collision.call_deferred("set","disabled",false)

# object collision
func _on_object_collector_body_entered(body):
	# food gives character stamina
	if body.is_in_group("food"):
		stamina += foodStamina
		if stamina > baseStamina:
			stamina = baseStamina
		emit_signal("staminaChanged", stamina)
		emit_signal("obj", "food")
		
	# coin gives coins
	if body.is_in_group("coin"):
		emit_signal("obj", "coin")
		
	# req takes stamina but gives score
	if body.is_in_group("req"):
		stamina -= reqStamina
		emit_signal("staminaChanged", stamina)
		emit_signal("obj", "req")
	# any object that collided with character results to them being removed
	body.queue_free()

# garbage collector
# big collision that covers more than the play space where projectiles that exit it are destroyed to maximize efficiency
func _on_bullet_destroyer_body_exited(body):
	if body.is_in_group("enemy"):
		body.queue_free()

# tired function
# checks for difference in positions and deducts stamina if player moved enough distance
func _on_position_checker_timeout():
	tired -= abs(position - prevPosition).length() * tiredMultiplier
	prevPosition = position
	if tired <= 0:
		tired = baseTired
		stamina -= tiredDec
		emit_signal("staminaChanged", stamina)

# nap timer that regains stamina if player has pressed nap button long enough
func _on_nap_timer_timeout():
	if napping:
		stamina += napInc
		# stamina limited to base
		if stamina > baseStamina:
			stamina = baseStamina
		emit_signal("staminaChanged", stamina)
	napping = true


func _on_node_2d_pause():
	if paused:
		paused = false
	else:
		paused = true
