#!/usr/bin/env python
import os
import shutil

current_folder = os.getenv('PROJECT_DIR')
action = os.getenv('ACTION')
configuration = os.getenv('CONFIGURATION')

if action == "install":
    source_folder = "iphoneos"
else:
    source_folder = "iphoneos_simulator"

source_framework_folder = os.path.join(current_folder, "libs", "ZegoLiveRoom-all", source_folder, "ZegoLiveRoom.framework")
dest_framework_folder = os.path.join(current_folder, "libs", "ZegoLiveRoom.framework")

if os.path.exists(dest_framework_folder):
    shutil.rmtree(dest_framework_folder, ignore_errors=True)

if os.path.exists(source_framework_folder):
    shutil.copytree(source_framework_folder, dest_framework_folder)
    log_name = os.path.join(current_folder, "libs", "zegoliveroom.version.txt")
    with open(log_name, 'w') as f:
        if action == "install":
            f.write('iphoneos \n')
        else:
            f.write('iphoneos & simulator \n')
        f.write(configuration)
    f.close()

