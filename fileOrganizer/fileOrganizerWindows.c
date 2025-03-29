#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <dirent.h>

// quick function to check if a folder exists or make one if it doesnt
void ensure_directory(const char *folder) {
    struct stat st = {0};
    if (stat(folder, &st) == -1) {
        mkdir(folder, 0700); // standard permissions should be fine
    }
}

// handles the actual moving process
void move_file(const char *filename, const char *folder) {
    char command[512];
    snprintf(command, sizeof(command), "mv '%s' '%s/'", filename, folder);
    system(command); // not super fancy
}

int main() {
    DIR *d;
    struct dirent *dir;
    d = opendir("."); // grabs the current directory
    if (!d) {
        printf("Could not open directory.\n");
        return 1;
    }

    // make folders are set up
    ensure_directory("Videos");
    ensure_directory("Pictures");
    ensure_directory("Documents");

    while ((dir = readdir(d)) != NULL) {
        char *ext = strrchr(dir->d_name, '.'); // checking file extension
        if (!ext) continue;

        // sorting files based on extension
        if (strcmp(ext, ".mkv") == 0 || strcmp(ext, ".mp4") == 0 || strcmp(ext, ".avi") == 0) {
            move_file(dir->d_name, "Videos");
        } else if (strcmp(ext, ".jpg") == 0 || strcmp(ext, ".png") == 0 || strcmp(ext, ".gif") == 0) {
            move_file(dir->d_name, "Pictures");
        } else if (strcmp(ext, ".pdf") == 0 || strcmp(ext, ".docx") == 0 || strcmp(ext, ".txt") == 0) {
            move_file(dir->d_name, "Documents");
        }
    }
    closedir(d);
    printf("Files have been sorted. All good!\n");
    return 0;
}
