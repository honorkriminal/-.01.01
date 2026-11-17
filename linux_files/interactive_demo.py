from pathlib import Path
import os
import tempfile
import pexpect

work = Path(tempfile.mkdtemp(prefix="linux-editors-"))
env = dict(os.environ, TERM="xterm", LC_ALL="C")

def start(command, args):
    return pexpect.spawn(command, args, cwd=str(work), env=env,
                         encoding="utf-8", timeout=10, dimensions=(12, 80))

print("\n$ cat > cat_notes.txt")
child = start("bash", ["-c", "cat > cat_notes.txt"])
child.sendline("Created with cat")
child.sendcontrol("d")
child.expect(pexpect.EOF)
child.close()
assert child.exitstatus == 0
print("Created with cat\n<Ctrl+D>")
print("$ cat cat_notes.txt")
print((work / "cat_notes.txt").read_text(), end="")

print("\n$ vi -u NONE -n vi_notes.txt")
child = start("vi", ["-u", "NONE", "-n", "vi_notes.txt"])
child.expect("vi_notes.txt")
child.send("iHello from vi!")
child.send("\x1b")
child.send("ZZ")
child.expect(pexpect.EOF)
child.close()
assert child.exitstatus == 0
assert (work / "vi_notes.txt").read_text() == "Hello from vi!\n"
print("iHello from vi!<Esc>ZZ")
print("$ cat vi_notes.txt")
print((work / "vi_notes.txt").read_text(), end="")

print("\n$ vi -u NONE -n vi_notes.txt")
child = start("vi", ["-u", "NONE", "-n", "vi_notes.txt"])
child.expect("vi_notes.txt")
child.send("iUNSAVED ")
child.send("\x1b:q!\r")
child.expect(pexpect.EOF)
child.close()
assert child.exitstatus == 0
assert (work / "vi_notes.txt").read_text() == "Hello from vi!\n"
print("iUNSAVED <Esc>:q!<Enter>")
print("$ cat vi_notes.txt")
print((work / "vi_notes.txt").read_text(), end="")

(work / "long.txt").write_text("".join(f"Line {n:03d}\n" for n in range(1, 101)))
print("\n$ more long.txt")
child = start("more", ["long.txt"])
child.expect("--More--")
print(child.before.strip())
child.send(" ")
child.expect("--More--")
assert "Line 012" in child.before
print("<Space>")
child.send("\r")
child.expect("--More--")
print("<Enter>")
child.send("b")
child.expect("--More--")
print("b")
child.send("q")
child.expect(pexpect.EOF)
child.close()
assert child.exitstatus == 0
print("q")
