# Simple Quantum CPU Simulator in Julia

Some helper functions to simulate a system of qubits, at the moment up to about 14 of them.

As an example, this is one of the simplest possible programs which simulates a quantum 8-sided dice:

```julia
number = register(3) |>
         gate(H,H,H) |>
         measureAll! |>
         toInt
```

This script creates a 3-bit register, applies a Hadamard gate to each bit and then measures the result as an integer. Quantum mechanics tells us that the probability of each bit being measured as `true` is 50%. The result is a true random number.
