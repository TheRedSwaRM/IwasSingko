extends Control

var masterVolumeBus = AudioServer.get_bus_index("Master")


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_volume_db(masterVolumeBus, SingletonScript.playerData["controls"]["playerVolume"])
	$volumeSlider.value = SingletonScript.playerData["controls"]["playerVolume"]
	if SingletonScript.playerData["controls"]["playerWalkUp"] is String:
		SingletonScript.SetControlsPlayerWalkUp(0)
		SingletonScript.SetControlsPlayerWalkDown(0)
		SingletonScript.SetControlsPlayerWalkRight(0)
		SingletonScript.SetControlsPlayerWalkLeft(0)
		SingletonScript.SetControlsPlayerSprint(0)
		SingletonScript.SetControlsPlayerNap(0)
	$ControlUP.select(SingletonScript.playerData["controls"]["playerWalkUp"])
	$ControlDown.select(SingletonScript.playerData["controls"]["playerWalkDown"])
	$ControlLeft.select(SingletonScript.playerData["controls"]["playerWalkRight"])
	$ControlRight.select(SingletonScript.playerData["controls"]["playerWalkLeft"])
	$ControlSprint.select(SingletonScript.playerData["controls"]["playerSprint"])
	$ControlNap.select(SingletonScript.playerData["controls"]["playerNap"])

func _on_Button_button_down():
	queue_free()
	pass # Replace with function body.


func _on_volume_slider_value_changed(value):
	SingletonScript.SetControlsPlayerVolume(value)
	AudioServer.set_bus_volume_db(masterVolumeBus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(masterVolumeBus, true)
	else:
		AudioServer.set_bus_mute(masterVolumeBus, false)
		
	SingletonScript.SavePlayerData()


func _on_control_up_item_selected(index):
	SingletonScript.SetControlsPlayerWalkUp(index)
	var event = InputMap.action_get_events("move_up")[0]
	if index == 0:
		event.set_keycode(KEY_UP)
	else:
		event.set_keycode(KEY_W)
	
	SingletonScript.SavePlayerData()

func _on_control_down_item_selected(index):
	SingletonScript.SetControlsPlayerWalkDown(index)
	var event = InputMap.action_get_events("move_down")[0]
	if index == 0:
		event.set_keycode(KEY_DOWN)
	else:
		event.set_keycode(KEY_S)
		
	SingletonScript.SavePlayerData()

func _on_control_left_item_selected(index):
	SingletonScript.SetControlsPlayerWalkLeft(index)
	var event = InputMap.action_get_events("move_left")[0]
	if index == 0:
		event.set_keycode(KEY_LEFT)
	else:
		event.set_keycode(KEY_A)
	
	SingletonScript.SavePlayerData()

func _on_control_right_item_selected(index):
	SingletonScript.SetControlsPlayerWalkRight(index)
	var event = InputMap.action_get_events("move_right")[0]
	if index == 0:
		event.set_keycode(KEY_RIGHT)
	else:
		event.set_keycode(KEY_D)
	
	SingletonScript.SavePlayerData()

func _on_control_sprint_item_selected(index):
	SingletonScript.SetControlsPlayerSprint(index)
	var event = InputMap.action_get_events("sprint")[0]
	if index == 0:
		event.set_keycode(KEY_Z)
	else:
		event.set_keycode(KEY_J)
	
	SingletonScript.SavePlayerData()

func _on_control_nap_item_selected(index):
	SingletonScript.SetControlsPlayerNap(index)
	var event = InputMap.action_get_events("nap")[0]
	if index == 0:
		event.set_keycode(KEY_X)
	else:
		event.set_keycode(KEY_K)
	
	SingletonScript.SavePlayerData()
