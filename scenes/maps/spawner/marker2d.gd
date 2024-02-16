class_name SpawnLocation
extends Marker2D
# Простой скрипт для определения того, будет ли текущий маркер использоваться для спавна
# наземных или воздушных сущностей


@export_enum("Ground", "Air") var spawn_type: int
