import gleam/int
import gleam/list
import gleeunit
import gleeunit/should
import primes

pub fn main() {
  gleeunit.main()
}

fn should_match_factors(actual: List(Int), factors: List(Int)) {
  actual
  |> list.sort(int.compare)
  |> should.equal(factors)
}

pub fn prime_factors_test() {
  primes.primes_of(123_456)
  |> should.be_ok
  |> should_match_factors([2, 2, 2, 2, 2, 2, 3, 643])

  primes.primes_of(9_934_728)
  |> should.be_ok
  |> should_match_factors([2, 2, 2, 3, 181, 2287])

  primes.primes_of(75_468_413_216)
  |> should.be_ok
  |> should_match_factors([2, 2, 2, 2, 2, 7, 151, 2_231_209])

  primes.primes_of(0)
  |> should.be_error

  primes.primes_of(-1)
  |> should.be_error

  primes.primes_of(1)
  |> should.be_error
}
