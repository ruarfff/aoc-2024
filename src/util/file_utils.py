from pathlib import Path


def read_file_to_lines(file_name):
    p = Path(file_name)
    with p.open() as f:
        return f.read().splitlines()
