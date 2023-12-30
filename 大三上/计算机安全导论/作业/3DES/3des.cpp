#include <iostream>
#include <stdio.h>
#include "memory.h"
#include <time.h>
#include <stdlib.h>

#define PLAIN_FILE_OPEN_ERROR -1
#define KEY_FILE_OPEN_ERROR -2
#define CIPHER_FILE_OPEN_ERROR -3
#define OK 1

///定义数据类型
typedef char type;
using namespace std;
class Treble_DES
{
    ///初始置换表IP
    int IP[64] = {  57,49,41,33,25,17,9,1,
                    59,51,43,35,27,19,11,3,
                    61,53,45,37,29,21,13,5,
                    63,55,47,39,31,23,15,7,
                    56,48,40,32,24,16,8,0,
                    58,50,42,34,26,18,10,2,
                    60,52,44,36,28,20,12,4,
                    62,54,46,38,30,22,14,6};

    ///逆初始置换表IP^-1
    int IP_1[64] = {39,7,47,15,55,23,63,31,
               38,6,46,14,54,22,62,30,
               37,5,45,13,53,21,61,29,
               36,4,44,12,52,20,60,28,
               35,3,43,11,51,19,59,27,
               34,2,42,10,50,18,58,26,
               33,1,41,9,49,17,57,25,
               32,0,40,8,48,16,56,24};

    ///扩充置换表E
    int E[48] = {31, 0, 1, 2, 3, 4,
                3, 4, 5, 6, 7, 8,
                7, 8,9,10,11,12,
                11,12,13,14,15,16,
                15,16,17,18,19,20,
                19,20,21,22,23,24,
                23,24,25,26,27,28,
                27,28,29,30,31, 0};

    //置换函数P
    int P[32] = {15,6,19,20,28,11,27,16,
                      0,14,22,25,4,17,30,9,
                      1,7,23,13,31,26,2,8,
                      18,12,29,5,21,10,3,24};

    //S盒
    int S[8][4][16] =//S1
    {{{14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7},
      {0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8},
      {4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0},
	  {15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13}},
                    //S2
     {{15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10},
      {3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5},
      {0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15},
      {13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9}},
                  //S3
     {{10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8},
      {13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1},
      {13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7},
      {1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12}},
                  //S4
     {{7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15},
      {13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9},
      {10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4},
      {3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14}},
                  //S5
     {{2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9},
      {14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6},
      {4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14},
      {11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3}},
                  //S6
     {{12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11},
      {10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8},
      {9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6},
      {4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13}},
                  //S7
    {{4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1},
     {13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6},
     {1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2},
     {6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12}},
                  //S8
     {{13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7},
      {1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2},
      {7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8},
      {2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11}}};
    //置换选择1
    int PC_1[56] = {56,48,40,32,24,16,8,
                  0,57,49,41,33,25,17,
                  9,1,58,50,42,34,26,
                  18,10,2,59,51,43,35,
                  62,54,46,38,30,22,14,
                  6,61,53,45,37,29,21,
                  13,5,60,52,44,36,28,
                  20,12,4,27,19,11,3};

    //置换选择2
    int PC_2[48] = {13,16,10,23,0,4,2,27,
                  14,5,20,9,22,18,11,3,
                  25,7,15,6,26,19,12,1,
                  40,51,30,36,46,54,29,39,
                  50,44,32,46,43,48,38,55,
                  33,52,45,41,49,35,28,31};

    //对左移次数的规定
    int left[16] = {1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1};

    ///字节转换成二进制
    int ByteToBit(type ch, type bit[8]){
        int cnt;
        for(cnt = 0;cnt < 8; cnt++){
            *(bit+cnt) = (ch>>cnt)&1;
        }
        return 0;
    }

    ///二进制转换成字节
    int BitToByte(type bit[8],type *ch){
        int cnt;
        for(cnt = 0;cnt < 8; cnt++){
            *ch |= *(bit + cnt)<<cnt;
        }
        return 0;
    }

    ///将长度为8的字符串转为二进制位串
    int Char8ToBit64(type ch[8],type bit[64]){
        int cnt;
        for(cnt = 0; cnt < 8; cnt++){
            ByteToBit(*(ch+cnt),bit+(cnt<<3));
        }
        return 0;
    }

