#启动命令 python rsa.py -p rsa_plain.txt -n n.txt -e e.txt -d d.txt -c rsa_cipher.txt -s rsa_sign.txt
import random
import binascii
import argparse         #导入读取命令行参数的模块
import sys
sys.setrecursionlimit(100000)   #设置迭代次数限制
 
def main():
        Build_key()     #生成公钥、密钥
        parser = argparse.ArgumentParser(description="This is a description, it includes the whole file's loactions of RSA algorithm.")
        parser.add_argument('-p', required = True, type = argparse.FileType('r'), help = 'plainfile')
        parser.add_argument('-n', required = True, type = argparse.FileType('r'), help = 'nfile')
        parser.add_argument('-e', required = False, type = argparse.FileType('r'), help = 'efile')
        parser.add_argument('-d', required = False, type = argparse.FileType('r'), help = 'dfile')
        parser.add_argument('-c', required = True, type = argparse.FileType('w+'), help = 'cipherfile')
        parser.add_argument('-s', required = True, type = argparse.FileType('w+'), help = 'signfile')
        args = parser.parse_args()  #args里面的成员是一个文件对象，所以后面写入文件的形式和一般的一样
        n = int(args.n.read(),16)
        m = args.p.read()
        #加密与签名
        if m=='':
            print('error：无明文!')
        else:
            print("加密中......")
            e = int(args.e.read(),16)
            cipher = encrypt(m,e,n)
            with args.c as f:
                f.write(cipher)
            print("加密完毕!\r\n密文是:",cipher)

            print("签名中......")
            d = int(args.d.read(),16)
            sign = encrypt(m,d,n)
            with args.s as f:
                f.write(sign)
            print("签名完毕!\r\n签名是:",sign)
        #解密
        c = cipher     #读取密文
        if c=='':
            print ("error：无密文!")
        else:
            print("解密中......")
            plain = decrypt(c,d,n)
            print("解密完毕!\r\n明文是:",plain)
 
#平方—乘法算法
def MRF(b,n,m):
    
        a=1
        x=b;y=n;z=m
        binstr = bin(n)[2:][::-1]	#通过切片去掉开头的0b，截取后面，然后反转
        for item in binstr:
                if item == '1':
                        a = (a*b)%m
                        b = (b**2)%m
                elif item == '0':
                        b = (b**2)%m
        return a
 
#Miller-Rabin的素数概率检测法
def MillerRabin(n):
    "利用Miller-Rabin算法检验生成的奇数是否为素数"
    m=n-1
    k=0
    while(m%2==0):
        m=m//2
        k=k+1
    a=random.randint(2,n)
    #b=a**m%n
    b = MRF(a,m,n)
    if b==1:
        return 1
    for i in range(k):
        if b==n-1:
            return 1
        else:
            b=b*b%n
    return 0
 
#生成大素数，20次MillerRabin算法缩小出错的概率
def BigPrime():
        Min = 10**11;Max = 10**15;p = 0
        while(1):
                p = random.randrange(Min,Max,1)
                for i in range(20):
                        if MillerRabin(p)==0:
                                break
                        elif i==19:
                                return p
                                
#加密，传入公钥，通过读取明文文件进行加密
def encrypt(m,e,n):
        cipher = ""
        nlength = len(str(hex(n))[2:])  #计算n的16进制长度，以便分组
        message = m             #读取明文
        for i in range(0,len(message),8):
            if i==len(message)//8*8:
                m = int(a2hex(message[i:]),16)  #最后一个分组
            m = int(a2hex(message[i:i+8]),16)
            c = MRF(m,e,n)
            cipher1 = str(hex(c))[2:]
            if len(cipher1)!=nlength:
                cipher1 = '0'*(nlength-len(cipher1))+cipher1    #每一个密文分组，长度不够，高位补0
            cipher += cipher1
        return cipher
#解密,传入私钥，通过文件读写进行解密
def decrypt(c,d,n):
        #加密之后每一个分组的长度和n的长度相同
        cipher = c
        message = ""
        nlength = len(str(hex(n))[2:])
        for i in range(0,len(cipher),nlength):
            c = int(cipher[i:i+nlength],16)     #得到一组密文的c
            m = MRF(c,d,n)
            info = hex2a(str(hex(m))[2:])
            message += info
        f_write("rsa_plain.txt",message)
        return message
 
#求最大公因子
def gcd(a,b):  
        if a%b == 0:
                return b
        else :
                return gcd(b,a%b)
 
#求逆元
def Ex_Euclid(x,n):
    r0=n
    r1=x%n
    if r1==1:
        y=1
    else:
        s0=1
        s1=0
        t0=0
        t1=1
        while (r0%r1!=0):
            q=r0//r1  
            r=r0%r1  
            r0=r1  
            r1=r  
            s=s0-q*s1 
            s0=s1 
            s1=s  
            t=t0-q*t1  
            t0=t1  
            t1=t  
            if r==1:
                y = (t+n)%n
    return y
 
#写入文件
def f_write(filename,message):
        f = open(filename,'w')
        f.write(message)
        f.close()
        return 0
 
#ascii_to_hex
def a2hex(raw_str):
        hex_str = ''
        for ch in raw_str:
                hex_str += hex(ord(ch))[2:]
        return hex_str
 
#hex_to_ascii
def hex2a(raw_str):
        asc_str = ''
        for i in range(0,len(raw_str),2):
                asc_str += chr(int(raw_str[i:i+2],16))
        return asc_str
def Build_key():
        #产生p,q,n,e,d
        p = BigPrime()
        q = BigPrime()
        n = p*q
        _n = (p-1)*(q-1)    #n的欧拉函数
        e = 0
        while(1):
                e = random.randint(1,_n+1)
                if gcd(e,_n)==1:
                        break
        d = Ex_Euclid(e,_n)
        #写入文件
        f_write('p.txt',str(hex(p))[2:])
        f_write('q.txt',str(hex(q))[2:])
        f_write('n.txt',str(hex(n))[2:])
        f_write('e.txt',str(hex(e))[2:])
        f_write('d.txt',str(hex(d))[2:])
        with open("rsa_pubkey.txt",mode="w") as f1:
                f1.write("n=" + str(hex(n))[2:])
                f1.write("\n")
                f1.write("e=" + str(hex(e))[2:])
        with open("rsa_prikey.txt",mode="w") as f2:
                f2.write("n=" + str(hex(n))[2:])
                f2.write("\n")
                f2.write("e=" + str(hex(d))[2:])
 
if __name__ == "__main__":
        main()