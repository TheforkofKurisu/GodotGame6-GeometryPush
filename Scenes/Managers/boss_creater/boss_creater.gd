extends Node2D

const BOSS_1 = preload("res://Scenes/objects/Boss/boss_1.tscn")

var spawn_position = Vector2(360,-500)

func _ready() -> void:
	GameManager.spawn_boss.connect(create_boss)

func create_boss():
	var new_boss = BOSS_1.instantiate()
	new_boss.position = spawn_position
	add_child(new_boss)
