#define_import_path bevy_wgsl_utils::simplex_noise

fn hash_22(p: vec2<f32>) -> vec2<f32> {
    let p1 = vec2<f32>(
        dot(p, vec2<f32>(127.1, 311.7)),
        dot(p, vec2<f32>(269.5, 183.3))
    );
    return -1.0 + 2.0 * fract(sin(p1) * 43758.5453123);
}

fn simplex_noise_21(p: vec2<f32>) -> f32 {
    const K1: f32 = 0.366025404; // (sqrt(3)-1)/2;
    const K2: f32 = 0.211324865; // (3-sqrt(3))/6;

    let i = floor(p + (p.x + p.y) * K1);
    let a = p - i + (i.x + i.y) * K2;
    let m = step(a.y, a.x);
    let o = vec2<f32>(m, 1.0 - m);
    let b = a - o + K2;
    let c = a - 1.0 + 2.0 * K2;
    let h = max(0.5 - vec3<f32>(dot(a, a), dot(b, b), dot(c, c)), vec3<f32>(0.0));
    let n = h * h * h * h * vec3<f32>(
        dot(a, hash_22(i + vec2<f32>(0.0, 0.0))),
        dot(b, hash_22(i + o)),
        dot(c, hash_22(i + vec2<f32>(1.0, 1.0)))
    );
    return dot(n, vec3<f32>(70.0));
}