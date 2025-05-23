extends State

func enter(host):
	super.enter(host)
	randomize()
	await get_tree().create_timer(5.0).timeout
	host.is_ready = true

func physics_update(delta: float) -> void:
	var to_target = host.target_pos - host.global_position
	var force = to_target.normalized() * host.speed * to_target.length()
	host.apply_central_force(force)
	if host.is_ready == true:
		transitioned.emit(self,"attack_" + str(randi_range(1,2)))
