function new_Approach(inputIm_Penstrokes_Unsaturated)
inputIm_average = inputIm_Penstrokes_Unsaturated(:,:,1)/3+inputIm_Penstrokes_Unsaturated(:,:,2)/3+inputIm_Penstrokes_Unsaturated(:,:,3)/3;
penstrokes_Saturated = inputIm_Penstrokes_Unsaturated;
penstrokes_Saturated(:,:,1) = 255*uint8(inputIm_Penstrokes_Unsaturated(:,:,1) > inputIm_average);
penstrokes_Saturated(:,:,2) = 255*uint8(inputIm_Penstrokes_Unsaturated(:,:,2) > inputIm_average);
penstrokes_Saturated(:,:,3) = 255*uint8(inputIm_Penstrokes_Unsaturated(:,:,3) > inputIm_average);
% imshow(penstrokes_Saturated)
end