extends Control

func _on_texture_button_pressed() -> void:
	SceneManager.stop_game.emit()
