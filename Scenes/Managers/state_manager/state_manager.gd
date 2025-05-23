extends Node2D

var max_HP = 100
var HP = 100

var heal_value = 0

func _ready() -> void:
	GameManager.on_monster_escape.connect(on_monster_escape)
	GameManager.on_monster_die_heal.connect(on_monster_die_heal)
	BuffManager.player_heal_hp.connect(add_heal_value)
	BuffManager.on_player_heal_hp_transition.connect(on_player_heal_hp_transition)
	
func on_monster_escape(damage):
	HP -= damage
	if HP <= 0:
		SignalManager.game_over.emit()
	GameManager.on_HP_changed.emit(damage,false)
	
func _on_timer_timeout() -> void:
	HP += heal_value
	GameManager.on_HP_changed.emit(heal_value,true)

func add_heal_value():
	heal_value += 0.5 

func on_monster_die_heal(heal):
	HP += heal
	GameManager.on_HP_changed.emit(heal,true)

func on_player_heal_hp_transition():
	max_HP += 50
