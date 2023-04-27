extends Control

var masterVolumeBus = AudioServer.get_bus_index("Master")


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_volume_db(masterVolumeBus, SingletonScript.playerData["controls"]["playerVolume"])
	$volumeSlider.value = SingletonScript.playerData["controls"]["playerVolume"]


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
