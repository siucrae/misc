#!/usr/bin/env python3

import os
import time
import subprocess

# prompt user
osu_maps_folder = input("Enter the full path to your osu maps folder: ").strip()

# go through each subdirectory
for root, _, files in os.walk(osu_maps_folder):
    for file in files:
        if file.endswith(".osz"):
            osu_file_path = os.path.join(root, file)
            print(f"Opening: {osu_file_path}")
            subprocess.run(["xdg-open", osu_file_path])  # linux (use "start" for windows and "open" for mac)
            time.sleep(3)
