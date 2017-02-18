function rt=gaussian(x,m,sd)

k=1/(sd*sqrt(2*pi));

rt=k*exp(-((x-m)*(x-m))/(2*sd*sd));



