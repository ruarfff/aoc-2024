import os
from collections import Counter

from src.util.file_utils import read_file_to_lines

input_file = os.path.dirname(os.path.realpath(__file__)) + "/input.txt"


def run_part1():
    input = read_file_to_lines(input_file)

    left, right = tuple(
        map(
            list,
            zip(
                *[
                    (int(nums[0]), int(nums[1]))
                    for nums in [x.split("   ") for x in input]
                ]
            ),
        ),
    )
    left.sort()
    right.sort()
    result = 0
    for i in range(len(left)):
        result += abs(left[i] - right[i])

    print(result)


run_part1()


def run_part2():
    input = read_file_to_lines(input_file)

    left, right = tuple(
        map(
            list,
            zip(
                *[
                    (int(nums[0]), int(nums[1]))
                    for nums in [x.split("   ") for x in input]
                ]
            ),
        ),
    )
    counts = Counter(right)
    result = 0
    for n in left:
        result += n * counts[n]

    print(result)


run_part2()
