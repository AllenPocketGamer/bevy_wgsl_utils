#import bevy_pbr::mesh_view_bindings::{view, globals}
#import bevy_wgsl_utils::simplex_noise::{
    simplex_noise_1d,
    simplex_noise_2d,
    simplex_noise_3d,
}
#import bevy_wgsl_utils::pcg_hash::{
    pcg_hash_22_f,
}

@vertex
fn vertex(@location(0) position: vec3f) -> @builtin(position) vec4f {
    return vec4f(position.xy, 1.0, 1.0);
}

@fragment
fn fragment(@builtin(position) position: vec4f) -> @location(0) vec4<f32> {
    let frag_coord = position.xy;

    let uv = frag_coord / view.viewport.zw;
    let uv0 = frag_coord / max(view.viewport.z, view.viewport.w);

    let in_1 = 16.0 * uv0.x;
    let in_2 = 16.0 * uv0;
    let in_3 = vec3f(32.0 * uv0, globals.time);
    let in_4 = vec4f(32.0 * uv0, globals.time, globals.delta_time);

    var noise = vec3f(0.0);

    if uv.x < 0.33 {
        noise = vec3f(simplex_noise_1d(in_1));
    } else if uv.x < 0.66 {
        noise = vec3f(simplex_noise_2d(in_2));
    } else {
        noise = vec3f(simplex_noise_3d(in_3));
    }

    noise = noise * 0.5 + 0.5;
    noise = pow(noise, vec3f(2.2));

    return vec4f(vec3f(noise), 1.0);
}