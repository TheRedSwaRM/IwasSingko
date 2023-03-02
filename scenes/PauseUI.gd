extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_settings_button_down():
	var settingsScene = preload("res://scenes/SettingsUI.tscn")
	get_parent().add_child(settingsScene.instance())
	pass # Replace with function body.


func _on_resume_button_down():
	queue_free()
	pass # Replace with function body.


func _on_goToMainMenu_button_down():
	get_tree().change_scene("res://scenes/MainMenuUI.tscn")
	pass # Replace with function body.
