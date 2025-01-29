#define_import_path bevy_wgsl_utils::pcg_hash

const MAX: f32 = f32(0xFFFFFFFFu);

// u32: 1 out, 1 in
fn pcg_hash_11_u(v: u32) -> u32 {
	let state = v * 747796405u + 2891336453u;
	let word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
	return (word >> 22u) ^ word;
}

// u32: 1 out, 2 in
fn pcg_hash_12_u(v: vec2u) -> u32 {
    let v1 = pcg_hash_22_u(v);

    return v1.x ^ v1.y;
}

// u32: 2 out, 2 in
fn pcg_hash_22_u(v: vec2u) -> vec2u {
    var v1 = v * 1664525u + 1013904223u;

    v1.x += v1.y * 1664525u;
    v1.y += v1.x * 1664525u;

    v1 = v1 ^ (v1 >> vec2u(16u));

    v1.x += v1.y * 1664525u;
    v1.y += v1.x * 1664525u;

    v1 = v1 ^ (v1 >> vec2u(16u));

    return v1;
}

// u32: 1 out, 3 in
fn pcg_hash_13_u(v: vec3u) -> f32 {
    let v1 = pcg_hash_33_u(v);

    return v1.x ^ v1.y ^ v1.z;
}

// u32: 2 out, 3 in
fn pcg_hash_23_u(v: vec3u) -> vec2u {
    let v1 = pcg_hash_33_u(v);

    return v1.xy ^ v1.zx;
}

// u32: 3 out, 3 in
fn pcg_hash_33_u(v: vec3u) -> vec3u {
    var v1 = v * 1664525u + 1013904223u;

    v1.x += v1.y * v1.z;
    v1.y += v1.z * v1.x;
    v1.z += v1.x * v1.y;

    v1 ^= v1 >> vec3u(16u);

    v1.x += v1.y * v1.z;
    v1.y += v1.z * v1.x;
    v1.z += v1.x * v1.y;

    return v1;
}

// u32: 1 out, 4 in
fn pcg_hash_14_u(v: vec4u) -> u32 {
    let v1 = pcg_hash_44_u(v);

    return v1.x ^ v1.y ^ v1.z ^ v1.w;
}

// u32: 2 out, 4 in
fn pcg_hash_24_u(v: vec4u) -> vec2u {
    let v1 = pcg_hash_44_u(v);

    return v1.xy ^ v1.zw;
}

// u32: 3 out, 4 in
fn pcg_hash_34_u(v: vec4u) -> vec3u {
    let v1 = pcg_hash_44_u(v);

    return v1.xyz ^ v1.wxy;
}

// u32: 4 out, 4 in
fn pcg_hash_44_u(v: vec4u) -> vec4u
{
    var v1 = v * 1664525u + 1013904223u;
    
    v1.x += v1.y * v1.w;
    v1.y += v1.z * v1.x;
    v1.z += v1.x * v1.y;
    v1.w += v1.y * v1.z;
    
    v1 ^= v1 >> vec4u(16u);
    
    v1.x += v1.y * v1.w;
    v1.y += v1.z * v1.x;
    v1.z += v1.x * v1.y;
    v1.w += v1.y * v1.z;
    
    return v1;
}

// f32: 1 out, 1 in
fn pcg_hash_11_f(v: f32) -> f32 {
    let v1 = bitcast<u32>(v);

    return f32(pcg_hash_11_u(v1)) / MAX;
}

// f32: 1 out, 2 in
fn pcg_hash_12_f(v: vec2f) -> f32 {
    let v1 = bitcast<vec2u>(v);

    return f32(pcg_hash_12_u(v1)) / MAX;
}

// f32: 2 out, 1 in
fn pcg_hash_22_f(v: vec2f) -> vec2f {
    let v1 = bitcast<vec2u>(v);

    return vec2f(pcg_hash_22_u(v1)) / MAX;
}

// f32: 1 out, 3 in
fn pcg_hash_13_f(v: vec3f) -> f32 {
    let v1 = bitcast<vec3u>(v);

    return f32(pcg_hash_13_u(v1)) / MAX;
}

// f32: 2 out, 3 in
fn pcg_hash_23_f(v: vec3f) -> vec2f {
    let v1 = bitcast<vec3u>(v);

    return vec2f(pcg_hash_23_u(v1)) / MAX;
}

// f32: 3 out, 3 in
fn pcg_hash_33_f(v: vec3f) -> vec3f {
    let v1 = bitcast<vec3u>(v);

    return vec3f(pcg_hash_33_u(v1)) / MAX;
}

// f32: 1 out, 4 in
fn pcg_hash_14_f(v: vec4f) -> f32 {
    let v1 = bitcast<vec4u>(v);

    return f32(pcg_hash_14_u(v1)) / MAX;
}

// f32: 2 out, 4 in
fn pcg_hash_24_f(v: vec4f) -> vec2f {
    let v1 = bitcast<vec4u>(v);

    return vec2f(pcg_hash_24_u(v1)) / MAX;
}

// f32: 3 out, 4 in
fn pcg_hash_34_f(v: vec4f) -> vec3f {
    let v1 = bitcast<vec4u>(v);

    return vec3f(pcg_hash_34_u(v1)) / MAX;
}

// f32: 4 out, 4 in
fn pcg_hash_44_f(v: vec4f) -> vec4f {
    let v1 = bitcast<vec4u>(v);

    return vec4f(pcg_hash_44_u(v1)) / MAX;
}