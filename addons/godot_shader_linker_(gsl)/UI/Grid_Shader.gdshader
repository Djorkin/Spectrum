shader_type canvas_item;

uniform vec4 background_color : source_color = vec4(0.11, 0.11, 0.11, 1.0);
uniform vec4 cross_color : source_color = vec4(0.2, 0.2, 0.2, 1.0);

uniform float grid_size = 32.0;
uniform float dot_thickness = 1.0;
uniform float dot_size = 6.0;
uniform float aa = 1.0;

void fragment() {
    vec2 pos = FRAGCOORD.xy; 

    vec2 cell = mod(pos + 0.5 * grid_size, grid_size) - 0.5 * grid_size;

    float horz = (1.0 - smoothstep(dot_thickness, dot_thickness + aa, abs(cell.y)))
                 * (1.0 - smoothstep(dot_size, dot_size + aa, abs(cell.x)));

    float vert = (1.0 - smoothstep(dot_thickness, dot_thickness + aa, abs(cell.x)))
                 * (1.0 - smoothstep(dot_size, dot_size + aa, abs(cell.y)));

    float cross = max(horz, vert);

    COLOR = mix(background_color, cross_color, cross);
}