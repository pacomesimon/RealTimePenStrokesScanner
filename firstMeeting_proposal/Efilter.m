
function outputIMAGE=Efilter(inputIMAGE,ENHmultiplier)

inputIMAGE=double(inputIMAGE);
inputMask = abs(inputIMAGE(:,:,1)-inputIMAGE(:,:,2)) + abs(inputIMAGE(:,:,2)-inputIMAGE(:,:,3)) + abs(inputIMAGE(:,:,1)-inputIMAGE(:,:,3));
inputMask = (inputMask < 50);

% average=(1/3)*(inputIMAGE(:,:,1)+inputIMAGE(:,:,2)+inputIMAGE(:,:,2));
% inputMask = abs(inputIMAGE(:,:,1)-average) + abs(inputIMAGE(:,:,2)-average) + abs(inputIMAGE(:,:,1)-average);


inimWHITE= inputMask.*inputIMAGE * ENHmultiplier;

inputIMAGE = uint8(~inputMask .* inputIMAGE);

inputIMAGE_HSV=rgb2hsv(inputIMAGE);
inputIMAGE_HSV(:,:,2)=inputIMAGE_HSV(:,:,2)*10;
inputIMAGE=hsv2rgb(inputIMAGE_HSV);

outputIMAGE= uint8(inimWHITE) + uint8(inputIMAGE*255);
end