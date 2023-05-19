extends RigidBody2D

var rng
var removeObj

func _ready():
	rng = RandomNumberGenerator.new()
	
func _process(delta):
	if get_tree().paused == true:
		hide()
	else:
		show()


func _on_directions_timer_timeout():
	var randomNum = rng.randi_range(1, 4)
	
	if randomNum == 1:
		self.linear_velocity.x = self.linear_velocity.x * -1
	if randomNum == 2:
		self.linear_velocity = self.linear_velocity * 1.5
	if randomNum == 3:
		self.linear_velocity.y = self.linear_velocity.y * -1
	if randomNum == 4:
		self.linear_velocity = self.linear_velocity * 2


func _on_visible_on_screen_notifier_2d_screen_entered():
	self.linear_velocity = self.linear_velocity * 0.5


func _on_visible_on_screen_notifier_2d_screen_exited():
	self.linear_velocity = self.linear_velocity * 2
	if removeObj == true:
		queue_free()


func _on_existence_timer_timeout():
	removeObj = true
