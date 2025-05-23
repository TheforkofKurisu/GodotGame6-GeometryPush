shader_type canvas_item;

// 导出参数方便实时调整
uniform vec4 center_color : source_color = vec4(1.0); // 中心颜色
uniform float fade_range : hint_range(0.1, 2.0) = 0.5; // 渐变范围
uniform float fade_power : hint_range(1.0, 5.0) = 2.0; // 渐变强度

void fragment() {
    // 获取 UV 坐标（转换为以中心为原点）
    vec2 uv = UV * 2.0 - 1.0; // 范围变为 [-1, 1]
    float distance = length(uv); // 到中心的距离

    // 计算渐变系数（0=中心，1=边缘）
    float fade = smoothstep(0.0, fade_range, distance);
    fade = pow(fade, fade_power); // 控制渐变曲线

    // 混合颜色（目标颜色改为纯黑且不透明）
    COLOR = mix(center_color, vec4(0.0, 0.0, 0.0, 1.0), fade);
}