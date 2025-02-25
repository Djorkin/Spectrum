shader_type spatial;

#include "res://Shaders/GSL/inc_shader/Tex_Cord.gdshaderinc"
#include "res://Shaders/GSL/inc_shader/Mapping.gdshaderinc"
#include "res://Shaders/GSL/inc_shader/Material_Output.gdshaderinc"
#include "res://Shaders/GSL/inc_shader/blender_coords.gdshaderinc"


vec3 apply_normal(vec3 local_normal) {
    return blender_to_godot_normal(local_normal * vec3(1.0,1.0,-1.0));
}

void vertex() {
    //tex_coord = apply_generated(blender_to_godot(VERTEX));
	//normal_coord = apply_normal(NORMAL);
    vec4 world_pos = MODEL_MATRIX * vec4(VERTEX * vec3(1.0,1.0,-1.0), 1.0);

    world_pos.xyz -= object_origin;

    if (use_reference) {
        object_coord = (object_ref_transform_inv * world_pos).xyz;
    } else {
        object_coord = world_pos.xyz;
    }
	object_coord = blender_to_godot(object_coord);
}

void fragment() {
    vec3 mapping = apply_mapping(vec3(object_coord));
    ALBEDO = apply_surface(vec3(mapping));
}
