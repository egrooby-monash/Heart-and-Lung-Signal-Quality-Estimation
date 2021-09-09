/* file: sampen.c	Doug Lake	2 August 2002
			Last revised:	6 January 2004 (by george@mit.edu)
-------------------------------------------------------------------------------
sampen: calculate Sample Entropy
Copyright (C) 2002 Doug Lake

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 59 Temple
Place - Suite 330, Boston, MA 02111-1307, USA.  You may also view the agreement
at http://www.fsf.org/copyleft/gpl.html.

You may contact the author via electronic mail (dlake@virginia.edu).  For
updates to this software, please visit PhysioNet (http://www.physionet.org/).

_______________________________________________________________________________

Compile this program using any standard C compiler, linking with the standard C
math library.  For example, if your compiler is gcc, use:
    gcc -o sampen -O sampen.c -lm

For brief instructions, use the '-h' option:
    sampen -h

Additional information is available at:
    http://www.physionet.org/physiotools/sampen/.

*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

float *readdata(char *filenm, int *filelen);
void sampen(float *y, int mm, float r, int n);
void sampen2(float *y, int mm, float r, int n);
void normalize(float *data, int n);
void help(void);

int main(int argc, char* argv[])
{
  float *data = NULL;
  float r = .2;
  int n, j, mm = 2;
  char *filenm=NULL;
  int nflag = 0;
  int vflag = 0;
  int i;

  for (i = 1; i < argc; i++)
    /* Read input and optional arguments. */
    {
      if(argv[i][0] == '-')
	{
	  switch(argv[i][1])
	    {
	    case 'h':
		help();
		exit(0);
		break;
	    case 'r':
	      if(argv[i][2] != '\0')
		{
		  fprintf(stderr, "sampen:  Unrecognized option '%s'\n", argv[i]);
		  help();
		  exit(1);
		}
	      if(i+1 < argc)
		{
		  i++;
		  r = atof(argv[i]);
		  break;
		}
	      fprintf(stderr, "sampen:  No value specified for option '-t'\n");
	      help();
	      exit(1);
	      break;
	    case 'm':
	      if(argv[i][2] != '\0')
                {
                  fprintf(stderr, "sampen:  Unrecognized option '%s'\n", argv[i]);
		  help();
                  exit(1);
                }
	      if(i+1 < argc)
		{
		  i++;
		  mm = atoi(argv[i]);
		  break;
		}
	      fprintf(stderr, "sampen:  No value specified for option '-t'\n");
	      help();
	      exit(1);
	      break;
	    case 'n':
	      if(argv[i][2] != '\0')
                {
                  fprintf(stderr, "sampen:  Unrecognized option '%s'\n", argv[i]);
		  help();
                  exit(1);
                }
	      nflag = 1;
	      break;
	    case 'v':
	      if(argv[i][2] != '\0')
         	{
		  fprintf(stderr, "sampen:  Unrecognized option '%s'\n", argv[i]);
		  help();
		  exit(1);
		}
	      vflag = 1;
	      break;
	    default:
	      fprintf(stderr, "sampen: Unrecognized option '%s'\n", argv[i]);
	      help();
	      exit(1);
	    }
	}
      else
	{
	  if(!filenm)
	    filenm = argv[i];
	  else	{ fprintf(stderr, "sampen:  Too many inputs\n"); exit(1); }
	}
    }
  if(!filenm)
	filenm = "-";	/* use the standard input if no input file specified */
  data=readdata(filenm, &n);
  if(mm > n/2)
  	{fprintf(stderr, "sampen:  m too large for time series of length %d\n", n); exit(1);}

  if(nflag)
    normalize(data, n);
  if(vflag)
    sampen2(data,mm,r,n);
  else
    sampen(data, mm, r, n);

  free(data);
  return 0;
}

float *readdata(char *filenm, int *filelen)
{
    FILE *ifile;
    long maxdat = 0L, npts = 0L;
    float *data = NULL, y, yp = 0.0;

    if (strcmp(filenm, "-") == 0) {
	filenm = "standard input";
	ifile = stdin;
    }
    else if ((ifile = fopen(filenm, "rt")) == NULL) {
      fprintf(stderr, "sampen:  Could not open %s \n", filenm);
      exit(1);
    }
	
    while (fscanf(ifile, "%f", &y) == 1) {
        if (++npts >= maxdat) {
	    float *s;

	    maxdat += 5000;	/* allow the input buffer to grow (the
				   increment is arbitrary) */
	    if ((s = realloc(data, maxdat * sizeof(float))) == NULL) {
		fprintf(stderr,
		   "sampen: insufficient memory, truncating input at row %d\n",
			npts);
	        break;
	    }
	    data = s;
	}
	data[npts] = y;
    }

    fclose(ifile);

    if (npts < 1) {
	fprintf(stderr, "sampen: %s contains no data\n", filenm);
	help();
	exit(1);
    }

    *filelen = npts;
    return (data);
}

