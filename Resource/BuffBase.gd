# BuffBase.gd
@tool
class_name BuffBase
extends Resource

## 基础身份系统（在Inspector面板中会显示为分组标题）
## 唯一标识符（英文小写，禁止重复）
@export var buff_id: String = "base_buff"

## 显示用名称（支持多语言本地化）
@export var display_name: String = "基础增益"

## 图标资源（推荐64x64像素）
@export var icon: Texture2D

## 动态描述文本（使用{value}占位符自动替换数值）
@export_multiline var description: String = "提升{value}% 效果"

## 目标过滤系统
## 可作用对象类型标签（如player/enemy/npc）
@export var target_types: Array[String] = ["player"]

## 目标属性名称（需与角色属性系统匹配）
@export var target_attribute: String = "attack"

## 数值计算系统
## 基础数值（加法运算优先计算）
@export var base_value: float = 0.0

## 倍率系数（乘法运算后于基础值）
@export_range(0.0, 10.0, 0.1) var multiplier: float = 1.0

## 是否以百分比形式显示（不影响实际计算）
@export var is_percentage: bool = false

## 时间控制系统
## 持续时间（秒，-1为永久生效）
@export var duration: float = -1.0

## 效果触发间隔（秒，0为无间隔）
@export var tick_interval: float = 1.0

## 堆叠系统
## 最大叠加层数（相同Buff叠加次数）
@export_range(1, 99) var max_stacks: int = 1

## 叠加时是否刷新持续时间
@export var refresh_duration: bool = true

## 生效优先级（数值大的覆盖小的）
@export var priority: int = 0

## 触发事件系统（枚举下拉菜单）
enum TriggerEvent { ON_APPLY, ON_ATTACK, ON_HIT, ON_KILL }
@export var trigger_events: Array[TriggerEvent] = [TriggerEvent.ON_APPLY]

## 组合系统
## 需要同时存在的其他Buff（组合条件）
@export var required_buffs: Array[BuffBase] = []

## 满足条件时触发的组合Buff
@export var combo_buff: BuffBase

## 进化系统
## 最大可升级次数（0=不可升级）
@export_range(1, 10) var max_level: int = 1

## 升级后的新Buff（留空则增强当前属性）
@export var next_level_buff: BuffBase

#=== 核心方法 ===========================================#
## 应用效果（需在子类实现具体逻辑）[[1][6]]
func apply_effect(target: Node) -> void:
	push_error("必须实现apply_effect方法!")

## 移除效果（需在子类实现逆向逻辑）
func remove_effect(target: Node) -> void:
	push_error("必须实现remove_effect方法!")

## 生成动态描述（自动替换数值占位符）
func get_description() -> String:
	var value = base_value * 100 if is_percentage else base_value
	return description.format({"value": "%.1f" % value})

#=== 信号系统 ============================================#
## Buff被施加时触发
signal buff_applied(buff: BuffBase)

## Buff被移除时触发
signal buff_removed(buff: BuffBase)

## 每次间隔触发时
signal buff_ticked(buff: BuffBase)

## 层数变化时（参数：旧层数，新层数）
signal stack_changed(old_stacks: int, new_stacks: int)
