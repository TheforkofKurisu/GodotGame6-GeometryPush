extends Boss

const JUMPING_DAMAGE_NUMBER_BOSS = preload("res://Scenes/UI/jumping_damage_number/jumping_damage_number_boss.tscn")

@onready var marker_2d: Marker2D = $Marker2D
@onready var shoot_timer: Timer = $Timers/ShootTimer
@onready var shoot_cd_timer: Timer = $Timers/ShootCDTimer
@onready var move_timer: Timer = $Timers/MoveTimer
@onready var idle_timer: Timer = $Timers/IdleTimer
@onready var rock_attack_timer: Timer = $Timers/RockAttackTimer
@onready var rock_attack_cd_timer: Timer = $Timers/RockAttackCDTimer
@onready var state_machine: Node = $StateMachine
@onready var label: Label = $Label
@onready var jumping_labels: Control = $JumpingLabels
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

var HP = 1000
var max_HP = 1000

var exp = 1000

var speed = 10000
var target_pos = Vector2(360,150)
var right_pos = Vector2(660,150)
var left_pos = Vector2(60,150)

var is_ready = false
var is_attacking = false
var is_hurt = false

var in_mode_time = 0

var label_position = Vector2(-26,-80)#伤害跳字标签相对于父节点的位置
var label_jump_distance = 30#伤害跳字标签跳跃距离
var label_scale = Vector2(10,10)

func _ready() -> void:
	randomize()
	linear_damp = 8.0
	
func _physics_process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node) -> void:
	if body is Ball and is_hurt == false:
		HP -= body.attribute.attack
		spawm_damage_label(body.attribute.attack)
		animation_player.play("boss_hurt")
		is_hurt = true
		await get_tree().create_timer(0.67).timeout
		is_hurt = false
		if HP <= 0:
			gpu_particles_2d.emitting = false
			gpu_particles_2d.restart()
			gpu_particles_2d.emitting = true
			animation_player.play("boss_die")
			await animation_player.animation_finished
			GameManager.boss_die.emit(exp)
			queue_free()
		
func spawm_damage_label(damage):
	var new_label = JUMPING_DAMAGE_NUMBER_BOSS.instantiate()
	new_label.position = label_position
	new_label.text = str(damage)
	jumping_labels.add_child(new_label)
	var dir_point = Vector2(randf_range(-100.0,100.0),randf_range(label_position.x,100.0))
	var direction = (label_position - dir_point).normalized()
	var tween = create_tween()
	tween.tween_property(new_label , "position" , label_position + direction * label_jump_distance , 0.6)
	new_label.play()


	
