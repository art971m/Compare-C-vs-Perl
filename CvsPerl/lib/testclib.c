#include <stdlib.h>
#include "./testclib.h"
double
foo(int a, long b, const char *c)
{
    return (a + b + atof(c) + TESTVAL);
}