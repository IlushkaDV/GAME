extends Motion  # Расширяет класс Motion


func enter() -> void:
	(owner as ShootingEnemy).apply_animation("shoot")


func update(_delta: float) -> void:
	_move()
	if (owner as ShootingEnemy).shooter.can_shoot and \
			(owner as ShootingEnemy).shooter.lookahead.is_colliding():
		(owner as ShootingEnemy).shooter.shoot()
	# проверяем, нужно ли выйти из состояния
	if (owner as ShootingEnemy).shooter.targets.is_empty():
		finished.emit("move")
	else:
		for target in (owner as ShootingEnemy).shooter.targets:
			if target is Objective:
				finished.emit("shoot_still")
				break
