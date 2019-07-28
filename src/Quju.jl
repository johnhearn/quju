using LinearAlgebra, SparseArrays, Memoize, Profile

const Numtype = Float32

ZERO = sparsevec([1], [Numtype(1)], 2)
ONE = sparsevec([2], [Numtype(1)], 2)

eye = sparse(I, 2, 2)
NOT = sparse([1; 2], [2; 1], [1; 1])
H = Numtype(1 / sqrt(2)) * [1 1; 1 -1]
M₀ = ZERO * ZERO'
M₁ = ONE * ONE'
⊗ = kron

register(n::Int) = register(fill(ZERO, n))
register(x::Vector...) = foldl(⊗, x)
hadamard(n) = foldl(⊗, fill(H, n))
gate(A...) = (qubits) -> foldl(⊗, A) * qubits

@memoize lift(n, k, op) = foldl(kron, map(it -> (it == k) ? op : eye, collect(1:n)))

#@memoize lift(n, k, op) = (n == 0) ? [1] : kron(((n == k) ? op : eye), lift(n - 1, k, op))

"""
Measures the kth bit of an n-bit register, updating the register.
Returns a tuples containing the boolean measured value and the resulting register.
"""
measure!(n::Int, k::Int, qubits) = begin
         U = lift(n, k, M₀)
         result = rand(Float32) > Float32(qubits' * U * qubits)
         M = result ? lift(n, k, M₁) : U
         (result, normalize(M * qubits))
       end

"""
Measures a rang of bits of an n-bit register, updating the register.
"""
measure!(n::Int, range::UnitRange, qubits) = begin
         results = BitArray{1}()
         for k in 1:n
           if(k in range)
             result, qubits = measure!(n, k, qubits)
             push!(results, result)
           end
         end
         results, qubits
       end

"""
Measures all the bits of an n-bit register, updating the register.
"""
measureAll!(n::Int, qubits) = measure!(n, 1:n, qubits)
measureAll!(qubits) = measureAll!(size(qubits), qubits)

"""
Utility functions
"""
num(qubits) = Int(floor(log2(length(qubits))))
