include("./Quju.jl")

update = (z1, z2) -> ( push!(z1[1], z2[1]) , z2[2] )

measureAllf = (n, qubits) -> reduce((acc, k) -> update(acc, measure!(n, k, acc[2])), 1:n, init = ([], qubits))

toInt = (b) -> reduce((acc, v) -> 2*acc + (v ? 1 : 0), b, init=0)

for meas in [measureAll, measureAllf]
    for n in 1:14
        @time print(toInt(meas(n, hadamard(n) * register(n))[1]))
    end
end


M = lift(10, 5, H)

special(n) = 2 * register(n) * register(n)' - sparse(I, 2^n, 2^n)

A = lift(10,5,H)
x = rand(1048576)
mul!(A, x, 1.0)