    ///将二进制位串转为长度为8的字符串
    int Bit64ToChar8(type bit[64],type ch[8]){
        int cnt;
        memset(ch,0,8);
        for(cnt = 0; cnt < 8; cnt++){
            BitToByte(bit+(cnt<<3),ch+cnt);
        }
        return 0;
    }

    ///生成子密钥
    int DES_MakeSubKeys(type key[64],type subKeys[16][48]){
        type temp[56];
        int cnt;
        DES_PC1_Transform(key,temp);//PC1置换
        for(cnt = 0; cnt < 16; cnt++){//16轮跌代，产生16个子密钥
            DES_ROL(temp,left[cnt]);//循环左移
            DES_PC2_Transform(temp,subKeys[cnt]);//PC2置换，产生子密钥
        }
        return 0;
    }

    ///密钥置换pc1
    int DES_PC1_Transform(type key[64], type tempbts[56]){
        int cnt;
        for(cnt = 0; cnt < 56; cnt++){
            tempbts[cnt] = key[PC_1[cnt]];
        }
        return 0;
    }

    ///密钥置换pc2
    int DES_PC2_Transform(type key[56], type tempbts[48]){
        int cnt;
        for(cnt = 0; cnt < 48; cnt++){
            tempbts[cnt] = key[PC_2[cnt]];
        }
        return 0;
    }

    ///循环左移
    int DES_ROL(type data[56], int time){
        type temp[56];

        //保存将要循环移动到右边的位
        memcpy(temp,data,time);
        memcpy(temp+time,data+28,time);

        //前28位移动
        memcpy(data,data+time,28-time);
        memcpy(data+28-time,temp,time);

        //后28位移动
        memcpy(data+28,data+28+time,28-time);
        memcpy(data+56-time,temp+time,time);

        return 0;
    }

    ///IP置换
    int DES_IP_Transform(type data[64]){
        int cnt;
        type temp[64];
        for(cnt = 0; cnt < 64; cnt++){
            temp[cnt] = data[IP[cnt]];
        }
        memcpy(data,temp,64);
        return 0;
    }

    ///IP逆置换
    int DES_IP_1_Transform(type data[64]){
        int cnt;
        type temp[64];
        for(cnt = 0; cnt < 64; cnt++){
            temp[cnt] = data[IP_1[cnt]];
        }
        memcpy(data,temp,64);
        return 0;
    }

    ///扩展置换
    int DES_E_Transform(type data[48]){
        int cnt;
        type temp[48];
        for(cnt = 0; cnt < 48; cnt++){
            temp[cnt] = data[E[cnt]];
        }
        memcpy(data,temp,48);
        return 0;
    }

    ///P置换
    int DES_P_Transform(type data[32]){
        int cnt;
        type temp[32];
        for(cnt = 0; cnt < 32; cnt++){
            temp[cnt] = data[P[cnt]];
        }
        memcpy(data,temp,32);
        return 0;
    }

    ///异或
    int DES_XOR(type R[48], type L[48] ,int count){
        int cnt;
        for(cnt = 0; cnt < count; cnt++){
            R[cnt] ^= L[cnt];
        }
        return 0;
    }

    ///S盒置换
    int DES_SBOX(type data[48]){
        int cnt;
        int line,row,output;
        int cur1,cur2;
        for(cnt = 0; cnt < 8; cnt++){
            cur1 = cnt*6;
            cur2 = cnt<<2;

            //计算在S盒中的行与列
            line = (data[cur1]<<1) + data[cur1+5];
            row = (data[cur1+1]<<3) + (data[cur1+2]<<2)
                + (data[cur1+3]<<1) + data[cur1+4];
            output = S[cnt][line][row];

            //化为2进制
            data[cur2] = (output&0X08)>>3;
            data[cur2+1] = (output&0X04)>>2;
            data[cur2+2] = (output&0X02)>>1;
            data[cur2+3] = output&0x01;
        }
        return 0;
    }

    ///交换
    int DES_Swap(type left[32], type right[32]){
        type temp[32];
        memcpy(temp,left,32);
        memcpy(left,right,32);
        memcpy(right,temp,32);
        return 0;
    }

