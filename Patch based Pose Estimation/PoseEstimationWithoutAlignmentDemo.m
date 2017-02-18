function estPose=PoseEstimationWithoutAlignmentDemo()

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
%  left to right YAW ) given CROPPED and ALIGNED face image. 
%  If your face images are not cropped instead you have the original image and the output of a face detectorface 
%  please call the other function PoseEstimationWithAlignmentDemo
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


Fx='RBF9D'; % the size of the RBF function e.g. RBF5D, RBF9D, RBF17D
NPatch=100; % the number of the patches in the grid.  Keep it fixed at 10x10 grid i.e. NPatch=100
sd=45;      % standard deviation of the RBF functions,  can try 11.25,45 or 90.

%load the library
load('Code\Mat Data\libraryFaceDetector240Preproc2Auto.mat','library');
sdiv=0.5; % standard deviation for mapping to the library.  Keep this fixed at 0.5 to be consistent with training

%% read the image 
imDir='Data\Aligned Images\';

%read the image: You can try with differenert images in the 'Data\Aligned Images folder\'
%Example image names: '00010_7.jpg','00019_8.8.jpg','Aaron_Guiel_0001.jpg','Abdullah_al-Attiyah_0003.jpg'
im1=imread([imDir '00019_8.8.jpg']);
im1=imresize(im1,[60,60]);

%% Preprocessing
%preprocess
im2=preprocess2Im(im1);

%divide to patches
rt=divideToPatches(im2,sqrt(NPatch));


%% Pose estimation
%find where maps to the library
libMap=findLogProbMap(rt,library,sdiv);

%Estimate pose for this image
estPose=testRegressionGivenImageManyRatings(libMap,Fx,NPatch,sd);

%% Display the result
%display the image and the estimated pose
figure
imshow(im1,'InitialMagnification',200)
hold on
text(30,0,...
            ['Estimated pose: ' num2str(estPose)],...
            'HorizontalAlignment','center',...
            'BackgroundColor',[.7 .2 .5]);

