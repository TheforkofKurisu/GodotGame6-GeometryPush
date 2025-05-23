extends Node

@onready var music_slider: HSlider = $VBoxContainer/VBoxContainer/HBoxContainer/HSlider
@onready var SFX_slider: HSlider = $VBoxContainer/VBoxContainer/HBoxContainer2/HSlider

func _ready() -> void:
	music_slider.value = AudioManager.music_value
	SFX_slider.value = AudioManager.SFX_value

func _on_button_button_down() -> void:
	SceneManager.change_to_scene_with_ball(SceneManager.MAIN_MENU)


func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.set_volume(AudioManager.Bus.MUSIC,value)
	AudioManager.music_value = value

func _on_SFX_slider_value_changed(value: float) -> void:
	AudioManager.set_volume(AudioManager.Bus.SFX,value)
	AudioManager.SFX_value = value
