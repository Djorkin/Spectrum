shader_type spatial;

void fragment() {
    float t = sin(1.0* TIME) ; // Генерация значения в диапазоне [0, 1]

    vec3 color1 = vec3(1.0, 0.0, 0.0); // Красный цвет
    vec3 color2 = vec3(0.0, 0.0, 1.0); // Синий цвет

    vec3 color = mix(color1, color2, t);

    ALBEDO = color;
}
