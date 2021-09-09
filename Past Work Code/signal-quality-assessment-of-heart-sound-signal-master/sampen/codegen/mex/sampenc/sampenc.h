/*
 * sampenc.h
 *
 * Code generation for function 'sampenc'
 *
 * C source code generated on: Tue Aug 18 16:14:49 2015
 *
 */

#ifndef __SAMPENC_H__
#define __SAMPENC_H__
/* Include files */
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "mwmathutil.h"

#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "blascompat32.h"
#include "rtwtypes.h"
#include "sampenc_types.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern void sampenc(const emxArray_real_T *y, real_T M, real_T r, emxArray_real_T *e, emxArray_real_T *A, emxArray_real_T *B);
#endif
/* End of code generation (sampenc.h) */
