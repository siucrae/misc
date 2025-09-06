#!/bin/bash

# set the source (where all the subfolders are)
SRC_DIR="path/to/source/folder"

# set the destination (where everything will be dumped)
DEST_DIR="path/to/consolidated/folder"

# create destination if it doesn't exist
mkdir -p "$DEST_DIR"

# loop over subfolders
for d in "$SRC_DIR"/*/ ; do
    # check that it's actually a directory
    [ -d "$d" ] || continue

    # move contents into destination
    # -n avoids overwriting files with the same name
    mv -n "$d"/* "$DEST_DIR"/ 2>/dev/null
done
