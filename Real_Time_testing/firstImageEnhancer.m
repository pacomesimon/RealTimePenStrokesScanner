
function outputIm=firstImageEnhancer(inputIm,LP_filter_PS,N_smoothing,Erosion_se,N_erosion,Dilution_se,N_dilution)


inputIm_Smoothed_Gray=rgb2gray(inputIm);

for t=1:1:N_smoothing 
    inputIm_Smoothed_Gray = imfilter(inputIm_Smoothed_Gray,LP_filter_PS);
end

F=[1 1 1; 1 -8 1; 1 1 1] ;

inputIm_Edges=imfilter(inputIm_Smoothed_Gray,F);
inputIm_Edges = histeq(inputIm_Edges);
inputIm_MaskForPenStrokes = (inputIm_Edges < 250);
pattern = Erosion_se;

for t=1:1:N_erosion
    inputIm_MaskForPenStrokes=imerode(inputIm_MaskForPenStrokes,pattern);
end
pattern = Dilution_se;

for t=1:1:N_dilution
    inputIm_MaskForPenStrokes=imdilate(inputIm_MaskForPenStrokes,pattern);
end
inputIm_MaskForWhitepaper = inputIm_MaskForPenStrokes;
inputIm_MaskForPenStrokes = uint8(~inputIm_MaskForPenStrokes);

% % % % inputIm_WhiteArea= inputIm_MaskForPenStrokes.*inputIm * enhancement_multiplier;

inputIm = (inputIm_MaskForPenStrokes) .* inputIm;

inputIMAGE_HSV=rgb2hsv(inputIm);
inputIMAGE_HSV(:,:,2)=inputIMAGE_HSV(:,:,2)*100;
inputIm=hsv2rgb(inputIMAGE_HSV);

% % % % % % % % % % outputIm= (inputIm_WhiteArea) + uint8(inputIm*255);
outputIm= uint8(inputIm*255)+ (uint8(inputIm_MaskForWhitepaper)*255);;
% % % % PenStrokes_Mask = ~inputIm_MaskForPenStrokes;
end