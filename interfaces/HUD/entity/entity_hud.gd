class_name EntityHud
extends Control


const RED := Color("#e86a17")
const YELLOW := Color("#d2b82d")
const GREEN := Color("#88e060")

@onready var state_label := $Parameters/StateLabel as Label
@onready var healthbar := $Parameters/Healthbar as TextureProgressBar
@onready var reload_bar := $Parameters/ReloadBar as TextureProgressBar


func _ready() -> void:
	# инициализация reload bar
	reload_bar.value = 0


# Мы используем анимацию для анимации панели перезагрузки. Обратите внимание, что мы используем Object.create_tween()
# вместо SceneTree.create_tween(), чтобы привязать ее к этому объекту. Это означает
# что "анимация остановит анимацию, когда объект не находится внутри дерева 
# и анимация будет автоматически отключена, когда связанный объект будет освобожден"
func update_reloadbar(duration: float) -> void:
	var tween := create_tween()
	tween.tween_callback(reload_bar.show)
	tween.tween_method(_update_bar, reload_bar.value, reload_bar.max_value,
			duration)


func _update_bar(value) -> void:
	reload_bar.value = value
	if value > reload_bar.max_value * 0.0:
		reload_bar.self_modulate = RED
	if value > reload_bar.max_value * 0.33:
		reload_bar.self_modulate = YELLOW
	if value > reload_bar.max_value * 0.66:
		reload_bar.self_modulate = GREEN
	if value == reload_bar.max_value:
		reload_bar.value = reload_bar.min_value


func _on_healthbar_value_changed(value: float) -> void:
	healthbar.self_modulate = RED if value <= healthbar.max_value / 4 else GREEN
