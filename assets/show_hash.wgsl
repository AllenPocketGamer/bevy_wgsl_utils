#import bevy_pbr::mesh_view_bindings::{view, globals}
#import bevy_wgsl_utils::pcg_hash::{
    pcg_hash_11_f,
    pcg_hash_12_f, pcg_hash_22_f,
    pcg_hash_13_f, pcg_hash_23_f, pcg_hash_33_f,
    pcg_hash_14_f, pcg_hash_24_f, pcg_hash_34_f, pcg_hash_44_f,
}

@vertex
fn vertex(@location(0) position: vec3f) -> @builtin(position) vec4f {
    return vec4f(position.xy, 1.0, 1.0);
}

@fragment
fn fragment(@builtin(position) position: vec4f) -> @location(0) vec4<f32> {
    let frag_coord = position.xy;
    let uv = frag_coord / view.viewport.zw;

    let in_1 = uv.x;
    let in_2 = uv;
    let in_3 = vec3f(uv, globals.time);
    let in_4 = vec4f(uv, globals.time, globals.delta_time);;

    if uv.y < 0.5 {
        if uv.x < 0.20 {
            let hash = pcg_hash_11_f(in_1);
            return vec4f(vec3f(hash), 1.0);
        } else if uv.x < 0.40 {
            let hash = pcg_hash_12_f(in_2);
            return vec4f(vec3f(hash), 1.0);
        } else if uv.x < 0.60 {
            let hash = pcg_hash_22_f(in_2);
            return vec4f(vec3f(hash, 0.0), 1.0);
        } else if uv.x < 0.80 {
            let hash = pcg_hash_13_f(in_3);
            return vec4f(vec3f(hash), 1.0);
        } else {
            let hash = pcg_hash_23_f(in_3);
            return vec4f(vec3f(hash, 0.0), 1.0);
        }
    } else {
        if uv.x < 0.20 {
            let hash = pcg_hash_33_f(in_3);
            return vec4f(hash, 1.0);
        } else if uv.x < 0.40 {
            let hash = pcg_hash_14_f(in_4);
            return vec4f(vec3f(hash), 1.0);
        } else if uv.x < 0.60 {
            let hash = pcg_hash_24_f(in_4);
            return vec4f(vec3f(hash, 0.0), 1.0);
        }
        else if uv.x < 0.80 {
            let hash = pcg_hash_34_f(in_4);
            return vec4f(hash, 1.0);
        } else {
            let hash = pcg_hash_44_f(in_4);
            return vec4f(hash.xyz * hash.w, 1.0);
        }
    }

    return vec4f(0.0, 0.0, 0.0, 1.0);
}