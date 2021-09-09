function y=movingAvgForwBack(s, K);

y=s(end:-1:1);
y=movingAvg(y, K/2);
y=movingAvg(y(end:-1:1), K/2);
