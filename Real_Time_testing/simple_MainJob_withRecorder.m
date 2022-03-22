
global cam;
global fig;
fig = figure('Name','Final Year Project','KeyPressFcn',@closeFigure);
fig.WindowState='fullscreen';
%fig.WindowState='maximized';
fig.ToolBar='none';
fig.MenuBar='none';



images = cell(2,1);
global cropFactor;
global interFramesDelay;
global enhancement_multiplier;
global camp;
camp = 3;
global movement_sensitivity;

cropFactor=0.5;
interFramesDelay=0;
enhancement_multiplier=1.85;

global trigger frameNumber videoFrames frameTic framesIndex;
videoFrames = {};
frameTic = [];
trigger = true;
frameNumber = 0;
tic;

recObj = audiorecorder(8000,16,1);
disp('Start speaking.')
record(recObj);
frameNumber = frameNumber + 1;
frameTic(frameNumber) = toc;
videoFrames{frameNumber} = uint8(zeros(100,100,3));

global rowCr1 rowCr2 colCr1 colCr2;

while (trigger)

    images{1}=snapshot(cam);
    rawImage1_Uncropped = images{1};
    [outputIm images{1} rowCr1 rowCr2 colCr1 colCr2]=firstFrameFilter(images{1},cropFactor);
    
    global total_numberOfRows total_numberOfColumns
    total_numberOfRows=rowCr2 - rowCr1 + 1;
    total_numberOfColumns = colCr2 - colCr1 + 1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global LP_filter_PS
    theRowPeriod = ceil((0.3/100) * total_numberOfRows);
    theColPeriod = ceil((0.3/100) * total_numberOfColumns);
    LP_filter_PS = (1/(theColPeriod*theRowPeriod)) * ones(theRowPeriod,theColPeriod);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global Erosion_se Dilution_se
    theRowPeriod = ceil((0.1/100) * total_numberOfRows);
    theColPeriod = ceil((0.1/100) * total_numberOfColumns);
    Erosion_se = ones(theRowPeriod,theColPeriod);
    theRowPeriod = ceil((0.2/100) * total_numberOfRows);
    theColPeriod = ceil((0.2/100) * total_numberOfColumns);
    Dilution_se = ones(theRowPeriod,theColPeriod);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global LP_filter_Hand
    theRowPeriod = ceil((1.5/100) * total_numberOfRows);
    theColPeriod = ceil((1.5/100) * total_numberOfColumns);
    LP_filter_Hand = (1/(theColPeriod*theRowPeriod)) * ones(theRowPeriod,theColPeriod);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rawImage1 = rawImage1_Uncropped(rowCr1:rowCr2,colCr1:colCr2,:);
    cropCornerArea=uint16(5); % area cropped from the corner, in percentage;
    farthest_row = total_numberOfRows * cropCornerArea / 100 ;
    farthest_column = total_numberOfColumns * cropCornerArea / 100 ;
    cropCorner1{1}=rawImage1(1:farthest_row,1:farthest_column,:);
    cropCorner1{2}=rawImage1(1:farthest_row,end-farthest_column:end,:);
    cropCorner1{1}=rgb2gray(cropCorner1{1});
    cropCorner1{2}=rgb2gray(cropCorner1{2});
    Corner1{1}=histeq(cropCorner1{1});
    Corner1{2}=histeq(cropCorner1{2});
    Corner1{1}=imbinarize(Corner1{1},0.5);
    Corner1{2}=imbinarize(Corner1{2},0.5);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global N_smoothing Erosion_se N_erosion Dilution_se N_dilution
    N_smoothing = 1;
    N_erosion = 1;
    N_dilution = 1;
    images{1}=imagesProcessor(images{1},rawImage1,enhancement_multiplier,LP_filter_PS,N_smoothing,Erosion_se,N_erosion,Dilution_se,N_dilution,LP_filter_Hand);
    figure(fig)
    imshow(images{1});
    
    frameNumber = frameNumber + 1;
    frameTic(frameNumber) = toc;
    videoFrames{frameNumber} = images{1};
    
    hold on
    pause(interFramesDelay)

    checker=true;

    
    while (trigger)
        a=2-checker;
        b=checker+1;
        images{b}=snapshot(cam);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        rawImage2 = images{b}(rowCr1:rowCr2,colCr1:colCr2,:);
        cropCorner2{1}=rawImage2(1:farthest_row,1:farthest_column,:);
        cropCorner2{2}=rawImage2(1:farthest_row,end-farthest_column:end,:);
        cropCorner2{1}=rgb2gray(cropCorner2{1});
        cropCorner2{2}=rgb2gray(cropCorner2{2});
        Corner2{1}=histeq(cropCorner2{1});
        Corner2{2}=histeq(cropCorner2{2});
        Corner2{1}=imbinarize(Corner2{1},0.5);
        Corner2{2}=imbinarize(Corner2{2},0.5);
        xor_from_corner1=xor((Corner1{1}(:)),(Corner2{1}(:)));
        xor_from_corner2=xor((Corner1{2}(:)),(Corner2{2}(:)));

        sum_xor_from_corner1=sum(xor_from_corner1(:));
        sum_xor_from_corner2=sum(xor_from_corner2(:));

        ratio_xor_from_corner1 = sum_xor_from_corner1/length(xor_from_corner1);
        ratio_xor_from_corner2 = sum_xor_from_corner2/length(xor_from_corner2);
        
        movementDetector = ((ratio_xor_from_corner1 > movement_sensitivity) || (ratio_xor_from_corner2 > movement_sensitivity));
        if movementDetector == true
            figure(fig)
