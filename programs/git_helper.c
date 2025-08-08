#include <dirent.h>
#include <libgen.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

#define MAX_PATH_LENGTH 1024
#define MAX_REF_LENGTH 256

int is_directory(const char *path);
int is_git_repo(const char *path);
char *fetch_git_branch(char *path);
char *get_git_branch(const char *path);
int read_first_line(const char *path, char *buffer, size_t buffsize);

int main(int argc, char **argv) {
  if (argc != 2) {
    return 1;
  }

  if (!is_directory(argv[1])) {
    return 2;
  }

  char *resolved_path = realpath(argv[1], NULL);
  if (NULL == resolved_path) {
    return 3;
  }

  char *git_branch = fetch_git_branch(resolved_path);
  if (NULL == git_branch) {
    return 4;
  }

  printf("%s", git_branch);
  return 0;
}

int is_directory(const char *path) {
  struct stat statbuf;
  return (stat(path, &statbuf) == 0 && S_ISDIR(statbuf.st_mode));
}

int is_git_repo(const char *path) {
  char git_path[1024];
  char head_path[1024];

  snprintf(git_path, sizeof(git_path), "%s/.git", path);
  struct stat statbuf;

  if (stat(git_path, &statbuf) != 0 || !S_ISDIR(statbuf.st_mode)) {
    return 0;
  }

  snprintf(head_path, sizeof(head_path), "%s/.git/HEAD", path);
  if (stat(head_path, &statbuf) != 0 || !S_ISREG(statbuf.st_mode)) {
    return 0;
  }

  return 1;
}

char *fetch_git_branch(char *path) {
  if (NULL == path || strcmp(path, "/") == 0) {
    return NULL;
  }

  if (is_git_repo(path)) {
    return get_git_branch(path);
  }

  return fetch_git_branch(dirname(path));
}

int read_first_line(const char *path, char *buffer, size_t bufsize) {
  FILE *file = fopen(path, "r");
  if (!file) {
    return 0;
  }

  int success = fgets(buffer, bufsize, file) != NULL;
  fclose(file);

  if (success) {
    buffer[strcspn(buffer, "\n")] = '\0';
  }

  return success;
}

char *get_git_branch(const char *path) {
  char head_path[MAX_PATH_LENGTH];
  char buffer[MAX_REF_LENGTH];

  snprintf(head_path, sizeof(head_path), "%s/.git/HEAD", path);

  if (!read_first_line(head_path, buffer, sizeof(buffer))) {
    return strdup("no HEAD");
  }

  if (strlen(buffer) == 40) {
    return strdup("detached HEAD");
  }

  const char *prefix = "ref: refs/heads/";
  if (strncmp(buffer, prefix, strlen(prefix)) == 0) {
    return strdup(buffer + strlen(prefix));
  }

  char ref_path[MAX_PATH_LENGTH];
  snprintf(ref_path, sizeof(ref_path), "%s/.git/%s", path, buffer + 5);

  if (read_first_line(ref_path, buffer, sizeof(buffer))) {
    return strdup("worktree");
  }

  return strdup("unknown");
}
