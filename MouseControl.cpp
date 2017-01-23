#include "afxres.h"     \\Mouse
#include "winuser.h"    \\Mouse
#include "windows.h"    \\Sleep
#include <iostream>
#include <cstdio>
#include <cmath>
using namespace std;

int main(){
    int a=0,b=0;
    int bt1=0,bt2=0,bt3=0,bt4=0;
    int newbt1,newbt2,newbt3,newbt4;
    int newa, newb;
    FILE* pFile;
    int i;
    bool Pen=false;
    bool inArea=false;
    while(1){
        pFile=fopen("Control.txt","r");
        fscanf(pFile,"%d %d %d %d %d %d",&newb, &newa, &newbt1, &newbt2, &newbt3, &newbt4);
        fclose(pFile);
        cout << "X=" << newa <<"; Y=" << newb <<endl;
        if(Pen==true){
            inArea=false;
            a=newa;b=newb;
            bt1=newbt1;bt2=newbt2;bt3=newbt3;
            SetCursorPos(a,b);
            mouse_event(MOUSEEVENTF_LEFTDOWN|MOUSEEVENTF_LEFTUP,0,0,0,0);
            if(bt4==1&&newbt4==0){
                Pen=false;
                SetCursorPos(400,400);
                keybd_event(VK_CONTROL,0,0,0);
                keybd_event('A',0,0,0);
                keybd_event('A',0,KEYEVENTF_KEYUP,0);
                keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);
            }
            bt4=newbt4;
        }
        else{
            if(bt1==0&&newbt1==1){
                SetCursorPos(newa,newb);
                mouse_event(MOUSEEVENTF_LEFTDOWN|MOUSEEVENTF_LEFTUP,0,0,0,0);
            }
            if(bt2==0&&newbt2==1){
                SetCursorPos(newa,newb);
                mouse_event(MOUSEEVENTF_RIGHTDOWN|MOUSEEVENTF_RIGHTUP,0,0,0,0);
            }
            if(newbt3==1){
                SetCursorPos(newa,newb);
            }
            if(newbt4==1&&bt4==0){
                Pen=true;
                SetCursorPos(400,400);
                keybd_event(VK_CONTROL,0,0,0);
                keybd_event('P',0,0,0);
                keybd_event('P',0,KEYEVENTF_KEYUP,0);
                keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);
            }
            if(newa>974&&newa<1024&&newb<50&&newb>0){
                if(inArea==false){
                inArea=true;
                keybd_event(18,0,0,0);
                keybd_event(VK_F4,0,0,0);
                keybd_event(VK_F4,0,KEYEVENTF_KEYUP,0);
                keybd_event(18,0,KEYEVENTF_KEYUP,0);
                }
            }
            else if(newa>0&&newa<50&&newb<50&&newb>0){
                if(inArea==false){
                inArea=true;
                keybd_event(VK_ESCAPE,0,0,0);
                }
            }
            else if(newa>974&&newa<1024&&newb<768&&newb>718){
                if(inArea==false){
                inArea=true;
                keybd_event(VK_EXECUTE,0,0,0);
                }
            }
            else if(newa>974&&newa<1024&&newb<768&&newb>718){
                if(inArea==false){
                inArea=true;
                keybd_event(VK_CONTROL,0,0,0);
                keybd_event('C',0,0,0);
                keybd_event('C',0,KEYEVENTF_KEYUP,0);
                keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);
                }
            }
            else{
                inArea=false;
            }
            a=newa;b=newb;
            bt1=newbt1;bt2=newbt2;bt3=newbt3;bt4=newbt4;
        }
    }
}
