clear all, clc;
A=arduino('COM3');
A.pinMode(3,'OUTPUT');
A.analogWrite(3,150);
pause(2);
cam=ipcam('http://192.168.1.100:8080/','','')
I=snapshot(cam);
image(I);
c=ginput(2);
FocusTable=zeros(2);
FocusTable(1,1)=uint32(c(3));
FocusTable(2,1)=uint32(c(1));
FocusTable(1,2)=uint32(c(4));
FocusTable(2,2)=uint32(c(2));
I(FocusTable(1,1)-4:FocusTable(1,1)+4,FocusTable(2,1)-4:FocusTable(2,1)+4,1)
I(FocusTable(1,2),FocusTable(2,2),1)