import gleeunit
import gleeunit/should
import gleam/io
import solution

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  let input = 
"MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"
  solution.part1(input) |> should.equal(18)
}

pub fn right_test() {
  let input = "..XMAS"
  solution.part1(input) |> should.equal(1)
  let input = "..SAMX"
  solution.part1(input) |> should.equal(1)
}

pub fn down_test() {
  let input = "X.....
M.....
A.....
S....."
  solution.part1(input) |> should.equal(1)
}

pub fn diag_right_test() {
  let input = "X.....
.M....
..A...
...S.."
  solution.part1(input) |> should.equal(1)
}

pub fn diag_left_test() {
  let input = 
"...S..
..A...
.M....
X....."
  solution.part1(input) |> should.equal(1)
}
