using SparseArrays, Test

include("./Quju.jl")
include("./Oracle.jl")

measure(k) = (qubits) -> measure!(num(qubits), k, qubits)[1][k]

deutchJosza(Uf) = register(ZERO, ZERO, ONE) |>
                gate(H, H, H) |>
                gate(Uf) |>
                gate(H, H, eye) |>
                measure(1:2) |>
                (y) -> reinterpret(Int, y.chunks)[1] != 0


Uf1 = oracle(2, 1, (x, y) -> y ⊻ 0)
Uf2 = oracle(2, 1, (x, y) -> y ⊻ (x & 1))
Uf3 = oracle(2, 1, (x, y) -> y ⊻ (x & 1 ⊻ 1))
Uf4 = oracle(2, 1, (x, y) -> y ⊻ 1)

@test map(deutchJosza, [Uf1, Uf2, Uf3, Uf4]) == [false, true, true, false]
