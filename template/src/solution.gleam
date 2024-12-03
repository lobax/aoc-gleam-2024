import gleam/string
import gleam/list
import gleam/int
import gleam/io
import simplifile.{read}

pub fn main() {
  let filepath = "input.txt"
  let assert Ok(input) = read(from: filepath)
  part1(input) |> io.debug
  part2(input) |> io.debug
}

fn unsafe_parse_ints(input: String) -> List(Int) {
  let assert Ok(ints) = string.split(input, " ") |> list.try_map(int.parse)
  ints
}

fn agg_lists(agg: List(List(Int)), next:List(Int)) -> List(List(Int)) {
  case next, agg {
    [a, b], [left, right] -> [[a, ..left], [b, ..right]]
    _, _ -> panic
  }
}

pub fn part1(input: String) -> Int {
  string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> list.map(unsafe_parse_ints) 
    |> io.debug
  1
}

pub fn part2(input: String) -> Int {
  string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> list.map(unsafe_parse_ints) 
    |> io.debug
  1
}

