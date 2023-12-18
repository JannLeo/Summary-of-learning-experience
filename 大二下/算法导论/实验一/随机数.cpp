#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include<math.h>
#include<windows.h>
 
int main(void)
{
	srand(time(NULL));//先种种子 
	int i,n[100000],s=0,m,t=0,j,length;
	char str[]="",FileName[255],path[255]="C:\\Users\\11440\\Desktop\\作业与课件\\大二下\\算法导论\\实验一";
		
	FILE *fp = NULL;
	t=50000;
	for(j=0;j<20;j++)
	{
		m=j;
		wsprintf(path,"C:\\Users\\11440\\Desktop\\作业与课件\\大二下\\算法导论\\实验一");
		wsprintf(FileName,"\\%d.txt",j);
		strcat(path,FileName);
		HANDLE hFile;
		hFile=CreateFile(path,GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
		if(hFile==INVALID_HANDLE_VALUE){
			continue;
		}
		DWORD dwWrite=t;
		WriteFile(hFile,&n[0],4*t,&dwWrite,NULL);
 		CloseHandle(hFile);
 		memset(path,0x00,255);
 		memset(FileName,0x00,255);
		snprintf(str,100,"C:\\Users\\11440\\Desktop\\作业与课件\\大二下\\算法导论\\实验一\\%d.txt",m);
		fp=fopen(str,"a");
		t=50000;
	for(i = 0 ; i < t ; i ++)  
	{
		n[i] = rand() ;
		fprintf(fp,"%10d",j);
    }
    fclose(fp);
    j=m;

}
}
	

