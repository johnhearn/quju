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
register(x...) = register(collect(x))
register(xs) = foldl(⊗, xs)

gate(A...) = gate(collect(A))
gate(As) = (qubits) -> foldl(⊗, As) * qubits

@memoize lift(n, k, op) = foldl(⊗, map(it -> (it == k) ? op : eye, collect(1:n)))

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
measureAll!(qubits) = measureAll!(num(qubits), qubits)

"""
Calculates the number of bits represented by the qubits vector.
"""
num(qubits)::Int = Int(floor(log2(length(qubits))))

"""
Converts a bit arrays to integers, most significant bit first.
"""
toInt(results::Tuple{BitArray{1},Array{Numtype,1}}) = toInt(results[1])
toInt(bits::BitArray{1}) = reinterpret(Int, bits.chunks)[1]