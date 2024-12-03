import gleeunit
import gleeunit/should
import solution.{part1, part2}

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  let input = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"
  part1(input) |> should.equal(2)
}

pub fn part2_test() {
  let input = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"
  part2(input) |> should.equal(4)
}
