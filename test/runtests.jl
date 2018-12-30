using NestedMaps, Test

@testset "fallback" begin
    x = 1:10
    @test nested_map(identity, x) == x
    @test nested_map(sum, x) == sum(x)
end

@testset "tuple" begin
    t = [(i, -i) for i in 1:10]
    @test nested_map(identity, t) == (1:10, -(1:10))
    @test nested_map(sum, t) == (55, -55)
    @test_throws ArgumentError nested_map(identity, [(1, ), (2, 3)])
end

@testset "named tuple" begin
    nt = [(a = i, b = -i) for i in 1:10]
    @test nested_map(identity, nt) == (a = 1:10, b = -(1:10))
    @test nested_map(sum, nt) == (a = 55, b = -55)
    @test_throws ArgumentError nested_map(identity, [(a = 1, ), (b = 2, )])
end

@testset "array" begin
    r1 = 1:5
    r2 = 2:7
    A = [[i, j] for i in r1, j in r2]
    @test nested_map(identity, A) == [[i for i in r1, _ in r2],
                                      [j for _ in r1, j in r2]]
    @test nested_map(sum, A) == [sum(r1) * length(r2), sum(r2) * length(r1)]
    @test_throws ArgumentError nested_map(identity, [[1], [1, 2]])
end

@testset "recursive" begin
    r = 1:5
    A = [(a = i, b = (c = -i, d = [i^2, -i^2])) for i in r]
    @test nested_map_recursive(identity, A) == (a = r, b = (c = .-r, d = [r.^2, -r.^2]))
    s1, s2 = sum(r), sum(abs2, r)
    @test nested_map_recursive(sum, A) == (a = s1, b = (c = -s1, d = [s2, -s2]))
end
