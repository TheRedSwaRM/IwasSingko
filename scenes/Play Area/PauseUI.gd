extends Control


var pause_scene = load("res://scenes/Play Area/PauseUI.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_settings_button_down():
	var settingsScene = preload("res://scenes/SettingsUI.tscn")
	get_parent().add_child(settingsScene.instantiate())
	get_tree().paused = false
	pass # Replace with function body.


func _on_resume_button_down():
	hide()
	get_tree().paused = false
	pass


func _on_goToMainMenu_button_down():
	get_tree().change_scene_to_file("res://scenes/MainMenuUI.tscn")
	get_tree().paused = false
	pass # Replace with function body.
