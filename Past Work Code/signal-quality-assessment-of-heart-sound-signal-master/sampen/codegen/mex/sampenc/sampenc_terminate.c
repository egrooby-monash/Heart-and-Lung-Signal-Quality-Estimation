/*
 * sampenc_terminate.c
 *
 * Code generation for function 'sampenc_terminate'
 *
 * C source code generated on: Tue Aug 18 16:14:49 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "sampenc.h"
#include "sampenc_terminate.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */

void sampenc_atexit(void)
{
    emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void sampenc_terminate(void)
{
    emlrtLeaveRtStack(&emlrtContextGlobal);
}
/* End of code generation (sampenc_terminate.c) */
