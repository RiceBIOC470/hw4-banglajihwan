function bw_img = autotresh(img) 

level = graythresh(img); 
bw_img = im2bw(img, level); 
