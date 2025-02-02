#define_import_path bevy_wgsl_utils::simplex_noise

#import bevy_wgsl_utils::pcg_hash::{
    pcg_hash_22_f,
    pcg_hash_33_f,
    pcg_hash_11_u,
}

// From: https://github.com/WardBenjamin/SimplexNoise/blob/master/SimplexNoise/Noise.cs#L379
fn grad_1d(hash: u32, x: f32) -> f32 {
    var h = hash & 15u;
    var grad = 1.0 + f32(h & 7u);
    if (h & 8u) != 0u { grad = -grad; }
    return grad * x;
}

// From: https://github.com/WardBenjamin/SimplexNoise/blob/master/SimplexNoise/Noise.cs#L139
fn simplex_noise_1d(x: f32) -> f32 {
    let i0 = floor(x);
    let i1 = i0 + 1.0;

    let x0 = x - i0;
    let x1 = x0 - 1.0;

    var t0 = 1.0 - x0 * x0;
    t0 *= t0;
    let n0 = t0 * t0 * grad_1d(pcg_hash_11_u(bitcast<u32>(i0)), x0);

    var t1 = 1.0 - x1 * x1;
    t1 *= t1;
    let n1 = t1 * t1 * grad_1d(pcg_hash_11_u(bitcast<u32>(i1)), x1);

    return 0.395 * (n0 + n1);
}

// From: https://www.shadertoy.com/view/Msf3WH
fn simplex_noise_2d(p: vec2f) -> f32 {
    const K1: f32 = 0.366025404; // (sqrt(3)-1)/2;
    const K2: f32 = 0.211324865; // (3-sqrt(3))/6;

    let i = floor(p + (p.x + p.y) * K1);
    let a = p - i + (i.x + i.y) * K2;
    let m = step(a.y, a.x);
    let o = vec2f(m, 1.0 - m);
    let b = a - o + K2;
    let c = a - 1.0 + 2.0 * K2;
    let h = max(0.5 - vec3f(dot(a, a), dot(b, b), dot(c, c)), vec3f(0.0));
    let n = h * h * h * h * vec3f(
        dot(a, 2.0 * pcg_hash_22_f(i + vec2f(0.0, 0.0)) - 1.0),
        dot(b, 2.0 * pcg_hash_22_f(i + o) - 1.0),
        dot(c, 2.0 * pcg_hash_22_f(i + vec2f(1.0, 1.0)) - 1.0)
    );
    return dot(n, vec3f(70.0));
}

// From: https://www.shadertoy.com/view/XsX3zB
fn simplex_noise_3d(p: vec3f) -> f32 {
        /* skew constants for 3d simplex functions */
    const F3: f32 = 0.3333333;
    const G3: f32 = 0.1666667;

    /* 1. find current tetrahedron T and it's four vertices */
    /* s, s+i1, s+i2, s+1.0 - absolute skewed (integer) coordinates of T vertices */
    /* x, x1, x2, x3 - unskewed coordinates of p relative to each of T vertices*/

    /* calculate s and x */
    let s = floor(p + dot(p, vec3f(F3)));
    let x = p - s + dot(s, vec3f(G3));

    /* calculate i1 and i2 */
    let e = step(vec3f(0.0), x - x.yzx);
    let i1 = e * (1.0 - e.zxy);
    let i2 = 1.0 - e.zxy * (1.0 - e);

    /* x1, x2, x3 */
    let x1 = x - i1 + G3;
    let x2 = x - i2 + 2.0 * G3;
    let x3 = x - 1.0 + 3.0 * G3;

    /* 2. find four surflets and store them in d */
    var w = vec4f(0.0);
    var d = vec4f(0.0);

    /* calculate surflet weights */
    w.x = dot(x, x);
    w.y = dot(x1, x1);
    w.z = dot(x2, x2);
    w.w = dot(x3, x3);

    /* w fades from 0.6 at the center of the surflet to 0.0 at the margin */
    w = max(0.6 - w, vec4f(0.0));

    /* calculate surflet components */
    d.x = dot(pcg_hash_33_f(s + 1.0) - 0.5, x);
    d.y = dot(pcg_hash_33_f(s + 1.0 + i1) - 0.5, x1);
    d.z = dot(pcg_hash_33_f(s + 1.0 + i2) - 0.5, x2);
    d.w = dot(pcg_hash_33_f(s + 2.0) - 0.5, x3);

    /* multiply d by w^4 */
    w *= w;
    w *= w;
    d *= w;

    /* 3. return the sum of the four surflets */
    return dot(d, vec4(52.0));
}