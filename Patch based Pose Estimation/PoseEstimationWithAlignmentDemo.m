function poseInfo=PoseEstimationWithAlignmentDemo

%******************** Disclaimer *****************************************
%*** This program is distributed in the hope that it will be useful, but
%*** WITHOUT ANY WARRANTY; without even the implied warranty of 
%*** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%*** Feel free to use this code for academic purposes.  Plase use the
%*** citation provided below.
%**************************************************************************

%**********************Citation***********************************
%
% J. Aghajanian and S.J.D. Prince, “Face pose estimation in uncontrolled
% environments”, BMVC, 2009
%
%**************************************************************************

%==========================================================================
%  This code performs patch-based continuous Pose estimation (-90:90 from
%  left to right YAW) given a face image and the outoput of a face detector (i.e. the coordinates of the face boundingbox)
%  This code also performs automatic alignment of the face for pitch. If your face images are already cropped 
%  and aligned please call the other function PoseEstimationWithoutAlignmentDemo
%
%     Usage:
%        poseInfo=PoseEstimationWithAlignmentDemo
%
%     Requires:
%        faceCoords :  A variable containing the coordinates of the
%        bounding box around the face in the following format:
%        - A 4 by 1 vector containing the X and Y coordinates of
%        the center of the bounding box, radius and 
%        orientation of the bounding box respectively.  
%
%     Output:
%     - PoseInfo: a structure array containing the following fields:
%         -box: The coordinates of the face bounding box detected by the face detector
%         -boxIm: The 60x60 cropped face image
%         -pose: an integer containing the predicted pose: 'Male' or 'Female'
%         
%==========================================================================
%% Initialization
% add the Code folder to the Matlab search path
addpath('Code');
addpath('Code\Mat Data');
addpath('Code\Mat Data\Grid 10x10 RBF9Dsd 45')

%define the directory containing test images
dataDir='Data\';

%% Read an image
%read the image:  You can try with differenert images in the Data folder
%Example image names: '23291_8.7', '01485_7.2','09688_9.4','02760_8.1','04785_5.6','00015_7.5', 
%'00019_8.8', '00188_8.5', '00214_9.4' ,'00233_8'
imName='01485_7.2';
im=imread([dataDir imName '.jpg']);
%read the face detector bounding box coordinates
load([dataDir imName '.mat'],'faceCoords');

%% Estimate pose
poseInfo=PoseEstimationGivenImage(im, faceCoords);

%% display the result
drawFaceImage(poseInfo,im)


%=======================================================================
function drawFaceImage(poseInfo,im)

%create figure and set size to full screen
screenSize = get(0,'ScreenSize');
figure; set(gcf,'Position',screenSize);

%show the original image
subplot(1,3,1);hold off; imagesc(im);hold on;axis off; axis image;
title('Detected Bounding Box');
%plot the bounding box
faceCoords=poseInfo.box;
corners= getFaceCorners(faceCoords);
% plot(corners(1,1),corners(2,1),'r.');
% plot(corners(1,2),corners(2,2),'g.');
% plot(corners(1,3),corners(2,3),'b.');
% plot(corners(1,4),corners(2,4),'m.');

plot(corners(1,1:2),corners(2,1:2),'y')
plot(corners(1,3:4),corners(2,3:4),'y')
plot(corners(1,2:3),corners(2,2:3),'y')
plot([corners(1,1),corners(1,4)],[corners(2,1),corners(2,4)],'y')

%show the cropped image
subplot(1,3,2); hold off; imagesc(poseInfo.boxIm); axis image; axis off; drawnow;
title('Aligned Face Image');
%show the original image with predicted gender
subplot(1,3,3);imshow(im);hold on;
title('Predicted Pose');
textX=corners(1,2)+(corners(1,3)-corners(1,2))/2;
textY=corners(2,2)-30;
estPose=poseInfo.pose;
text(textX,textY,...
    ['Estimated pose: ' num2str(estPose)],...
    'HorizontalAlignment','center',...
    'BackgroundColor',[.5 .4 .9]);


%===================================================================

function corners= getFaceCorners(faceCoords)

cX = faceCoords(1);
cY = faceCoords(2);
r = faceCoords(3);
or = faceCoords(4)*pi/180;
x = cX+0.5*[-r -r r r -r]*cos(or)+0.5*[r -r -r r r]*sin(or);
y = cY+0.5*[-r -r r r -r]*-sin(or)+0.5*[r -r -r r r]*cos(or);

corners(1,:)=x(1:4);
corners(2,:)=y(1:4);