shader_type canvas_item;
uniform float progress : hint_range(0, 1);
uniform sampler2D noise_texture;
uniform vec4 color : source_color;

void fragment() {

    float noise_value = texture(noise_texture, UV).r;

    if (noise_value < progress) {
        discard;
    }

    COLOR = color;
}