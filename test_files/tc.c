#include <stdio.h>

int main()
{
    int c = 1;
    goto main;
main:
    c = c++ + c;
    printf("%d", c);
    return 0;
}
