
function outPut=whitePaperProcessor(previousFrame,currentFrame,ENHENCEMENTmultiplier)


a=Efilter(currentFrame,ENHENCEMENTmultiplier);
ag=rgb2gray(a);
t=254/255;
ab=imbinarize(ag,t);
abd=imdilate(ab,ones(29));
abd=imerode(abd,ones(65));
abd=uint8(abd);

abd3(:,:,1)=abd;
abd3(:,:,2)=abd;
abd3(:,:,3)=abd;


outPut=a.*(abd3);

outPut=outPut+uint8(~abd3).*previousFrame;
end