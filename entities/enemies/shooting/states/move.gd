extends "res://entities/enemies/states/move.gd"  # Расширяет "res://entities/enemies/states/move.gd"


func update(delta: float) -> void:
	super(delta)
	# проверяем, нужно ли выйти из состояния
	if (owner as ShootingEnemy).shooter.targets.size() > 0:
		finished.emit("shoot")
