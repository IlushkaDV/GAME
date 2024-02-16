extends Node

var is_gameover := false
var turret_actions: Control = null  # используется для того, чтобы убедиться, что только один видим на карте
var money: int
var turret_prices := {
	"gatling": 250,
	"single": 400,
	"missile": 800,
}

# Функция для оборачивания индекса вокруг массива (циклический массив)
static func wrap_index(index: int, size: int) -> int:
	return ((index % size) + size) % size
