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

type LevelDelta {
  Increasing
  Decreasing
}

type Safety {
  Safe
  Unsafe
}

fn report_safety_r(report: List(Int), delta: LevelDelta) -> Safety {
  case report, delta { 
    [_], _  -> Safe 
    [], _   -> Safe 
    [a, b, .._], _              if b == a -> Unsafe
    [a, b, ..tail], Increasing  if a < b && b-a <= 3 -> 
      report_safety_r([b, ..tail], delta)
    [a, b, ..tail], Decreasing, if a > b && a-b <= 3 -> 
      report_safety_r([b, ..tail], delta)
    _, _    -> Unsafe
  }
}

fn report_safety(report: List(Int)) -> Safety {
  case report {
    [a, b, .._] if a < b -> report_safety_r(report, Increasing)
    [a, b, .._] if a > b -> report_safety_r(report, Decreasing) 
    _ -> Unsafe
  }
}

pub fn part1(input: String) -> Int {
  string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> list.map(unsafe_parse_ints) 
    |> list.map(report_safety)
    |> list.count(fn(r) {r == Safe}) 
}

fn dampener(report: List(Int), idx: Int, acc: List(List(Int))) -> List(List(Int)) {
  let length = list.length(report)
  case idx {
    i  if i > length -> acc
    i  -> dampener(report, i+1, [list.append(list.take(report, i-1), list.drop(report, i)), ..acc])
  }
}

fn report_safety_dampener(report: List(Int)) -> Safety {
  case report_safety(report) {
    Safe    -> Safe
    Unsafe  -> dampener(report, 1, [])
      |> list.map(report_safety)
      |> list.fold(Unsafe, fn(b, a) { 
        case b,a {
          Safe, _         -> Safe
          _, Safe         -> Safe
          Unsafe, Unsafe  -> Unsafe
        }
      })
  } 
}

pub fn part2(input: String) -> Int {
  string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> list.map(unsafe_parse_ints)
    |> list.map(report_safety_dampener)
    |> list.count(fn(r) {r == Safe}) 
}

