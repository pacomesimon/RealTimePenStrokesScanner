
# Import everything needed to edit video clips
import sys
from moviepy.editor import *
  
def myMixer(myFileName,startSec,stopSec):
	# loading video dsa gfg intro video
	clip = VideoFileClip("myVideo.avi")
	  
	  
	# getting only first 8 seconds
	clip = clip.subclip(startSec,stopSec)
	  
	# loading audio file
	audioclip = AudioFileClip("myAudio.wav").subclip(startSec,stopSec)
	  
	# adding audio to the video clip
	videoclip = clip.set_audio(audioclip)
	  
	# showing video clip
	# videoclip.ipython_display()
	myFinalName=myFileName+".webm"
	videoclip.write_videofile(myFinalName,fps=25)

if __name__ == "__main__":
    a = str(sys.argv[1])
    b = int(sys.argv[2])
    c = int(sys.argv[3])    
    myMixer(a, b, c)