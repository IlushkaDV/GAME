extends "res://entities/enemies/shooting/states/shoot.gd"


func update(_delta: float) -> void:
	if (owner as ShootingEnemy).shooter.can_shoot and \
			(owner as ShootingEnemy).shooter.lookahead.is_colliding():
		(owner as ShootingEnemy).shooter.shoot()
		var shooting_anim := (owner as ShootingEnemy).shooter.gun.animation
		(owner as ShootingEnemy).apply_animation(shooting_anim)
	if (owner as ShootingEnemy).shooter.targets.is_empty():
		finished.emit("move")


func on_animation_finished() -> void:
	var cur_anim := String((owner as ShootingEnemy).sprite.animation)
	if cur_anim in ["shoot_a", "shoot_b"]:
		(owner as ShootingEnemy).apply_animation("move")


#код является частью логики состояния стрельбы для стрелкового врага в игре. 
#Сначала проверяется возможность стрельбы и столкновение взгляда стрелка. 
#Если условия выполняются, стрелковый объект производит выстрел и проигрывает анимацию стрельбы. 
#Затем, при завершении анимации стрельбы, объект возвращается к анимации движения, 
#если текущая анимация была одной из анимаций стрельбы.
