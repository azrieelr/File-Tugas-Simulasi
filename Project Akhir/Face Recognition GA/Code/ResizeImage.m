% Resizes images to a size of 224x224, which AlexNet needs, and saves the resized images in a "Resized to 224x224" subfolder of the images folder.
% Image Analyst, March 21, 2020.
clc;    % Clear the command window.
fprintf('Beginning to run %s.m.\n', mfilename);
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 15;
% Specify the folder where the files live.
inputImagesFolder = 'D:\Download\archive\imgs_zip\imgs\Acura'; % Change it to whatever you need, if you want/need to.
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isfolder(inputImagesFolder)
	errorMessage = sprintf('Error: The following folder does not exist:\n\n%s\n\nPlease specify to an existing folder.', inputImagesFolder);
	uiwait(warndlg(errorMessage));
	% Try to find the highest level folder in that path that DOES exist.
	while ~isfolder(inputImagesFolder) && length(inputImagesFolder) > 3
		[inputImagesFolder, ~, ~] = fileparts(inputImagesFolder);
	end
	% Should have a good starting folder now.
	inputImagesFolder = uigetdir(inputImagesFolder);
	if inputImagesFolder == 0
		return;
	end
end
% Create output folder
outputImagesFolder = fullfile(inputImagesFolder, '/Resized to 100x100');
if ~isfolder(outputImagesFolder)
	mkdir(outputImagesFolder);
end
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(inputImagesFolder, '*.jpg'); % Change to whatever pattern you need.
theFiles = dir(filePattern)
numFiles = length(theFiles);
hFig = figure;
hFig.WindowState = 'maximized';
for k = 1 : numFiles
	% Get the input file name.
	baseFileName = theFiles(k).name;
	fullFileName = fullfile(inputImagesFolder, baseFileName);
	% Get the output file name.
	outputFullFileName = fullfile(outputImagesFolder, baseFileName);
	fprintf(1, 'Now reading %d of %d "%s"\n', k, numFiles, fullFileName);
	
	% Read in input image with imread().
	inputImage = imread(fullFileName);
	% Resize it.
	outputImage = imresize(inputImage, [200, 200]);
    outputImage1 = rgb2gray(outputImage);
	
	% Display input and output images.
	subplot(1, 2, 1);
	imshow(inputImage);  % Display image.
	caption = sprintf('Input image (%d of %d):\n"%s", %d by %d', k, numFiles, baseFileName, size(inputImage, 1), size(inputImage, 2));
	title(caption, 'FontSize', fontSize, 'Interpreter', 'none');
	subplot(1, 2, 2);
	imshow(outputImage1);  % Display image.
	caption = sprintf('Output image: "%s", %d by %d', baseFileName, size(outputImage1, 1), size(outputImage1, 2));
	title(caption, 'FontSize', fontSize, 'Interpreter', 'none');
	drawnow; % Force display to update immediately.
	
	% Write out the resized output file to the output folder.
	imwrite(outputImage1, outputFullFileName);
end
fprintf('Done running %s.m.\n', mfilename);
% Open the output folder in File Explorer.
winopen(outputImagesFolder);