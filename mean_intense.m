function mean = mean_intense(img1, xmask)


cell_prop = regionprops(xmask, img1, 'MeanIntensity') 
mean = [cell_prop.MeanIntensity] 