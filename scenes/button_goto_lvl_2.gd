extends Button

func _pressed() -> void:
	print("pressed  go to lvl 2")
	get_tree().change_scene_to_file("res://scenes/city_2.tscn")
