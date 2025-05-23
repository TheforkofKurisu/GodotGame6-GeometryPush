extends Control

@onready var label_3: Label = $MarginContainer/VBoxContainer/Label3

func _ready() -> void:
	visible = false

func _on_button_pressed() -> void:
	get_tree().paused = false
	SceneManager.change_to_scene_with_ball(SceneManager.MAIN)

func _on_button_2_pressed() -> void:
	get_tree().paused = false
	SceneManager.change_to_scene_with_ball(SceneManager.MAIN_MENU)

func game_over(level = 0):
	label_3.text = str(level)
	
