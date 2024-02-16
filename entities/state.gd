class_name State
extends Node

# Базовый интерфейс для всех состояний: сам по себе ничего не делает,
# но заставляет нас передавать правильные аргументы в методы ниже
# и гарантирует, что каждый объект State имеет все эти методы.


signal finished(next_state_name: String)


# Инициализация состояния. Например, изменение анимации
func enter() -> void:
	return


# Завершение состояния. Переинициализация значений, таких как таймер
func exit() -> void:
	return


func handle_input(event: InputEvent) -> InputEvent:
	return event


func update(_delta: float) -> void:
	return


# Вызывается конечным автоматом
func on_animation_finished() -> void:
	return
