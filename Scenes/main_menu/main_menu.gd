extends Node2D
@onready var ball: Ball = $Ball

func _ready() -> void:
	SceneManager.start_game.connect(on_start_game)
	SceneManager.exit_game.connect(on_exit_game)
	SceneManager.enter_options.connect(on_enter_options)
	AudioManager.play_music("BGM")

	
func on_start_game():
	SceneManager.change_to_scene_with_ball(SceneManager.MAIN,ball.position)

func on_exit_game():
	SceneManager.change_scene_to_exit_game(ball.position)

func on_enter_options():
	SceneManager.change_to_scene_with_ball(SceneManager.OPTIONS,ball.position)
