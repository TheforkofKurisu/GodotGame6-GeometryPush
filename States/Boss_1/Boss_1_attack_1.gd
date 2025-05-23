extends State

var to_right_pos = false
var to_left_pos = false
var to_center_pos = false

func enter(host):
	super.enter(host)
	host.shoot_cd_timer.start()
	host.shoot_timer.start()
	host.move_timer.start()
	
func physics_update(delta: float) -> void:
	if to_right_pos == false and to_center_pos == false and to_left_pos == false:
		move_to_pos(host.right_pos)
	elif to_right_pos == true and to_center_pos == true:
		move_to_pos(host.left_pos)
	elif to_left_pos == true and to_center_pos == true:
		move_to_pos(host.right_pos)
	elif to_right_pos == true:
		move_to_pos(host.target_pos)
	elif to_left_pos == true:
		move_to_pos(host.target_pos)
	else :
		print("move error")
	
func exit():
	host.shoot_cd_timer.stop()
	host.shoot_timer.stop()
	host.move_timer.stop()
	to_right_pos = false
	to_left_pos = false
	to_center_pos = false

func _on_shoot_cd_timer_timeout() -> void:
	GameManager.spawn_monster.emit("monster_3",host.marker_2d.global_position)

func _on_shoot_timer_timeout() -> void:
	transitioned.emit(self,"idle")

func _on_move_timer_timeout() -> void:#三个标志位，左，中，右，用来判断下一步该往哪个方向走
	if to_right_pos == false and to_center_pos == false and to_left_pos == false:
		to_right_pos = true
	elif to_right_pos == true and to_center_pos == true:
		to_left_pos = true
		to_center_pos = false
		to_right_pos = false
	elif to_left_pos == true and to_center_pos == true:
		to_right_pos = true
		to_center_pos = false
		to_left_pos = false
	elif to_right_pos == true:
		to_center_pos = true
	elif to_left_pos == true:
		to_center_pos = true
	else :
		print("move error")
		
func move_to_pos(pos):
	var to_target = pos - host.global_position
	var force = to_target.normalized() * host.speed * 0.67 * to_target.length()
	host.apply_central_force(force)

func check():
	print("left ",to_left_pos)
	print("center ",to_center_pos)
	print("right ",to_right_pos)
	print("~~~~~~~~~~~~~~~~~~~")	
