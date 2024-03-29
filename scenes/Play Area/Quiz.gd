extends RigidBody2D

@export var projectile: PackedScene
@export var speed = 100.0
var rng
var curPos
var prevPause

var stop = false

var removeObj = false

@onready var char = get_tree().get_first_node_in_group("Character")
# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()

func _process(delta):
	if get_tree().paused == true:
		hide()
	else:
		show()
		
	prevPause = get_tree().paused
	
	self.look_at(char.global_position)
	if prevPause == false:
		if stop == false:
			self.global_position = self.global_position.move_toward(char.global_position, speed*delta)
		else:
			self.linear_velocity = Vector2(0.0, 0.0)

func _on_stop_timer_timeout():
	stop = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	if stop == true and removeObj == true:
		queue_free()

func _on_existence_timer_timeout():
	removeObj = true
