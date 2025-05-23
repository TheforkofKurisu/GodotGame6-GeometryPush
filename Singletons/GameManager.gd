extends Node

#怪物相关
signal on_monster_die
signal on_monster_escape
signal spawn_monster
signal on_monster_buff_time
signal on_monster_die_heal
signal spawn_boss
signal boss_die

#小球相关
signal on_ball_collide
signal on_ball_collide_with_pat
signal on_ball_exit_screen
signal on_combo_change

#经验相关
signal on_level_up
signal on_exp_up
signal end_selection

#岩石相关
signal spawn_rock
signal rock_attack

#主游戏相关
signal on_HP_changed

#引用
const BALL = preload("res://Scenes/objects/ball/ball.tscn")

#常量
