clear all;

flag = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag == 1
    %%problem 1, stitch two images
    leftImageName = 'uttower_left.jpg';
    rightImageName = 'uttower_right.jpg';
    dataDir = fullfile('..','data');

    leftIm_rgb = imread(fullfile(dataDir, leftImageName));
    rightIm_rgb = imread(fullfile(dataDir, rightImageName));

    stitchedIm = stitch_pair(leftIm_rgb, rightIm_rgb, 1);
    figure; imshow(stitchedIm);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag == 2
     %%problem 2, stitch multiple images
     imageName1='1.JPG';
     imageName2='2.JPG';
     imageName3='3.JPG';
     dataDir = fullfile('..','data','ledge'); %hill, ledge, pier
     
     image1 = imread(fullfile(dataDir, imageName1));
     image2 = imread(fullfile(dataDir, imageName2));
     image3 = imread(fullfile(dataDir, imageName3));
     stitchedIm = stitch_multiple_pairs({image1,image2,image3});%takes and returns RGB composite image
     figure; imshow(stitchedIm);
end