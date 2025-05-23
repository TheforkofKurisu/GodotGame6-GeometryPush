extends BuffSystem

#基础属性
var speed = 0
var max_speed = 2000
var attack = 10
var max_attack = 100
var knock_back_distance = 100
var ball_size = 0.03

var attack_buff_amount = 5
var attack_buff_count = 0
var knock_back_buff_amount = 50
var knock_back_buff_count = 0
var size_buff_amount = 0.002
var size_buff_count = 0

var combo_number = 0
var combo_attack_buff = 1
var combo_attack_buff_amount = 1
var combo_attack_buff_count = 0

func _ready() -> void:
	BuffManager.ball_add_attack.connect(ball_add_attack)
	BuffManager.ball_add_knock_back.connect(ball_add_knock_back)
	BuffManager.ball_add_size.connect(ball_add_size)
	BuffManager.ball_boost_combo.connect(ball_boost_combo)
	GameManager.on_combo_change.connect(ball_combo_change)
	
	for buff in BuffManager.active_buffs:
		var buff_name = buff["name"]
		var count = buff["count"]
		match buff_name:
			"ball_add_attack":
				attack_buff_count += count
			"ball_add_knock_back":
				knock_back_buff_count += count
			"ball_add_size":
				size_buff_count += count
			"ball_boost_combo":
				combo_attack_buff_count += count
				
func ball_combo_change(combo_num):
	combo_number = combo_num
	attack += combo_attack_buff
		
func ball_add_attack():
	attack += attack_buff_amount

func ball_add_knock_back():
	knock_back_distance += knock_back_buff_amount

func ball_add_size():
	ball_size += size_buff_amount

func ball_boost_combo():
	combo_attack_buff += combo_attack_buff_amount
