clear all, clc;
%Camera Configuration
cam=ipcam('http://192.168.1.100:8080/','','');

%Screen Config
H=480;
W=640;

%Arduino Configuration
%Arduino=arduino('COM9');
%Arduino.pinMode(2,'OUTPUT');
%Arduino.pinMode(3,'OUTPUT');
%Arduino.pinMode(14,'INPUT');
%Arduino.pinMode(15,'INPUT');
%Arduino.digitalWrite(2,1);
%Arduino.digitalWrite(3,1);

%Detecting Position
while true
    pause(0.05);
    BoolTable=zeros(H+2,W+2);
    img=snapshot(cam);
    %BoolTable Approach #1
    %Threshold=sum(sum(sum(img,3),2),1)/640/480*0.8;
    %BoolTable(2:481,2:641)=sum(img,3)>Threshold;
    %
    %
    %BoolTable Approach #2
    %
    imgsum=sum(img,3);
    ThresholdTable=zeros(H,W);
    OverlapTable=zeros(H,W);
    OverlapBase=ones(H,W);
    for I=-16:4:16
        for J=-16:4:16
            ThresholdModX1=max([1,1+I]);
            ThresholdModX2=min([H,H+I]);
            ThresholdModY1=max([1,1+J]);
            ThresholdModY2=min([W,W+J]);
            ImgModX1=max([1,1-I]);
            ImgModX2=min([H,H-I]);
            ImgModY1=max([1,1-J]);
            ImgModY2=min([W,W-J]);
            ThresholdTable(ThresholdModX1:ThresholdModX2,ThresholdModY1:ThresholdModY2)=...
                ThresholdTable(ThresholdModX1:ThresholdModX2,ThresholdModY1:ThresholdModY2)+...
                imgsum(ImgModX1:ImgModX2,ImgModY1:ImgModY2);
            OverlapTable(ThresholdModX1:ThresholdModX2,ThresholdModY1:ThresholdModY2)=...
                OverlapTable(ThresholdModX1:ThresholdModX2,ThresholdModY1:ThresholdModY2)+...
                OverlapBase(ImgModX1:ImgModX2,ImgModY1:ImgModY2);
        end
    end
    BoolTable(2:H+1,2:W+1)=imgsum>((ThresholdTable./OverlapTable)+3);
    
