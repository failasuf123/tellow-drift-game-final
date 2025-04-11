extends Node2D

@export var people_scene = preload("res://scenes/people.tscn")  
@export var player_scene = preload("res://scenes/player.tscn")

@onready var health_bar: ProgressBar = $CanvasLayer/HBoxContainer/VBoxContainer/HealthBar
@onready var people_counter_label: Label = $CanvasLayer/HBoxContainer/VBoxContainer/HBoxContainer/PeopleCounter
@onready var people_target_for_win: Label = $CanvasLayer/HBoxContainer/VBoxContainer/HBoxContainer/TargetPeople

var player: CharacterBody2D

var level = 1
var peoples_target_lvl1 = 20
var peoples_target_lvl2 = 35
var peoples_target_lvl3 = 50
var current_wave: int
var starting_nodes: int
var current_nodes: int
var wave_spawn_end

func _ready():
	# Instantiate player
	player = player_scene.instantiate()
	add_child(player)
	
	# Pastikan node UI tersedia
	if not health_bar:
		printerr("HealthBar not found!")
	if not people_counter_label:
		printerr("PeopleCounter not found!")
	
	# Hubungkan sinyal dengan cara yang lebih aman
	if player.has_signal("health_updated"):
		player.connect("health_updated", Callable(self, "_on_player_health_updated"))
	else:
		printerr("Signal health_updated tidak ada di player!")
	
	if player.has_signal("player_died"):
		player.connect("player_died", Callable(self, "_on_player_died"))
	else:
		printerr("Signal player_died tidak ada di player!")
	
	if player.has_signal("people_collected"):
		player.connect("people_collected", Callable(self, "_on_player_people_collected"))
	else:
		printerr("Signal people_collected tidak ada di player!")
	
	# Inisialisasi nilai awal
	if health_bar:
		health_bar.max_value = 100
		health_bar.value = player.health
	if people_counter_label:
		people_counter_label.text = str(player.peoples)
	if people_target_for_win:
		if level == 1:
			people_target_for_win.text = str("/ ", peoples_target_lvl1)
		elif level == 2:
			people_target_for_win.text = str("/ ", peoples_target_lvl2)
		elif level == 3:
			people_target_for_win.text = str("/ ", peoples_target_lvl3)
		else:
			people_target_for_win.text = str("/ ", 999)

func _on_player_health_updated(new_health):
	health_bar.value = new_health
	# Jika health mencapai 0 atau kurang, panggil fungsi _on_player_died()
	if new_health <= 0:
		_on_player_died()

func _on_player_people_collected(current_peoples):
	people_counter_label.text = str(current_peoples)
	if current_peoples >= 20:
		get_tree().change_scene_to_file("res://scenes/win_lvl_1.tscn")

func spawn_people():
	var new_people = people_scene.instantiate()
	add_child(new_people)
	new_people.global_position = Vector2(
		randf_range(1000, 1100),
		randf_range(1000, 1200)
	)

func _on_player_died():
	print("Player died - show game over screen")
	get_tree().change_scene_to_file("res://scenes/lose_lvl_1.tscn")
