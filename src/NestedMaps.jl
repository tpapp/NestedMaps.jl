module NestedMaps

export nested_map, nested_map_recursive

using ArgCheck: @argcheck

"""
    nested_map_strict(f, A, kind...)

Implements `nested_map` given the element type and size, specified by the arguments
`kind...`, which is checked. See [`nested_map_kind`](@ref).

Internal function, not part of the API.
"""
function nested_map_strict(f, A, ::Type{<: NTuple{N, Any}}) where {N}
    @argcheck all(x -> x isa NTuple{N, Any}, A) "Incompatible elements."
    ntuple(n -> f(map(x -> x[n], A)), Val{N}())
end

function nested_map_strict(f, A, ::Type{<: NamedTuple{N}}) where {N}
    @argcheck all(x -> x isa NamedTuple{N}, A) "Incompatible elements."
    NamedTuple{N}(map(n -> f(map(x -> x[n], A)), N))
end

function nested_map_strict(f, A, ::Type{Array}, axs)
    @argcheck all(x -> axes(x) == axs, A) "Incompatible elements."
    [f(map(x -> x[i], A)) for i in CartesianIndices(axs)]
end

nested_map_strict(f, A) = f(A)

"""
    nested_map_kind(elt)

Provide a `kind` argument based on an element, usually the first one, for
[`nested_map_strict`](@ref).

`kind ≡ ()` is special, suggesting no transformation.

Internal function, not part of the API.
"""
nested_map_kind(elt::NTuple{N}) where N = (NTuple{N, Any}, )

nested_map_kind(elt::NamedTuple{N}) where N = (NamedTuple{N}, )

nested_map_kind(elt::T) where {T <: AbstractArray} = (Array, axes(elt))

nested_map_kind(elt) = ()

"""
    nested_map(f, A)

Return `B` such that `B[i] == f(map(x -> x[i], A))` for all valid indexes of `i`. The latter
is determined from the first element.
"""
nested_map(f, A) = nested_map_strict(f, A, nested_map_kind(first(A))...)

"""
    nested_map_recursive(f, A)

Same as `nested_map`, but applied recursively.
"""
function nested_map_recursive(f, A)
    kind = nested_map_kind(first(A))
    if kind ≡ ()
        f(A)
    else
        nested_map_strict(x -> nested_map_recursive(f, x), A, kind...)
    end
end

end # module
