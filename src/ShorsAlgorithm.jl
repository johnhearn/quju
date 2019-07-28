using Test, SparseArrays

include("./Quju.jl")
include("./Oracle.jl")
include("./Qft.jl")

function period(N, a)
    global r = 1
    while a^r % N != 1 && r < N
        r = r + 1
    end
    r
end

# Number to factor, a multiple of 2 prime factors > 2
N = 15 #1517

# Step 1: choose a random number 1 < a < N
a = BigInt(13) #BigInt(rand(2:N)) #13 works for 15 and 21

# Step 2: find r, the period of a^x mod N
r = period(N, a)

@show N, a, r

# Step 3: check that r is even and a^(r/2)+1 != 0 mod N
if r % 2 == 0 && a^(r>>1) % N != 0

    # Step 4: p = gcd(a^(r/2)-1, N)
    p = gcd(a^(r>>1)-1, N)
    q = gcd(a^(r>>1)+1, N)

    @show p, q
end
