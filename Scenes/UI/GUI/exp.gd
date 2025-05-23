extends Control

@onready var label: Label = $Label
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

var level = 0
var EXP_needed = 0
var EXP_value = 0
var is_level_up = false

func _ready() -> void:
	GameManager.on_exp_up.connect(on_exp_up)

func on_exp_up(level,EXP_needed,EXP_value):
	if level > self.level:
		is_level_up = true
	self.level = level
	self.EXP_needed = EXP_needed
	self.EXP_value = EXP_value
	
	label.text = str(self.level)

	if is_level_up == true:
		var tween_up = get_tree().create_tween()
		tween_up.tween_property(texture_progress_bar,"value",self.EXP_needed,0.1)
		texture_progress_bar.value = 0
		texture_progress_bar.max_value = self.EXP_needed
		tween_up.tween_property(texture_progress_bar,"value",self.EXP_value,0.1)
	elif is_level_up == false:
		texture_progress_bar.max_value = self.EXP_needed	
		var tween = get_tree().create_tween()
		tween.tween_property(texture_progress_bar,"value",self.EXP_value,0.2)
	
	is_level_up = false
