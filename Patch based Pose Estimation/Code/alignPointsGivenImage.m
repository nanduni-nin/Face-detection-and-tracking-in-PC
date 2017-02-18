function imNew = alignPointsGivenImage(im,faceCoords)

%==========================================================================
%  Performing Euclidean warp to align images to a 60x60 template
%
%     Usage:
%        imNew = alignPointsGivenImage(im,faceCoords);
%
%     Inputs:
%     - im: an image containing one or more faces
%     - faceCords is a 4 by N matrix where N is the number of faces found by the face detector.
%       each column faceCords is a 4 x1 vector containing center X coordinate, center Y
%       cooridnate, radius and orientation of the center point.  
%
%     Output:
%     - imNew: 
%==========================================================================


%close any previous figures
close all;

%definitions
MAX_FACES_PER_IMAGE = 6;
N_NON_FACE_PER_FRAME = 2;
outSize = [60];
nFeatures=4;


%figure; set(gcf,'Color',[1 1 1]);

nFace=0;
[imY imX dummy] = size(im);
imOrig = im;
imYBorder = ceil(imY/4);
imXBorder = ceil(imX/4);
im = cat(1,127*ones(ceil(imY/4),imX,3),im,127*ones(ceil(imY/4),imX,3));[imY imX dummy] = size(im);
im = cat(2,127*ones(imY,ceil(imX/4),3),im,127*ones(imY,ceil(imX/4),3));[imY imX dummy] = size(im);
%subplot(1,3,1);hold off; imagesc(im);hold on;axis off; axis image;
allFaceCorners = [];

%EXTRACT FACES
for (cFace = 1:MAX_FACES_PER_IMAGE)
    
    if ~(sum(sum(faceCoords==-1)))
        corners = getFaceCorners(faceCoords);
        corners(1,:)=corners(1,:)+imXBorder;
        corners(2,:)=corners(2,:)+imYBorder;
        
        corners=[corners(:,2:end) corners(:,1)];
        
%         plot(corners(1,1),corners(2,1),'r.');
%         plot(corners(1,2),corners(2,2),'g.');
%         plot(corners(1,3),corners(2,3),'b.');
%         plot(corners(1,4),corners(2,4),'m.');
%         
        pointsFrom = corners(:,1:3);
        if(inImage(corners,[imY imX]))
            windowSize = norm(corners(:,1)-corners(:,2));
            %reject if image is too small
            if (windowSize>=outSize(1))
                pointsTo = [1 outSize(1) outSize(1); 1 1 outSize(1)];
                T = maketform('affine',pointsFrom',pointsTo');
                imNew = imtransform(im,T,'XData',[1 outSize(1)],'YData',[1 outSize(1)]);
                %check if colour
                diffRG = double(imNew(:,:,1))-double(imNew(:,:,2));
                if (sum(abs(diffRG(:)))>outSize(1)*outSize(1)*5)
                    allFaceCorners = [allFaceCorners corners];
                    
                    
                    for (cOutSize = outSize)
                        if (windowSize>cOutSize)
                            pointsTo = [1 cOutSize cOutSize; 1 1 cOutSize];
                            T = maketform('affine',pointsFrom',pointsTo');
                            imNew = imtransform(im,T,'XData',[1 cOutSize],'YData',[1 cOutSize]);
                            %subplot(1,3,2); hold off; imagesc(imNew); axis image; axis off; drawnow;
                            % calculate new filename
                            %newFilename = [OutDir imName];
                            %imwrite(imNew,newFilename,'jpg');
                        end;
                    end;
                    
                end;
            end;
        end;
    end;
end;

if (~isempty(allFaceCorners))
    allFaceCorners = allFaceCorners-repmat([imXBorder;imYBorder],1,size(allFaceCorners,2));
    
    [imY imX dummy] = size(imOrig);
    imXBorder = ceil(imX/10);
    imYBorder = ceil(imY/10);
    allFaceCorners = allFaceCorners+repmat([imXBorder;imYBorder],1,size(allFaceCorners,2));
end; %end is empty



%==========================================================================

%check if corners are in image
function inState = inImage(corners,imSize);

goodPts = corners(1,:)>1 & corners(1,:)<=imSize(2) & corners(2,:)>1 & corners(2,:)<=imSize(1);
if sum(~goodPts(:))
    inState=0;
else;
    inState=1;
end;

%find face corners
function corners= getFaceCorners(faceCoords)

cX = faceCoords(1);
cY = faceCoords(2);
r = faceCoords(3);
or = faceCoords(4)*pi/180;
x = cX+0.5*[-r -r r r -r]*cos(or)+0.5*[r -r -r r r]*sin(or);
y = cY+0.5*[-r -r r r -r]*-sin(or)+0.5*[r -r -r r r]*cos(or);

corners(1,:)=x(1:4);
corners(2,:)=y(1:4);

