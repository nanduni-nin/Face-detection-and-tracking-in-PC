function patchDataset=divideToPatches(data,patchNum)

%==========================================================================
%  This function breaks the image into nonoverlapping patches of specified size
%
%     Usage:
%        patchDataset=divideToPatches(data,patchNum)
%
%     Inputs:
%     - data: an image containing one or more faces
%     - patchNum is an integer specifying the resolutions of the patch grid. e.g.
%     patchNum=10 will break the image into a 10x10 regular grid.
%     Output:
%     - patchDataset: is the array containing all of the patches
%==========================================================================

%dimensions of the given images
[x y] = size(data);


%dimensions of the patch
nPatchX=x/patchNum;
nPatchY=y/patchNum;

patchDataset=zeros(patchNum*patchNum,nPatchX,nPatchY);


%divide each image into patches

pCount=0;
for (i=1:nPatchX:x)
    for(j=1:nPatchY:y)
        pCount=pCount+1;
        
        %collect this patch for all training samples
        p=data(i:i+nPatchX-1,j:j+nPatchY-1,:);
        patchDataset(pCount,:,:,:)=p;
    end
end



