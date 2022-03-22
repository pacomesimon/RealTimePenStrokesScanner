totalNumberOfFrames=3*11;
OutputFrameRate=3;
framePeriod=1/OutputFrameRate;

clear('cam')
% cam=webcam('HP Truevision HD');
webcamIndex=menu('Choose Your Webcam',webcamlist)
webcamlist;
pause(3)


% preview(cam);

images = cell(totalNumberOfFrames,1);

imshow(zeros(100,100));
recObj = audiorecorder;
cam=webcam(ans{webcamIndex});
%preview(cam)
disp('Start speaking.')
record(recObj);
tic;
images{1}=snapshot(cam);
imshow(images{1})

for u=2:totalNumberOfFrames
    captureDelay=toc;
    pause(framePeriod-captureDelay)
    images{u}=snapshot(cam);
    tic;
    imshow(images{u})
end


disp('End of Recording.');
stop(recObj);
clear('cam')



miAudioSamplingFreq = recObj.SampleRate;

miAudioData = getaudiodata(recObj);

miAudioFileName='myAudio.wav';
audiowrite(miAudioFileName,miAudioData,miAudioSamplingFreq);

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
command = 'py vidAudMixer.py'; [status,cmdout] = system(command)
 