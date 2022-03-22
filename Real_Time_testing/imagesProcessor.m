
function outputIm=imagesProcessor(inputIm_Previous,inputIm,enhancement_multiplier,LP_filter_PS,N_smoothing,Erosion_se,N_erosion,Dilution_se,N_dilution,LP_filter_Hand)


[inputIm_Enhanced,PenStrokes_Mask] =imageEnhancer(inputIm,enhancement_multiplier,LP_filter_PS,N_smoothing,Erosion_se,N_erosion,Dilution_se,N_dilution);


    inputIm_Gray=rgb2gray(inputIm);
    inputIm_Gray(PenStrokes_Mask) = uint8(255);
    inputIm_Gray_Smoothed = imfilter(inputIm_Gray,LP_filter_Hand);
    inputIm_Gray_Smoothed_eq=histeq(inputIm_Gray_Smoothed);
    global obsThr;
    inputIm_MaskOfObstruction_Binary = imbinarize(inputIm_Gray_Smoothed_eq,obsThr); %0.5
    inputIm_MaskOfObstruction_Binary=uint8(inputIm_MaskOfObstruction_Binary);
% % % % % % %     Mask_RGB(:,:,1)=inputIm_MaskOfObstruction_Binary;
% % % % % % %     Mask_RGB(:,:,2)=inputIm_MaskOfObstruction_Binary;
% % % % % % %     Mask_RGB(:,:,3)=inputIm_MaskOfObstruction_Binary;
% % % % % % % 
% % % % % % % 
% % % % % % %     outputIm=inputIm_Enhanced.*(Mask_RGB);
% % % % % % %     outputIm=outputIm+uint8(~Mask_RGB).*inputIm_Previous;
% % % % % % %     
    outputIm=inputIm_Enhanced.*(inputIm_MaskOfObstruction_Binary);
    outputIm=outputIm+uint8(~inputIm_MaskOfObstruction_Binary).*inputIm_Previous;
    
%     display(rand)
    


end