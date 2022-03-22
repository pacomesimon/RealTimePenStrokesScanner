
function [outputIm,PenStrokes_Mask]=imageEnhancer(inputIm,enhancement_multiplier,LP_filter_PS,N_smoothing,Erosion_se,N_erosion,Dilution_se,N_dilution)


inputIm_Smoothed_Gray=rgb2gray(inputIm);

for t=1:1:N_smoothing 
    inputIm_Smoothed_Gray = imfilter(inputIm_Smoothed_Gray,LP_filter_PS);
end

F=[1 1 1; 1 -8 1; 1 1 1] ;

inputIm_Edges=imfilter(inputIm_Smoothed_Gray,F);
inputIm_Edges = histeq(inputIm_Edges);
global pensThr;
inputIm_MaskForPenStrokes = (inputIm_Edges < pensThr); %230
% pattern = Erosion_se;

% for t=1:1:N_erosion
%     inputIm_MaskForPenStrokes=imerode(inputIm_MaskForPenStrokes,pattern);
% end
pattern = Dilution_se;

for t=1:1:N_dilution
    inputIm_MaskForPenStrokes=imdilate(inputIm_MaskForPenStrokes,pattern);
end

inputIm_MaskForPenStrokes = uint8(inputIm_MaskForPenStrokes);

inputIm_WhiteArea= inputIm_MaskForPenStrokes.*inputIm * enhancement_multiplier;

PenStrokes_Mask = ~inputIm_MaskForPenStrokes;
inputIm = uint8(PenStrokes_Mask) .* inputIm;

inputIm_average = inputIm(:,:,1)/3+inputIm(:,:,2)/3+inputIm(:,:,3)/3;
penstrokes_Saturated = inputIm;
penstrokes_Saturated(:,:,1) = 255*uint8(inputIm(:,:,1) > inputIm_average);
penstrokes_Saturated(:,:,2) = 255*uint8(inputIm(:,:,2) > inputIm_average);
penstrokes_Saturated(:,:,3) = 255*uint8(inputIm(:,:,3) > inputIm_average);


% outputIm= (inputIm_WhiteArea) + uint8(inputIm*255);
outputIm= (inputIm_WhiteArea) + penstrokes_Saturated;

end