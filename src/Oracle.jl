using LinearAlgebra, SparseArrays, Test

swap!(a, b, π) = begin temp = π[a]
       π[a] = π[b]
       π[b] = temp
       π
end

@test swap!(1,3,[1, 2, 3]) == [3, 2, 1]

permutate(n, π...) = foldl((acc, v) -> swap!(v[1], v[2], acc), π, init = collect(1:n))

@test permutate(1, 1 => 1) == [1]
@test permutate(5, 1 => 1) == [1, 2, 3, 4, 5]
@test permutate(5, 1 => 2) == [2, 1, 3, 4, 5]

permmat(π) = sparse(1:length(π), π, 1)

@test permmat(permutate(2)) == [1 0; 0 1]
@test permmat(permutate(2, 1=>2)) == [0 1; 1 0]
@test permmat(permutate(4, 1=>2, 3=>4)) == [0 1 0 0; 1 0 0 0; 0 0 0 1; 0 0 1 0]

oracle(m::Int, n::Int, f) = begin
    perm = Dict{Int,Int}()
    for x in 0:2^m-1
        for y in 0:2^n-1
            xy = (x << n) + y      # |x>|y>
            fxy = f(x, y)          # |f(x,y)>
            xfxy = (x << n) + fxy  # |x>|f(x,y)>
            #println(format(x, m)," ",format(y, n)," ",format(x, m)," ",format(fxy, n)," | $xy => $xfxy")
            perm[xy+1] = xfxy+1
        end
    end
    #permmat(permutate(2^(n+m), map...))
    permmat(map((it) -> perm[it], 1:2^(n+m)))
end

format(x::Int, width::Int) = string(x,base=2,pad=width)

oracleXor(m::Int, n::Int, f) = begin
    oracle(m, n, (x, y) -> y ⊻ f(x))
end