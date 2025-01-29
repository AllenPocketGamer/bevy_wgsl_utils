use bevy::{asset::load_internal_asset, prelude::*};

pub struct WgslUtilsPlugin;

pub const PCG_HASH_SHADER_HANDLE: Handle<Shader> =
    Handle::weak_from_u128(912837465102938475610293847561029384);
pub const SIMPLEX_NOISE_SHADER_HANDLE: Handle<Shader> =
    Handle::weak_from_u128(71828182845904523536028747135266);

impl Plugin for WgslUtilsPlugin {
    fn build(&self, app: &mut App) {
        load_internal_asset!(
            app,
            PCG_HASH_SHADER_HANDLE,
            "pcg_hash.wgsl",
            Shader::from_wgsl
        );

        load_internal_asset!(
            app,
            SIMPLEX_NOISE_SHADER_HANDLE,
            "simplex_noise.wgsl",
            Shader::from_wgsl
        );
    }
}
