extends Button

func _pressed() -> void:
	print("pressed  to vl1")
	get_tree().change_scene_to_file("res://scenes/city.tscn")
	
