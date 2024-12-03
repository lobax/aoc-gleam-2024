import gleeunit
import gleeunit/should
import solution.{part1, part2}

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  let input = "3 4"
  part1(input) |> should.equal(1)
}

pub fn part2_test() {
  let input = "3 4"
  part2(input) |> should.equal(1)
}
