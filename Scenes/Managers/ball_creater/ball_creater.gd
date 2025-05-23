extends Node2D

@onready var ball_holder: Node2D = $BallHolder

var max_balls_num = 1
var ball_count = 0
var is_processing_add: bool = false

const SCREEN_UP = 0
const SCREEN_DOWN = 1280
const SCREEN_LEFT = 0
const SCREEN_RIGHT = 720

func _ready() -> void:
	randomize()
	GameManager.on_ball_exit_screen.connect(on_ball_exit_screen)
	BuffManager.on_ball_add_size_transition.connect(on_ball_add_size_transition)
	BuffManager.on_ball_add_knock_back_transition.connect(on_ball_add_knock_back_transition)
		
func on_ball_exit_screen():
	ball_count -= 1
	for ball in ball_holder.get_children():
		if ball is Ball:
			if ball.position.y >= SCREEN_DOWN or ball.position.y <= SCREEN_UP or ball.position.x >= SCREEN_RIGHT or ball.position.x <= SCREEN_LEFT:
				ball.ball_die()			
	spawn_ball()

func spawn_ball(spawn_pos = Vector2(360,640)):
	var spawn_num = max_balls_num - ball_count
	for i in range(spawn_num):
		var new_ball = GameManager.BALL.instantiate()
		new_ball.global_position = spawn_pos
		ball_holder.add_child(new_ball)	
		ball_count += 1 
	
func add_ball():
	if !is_processing_add:
		is_processing_add = true
		call_deferred("_deferred_add_ball")

func _deferred_add_ball():
	if max_balls_num <= 3:
		max_balls_num += 1
		spawn_ball()
	is_processing_add = false

func on_ball_add_size_transition():
	add_ball()

func on_ball_add_knock_back_transition():
	add_ball()
