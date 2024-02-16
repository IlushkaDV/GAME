extends Motion  # Расширяет класс Motion


@export var state_duration: float = 0.5  # Длительность состояния по умолчанию
@export var slowdown_percentage: float = 0.2  # процент уменьшения скорости

var prev_state: State  # Предыдущее состояние врага

@onready var timer := Timer.new()  # Таймер для отслеживания длительности состояния
@onready var prev_speed := (owner as Enemy).speed  # Изначальная скорость врага

func _ready() -> void:
	timer.timeout.connect(_on_Timer_timeout)
	timer.one_shot = true
	add_child(timer)

# Урон владельцу уже был нанесен. Смотрите родительский класс.
# Мы просто получаем предыдущее состояние и замедляем врага
# на время этого состояния
func enter() -> void:
	(owner as Enemy).speed -= int((owner as Enemy).speed * slowdown_percentage)
	prev_state = (owner as Enemy).state_machine.states_stack.back()
	timer.start(state_duration)

# Восстанавливаем исходную скорость
func exit() -> void:
	timer.stop()
	(owner as Enemy).speed = prev_speed

func update(_delta: float) -> void:
	if prev_state is Motion:
		_move()

# У нас фактически есть стек состояний, позволяющий нам видеть предыдущее состояние.
# В этом случае мы можем использовать его, чтобы восстановить состояние,
# в котором находился владелец перед входом.
func _on_Timer_timeout() -> void:
	finished.emit((prev_state.name as String).to_lower())
