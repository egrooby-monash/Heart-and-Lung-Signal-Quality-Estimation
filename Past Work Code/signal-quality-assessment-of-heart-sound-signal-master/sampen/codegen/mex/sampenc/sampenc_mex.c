/*
 * sampenc_mex.c
 *
 * Code generation for function 'sampenc'
 *
 * C source code generated on: Tue Aug 18 16:14:49 2015
 *
 */

/* Include files */
#include "mex.h"
#include "sampenc_api.h"
#include "sampenc_initialize.h"
#include "sampenc_terminate.h"

/* Type Definitions */

/* Function Declarations */
static void sampenc_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

/* Variable Definitions */
emlrtContext emlrtContextGlobal = { true, false, EMLRT_VERSION_INFO, NULL, "sampenc", NULL, false, NULL, false, 1, false };

/* Function Definitions */
static void sampenc_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Temporary copy for mex outputs. */
  mxArray *outputs[3];
  int n = 0;
  int nOutputs = (nlhs < 1 ? 1 : nlhs);
  /* Check for proper number of arguments. */
  if(nrhs != 3) {
    mexErrMsgIdAndTxt("emlcoder:emlmex:WrongNumberOfInputs","3 inputs required for entry-point 'sampenc'.");
  } else if(nlhs > 3) {
    mexErrMsgIdAndTxt("emlcoder:emlmex:TooManyOutputArguments","Too many output arguments for entry-point 'sampenc'.");
  }
  /* Module initialization. */
  sampenc_initialize(&emlrtContextGlobal);
  /* Call the function. */
  sampenc_api(prhs,(const mxArray**)outputs);
  /* Copy over outputs to the caller. */
  for (n = 0; n < nOutputs; ++n) {
    plhs[n] = emlrtReturnArrayR2009a(outputs[n]);
  }
  /* Module finalization. */
  sampenc_terminate();
}
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Initialize the memory manager. */
  mexAtExit(sampenc_atexit);
  emlrtClearAllocCount(&emlrtContextGlobal, 0, 0, NULL);
  /* Dispatch the entry-point. */
  sampenc_mexFunction(nlhs, plhs, nrhs, prhs);
}
/* End of code generation (sampenc_mex.c) */
