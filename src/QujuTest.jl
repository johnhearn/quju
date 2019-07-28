using Test

include("./Quju.jl")

@test gate(NOT)(ZERO) == ONE
@test gate(NOT)(ONE) == ZERO

@test measureAll!(ZERO)[1] == [false]
@test measureAll!(ONE)[1] == [true]
