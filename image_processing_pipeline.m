%% Image Processing and Segmentation Pipeline
% This MATLAB script performs image pre-processing, channel extraction,
% segmentation, morphological operations, and overlay visualization.
% University FYP dissertation, University of Peshawar(SZIC)
% Author: Izharullah
% Date: 2014-10-15

clc; clear; close all;

%% STEP 1: Select and Read Image
%% this will upload in online MATLAB in browser. you have to upload images folder to see the results
[file, path] = uigetfile({'*.jpg;*.tif;*.png;*.gif','Image Files'}, 'Select an Image');

if isequal(file,0)
    disp('No file selected');
    return;
else
    % Read the selected image
    J = imread(fullfile(path, file));
    figure, imshow(J), title('Original Image');
end

%% STEP 2: Image Pre-processing
% Adjust image contrast using automatic stretch limits
I = imadjust(J, stretchlim(J));
figure, imshow(I), title('Contrast Adjusted Image');

%% STEP 3: Image Channelization
% Extract RGB channels individually
R = I(:,:,1); % Red channel
G = I(:,:,2); % Green channel
B = I(:,:,3); % Blue channel

figure, imshow(R), title('Red Channel');
figure, imshow(G), title('Green Channel');
figure, imshow(B), title('Blue Channel');

% Concatenate channels back to form RGB image
RGB = cat(3, R, G, B);
figure, imshow(RGB), title('Reconstructed RGB Image');

%% STEP 4: Image Segmentation
% Convert image to binary using thresholding
BW = imbinarize(rgb2gray(RGB), 0.95); % grayscale + threshold
figure, imshow(BW), title('Binary Image (Thresholded)');

% Apply median filter to remove noise
BW_med = medfilt2(BW, [3 3]);
figure, imshow(BW_med), title('Median Filter Applied');

%% STEP 5: Morphological Operations
% Erosion
se_erode = strel('disk', 24);
BW_eroded = imerode(BW_med, se_erode);
figure, imshow(BW_eroded), title('Eroded Image');

% Dilation
se_dilate = strel('line', 110, 200); 
BW_dilated = imdilate(BW_eroded, se_dilate);
figure, imshow(BW_dilated), title('Dilated Image');

% Closing to fill gaps
se_close = strel('disk', 18);
BW_closed = imclose(BW_dilated, se_close);
figure, imshow(BW_closed), title('Closed Image');

%% STEP 6: Overlay Boundaries on Original Image
% Find object perimeters
perim = bwperim(BW_closed);
figure, imshow(perim), title('Object Boundaries');

% Overlay boundaries on original image
overlay = imoverlay(I, BW_closed, [1 0 0]); % red overlay
figure, imshow(overlay), title('Overlay on Original Image');
