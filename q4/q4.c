#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main(void)
{
    char op[6];
    int num1, num2;
    char libpath[16];

    while (scanf("%5s %d %d", op, &num1, &num2) == 3) {
        snprintf(libpath, sizeof(libpath), "./lib%s.so", op);

        void *handle = dlopen(libpath, RTLD_LAZY);
        if (!handle) {
            fprintf(stderr, "dlopen failed for %s: %s\n", libpath, dlerror());
            return 1;
        }

        dlerror();

        int (*func)(int, int) = (int (*)(int, int)) dlsym(handle, op);
        char *err = dlerror();
        if (err != NULL) {
            fprintf(stderr, "dlsym failed for symbol '%s': %s\n", op, err);
            dlclose(handle);
            return 1;
        }

        printf("%d\n", func(num1, num2));

        dlclose(handle);
    }

    return 0;
}
