import { generatePrimes, stopOnCount } from "prime-lib";

const prime_list = stopOnCount(generatePrimes({
  boost: 100000
}), 100000);

await Bun.write("./src/primes.gleam", `
// gleam algorithm for obtaining prime factors of a number
import gleam/int
import gleam/bool
import gleam/result.{try}
import gleam/float

pub fn primes_of(n: Int) -> Result(List(Int), Nil) {
  use <- bool.guard(n == 1, Ok([]))
  use <- bool.guard(n < 0, Error(Nil))
  case int.bitwise_and(n, 1) {
    0 -> do_prime_factors_even(
      int.bitwise_shift_right(n, 1),
      [2],
    )
    _ -> {
      use sqrt <- try(result.map(int.square_root(n), float.truncate))
      do_prime_factors_odd(n, 3, sqrt, [])
    }
  }
}

fn do_prime_factors_even(n: Int, acc: List(Int)) -> Result(List(Int), Nil) {
  case int.bitwise_and(n, 1) {
    0 -> do_prime_factors_even(
      int.bitwise_shift_right(n, 1),
      [2, ..acc],
    )
    _ -> {
      use sqrt <- try(result.map(int.square_root(n), float.truncate))
      do_prime_factors_odd(n, 3, sqrt, acc)
    }
  }
}

fn do_prime_factors_odd(n: Int, start: Int, end: Int, acc: List(Int)) -> Result(List(Int), Nil) {
  case n % start {
    rem if rem == 0 -> {
      use sqrt <- try(result.map(int.square_root(n), float.truncate))
      do_prime_factors_odd(n / start, start + 2, sqrt, [start, ..acc])
    }
    _ -> do_prime_factors_odd(n, start + 2, end, acc)
  }
}


pub const primes = #(\n  ${Array.from(prime_list).map(e => e.toString()).join(",\n  ")},\n)
`.trim())