    ///加密单个分组
    int DES_EncryptBlock(type plainBlock[8], type subKeys[16][48], type cipherBlock[8]){
        type plainBits[64];
        type copyRight[48];
        int cnt;

        Char8ToBit64(plainBlock,plainBits);
        //初始置换（IP置换）
        DES_IP_Transform(plainBits);

        //16轮迭代
        for(cnt = 0; cnt < 16; cnt++){
            memcpy(copyRight,plainBits+32,32);
            //将右半部分进行扩展置换，从32位扩展到48位
            DES_E_Transform(copyRight);
            //将右半部分与子密钥进行异或操作
            DES_XOR(copyRight,subKeys[cnt],48);
            //异或结果进入S盒，输出32位结果
            DES_SBOX(copyRight);
            //P置换
            DES_P_Transform(copyRight);
            //将明文左半部分与右半部分进行异或
            DES_XOR(plainBits,copyRight,32);
            if(cnt != 15){
                //最终完成左右部的交换
                DES_Swap(plainBits,plainBits+32);
            }
        }
        //逆初始置换（IP^1置换）
        DES_IP_1_Transform(plainBits);
        Bit64ToChar8(plainBits,cipherBlock);
        return 0;
    }

    ///解密单个分组
    int DES_DecryptBlock(type cipherBlock[8], type subKeys[16][48],type plainBlock[8]){
        type cipherBits[64];
        type copyRight[48];
        int cnt;

        Char8ToBit64(cipherBlock,cipherBits);
        //初始置换（IP置换）
        DES_IP_Transform(cipherBits);

        //16轮迭代
        for(cnt = 15; cnt >= 0; cnt--){
            memcpy(copyRight,cipherBits+32,32);
            //将右半部分进行扩展置换，从32位扩展到48位
            DES_E_Transform(copyRight);
            //将右半部分与子密钥进行异或操作
            DES_XOR(copyRight,subKeys[cnt],48);
            //异或结果进入S盒，输出32位结果
            DES_SBOX(copyRight);
            //P置换
            DES_P_Transform(copyRight);
            //将明文左半部分与右半部分进行异或
            DES_XOR(cipherBits,copyRight,32);
            if(cnt != 0){
                //最终完成左右部的交换
                DES_Swap(cipherBits,cipherBits+32);
            }
        }
        //逆初始置换（IP^1置换）
        DES_IP_1_Transform(cipherBits);
        Bit64ToChar8(cipherBits,plainBlock);
        return 0;
    }

    //加密文件
    public: int treble_DES_Encrypt(char *plainFile, type *key_1,type *key_2,type *key_3,char *cipherFile){
        FILE *plain, *cipher;
        int count;
        long fileLen;
        type plainBlock[8],cipherBlock1[8],cipherBlock2[8],cipherBlock3[8];
        type Key1[64];
        type Key2[64];
        type Key3[64];
        type subKeys1[16][48];
        type subKeys2[16][48];
        type subKeys3[16][48];

        if((cipher = fopen(cipherFile,"wb")) == NULL){
            return CIPHER_FILE_OPEN_ERROR;
        }
        if((plain = fopen(plainFile,"rb")) == NULL){
            return PLAIN_FILE_OPEN_ERROR;
        }
        //设置密钥
        //将密钥转换为二进制流
        Char8ToBit64(key_1,Key1);
        Char8ToBit64(key_2,Key2);
        Char8ToBit64(key_3,Key3);
        //生成子密钥
        DES_MakeSubKeys(Key1,subKeys1);
        DES_MakeSubKeys(Key2,subKeys2);
        DES_MakeSubKeys(Key3,subKeys3);

        //如果文件非空
        while(!feof(plain)){
            //每次读8个字节，并返回成功读取的字节数
            if((count = fread(plainBlock,sizeof(char),8,plain)) == 8){
                //3DES加密单组文件
                DES_EncryptBlock(plainBlock,subKeys1,cipherBlock1);
                DES_DecryptBlock(cipherBlock1,subKeys2,cipherBlock2);
                DES_EncryptBlock(cipherBlock2,subKeys3,cipherBlock3);
                //写入
                fwrite(cipherBlock3,sizeof(char),8,cipher);
            }
        }
        //补充最后一组
        if(count){
            //填充
            memset(plainBlock + count,'\0',7 - count);
            //最后一个字符保存包括最后一个字符在内的所填充的字符数量
            plainBlock[7] = 8 - count;
            //加密单个分组
            DES_EncryptBlock(plainBlock,subKeys1,cipherBlock1);
            DES_DecryptBlock(cipherBlock1,subKeys2,cipherBlock2);
            DES_EncryptBlock(cipherBlock2,subKeys3,cipherBlock3);
            //写入文件
            fwrite(cipherBlock3,sizeof(char),8,cipher);
        }
        fclose(plain);
        fclose(cipher);
        return OK;
    }

