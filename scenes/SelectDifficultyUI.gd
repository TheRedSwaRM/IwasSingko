extends Control

func _on_easy_button_down():
	get_tree().change_scene_to_file("res://scenes/Play Area/PlayArea.tscn")
	SingletonScript.SetPlayAreaDifficulty("Easy")
	pass # Replace with function body.

func _on_normal_button_down():
	get_tree().change_scene_to_file("res://scenes/Play Area/PlayArea.tscn")
	SingletonScript.SetPlayAreaDifficulty("Normal")
	pass # Replace with function body.

func _on_hard_button_down():
	get_tree().change_scene_to_file("res://scenes/Play Area/PlayArea.tscn")
	SingletonScript.SetPlayAreaDifficulty("Hard")
	pass # Replace with function body.
