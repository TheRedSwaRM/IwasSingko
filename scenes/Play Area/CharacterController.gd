extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
	
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

	# velocity is used to implement diagonal movement
	# also covers the case where two keys towards the opposite direction are pressed at the same time
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	

# on collision function
func _on_body_entered(body):
	hide()
