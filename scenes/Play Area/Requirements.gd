extends RigidBody2D

var offscreenMarker
var indicator
var onScreen
@onready var char = get_tree().get_first_node_in_group("Character")
var vpr
var margin

func _ready():
	onScreen = false
	offscreenMarker = $OffscreenMarker
	indicator = $OffscreenMarker/Indicator
	$ExistenceTimer.wait_time = SingletonScript.playerData["player"]["playerRateReq"]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().paused == true:
		hide()
	else:
		show()
	vpr = get_viewport_rect().size
	margin = Vector2(indicator.texture.get_width(), indicator.texture.get_height()) * indicator.scale / 2
	offscreenMarker.global_position.x = clampf(self.global_position.x, char.global_position.x - vpr.x/2 + margin.x, char.global_position.x + vpr.x/2 - margin.x)
	offscreenMarker.global_position.y = clampf(self.global_position.y, char.global_position.y - vpr.y/2 + margin.y, char.global_position.y + vpr.y/2- margin.y)
	offscreenMarker.look_at(char.global_position)
	$OffscreenMarker/TimerLabel.text = str(round($ExistenceTimer.time_left))
	$OffscreenMarker/TimerLabel.rotation = -offscreenMarker.rotation
	#if onScreen == false:
	#	$TimerLabel.global_position = offscreenMarker.global_position
	#else:
	#	$TimerLabel.global_position = self.global_position
	#	$TimerLabel.global_position.y = $TimerLabel.global_position.y - ($Sprite2D.texture.get_height() * $Sprite2D.scale / 4).y

func _on_visible_on_screen_notifier_2d_screen_entered():
	offscreenMarker.hide()
	onScreen = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	offscreenMarker.show()
	onScreen = false

func _on_existence_timer_timeout():
	queue_free()
	get_tree().change_scene_to_file("res://scenes/GameOverUI.tscn")
