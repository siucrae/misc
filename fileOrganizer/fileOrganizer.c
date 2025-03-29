#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>

#define MAX_EXTENSIONS 10

// file categories and their extensions
typedef struct {
    char *folder;
    char *extensions[MAX_EXTENSIONS];
} FileCategory;

FileCategory categories[] = {
    {"Videos", {"mp4", "mkv", "avi", "mov", "webm", NULL}},
    {"Pictures", {"jpg", "jpeg", "png", "gif", "bmp", "svg", NULL}},
    {"Documents", {"pdf", "docx", "txt", "odt", "pptx", "xlsx", NULL}},
    {"Music", {"mp3", "wav", "flac", "aac", "ogg", NULL}},
    {"Archives", {"zip", "rar", "tar", "gz", "7z", NULL}},
    {"Executables", {"exe", "sh", "bin", "appimage", NULL}},
    {"Code", {"c", "cpp", "py", "js", "html", "css", NULL}}
};

#define CATEGORY_COUNT (sizeof(categories) / sizeof(categories[0]))

// function to get file extension
const char *get_file_extension(const char *filename) {
    const char *dot = strrchr(filename, '.');
    return (dot && dot != filename) ? dot + 1 : NULL;
}

// function to check if a directory exists and create it if it doesnt
void create_directory(const char *folder) {
    struct stat st;
    if (stat(folder, &st) == -1) {
        mkdir(folder, 0777); // create folder with full permissions
    }
}

// function to move a file to the appropriate folder
void move_file(const char *filename, const char *folder) {
    char destination[512];
    snprintf(destination, sizeof(destination), "%s/%s", folder, filename);
    rename(filename, destination);
    printf("Moved %s -> %s\n", filename, destination);
}

// main function to organize files
void organize_files() {
    DIR *dir;
    struct dirent *entry;

    if ((dir = opendir(".")) == NULL) {
        perror("opendir failed");
        return;
    }

    while ((entry = readdir(dir)) != NULL) {
        if (entry->d_type == DT_REG) { // only process regular files
            const char *ext = get_file_extension(entry->d_name);
            if (ext) {
                for (int i = 0; i < CATEGORY_COUNT; i++) {
                    for (int j = 0; categories[i].extensions[j] != NULL; j++) {
                        if (strcasecmp(ext, categories[i].extensions[j]) == 0) {
                            create_directory(categories[i].folder);
                            move_file(entry->d_name, categories[i].folder);
                            break;
                        }
                    }
                }
            }
        }
    }

    closedir(dir);
}

int main() {
    organize_files();
    return 0;
}
