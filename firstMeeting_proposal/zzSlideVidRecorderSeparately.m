totalNumberOfFrames=3*11;
OutputFrameRate=2;
framePeriod=1/OutputFrameRate;


 % create the video writer with 1 fps
 writerObj = VideoWriter('myVideo.avi');
 writerObj.FrameRate = OutputFrameRate;
 writerObj.Quality = 25 ; % 75/100 !!!
 % set the seconds per image
 secsPerImage = 1;
 % open the video writer
 open(writerObj);
 % write the frames to the video
 for u=1:length(images)
     % convert the image to a frame
     % images{u}=cat(3,images{u},images{u},images{u});
     frame = im2frame(images{u});
     %for v=0:secsPerImage 
         writeVideo(writerObj, frame);
     %end
 end
 % close the writer object
 close(writerObj);