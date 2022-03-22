function [outImage rowCr1 rowCr2 colCr1 colCr2]=whitePaperTrimmer(inim,cropFactor)
inimENH=2*(inim);
inimGR=rgb2gray(inimENH);
t=254/255;
inimBIN=imbinarize(inimGR,t);

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
 

 outImage=inim(rowCr1:rowCr2,colCr1:colCr2,:);
end