%
%
    NumTable=zeros(H+2,W+2);
    CoTable=zeros(2,100000);CoTablePointer=1;CoTableEndPointer=1;;
    CoTableN=zeros(2,100000);CoTableNEndPointer=2;
    CoTableN(1,1)=1;CoTableN(2,1)=1;
    Numbered=0;
    CurrentNumber=1;
    while Numbered<(H+2)*(W+2)
        CoTable=CoTableN;
        CoTableN=zeros(2,100000);
        CoTablePointer=1;
        CoTableEndPointer=CoTableNEndPointer;
        CoTableNEndPointer=1;
        while CoTablePointer<CoTableEndPointer
            X=CoTable(1,CoTablePointer);
            Y=CoTable(2,CoTablePointer);
            if(X+1<=H+2&&NumTable(X+1,Y)==0)
                if BoolTable(X,Y)==BoolTable(X+1,Y)
                    NumTable(X+1,Y)=CurrentNumber;
                    CoTable(1,CoTableEndPointer)=X+1;           
                    CoTable(2,CoTableEndPointer)=Y;
                    CoTableEndPointer=CoTableEndPointer+1;
                    Numbered=Numbered+1;
                else
                    NumTable(X+1,Y)=CurrentNumber+1;
                    CoTableN(1,CoTableNEndPointer)=X+1;
                    CoTableN(2,CoTableNEndPointer)=Y;
                    CoTableNEndPointer=CoTableNEndPointer+1;
                    Numbered=Numbered+1;
                end
            end
            if(X-1>=1&&NumTable(X-1,Y)==0)
                if BoolTable(X,Y)==BoolTable(X-1,Y)
                    NumTable(X-1,Y)=CurrentNumber;
                    CoTable(1,CoTableEndPointer)=X-1;           
                    CoTable(2,CoTableEndPointer)=Y;
                    CoTableEndPointer=CoTableEndPointer+1;
                    Numbered=Numbered+1;
                else
                    NumTable(X-1,Y)=CurrentNumber+1;
                    CoTableN(1,CoTableNEndPointer)=X-1;
                    CoTableN(2,CoTableNEndPointer)=Y;
                    CoTableNEndPointer=CoTableNEndPointer+1;
                    Numbered=Numbered+1;
                end
            end
            if(Y+1<=W+2&&NumTable(X,Y+1)==0)
                if BoolTable(X,Y)==BoolTable(X,Y+1)
                    NumTable(X,Y+1)=CurrentNumber;
                    CoTable(1,CoTableEndPointer)=X;           
                    CoTable(2,CoTableEndPointer)=Y+1;
                    CoTableEndPointer=CoTableEndPointer+1;
                    Numbered=Numbered+1;
                else
                    NumTable(X,Y+1)=CurrentNumber+1;
                    CoTableN(1,CoTableNEndPointer)=X;
                    CoTableN(2,CoTableNEndPointer)=Y+1;
                    CoTableNEndPointer=CoTableNEndPointer+1;
                    Numbered=Numbered+1;
                end
            end
            if(Y-1>=1&&NumTable(X,Y-1)==0)
                if BoolTable(X,Y)==BoolTable(X,Y-1)
                    NumTable(X,Y-1)=CurrentNumber;
                    CoTable(1,CoTableEndPointer)=X;           
                    CoTable(2,CoTableEndPointer)=Y-1;
                    CoTableEndPointer=CoTableEndPointer+1;
                    Numbered=Numbered+1;
                else
                    NumTable(X,Y-1)=CurrentNumber+1;
                    CoTableN(1,CoTableNEndPointer)=X;
                    CoTableN(2,CoTableNEndPointer)=Y-1;
                    CoTableNEndPointer=CoTableNEndPointer+1;
                    Numbered=Numbered+1;
                end
            end
            CoTablePointer=CoTablePointer+1;
        end
        CurrentNumber=CurrentNumber+1;
    end
    PeakTable=(NumTable>5);
    PeakTableEvaluated=PeakTable;
    C=zeros(H+2,W+2,3);
    C(:,:,1)=PeakTable;
    C(:,:,2)=PeakTable;
    C(:,:,3)=PeakTable;
    FocusTable=zeros(2,100);FocusNum=0;
    for I=1:5:H+2
        for J=1:5:W+2
            if PeakTableEvaluated(I,J)==1
                AreaTable=zeros(2,10000);
                AreaTablePointer=1;
                AreaTableEndPointer=2;
                SumX=I;SumY=J;Size=1;
                PeakTableEvaluated(I,J)=0;
                AreaTable(1,AreaTablePointer)=I;
                AreaTable(2,AreaTablePointer)=J;
                while AreaTablePointer<AreaTableEndPointer
                    I=AreaTable(1,AreaTablePointer);
                    J=AreaTable(2,AreaTablePointer);
                    if PeakTableEvaluated(I+1,J)==1
                        AreaTable(1,AreaTableEndPointer)=I+1;
                        AreaTable(2,AreaTableEndPointer)=J;
                        AreaTableEndPointer=AreaTableEndPointer+1;
                        Size=Size+1;
                        SumX=SumX+I+1;
                        SumY=SumY+J;
                        PeakTableEvaluated(I+1,J)=0;
                    end
                    if PeakTableEvaluated(I-1,J)==1
                        AreaTable(1,AreaTableEndPointer)=I-1;
                        AreaTable(2,AreaTableEndPointer)=J;
                        AreaTableEndPointer=AreaTableEndPointer+1;
                        Size=Size+1;
                        SumX=SumX+I-1;
                        SumY=SumY+J;
                        PeakTableEvaluated(I-1,J)=0;
                    end
                    if PeakTableEvaluated(I,J+1)==1
                        AreaTable(1,AreaTableEndPointer)=I;
                        AreaTable(2,AreaTableEndPointer)=J+1;
                        AreaTableEndPointer=AreaTableEndPointer+1;
                        Size=Size+1;
                        SumX=SumX+I;
                        SumY=SumY+J+1;
                        PeakTableEvaluated(I,J+1)=0;
                    end
                    if PeakTableEvaluated(I,J-1)==1
                        AreaTable(1,AreaTableEndPointer)=I;
                        AreaTable(2,AreaTableEndPointer)=J-1;
                        AreaTableEndPointer=AreaTableEndPointer+1;
                        Size=Size+1;
                        SumX=SumX+I;
                        SumY=SumY+J-1;
                        PeakTableEvaluated(I,J-1)=0;
                    end
                    AreaTablePointer=AreaTablePointer+1;
                end
                AvgX=int16(SumX/Size);
                AvgY=int16(SumY/Size);
                FocusNum=FocusNum+1;
                FocusTable(1,FocusNum)=AvgX;
                FocusTable(2,FocusNum)=AvgY;
            end
        end
    end
    if FocusNum>0
        for i=1:FocusNum
            img((FocusTable(1,i)-2):(FocusTable(1,i)),(FocusTable(2,i)-2):(FocusTable(2,i)),1)=[255,255,255;255,255,255;255,255,255];
            img((FocusTable(1,i)-2):(FocusTable(1,i)),(FocusTable(2,i)-2):(FocusTable(2,i)),2)=[0,0,0;0,0,0;0,0,0];
            img((FocusTable(1,i)-2):(FocusTable(1,i)),(FocusTable(2,i)-2):(FocusTable(2,i)),3)=[0,0,0;0,0,0;0,0,0];
        end
    end
    subplot(1,2,1);
    subimage(BoolTable*10);
    subplot(1,2,2);
    subimage(img);
    FocusNum
    if FocusNum==4
        break;
    end
