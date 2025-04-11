extends Button

func _pressed() -> void:
	print("pressed  to lvl 2 restart")
	get_tree().change_scene_to_file("res://scenes/city_2.tscn")
	
