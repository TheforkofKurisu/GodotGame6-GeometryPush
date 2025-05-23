extends VBoxContainer

class_name Buff

@onready var texture_button: TextureButton = $TextureButton
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var label: Label = $TextureButton/MarginContainer/Label
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

var buff_name:String = ""
var count = 0
var description:String = ""

var is_ball_selecting = true

func init(buff_name,count = 0,description = "NOT FOUND!"):
	self.buff_name = buff_name
	self.count = count
	self.description = description

func display(is_ball_selecting = true):
	label.text = description
	if is_ball_selecting == true:
		texture_progress_bar.value = count
		texture_progress_bar.visible = true
	elif is_ball_selecting == false:
		texture_progress_bar.visible = false
	
func _on_button_pressed() -> void:
	gpu_particles_2d.emitting = true
	await  get_tree().create_timer(0.3).timeout
	BuffManager.add_buff(buff_name)	
	match buff_name: 
		"ball_add_attack":
			BuffManager.ball_add_attack.emit()
		"ball_add_knock_back":
			BuffManager.ball_add_knock_back.emit()
		"ball_add_size":
			BuffManager.ball_add_size.emit()
		"monster_add_health":
			BuffManager.monster_add_health.emit()
		"monster_add_speed":
			BuffManager.monster_add_speed.emit()
		"monster_add_damage":
			BuffManager.monster_add_damage.emit()
		"player_heal_hp":
			BuffManager.player_heal_hp.emit()
		"player_add_kill_monster_heal":
			BuffManager.player_add_kill_monster_heal.emit()
		"ball_boost_combo":
			BuffManager.ball_boost_combo.emit()
		"monster_decrease_spawn_time":
			BuffManager.monster_decrease_spawn_time.emit()
			
	GameManager.end_selection.emit()
			
