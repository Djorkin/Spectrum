// Режимы Mapping:
// 0 - Point
// 1 - Texture
// 2 - Vector
// 3 - Normal
uniform int mapping_type = 0;
uniform vec3 location = vec3(0.0);
uniform vec3 rotation_degrees = vec3(0.0);
uniform vec3 scale = vec3(1.0);


vec3 rodri_rotate(vec3 v, vec3 axis, float angle) {
    axis = normalize(axis);
    float c = cos(angle);
    float s = sin(angle);
    return v * c + cross(axis, v) * s + axis * dot(axis, v) * (1.0 - c);
}


vec3 apply_mapping(vec3 uv) {
    vec3 coord = uv;
    vec3 angles = radians(rotation_degrees);

    if(mapping_type == 0) {
        coord *= scale;
        coord = rodri_rotate(coord, vec3(1.0, 0.0, 0.0), angles.x);
        coord = rodri_rotate(coord, vec3(0.0, 1.0, 0.0), angles.y);
        coord = rodri_rotate(coord, vec3(0.0, 0.0, 1.0), angles.z);
        coord += location;
    }
    else if(mapping_type == 1) {
        coord = uv - location;
        coord = rodri_rotate(coord, vec3(0.0, 0.0, 1.0), -radians(rotation_degrees.z));
        coord = rodri_rotate(coord, vec3(0.0, 1.0, 0.0), -radians(rotation_degrees.y));
        coord = rodri_rotate(coord, vec3(1.0, 0.0, 0.0), -radians(rotation_degrees.x));
        coord /= scale;
    }
	else if(mapping_type == 2) {
        coord *= scale;
        coord = rodri_rotate(coord, vec3(1.0, 0.0, 0.0), angles.x);
        coord = rodri_rotate(coord, vec3(0.0, 1.0, 0.0), angles.y);
        coord = rodri_rotate(coord, vec3(0.0, 0.0, 1.0), angles.z);
    }
    else if(mapping_type == 3) {
        mat3 rx = mat3(
            vec3(1.0, 0.0, 0.0),
            vec3(0.0, cos(angles.x), -sin(angles.x)),
            vec3(0.0, sin(angles.x), cos(angles.x))
        );
        mat3 ry = mat3(
            vec3(cos(angles.y), 0.0, sin(angles.y)),
            vec3(0.0, 1.0, 0.0),
            vec3(-sin(angles.y), 0.0, cos(angles.y))
        );
        mat3 rz = mat3(
            vec3(cos(angles.z), -sin(angles.z), 0.0),
            vec3(sin(angles.z), cos(angles.z), 0.0),
            vec3(0.0, 0.0, 1.0)
        );

        mat3 R = rx * ry * rz;
        
        mat3 S_inv = mat3(
            vec3(1.0 / scale.x, 0.0, 0.0),
            vec3(0.0, 1.0 / scale.y, 0.0),
            vec3(0.0, 0.0, 1.0 / scale.z)
        );

        coord = normalize(inverse(R) * S_inv * uv);
    }
    return coord;
}
