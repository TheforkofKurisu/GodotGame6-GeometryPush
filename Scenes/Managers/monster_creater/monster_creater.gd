extends Node2D

@onready var monster_holder: Node2D = $MonsterHolder
@onready var monster_spawn_timer: Timer = $"../Timers/MonsterSpawnTimer"

var monster_spawn_time = 1

const MONSTER_3 = preload("res://Scenes/objects/monsters/monster_3.tscn")
const MONSTER_4 = preload("res://Scenes/objects/monsters/monster_4.tscn")

const MONSTER_LIST = [ MONSTER_3 , MONSTER_4]

func _ready() -> void:
	randomize()
	GameManager.spawn_monster.connect(spawn_monster)
	BuffManager.monster_decrease_spawn_time.connect(monster_decrease_spawn_time)
	
func spawn_monster(monster_name:String , position = Vector2(randf_range(40,680),randf_range(-100,0))):
	match monster_name:
		"monster_3":
			var new_monster = MONSTER_3.instantiate()
			new_monster.position = position
			monster_holder.add_child(new_monster)
		"monster_4":
			var new_monster = MONSTER_4.instantiate()
			new_monster.position = position
			monster_holder.add_child(new_monster)


func _on_monster_spawn_timer_timeout() -> void:
	var random_monster_index = randi_range(0,MONSTER_LIST.size() - 1)
	spawn_monster("monster_" + str(random_monster_index + 3))
	monster_spawn_timer.wait_time = monster_spawn_time

func monster_decrease_spawn_time():
	if monster_spawn_time > 0.4:
		monster_spawn_time -= 0.2
