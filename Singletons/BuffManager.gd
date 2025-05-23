extends Node
#Buff相关信号
signal ball_add_attack
signal ball_add_knock_back
signal ball_add_size
signal ball_boost_combo

signal monster_add_health
signal monster_add_speed
signal monster_add_damage
signal monster_decrease_spawn_time

signal player_heal_hp
signal player_add_kill_monster_heal

#Buff质变信号
signal on_ball_add_size_transition
signal on_ball_boost_combo_transition
signal on_player_heal_hp_transition
signal on_player_add_kill_monster_heal_transition
signal on_ball_add_knock_back_transition

const BALL_ADD_ATTACK = preload("res://Resource/ball_add_attack.tres")
const BALL_ADD_KNOCK_BACK = preload("res://Resource/ball_add_knock_back.tres")
const BALL_ADD_SIZE = preload("res://Resource/ball_add_size.tres")
const BALL_BOOST_COMBO = preload("res://Resource/ball_boost_combo.tres")

const MONSTER_ADD_HEALTH = preload("res://Resource/monster_add_health.tres")
const MONSTER_ADD_SPEED = preload("res://Resource/monster_add_speed.tres")
const MONSTER_ADD_DAMAGE = preload("res://Resource/monster_add_damage.tres")
const MONSTER_DECREASE_SPAWN_TIME = preload("res://Resource/monster_decrease_spawn_time.tres")

const PLAYER_HEAL_HP = preload("res://Resource/player_heal_hp.tres")
const PLAYER_ADD_KILL_MONSTER_HEAL = preload("res://Resource/player_add_kill_monster_heal.tres")

var active_buffs = [ ]  # 主存储列表
var buffs_pool = [ BALL_ADD_ATTACK , BALL_ADD_KNOCK_BACK , BALL_ADD_SIZE , PLAYER_HEAL_HP ,
 PLAYER_ADD_KILL_MONSTER_HEAL , BALL_BOOST_COMBO ]
var monster_buffs_pool = [ MONSTER_ADD_HEALTH , MONSTER_ADD_SPEED , MONSTER_ADD_DAMAGE , MONSTER_DECREASE_SPAWN_TIME ]
var limit_buffs_pool = [ PLAYER_HEAL_HP , PLAYER_ADD_KILL_MONSTER_HEAL , BALL_BOOST_COMBO ]

func add_buff(buff_name: String):
	# 先检查是否已有该buff
	for buff in active_buffs:
		if buff["name"] == buff_name:
			buff["count"] += 1
			# 新增逻辑：当层数达到5时执行移除操作
			if buff["count"] == 5:
				match buff["name"]:
					"player_add_kill_monster_heal":
						BuffManager.on_player_add_kill_monster_heal_transition.emit()
					"player_heal_hp":
						BuffManager.on_player_heal_hp_transition.emit()
					"ball_boost_combo":
						BuffManager.on_ball_boost_combo_transition.emit()
					"ball_add_size":
						BuffManager.on_ball_add_size_transition.emit()
					"ball_add_knock_back":
						BuffManager.on_ball_add_knock_back_transition.emit()
					
				for limit_buff in limit_buffs_pool:
					if limit_buff.buff_id == buff["name"]:
						_remove_from_pools_by_id(buff_name)
			return	
	# 新buff的初始化逻辑
	active_buffs.append({
		"name": buff_name,
		"count": 1
	})
# 删除指定名称的所有层数
func remove_buff(buff_name: String):
	# 从后往前遍历避免索引错位
	for i in range(active_buffs.size() -1, -1, -1):
		if active_buffs[i]["name"] == buff_name:
			active_buffs.remove_at(i)

# 减少层数函数
func decrement_buff(buff_name: String):
	# 需要先找到所有匹配项
	for i in range(active_buffs.size() -1, -1, -1):
		if active_buffs[i]["name"] == buff_name:
			active_buffs[i]["count"] -= 1
			if active_buffs[i]["count"] <= 0:
				active_buffs.remove(i)
			break  # 只操作第一个匹配项

# 查询是否存在某个 buff
func has_buff(buff_name: String) -> bool:
	for buff in active_buffs:
		if buff["name"] == buff_name:
			return true
	return false

# 获取指定 buff 的当前层数
func get_buff_count(buff_name: String) -> int:
	for buff in active_buffs:
		if buff["name"] == buff_name:
			return buff["count"]
	return 0  # 不存在返回0

# 清空所有 buff
func clear_all_buffs():
	active_buffs.clear()

# 新增辅助函数：通过buff_id从所有资源池中移除
func _remove_from_pools_by_id(target_id: String):
	# 从后向前遍历避免索引错位
	for i in range(buffs_pool.size() - 1, -1, -1):
		if buffs_pool[i].buff_id == target_id:
			buffs_pool.remove_at(i)
	
	for i in range(monster_buffs_pool.size() - 1, -1, -1):
		if monster_buffs_pool[i].buff_id == target_id:
			monster_buffs_pool.remove_at(i)
