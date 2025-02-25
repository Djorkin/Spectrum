// Нода: Texture Coordinate (UV)
const vec3 bbox_min = vec3(-1.0, 1.0, -1.0);
const vec3 bbox_max = vec3( 1.0,  -1.0,  1.0);

uniform bool use_reference = false;
varying mat4 object_ref_transform;
varying mat4 object_ref_transform_inv;
uniform vec3 object_origin;

varying vec3 tex_coord;
varying vec3 normal_coord;
varying vec3 object_coord;


vec2 apply_blender_coords(vec2 uv) {
    return vec2(uv.x, 1.0 - uv.y);
}

vec2 get_uv_coord(vec2 uv) {
	uv = apply_blender_coords(uv);
    return uv;
}

vec3 apply_generated(vec3 vertex_pos) {
    vec3 gen = (vertex_pos - bbox_min) / (bbox_max - bbox_min);
    return clamp(gen, vec3(0.0), vec3(1.0));
}
