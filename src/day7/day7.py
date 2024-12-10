from math import prod
import os

from src.util.file_utils import read_file_to_lines

example_file = os.path.dirname(os.path.realpath(__file__)) + "/example.txt"
input_file = os.path.dirname(os.path.realpath(__file__)) + "/input.txt"

def check_prod_or_sum_backtracking(numbers, target):
    def evaluate(nums, operators):
        result = nums[0]
        for i in range(0, len(operators)):
            if operators[i] == '+':
                result += nums[i + 1]
            elif operators[i] == '*':
                result *= nums[i + 1]

        return result

    def generate_operator_combinations(cur_len):
        operators = ['+', '*']
        combinations = []

        def backtrack(curr):
            if len(curr) == cur_len:
                combinations.append(curr)
                return

            for op in operators:
                curr.append(op)
                backtrack(curr)
                curr.pop()

        backtrack([])
        return combinations


    num_operators = len(numbers) - 1
    operator_combinations = generate_operator_combinations(num_operators)
    solutions = []

    for operators in operator_combinations:
        result = evaluate(numbers, operators)
        if result == target:
            expression = numbers[0]
            for i in range(0, len(operators)):
                expression += f"{operators[i]} {numbers[i + 1]}"
            solutions.append(expression);
    
    return solutions

def run(file):
    part_1_res = 0
    lines = read_file_to_lines(file)
    for line in lines:        
        test_val, nums = line.split(": ")
        test_val = int(test_val)
        nums = [int(n) for n in nums.split(' ')]
        if sum(nums) == test_val or prod(nums) == test_val or len(check_prod_or_sum_backtracking(nums, test_val)) > 0:
            print(f"{line} is valid")
            part_1_res += test_val

    print(part_1_res)


run(example_file)
