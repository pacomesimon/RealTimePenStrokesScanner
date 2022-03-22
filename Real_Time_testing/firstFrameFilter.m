
function [outputIm outputIm_Cropped rowCr1 rowCr2 colCr1 colCr2]=firstFrameFilter(inputIm,cropFactor)


% inputIm_Enhanced=2*(inputIm);
inputIm_Enhanced_Gray=rgb2gray(2*(inputIm));
t=254/255;
inputIm_Binary=imbinarize(inputIm_Enhanced_Gray,t);

[rows cols]=size(inputIm_Binary);

meanCOLS=mean(inputIm_Binary);
maxOfMeanCOLS=max(meanCOLS);
theCOL=1;

theTHRES=maxOfMeanCOLS * cropFactor;
for n=1:1:cols
    if meanCOLS(n) >= theTHRES
        theCOL=n;
        break
    end
end

colCr1=theCOL;

for n=cols:-1:1
    if meanCOLS(n) >= theTHRES
        theCOL=n;
        break
    end
end

colCr2=theCOL;

meanROWS=mean((inputIm_Binary)');
maxOfMeanROWS=max(meanROWS);
theROW=1;
theTHRES=maxOfMeanROWS * cropFactor;
for n=1:1:rows
    if meanROWS(n) >= theTHRES
        theROW=n;
        break
    end
end

 rowCr1=theROW;
 
 for n=rows:-1:1
    if meanROWS(n) >= theTHRES
        theROW=n;
        break
    end
end

 rowCr2=theROW;
 
 outputIm=inputIm;
 outputIm_Cropped=outputIm(rowCr1:rowCr2,colCr1:colCr2,:);
 global LP_filter_PS N_smoothing Erosion_se N_erosion Dilution_se N_dilution;
 outputIm_Cropped=firstImageEnhancer(outputIm_Cropped,LP_filter_PS,N_smoothing,Erosion_se,N_erosion,Dilution_se,N_dilution);
% % % outputIm=                 firstImageEnhancer(inputIm,LP_filter_PS,N_smoothing,Erosion_se,N_erosion,Dilution_se,N_dilution)
 outputIm(rowCr1:rowCr2,colCr1:colCr2,:)=outputIm_Cropped;
 
 
 
end