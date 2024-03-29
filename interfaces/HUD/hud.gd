class_name Hud
extends CanvasLayer


@onready var healthbar := $Info/PanelContainer/Rows/Health/HealthBar as TextureProgressBar
@onready var money_label := $Info/PanelContainer/Rows/Money/Label as Label
@onready var gameover := $UI/GameOver as GameOver
@onready var wave_label := $Info/WaveLabel as Label
@onready var nextwave_panel := $Info/NextWave as PanelContainer
@onready var countdown_label := $Info/NextWave/Rows/Countdown as Label
@onready var nextwave_timer := $Info/NextWave/Timer as Timer


func _process(_delta: float) -> void:
	money_label.text = str(Global.money)
	if not nextwave_timer.is_stopped():
		countdown_label.text = str(int(nextwave_timer.time_left) + 1)


# Необходимо установить начальные значения healthbar
func initialize(max_health) -> void:
	healthbar.max_value = max_health
	healthbar.value = healthbar.max_value


# Используется для обновления здоровья объекта
func _on_objective_health_changed(cur_health: int) -> void:
	healthbar.value = cur_health


func _on_objective_destroyed() -> void:
	gameover.enable(true)


func _on_spawner_countdown_started(seconds: float) -> void:
	nextwave_panel.show()
	nextwave_timer.start(seconds)


func _on_timer_timeout() -> void:
	nextwave_panel.hide()


# Здесь просто на всякий случай, если для победы будет использовано другое
# окно завершения игры
func _on_spawner_enemies_defeated() -> void:
	gameover.enable(true)


func _on_spawner_wave_started(current_wave: int) -> void:
	wave_label.text = "Волна: %d" % current_wave
