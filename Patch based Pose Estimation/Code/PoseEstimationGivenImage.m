function info=PoseEstimationGivenImage(im, faceCoords)


%% Initialization
Fx='RBF9D'; % the size of the RBF function e.g. RBF5D, RBF9D, RBF17D
NPatch=100; % the number of the patches in the grid.  Keep it fixed at 10x10 grid i.e. NPatch=100
sd=45;      % standard deviation of the RBF functions,  can try 11.25,45 or 90.

%load the library
load('Mat Data\libraryFaceDetector240Preproc2Auto.mat','library');
sdiv=0.5; % standard deviation for mapping to the library.  Keep this fixed at 0.5 to be consistent with training

%% Image alignment and preprocessing
im1 = alignPointsGivenImage(im,faceCoords);

%preprocess
im2=preprocess2Im(im1);


%divide to patches
rt=divideToPatches(im2,sqrt(NPatch));


%% Estimate Pose
%find where maps to the library
libMap=findLogProbMap(rt,library,sdiv);

%Estimate pose for this image
estPose=testRegressionGivenImageManyRatings(libMap,Fx,NPatch,sd);


%Store the predictions
info.box=faceCoords;
info.boxIm=im1;
info.pose=estPose;


