class_name GameOver
extends PanelContainer


@onready var anim_player := $AnimationPlayer as AnimationPlayer


# Обратите внимание, что родительский узел ДОЛЖЕН иметь установленный режим обработки "Всегда",
# чтобы этот узел продолжал обрабатываться после приостановки дерева сцен.
func enable(value: bool) -> void:
	Global.is_gameover = value
	get_tree().paused = value
	visible = value
	anim_player.play("show" if value else "RESET")


func _on_retry_pressed() -> void:
	enable(false)
	Scenes.change_scene(Scenes.MAP_TEMPLATE)


func _on_exit_pressed() -> void:
	enable(false)
	Scenes.change_scene(Scenes.MAIN_MENU)
