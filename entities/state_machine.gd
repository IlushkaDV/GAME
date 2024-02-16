class_name StateMachine
extends Node

# Цель паттерна Состояние - разделение обязанностей, чтобы следовать
# принципу единственной ответственности. Каждое состояние описывает действие или поведение.
# Автомат состояний является единственной сущностью, которая знает о состояниях.
# Поэтому этот скрипт получает строки от состояний: он сопоставляет
# эти строки фактическим объектам состояний (Move, Jump и т. д.).
# Состояния (Move, Jump и т. д.) не знают о своих соседях. Таким образом, вы можете
# в любое время изменить любое из состояний без нарушения игры.


signal state_changed(states_stack: Array)

# Вы должны установить начальный узел из инспектора или на
# узле, который наследуется от этого интерфейса автомата состояний.
# Если вы этого не сделаете, игра аварийно завершится (намеренно, чтобы вы не забыли
# инициализировать автомат состояний)
@export var START_STATE: NodePath

# В этом примере хранится история некоторых состояний, чтобы, например, после получения удара
# персонаж мог вернуться к предыдущему состоянию. Stack состояний - это массив,
# и мы используем Array.push_front() и Array.pop_front() для добавления и
# удаления состояний из истории.
var states_map := {}
var states_stack: Array[Object] = []
var current_state: State = null


func _ready() -> void:
	for state_node in get_children():
		state_node.finished.connect(_change_state)
	initialize(START_STATE)


# Автомат состояний делегирует обработку и ввод колбэкам текущего состояния
# Объект состояния, например, Move, затем обрабатывает ввод, вычисляет скорость
# и перемещает то, что я назвал "хостом", узел Игрока (KinematicBody2D) в данном случае.
func _physics_process(delta: float) -> void:
	current_state.update(delta)


func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)


# Если значение false, это отключает обработку, в противном случае - включает ее
func set_processing(value: bool) -> void:
	set_process_unhandled_input(value)


func initialize(start_state: NodePath) -> void:
	states_stack.push_front(get_node(start_state))
	current_state = states_stack[0]
	current_state.enter()


# Мы используем этот метод для:
# 1. Очистки текущего состояния с его методом выхода
# 2. Управления потоком и историей состояний
# 3. Инициализации нового состояния с его методом входа
func _change_state(_state_name: String) -> void:
	pass


# Мы хотим делегировать каждый метод или колбэк, который может вызвать
# изменение состояния, объектам состояний. Базовый скрипт state.gd,
# который расширяют все состояния, гарантирует, что все состояния имеют одинаковый
# интерфейс, то есть доступ к тем же базовым методам, включая
# on_animation_finished. См. state.gd
func _on_Sprite_animation_finished() -> void:
	current_state.on_animation_finished()
