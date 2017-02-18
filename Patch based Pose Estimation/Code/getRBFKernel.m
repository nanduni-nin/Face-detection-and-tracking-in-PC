function rbf=getRBFKernel(x,r,sd);

%sd=22.5;
for(i=1:length(r))
    thisR=r(i);
    rbf(i)=gaussianRBF(x,thisR,sd);
end

