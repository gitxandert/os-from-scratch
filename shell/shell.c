#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
  char line[1024];
  char *argv[100];

  while (1) {
    printf("xsh> ");
    if (!fgets(line, sizeof(line), stdin)) break;

    line[strcspn(line, "\n")] = 0;

    if (strcmp(line, "exit") == 0) break;

    int argc = 0;
    argv[argc] = strtok(line, " ");
    while (argv[argc] != NULL && argc < 99) {
      argv[++argc] = strtok(NULL, " ");
    }

    pid_t pid = fork();
    if (pid == 0) {
      execvp(argv[0], argv);
      perror("exec failed");
      exit(1);
    } else if (pid > 0) {
      wait(NULL);
    } else {
      perror("fork failed");
    }
  }

  return 0;
}
