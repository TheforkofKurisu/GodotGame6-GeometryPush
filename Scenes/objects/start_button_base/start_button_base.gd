extends RigidBody2D

class_name StartButtonBase

@onready var label: Label = $Label

func _on_body_entered(body: Node) -> void:
	if body is Ball:
		if label.text == "开始":
			SceneManager.start_game.emit()	
		if label.text == "离开":
			SceneManager.exit_game.emit()
		if label.text == "设置":
			SceneManager.enter_options.emit()
