extends Node2D
# Это действует как базовая сцена карты. Чтобы создать новый уровень,
# просто создайте сцену, наследующуюся от этой, и используйте тайлмап для его проектирования.
# Вы можете использовать функцию территорий для рисования путей, уже имеющих
# настройку навигации, а затем настраивать спавнер, цель, камеру и т. д.
# по вашему усмотрению.


const STARTING_MONEY := 5000

@onready var objective := $Objective as Objective
@onready var spawner := $Spawner as Spawner
@onready var camera := $Camera2D as Camera2D
@onready var tilemap := $TileMap as TileMap


func _ready() -> void:
	randomize()
	# инициализировать деньги
	Global.money = STARTING_MONEY
	# инициализировать камеру
	var map_limits := tilemap.get_used_rect()
	var cell_size := tilemap.tile_set.tile_size
	camera.limit_left = int(map_limits.position.x) * cell_size.x
	camera.limit_top = int(map_limits.position.y) * cell_size.y
	camera.limit_right = int(map_limits.end.x) * cell_size.x
	camera.limit_bottom = int(map_limits.end.y) * cell_size.y
	# подключить сигналы
	spawner.countdown_started.connect(Callable(camera.hud, "_on_spawner_countdown_started"))
	spawner.wave_started.connect(Callable(camera.hud, "_on_spawner_wave_started"))
	spawner.enemies_defeated.connect(Callable(camera.hud, "_on_spawner_enemies_defeated"))
	objective.health_changed.connect(Callable(camera.hud, "_on_objective_health_changed"))
	objective.destroyed.connect(Callable(camera.hud, "_on_objective_destroyed"))
	# инициализировать параметры HUD
	(camera.hud as Hud).initialize(objective.health)  # цель уже будет инициализирована
	# начать появление врагов
	spawner.initialize(objective.global_position, map_limits, cell_size)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and \
			event.button_index == MOUSE_BUTTON_LEFT:
		# если виджет действий с турелью видим, спрятать его
		if Global.turret_actions:
			Global.turret_actions.hide()
