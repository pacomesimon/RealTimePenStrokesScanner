
# Import everything needed to edit video clips
from moviepy.editor import *
  
   
# loading video dsa gfg intro video
clip = VideoFileClip("myVideo.avi")
  
  
# getting only first 8 seconds
clip = clip.subclip(0, 10)
  
# loading audio file
audioclip = AudioFileClip("myAudio.wav").subclip(0, 10)
  
# adding audio to the video clip
videoclip = clip.set_audio(audioclip)
  
# showing video clip
# videoclip.ipython_display()
videoclip.write_videofile("myVidAud.webm",fps=25)