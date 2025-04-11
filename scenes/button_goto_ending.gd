extends Button

func _pressed() -> void:
	print("pressed  go to ending")
	get_tree().change_scene_to_file("res://scenes/ending.tscn")
