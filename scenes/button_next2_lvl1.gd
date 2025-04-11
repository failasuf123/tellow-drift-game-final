extends Button


func _pressed() -> void:
	print("pressed  to prolog lvl1")
	get_tree().change_scene_to_file("res://scenes/city.tscn")
