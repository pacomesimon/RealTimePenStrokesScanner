
function [outim outimCropped rowCr1 rowCr2 colCr1 colCr2]=firstFrameFilter(inim,cropFactor)


inimENH=2*(inim);
inimGR=rgb2gray(inimENH);
%inimGR=histeq(inimGR);
t=254/255;
inimBIN=imbinarize(inimGR,t);


%outim=inimENH.*(abd3);
%omages{i-1}(2000,2000,:)=uint8(0);
%outim=inimBIN;%(1:r,1:c,:);


[rows cols]=size(inimBIN);

meanCOLS=mean(inimBIN);
maxOfMeanCOLS=max(meanCOLS);
theCOL=1;

%cropFactor=0.1;

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


meanROWS=mean((inimBIN)');
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
 

 thePaperPosition=inimBIN(rowCr1:rowCr2,colCr1:colCr2,:);
 thePaperPosition=imerode(thePaperPosition,ones(5));
 thePaperPosition=imdilate(thePaperPosition,ones(5));
 thePaperPosition=uint8(thePaperPosition);
 outim=inim;
 theArea=inim(rowCr1:rowCr2,colCr1:colCr2,:);
 theAreaENH=theArea*2;
 outim(rowCr1:rowCr2,colCr1:colCr2,:)=(theAreaENH.*thePaperPosition) + theArea;
 
 outimCropped=outim(rowCr1:rowCr2,colCr1:colCr2,:);
 
 
 
 
end