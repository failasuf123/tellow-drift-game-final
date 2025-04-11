extends CharacterBody2D

var SPEED = 70
var player_chase = false
var player = null

var start_position: Vector2
var patrol_target: Vector2
var is_patrolling = false
var is_returning = false

func _ready():
	start_position = global_position
	randomize()
	_set_new_patrol_target()

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position) / SPEED

		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		# // lakukan algoritma disini untuk menggerakan musuh
		if is_patrolling:
			var direction = (patrol_target - global_position)
			if direction.length() < 5:
				is_patrolling = false
				is_returning = true
			else:
				position += direction.normalized() * SPEED * delta
				$AnimatedSprite2D.flip_h = direction.x > 0
		elif is_returning:
			var direction = (start_position - global_position)
			if direction.length() < 5:
				is_returning = false
				await get_tree().create_timer(1.0).timeout
				_set_new_patrol_target()
			else:
				position += direction.normalized() * SPEED * delta
				$AnimatedSprite2D.flip_h = direction.x > 0

func _set_new_patrol_target():
	var angle = randf_range(0, PI * 2)
	var distance = randf_range(50, 100)
	patrol_target = start_position + Vector2(cos(angle), sin(angle)) * distance
	is_patrolling = true

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
