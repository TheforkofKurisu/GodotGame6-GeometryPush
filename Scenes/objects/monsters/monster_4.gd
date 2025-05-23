extends MonsterBase

class_name monster_4

func _ready() -> void:
	#配置属性
	attribute.speed = 100 + attribute.speed_buff_count * attribute.speed_buff_amount
	attribute.HP = 24 + attribute.health_buff_count * attribute.health_buff_amount
	attribute.EXP = 200
	attribute.damage = 10 + attribute.damage_buff_count * attribute.damage_buff_amount
	attribute.heal_value = 1 + attribute.heal_value_buff_count * attribute.heal_value_buff_amount
