class_name Turret
extends CharacterBody2D

signal turret_disabled

const FADE_OUT_DURATION := 0.25

@export_range(1, 500) var health: int = 100:  # Здоровье турели
	set = set_health

# Это работает, пока все турели являются единственными дочерними элементами каждого слота турели,
# т.е. их имя всегда будет "SingleTurret" или "MissileTurret" и т. д.
var type: String:  # Тип турели
	get: return String(name).trim_suffix("Turret").to_lower()

@onready var collision := $CollisionShape2D as CollisionShape2D  # Коллизия
@onready var shooter := $Shooter as Shooter  # Стрелок
@onready var explosion := $Explosion as AnimatedSprite2D  # Взрыв
@onready var hud := $UI/EntityHUD as EntityHud  # HUD

func _ready() -> void:
	# Инициализация HUD
	hud.state_label.hide()
	hud.healthbar.max_value = health
	hud.healthbar.value = health

func _physics_process(_delta: float) -> void:
	if shooter.targets:
		if shooter.can_shoot and shooter.lookahead.is_colliding():
			shooter.shoot()

# Вызывается из интерфейса: возвращает некоторое значение в зависимости от процента текущего здоровья
func remove() -> void:
	var health_perc: float = hud.healthbar.value / hud.healthbar.max_value
	var money_returned := int(Global.turret_prices[type] * health_perc / 2)
	Global.money += money_returned
	queue_free()

# Вызывается из интерфейса: возвращает false, если нет достаточно денег, чтобы починить турель
func repair() -> bool:
	var missing_health_perc: float = 1.0 - \
			(hud.healthbar.value / hud.healthbar.max_value)
	var money_needed := int(Global.turret_prices[type] * missing_health_perc)
	var can_repair := Global.money >= money_needed
	if can_repair:
		Global.money -= money_needed
		health = int(hud.healthbar.max_value)
	return can_repair

func set_health(value: int) -> void:
	health = max(0, value)
	if is_instance_valid(hud):
		hud.healthbar.value = health
	if health == 0:
		collision.set_deferred("disabled", true)
		shooter.explode()
		explosion.play("default")
		turret_disabled.emit()

func _on_gun_animation_finished() -> void:
	# вызывается shooter.explode()
	if shooter.gun.animation == "explode":
		var tween := get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 0.0, FADE_OUT_DURATION)
		tween.finished.connect(_on_tween_finished)

func _on_tween_finished() -> void:
	queue_free()

# Датчик Area2D может обнаруживать только определенных врагов. См. его маску коллизий.
func _on_detector_body_entered(body: Node2D) -> void:
	if not body in shooter.targets:
		shooter.targets.append(body)

func _on_detector_body_exited(body: Node2D) -> void:
	if body in shooter.targets:
		shooter.targets.erase(body)

func _on_shooter_has_shot(reload_time: float) -> void:
	hud.update_reloadbar(reload_time)
