extends Node

class_name State

signal transitioned

@export var host: Node

func enter(_host: Node) -> void:
	host = _host  # 接收宿主对象

func exit():
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass
