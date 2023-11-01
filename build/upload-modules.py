import os
import subprocess

PIPELINE_RUN = True if "GITHUB_ACTIONS" in os.environ else False

gitdir = os.path.dirname(os.path.abspath(__file__))
while True:
    if os.path.exists(os.path.join(gitdir, ".git")):
        directory = gitdir
        break
    elif gitdir == "/":
        raise EnvironmentError("This is not a git repository.")
    gitdir = os.path.dirname(gitdir)


def run_command(command: str) -> str:
    cmdargs = {
        "capture_output": True,
        "cwd": gitdir,
        "shell": True,
        "encoding": "UTF-8"
    }
    return subprocess.run(args=command, **cmdargs).stdout.strip("\n")


current_branch = run_command("git rev-parse --abbrev-ref HEAD")
remote_branch = f"refs/heads/{current_branch}"

if not PIPELINE_RUN:
    last_remote_commit = f"git ls-remote --heads origin | grep \"{remote_branch}\" | cut -f 1"
    last_commit = run_command(last_remote_commit)
else:
    last_remote_commit = os.environ.get("github.sha")


files = run_command(f"git diff-tree no-commit-id --name-only -r {last_remote_commit}")
files = files.split(",")

unique_modules = {}
for file in files:
    provider, module_name = tuple(file.split("/")[1:2])
    unique_modules[module_name] = provider
print("here")
