extends Control


func _ready() -> void:
	SceneManager.stop_game.connect(stop_game)

func stop_game():
	visible = true

func _on_visibility_changed() -> void:
	get_tree().paused = visible

func _on_button_pressed() -> void:
	visible = false

func _on_button_3_pressed() -> void:
	get_tree().paused = false
	SceneManager.change_to_scene(SceneManager.MAIN_MENU)

func _on_button_4_pressed() -> void:
	get_tree().quit()
