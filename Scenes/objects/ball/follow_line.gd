extends Line2D

var previous_position = Vector2.ZERO
var ball_radius = 0.0

func _ready() -> void:
	init()
	
func _process(delta: float) -> void:
	var current_position = get_parent().global_position
	var direction = (current_position - previous_position).normalized()
	
	add_point(current_position - ball_radius * direction)
	if points.size() > 20:
		remove_point(0)
		
	previous_position = current_position 

func init():
	var texture1 = get_parent().texture
	ball_radius = get_parent().scale.x * texture1.get_size().x * 0.5
	previous_position = get_parent().global_position	
