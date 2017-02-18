function [maxima]=findMaxima(patchprobMap)

%normalize the patchprobMap to be aprobability distribution
patchprobMap = patchprobMap-max(patchprobMap(:));
patchprobMap = exp(patchprobMap);
patchprobMap = patchprobMap/sum(patchprobMap(:));
    
%find the index of the maximum probability in the probMap
maximum=-realmin;
for(i=1:size(patchprobMap,3))
    thislayer=patchprobMap(:,:,i);
    if(max(thislayer(:))>maximum)
        [x,y]=find(thislayer==max(thislayer(:)));
        z=i;
        maximum=max(thislayer(:));
    end
end
x=x(1);
y=y(1);
z=z(1);

maxima.x=x;
maxima.y=y;
maxima.z=z;
maxima.score=patchprobMap(x,y,z);
%select the patch that best matches the library
%            bestPatch=library(startRow+x-1:startRow+x-1+5,startColumn+y-1:startColumn+y-1+5,z);





