% Date : 2016-06-14
% Tested on MATLAB 2015a
% Author  : Nanduni Nimalsiri
% Face detection using Neural Networks and Gabor Features and Gabor Feature Extraction

clear all;
close all;
clc;

if ~exist('main.m')
    fprintf ('You must navigate to the folder which contains main.m\n');
    fprintf ('Use dir command to make sure you are in the correct folder.\n');
    fprintf ('Use  cd command to navigate to the folder.\n');
    return;
end

if ~exist('./data/gabor.mat','file')    
    run ('include/createGabor.m');
end
if ~exist('./data/net.mat','file')
    run ('include/menuCreateNetwork.m');
end
if ~exist('./data/imgdb.mat','file')
    run ('include/menuLoadImages.m');
end

run ('include/menuTrainNetwork.m');
run ('include/menuScanImage.m');






