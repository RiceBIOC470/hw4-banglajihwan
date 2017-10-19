function xmask = rand_mask (N)

img_1point = false(1024);

for i = 1:20 
    img_1point (randi(1024), randi(1024)) = true; 
    
end 
xmask = imdilate(img_1point, strel('disk', N));

end 
