extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var pause_scene = load("res://scenes/PauseUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_button_down():
	get_parent().add_child(pause_scene.instance())
	pass # Replace with function body.
