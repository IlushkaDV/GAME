class_name EnemyFSM
extends StateMachine

# Этот класс должен переопределить метод _change_state, чтобы завершить текущее
# состояние, выполнить необходимые шаги и, наконец, переключиться на новое состояние.
# Кроме того, словарь states_map будет содержать все имена состояний в качестве
# ключей и их путь как относительную запись. Каждый идентификатор будет ссылаться
# из каждого состояния и передаваться при эмиссии их сигнала "finished".


const STATES_STACK_COUNT := 2  # Количество состояний в стеке

# Мы должны добавить состояния в states_map. Это будет выглядеть так:
#	states_map = {
#		"move": $Move,
#		"idle": $Idle,
#		"hit": $Hit,
#	}
func _ready() -> void:
	super()
	for node in get_children():
		states_map[String(node.name).to_lower()] = node

# Специальный случай для принудительного перехода в состояние Hit.
# Вызывается при столкновении с наносящим урон объектом. Это ограничение
# данной реализации, потому что мы не можем передавать данные напрямую в состояние.
func is_hit(damage: int) -> void:
	if String(current_state.name) in ["Hit", "Die"]:
		return
	(owner as Enemy).health -= damage
	current_state.finished.emit("die" if (owner as Enemy).health == 0 else "hit")

func _change_state(state_name: String) -> void:
	# завершаем текущее состояние
	current_state.exit()
	states_stack.push_front(states_map[state_name])
	if states_stack.size() > STATES_STACK_COUNT:
		states_stack.pop_back()
	# входим в новое состояние
	current_state = states_stack[0]
	state_changed.emit(states_stack)
	current_state.enter()
