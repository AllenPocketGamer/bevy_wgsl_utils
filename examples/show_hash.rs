use bevy::{
    pbr::NotShadowCaster,
    prelude::*,
    render::{
        render_resource::{AsBindGroup, ShaderRef},
        view::NoFrustumCulling,
    },
};
use bevy_wgsl_utils::WgslUtilsPlugin;

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_plugins(MaterialPlugin::<ShowPcgHashMaterial>::default())
        .add_plugins(WgslUtilsPlugin)
        .add_systems(Startup, setup)
        .run();
}

pub fn setup(
    mut commands: Commands,
    mut meshes: ResMut<Assets<Mesh>>,
    mut fmats: ResMut<Assets<ShowPcgHashMaterial>>,
) {
    let mesh_handle = meshes.add(Rectangle::new(2.0, 2.0));
    let fmat_handle = fmats.add(ShowPcgHashMaterial {});

    commands.spawn((
        Mesh3d(mesh_handle),
        MeshMaterial3d(fmat_handle),
        NotShadowCaster,
        NoFrustumCulling,
    ));

    // camera
    commands.spawn((
        Camera3d::default(),
        Transform::IDENTITY,
        // Disabling MSAA for maximum compatibility. Shader prepass with MSAA needs GPU capability MULTISAMPLED_SHADING
        Msaa::Off,
    ));
}

#[derive(Asset, TypePath, AsBindGroup, Debug, Clone)]
pub struct ShowPcgHashMaterial {}

impl Material for ShowPcgHashMaterial {
    fn vertex_shader() -> ShaderRef {
        "show_hash.wgsl".into()
    }

    fn fragment_shader() -> ShaderRef {
        "show_hash.wgsl".into()
    }
}