void normalize(float *data, int n)
     /* subtracts the mean from data, then divides data by
	its variance. */
{
  int i;
  float mean = 0;
  float var = 0;
  for (i = 0; i < n; i++)
    mean += data[i];
  mean = mean/n;
  for (i = 0; i < n; i++)
    data[i] = data[i]-mean;
  for (i = 0; i <n; i++)
    var += data[i]*data[i];
  var = var/n;
  for (i = 0; i < n; i++)
    data[i] = data[i]/var;
}

void sampen2(float *y, int mm, float r, int n)
     /* calculates an estimate of sample entropy
	and the variance of the estimate. */
{
  float *p=NULL;
  float *v1=NULL, *v2=NULL, *s1=NULL, dv;
  int *R1=NULL, *R2=NULL,*F2=NULL, *F1=NULL, *F=NULL, FF;
  int *run=NULL, *run1=NULL;
  float  *A=NULL, *B=NULL;
  float *K=NULL, *n1=NULL, *n2=NULL;
  int MM;
  int m,m1,i,j,nj,jj,d,d2,i1,i2,dd;
  int  nm1, nm2, nm3, nm4;
  float y1;

  MM=2*mm;

  if ((run=(int*)calloc(n, sizeof(int)))==NULL)	exit(1);
  if ((run1=(int*)calloc(n, sizeof(int)))==NULL)	exit(1);
  if ((R1=(int*)calloc(n*MM, sizeof(int)))==NULL)	exit(1);
  if ((R2=(int*)calloc(n*MM, sizeof(int)))==NULL)	exit(1);
  if ((F=(int*)calloc(n*MM, sizeof(int)))==NULL)	exit(1);
  if ((F1=(int*)calloc(n*mm, sizeof(int)))==NULL)	exit(1);
  if ((F2=(int*)calloc(n*mm, sizeof(int)))==NULL)	exit(1);
  if ((K=(float*)calloc((mm+1)*mm, sizeof(float)))==NULL) exit(1);
  if ((A=(float*)calloc(mm, sizeof(float)))==NULL)	exit(1);
  if ((B=(float*)calloc(mm, sizeof(float)))==NULL)	exit(1);
  if ((p=(float*)calloc(mm, sizeof(float)))==NULL)	exit(1);
  if ((v1=(float*)calloc(mm, sizeof(float)))==NULL)	exit(1);
  if ((v2=(float*)calloc(mm, sizeof(float)))==NULL)	exit(1);
  if ((s1=(float*)calloc(mm, sizeof(float)))==NULL)	exit(1);
  if ((n1=(float*)calloc(mm, sizeof(float)))==NULL)	exit(1);
  if ((n2=(float*)calloc(mm, sizeof(float)))==NULL)	exit(1);

  for ( i=0; i<n-1; i++)
    {
      nj = n-i-1;
      y1=y[i];
      for ( jj=0; jj<nj; jj++)
	{
	  j=jj+i+1;
	  if (((y[j]-y1)<r)&& ((y1-y[j])<r))
	    {
	      run[jj]=run1[jj]+1;
	      m1= (mm<run[jj]) ? mm: run[jj];
	      for ( m=0; m<m1; m++)
		{
		  A[m]++;
		  if (j<n-1) B[m]++;
		  F1[i+m*n]++;   F[i+n*m]++;   F[j+n*m]++;
		}
	    }
	  else  run[jj] = 0;
	} /* for jj*/

      for (j=0; j<MM; j++)
	{
	  run1[j]=run[j];  R1[i+n*j]=run[j];

	}
      if (nj>MM-1)
	for (j=MM; j<nj; j++)   run1[j]=run[j];
    } /* for i*/

  for (i=1; i<MM; i++)
    for ( j=0; j<i-1; j++)
      R2[i+n*j] = R1[i-j-1+n*j];
  for (i=MM; i<n; i++)
    for (j=0; j<MM; j++)
      R2[i+n*j]=R1[i-j-1+n*j];
  for (i=0; i<n; i++)
    for (m=0; m<mm; m++)
      {
	FF = F[i+n*m];
	F2[i+n*m]=FF-F1[i+n*m];
	K[(mm+1)*m]+=FF*(FF-1);
      }

  for (m=mm-1; m > 0; m--)  B[m]=B[m-1];
  B[0]= (float)n*(n-1)/2;
  for (m=0; m<mm; m++)
    {
      p[m]=(float)A[m]/B[m];
      v2[m] = p[m]*(1-p[m])/B[m];
    }
  dd=1;
  for (m=0; m<mm; m++)
    {
      d2 = m+1<mm-1? m+1: mm-1;
      for (d=0; d<d2+1; d++)
	{
	  for (i1=d+1; i1<n; i1++)
	    {
	      i2 =i1-d-1;
	      nm1 = F1[i1+n*m];   nm3 = F1[i2+n*m];
	      nm2 = F2[i1+n*m];   nm4 = F2[i2+n*m];
	      for (j=0; j<(dd-1); j++)
		{
		  if (R1[i1+n*j] >=m+1)    nm1--;
		  if (R2[i1+n*j] >=m+1)    nm4--;
		}
	      for (j=0; j<2*(d+1); j++)
		if (R2[i1+n*j]>=m+1)   nm2--;
	      for (j=0; j<(2*d+1); j++)
		if (R1[i2+n*j] >=m+1)  nm3--;
	      K[d+1+(mm+1)*m]+=(float)2*(nm1+nm2)*(nm3+nm4);
	    }
	}
    }

  n1[0] = (float)n*(n-1)*(n-2);
  for (m=0; m<mm-1; m++)
    for (j=0; j<m+2; j++)
      n1[m+1]+=K[j+(mm+1)*m];
  for (m=0; m<mm; m++)
    {
      for (j=0; j<m+1; j++)  n2[m]+=K[j+(mm+1)*m];
    }

  for (m=0; m<mm; m++)
    {
      v1[m] =v2[m];
      dv = (n2[m]-n1[m]*p[m]*p[m])/(B[m]*B[m]);
      if (dv>0)   v1[m]+=dv;
      s1[m]=(float)sqrt((double)(v1[m]));
    }

  for (m=0; m<mm; m++)
    printf("SampEn(%d,%g,%d) = %f (standard deviation = %f)\n",
	   m+1, r, n, -log(p[m]), s1[m]);

  free(A);
  free(B);
  free(p);
  free(run);
  free(run1);
  free(s1);
  free(K);
  free(n1);
  free(R1);
  free(R2);
  free(v1);
  free(v2);
  free(F);
  free(F1);
  free(F2);

}

