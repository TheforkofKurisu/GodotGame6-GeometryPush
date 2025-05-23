extends Control

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var combo_number = 0
var reset_number = 0
var reset_flag = false
var yellow_color = Color(0.761,0.91,0.071)
var red_color = Color(0.388,0.012,0.078)


func _ready() -> void:
	GameManager.on_ball_collide_with_pat.connect(add_combo)
	GameManager.on_ball_exit_screen.connect(clear_combo)
	BuffManager.on_ball_boost_combo_transition.connect(on_ball_boost_combo_transition)

func _process(delta: float) -> void:
	check_reset_number()
	
func check_combo():
	if combo_number >= 10:
		label.add_theme_color_override("font_color", yellow_color)
	elif combo_number >= 15:
		label.add_theme_color_override("font_color", red_color)
		
func add_combo():
	combo_number += 1
	GameManager.on_combo_change.emit(combo_number)
	var tween = create_tween()
	tween.tween_property(label,"text",str(combo_number),0.1)
	animation_player.play("add_combo")

func clear_combo():
	combo_number = reset_number
	GameManager.on_combo_change.emit(combo_number)
	label.text = str(combo_number)

func on_ball_boost_combo_transition():
	reset_flag = true

func check_reset_number():
	if reset_flag == false:
		return
	elif reset_flag == true:
		reset_number = int(combo_number * 0.5)
