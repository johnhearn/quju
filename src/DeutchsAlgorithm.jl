using SparseArrays, Test

include("./Quju.jl")
include("./Oracle.jl")

measure(k) = (qubits) -> measure!(num(qubits), k, qubits)[1][k]

deutch(Uf) = register(ZERO, ONE) |>
                gate(H, H) |>
                gate(Uf) |>
                gate(H, eye) |>
                measure(1)


Uf1 = blockdiag(eye, eye)
Uf2 = blockdiag(NOT, eye)
Uf3 = blockdiag(eye, NOT)
Uf4 = blockdiag(NOT, NOT)

@test map(deutch, [Uf1, Uf2, Uf3, Uf4]) == [false, true, true, false]

oracleXor(m::Int, n::Int, f) = oracle(m, n, (x, y) -> y ⊻ f(x))

Uf1 = oracleXor(1, 1, (x) -> 0)
Uf2 = oracle(1, 1, (x, y) -> y ⊻ x)
Uf3 = oracle(1, 1, (x, y) -> y ⊻ (x ⊻ 1))
Uf4 = oracle(1, 1, (x, y) -> y ⊻ 1)

@test map(deutch, [Uf1, Uf2, Uf3, Uf4]) == [false, true, true, false]