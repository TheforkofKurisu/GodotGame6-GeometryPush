extends RigidBody2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

const BALL_RADIUS = 25  # 小球半径

const SCREEN_RIGHT = 720
const SCREEN_LEFT = 0
const SCREEN_UP = 0
const SCREEN_DOWN = 1280

func _ready() -> void:
	GameManager.rock_attack.connect(rock_attack)
	apply_central_impulse(Vector2(0,300))
	
func _physics_process(delta: float) -> void:
	apply_central_force(Vector2(0,200))

func _on_body_entered(body: Node) -> void:
	if body is Ball:
		var rock_to_ball = (body.global_position - self.global_position).normalized()
		var collision_point = body.global_position - rock_to_ball * BALL_RADIUS
		gpu_particles_2d.global_position = collision_point
		gpu_particles_2d.look_at(body.global_position)
		
		if body.attribute.speed < 200.0:
			gpu_particles_2d.amount = 10
		elif body.attribute.speed >= 200.0:
			var percentage = body.attribute.speed / 2000.0
			gpu_particles_2d.amount = 10 + percentage * 20
		
		gpu_particles_2d.emitting = false
		gpu_particles_2d.restart()
		gpu_particles_2d.emitting = true

func rock_attack(target_position,impulse):
	self.linear_velocity = Vector2(0,0)
	var force = target_position - global_position
	apply_central_impulse(force.normalized() * impulse * force.length())


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if position.y > SCREEN_DOWN or position.x <= SCREEN_LEFT or position.x > SCREEN_RIGHT:
		queue_free()
