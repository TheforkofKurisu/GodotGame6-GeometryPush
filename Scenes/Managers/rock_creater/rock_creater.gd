extends Node2D

@onready var rock_holder: Node2D = $RockHolder

const ROCK_1 = preload("res://Scenes/objects/rocks/rock_1.tscn")
const ROCK_2 = preload("res://Scenes/objects/rocks/rock_2.tscn")
const ROCK_3 = preload("res://Scenes/objects/rocks/rock_3.tscn")
const ROCK_4 = preload("res://Scenes/objects/rocks/rock_4.tscn")
const ROCK_5 = preload("res://Scenes/objects/rocks/rock_5.tscn")
const ROCK_6 = preload("res://Scenes/objects/rocks/rock_6.tscn")
const ROCK_LIST = [ ROCK_1 , ROCK_2 , ROCK_3 , ROCK_4 , ROCK_5 , ROCK_6]

func _ready() -> void:
	randomize()
	GameManager.spawn_rock.connect(spawn_rock)

func spawn_rock(rock_name:String , position = Vector2(randf_range(40,680),randf_range(-100,-50)) ):
	match rock_name:
		"rock_1":
			var new_rock = ROCK_1.instantiate()
			new_rock.position = position	
			rock_holder.add_child(new_rock)
		"rock_2":
			var new_rock = ROCK_2.instantiate()
			new_rock.position = position	
			rock_holder.add_child(new_rock)
		"rock_3":
			var new_rock = ROCK_3.instantiate()
			new_rock.position = position	
			rock_holder.add_child(new_rock)
		"rock_4":
			var new_rock = ROCK_4.instantiate()
			new_rock.position = position	
			rock_holder.add_child(new_rock)
		"rock_5":
			var new_rock = ROCK_5.instantiate()
			new_rock.position = position	
			rock_holder.add_child(new_rock)
		"rock_6":
			var new_rock = ROCK_6.instantiate()
			new_rock.position = position	
			rock_holder.add_child(new_rock)
			
func _on_rock_spawn_timer_timeout() -> void:
	var random_rock_index = randi_range(0,ROCK_LIST.size() - 1)
	spawn_rock("rock_" + str(random_rock_index))
