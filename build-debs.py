#!/bin/python3

import os
import subprocess
import concurrent.futures

#'unity-lts'
debDirList = ['discord', 'firefox']
baseDir = os.getcwd()
repoDebPath = os.path.join(baseDir, "repo/amd64")

if os.environ.get('DEBUG'):
  print('########################', flush=True)
  print('#     Build Config     #', flush=True)
  print('------------------------', flush=True)
  print('Targets: ', debDirList, flush=True)
  print('Base Dir: ', baseDir, flush=True)
  print('Repo Deb Path: ', repoDebPath, flush=True)
  print('########################', flush=True)

def buildDeb(dir):
  res = None
  try:
    res = subprocess.run(["./build-deb.sh", dir, repoDebPath], capture_output=True)
  except Exception as e:
    return False, e
  return res.returncode == 0, [res.stdout, res.stderr]

def main():
  with concurrent.futures.ProcessPoolExecutor(4) as executor:
    for dir, [success, log] in zip(debDirList, executor.map(buildDeb, debDirList)):
      print(dir, success)
      if not success or os.environ.get('DEBUG'):
        print(log[0].decode('utf-8'), flush=True)
        # print(log[1].decode('utf-8'), flush=True)
  subprocess.run("./refresh-repo.sh")

if __name__ == '__main__':
  main()
