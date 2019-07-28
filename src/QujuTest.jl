using Test

include("./Quju.jl")

@test gate(NOT)(ZERO) == ONE
@test gate(NOT)(ONE) == ZERO