void sampen(float *y, int M, float r, int n)
     /* calculates an estimate of sample entropy but does NOT
   caclulate the variance of the estimate */
{
  float *p=NULL;
  float *e=NULL;
  long *run=NULL, *lastrun=NULL, N;
  float *A=NULL, *B=NULL;
  int M1, j, nj, jj, m;
  int i;
  float y1;

  if ((run=(long*)calloc(n, sizeof(long)))==NULL)	exit(1);
  if ((lastrun=(long*)calloc(n, sizeof(long)))==NULL)	exit(1);
  if ((A=(float*)calloc(M, sizeof(float)))==NULL)	exit(1);
  if ((B=(float*)calloc(M, sizeof(float)))==NULL)	exit(1);
  if ((p=(float*)calloc(M, sizeof(float)))==NULL)	exit(1);

  /*start running*/
  for ( i=0; i<n-1; i++)
    {
      nj = n-i-1;
      y1=y[i];
      for ( jj=0; jj<nj; jj++)
	{
	  j=jj+i+1;
	  if (((y[j]-y1)<r)&&((y1-y[j])<r))
	    {
	      run[jj]=lastrun[jj]+1;
	      M1= M<run[jj]? M: run[jj];
	      for ( m=0; m<M1; m++)
		{
		  A[m]++;
		  if (j<n-1) B[m]++;
		}
	    }
	  else  run[jj] = 0;
	} /* for jj*/
      for (j=0; j<nj; j++)  lastrun[j] = run[j];
    } /* for i*/

  N = (long)(n*(n-1)/2);
  p[0]=A[0]/N;

  printf("SampEn(1,%g,%d) = %f\n", r, n, -log(p[0]));
  for (m=1; m<M; m++) {
      p[m] = A[m] / B[m-1];
      printf("SampEn(%d,%g,%d) = %f\n", m+1, r, n, -log(p[m]));
  }

  free(A);
  free(B);
  free(p);
  free(run);
  free(lastrun);
}

static char *help_strings[] = {
 "usage: %s [OPTIONS ...] [TEXT-FILE]\n",
 "where OPTIONS may include:",
 " -h          print this usage summary",
 " -m M        set the maximum epoch length to M (default: 2)",
 " -n          normalize such that the mean of the input is 0 and the sample",
 "             variance is 1",
 " -r R        set the tolerance to R (default: 0.2)",
 " -v          output an estimate of the standard deviation of each SampEn",
 "TEXT-FILE should contain the time series (a column of decimal numbers);",
 "if omitted, sampen reads its standard input.  The output contains values of",
 "SampEn(k,r,N) where k is the epoch length, r is the tolerance, and N is the",
 "length of the input series.",
NULL
};

void help()
{
    int i;

    (void)fprintf(stderr, help_strings[0], "sampen");
    for (i = 1; help_strings[i] != NULL; i++)
	(void)fprintf(stderr, "%s\n", help_strings[i]);
}
