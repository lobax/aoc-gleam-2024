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
  let assert Ok(ints) = string.split(input, "   ") |> list.try_map(int.parse)
  ints
}

fn agg_lists(agg: List(List(Int)), next:List(Int)) -> List(List(Int)) {
  case next, agg {
    [a, b], [left, right] -> [[a, ..left], [b, ..right]]
    _, _ -> panic
  }
}

fn abs(a: Int, b: Int) -> Int {
  case a-b {
      d if d<0 -> -d
      d -> d
  }
}

pub fn part1(input: String) -> Int {
  let assert [a, b] = string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> list.map(unsafe_parse_ints) 
    |> list.fold([[],[]], agg_lists)
    |> list.map(fn (l) { list.sort(l, by: int.compare)})
  list.map2(a, b, abs) 
    |> list.fold(0, fn(b,a) {a+b})
}

fn simularity_score(left: List(Int), right: List(Int)) -> Int {
  case left {
    [h, ..tail] -> h* list.count(right, fn(a){a==h}) + simularity_score(tail, right)
    _ -> 0
  }
}

pub fn part2(input: String) -> Int {
  let assert [a, b] = string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> list.map(unsafe_parse_ints) 
    |> list.fold([[],[]], agg_lists)
  simularity_score(a, b)
}