%             beep;
            imshow(0.8*images{a});
%             beep;
            
            frameNumber = frameNumber + 1;
            frameTic(frameNumber) = toc;
            videoFrames{frameNumber} = images{a}*0.9;
            beep;pause(1);beep;pause(2);
    
            break;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        images{b}=imagesProcessor(images{a},images{b}(rowCr1:rowCr2,colCr1:colCr2,:),enhancement_multiplier,LP_filter_PS,N_smoothing,Erosion_se,N_erosion,Dilution_se,N_dilution,LP_filter_Hand);
        figure(fig)
        imshow(images{b});
        
        frameNumber = frameNumber + 1;
        frameTic(frameNumber) = toc;
        videoFrames{frameNumber} = images{b};
        
        hold on
        pause(interFramesDelay)
        checker = ~(checker);
    end
end

stop(recObj);
disp('End of Recording.');



% function myprogress1
global trigger frameNumber videoFrames frameTic;
    figD = uifigure('Name','Processing the audio and the video ...');
    d = uiprogressdlg(figD,'Title','Please Wait',...
        'Message','Putting together needed data ...');
    %############################################################################################
    %#############################################################################
    %#####################################################
    d.Value = .11; 
    d.Message = 'Preparing Audio ...';
    pause(1)
    %#############################################################################
   
    miAudioSamplingFreq = recObj.SampleRate ;

    miAudioData = getaudiodata(recObj);

    miAudioFileName='myAudio.wav';
    audiowrite(miAudioFileName,miAudioData,miAudioSamplingFreq);
    
    %############################################################################################
    %#############################################################################
    %#####################################################
    d.Value = .33; 
    d.Message = 'Preparing Video (Separately) ...';
    %#############################################################################
    %%%%%%%%%%%%%%%%%%%%%%%%%%*******************
    global frameT;
    frameT =frameTic;
    frameTic = floor(10*frameTic)/10;

    theNeededRange=length(frameTic)-1;
    framesIndex = [];

    for k=1:1:theNeededRange
        frameReplications = uint64((frameTic(k+1)-frameTic(k))/0.2);
        framePlaceholders = k*ones(1,frameReplications);
        framesIndex=[framesIndex,framePlaceholders];
    end
    framesIndex=[framesIndex,theNeededRange+1];

    %%%%%%%%%%%%%%%%%%%%%********************************



     writerObj = VideoWriter('myVideo.avi');
     finalFramesNumber = size(framesIndex);
     OutputFrameRate=finalFramesNumber(2)/(frameT(end) - frameT(1));
     writerObj.FrameRate = OutputFrameRate;
     writerObj.Quality = 50 ; % 75/100 !!!

     % open the video writer
     open(writerObj);
     % write the frames to the video
     for u=framesIndex
         % convert the image to a frame
         % images{u}=cat(3,images{u},images{u},images{u});

         [ro co di]= size(videoFrames{u});
         if ro == co
            outu = videoFrames{u};
         elseif ro > co
            outu = padarray(videoFrames{u},[0 floor((ro - co)/2)],0,'both');
         else
            outu = padarray(videoFrames{u},[floor((co - ro)/2) 0],0,'both');
        end
         outu = imresize(outu, [720,720]);
         frame = im2frame(outu);
         %for v=0:secsPerImage 
             writeVideo(writerObj, frame);
         %end
     end
     % close the writer object
     close(writerObj);
    %############################################################################################
    %#############################################################################
    %#####################################################
    d.Value = .66; 
    d.Message = 'Combining Audio and Video into a single file';
    %#############################################################################
    miFileNameMi= datestr(now,'dd_mmmm_yyyy_HH_MM_SS_AM');
    miFileNameMi=strrep(miFileNameMi, ' ', '')
    command = "py vidAudMixerFX.py "; 
    command = command + miFileNameMi;
    command = command + " 0 ";
    spanNeeded = floor(frameT(end) - frameT(1)) - 1;
    command = command + string(spanNeeded);
    global finalchichi
    finalchichi =command;
    [status,cmdout] = system(command);
    if (status == 0)
        d.Value = 1;
        d.Message = "FINISHED! your final video file is named as: '"+ miFileNameMi +".webm' in the current directory.";
        pause(20)
    else
        d.Value = 1;
        d.Message = "FAILED! (Python related problems), anyway, your video and audio files are saved as 'myVideo.avi' and 'myAudio.wav' in the current directory.";
        pause(20)
    end

    % Close dialog box
    close(d)
    close(figD)
% end

% myprogress1;