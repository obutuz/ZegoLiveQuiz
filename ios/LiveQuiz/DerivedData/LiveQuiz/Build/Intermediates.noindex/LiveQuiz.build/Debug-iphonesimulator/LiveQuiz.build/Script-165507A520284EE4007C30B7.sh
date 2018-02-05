#!/usr/bin/env python
import os
import subprocess

action = os.getenv('ACTION')
configuration = os.getenv('CONFIGURATION')
if action == "install":
    exit(0)
if configuration == "Release":
    exit(0)

current_folder = os.getenv('PROJECT_DIR')
copy_framework_path = os.path.join(current_folder, "..", "copy_framework_new.py")

if os.path.exists(copy_framework_path):
    log_file = os.path.join(current_folder, "..", "log.txt")
    with open(log_file, "w") as outfile:
        arguments = [copy_framework_path, '-repackage']
        subprocess.call(arguments, stdout=outfile)
