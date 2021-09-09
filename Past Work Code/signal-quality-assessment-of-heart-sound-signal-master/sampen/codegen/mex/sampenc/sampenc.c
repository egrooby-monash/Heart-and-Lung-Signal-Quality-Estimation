/*
 * sampenc.c
 *
 * Code generation for function 'sampenc'
 *
 * C source code generated on: Tue Aug 18 16:14:49 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "sampenc.h"
#include "sampenc_emxutil.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 16, "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m" };
static emlrtRSInfo b_emlrtRSI = { 47, "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m" };
static emlrtRSInfo c_emlrtRSI = { 48, "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m" };
static emlrtRSInfo d_emlrtRSI = { 13, "rdivide", "C:/Program Files/MATLAB/R2011b/toolbox/eml/lib/matlab/ops/rdivide.m" };
static emlrtRSInfo f_emlrtRSI = { 14, "log", "C:/Program Files/MATLAB/R2011b/toolbox/eml/lib/matlab/elfun/log.m" };
static emlrtRSInfo g_emlrtRSI = { 20, "eml_error", "C:/Program Files/MATLAB/R2011b/toolbox/eml/lib/matlab/eml/eml_error.m" };
static emlrtMCInfo emlrtMCI = { 20, 19, "eml_error", "C:/Program Files/MATLAB/R2011b/toolbox/eml/lib/matlab/eml/eml_error.m" };
static emlrtMCInfo b_emlrtMCI = { 20, 5, "eml_error", "C:/Program Files/MATLAB/R2011b/toolbox/eml/lib/matlab/eml/eml_error.m" };
static emlrtRTEInfo emlrtRTEI = { 1, 18, "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m" };
static emlrtRTEInfo b_emlrtRTEI = { 17, 1, "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m" };
static emlrtRTEInfo c_emlrtRTEI = { 18, 1, "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m" };
static emlrtRTEInfo d_emlrtRTEI = { 21, 1, "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m" };
static emlrtBCInfo emlrtBCI = { -1, -1, 19, 27, "", "log", "C:/Program Files/MATLAB/R2011b/toolbox/eml/lib/matlab/elfun/log.m", 0 };
static emlrtECInfo emlrtECI = { 1, 16, 9, "eml_div", "C:/Program Files/MATLAB/R2011b/toolbox/eml/lib/matlab/eml/eml_div.m" };
static emlrtECInfo b_emlrtECI = { -1, 46, 6, "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m" };
static emlrtBCInfo b_emlrtBCI = { -1, -1, 46, 6, "B", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtBCInfo c_emlrtBCI = { -1, -1, 46, 6, "B", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtBCInfo d_emlrtBCI = { -1, -1, 30, 19, "run", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtBCInfo e_emlrtBCI = { -1, -1, 25, 7, "y", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtDCInfo emlrtDCI = { 19, 9, "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 1 };
static emlrtDCInfo b_emlrtDCI = { 19, 9, "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 4 };
static emlrtDCInfo c_emlrtDCI = { 19, 9, "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 1 };
static emlrtDCInfo d_emlrtDCI = { 19, 9, "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 4 };
static emlrtBCInfo f_emlrtBCI = { -1, -1, 19, 5, "", "log", "C:/Program Files/MATLAB/R2011b/toolbox/eml/lib/matlab/elfun/log.m", 0 };
static emlrtBCInfo g_emlrtBCI = { -1, -1, 13, 12, "", "log", "C:/Program Files/MATLAB/R2011b/toolbox/eml/lib/matlab/elfun/log.m", 0 };
static emlrtBCInfo h_emlrtBCI = { -1, -1, 42, 7, "lastrun", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtBCInfo i_emlrtBCI = { -1, -1, 42, 18, "run", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtBCInfo j_emlrtBCI = { -1, -1, 28, 14, "y", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtBCInfo k_emlrtBCI = { -1, -1, 38, 10, "run", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtBCInfo l_emlrtBCI = { -1, -1, 29, 10, "run", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtBCInfo m_emlrtBCI = { -1, -1, 29, 18, "lastrun", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtBCInfo n_emlrtBCI = { -1, -1, 32, 13, "A", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtBCInfo o_emlrtBCI = { -1, -1, 32, 18, "A", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtBCInfo p_emlrtBCI = { -1, -1, 34, 16, "B", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };
static emlrtBCInfo q_emlrtBCI = { -1, -1, 34, 21, "B", "sampenc", "C:/Users/sedm3697/Dropbox/DPhil/Matlab/Final_Matlab_Code/Signal Quality/Signal Quality Features/sampen/sampenc.m", 0 };

/* Function Declarations */
static void eml_error(void);
static void error(const mxArray *b, emlrtMCInfo *location);
static const mxArray *message(const mxArray *b, emlrtMCInfo *location);

