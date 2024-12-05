import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, Some, None}
import gleam/result
import gleam/set
import gleam/string
import simplifile.{read}

pub fn main() {
  let filepath = "input.txt"
  let assert Ok(input) = read(from: filepath)
  part1(input) |> io.debug
  part2(input) |> io.debug
}

pub type Rulebook = dict.Dict(Int, set.Set(Int))

fn rb_add(rulebook: Rulebook, rule: List(Int)) -> Rulebook {
  let assert [before, after] = rule
  dict.upsert(rulebook, after, fn(v) {
    case v {
      Some(v) -> set.insert(v, before) 
      None    -> set.from_list([before]) 
    }
  })
}

fn rb_get(rulebook: Rulebook, key: Int) -> set.Set(Int) {
  dict.get(rulebook, key) |> result.unwrap(or: set.new())
}

pub fn valid_update(rulebook: Rulebook, update: List(Int)) -> Bool {
  case update {
    [] -> True
    [before, ..after] -> {
      rb_get(rulebook, before) 
        |> set.intersection(set.from_list(after))
        |> set.is_empty()
        |> bool.and(valid_update(rulebook, after))
    }
  }
}

pub fn parse_rules(input: String) -> Rulebook {
  let assert Ok(rules) = string.split(input, "\n") |> list.try_map(
      fn(r) {
      string.split(r,"|") |> list.try_map(int.parse)
      })
  let rulebook: Rulebook = dict.new()
  list.fold(rules, rulebook, rb_add)
}

fn parse_updates(input: String) {
  let assert Ok(updates) = string.split(input, "\n") 
    |> list.filter(fn(x) {x != ""})
    |> list.try_map(
      fn(r) {
      string.split(r,",") |> list.try_map(int.parse)
      })
  updates
}

fn list_midpoint(input: List(a)) -> a {
  let length = list.length(input)
  let assert Ok(mid) = int.divide(length, 2)
  let assert [h, ..] = list.drop(input, mid) 
  h
}

pub fn part1(input: String) -> Int {
  let assert [rules, pages, ..] = string.split(input, "\n\n") 
  let updates = parse_updates(pages)
  let rulebook = parse_rules(rules)
  list.filter(updates, fn(u) {valid_update(rulebook,u)})
    |> list.map(list_midpoint)
    |> list.fold(0, fn(a,b) {a+b})
}

pub fn reorder(updates: List(Int), rulebook: Rulebook) -> List(Int) {
  case updates {
    [] -> []
    [h] -> [h]
    [before, ..after] -> {
      let wrong_set = rb_get(rulebook, before) 
        |> set.intersection(set.from_list(after))
      let new_head = after 
        |> list.filter(fn(e) {set.contains(wrong_set, e)})
      let new_after = after
        |> list.filter(fn(e) {!set.contains(wrong_set, e)})
      list.flatten([reorder(new_head, rulebook),[before],reorder(new_after, rulebook)])
    }
  }
}

pub fn part2(input: String) -> Int {
  let assert [rules, pages, ..] = string.split(input, "\n\n") 
  let updates = parse_updates(pages)
  let rulebook = parse_rules(rules)
  list.filter(updates, fn(u) {!valid_update(rulebook,u)}) 
    |> list.map(fn(l){reorder(l,rulebook)})
    |> list.map(list_midpoint)
    |> list.fold(0, fn(a,b) {a+b})
}

