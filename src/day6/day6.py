import os

from src.util.file_utils import read_file_to_lines

example_file = os.path.dirname(os.path.realpath(__file__)) + "/example.txt"
input_file = os.path.dirname(os.path.realpath(__file__)) + "/input.txt"


def find_guard(grid):
    for y, row in enumerate(grid):
        for x, ch in enumerate(grid[y]):
            if ch == "^":
                return (x, y)


def run(file):
    grid = [list(line) for line in read_file_to_lines(file)]
    # guard_location[0] = x (left 0 to right len(grid[0]) - 1)
    # guard_location[1] = y (top 0 to bottom len(grid) - 1)
    guard_location = find_guard(grid)
    current_direction = "up"
    visited = set()

    while (
        guard_location[0] >= 0
        and guard_location[1] >= 0
        and guard_location[0] < len(grid)
        and guard_location[1] < len(grid[0])
    ):
        x, y = guard_location
        visited.add(guard_location)
        if current_direction == "up":
            next_up = y - 1
            if next_up < 0:
                break
            if grid[next_up][x] == "#":
                current_direction = "right"
            else:
                guard_location = (x, next_up)
        elif current_direction == "down":
            next_down = y + 1
            if next_down >= len(grid):
                break
            if grid[next_down][x] == "#":
                current_direction = "left"
            else:
                guard_location = (x, next_down)
        elif current_direction == "left":
            next_left = x - 1
            if next_left < 0:
                break
            if grid[y][next_left] == "#":
                current_direction = "up"
            else:
                guard_location = (next_left, y)
        elif current_direction == "right":
            next_right = x + 1
            if next_right >= len(grid[y]):
                break
            if grid[y][next_right] == "#":
                current_direction = "down"
            else:
                guard_location = (next_right, y)

    print(len(visited))


run(input_file)
run(example_file)
