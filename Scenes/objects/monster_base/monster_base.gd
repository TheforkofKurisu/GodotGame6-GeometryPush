extends RigidBody2D

class_name MonsterBase

const JUMPING_DAMAGE_NUMBER = preload("res://Scenes/UI/jumping_damage_number/jumping_damage_number.tscn")

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var jumping_labels: Control = $JumpingLabels
@onready var attribute: Node2D = $Attribute

const SCREEN_RIGHT = 720
const SCREEN_LEFT = 0
const SCREEN_UP = 0
const SCREEN_DOWN = 1280

var label_position = Vector2(-26,-80)#伤害跳字标签相对于父节点的位置
var label_jump_distance = 30#伤害跳字标签跳跃距离

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	position.y += attribute.speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Ball:
		attribute.HP -= body.attribute.attack
		if attribute.is_dead == false:
			var percentage = body.attribute.speed / body.attribute.max_speed
			knock_back(body.position,body.attribute.knock_back_distance * percentage)
			spawm_damage_label(body.attribute.attack)
		if attribute.HP <= 0 and attribute.is_dead == false:
			attribute.is_dead = true
			GameManager.on_monster_die_heal.emit(attribute.heal_value)
			
			if body.attribute.speed < 200.0:
				gpu_particles_2d.amount = 10
			elif body.attribute.speed >= 200.0:
				var percentage = body.attribute.speed / 2000.0
				gpu_particles_2d.amount = 10 + percentage * 50
			gpu_particles_2d.look_at(body.global_position)
			animation_player.play("monster_die")
			gpu_particles_2d.emitting = true
			GameManager.on_monster_die.emit(attribute.EXP)
			await get_tree().create_timer(1.0).timeout
			
			monster_die()
			
		animation_player.play("monster_hurt")


		
func monster_die():
	queue_free()

func spawm_damage_label(damage):
	var new_label = JUMPING_DAMAGE_NUMBER.instantiate()
	new_label.position = label_position
	new_label.text = str(damage)
	jumping_labels.add_child(new_label)
	var dir_point = Vector2(randf_range(-100.0,100.0),randf_range(label_position.x,100.0))
	var direction = (label_position - dir_point).normalized()
	var tween = create_tween()
	tween.tween_property(new_label , "position" , label_position + direction * label_jump_distance , 0.6)
	new_label.play()

func knock_back(ball_position,knock_back_distance):
	var direction = (ball_position - self.position).normalized()
	if direction.y > 0:
		var tween = create_tween()
		var target_pos = self.position + -direction * knock_back_distance
		target_pos.x = clampf(target_pos.x,30.0,690.0)
		tween.tween_property(self , "position" , target_pos , 0.2)

		
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if position.y > SCREEN_DOWN or position.x <= SCREEN_LEFT or position.x > SCREEN_RIGHT:
		GameManager.on_monster_escape.emit(attribute.damage)
		queue_free()
	
