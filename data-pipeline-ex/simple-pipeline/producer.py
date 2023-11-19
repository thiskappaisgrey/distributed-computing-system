import sys
from pathlib import Path

# data dir
dir = sys.argv[1]
dirPath = Path(dir)
if not dirPath.is_dir():
    print("Path given is not a dir", file=sys.stderr)
    exit(1)
# this script creates the file
file = dirPath / "myfile.txt"
if file.exists():
    print("File exists, pick another dir", file=sys.stderr)
    exit(1)
file.write_text("Hello world")
