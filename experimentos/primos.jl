# Find all 6-digit prime numbers
function find_6_digit_primes()
  primes = []
  for i in 100003:999983
    if isprime(i)
      push!(primes, i)
    end
  end
  return primes
end

# Check if a number is prime
function isprime(n)
  if n < 2
    return false
  end
  for i in 2:floor(sqrt(n))
    if n % i == 0
      return false
    end
  end
  return true
end

# Print all 6-digit prime numbers
function print_6_digit_primes(primes)
  for prime in primes
    println(prime)
  end
end

# Find and print all 6-digit prime numbers
primes = find_6_digit_primes()
print_6_digit_primes(primes)