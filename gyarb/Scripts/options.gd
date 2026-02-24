extends Node2D

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")
	

func _on_instructions_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/instructions.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
