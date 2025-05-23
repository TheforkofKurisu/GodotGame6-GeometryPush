extends BuffSystem

#基础属性
var speed = 0
var HP = 10
var is_dead = false
var EXP = 100
var damage = 0
var heal_value = 0

var health_buff_amount = 10
var health_buff_count = 0
var speed_buff_amount = 100
var speed_buff_count = 0
var damage_buff_amount = 5
var damage_buff_count = 0
var heal_value_buff_amount = 1
var heal_value_buff_count = 0

func _ready() -> void:
	BuffManager.monster_add_health.connect(monster_add_health)
	BuffManager.monster_add_speed.connect(monster_add_speed)
	BuffManager.monster_add_damage.connect(monster_add_damage)
	BuffManager.player_add_kill_monster_heal.connect(player_add_kill_monster_heal)
	
	for buff in BuffManager.active_buffs:
		var buff_name = buff["name"]
		var count = buff["count"]
		match buff_name:
			"monster_add_health":
				health_buff_count += count
			"monster_add_speed":
				speed_buff_count += count
			"monster_add_damage":
				damage_buff_count += count
			"player_add_kill_monster_heal":
				heal_value_buff_count += count
				if count == 5:
					heal_value_buff_count += 2.5
	
func monster_add_health():
	HP += health_buff_amount
	
func monster_add_speed():
	speed += speed_buff_amount
	
func monster_add_damage():
	damage += damage_buff_amount

func player_add_kill_monster_heal():
	heal_value += heal_value_buff_amount
