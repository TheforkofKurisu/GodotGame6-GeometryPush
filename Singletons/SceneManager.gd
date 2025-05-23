extends Node

#场景切换相关信号
signal start_game
signal exit_game
signal enter_options
signal stop_game

const MAIN = preload("res://Scenes/main/main.tscn")
const MAIN_MENU = preload("res://Scenes/main_menu/main_menu.tscn")
const OPTIONS = preload("res://Scenes/options/options.tscn")

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var start_position: Vector2 = Vector2(360,640)
var end_position: Vector2 = Vector2(360,640)

var is_transiting = false

func _ready() -> void:
	self.visible = false
	
func change_scene_to_exit_game(target_pos):
	self.visible = true
	self.layer = 999
	start_position = target_pos
	color_rect.material.set_shader_parameter("center_absolute", start_position)
	animation_player.play("transition")
	await animation_player.animation_finished
	
	get_tree().quit()

func change_to_scene_with_ball(path,target_pos = start_position):
	if is_transiting == false:
		is_transiting == true
		self.visible = true
		self.layer = 999
		start_position = target_pos
		color_rect.material.set_shader_parameter("center_absolute", start_position)
		animation_player.play("transition")
		await animation_player.animation_finished
		
		get_tree().change_scene_to_packed(path)

		color_rect.material.set_shader_parameter("center_absolute", end_position)
		animation_player.play_backwards("transition")
		await animation_player.animation_finished
		self.layer = -1
		self.visible = false
		is_transiting == false
		
func change_to_scene(path):
	get_tree().change_scene_to_packed(path)
	
