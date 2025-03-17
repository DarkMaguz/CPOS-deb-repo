#!/bin/python3

import os
import glob

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

updatedDebFiles = []
for debDir in debDirList:
  print('########################', flush=True)
  print('Running: ', debDir, flush=True)
  print('########################', flush=True)
  os.chdir(os.path.join(baseDir, debDir))
  status = os.system('./build-deb.sh')
  debFiles = glob.glob('*.deb')
  for file in debFiles:
    if status == 0:
      os.system('mv "%s" "%s"' % (file, repoDebPath))
      updatedDebFiles.append(file)
    else:
      os.remove(file)

if updatedDebFiles:
  os.chdir(baseDir)
  os.system('./refresh-repo.sh')
