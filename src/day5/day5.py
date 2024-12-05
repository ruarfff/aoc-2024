import os
from collections import defaultdict
from itertools import groupby

from src.util.file_utils import read_file_to_lines

example_file = os.path.dirname(os.path.realpath(__file__)) + "/example.txt"
input_file = os.path.dirname(os.path.realpath(__file__)) + "/input.txt"


def sort_numbers(numbers, rules):
    graph = defaultdict(set)
    for rule in rules:
        left, right = rule.split("|")
        graph[int(left)].add(int(right))
    index_map = {num: index for index, num in enumerate(numbers)}
    visited = set()
    sorted_numbers = []

    def dfs(num):
        visited.add(num)
        for dep in graph[num]:
            if dep in index_map and dep not in visited:
                dfs(dep)

        sorted_numbers.append(num)

    for num in numbers:
        if num not in visited:
            dfs(num)

    return sorted_numbers.reverse()


def run(file):
    rules, pages = [
        list(group)
        for key, group in groupby(read_file_to_lines(file), lambda x: x != "")
        if key
    ]
    rule_map = {}
    for rule in rules:
        before, after = rule.split("|")
        if not rule_map.get(int(before)):
            rule_map[int(before)] = set()
        rule_map[int(before)].add(int(after))

    pages = [list(map(int, page.split(","))) for page in pages]

    result = 0
    result2 = 0
    for page in pages:
        seen = set()
        valid = True
        for p in page:
            if p in rule_map:
                if rule_map[p] & seen:
                    valid = False
                    print(f"Invalid page: {page}")
                    break
            seen.add(p)
        if valid:
            result += page[len(page) // 2]
        else:
            sorted_page = sort_numbers(page, rules)
            print(f"Sorted page: {sorted_page}")
            result2 += sorted_page[len(sorted_page) // 2]

    print(result)
    print(result2)


run(input_file)
run(example_file)
