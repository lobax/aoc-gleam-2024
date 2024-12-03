import gleeunit
import gleeunit/should
import solution.{part1, part2}

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  let input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  part1(input) |> should.equal(161)
}

pub fn part2_test() {
  let input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  part2(input) |> should.equal(48)
}
