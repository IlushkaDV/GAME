extends "res://entities/enemies/states/die.gd"  # Расширяет "res://entities/enemies/states/die.gd"


# Воспроизводит анимацию "взрыв" для модуля стрелка.
# Она ДОЛЖНА иметь ту же частоту кадров и количество кадров,
# что и анимация "взрыв" базового класса ShootingEnemy.
func enter() -> void:
	super()
	(owner as ShootingEnemy).shooter.explode()
