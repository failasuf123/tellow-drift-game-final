extends CharacterBody2D

#Pengaturan signals
signal health_updated(new_health)
signal player_died
signal people_collected(current_peoples)

# Pengaturan Kecepatan
const INITIAL_SPEED = 200
const SPEED_INCREMENT = 50
const MAX_SPEED = 450
const REVERSING = 150
const ROTATION_SPEED = 5  # Radians per second

# Variabel Kendali
var current_speed = INITIAL_SPEED
var acceleration_timer = 0
var is_accelerating = false
var is_reversing = false
var was_accelerating = false  # Untuk melacak state sebelumnya

# Variabel Serangan Musuh
var enemy_inattack_range = false
var enemy_attack_cooldown = true

# Pengaturan general
var player_alive = true
var level = 1
var health = 100:
	set(value):
		health = max(0, min(value, 100))  # Clamp antara 0-100
		emit_signal("health_updated", health)
		if health <= 0 and player_alive:
			player_alive = false
			emit_signal("player_died")
var peoples = 0:    
	set(value):
		peoples = value
		emit_signal("people_collected", peoples)

# Node Audio
@onready var driving_sound: AudioStreamPlayer2D = $DrivingSound
@onready var brake_sound: AudioStreamPlayer2D = $BrakeSound
@onready var batbite_sound: AudioStreamPlayer2D = $BatBite
@onready var pickedup_sound: AudioStreamPlayer2D = $PickedUp


func _ready():
	# Pastikan suara tidak otomatis menyala
	driving_sound.stop()
	brake_sound.stop()

func _physics_process(delta):
	player_movement(delta)
	handle_sound_effects()
	enemy_attack()
	

		
func player_movement(delta):
	# Handle rotasi (A/D atau panah kiri/kanan)
	var rotation_dir = 0
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		rotation_dir -= 1
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		rotation_dir += 1
	
	rotate(rotation_dir * ROTATION_SPEED * delta)
	
	# Handle gerakan maju/mundur (W/S atau panah atas/bawah)
	var direction = 0
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		direction += 1
		is_accelerating = true
		is_reversing = false
	elif Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		direction -= 1
		is_accelerating = false
		is_reversing = true
	else:
		# Reset saat tidak ada input
		is_accelerating = false
		is_reversing = false
		current_speed = INITIAL_SPEED
		acceleration_timer = 0
	
	# Logika akselerasi
	if is_accelerating:
		acceleration_timer += delta
		if acceleration_timer >= 1.0:  # Interval 1 detik
			acceleration_timer = 0
			current_speed = min(current_speed + SPEED_INCREMENT, MAX_SPEED)
	
	# Kecepatan mundur (instant)
	if is_reversing:
		current_speed = REVERSING
	
	# Terapkan kecepatan
	velocity = transform.x * direction * current_speed
	
	move_and_slide()

func handle_sound_effects():
	# Cek perubahan state akselerasi
	if is_accelerating and !was_accelerating:
		print("Mulai driving_sound")
		driving_sound.play()
		brake_sound.stop()
	elif !is_accelerating and was_accelerating:
		driving_sound.stop()
		brake_sound.play()
	
	# Update state sebelumnya
	was_accelerating = is_accelerating


func _on_player_hit_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true
	

func _on_player_hit_area_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 5
		batbite_sound.play()
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("Player took demege")
		print("Helath: ", health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	


func collect_people():
	pickedup_sound.play()
	health += 2
	peoples += 1
	print("People collected:", peoples)
	
