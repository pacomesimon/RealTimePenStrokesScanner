function hsi_Approach(image)
inputIMAGE_HSV=rgb2hsv(image);
inputIMAGE_HSV(:,:,2)=inputIMAGE_HSV(:,:,2)*10;
inputIm=hsv2rgb(inputIMAGE_HSV);
end