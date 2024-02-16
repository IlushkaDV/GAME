class_name Enemy
extends CharacterBody2D

signal target_changed(pos: Vector2)
signal dead

@export var rot_speed: float = 10.0  # Скорость вращения врага
@export var health: int = 100:  # Здоровье врага
	set = set_health
@export var speed: int = 300  # Скорость врага

var objective_damage := 10  # По умолчанию урон, наносимый при достижении цели

@onready var state_machine := $StateMachine as StateMachine  # Ссылка на автомат состояний врага
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D  # Ссылка на агента навигации
@onready var sprite := $Sprite2D as AnimatedSprite2D:  # Ссылка на анимированный спрайт врага
	get: return $Sprite2D as AnimatedSprite2D
@onready var collision := $CollisionShape2D as CollisionShape2D  # Ссылка на коллизию врага
@onready var hud := $UI/EntityHUD as EntityHud  # Ссылка на HUD врага

func _ready() -> void:
	# Инициализация HUD
	hud.state_label.text = state_machine.current_state.name
	hud.healthbar.max_value = health
	hud.healthbar.value = health
	# Инициализация агента навигации
	nav_agent.max_speed = speed

func _physics_process(delta: float) -> void:
	# Поворот на основе текущей скорости
	sprite.global_rotation = _calculate_rot(sprite.global_rotation,
			velocity.angle(), rot_speed, delta)
	collision.global_rotation = _calculate_rot(collision.global_rotation,
			velocity.angle(), rot_speed, delta)

func move_to(pos: Vector2) -> void:
	nav_agent.target_position = pos
	target_changed.emit(nav_agent.target_position)

func stop() -> void:
	if velocity == Vector2.ZERO:
		return
	nav_agent.set_velocity(Vector2.ZERO)

# Всегда вызывается состояниями
func apply_animation(anim_name: String) -> void:
	if sprite.sprite_frames.has_animation(anim_name):
		sprite.play(anim_name)
	else:
		print_debug("У спрайта отсутствует анимация %s!" % anim_name)

# Здоровье изменяется автоматом состояний, которое в конечном итоге вызовет состояние 'die', если здоровье станет равным нулю
func set_health(value: int) -> void:
	health = max(0, value)
	# Это нужно, потому что здоровье - это экспортируемая переменная, установленная в инспекторе,
	# что означает, что этот сеттер вызывается до того, как сцена будет готова.
	# Другими словами, переменные onready, ссылающиеся на узлы, не будут проинициализированы
	# при первом вызове этого сеттера.
	if is_instance_valid(hud):
		hud.healthbar.value = health

# Используется для вращения врага так, чтобы он смотрел в текущем направлении,
# со специфицированной скоростью вращения и использованием интерполяции
func _calculate_rot(start_rot: float, target_rot: float, _speed: float, delta: float) -> float:
	return lerp_angle(start_rot, target_rot, _speed * delta)

# Излучается NavigationAgent2D.set_velocity, который может быть вызван любым
# классом состояний. Устанавливает желаемую скорость и заставляет врага двигаться
func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func _on_state_machine_state_changed(states_stack: Array) -> void:
	hud.state_label.text = (states_stack[0] as State).name
