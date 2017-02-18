function likelihood=findLikelihoodThisPatch(libIndxZ,w,allRates)

for(cRate=1:length(allRates))
   likelihood(cRate)=exp(w(libIndxZ,:)*allRates(:,cRate))/sum(exp(w*allRates(:,cRate)));
end

