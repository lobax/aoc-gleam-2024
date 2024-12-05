import gleeunit
import gleeunit/should
import solution.{part1, part2}

pub fn main() {
  gleeunit.main()
}

pub fn test_rules() {
  let input = 
"47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13"

  let rulebook = solution.parse_rules(input)
  solution.valid_update(rulebook, [75,47,61,53,29]) |> should.equal(True)
  solution.valid_update(rulebook, [97,61,53,29,13]) |> should.equal(True)
  solution.valid_update(rulebook, [97,13,75,29,47]) |> should.equal(False)
}

pub fn part1_test() {
  let input = 
"47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"

  part1(input) |> should.equal(143)
}

pub fn part2_test() {
  let input = 
"47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"

  part2(input) |> should.equal(123)
}