    //解密文件
   public: int treble_DES_Decrypt(char *cipherFile, type *key_1,type *key_2,type *key_3,char *plainFile){
        FILE *plain, *cipher;
        int count,times = 0;
        long fileLen;
        type plainBlock1[8],plainBlock2[8],plainBlock3[8],cipherBlock[8];
        type Key1[64];
        type Key2[64];
        type Key3[64];
        type subKeys1[16][48];
        type subKeys2[16][48];
        type subKeys3[16][48];

        if((cipher = fopen(cipherFile,"rb")) == NULL){
            return CIPHER_FILE_OPEN_ERROR;
        }
        if((plain = fopen(plainFile,"wb")) == NULL){
            return PLAIN_FILE_OPEN_ERROR;
        }

        //将密钥转换为二进制流
        Char8ToBit64(key_1,Key1);
        Char8ToBit64(key_2,Key2);
        Char8ToBit64(key_3,Key3);
        //生成子密钥
        DES_MakeSubKeys(Key1,subKeys1);
        DES_MakeSubKeys(Key2,subKeys2);
        DES_MakeSubKeys(Key3,subKeys3);

        //取文件长度
        fseek(cipher,0,SEEK_END);   //将文件指针置尾
        fileLen = ftell(cipher);    //取文件指针当前位置
        rewind(cipher);             //将文件指针重指向文件头
        while(1){
            //密文的字节数一定是8的整数倍
            fread(cipherBlock,sizeof(char),8,cipher);
            //3DES解密
            DES_DecryptBlock(cipherBlock,subKeys3,plainBlock1);
            DES_EncryptBlock(plainBlock1,subKeys2,plainBlock2);
            DES_DecryptBlock(plainBlock2,subKeys1,plainBlock3);
             times += 8;
            if(times < fileLen){
                fwrite(plainBlock3,sizeof(char),8,plain);
            }
            else{
                break;
            }
        }
        //判断末尾是否被填充
        if(plainBlock3[7] < 8){
            for(count = 8 - plainBlock3[7]; count < 7; count++){
                if(plainBlock3[count] != '\0'){
                //3des
                DES_DecryptBlock(cipherBlock,subKeys3,plainBlock1);
                DES_EncryptBlock(plainBlock1,subKeys2,plainBlock2);
                DES_DecryptBlock(plainBlock2,subKeys1,plainBlock3);
                break;
                }
            }
        }
        if(count == 7){//有填充
            fwrite(plainBlock3,sizeof(char),8 - plainBlock3[7],plain);
        }
        else{//无填充
            fwrite(plainBlock3,sizeof(char),8,plain);
        }

        fclose(plain);
        fclose(cipher);
        return OK;
    }

};


int main()
{
    type key_1[8] =  {'1','1','2','2','3','3','4','4'};
    type key_2[8] =  {'a','b','c','d','e','f','g','h'};
    type key_3[8] =  {'1','2','3','4','5','6','7','8'};
    Treble_DES d;
    cout<<"开始加密"<<endl;
    cout<<d.treble_DES_Encrypt("明文.docx",key_1,key_2,key_3,"加密.txt");
    cout<<"加密结束，开始解密"<<endl;
    cout<<d.treble_DES_Decrypt("加密.txt",key_1,key_2,key_3,"输出明文.docx");
    cout<<"解密完成"<<endl;
    getchar();

    return 0;
}
