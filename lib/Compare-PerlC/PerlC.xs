#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <comparison.h>


MODULE = Compare::PerlC		PACKAGE = Compare::PerlC		


double
factorial_iterative_c(x)
	int	x

double
factorial_recursive_c(x)
	int	x
