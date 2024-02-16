extends Node
# Глобальный вспомогательный класс, используемый для получения информации о сценах игры.


# Враги
const INFANTRY_T1 := "res://entities/enemies/infantry/infantry_t1.tscn"
const INFANTRY_T2 := "res://entities/enemies/infantry/infantry_t2.tscn"
const TANK := "res://entities/enemies/shooting/tanks/tank.tscn"
const HELICOPTER := "res://entities/enemies/shooting/helicopters/helicopter.tscn"
# Орудия
const GATLING_TURRET := "res://entities/turrets/gatling/gatling_turret.tscn"
const SINGLE_TURRET := "res://entities/turrets/single/single_turret.tscn"
const MISSILE_TURRET := "res://entities/turrets/missile/missile_turret.tscn"
# Сцены
const MAIN_MENU := "res://interfaces/UI/menu/menu.tscn"
const MAP_TEMPLATE := "res://scenes/maps/map_template.tscn"


static func get_enemy_path(enemy_name: String) -> String:
	var enemy_path: String
	match enemy_name:
		"infantry_t1":
			enemy_path = INFANTRY_T1
		"infantry_t2":
			enemy_path = INFANTRY_T2
		"tank":
			enemy_path = TANK
		"helicopter":
			enemy_path = HELICOPTER
		_:
			printerr("Не удается получить сцену врага из имени %s" % enemy_name)
	return enemy_path


static func get_turret_path(turret_name: String) -> String:
	var turret_path: String
	match turret_name:
		"gatling":
			turret_path = GATLING_TURRET
		"single":
			turret_path = SINGLE_TURRET
		"missile":
			turret_path = MISSILE_TURRET
		_:
			printerr("Не удается получить сцену орудия из имени %s" % turret_name)
	return turret_path


func change_scene(scene: String) -> void:
	var e = get_tree().change_scene_to_file(scene)
	if e != OK:
		push_error("Ошибка при смене сцены: %s" % str(e))
