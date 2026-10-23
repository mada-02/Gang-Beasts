"""Builds the development player and runs DevTestRunner suites headless.

  python -I tools/dev/run_tests.py --build                       batch-build only
  python -I tools/dev/run_tests.py --suite smoke [--build]       run suites (comma-separated)
      [--seeds 1-5 | --seeds 1,4,9] [--filter name] [--timeout 900] [--windowed] [--release]

Results go to dev/out/results/<time>/: one JSONL file and one player log per seed, plus summary.json.
Exit code 0 only when every test of every seed passed and every run reached its end marker.
Unity must not have the project open (it locks the project); --build refuses if it does.
"""
import argparse
import datetime
import json
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RECON = os.path.normpath(os.path.join(HERE, "..", ".."))
REPO = os.path.dirname(RECON)
PROJECT = os.path.join(RECON, "GangBeasts")
OUT = os.path.join(RECON, "dev", "out")
PLAYER_DIR = os.path.join(OUT, "player")


def find_unity():
    if os.environ.get("UNITY_EXE"):
        return os.environ["UNITY_EXE"]
    for base in (REPO, os.path.dirname(REPO)):
        exe = os.path.join(base, "UnitySetup-4.3.2", "Unity.exe")
        if os.path.isfile(exe):
            return exe
    sys.exit("Unity 4.3.2 not found next to the repository (set UNITY_EXE)")


def project_locked():
    lock = os.path.join(PROJECT, "Temp", "UnityLockfile")
    if not os.path.exists(lock):
        return False
    try:
        # Unity holds the lock file open while the project is loaded; Windows refuses the rename.
        os.rename(lock, lock + ".probe")
        os.rename(lock + ".probe", lock)
        return False
    except OSError:
        return True


def build(release, exe):
    if project_locked():
        sys.exit("The Unity editor has this project open; close it before a batch build.")
    os.makedirs(PLAYER_DIR, exist_ok=True)
    log = os.path.join(OUT, "build.log")
    cmd = [find_unity(), "-batchmode", "-quit", "-projectPath", PROJECT, "-executeMethod", "DevBuild.BuildPlayer",
           "-devbuildout", exe, "-logFile", log]
    if release:
        cmd.append("-devbuildrelease")
    print("building", exe)
    started = datetime.datetime.now()
    code = subprocess.call(cmd)
    print("build exit", code, "in", datetime.datetime.now() - started)
    if code != 0 or not os.path.isfile(exe):
        if os.path.isfile(log):
            with open(log, encoding="utf-8", errors="replace") as f:
                print("".join(f.readlines()[-60:]))
        sys.exit("build failed (log: %s)" % log)


def parse_seeds(text):
    seeds = []
    for part in text.split(","):
        if "-" in part:
            lo, hi = part.split("-")
            seeds.extend(range(int(lo), int(hi) + 1))
        else:
            seeds.append(int(part))
    return seeds


def run_seed(exe, suites, seed, args, results_dir):
    jsonl = os.path.join(results_dir, "seed%d.jsonl" % seed)
    log = os.path.join(results_dir, "seed%d.player.log" % seed)
    cmd = [exe, "-devtest", suites, "-devseed", str(seed), "-devout", jsonl, "-logFile", log]
    if not args.windowed:
        cmd[1:1] = ["-batchmode", "-nographics"]
    else:
        cmd[1:1] = ["-screen-width", "640", "-screen-height", "360", "-screen-fullscreen", "0"]
    if args.filter:
        cmd += ["-devfilter", args.filter]
    started = datetime.datetime.now()
    try:
        code = subprocess.call(cmd, timeout=args.timeout)
    except subprocess.TimeoutExpired:
        code = "timeout"
        subprocess.call(["taskkill", "/F", "/IM", os.path.basename(exe)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    elapsed = (datetime.datetime.now() - started).total_seconds()
    # Unity 4 players also write <name>_Data/output_log.txt; keep it next to the results.
    data_log = os.path.join(os.path.dirname(exe), os.path.splitext(os.path.basename(exe))[0] + "_Data", "output_log.txt")
    if not os.path.isfile(log) and os.path.isfile(data_log):
        shutil.copyfile(data_log, log)
    records = []
    if os.path.isfile(jsonl):
        with open(jsonl, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line:
                    records.append(json.loads(line))
    return code, elapsed, records


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--build", action="store_true")
    parser.add_argument("--release", action="store_true")
    parser.add_argument("--suite")
    parser.add_argument("--seeds", default="1")
    parser.add_argument("--filter")
    parser.add_argument("--timeout", type=int, default=900)
    parser.add_argument("--windowed", action="store_true")
    parser.add_argument("--exe", default=os.path.join(PLAYER_DIR, "GangBeastsDev.exe"))
    args = parser.parse_args()
    if args.build:
        build(args.release, args.exe)
    if not args.suite:
        return 0
    if not os.path.isfile(args.exe):
        sys.exit("no player at %s (run with --build)" % args.exe)
    stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    results_dir = os.path.join(OUT, "results", stamp)
    os.makedirs(results_dir)
    summary = {"suites": args.suite, "seeds": [], "ok": True}
    for seed in parse_seeds(args.seeds):
        code, elapsed, records = run_seed(args.exe, args.suite, seed, args, results_dir)
        ended = any(r.get("type") == "end" for r in records)
        tests = [r for r in records if r.get("type") == "test"]
        print("\n=== seed %d: exit %s, %.1f s, %d tests%s" % (seed, code, elapsed, len(tests), "" if ended else ", NO END MARKER"))
        for r in tests:
            print("  %-5s %s/%s  (%s checks, %s steps, %.1f s)" % (r["status"].upper(), r["suite"], r["name"], r.get("checks"),
                                                                 r.get("steps"), r.get("real_seconds", 0)))
            for failure in r.get("failures", []):
                print("        fail: " + failure)
            for error in r.get("errors", [])[:5]:
                print("        log:  " + error.splitlines()[0][:200])
            if r.get("metrics"):
                print("        metrics: " + json.dumps(r["metrics"]))
            if r.get("info"):
                print("        info: " + json.dumps(r["info"]))
        ok = ended and all(r["status"] == "pass" for r in tests)
        summary["seeds"].append({"seed": seed, "exit": code, "seconds": elapsed, "ended": ended, "ok": ok, "tests": tests})
        summary["ok"] = summary["ok"] and ok
    with open(os.path.join(results_dir, "summary.json"), "w", encoding="utf-8", newline="\n") as f:
        json.dump(summary, f, indent=1)
    print("\n%s  (results: %s)" % ("ALL PASSED" if summary["ok"] else "FAILED", results_dir))
    return 0 if summary["ok"] else 1


if __name__ == "__main__":
    sys.exit(main())
