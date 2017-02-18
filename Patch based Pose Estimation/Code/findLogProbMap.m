function libMap=findLogProbMap(image,library,sdiv)

% this function returns the log likelihood of this patch given a subset of
% the library as well as the [x y z] index of the library that best matches this patch.
%(note only an offset of the library is being used for each patch).


close all;

%initialize
[nPatch patchX patchY ]=size(image);
offset=2*patchX-1;
draw_prob_flag=0;
save_flag=0;
probMapSparse=zeros(nPatch,offset-patchX+1,offset-patchY+1,size(library,3));

%for each patch in this image
for(cPatch=1:nPatch)
    startX=floor(cPatch/sqrt(nPatch))+1;
    if(mod(cPatch,sqrt(nPatch))==0)startX=startX-1; end
    startY=mod(cPatch,sqrt(nPatch));
    if(startY==0)startY=sqrt(nPatch); end

    startRow=(startX-1)*patchX+1;
    startColumn=(startY-1)*patchY+1;

    endRow=startRow+offset-1;
    endColumn=startColumn+offset-1;

    if(endRow>size(library,1)) endRow=size(library,1); end
    if(endColumn>size(library,2)) endColumn=size(library,2); end
    
    thisPatch=squeeze(image(cPatch,:,:));
    thisLib=library(startRow:endRow,startColumn:endColumn,:);
    libVar=ones(size(thisLib))*sdiv;
    
    a=single(getLogLikelihood(thisPatch,thisLib,libVar));
    
    if(size(a,1)<(offset-patchX+1)) | ((size(a,2)<(offset-patchX+1)))
        [aX aY aZ]=size(a);
        patchprobMap(1:aX,1:aY,1:aZ)=a;
    else    
        patchprobMap=a;
    end
     maxima=findMaxima(patchprobMap);
     x(cPatch)=maxima.x;
     y(cPatch)=maxima.y;
     z(cPatch)=maxima.z;
     sc(cPatch)=maxima.score;
     
end

libMap=[x';y';z';sc'];





