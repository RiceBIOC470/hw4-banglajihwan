%HW4
%% 
% Problem 1. 

% 1. Write a function to generate an 8-bit image of size 1024x1024 with a random value 
% of the intensity in each pixel. Call your image rand8bit.tif. 
rand8bit.tif = randi([0,255], 1024);
imshow(rand8bit.tif); 

% 2. Write a function that takes an integer value as input and outputs a
% 1024x1024 binary image mask containing 20 circles of that size in random
% locations
xmask = rand_mask(5); % not really a circle, but a disk.  
imshow(xmask); 
% 3. Write a function that takes the image from (1) and the binary mask
% from (2) and returns a vector of mean intensities of each circle (hint: use regionprops).
mean_in = mean_intense(rand8bit.tif, xmask);
% 4. Plot the mean and standard deviation of the values in your output
% vector as a function of circle size. Explain your results. 

%%hold on 
for i = 1:50 
    xmaski = rand_mask(i);
        meani = mean_intense (rand8bit.tif, xmaski); 
        a = mean(meani);
        s = std(meani); 
        scatter(pi*i^2, a, 10, 'red', 'filled')
        scatter(pi*i^2, s, 10, 'blue', 'filled')
end 
hold off 
%%NOTE%% 
% as the size the circle increases, you capture the randomness better. The
% average pixel value should be around 255/2 which you see in the plot. 
% the standard deviation of the mean should become smaller because all the
% mean intesity goes towards the 255/2 value as the size increases. 

%Problem 2. Here is some data showing an NFKB reporter in ovarian cancer
%cells. 
%https://www.dropbox.com/sh/2dnyzq8800npke8/AABoG3TI6v7yTcL_bOnKTzyja?dl=0
%There are two files, each of which have multiple timepoints, z
%slices and channels. One channel marks the cell nuclei and the other
%contains the reporter which moves into the nucleus when the pathway is
%active. 

%
%Part 1. Use Fiji to import both data files, take maximum intensity
%projections in the z direction, concatentate the files, display both
%channels together with appropriate look up tables, and save the result as
%a movie in .avi format. Put comments in this file explaining the commands
%you used and save your .avi file in your repository (low quality ok for
%space). 
%%ANSWER%% 
%File -> Open 
%Click file that needs to open e.g. nfkb_movie1.tif
%Scroll through the z direction to get the brighest image e.g. last
%z-direction
%Image -> Color -> Stack to RGB %deselect slices
% Do the same after scrolling to second channel 
%Image -> Color -> Merge Channel 
% For red select first channel, For green, select second channel; 
% You will get a composite file. 
%Image -> Color -> Stack; do this for the composite image. 
%and save as AVI. No compression is required.



%Part 2. Perform the same operations as in part 1 but use MATLAB code. You don't
%need to save the result in your repository, just the code that produces
%it. 

file1 = 'nfkb_movie1.tif' 
reader = bfGetReader(file1); 
chan_1 = 1;
chan_2 = 2;
zplane = 6;

for i = 1:reader.getSizeT 
time = i
iplane_1 = reader.getIndex(zplane-1, chan_1-1,time-1) +1;
iplane_2 = reader.getIndex(zplane-1, chan_2-1,time-1) +1;
img_1 = bfGetPlane(reader, iplane_1);
img_2 = bfGetPlane (reader, iplane_2);
img2show = cat (3, imadjust(img_1), imadjust(img_2), zeros(size(img_1)));
%img2show_uint8 = uint8(img2show); 
imwrite(img2show, 'img_stack.tif', 'WriteMode', 'append');
end 


% for other image, just change the file1 = 'nfkb_movie2.tif' and repeat 

%%

% Problem 3. 
% Continue with the data from part 2
% 
% 1. Use your MATLAB code from Problem 2, Part 2  to generate a maximum
% intensity projection image of the first channel of the first time point
% of movie 1. 
img_cat = []
file1 = 'nfkb_movie1.tif' 
reader = bfGetReader(file1); 
chan_1 = 1;
time = 1;

for i = 1:6
 zplane = i
iplane_1 = reader.getIndex(zplane-1, chan_1-1,time-1) +1;

img_1 = bfGetPlane(reader, iplane_1);

img_cat = cat(3,img_cat, img_1);

end 
mip = max (img_cat, [], 3)% this gets the maximum pixel value in dimension 3 which the z-stacks are. 
imshow(mip, [200 1000]); 


% 2. Write a function which performs smoothing and background subtraction
% on an image and apply it to the image from (1). Any necessary parameters
% (e.g. smoothing radius) should be inputs to the function. Choose them
% appropriately when calling the function.
img_out = smooth_substract (mip, 4,2,50);
figure
imshow(mip, [400, 1000]); %for comparison 
imshow(img_out,[200, 800] );

% 3. Write  a function which automatically determines a threshold  and
% thresholds an image to make a binary mask. Apply this to your output
% image from 2. 

bw_img = autotresh(img_out); %this uses the ostu method of thresholding 
figure
imshow(bw_img); 

% 4. Write a function that "cleans up" this binary mask - i.e. no small
% dots, or holes in nuclei. It should line up as closely as possible with
% what you perceive to be the nuclei in your image. 
img_clean = img_cleanup (bw_img, 5, 300); %second input is the radius of imclose
imshow(img_clean) %some of the less brigher ones get excluded

% 5. Write a function that uses your image from (2) and your mask from 
% (4) to get a. the number of cells in the image. b. the mean area of the
% cells, and c. the mean intensity of the cells in channel 1. 

[cell_count, cell_area, cell_intensity] = img_analysis(img_clean, img_out); 

% 6. Apply your function from (2) to make a smoothed, background subtracted
% image from channel 2 that corresponds to the image we have been using
% from channel 1 (that is the max intensity projection from the same time point). Apply your
% function from 5 to get the mean intensity of the cells in this channel. 

