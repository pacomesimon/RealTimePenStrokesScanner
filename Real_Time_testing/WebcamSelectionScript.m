
webcamIndex=menu('Choose Your Webcam',webcamlist);
if webcamIndex<=0, webcamIndex=1;end
listOfWebCamsAvailable = webcamlist;
global camName;
camName=listOfWebCamsAvailable{webcamIndex};
global cam;
cam = 3;
cam=webcam(camName);
% cam.AvailableResolutions
% cam.Resolution = '3840x2160';

resolutionIndex=menu('Choose a resolution',cam.AvailableResolutions);
if resolutionIndex<=0, resolutionIndex=1;end
listOfResolutionsAvailable = cam.AvailableResolutions;
global camName;
cam.Resolution=listOfResolutionsAvailable{resolutionIndex};

myPreviewer = menu('PREVIEW THE CAMERA INPUT ?','YES','NO');

if (myPreviewer == 1)
    
    global camp;
    camp = cam;
    myImag=snapshot(camp);
    global ax;
    imshow(myImag,'Parent',ax)

    for n=0:1:10
        try
            myImag=snapshot(camp);
            imshow(myImag,'Parent',ax);
            ax.Title.String = strcat("PREVIEW: (remaining Frames: approximately " , string((10-n))," frames)");
            pause(0.5)
        catch e
            break
        end
    end

end


% cam =3; 