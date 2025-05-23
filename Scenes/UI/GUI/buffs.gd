extends Control

@onready var buff: Buff = $MarginContainer/VBoxContainer/HBoxContainer/Buff
@onready var buff_2: Buff = $MarginContainer/VBoxContainer/HBoxContainer/Buff2
@onready var buff_3: Buff = $MarginContainer/VBoxContainer/HBoxContainer/Buff3
@onready var reroll: Button = $MarginContainer/VBoxContainer/Reroll
@onready var label: Label = $MarginContainer/VBoxContainer/Label

var first_option_index = 0
var second_option_index = 1
var third_option_index = 2

var level_up_text = "Level  Up!"
var monster_level_up_text = "Monster  Level  Up!"

var is_reroll = false
var is_ball_selecting = true


func _ready() -> void:
	GameManager.on_level_up.connect(ball_start_selection)
	GameManager.end_selection.connect(ball_end_selection)
	GameManager.on_monster_buff_time.connect(monster_start_selection)
	randomize()
	visible = false
	
func display():
	random_buffs()
	init_buffs()
	visible = true
	
	if is_reroll == true:
		reroll.visible = true
	get_tree().paused = true
	
	buff.visible = false
	buff_2.visible = false
	buff_3.visible = false
	await get_tree().create_timer(0.2).timeout
	buff.visible = true
	await get_tree().create_timer(0.2).timeout
	buff_2.visible = true
	await get_tree().create_timer(0.2).timeout
	buff_3.visible = true
	


func ball_end_selection():
	visible = false
	get_tree().paused = false

func ball_start_selection():
	is_ball_selecting = true
	label.text = level_up_text
	display()

func monster_start_selection():
	is_ball_selecting = false
	label.text = monster_level_up_text
	display()

func random_buffs():
	if is_ball_selecting == true:
		BuffManager.buffs_pool.shuffle()
	elif is_ball_selecting == false:
		BuffManager.monster_buffs_pool.shuffle()
		
	'''if is_ball_selecting == true:
		first_option_index = randi_range(0,BuffManager.buffs_pool.size() - 1)
		while second_option_index == first_option_index:
			second_option_index = randi_range(0,BuffManager.buffs_pool.size() - 1)
		while third_option_index == first_option_index or third_option_index == second_option_index:
			third_option_index = randi_range(0,BuffManager.buffs_pool.size() - 1)
	elif is_ball_selecting == false:
		first_option_index = randi_range(0,BuffManager.monster_buffs_pool.size() - 1)
		while second_option_index == first_option_index:
			second_option_index = randi_range(0,BuffManager.monster_buffs_pool.size() - 1)
		while third_option_index == first_option_index or third_option_index == second_option_index:
			third_option_index = randi_range(0,BuffManager.monster_buffs_pool.size() - 1)		
	else :
		print("random buff error!")'''
		
func init_buffs():
	if is_ball_selecting == true:
		buff.init(BuffManager.buffs_pool[first_option_index].buff_id,
		BuffManager.get_buff_count(BuffManager.buffs_pool[first_option_index].buff_id),
		BuffManager.buffs_pool[first_option_index].description)
		buff.display(is_ball_selecting)
		
		buff_2.init(BuffManager.buffs_pool[second_option_index].buff_id,
		BuffManager.get_buff_count(BuffManager.buffs_pool[second_option_index].buff_id),
		BuffManager.buffs_pool[second_option_index].description)
		buff_2.display(is_ball_selecting)
			
		buff_3.init(BuffManager.buffs_pool[third_option_index].buff_id,
		BuffManager.get_buff_count(BuffManager.buffs_pool[third_option_index].buff_id),
		BuffManager.buffs_pool[third_option_index].description)
		buff_3.display(is_ball_selecting)
		
	elif is_ball_selecting == false:
		buff.init(BuffManager.monster_buffs_pool[first_option_index].buff_id,
		BuffManager.get_buff_count(BuffManager.monster_buffs_pool[first_option_index].buff_id),
		BuffManager.monster_buffs_pool[first_option_index].description)
		buff.display(is_ball_selecting)
		
		buff_2.init(BuffManager.monster_buffs_pool[second_option_index].buff_id,
		BuffManager.get_buff_count(BuffManager.monster_buffs_pool[second_option_index].buff_id),
		BuffManager.monster_buffs_pool[second_option_index].description)
		buff_2.display(is_ball_selecting)
			
		buff_3.init(BuffManager.monster_buffs_pool[third_option_index].buff_id,
		BuffManager.get_buff_count(BuffManager.monster_buffs_pool[third_option_index].buff_id),
		BuffManager.monster_buffs_pool[third_option_index].description)
		buff_3.display(is_ball_selecting)
		
func _on_reroll_pressed() -> void:
	random_buffs()
	init_buffs()
	reroll.visible = false
	is_reroll = true
