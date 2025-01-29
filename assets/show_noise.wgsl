#import bevy_pbr::mesh_view_bindings::{view, globals}
#import bevy_wgsl_utils::simplex_noise
#import bevy_wgsl_utils::pcg_hash


@vertex
fn vertex(@location(0) position: vec3f) -> @builtin(position) vec4f {
    return vec4f(position.xy, 1.0, 1.0);
}

@fragment
fn fragment(@builtin(position) position: vec4f) -> @location(0) vec4<f32> {
    let frag_coord = position.xy;
    let uv = frag_coord / view.viewport.zw;

    let input = vec4f(uv, globals.time, globals.delta_time);
    // let input = vec3u(vec3f(frag_coord, globals.time));
    let hash = pcg_hash::pcg_hash_12_f(uv);

    return vec4f(vec3f(hash), 1.0);
}