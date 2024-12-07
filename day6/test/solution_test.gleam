import gleeunit
import gleeunit/should
import solution.{part1, part2}

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  let input = 
"....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
  part1(input) |> should.equal(41)
}
