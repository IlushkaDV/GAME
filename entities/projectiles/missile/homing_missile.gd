extends Projectile

@export var steer_force: int = 40  # Сила управления

var acceleration: Vector2  # Ускорение

func _physics_process(delta: float) -> void:
	if is_instance_valid(target):
		acceleration += _steer()
		velocity += acceleration * delta
		velocity = velocity.limit_length(speed)
		rotation = velocity.angle()
	global_position += velocity * delta

func _steer() -> Vector2:
	# вычисляем желаемый вектор направления с максимальной скоростью
	var desired := global_position.direction_to(target.global_position) * speed
	# возвращаем количество, на которое мы можем повернуться к желаемому направлению
	return velocity.direction_to(desired) * steer_force
