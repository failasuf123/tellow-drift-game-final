extends Button

func _pressed() -> void:
	print("pressed  to Main Menu")
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
	
