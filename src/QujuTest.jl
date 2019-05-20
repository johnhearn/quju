using LinearAlgebra

ZERO = Float32(1) * [1, 0]
ONE = Float32(1) * [0, 1]

eye = Matrix{Float32}(I, 2, 2)
H = Float32(1/sqrt(2)) * [1 1; 1 -1]
M₀ = ZERO * ZERO'
M₁ = ONE * ONE'

register = (n) -> foldl(kron, fill(ZERO, n))
hadamard = (n) -> foldl(kron, fill(H, n))

lift = (n, k, op) -> foldl(kron, map(it -> (it == k) ? op : eye, collect(1:n)))

measure = (n, k, qubits) -> begin
         result = rand() > qubits' * lift(n, k, M₀) * qubits
         (result, normalize(lift(n, k, (result ? M₁ : M₀)) * qubits))
       end

measureAll = (n, qubits) -> begin
         results = [];
         for k in 1:n
           result, qubits = measure(n, k, qubits)
           push!(results, result)
         end
         results, qubits
       end

toInt = (b) -> reduce((acc, v) -> 2*acc + (v ? 1 : 0), b, init=0)

qubits = hadamard(3) * register(3)
print(toInt(measureAll(3, qubits)[1]))
