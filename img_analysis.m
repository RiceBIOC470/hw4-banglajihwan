function [cell_count, mean_area, mean_intense] = img_analysis (img_bw, img)
cell_prop = regionprops(img_bw, img, 'MeanIntensity', 'Area' )
cell_count = length([cell_prop.Area])
mean_intense = mean([cell_prop.MeanIntensity])
mean_area = mean([cell_prop.Area])

