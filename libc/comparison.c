double factorial_recursive_c(int x) {
    if (x < 2)  return 1;
    return x * factorial_recursive_c(x - 1);
}

double factorial_iterative_c(int x) {
    int i;
    double result = 1;
    for (i = 2; i <= x; i++)
        result *= i;
    return result;
}