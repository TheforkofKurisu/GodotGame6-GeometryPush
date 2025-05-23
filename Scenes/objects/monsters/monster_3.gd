extends MonsterBase

class_name monster_3

func _ready() -> void:
	#配置属性
	attribute.speed = 100 + attribute.speed_buff_count * attribute.speed_buff_amount
	attribute.HP = 12 + attribute.health_buff_count * attribute.health_buff_amount
	attribute.EXP = 100
	attribute.damage = 5 + attribute.damage_buff_count * attribute.damage_buff_amount
	attribute.heal_value = 1 + attribute.heal_value_buff_count * attribute.heal_value_buff_amount
