shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float gamma = 1; // Параметр гаммы для коррекции
uniform float vignette_radius = 0.6; // Радиус виньетки
uniform float vignette_softness = 0.3; // Мягкость края виньетки
uniform int color_mode = 0; // 0 - UFS (ультрафиолет), 1 - YBS (желто-черный)

// Простая функция шума
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// Функция фрактального шума
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 0.0;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Функция для преобразования в ультрафиолетовый спектр
vec3 rgb_to_ultraviolet(vec3 color) {
    float intensity = dot(color, vec3(0.299, 0.587, 0.114)); // Преобразование в градации серого
    float uv_intensity = pow(intensity, 0.8); // Усиление эффекта ультрафиолета
    return vec3(uv_intensity * 0.6, 0.0, uv_intensity); // Ультрафиолетовый спектр
}

// Функция для преобразования в желто-черный спектр
vec3 rgb_to_yellow_black(vec3 color) {
    float intensity = dot(color, vec3(0.299, 0.587, 0.114)); // Преобразование в градации серого
    float yb_intensity = pow(intensity, 0.9); // Усиление эффекта
    return vec3(yb_intensity, yb_intensity * 0.8, 0.0); // Желто-черный спектр
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 color = texture(screen_texture, uv);

    // Применение гамма-коррекции
    vec3 corrected_color = pow(color.rgb, vec3(1.0 / gamma));

    // Вычисление дистанции от центра
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(uv, center);

    // Анимация дыма с использованием фрактального шума
    float noise_value = fbm(uv * 2.0 + vec2(TIME * 0.05, TIME * 0.05));

    // Эффект виньетки с дымом
    float vignette = smoothstep(vignette_radius, vignette_radius - vignette_softness, dist + noise_value * 0.3);
    corrected_color *= (1.0 + vignette); // Затемнение цвета в зависимости от виньетки

    // Применение нужного спектра
    vec3 final_color;
    if (color_mode == 0) {
        final_color = rgb_to_ultraviolet(corrected_color);
    } else if (color_mode == 1) {
        final_color = rgb_to_yellow_black(corrected_color);
    } else {
        final_color = corrected_color; // Если режим не задан, оставить оригинальный цвет
    }

    COLOR = vec4(final_color, 1.0); // Устанавливаем цвет с выбранным спектром
}