/* Function Definitions */

/*
 * 
 */
static void eml_error(void)
{
    const mxArray *y;
    static const int32_T iv0[2] = { 1, 29 };
    const mxArray *m0;
    static const char_T cv0[29] = { 'C', 'o', 'd', 'e', 'r', ':', 't', 'o', 'o', 'l', 'b', 'o', 'x', ':', 'l', 'o', 'g', '_', 'd', 'o', 'm', 'a', 'i', 'n', 'E', 'r', 'r', 'o', 'r' };
    EMLRTPUSHRTSTACK(&g_emlrtRSI);
    y = NULL;
    m0 = mxCreateCharArray(2, iv0);
    emlrtInitCharArray(29, m0, cv0);
    emlrtAssign(&y, m0);
    error(message(y, &emlrtMCI), &b_emlrtMCI);
    EMLRTPOPRTSTACK(&g_emlrtRSI);
}

static void error(const mxArray *b, emlrtMCInfo *location)
{
    const mxArray *pArray;
    pArray = b;
    emlrtCallMATLAB(0, NULL, 1, &pArray, "error", TRUE, location);
}

static const mxArray *message(const mxArray *b, emlrtMCInfo *location)
{
    const mxArray *pArray;
    const mxArray *m2;
    pArray = b;
    return emlrtCallMATLAB(1, &m2, 1, &pArray, "message", TRUE, location);
}

/*
 * function [e,A,B]=sampenc(y,M,r)
 */
