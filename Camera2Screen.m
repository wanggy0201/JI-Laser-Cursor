function [ScreenX,ScreenY]=Camera2Screen(FocusTable,ScreenTable,CamX,CamY)
clear ScreenX;
clear ScreenY;
%Minor Adjustment
if CamX==FocusTable(1,1)||CamX==FocusTable(1,2)||CamX==FocusTable(1,3)||CamX==FocusTable(1,4)
    CamX=CamX+1;
end
if CamX==FocusTable(1,1)||CamX==FocusTable(1,2)||CamX==FocusTable(1,3)||CamX==FocusTable(1,4)
    CamX=CamX+1;
end
if CamY==FocusTable(2,1)||CamY==FocusTable(2,2)||CamY==FocusTable(2,3)||CamY==FocusTable(2,4)
    CamY=CamY+1;
end
if CamY==FocusTable(2,1)||CamY==FocusTable(2,2)||CamY==FocusTable(2,3)||CamY==FocusTable(2,4)
    CamY=CamY+1;
end
%Read Out Data
X1=FocusTable(1,1);SX1=ScreenTable(1,1);
X2=FocusTable(1,2);SX2=ScreenTable(1,2);
X3=FocusTable(1,3);SX3=ScreenTable(1,3);
X4=FocusTable(1,4);SX4=ScreenTable(1,4);
Y1=FocusTable(2,1);SY1=ScreenTable(2,1);
Y2=FocusTable(2,2);SY2=ScreenTable(2,2);
Y3=FocusTable(2,3);SY3=ScreenTable(2,3);
Y4=FocusTable(2,4);SY4=ScreenTable(2,4);
LineA=(CamY-Y1)/(CamX-X1)-(Y2-Y1)/(X2-X1);
LineB=(CamY-Y3)/(CamX-X3)-(Y3-Y4)/(X3-X4);
alpha=(LineB)/(LineB-LineA);
LineA=(CamX-X1)/(CamY-Y1)-(X3-X1)/(Y3-Y1);
LineB=(CamX-X2)/(CamY-Y2)-(X2-X4)/(Y2-Y4);
beta=(LineB)/(LineB-LineA);
ScreenXtmp=int32(alpha*(SX1*beta+SX2*(1-beta))+(1-alpha)*(SX3*beta+(1-beta)*SX4));
ScreenYtmp=int32(alpha*(SY1*beta+SY2*(1-beta))+(1-alpha)*(SY3*beta+(1-beta)*SY4));
ScreenX=int32(ScreenXtmp);
ScreenY=int32(ScreenYtmp);
end