file1 = 'nfkb_movie1.tif' 
reader = bfGetReader(file1); 
chan_2 = 2;
time = 1;
img_cat_2 = [ ];
for i = 1:6
iplane_2 = reader.getIndex(i-1, chan_2-1,time-1) +1;
img_2 = bfGetPlane(reader, iplane_2);
img_cat_2 = cat(3,img_cat_2, img_2);
end 
mip_2 = max (img_cat_2, [], 3);% this gets the maximum pixel value in dimension 3 which the z-stacks are. 
imshow(mip_2, [200 1000]); 
img_out_2 = smooth_substract (mip_2, 2,2,400); %smooth and background subtract; I used a loop to see which parameters worked the best;
% example %
%for i= 100:50:500
%img_out_2 = smooth_substract (mip_2, 4,2,i);
%bw_img_2 = autotresh(img_out_2);
%figure 
%imshow(bw_img_2); 
%end %
bw_img_2 = autotresh(img_out_2); %autothreshold;
imshow(img_out_2, [200 1000])
img_clean_2 = img_cleanup (bw_img_2, 1,200); %clean up 
imshow(img_clean_2);
[cell_count2, cell_area2, cell_intensity2] = img_analysis(img_clean_2, img_out_2);
%channel 2 is much more difficult to mask because there is a lot more
%overlap. 




%%
% Problem 4. 

% 1. Write a loop that calls your functions from Problem 3 to produce binary masks
% for every time point in the two movies. Save a movie of the binary masks.
% I will use channel 1 for this question. 

file1 = 'nfkb_movie1.tif' 
reader = bfGetReader(file1); 
chan_1 = 1;
img_cat = []
for i = 1:reader.getSizeT 
time = i
for j = 1:6 %creating MIP; 
 zplane = j
iplane_1 = reader.getIndex(zplane-1, chan_1-1,time-1) +1;
img_1 = bfGetPlane(reader, iplane_1);
img_cat = cat(3,img_cat, img_1);

end 
mip = max (img_cat, [], 3);% this gets the maximum pixel value in dimension 3 which the z-stacks are. 
%imshow(mip, [200 1000]);

img_out = smooth_substract (mip, 5,2,100);
bw_img = autotresh(img_out);
img_clean = img_cleanup (bw_img, 2, 300);
imwrite(img_clean, 'img_mask_1.tif', 'WriteMode', 'append');
end 

file2 = 'nfkb_movie1.tif' 
reader = bfGetReader(file2); 
chan_1 = 1;
img_cat = []
for i = 1:reader.getSizeT 
time = i
for j = 1:6 %creating MIP; 
 zplane = j
iplane_1 = reader.getIndex(zplane-1, chan_1-1,time-1) +1;
img_1 = bfGetPlane(reader, iplane_1);
img_cat = cat(3,img_cat, img_1);

end 
mip = max (img_cat, [], 3);% this gets the maximum pixel value in dimension 3 which the z-stacks are. 
%imshow(mip, [200 1000]);

img_out = smooth_substract (mip, 5,2,100);
bw_img = autotresh(img_out);
img_clean = img_cleanup (bw_img, 2, 300);
imwrite(img_clean, 'img_mask_2.tif', 'WriteMode', 'append');
end 

% 2. Use a loop to call your function from problem 3, part 5 on each one of
% these masks and the corresponding images and 
% get the number of cells and the mean intensities in both
% channels as a function of time. Make plots of these with time on the
% x-axis and either number of cells or intensity on the y-axis. 
file1 = 'nfkb_movie1.tif' 
reader = bfGetReader(file1); 
chan_1 = 1;
chan_2 = 2; %I need channel 2 for this question 
img_cat = []
img_cat_2 = []
channel_1 = []
channel_2 = []
for i = 1:reader.getSizeT 
time = i
for j = 1:6 %creating MIP; 
 zplane = j
iplane_1 = reader.getIndex(zplane-1, chan_1-1,time-1) +1;
iplane_2 = reader.getIndex(zplane-1, chan_2-1,time-1) +1;
img_1 = bfGetPlane(reader, iplane_1);
img_2 = bfGetPlane(reader, iplane_2);
img_cat = cat(3,img_cat, img_1);
img_cat_2 = cat(3, img_cat_2, img_2);

end 
mip = max (img_cat, [], 3);
mip_2= max (img_cat_2, [], 3);% this gets the maximum pixel value in dimension 3 which the z-stacks are. 
%imshow(mip, [200 1000]);

img_out = smooth_substract (mip, 5,2,100);
img_out_2 = smooth_substract (mip_2, 2,2,400);
bw_img = autotresh(img_out);
bw_img_2 = autotresh(img_out_2);
img_clean = img_cleanup (bw_img, 2, 300);
img_clean_2 = img_cleanup (bw_img_2, 1, 400);
%imwrite(img_clean, 'img_mask_1.tif', 'WriteMode', 'append');
[cell_count, cell_area, cell_intensity] = img_analysis(img_clean, img_out);
channel_1 = [channel_1; cell_count, cell_area, cell_intensity];
[cell_count2, cell_area2, cell_intensity2] = img_analysis(img_clean_2, img_out_2);
channel_2 = [channel_2; cell_count2, cell_area2, cell_intensity2];


end 

ax1 =subplot(2,1,1);
scatter (ax1,transpose(1:reader.getSizeT), channel_1(:,3), 10, 'red')

xlabel('time')
ylabel('mean intensity')
xlim([0 20])
ylim ([2000 3000])
ax2 = subplot(2,1,2);
scatter (ax2,transpose(1:reader.getSizeT), channel_2(:,3), 10, 'blue')
xlabel('time')
ylabel('mean intensity')
