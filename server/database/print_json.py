import json
import os
from typing import Union

from pygments import highlight
from pygments.lexers import JsonLexer
from pygments.formatters import TerminalFormatter

def pretty_print_json_color(file_path: Union[str, os.PathLike] = "db.json") -> None:
    """
    Reads a JSON file and prints it in a human-readable, colorized format.

    :param file_path: Path to the JSON file (defaults to "db.json").
    """
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"\033[31mError:\033[0m File not found: {file_path}")
        return
    except json.JSONDecodeError as e:
        print(f"\033[31mError:\033[0m Failed to parse JSON in {file_path}: {e}")
        return

    # Dump with indentation and sorted keys
    pretty = json.dumps(data, indent=4, sort_keys=True, ensure_ascii=False)

    # Use Pygments to colorize
    colorful = highlight(pretty, JsonLexer(), TerminalFormatter())
    print(colorful)

if __name__ == "__main__":
    pretty_print_json_color("db.json")
