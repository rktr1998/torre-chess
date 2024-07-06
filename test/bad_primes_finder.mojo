# Function to check if a number is prime in Mojo language
fn mojo_is_prime(num: UInt32) -> Bool:
    if num < 2:
        return False
    if num == 2:
        return True
    if num % 2 == 0:
        return False
    var i: UInt32 = 3
    while i * i <= num:
        if num % i == 0:
            return False
        i += 2
    return True

# Function to find Nth prime number in Mojo language
fn mojo_nth_prime(n: UInt32) -> UInt32:
    if n == 1:
        return 2
    var count: UInt32 = 1
    var num: UInt32 = 1
    while count < n:
        num += 2
        if mojo_is_prime(num):
            count += 1
    return num


# Measure and print time taken to find 100_000th prime number
from time import now

fn main():
    var start = now()
    print(mojo_nth_prime(100_000))
    print("Time taken:", (now() - start) / 10 ** 6, "ms")
