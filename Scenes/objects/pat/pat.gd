extends RigidBody2D
class_name Pat

# 配置参数
@export var follow_speed := 2500.0
@export var max_speed := 1000.0
@export var return_speed_multiplier := 0.9
@export var collision_disable_speed := 800.0  # 触发禁用碰撞的速度阈值
@export var collision_recovery_speed := 500.0 # 重新启用碰撞的速度阈值

var home_position := Vector2(360,900)
var was_mouse_outside := true  # 上一帧鼠标是否在视口外

func _ready():
	linear_damp = 30.0
	angular_damp = 1000.0
	continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY

func _physics_process(delta):
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	var is_mouse_inside = viewport.get_visible_rect().has_point(mouse_pos)
	
	# 检测鼠标进入视口的瞬间
	var mouse_just_entered = was_mouse_outside and is_mouse_inside
	was_mouse_outside = not is_mouse_inside
	
	# 动态控制碰撞
	var current_speed = linear_velocity.length()
	if mouse_just_entered and current_speed >= collision_disable_speed:
		set_collision_mask(0)  # 禁用所有碰撞
	elif current_speed <= collision_recovery_speed:
		set_collision_mask(1)  # 恢复碰撞
		
	# 位置更新逻辑
	var target_pos = home_position
	var current_speed_multiplier = follow_speed
	if is_mouse_inside:
		target_pos = get_global_mouse_position()
	else:
		current_speed_multiplier *= return_speed_multiplier
		
	var to_target = target_pos - global_position
	var force = to_target.normalized() * current_speed_multiplier * to_target.length()
	apply_central_force(force)
	
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

# 手动重置碰撞（保险措施）
func enable_collision():
	set_collision_mask(1)
