#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <./CvsPerl/lib/testclib.h>

#include "const-c.inc"

MODULE = CvsPerl		PACKAGE = CvsPerl		

INCLUDE: const-xs.inc

TYPEMAP: <<END
const char *	T_PV
END

double
foo(a,b,c)
		int             a
		long            b
		const char *    c
	OUTPUT:
		RETVAL