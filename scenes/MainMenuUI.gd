extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_goToPlay_button_down():
	get_tree().change_scene_to_file("res://scenes/SelectDifficultyUI.tscn")
	pass # Replace with function body.

func _on_goToShop_button_down():
	get_tree().change_scene_to_file("res://scenes/ShopUI.tscn")
	pass # Replace with function body.

func _on_goToSettings_button_down():
	var settingsScene = preload("res://scenes/SettingsUI.tscn")
	get_parent().add_child(settingsScene.instantiate())
	pass # Replace with function body.

func _on_goToGuide_button_down():
	get_tree().change_scene_to_file("res://scenes/HowToPlayUI.tscn")
	pass # Replace with function body.

func _on_exit_button_down():
	get_tree().quit()
	pass # Replace with function body.
