extends State

func enter(host):
	super.enter(host)
	randomize()
	host.idle_timer.start()

func physics_update(delta: float) -> void:
	var to_target = host.target_pos - host.global_position
	var force = to_target.normalized() * host.speed * to_target.length()
	host.apply_central_force(force)

func exit():
	host.idle_timer.stop()

func _on_idle_timer_timeout() -> void:
	var index = randi_range(1,2)
	transitioned.emit(self,"attack_" + str(index))
