extends RigidBody2D

class_name Ball

@onready var attribute: Node2D = $Attribute
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var line_2d: Line2D = $Sprite2D/Line2D

const SCREEN_RIGHT = 720
const SCREEN_LEFT = 0
const SCREEN_UP = 0
const SCREEN_DOWN = 1280

func _ready() -> void:
	randomize()
	init_ball()

func _physics_process(delta: float) -> void:
	limit_ball_speed()
	check_ball_size()

func check_ball_size():
	if sprite_2d.scale != Vector2(attribute.ball_size,attribute.ball_size):
		var percentage = attribute.ball_size / sprite_2d.scale.x
		sprite_2d.scale = Vector2(attribute.ball_size,attribute.ball_size)
		collision_shape_2d.scale *= percentage
		line_2d.init()
		
func limit_ball_speed():
	if linear_velocity.length() >= attribute.max_speed:
		linear_velocity = linear_velocity.normalized() * attribute.max_speed
	attribute.speed = linear_velocity.length()	

func _on_body_entered(body: Node) -> void:
	if body is not Pat:
		GameManager.on_ball_collide.emit()
	elif body is Pat:
		GameManager.on_ball_collide_with_pat.emit()
	elif body is StartButtonBase:
		linear_velocity = Vector2.ZERO
	play_random_collide_SFX()
	
func ball_die():
	queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	GameManager.on_ball_exit_screen.emit()

func init_ball():
	attribute.attack = 10 + attribute.attack_buff_count * attribute.attack_buff_amount
	attribute.attack += attribute.combo_number * attribute.combo_attack_buff
	attribute.knock_back_distance = 100 + attribute.knock_back_buff_count * attribute.knock_back_buff_amount
	attribute.ball_size = 0.03 + attribute.size_buff_count * attribute.size_buff_amount
	attribute.combo_attack_buff = 1 + attribute.combo_attack_buff_count * attribute.combo_attack_buff_amount

func play_random_collide_SFX():
	var index = randi_range(1,5)
	var SFX = "collide_" + str(index)
	AudioManager.play_sfx(SFX,AudioManager.PitchMode.RANDOM)
