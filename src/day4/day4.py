import os

from src.util.file_utils import read_file_to_lines

example_file = os.path.dirname(os.path.realpath(__file__)) + "/example.txt"
input_file = os.path.dirname(os.path.realpath(__file__)) + "/input.txt"


def run(file):
    grid = [line for line in read_file_to_lines(file)]
    count = 0
    for y, row in enumerate(grid):
        for x, char in enumerate(row):
            xmas = "XMAS"
            buffer = len(xmas) - 1
            if char == "X":
                if y >= buffer:
                    if (
                        f"{char}{grid[y - 1][x]}{grid[y - 2][x]}{grid[y - 3][x]}"
                        == xmas
                    ):
                        count += 1
                if x >= buffer:
                    if (
                        f"{char}{grid[y][x - 1]}{grid[y][x - 2]}{grid[y][x - 3]}"
                        == xmas
                    ):
                        count += 1
                if y >= buffer and x >= buffer:
                    if (
                        f"{char}{grid[y - 1][x - 1]}{grid[y - 2][x - 2]}{grid[y - 3][x - 3]}"
                        == xmas
                    ):
                        count += 1
                if y <= len(grid) - len(xmas):
                    if (
                        f"{char}{grid[y + 1][x]}{grid[y + 2][x]}{grid[y + 3][x]}"
                        == xmas
                    ):
                        count += 1
                if y <= len(grid) - len(xmas) and x >= buffer:
                    if (
                        f"{char}{grid[y + 1][x - 1]}{grid[y + 2][x - 2]}{grid[y + 3][x - 3]}"
                        == xmas
                    ):
                        count += 1
                if y <= len(grid) - len(xmas) and x <= len(grid[y]) - len(xmas):
                    if (
                        f"{char}{grid[y + 1][x + 1]}{grid[y + 2][x + 2]}{grid[y + 3][x + 3]}"
                        == xmas
                    ):
                        count += 1
                if x <= len(grid[y]) - len(xmas):
                    if (
                        f"{char}{grid[y][x + 1]}{grid[y][x + 2]}{grid[y][x + 3]}"
                        == xmas
                    ):
                        count += 1
                if y >= buffer and x <= len(grid[y]) - len(xmas):
                    if (
                        f"{char}{grid[y - 1][x + 1]}{grid[y - 2][x + 2]}{grid[y - 3][x + 3]}"
                        == xmas
                    ):
                        count += 1
    print(count)
    x_count = 0
    for x in range(1, len(grid) - 1):
        for y in range(1, len(grid[x]) - 1):
            is_center_A = grid[x][y] == "A"
            diagonal_pair1 = {grid[x - 1][y - 1], grid[x + 1][y + 1]}
            diagonal_pair2 = {grid[x - 1][y + 1], grid[x + 1][y - 1]}
            valid_diagonals = diagonal_pair1 == diagonal_pair2 == {"M", "S"}

            if is_center_A and valid_diagonals:
                x_count += 1
    print(x_count)


run(input_file)
run(example_file)
