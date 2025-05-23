shader_type canvas_item;

// 控制渐变的颜色
uniform vec4 effect_color : source_color = vec4(1.0);
// 控制渐变进度 (0-1)
uniform float progress : hint_range(0, 1) = 0.0;
// 圆心起始位置 (绝对像素坐标)
uniform vec2 center_absolute = vec2(360.0, 640.0);
// 新增：放大倍数控制（默认1.2，建议1.0-2.0）
uniform float scale_factor : hint_range(1.0, 3.0) = 1.2;

void fragment() {
    // 获取当前屏幕UV坐标
    vec2 screen_uv = SCREEN_UV;
    vec2 screen_pixel_size = SCREEN_PIXEL_SIZE;

    // 坐标转换与宽高比修正
    float aspect_ratio = screen_pixel_size.x / screen_pixel_size.y;
    vec2 center = center_absolute * screen_pixel_size;
    vec2 adjusted_uv = vec2(screen_uv.x, screen_uv.y * aspect_ratio);
    vec2 adjusted_center = vec2(center.x, center.y * aspect_ratio);

    // 计算最大覆盖半径（新增scale_factor控制）
    float d1 = distance(adjusted_center, vec2(0.0, 0.0 * aspect_ratio));
    float d2 = distance(adjusted_center, vec2(1.0, 0.0 * aspect_ratio));
    float d3 = distance(adjusted_center, vec2(0.0, 1.0 * aspect_ratio));
    float d4 = distance(adjusted_center, vec2(1.0, 1.0 * aspect_ratio));
    float max_radius = max(max(max(d1, d2), d3), d4) * scale_factor; // 关键修改

    // 当前半径计算
    float current_radius = progress * max_radius;
    float dist = distance(adjusted_uv, adjusted_center);

    // 平滑过渡处理
    float alpha = 1.0 - smoothstep(
        current_radius - 0.005,
        current_radius + 0.005,
        dist
    );

    COLOR = vec4(effect_color.rgb, alpha * effect_color.a);
}