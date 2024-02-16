extends "res://entities/enemies/states/hit.gd"  # Расширяет "res://entities/enemies/states/hit.gd"


func enter() -> void:
	super()
	# замораживает время перезарядки на время этого состояния
	(owner as ShootingEnemy).shooter.set_firerate_timer_paused(true)


func exit() -> void:
	super()
	# возобновляет время перезарядки после выхода из этого состояния
	(owner as ShootingEnemy).shooter.set_firerate_timer_paused(false)
