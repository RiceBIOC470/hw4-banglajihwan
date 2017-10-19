function img_out = smooth_substract(img, f_radius, f_sigma, b_radius)



img_sm = imfilter(img, fspecial('gaussian', f_radius, f_sigma));
img_bg = imopen(img_sm, strel('disk', b_radius)); 
img_sub = imsubtract (img_sm, img_bg); 
img_out = imsubtract (img_sm, img_bg);

%img_normsub= im2double(img_normsub); 
%img_smooth_substract_dil = imdilate(img_normsub, strel('disk', 200)); 
%img_out = img_normsub./img_smooth_substract_dil;

 