void sampenc(const emxArray_real_T *y, real_T M, real_T r, emxArray_real_T *e, emxArray_real_T *A, emxArray_real_T *B)
{
    emxArray_real_T *lastrun;
    int32_T nj;
    int32_T unnamed_idx_1;
    emxArray_real_T *run;
    int32_T jj;
    int32_T j;
    real_T M1;
    int32_T m;
    emxArray_int32_T *r0;
    emxArray_int32_T *r1;
    emxArray_real_T *b_y;
    emxArray_real_T *p;
    int32_T b_A[1];
    int32_T b_B[1];
    emlrtHeapReferenceStackEnterFcn();
    emxInit_real_T(&lastrun, 2, &b_emlrtRTEI, TRUE);
    /* function [e,A,B]=sampenc(y,M,r); */
    /*  */
    /* Input */
    /*  */
    /* y input data */
    /* M maximum template length */
    /* r matching tolerance */
    /*  */
    /* Output */
    /*  */
    /* e sample entropy estimates for m=0,1,...,M-1 */
    /* A number of matches for m=1,...,M */
    /* B number of matches for m=0,...,M-1 excluding last point */
    /* 'sampenc:16' n=length(y); */
    EMLRTPUSHRTSTACK(&emlrtRSI);
    EMLRTPOPRTSTACK(&emlrtRSI);
    /* 'sampenc:17' lastrun=zeros(1,n); */
    nj = lastrun->size[0] * lastrun->size[1];
    lastrun->size[0] = 1;
    emxEnsureCapacity((emxArray__common *)lastrun, nj, (int32_T)sizeof(real_T), &emlrtRTEI);
    unnamed_idx_1 = y->size[0];
    nj = lastrun->size[0] * lastrun->size[1];
    lastrun->size[1] = unnamed_idx_1;
    emxEnsureCapacity((emxArray__common *)lastrun, nj, (int32_T)sizeof(real_T), &emlrtRTEI);
    unnamed_idx_1 = y->size[0] - 1;
    for (nj = 0; nj <= unnamed_idx_1; nj++) {
        lastrun->data[nj] = 0.0;
    }
    emxInit_real_T(&run, 2, &c_emlrtRTEI, TRUE);
    /* 'sampenc:18' run=zeros(1,n); */
    nj = run->size[0] * run->size[1];
    run->size[0] = 1;
    emxEnsureCapacity((emxArray__common *)run, nj, (int32_T)sizeof(real_T), &emlrtRTEI);
    unnamed_idx_1 = y->size[0];
    nj = run->size[0] * run->size[1];
    run->size[1] = unnamed_idx_1;
    emxEnsureCapacity((emxArray__common *)run, nj, (int32_T)sizeof(real_T), &emlrtRTEI);
    unnamed_idx_1 = y->size[0] - 1;
    for (nj = 0; nj <= unnamed_idx_1; nj++) {
        run->data[nj] = 0.0;
    }
    /* 'sampenc:19' A=zeros(M,1); */
    nj = A->size[0];
    A->size[0] = (int32_T)emlrtIntegerCheckR2009b(emlrtNonNegativeCheckR2009b(M, &b_emlrtDCI), &emlrtDCI);
    emxEnsureCapacity((emxArray__common *)A, nj, (int32_T)sizeof(real_T), &emlrtRTEI);
    unnamed_idx_1 = (int32_T)emlrtIntegerCheckR2009b(emlrtNonNegativeCheckR2009b(M, &d_emlrtDCI), &c_emlrtDCI) - 1;
    for (nj = 0; nj <= unnamed_idx_1; nj++) {
        A->data[nj] = 0.0;
    }
    /* 'sampenc:20' B=zeros(M,1); */
    nj = B->size[0];
    B->size[0] = (int32_T)M;
    emxEnsureCapacity((emxArray__common *)B, nj, (int32_T)sizeof(real_T), &emlrtRTEI);
    unnamed_idx_1 = (int32_T)M - 1;
    for (nj = 0; nj <= unnamed_idx_1; nj++) {
        B->data[nj] = 0.0;
    }
    /* 'sampenc:21' p=zeros(M,1); */
    /* 'sampenc:22' e=zeros(M,1); */
    /* 'sampenc:23' for i=1:(n-1) */
    unnamed_idx_1 = 0;
    while (unnamed_idx_1 <= y->size[0] - 2) {
        /* 'sampenc:24' nj=n-i; */
        nj = (y->size[0] - unnamed_idx_1) - 2;
        /* 'sampenc:25' y1=y(i); */
        emlrtDynamicBoundsCheck((int32_T)(1.0 + (real_T)unnamed_idx_1), 1, y->size[0], &e_emlrtBCI);
        /* 'sampenc:26' for jj=1:nj */
        jj = 0;
        while (jj <= nj) {
            /* 'sampenc:27' j=jj+i; */
            j = (jj + unnamed_idx_1) + 2;
            /* 'sampenc:28' if abs(y(j)-y1)<r */
            M1 = y->data[emlrtDynamicBoundsCheck(j, 1, y->size[0], &j_emlrtBCI) - 1] - y->data[unnamed_idx_1];
            if (muDoubleScalarAbs(M1) < r) {
                /* 'sampenc:29' run(jj)=lastrun(jj)+1; */
                run->data[emlrtDynamicBoundsCheck(jj + 1, 1, run->size[1], &l_emlrtBCI) - 1] = lastrun->data[emlrtDynamicBoundsCheck(jj + 1, 1, lastrun->size[1], &m_emlrtBCI) - 1] + 1.0;
                /* 'sampenc:30' M1=min(M,run(jj)); */
                emlrtDynamicBoundsCheck((int32_T)(1.0 + (real_T)jj), 1, run->size[1], &d_emlrtBCI);
                M1 = muDoubleScalarMin(M, run->data[jj]);
                /* 'sampenc:31' for m=1:M1 */
                m = 0;
                while (m <= (int32_T)M1 - 1) {
                    /* 'sampenc:32' A(m)=A(m)+1; */
                    A->data[emlrtDynamicBoundsCheck((int32_T)(1.0 + (real_T)m), 1, A->size[0], &n_emlrtBCI) - 1] = A->data[emlrtDynamicBoundsCheck((int32_T)(1.0 + (real_T)m), 1, A->size[0], &o_emlrtBCI) - 1] + 1.0;
                    /* 'sampenc:33' if j<n */
                    if (j < y->size[0]) {
                        /* 'sampenc:34' B(m)=B(m)+1; */
                        B->data[emlrtDynamicBoundsCheck((int32_T)(1.0 + (real_T)m), 1, B->size[0], &p_emlrtBCI) - 1] = B->data[emlrtDynamicBoundsCheck((int32_T)(1.0 + (real_T)m), 1, B->size[0], &q_emlrtBCI) - 1] + 1.0;
                    }
                    m++;
                    emlrtBreakCheck();
                }
            } else {
                /* 'sampenc:37' else */
                /* 'sampenc:38' run(jj)=0; */
                run->data[emlrtDynamicBoundsCheck(jj + 1, 1, run->size[1], &k_emlrtBCI) - 1] = 0.0;
            }
            jj++;
            emlrtBreakCheck();
        }
        /* 'sampenc:41' for j=1:nj */
        j = 1;
        while (j - 1 <= nj) {
            /* 'sampenc:42' lastrun(j)=run(j); */
            lastrun->data[emlrtDynamicBoundsCheck(j, 1, lastrun->size[1], &h_emlrtBCI) - 1] = run->data[emlrtDynamicBoundsCheck(j, 1, run->size[1], &i_emlrtBCI) - 1];
            j++;
            emlrtBreakCheck();
        }
        unnamed_idx_1++;
        emlrtBreakCheck();
    }
    emxFree_real_T(&run);
    emxFree_real_T(&lastrun);
    /* 'sampenc:45' N=n*(n-1)/2; */
    /* 'sampenc:46' B=[N;B(1:(M-1))]; */
    if (1.0 > M - 1.0) {
        nj = 0;
    } else {
        emlrtDynamicBoundsCheck(1, 1, B->size[0], &c_emlrtBCI);
        nj = emlrtDynamicBoundsCheck((int32_T)(M - 1.0), 1, B->size[0], &b_emlrtBCI);
    }
    b_emxInit_int32_T(&r0, 1, &emlrtRTEI, TRUE);
    unnamed_idx_1 = r0->size[0];
    r0->size[0] = nj;
    emxEnsureCapacity((emxArray__common *)r0, unnamed_idx_1, (int32_T)sizeof(int32_T), &emlrtRTEI);
    unnamed_idx_1 = nj - 1;
    for (nj = 0; nj <= unnamed_idx_1; nj++) {
        r0->data[nj] = 1 + nj;
    }
    emxInit_int32_T(&r1, 2, &emlrtRTEI, TRUE);
    nj = r1->size[0] * r1->size[1];
    r1->size[0] = 1;
    emxEnsureCapacity((emxArray__common *)r1, nj, (int32_T)sizeof(int32_T), &emlrtRTEI);
    unnamed_idx_1 = r0->size[0];
    nj = r1->size[0] * r1->size[1];
    r1->size[1] = unnamed_idx_1;
    emxEnsureCapacity((emxArray__common *)r1, nj, (int32_T)sizeof(int32_T), &emlrtRTEI);
    unnamed_idx_1 = r0->size[0] - 1;
    for (nj = 0; nj <= unnamed_idx_1; nj++) {
        r1->data[nj] = r0->data[nj];
    }
    emxFree_int32_T(&r0);
    b_emxInit_real_T(&b_y, 1, &emlrtRTEI, TRUE);
    emlrtVectorVectorIndexCheck(B->size[0], 1, 1, r1->size[1], &b_emlrtECI);
    nj = b_y->size[0];
    b_y->size[0] = 1 + r1->size[1];
    emxEnsureCapacity((emxArray__common *)b_y, nj, (int32_T)sizeof(real_T), &emlrtRTEI);
    b_y->data[0] = (real_T)y->size[0] * ((real_T)y->size[0] - 1.0) / 2.0;
    unnamed_idx_1 = r1->size[1] - 1;
    for (nj = 0; nj <= unnamed_idx_1; nj++) {
        b_y->data[nj + 1] = B->data[r1->data[nj] - 1];
    }
    emxFree_int32_T(&r1);
    nj = B->size[0];
    B->size[0] = b_y->size[0];
    emxEnsureCapacity((emxArray__common *)B, nj, (int32_T)sizeof(real_T), &emlrtRTEI);
    unnamed_idx_1 = b_y->size[0] - 1;
    for (nj = 0; nj <= unnamed_idx_1; nj++) {
        B->data[nj] = b_y->data[nj];
    }
    emxFree_real_T(&b_y);
    b_emxInit_real_T(&p, 1, &d_emlrtRTEI, TRUE);
    /* 'sampenc:47' p=A./B; */
    EMLRTPUSHRTSTACK(&b_emlrtRSI);
    EMLRTPUSHRTSTACK(&d_emlrtRSI);
    b_A[0] = A->size[0];
    b_B[0] = B->size[0];
    emlrtSizeEqCheckND(b_A, b_B, &emlrtECI);
    nj = p->size[0];
    p->size[0] = A->size[0];
    emxEnsureCapacity((emxArray__common *)p, nj, (int32_T)sizeof(real_T), &emlrtRTEI);
    unnamed_idx_1 = A->size[0] - 1;
    for (nj = 0; nj <= unnamed_idx_1; nj++) {
        p->data[nj] = A->data[nj] / B->data[nj];
    }
    EMLRTPOPRTSTACK(&d_emlrtRSI);
    EMLRTPOPRTSTACK(&b_emlrtRSI);
    /* 'sampenc:48' e=-log(p); */
    EMLRTPUSHRTSTACK(&c_emlrtRSI);
    nj = e->size[0];
    e->size[0] = p->size[0];
    emxEnsureCapacity((emxArray__common *)e, nj, (int32_T)sizeof(real_T), &emlrtRTEI);
    unnamed_idx_1 = p->size[0] - 1;
    for (nj = 0; nj <= unnamed_idx_1; nj++) {
        e->data[nj] = p->data[nj];
    }
    for (unnamed_idx_1 = 0; unnamed_idx_1 <= p->size[0] - 1; unnamed_idx_1++) {
        if (p->data[emlrtDynamicBoundsCheck(unnamed_idx_1 + 1, 1, p->size[0], &g_emlrtBCI) - 1] < 0.0) {
            EMLRTPUSHRTSTACK(&f_emlrtRSI);
            eml_error();
            EMLRTPOPRTSTACK(&f_emlrtRSI);
        }
    }
    for (unnamed_idx_1 = 0; unnamed_idx_1 <= p->size[0] - 1; unnamed_idx_1++) {
        emlrtDynamicBoundsCheck((int32_T)(1.0 + (real_T)unnamed_idx_1), 1, e->size[0], &emlrtBCI);
        e->data[emlrtDynamicBoundsCheck(1 + unnamed_idx_1, 1, e->size[0], &f_emlrtBCI) - 1] = muDoubleScalarLog(e->data[unnamed_idx_1]);
    }
    emxFree_real_T(&p);
    nj = e->size[0];
    emxEnsureCapacity((emxArray__common *)e, nj, (int32_T)sizeof(real_T), &emlrtRTEI);
    unnamed_idx_1 = e->size[0] - 1;
    for (nj = 0; nj <= unnamed_idx_1; nj++) {
        e->data[nj] = -e->data[nj];
    }
    EMLRTPOPRTSTACK(&c_emlrtRSI);
    emlrtHeapReferenceStackLeaveFcn();
}
/* End of code generation (sampenc.c) */
