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


func _on_playAgain_button_down():
	get_tree().change_scene_to_file("res://scenes/PlayArea.tscn")
	pass # Replace with function body.


func _on_backToMainMenu_button_down():
	get_tree().change_scene_to_file("res://scenes/MainMenuUI.tscn")
	pass # Replace with function body.
