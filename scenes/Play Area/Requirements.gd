extends RigidBody2D

var offscreenMarker
var indicator
var icon
@onready var char = get_tree().get_first_node_in_group("Character")
var vpr

func _ready():
	offscreenMarker = $OffscreenMarker
	icon = $OffscreenMarker/OffscreenIcon
	icon.set_frame($Sprite2D.get_frame())
	indicator = $OffscreenMarker/Indicator
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().paused == true:
		hide()
	else:
		show()
	vpr = get_viewport_rect().size
	offscreenMarker.global_position.x = clampf(self.global_position.x, char.global_position.x - vpr.x/2, char.global_position.x + vpr.x/2)
	offscreenMarker.global_position.y = clampf(self.global_position.y, char.global_position.y - vpr.y/2, char.global_position.y + vpr.y/2)
	offscreenMarker.look_at(char.global_position)

func _on_visible_on_screen_notifier_2d_screen_entered():
	offscreenMarker.hide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	offscreenMarker.show()
