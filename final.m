function varargout = final(varargin)
% FINAL MATLAB code for final.fig
%      FINAL, by itself, creates a new FINAL or raises the existing
%      singleton*.
%
%      H = FINAL returns the handle to a new FINAL or the handle to
%      the existing singleton*.
%
%      FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL.M with the given input arguments.
%
%      FINAL('Property','Value',...) creates a new FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final

% Last Modified by GUIDE v2.5 22-Aug-2021 22:12:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_OpeningFcn, ...
                   'gui_OutputFcn',  @final_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before final is made visible.
function final_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final (see VARARGIN)

% Choose default command line output for final
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in select_image.
function select_image_Callback(hObject, eventdata, handles)
global img
% get image
% [filename, pathname]=uigetfile({'*.bmp;*.jpg;*.jpeg;*.tif;*.png;','IMAGE FILES (*.bmp,*.jpg,*.jpeg,*.tif,*.png)'},'Choose an image');
% img=imread(filename);

[filename, pathname] = uigetfile({'*.bmp;*.jpg;*.jpeg;*.tif;*.png;','IMAGE FILES (*.bmp,*.jpg,*.jpeg,*.tif,*.png)'},'Choose an image');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       filename=strcat(pathname,filename);
       img=imread(filename);
       % show image in the GUI axes
       axes(handles.axes1);
       imshow(img);
    end


% --- Executes on button press in resize_image.
function resize_image_Callback(hObject, eventdata, handles)
global img
global img_resized
[row col channel] = size(img);
img_resized = imresize(img,[300 300]); % Need to change the size of the resize

% Displaying the image
axes(handles.axes2);
imshow(img_resized);
title('Resized Image(300*300)');

handles.ResizedImage = img_resized;
guidata(hObject,handles);

% --- Executes on button press in filter_image.
function filter_image_Callback(hObject, eventdata, handles)
global img_resized


facedetector=vision.CascadeObjectDetector;

facebox = facedetector(img_resized);

if(sum(sum(facebox))~=0) % if face detected
        img_resized=imcrop(img_resized,facebox(1, :)); % crop detected face
        img_resized=imresize(img_resized,[128 128]); % resize image
        %fullFileName = fullfile('mask weared', strcat(num2str,'.jpeg'));
        %imwrite(img_resized,fullFileName);   % Save image
        axes(handles.axes3);
        imshow(img_resized);
        title('Face Croped');
end

% Im = im2bw(img_resized);
Im = rgb2gray(img_resized);
% K = wiener2(Im,[5 5]);
K = medfilt3(Im);
axes(handles.axes4);
imshow(Im);
title('Image filtered');


% handles.ResizedImage = Im;
img_resized = K;

% --- Executes on button press in train_image.
function train_image_Callback(hObject, eventdata, handles)
%% Trainig an Image
global img_resized
im = img_resized;
c=input('Enter the Class(Number from 1-4)');
%% Feature Extraction
F=FeatureStatistical(im);
% ndims(im)
try c
    load DB;
    F=[F c];
    DB=[DB; F];
    save DB.mat DB 
catch 
%     size(F,1)
%     size(c,1)
%       F
%       c
%     ndims(F)
%     ndims(c)
    DB=[F c]; % 10 12 1 % m s c
    save DB.mat DB 
end


% --- Executes on button press in test_image.
function test_image_Callback(hObject, eventdata, handles)
%% Test Image
% clc;
% clear all;
% close all;
% [fname, path]=uigetfile('.jpeg','provide an Image for testing');
% fname=strcat(path, fname);
% im=imread(fname);
% im=im2bw(im);
% imshow(im);
% title('Test Image');
% %% Find the class the test image belongs
% Ftest=FeatureStatistical(im);
% % Compare with the feature of training image in the database
% load DB.mat
% Ftrain=DB(:,1:2);
% Ctrain=DB(:,3);
% for (i=1:size(Ftrain,1));
%     dist(i,:)=sum(abs(Ftrain(i,:)-Ftest));
% end   
% m=find(dist==min(dist),1);
% det_class=Ctrain(m);
% msgbox(strcat('Detected Class=',num2str(det_class)));


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load DB.mat
global img_resized
im = img_resized
Ftest=FeatureStatistical(im);
% Compare with the feature of training image in the database

Ftrain=DB(:,1:2);
Ctrain=DB(:,3);
for (i=1:size(Ftrain,1));
    dist(i,:)=sum(abs(Ftrain(i,:)-Ftest));
end   
m=find(dist==min(dist),1);
det_class=Ctrain(m);
% msgbox(strcat('Detected Class=',num2str(det_class)));

if det_class == 1
    helpdlg(' Mask weared ');
    disp('Mask weared');
elseif det_class == 2
    helpdlg(' Mask not weared ');
    disp(' Mask not weared ');
elseif det_class == 3
    helpdlg(' Mask weared not properly ');
    disp('Mask weared not properly');
elseif det_class == 4
    helpdlg(' Mask weared not properly ');
    disp('Mask weared not properly');
else
    helpdlg('Unable to recognize');
    disp('Unable to recognize');
end



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
close all;
