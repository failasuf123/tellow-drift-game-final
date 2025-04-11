extends CharacterBody2D

@onready var respawn_timer: Timer = $RespawnTimer
var level = 1
var current_wave : int

func _ready():
	respawn_timer.one_shot = true

func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body.has_method("collect_people"):  
		body.collect_people() 
		queue_free()
		start_respawn() 
		 

func start_respawn():
	var random_time = randf_range(1.0, 2.0)  # Waktu acak 20-60 detik
	respawn_timer.start(random_time)
	print("People akan respawn dalam ", random_time, " detik")

func _on_respawn_timer_timeout():
	# Spawn people baru (misal: di scene utama/map)
	get_parent().spawn_people()  # Panggil fungsi spawn di parent (map.gd)
	
func people():
	pass
	
