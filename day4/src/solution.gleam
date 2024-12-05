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

pub fn find_first_pattern(input: List(String), dir: Direction, width: Int, buffer: List(String) ) -> Int {
  case input, buffer {
    ["S", ..], ["A","M","X"]  -> 1 
    ["X", ..], ["M","A","S"]  -> 1 
    _ , [_,_,_]               -> 0
    [], _                     -> 0
    [h,..], buf               -> find_first_pattern(step(input, dir, width), dir, width, [h, ..buf])
  }
}


fn search_xmas(input: List(String), width: Int, pos: Int) -> Int {
  case input {
    [] -> 0
    [h, ..t] -> case pos % width {
      x if x < 3 -> {
        find_first_pattern(input, Right, width, [])  +  
          find_first_pattern(input, Down, width, [])   + 
          find_first_pattern(input, DiagRight, width, [])  
      }
      x if width - x < 4 -> {
        find_first_pattern(input, Down, width, []) + 
          find_first_pattern(input, DiagLeft, width, []) 
      }
      _ -> {
        find_first_pattern(input, Right, width, [])    +  
          find_first_pattern(input, Down, width, [])     + 
          find_first_pattern(input, DiagRight, width, [])+
          find_first_pattern(input, DiagLeft, width, [])  
      }
    } + search_xmas(t, width, pos+1)
  }
}

pub fn part1(input: String) -> Int {
  let input = string.split(input, "\n") |> list.filter(fn(x) {x != ""})
  let assert Ok(first) = list.first(input) 
  let length = string.length(first)
  let grapheme = list.flat_map(input, string.to_graphemes)
  search_xmas(grapheme, length, 0)
}

pub fn find_second_pattern(input: List(String), dir: Direction, width: Int, buffer: List(String) ) -> Bool {
  case input, buffer {
    ["S", ..], ["A","M"]  -> True
    ["M", ..], ["A","S"]  -> True 
    _ , [_,_,_]           -> False
    [], _                 -> False
    [h,..], buf           -> find_second_pattern(step(input, dir, width), dir, width, [h, ..buf])
  }
}

fn search_x(input: List(String), width: Int, pos: Int) {
  case input {
    [] -> 0
    [h, ..t] -> case pos % width {
      x if width - x >= 3 -> {
        let cross = find_second_pattern(input, DiagRight, width, []) &&
        find_second_pattern(traverse(input, 2), DiagLeft, width, []) 
        case cross {
          True  -> 1
          False -> 0
        }
      }
      _ -> 0
    } + search_x(t, width, pos+1)
  }
}

pub fn part2(input: String) -> Int {
  let input = string.split(input, "\n") |> list.filter(fn(x) {x != ""})
  let assert Ok(first) = list.first(input) 
  let length = string.length(first)
  let grapheme = list.flat_map(input, string.to_graphemes)
  search_x(grapheme, length, 0)
}

