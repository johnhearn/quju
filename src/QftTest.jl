using Test

include("./Qft.jl")

# Check the function returns an array of the correct type
@test typeof(qft(2)) == Array{Complex{Float32},2}

# Check the result for n=2 against the example in Wikipedia
@test qft(2) ≈ 0.5 * [1  1   1  1;
                      1  im -1 -im;
                      1 -1   1 -1;
                      1 -im -1  im]

# Check that the matrix is unitary
@test qft(2) * qft´(2) ≈ sparse(I, 4, 4) # Unitary