end

%Minor Adjustment
if FocusTable(1,1)==FocusTable(1,2)
    FocusTable(1,1)=FocusTable(1,1)+1;
end
if FocusTable(1,3)==FocusTable(1,4)
    FocusTable(1,3)=FocusTable(1,3)+1;
end
if FocusTable(2,1)==FocusTable(2,3)
    FocusTable(2,1)=FocusTable(2,1)+1;
end
if FocusTable(2,2)==FocusTable(2,4)
    FocusTable(2,2)=FocusTable(2,2)+1;
end

FocusTable(1:2,1:4)
for i=1:3
    for j=1:3
        if FocusTable(1,j)*1+FocusTable(2,j)*2>FocusTable(1,j+1)+FocusTable(2,j+1)*2
        FocusTable(:,5)=FocusTable(:,j);
        FocusTable(:,j)=FocusTable(:,j+1);
        FocusTable(:,j+1)=FocusTable(:,5);
        end
    end
end
%Set up Screen Position
ScreenTable=[120,648,120,648;90,90,934,934];
ScreenArea=zeros(H,W);
for i=1:4:H
    for j=1:4:W
        [ScnX,ScnY]=Camera2Screen(FocusTable,ScreenTable,i,j);
        if ScnX>0&&ScnX<768&&ScnY>0&&ScnY<1024
            ScreenArea(i:i+3,j:j+3)=[1,1,1,1;1,1,1,1;1,1,1,1;1,1,1,1];
        end
    end
    i
end
%[scx,scy]=Camera2Screen(FocusTable,ScreenTable,300,300)
img(299:301,299:301,1)=[255,255,255;255,255,255;255,255,255];
img(299:301,299:301,2)=[255,255,255;255,255,255;255,255,255];
img(299:301,299:301,3)=[255,255,255;255,255,255;255,255,255];
image(img);


clear ThresholdTable;
clear OverlapTable;
clear OverlapBase;
clear CoTable;
clear CoTableN;
clear CoTablePointer
clear CoTableNEndPointer;
clear BoolTable;
clear PeakTable;
clear PeakTableEvaluated;

%Method 1
while true
    pause(0.05);
    img=snapshot(cam);
    RedLayer=img(:,:,1);
    GreenLayer=img(:,:,2);
    BlueLayer=img(:,:,3);
    TrueLayer(:,:)=((BlueLayer>250&GreenLayer>250&RedLayer>250)&ScreenArea>0);
    Pixels=sum(sum(TrueLayer));
    [PixelY,PixelX] = meshgrid(1:1280,1:960);
    AvgX=0;AvgY=0;
    if Pixels ~=0
    AvgX=sum(PixelX(TrueLayer))/Pixels;
    AvgY=sum(PixelY(TrueLayer))/Pixels;
    end
    [ScnX,ScnY]=Camera2Screen(FocusTable,ScreenTable,AvgX,AvgY);
    subplot(1,2,1);
    ImageShow=TrueLayer*10;
    %ImageShow(uint32(AvgX)-1:uint32(AvgX)+1,uint32(AvgY)-1:uint32(AvgY)+1)=ones(3)*20;
    image(ImageShow);
    subplot(1,2,1);
    image(TrueLayer*100);
    Temp=zeros(H,W);
    if(ScnX>0&&ScnX<H&&ScnY>0&&ScnY<W)
    Temp(ScnX,ScnY)=1;
    subplot(1,2,2);
    image(Temp*100);
    end
    subplot(1,2,2);
    image(img);
    Mode=0;
    %if Arduino.analogRead(14)>1020
    %    Mode=Mode+2;
    %end
    %if Arduino.analogRead(15)>1020
    %    Mode=Mode+1;
    %end
    Output=[ScnX,ScnY,Mode]
    fd=fopen('Control.txt','w+');
    fprintf(fd,'%d %d',ScnX,ScnY);
    fclose(fd);
end










