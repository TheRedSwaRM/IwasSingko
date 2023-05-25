extends Node2D

@onready var char = get_tree().get_first_node_in_group("Character")
@export var tileMapBG: PackedScene

signal createNewTileMap

func _on_area_2d_area_exited(area):
	if area.is_in_group("Character"):
		queue_free()


func _on_create_new_tile_map_area_exited(area):
	createNewTileMap.emit()
