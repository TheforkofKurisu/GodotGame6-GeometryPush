extends Node2D

var EXP_get = 0
var EXP_needed = 200
var EXP_value = 0
var level = 0

func _ready() -> void:
	GameManager.on_monster_die.connect(get_exp)
	GameManager.boss_die.connect(get_exp)
	
func get_exp(EXP_get):
	EXP_value += EXP_get
	if EXP_value < EXP_needed:
		GameManager.on_exp_up.emit(level,EXP_needed,EXP_value)
	elif EXP_value >= EXP_needed:
		level += 1
		EXP_value -= EXP_needed
		EXP_needed *= 1.3
		GameManager.on_exp_up.emit(level,EXP_needed,EXP_value)
		GameManager.on_level_up.emit()
