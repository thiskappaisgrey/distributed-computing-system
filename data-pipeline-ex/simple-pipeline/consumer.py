from pathlib import Path
import sys

arg = sys.argv[1]

dir = Path(arg)
if not dir.is_dir():
    print("Pick an existing directory", file=sys.stderr)
    exit(1)
# This script consumes the file
file = dir / "myfile.txt"
if not file.exists():
    print("Run one.py first", file=sys.stderr)
    exit(1)
print(file.read_text())
