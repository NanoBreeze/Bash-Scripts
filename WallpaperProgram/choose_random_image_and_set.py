import os
from os import listdir
from os.path import isfile, join
import random 
file = open('hello.txt',"w") 
 
file.write('hello')
file.close() 


mypath = r"C:\Users\lcheng\Pictures\WallpaperProgram\Wallpapers"
onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]

fullpath =  r"C:\Users\lcheng\Pictures\WallpaperProgram\Wallpapers" + "\\" + random.choice(onlyfiles)
print(fullpath)

cmd = r"WallpaperChanger.exe " + fullpath

print(cmd)

os.system(cmd)
#os.system(r"wp.bat C:\Users\lcheng\Pictures\Wallpapers\hi.jpg")