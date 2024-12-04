import gleam/string
import gleam/list
import gleam/io
import simplifile.{read}

pub fn main() {
  let filepath = "input.txt"
  let assert Ok(input) = read(from: filepath)
  part1(input) |> io.debug
  part2(input) |> io.debug
}


pub type Direction {
  Right
  Down
  DiagLeft
  DiagRight
}

fn traverse(input: List(String), steps: Int) -> List(String) {
  case steps, input {
    1, [_, ..t] -> t
    n, [_, ..t] -> traverse(t, n-1)
    _, _ -> []
  }
}

pub fn step(input: List(String), direction: Direction, width: Int) -> List(String) {
  let right         = 1
  let down          = width 
  let diag_left     = width - 1
  let diag_right    = width + 1

  case direction {
    Down      -> traverse(input, down)
    Right     -> traverse(input, right)
    DiagLeft  -> traverse(input, diag_left)
    DiagRight -> traverse(input, diag_right)
  }
}

pub fn find_patterns(input: List(String), dir: Direction, width: Int, buffer: List(String) ) -> Int {
  case input, buffer {
    ["S", ..], ["A","M","X"]  -> 1 
    ["X", ..], ["M","A","S"]  -> 1 
    _ , [_,_,_]               -> 0
    [], _                     -> 0
    [h,..], buf               -> find_patterns(step(input, dir, width), dir, width, [h, ..buf])
  }
}

fn parse_tree(input: List(String), width: Int, pos: Int) -> Int {
  case input {
    [] -> 0
    [h, ..t] -> case pos % width {
      x if x < 3 -> {
        find_patterns(input, Right, width, [])  +  
          find_patterns(input, Down, width, [])   + 
          find_patterns(input, DiagRight, width, [])  
      }
      x if width - x < 4 -> {
        find_patterns(input, Down, width, []) + 
          find_patterns(input, DiagLeft, width, []) 
      }
      _ -> {
        find_patterns(input, Right, width, [])    +  
          find_patterns(input, Down, width, [])     + 
          find_patterns(input, DiagRight, width, [])+
          find_patterns(input, DiagLeft, width, [])  
      }
    } + parse_tree(t, width, pos+1)
  }
}

pub fn parse_input(input: List(String)) -> Int {
  let assert Ok(first) = list.first(input) 
  let length = string.length(first)
  let grapheme = list.flat_map(input, string.to_graphemes)
  parse_tree(grapheme, length, 0)
}

pub fn part1(input: String) -> Int {
  string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> parse_input()
}

pub fn part2(input: String) -> Int {
  string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> io.debug
  1
}

