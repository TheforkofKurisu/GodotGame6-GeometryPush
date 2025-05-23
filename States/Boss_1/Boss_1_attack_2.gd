extends State

var ball:Ball
var impulse = 10

func enter(host):
	super.enter(host)
	ball = get_tree().get_first_node_in_group("ball")
	host.rock_attack_timer.start()
	host.rock_attack_cd_timer.start()
	
func physics_update(delta: float) -> void:
	if ball == null:
		ball = get_tree().get_first_node_in_group("ball")

func exit():
	host.rock_attack_timer.stop()
	host.rock_attack_cd_timer.stop()

func _on_rock_attack_timer_timeout() -> void:
	transitioned.emit(self,"idle")

func _on_rock_attack_cd_timer_timeout() -> void:
	GameManager.spawn_rock.emit("rock_1",host.marker_2d.global_position + Vector2(0,50))
	GameManager.rock_attack.emit(ball.position,impulse)
