#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(int argc, const char *argv[])
{
    int ret;
    unsigned char buf[256];
    unsigned char cwd[256];
    char *path;
    if (argc != 2) {
        printf("When in Vim terminal, ve tell Vim to open file for edit in current Vim\nUsage: ve file\n");
        return -1;
    }

    path = NULL;
    if (!strncmp("~/",argv[1], 2) || !strncmp("/",argv[1],1)) {
        /* nothing */
    } else {
        /* need to get current working directory */
        path = getcwd(cwd, sizeof(cwd));
        //printf("path is:%s\n", path);
    }

    if (path != NULL) {
        ret = snprintf(buf, sizeof(buf), "\x1b]51;[\"drop\",\"%s/%s\"]\x07\n", path, argv[1]);
    } else {
        ret = snprintf(buf, sizeof(buf), "\x1b]51;[\"drop\",\"%s\"]\x07\n", argv[1]);
    }
    //ret = snprintf(buf, sizeof(buf), "\x1b]51;[\"call\",\"TerminalEdit\",[\"%s\"]]\x07\n", argv[1]);
    if (ret >= sizeof(buf)) {
        printf("file path too long\n");
        return -1;
    }

    printf("%s",buf);
    return 0;
}

