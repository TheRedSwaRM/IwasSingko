extends Control
var time_start = 0
var time_now = 0

var masterVolumeBus = AudioServer.get_bus_index("Master")

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_unix_time_from_system()
	AudioServer.set_bus_volume_db(masterVolumeBus, SingletonScript.playerData["controls"]["playerVolume"])
	SetHotkeys()

func _physics_process(delta):
	time_now = Time.get_unix_time_from_system()
	if time_now - time_start >= 10:
		get_tree().change_scene_to_file("res://scenes/MainMenuUI.tscn")
		pass

func _input(event):
	#print(event.as_text())
	if event.is_pressed():
		get_tree().change_scene_to_file("res://scenes/MainMenuUI.tscn")
		pass
		
	
	
func SetHotkeys():
	if SingletonScript.playerData["controls"]["playerWalkUp"] is String:
		SingletonScript.ResetPlayerData()
	
	var event
	event = InputMap.action_get_events("move_up")[0]
	if SingletonScript.playerData["controls"]["playerWalkUp"] == 0:
		event.set_keycode(KEY_UP)
	else:
		event.set_keycode(KEY_W)
	
	event = InputMap.action_get_events("move_down")[0]
	if SingletonScript.playerData["controls"]["playerWalkDown"] == 0:
		event.set_keycode(KEY_DOWN)
	else:
		event.set_keycode(KEY_S)
	
	event = InputMap.action_get_events("move_left")[0]
	if SingletonScript.playerData["controls"]["playerWalkLeft"] == 0:
		event.set_keycode(KEY_LEFT)
	else:
		event.set_keycode(KEY_A)
	
	event = InputMap.action_get_events("move_right")[0]
	if SingletonScript.playerData["controls"]["playerWalkRight"] == 0:
		event.set_keycode(KEY_RIGHT)
	else:
		event.set_keycode(KEY_D)
	
	event = InputMap.action_get_events("sprint")[0]
	if SingletonScript.playerData["controls"]["playerSprint"] == 0:
		event.set_keycode(KEY_Z)
	else:
		event.set_keycode(KEY_J)
	
	event = InputMap.action_get_events("nap")[0]
	if SingletonScript.playerData["controls"]["playerNap"] == 0:
		event.set_keycode(KEY_X)
	else:
		event.set_keycode(KEY_K)
