clc;
clear all;
close all;
[fname, path]=uigetfile('.jpg','provide an Image for testing');
fname=strcat(path, fname);
im=imread(fname);
% im=im2bw(im);
im=rgb2gray(im);
imshow(im);
title('Test Image');
%% Find the class the test image belongs
Ftest=FeatureStatistical(im);
% Compare with the feature of training image in the database
load db.mat
Ftrain=db(:,1:2);
Ctrain=db(:,3);
for (i=1:size(Ftrain,1));
    dist(i,:)=sum(abs(Ftrain(i,:)-Ftest));
end   
m=find(dist==min(dist),1);
det_class=Ctrain(m);
msgbox(strcat('Detected Class=',num2str(det_class)));