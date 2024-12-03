import gleam/string
import gleam/list
import gleam/int
import gleam/io
import gleam/regexp
import gleam/option.{Some}
import simplifile.{read}

pub fn main() {
  let filepath = "input.txt"
  let assert Ok(input) = read(from: filepath)
  part1(input) |> io.debug
  part2(input) |> io.debug
}

fn parse_instruction(input: List(regexp.Match), enabled: Bool, agg: List(Int)) -> List(Int) {
  case enabled, input {
    _, [regexp.Match("do()" <> _, []), ..tail] -> {
      parse_instruction(tail, True, agg)
    }
    _, [regexp.Match("don't()" <> _, []), ..tail] -> {
      parse_instruction(tail, False, agg)
    }
    False, [regexp.Match("mul" <> _, _), ..tail] -> {
      parse_instruction(tail, enabled, agg)
    }
    True, [regexp.Match("mul" <> _, [Some(a), Some(b)]), ..tail] -> { 
      let assert Ok(a) = int.parse(a)
      let assert Ok(b) = int.parse(b)
      parse_instruction(tail, enabled, [a*b, ..agg])
    }
    _, [] -> agg 
    _, [_, ..] -> {
      panic
    }
  }
}

fn parse_mul(input: String) {
  let assert Ok(re) = regexp.from_string("mul\\((\\d+),(\\d+)\\)")
  regexp.scan(with: re, content: input) 
    |> parse_instruction(True, [])
}

pub fn part1(input: String) -> Int {
  string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> list.flat_map(parse_mul) 
    |> list.fold(0, fn(a,b){a+b})
}

fn parse(input: String) {
  let assert Ok(re) = regexp.from_string("(?:don't\\(\\)|do\\(\\)|mul\\((\\d+),(\\d+)\\))")
  regexp.scan(with: re, content: input) 
    |> parse_instruction(True, [])
}

pub fn part2(input: String) -> Int {
  string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> string.concat()
    |> parse() 
    |> list.fold(0, fn(a,b){a+b})
}

