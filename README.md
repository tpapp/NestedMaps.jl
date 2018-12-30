# NestedMaps

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.com/tpapp/NestedMaps.jl.svg?branch=master)](https://travis-ci.com/tpapp/NestedMaps.jl)
[![codecov.io](http://codecov.io/github/tpapp/NestedMaps.jl/coverage.svg?branch=master)](http://codecov.io/github/tpapp/NestedMaps.jl?branch=master)

Julia package for mapping nested collections elementwise.

Not yet registered, install from repository.

```julia
julia> using NestedMaps

julia> A = [(a = i, b = (c = -i, d = [i^2, -i^2])) for i in 1:3]
3-element Array{NamedTuple{(:a, :b),Tuple{Int64,NamedTuple{(:c, :d),Tuple{Int64,Array{Int64,1}}}}},1}:
 (a = 1, b = (c = -1, d = [1, -1]))
 (a = 2, b = (c = -2, d = [4, -4]))
 (a = 3, b = (c = -3, d = [9, -9]))

julia> nested_map(identity, A)
(a = [1, 2, 3], b = NamedTuple{(:c, :d),Tuple{Int64,Array{Int64,1}}}[(c = -1, d = [1, -1]), (c = -2, d = [4, -4]), (c = -3, d = [9, -9])])

julia> nested_map_recursive(sum, A)
(a = 6, b = (c = -6, d = [14, -14]))
```
