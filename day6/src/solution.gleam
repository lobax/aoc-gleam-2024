import gleam/string
import gleam/list
import gleam/int
import gleam/io
import gleam/result
import gleam/option.{type Option, Some, None}
import gleam/dict.{type Dict}
import simplifile.{read}

pub fn main() {
  let filepath = "input.txt"
  let assert Ok(input) = read(from: filepath)
  part1(input) |> io.debug
//  part2(input) |> io.debug
}

type Map = Dict(Int, List(String))

fn map_get(map: Map, pos: #(Int, Int)) -> Result(String, Nil) {
  use row <- result.then(dict.get(map, pos.1))
  case list.drop(row, pos.0) {
    _ if pos.0 < 0 -> Error(Nil)
    [h,..] -> Ok(h)
    [] -> Error(Nil)
  }
}

fn mark_map(map: Map, pos: #(Int, Int), symbol: String) -> Map {
  let assert [symbol] = string.to_graphemes(symbol)
  let assert Ok(row) = dict.get(map, pos.1)
  let list = list.append(list.take(row, pos.0), [symbol, ..list.drop(row, pos.0 + 1)])
  dict.insert(map, pos.1, list)
}

fn map_draw(map: Map) {
  dict.to_list(map) 
    |> list.sort(fn(a,b) {int.compare(a.0,b.0)}) 
    |> list.map(fn(t) {t.1})
    |> list.map(string.concat)
    |> list.each(io.debug)
}

fn to_map(input: List(List(String))) -> Map {
  input 
    |> list.index_map(fn(l, i) { #(i,l) })
    |> dict.from_list
}

fn find_start(map: Map, pos: #(Int, Int)) -> #(Int, Int) {
  case map_get(map, pos) {
    Ok("^")     -> pos
    Ok(_)       -> find_start(map, #(pos.0+1,pos.1)) 
    Error(Nil)  -> find_start(map, #(0,pos.1+1))
  }
}

type Direction {
  Up
  Down
  Left
  Right
}

fn rotate(dir: Direction) -> Direction {
  case dir {
    Up    -> Right
    Right -> Down
    Down  -> Left
    Left  -> Up
  }
}

type Context {
  Context(map: Map, pos: #(Int, Int), dir: Direction, marks: Int)
}

fn walk(context: Context) -> Context {
  let Context(map, #(x, y) as pos, dir, marks) = context

  let next = case  dir {
    Down  -> #(x, y+1)
    Up    -> #(x, y-1)
    Right -> #(x+1, y)
    Left  -> #(x-1, y)
  }

  case map_get(map, pos), map_get(map, next) {
    Ok(_), Ok("#")  -> walk(Context(map, pos, rotate(dir), marks))
    Ok("X"), Ok(_)  -> walk(Context(map, next, dir, marks))
    Ok(_), Ok(_)    -> {
      let map = mark_map(map, pos, "X") 
      walk(Context(map, next, dir, marks+1))
    }
    Ok(_), Error(Nil)      -> {
      let map = mark_map(map, pos, "X") 
      map_draw(map)
      Context(map, pos, dir, marks+1)
    }
    Error(Nil), _ -> panic as "Invalid postion!"
  }
}

pub fn part1(input: String) -> Int {
  let map = string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> list.map(string.to_graphemes)
    |> to_map()
   let start = map |> find_start(#(0,0))
   let context = walk(Context(map, start, Up, 0))
   context.marks
}

pub fn part2(input: String) -> Int {
  string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> io.debug
  1
}

