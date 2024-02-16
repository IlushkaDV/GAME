class_name Projectile
extends Area2D

@export var lifetime: int = 10  # в секундах

var speed: int
var damage: int
var velocity: Vector2
var target  # только для самонаводящихся ракет

@onready var sprite := $Sprite2D as Sprite2D
@onready var hit_vfx := $HitVfx as AnimatedSprite2D
@onready var collision_shape := $CollisionShape2D as CollisionShape2D
@onready var visibility_notifier := $VisibleOnScreenNotifier2D as VisibleOnScreenNotifier2D
@onready var lifetime_timer := $LifetimeTimer as Timer

func _ready() -> void:
	hit_vfx.hide()
	# обработка видимости через узел VisibleOnScreenNotifier2D
	visibility_notifier.screen_entered.connect(show)
	visibility_notifier.screen_exited.connect(hide)
	# создание таймера срока службы
	lifetime_timer.start(lifetime)

func _physics_process(delta: float) -> void:
	global_position += velocity * delta

# Вызывается турелью, которая создает снаряд и (по желанию)
# дает ему цель
func start(_position: Vector2, _rotation: float, _speed: int, _damage: int, _target=null) -> void:
	global_position = _position
	rotation = _rotation
	speed = _speed
	damage = _damage
	target = _target
	velocity = Vector2.RIGHT.rotated(_rotation) * speed

# У каждого потомка этой сцены будет разная маска коллизий.
# Таким образом, мы можем быть уверены, что правильный метод будет вызван каждым экземпляром
func _on_projectile_body_entered(body: Node2D) -> void:
	if body is Enemy:
		(body.state_machine as EnemyFSM).is_hit(damage)
		_explode()
	elif body is Turret:
		(body as Turret).health -= damage
		_explode()

# См. комментарий к методу выше
func _on_projectile_area_entered(area: Area2D) -> void:
	if area is Objective:
		(area as Objective).health -= damage
		_explode()

func _explode() -> void:
	# остановить пулю и отключить коллизию
	set_physics_process(false)
	collision_shape.set_deferred("disabled", true)
	# воспроизвести vfx
	sprite.hide()
	hit_vfx.show()
	hit_vfx.play("hit")

func _on_lifetime_timer_timeout() -> void:
	queue_free()

func _on_hit_vfx_animation_finished() -> void:
	queue_free()
