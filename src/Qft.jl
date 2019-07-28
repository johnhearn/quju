# Returns a matrix representation of the QFT for n bits.
# Inverse is simply qft(n)'
function qft(n)
   N = 2^n
   ω = exp(2f0*π*im / N)
   a = 1f0 / sqrt(Float32(N))
   [a*ω^(i*j) for i in 0:N-1, j in 0:N-1]
end

# Alias for the inverse QFT
qft´(n) = qft(n)'