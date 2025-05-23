extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

var max_HP = 100
var HP = 100

func _ready() -> void:
	init()
	GameManager.on_HP_changed.connect(on_HP_changed)
	BuffManager.on_player_heal_hp_transition.connect(on_player_heal_hp_transition)
	
func on_HP_changed(change_value,is_add = true):
	if is_add == true:
		HP += change_value
	elif is_add == false:
		HP -= change_value
	
	var tween = create_tween()
	tween.tween_property(texture_progress_bar,"value",HP,0.2)

func on_player_heal_hp_transition():
	max_HP += 50
	init()

func init():
	texture_progress_bar.max_value = max_HP
	texture_progress_bar.value = HP
