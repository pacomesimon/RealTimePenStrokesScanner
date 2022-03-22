

rate1 = myRating(frameT1); 
rate2 = myRating(frameT2);
rate3 = myRating(frameT3); 
rate4 = myRating(frameT4); 
rate5 = myRating(frameT5); 
rate6 = myRating(frameT6); 
rate7 = myRating(frameT7); 
rate8 = myRating(frameT8);

rates=sort([rate1,rate2,rate3,rate4,rate5,rate6,rate7,rate8],'descend');
resolutions = sort([640*480,2560*1440,1920*1080,1280*960,3840*2160,960*540,640*360,1280*720]);

stem(resolutions/(10^6),rates)

function rate = myRating(frameT)
rate=[frameT,frameT(end)]-[frameT(1),frameT];
rate = 1./rate;
rate(isinf(rate))=[];
rate(1)=[];
rate = mean(rate);
% plot(rate)
end
