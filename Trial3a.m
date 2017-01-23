clear all, clc;
cam=ipcam('http://192.168.1.100:8080/','','')
image(snapshot(cam));
c=ginput(4);
close all;
FocusTable=zeros(2,4);
FocusTable(1,1)=uint32(c(5));
FocusTable(2,1)=uint32(c(1));
FocusTable(1,2)=uint32(c(6));
FocusTable(2,2)=uint32(c(2));
FocusTable(1,3)=uint32(c(7));
FocusTable(2,3)=uint32(c(3));
FocusTable(1,4)=uint32(c(8));
FocusTable(2,4)=uint32(c(4));