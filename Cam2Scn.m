function [XFP,YFP]=Cam2Scn(CoordTable,ScreenTable,XP,YP)
%Read Data
X1=CoordTable(1,1);Y1=CoordTable(2,1);
X2=CoordTable(1,2);Y2=CoordTable(2,2);
X3=CoordTable(1,3);Y3=CoordTable(2,3);
X4=CoordTable(1,4);Y4=CoordTable(2,4);
XM=CoordTable(1,5);YM=CoordTable(2,5);
XV=CoordTable(1,6);YV=CoordTable(2,6);
XH=CoordTable(1,7);YH=CoordTable(2,7);
XW=CoordTable(1,8);YW=CoordTable(2,8);
XG=CoordTable(1,9);YG=CoordTable(2,9);
XF1=ScreenTable(1,1);YF1=ScreenTable(2,1);
XF2=ScreenTable(1,2);YF2=ScreenTable(2,2);
XF3=ScreenTable(1,3);YF3=ScreenTable(2,3);
XF4=ScreenTable(1,4);YF4=ScreenTable(2,4);
XFW=(XF1+XF3)/2;YFG=(YF1+YF2)/2;
%Intersection Q (VP&13)
A=[Y3-Y1,-X3+X1;YV-YP,-XV+XP];
B=[X1*(Y3-Y1)-Y1*(X3-X1);XP*(YV-YP)-YP*(XV-XP)];
Q=linsolve(A,B);
XQ=Q(1,1);
YQ=Q(2,1);
clear A; clear B;
%Intersection R (HP&12)
A=[Y2-Y1,-X2+X1;YH-YP,-XH+XP];
B=[X1*(Y2-Y1)-Y1*(X2-X1);XP*(YH-YP)-YP*(XH-XP)];
R=linsolve(A,B);
XR=R(1,1);
YR=R(2,1);
clear A; clear B;
%Calculate with Cross-Ratio
XFP=((X1-X3)*(XQ-XW)*(XF1-XFW)*XF3-(X1-XW)*(XQ-X3)*(XF1-XF3)*XFW)/((X1-X3)*(XQ-XW)*(XF1-XFW)-(X1-XW)*(XQ-X3)*(XF1-XF3));
YFP=((Y1-X2)*(YR-YG)*(YF1-YFG)*YF2-(Y1-YG)*(YR-Y2)*(YF1-YF2)*YFG)/((Y1-Y2)*(YR-YG)*(YF1-YFG)-(Y1-YG)*(YR-Y2)*(YF1-YF2));
end