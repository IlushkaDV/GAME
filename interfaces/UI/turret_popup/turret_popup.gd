extends CanvasLayer


signal turret_requested(type: String)

const PRICE_LABEL_PATH := "Background/Panel/Turrets/%s/Label"


func _ready() -> void:
	# инициализация цен на турели
	for turret in $Background/Panel/Turrets.get_children():
		var price_label := turret.get_node("Label") as Label
		price_label.text = str(Global.turret_prices[String(turret.name).to_lower()])


func _on_close_pressed() -> void:
	hide()


# Узел Background имитирует старый "исключительный" функционал всплывающего окна:
# при щелчке за пределами панели всплывающего окна оно закрывается.
func _on_background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			hide()


# Обратите внимание, что вы можете передавать пользовательские аргументы сигналу,
# включив расширенные настройки при подключении сигнала к методу с использованием редактора.
# В данном случае мы передаем тип турели на основе того, какая кнопка нажата.
func _on_button_pressed(type: String) -> void:
	if Global.money >= Global.turret_prices[type]:
		Global.money -= Global.turret_prices[type]
		turret_requested.emit(type)
		hide()
	else:
		var tween := create_tween().set_trans(Tween.TRANS_BACK).\
				set_ease(Tween.EASE_IN_OUT)
		var price_label := get_node(PRICE_LABEL_PATH % [type.capitalize()]) as Label
		price_label.modulate = Color("ff383f")
		tween.tween_property(price_label, "modulate", Color("fff"), 0.25)
