extends StaticBody2D

@onready var gpu_particles_2d: GPUParticles2D = $Area2D/GPUParticles2D

var contact_point = Vector2.ZERO
var offset = Vector2.ZERO

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Ball:
		if self.position.x <= 0:#左
			offset.x = 5
			offset.y = body.position.y - self.position.y
		elif self.position.y <= 0:#上
			offset.x = body.position.x - self.position.x
			offset.y = 5
		elif self.position.x >= 720:#右
			offset.x = -5
			offset.y = body.position.y - self.position.y
			gpu_particles_2d.rotation_degrees = 180
		elif self.position.y >= 1280:#下
			offset.x = body.position.x - self.position.x
			offset.y = -5
			gpu_particles_2d.rotation_degrees = 180
		
		if body.attribute.speed < 200.0:
			gpu_particles_2d.amount = 10
		elif body.attribute.speed >= 200.0:
			var percentage = body.attribute.speed / 2000.0
			gpu_particles_2d.amount = 10 + percentage * 40
		contact_point = self.position + offset
		gpu_particles_2d.global_position = contact_point
		gpu_particles_2d.emitting = false
		gpu_particles_2d.restart()
		gpu_particles_2d.emitting = true
