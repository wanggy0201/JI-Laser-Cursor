function K=GetCoord(FocusTable)
%Read Out Data
X1=FocusTable(1,1);
X2=FocusTable(1,2);
X3=FocusTable(1,3);
X4=FocusTable(1,4);
Y1=FocusTable(2,1);
Y2=FocusTable(2,2);
Y3=FocusTable(2,3);
Y4=FocusTable(2,4);
%Calculate MidPoint
A=[Y4-Y1,-X4+X1;Y3-Y2,-X3+X2];
B=[X1*(Y4-Y1)-Y1*(X4-X1);X2*(Y3-Y2)-Y2*(X3-X2)];
M=linsolve(A,B);
XM=M(1,1);YM=M(2,1);
clear A; clear B;
%Calculate Infinite Point
%Vertical
A=[Y2-Y1,-X2+X1;Y3-Y4,-X3+X4];
B=[X1*(Y2-Y1)-Y1*(X2-X1);X4*(Y3-Y4)-Y4*(X3-X4)];
V=linsolve(A,B);
XV=V(1,1);YV=V(2,1);
clear A; clear B;
%Horizontal
A=[Y3-Y1,-X3+X1;Y4-Y2,-X4+X2];
B=[X1*(Y3-Y1)-Y1*(X3-X1);X2*(Y4-Y2)-Y2*(X4-X2)];
H=linsolve(A,B);
XH=H(1,1);YH=H(2,1);
clear A; clear B;
%Intersection W (VM&13)
A=[Y3-Y1,-X3+X1;YV-YM,-XV+XM];
B=[X1*(Y3-Y1)-Y1*(X3-X1);XM*(YV-YM)-YM*(XV-XM)];
W=linsolve(A,B);
XW=W(1,1);YW=W(2,1);
clear A; clear B;
%Intersection G (HM&12)
A=[Y2-Y1,-X2+X1;YH-YM,-XH+XM];
B=[X1*(Y2-Y1)-Y1*(X2-X1);XM*(YH-YM)-YM*(XH-XM)];
G=linsolve(A,B);
XG=G(1,1);YG=G(2,1);
clear A; clear B;
K=[X1,X2,X3,X4,XM,XV,XH,XW,XG;Y1,Y2,Y3,Y4,YM,YV,YH,YW,YG];
end