extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var stamina = 100

@onready var collision = $CollisionShape2D
@onready var collisionTimer = $CollisionTimer

signal hurt
signal obj(type)

func _ready():
	pass


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	# movement controls
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("idle")
	else:
		$AnimationTree.get("parameters/playback").travel("walk")
		$AnimationTree.set("parameters/idle/blend_position", velocity)
		$AnimationTree.set("parameters/walk/blend_position", velocity)
	# sprint controls
	# doubles movement speed if sprint is held
	var movementSpeed = speed
	if Input.is_action_pressed("sprint"):
		movementSpeed *= 2

	# nap controls
	if Input.is_action_pressed("nap"):
		movementSpeed = 0
	
	# velocity is used to implement diagonal movement
	# also covers the case where two keys towards the opposite direction are pressed at the same time
	if velocity.length() > 0:
		velocity = velocity.normalized() * movementSpeed
	position += velocity * delta
	

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		collision.call_deferred("set","disabled",true)
		collisionTimer.start()
		emit_signal("hurt")

func _on_collision_timer_timeout():
	collision.call_deferred("set","disabled",false)


func _on_object_collector_body_entered(body):
	if body.is_in_group("food"):
		emit_signal("obj", "food")
	if body.is_in_group("coin"):
		emit_signal("obj", "coin")
	if body.is_in_group("req"):
		emit_signal("obj", "req")
	
