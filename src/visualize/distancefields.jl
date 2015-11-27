visualize_default(distancefield::Union{Texture{Float32, 2}, Array{Float32, 2}}, s::Style{:distancefield}, kw_args...) = @compat(Dict(
    :color          => default(RGBA, s),
    :primitive      => GLUVMesh2D(SimpleRectangle{Float32}(0f0,0f0,size(distancefield)...)),
    :preferred_camera  => :orthographic_pixel
))

@visualize_gen Array{Float32, 2} Texture Style

function visualize(distancefield::Texture{Float32, 2}, s::Style{:distancefield}, customizations=visualize_default(positions, s))
    @materialize! primitive = customizations
    data = merge(Dict(
        :distancefield => distancefield,
    ), collect_for_gl(primitive), customizations)

    program = assemble_std(
        distancefield, data,
        "uv_vert.vert", "distancefield.frag",
        boundingbox=Signal(AABB{Float32}(Vec3f0(0), Vec3f0(size(distancefield)...,0)))
    )
end


