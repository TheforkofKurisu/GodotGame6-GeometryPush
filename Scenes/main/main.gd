extends Node2D

@onready var ball_creater: Node2D = $BallCreater
@onready var monster_spawn_timer: Timer = $Timers/MonsterSpawnTimer
@onready var exp_manager: Node2D = $ExpManager
@onready var game_over_ui: Control = $"../GameOver"


func _ready() -> void:
	SignalManager.game_over.connect(game_over)
	ball_creater.spawn_ball()

func game_over():
	get_tree().paused = true
	game_over_ui.visible = true
	game_over_ui.game_over(exp_manager.level)
	BuffManager.clear_all_buffs()
	for ball in ball_creater.ball_holder.get_children():
		ball.queue_free()
