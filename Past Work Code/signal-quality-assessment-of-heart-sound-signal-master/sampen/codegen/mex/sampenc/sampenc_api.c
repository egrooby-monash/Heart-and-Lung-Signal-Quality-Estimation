/*
 * sampenc_api.c
 *
 * Code generation for function 'sampenc_api'
 *
 * C source code generated on: Tue Aug 18 16:14:49 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "sampenc.h"
#include "sampenc_api.h"
#include "sampenc_emxutil.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
static emlrtRTEInfo e_emlrtRTEI = { 1, 1, "sampenc_api", "" };

/* Function Declarations */
static void b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static real_T c_emlrt_marshallIn(const mxArray *M, const char_T *identifier);
static real_T d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier *parentId);
static void e_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static void emlrt_marshallIn(const mxArray *y, const char_T *identifier, emxArray_real_T *b_y);
static const mxArray *emlrt_marshallOut(emxArray_real_T *u);
static real_T f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *msgId);

/* Function Definitions */

static void b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
    e_emlrt_marshallIn(emlrtAlias(u), parentId, y);
    emlrtDestroyArray(&u);
}

static real_T c_emlrt_marshallIn(const mxArray *M, const char_T *identifier)
{
    real_T y;
    emlrtMsgIdentifier thisId;
    thisId.fIdentifier = identifier;
    thisId.fParent = NULL;
    y = d_emlrt_marshallIn(emlrtAlias(M), &thisId);
    emlrtDestroyArray(&M);
    return y;
}

static real_T d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier *parentId)
{
    real_T y;
    y = f_emlrt_marshallIn(emlrtAlias(u), parentId);
    emlrtDestroyArray(&u);
    return y;
}

static void e_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
    int32_T iv1[1];
    boolean_T bv0[1];
    int32_T i1;
    iv1[0] = 100000;
    bv0[0] = TRUE;
    emlrtCheckVsBuiltInCtxR2011b(&emlrtContextGlobal, msgId, src, "double", FALSE, 1U, iv1, bv0, ret->size);
    i1 = ret->size[0];
    emxEnsureCapacity((emxArray__common *)ret, i1, (int32_T)sizeof(real_T), (emlrtRTEInfo *)NULL);
    emlrtImportArrayR2011b(src, ret->data, 8, FALSE);
    emlrtDestroyArray(&src);
}

static void emlrt_marshallIn(const mxArray *y, const char_T *identifier, emxArray_real_T *b_y)
{
    emlrtMsgIdentifier thisId;
    thisId.fIdentifier = identifier;
    thisId.fParent = NULL;
    b_emlrt_marshallIn(emlrtAlias(y), &thisId, b_y);
    emlrtDestroyArray(&y);
}

static const mxArray *emlrt_marshallOut(emxArray_real_T *u)
{
    const mxArray *y;
    const mxArray *m1;
    real_T (*pData)[];
    int32_T i0;
    int32_T i;
    y = NULL;
    m1 = mxCreateNumericArray(1, u->size, mxDOUBLE_CLASS, mxREAL);
    pData = (real_T (*)[])mxGetPr(m1);
    i0 = 0;
    for (i = 0; i < u->size[0]; i++) {
        (*pData)[i0] = u->data[i];
        i0++;
    }
    emlrtAssign(&y, m1);
    return y;
}

static real_T f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *msgId)
{
    real_T ret;
    emlrtCheckBuiltInCtxR2011b(&emlrtContextGlobal, msgId, src, "double", FALSE, 0U, 0);
    ret = *(real_T *)mxGetData(src);
    emlrtDestroyArray(&src);
    return ret;
}

void sampenc_api(const mxArray * const prhs[3], const mxArray *plhs[3])
{
    emxArray_real_T *y;
    emxArray_real_T *e;
    emxArray_real_T *A;
    emxArray_real_T *B;
    real_T M;
    real_T r;
    emlrtHeapReferenceStackEnterFcn();
    b_emxInit_real_T(&y, 1, &e_emlrtRTEI, TRUE);
    b_emxInit_real_T(&e, 1, &e_emlrtRTEI, TRUE);
    b_emxInit_real_T(&A, 1, &e_emlrtRTEI, TRUE);
    b_emxInit_real_T(&B, 1, &e_emlrtRTEI, TRUE);
    /* Marshall function inputs */
    emlrt_marshallIn(emlrtAliasP(prhs[0]), "y", y);
    M = c_emlrt_marshallIn(emlrtAliasP(prhs[1]), "M");
    r = c_emlrt_marshallIn(emlrtAliasP(prhs[2]), "r");
    /* Invoke the target function */
    sampenc(y, M, r, e, A, B);
    /* Marshall function outputs */
    plhs[0] = emlrt_marshallOut(e);
    plhs[1] = emlrt_marshallOut(A);
    plhs[2] = emlrt_marshallOut(B);
    emxFree_real_T(&B);
    emxFree_real_T(&A);
    emxFree_real_T(&e);
    emxFree_real_T(&y);
    emlrtHeapReferenceStackLeaveFcn();
}
/* End of code generation (sampenc_api.c) */
