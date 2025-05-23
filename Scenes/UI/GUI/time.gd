extends Control

@onready var timer: Timer = $Timer
@onready var label: Label = $Label

var min = 0
var s = 0

var is_stop = false
var is_min_reach_10 = false
var is_s_reach_10 = false
var spawn_boss = false


func _ready() -> void:
	GameManager.boss_die.connect(boss_die)

func _process(delta: float) -> void:
	check_position_number()
	display_time()
	check_boss_spawn()
	
func display_time():
	if is_min_reach_10 == true and is_s_reach_10 == true:
		label.text = str(min) + ":" + str(s)
	elif is_min_reach_10 == true and is_s_reach_10 == false:
		label.text = str(min) + ":0" + str(s)
	elif is_min_reach_10 == false and is_s_reach_10 == true:
		label.text = "0" + str(min) + ":" + str(s)
	else:
		label.text = "0" + str(min) + ":0" + str(s)	
					
func check_position_number():
	if s >= 60:
		min += 1
		s = 0
		GameManager.on_monster_buff_time.emit()
		is_s_reach_10 = false
		if min >= 10:
			is_min_reach_10 = true

func _on_timer_timeout() -> void:
	if is_stop == false:
		s += 1
		if s >= 10:
			is_s_reach_10 = true
	
func check_boss_spawn():
	if spawn_boss == false:
		if min == 2:
			if s == 30:
				spawn_boss = true
				is_stop = true
				s += 1
		elif min == 5:
			if s == 0:
				spawn_boss = true
				is_stop = true
				s += 1
		elif min == 7:
			if s == 30:
				spawn_boss = true
				is_stop = true
				s += 1
		elif min == 10:
			if s == 0:
				spawn_boss = true
				is_stop = true
				s += 1
		if spawn_boss == true:
			GameManager.spawn_boss.emit()

func boss_die(exp):
	spawn_boss = false
	is_stop = false
