extends Label

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play():
	animation_player.play("on_damage")
	await animation_player.animation_finished
	queue_free()

func update_label_font_size(size):
	var label = $"."
	var label_settings = label.label_settings if label.label_settings else LabelSettings.new()
	label_settings.font_size = size
	label.label_settings = label_settings
