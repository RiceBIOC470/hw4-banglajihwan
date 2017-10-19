function img_out = img_cleanup (img, radius, mim_area) 

%img_out= imdilate(img_1, stre1('disk', radius));
cell_prop = regionprops (img, 'Area', 'Centroid', 'PixelIdxList', 'Image') 

ids = find([cell_prop.Area]<300)
%imshow(cell_prop(ids(1)).Image);
%disp(length(ids));
for i = 1:length(ids)
   img(cell_prop(ids(i)).PixelIdxList) = false; 
end 
%img_out = imerode(img, strel('disk', radius-1)); 
img_out = imclose(img, strel('disk', radius));
%figure
%imshow(img_out); 
