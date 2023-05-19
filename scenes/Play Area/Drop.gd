extends RigidBody2D

var speed = 50.0
var removeObj

func _ready():
	pass # Replace with function body.

func _process(delta):
	if get_tree().paused == true:
		hide()
	else:
		show()
		var req = get_tree().get_first_node_in_group("req")
		if req != null:
			self.look_at(req.global_position)
			self.global_position = self.global_position.move_toward(req.global_position, speed*delta)
		else:
			self.linear_velocity = Vector2(0.0, 0.0)

func _on_body_entered(body):
	if body.is_in_group("req"):
		body.queue_free()


func _on_existence_timer_timeout():
	removeObj = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	if removeObj == true:
		queue_free()
