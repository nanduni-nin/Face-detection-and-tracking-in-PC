function estRateData=testRegressionGivenImageManyRatings(libMap,Fx,NPatch,sd)

%% Initialization
  
ratings=[-90:90]';% All possible poses you want to examin.  you can change it to have finer or coarser degree steps.
% at the moment it is set to be 1 degree apart.

classes=ratings;
switch Fx
    case 'x'
        allRates=ratings;
    case 'x1-x'
        allRates(:,1)=ratings;
        allRates(:,2)=ones(length(ratings),1)-ratings;
       
    case 'RBF9D'
        for(cR=1:length(ratings))
            allRates(cR,:)=getRBFKernel(ratings(cR),[-90:22.5:90],sd);
        end
    case 'RBF5D'
        for(cR=1:length(ratings))
            allRates(cR,:)=getRBFKernel(ratings(cR),[-90:45:90],sd);
        end
    case 'RBF17D'
        for(cR=1:length(ratings))
            allRates(cR,:)=getRBFKernel(ratings(cR),[-90:11.25:90],sd);
        end
        
end


nData=1;
%% verify
%for each data
for cData=1:nData

    %for each patch
    for cPatch=1:NPatch
        %get this libIndexZ
        libIndxZ=libMap(2*NPatch+cPatch,cData);
        
         %get learn weights for this patch
        load(['Code\Mat Data\Grid ' num2str(sqrt(NPatch)) 'x' num2str(sqrt(NPatch)) ' ' Fx 'sd ' num2str(sd) '\learnedWeights' num2str(cPatch) 'Function' Fx '.mat']);
      
        %find likelihood of each rating value
        thisPatchLike=findLikelihoodThisPatch(libIndxZ,w,allRates');
        
        %likelihoods(cData,cPatch,:)=thisPatchLike;
        likelihoods(cPatch,:)=thisPatchLike;
    end
    
    %overallLikeThisData=squeeze(sum(likelihoods(cData,:,:)));
    overallLikeThisData=squeeze(sum(likelihoods));
    
    estDataIndx=find(overallLikeThisData==max(overallLikeThisData));
    if(length(estDataIndx)>1)
        estRateData(cData)=mean(classes(estDataIndx))
    else
    estRateData(cData)=classes(estDataIndx);
    end
end


%save(['Mat Data\Grid ' num2str(sqrt(NPatch)) 'x' num2str(sqrt(NPatch)) ' ' Fx 'sd ' num2str(sd) '\TestResults' num2str(length(classes)) 'Steps' Fx '.mat'],'estRateData','ratings','classes')

