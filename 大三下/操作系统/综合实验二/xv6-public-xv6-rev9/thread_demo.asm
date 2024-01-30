
_thread_demo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
        int n=5*(int )t_num+i+2+num;
        printf(0,"thread num: %d, global: %d , fib(%d)=%d\n",(int)t_num,global,n,fib(n));
    }
    exit();
}
int main(int argc,char* argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    int tids[5];
    int i;
    for(i=0;i<3;i++){
   f:	31 db                	xor    %ebx,%ebx
int main(int argc,char* argv[]){
  11:	83 ec 20             	sub    $0x20,%esp
        void* stack=malloc(4096);
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	68 00 10 00 00       	push   $0x1000
  1c:	e8 af 07 00 00       	call   7d0 <malloc>
        tids[i]=clone(func,(void*)i,stack);
  21:	83 c4 0c             	add    $0xc,%esp
  24:	50                   	push   %eax
  25:	53                   	push   %ebx
  26:	68 c0 00 00 00       	push   $0xc0
  2b:	e8 82 04 00 00       	call   4b2 <clone>
  30:	89 44 9d e4          	mov    %eax,-0x1c(%ebp,%ebx,4)
    for(i=0;i<3;i++){
  34:	83 c3 01             	add    $0x1,%ebx
  37:	83 c4 10             	add    $0x10,%esp
  3a:	83 fb 03             	cmp    $0x3,%ebx
  3d:	75 d5                	jne    14 <main+0x14>
    }
    for(i=0;i<3;i++){
        join((void**)tids[i]);
  3f:	83 ec 0c             	sub    $0xc,%esp
  42:	ff 75 e4             	pushl  -0x1c(%ebp)
  45:	e8 60 04 00 00       	call   4aa <join>
  4a:	58                   	pop    %eax
  4b:	ff 75 e8             	pushl  -0x18(%ebp)
  4e:	e8 57 04 00 00       	call   4aa <join>
  53:	5a                   	pop    %edx
  54:	ff 75 ec             	pushl  -0x14(%ebp)
  57:	e8 4e 04 00 00       	call   4aa <join>
    }
    exit();
  5c:	e8 51 03 00 00       	call   3b2 <exit>
  61:	66 90                	xchg   %ax,%ax
  63:	66 90                	xchg   %ax,%ax
  65:	66 90                	xchg   %ax,%ax
  67:	66 90                	xchg   %ax,%ax
  69:	66 90                	xchg   %ax,%ax
  6b:	66 90                	xchg   %ax,%ax
  6d:	66 90                	xchg   %ax,%ax
  6f:	90                   	nop

00000070 <fib>:
int fib(int x){
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	57                   	push   %edi
  74:	56                   	push   %esi
  75:	53                   	push   %ebx
    if(x<=2) return x;
  76:	31 ff                	xor    %edi,%edi
int fib(int x){
  78:	83 ec 1c             	sub    $0x1c,%esp
  7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(x<=2) return x;
  7e:	83 fb 02             	cmp    $0x2,%ebx
  81:	7e 30                	jle    b3 <fib+0x43>
  83:	8d 43 fd             	lea    -0x3(%ebx),%eax
  86:	8d 73 ff             	lea    -0x1(%ebx),%esi
  89:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8c:	83 e0 01             	and    $0x1,%eax
  8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return fib(x-1)+fib(x-2);
  92:	83 ec 0c             	sub    $0xc,%esp
  95:	56                   	push   %esi
  96:	83 ee 02             	sub    $0x2,%esi
  99:	e8 d2 ff ff ff       	call   70 <fib>
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	01 c7                	add    %eax,%edi
    if(x<=2) return x;
  a3:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  a6:	75 ea                	jne    92 <fib+0x22>
  a8:	8b 75 e0             	mov    -0x20(%ebp),%esi
  ab:	83 eb 02             	sub    $0x2,%ebx
  ae:	83 e6 fe             	and    $0xfffffffe,%esi
  b1:	29 f3                	sub    %esi,%ebx
}
  b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  b6:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
  b9:	5b                   	pop    %ebx
  ba:	5e                   	pop    %esi
  bb:	5f                   	pop    %edi
  bc:	5d                   	pop    %ebp
  bd:	c3                   	ret    
  be:	66 90                	xchg   %ax,%ax

000000c0 <func>:
void func(void* t_num){
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	56                   	push   %esi
  c5:	53                   	push   %ebx
  c6:	83 ec 1c             	sub    $0x1c,%esp
        int n=5*(int )t_num+i+2+num;
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  cf:	8d 58 01             	lea    0x1(%eax),%ebx
  d2:	83 c0 06             	add    $0x6,%eax
  d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        global++;
  d8:	a1 f0 0b 00 00       	mov    0xbf0,%eax
  dd:	83 c0 01             	add    $0x1,%eax
    if(x<=2) return x;
  e0:	83 fb 02             	cmp    $0x2,%ebx
        global++;
  e3:	a3 f0 0b 00 00       	mov    %eax,0xbf0
    if(x<=2) return x;
  e8:	7e 66                	jle    150 <func+0x90>
  ea:	8d 7b fd             	lea    -0x3(%ebx),%edi
  ed:	8d 53 ff             	lea    -0x1(%ebx),%edx
  f0:	31 c9                	xor    %ecx,%ecx
  f2:	89 fe                	mov    %edi,%esi
  f4:	83 e6 01             	and    $0x1,%esi
  f7:	89 f6                	mov    %esi,%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return fib(x-1)+fib(x-2);
 100:	83 ec 0c             	sub    $0xc,%esp
 103:	52                   	push   %edx
 104:	e8 67 ff ff ff       	call   70 <fib>
 109:	83 ea 02             	sub    $0x2,%edx
 10c:	83 c4 10             	add    $0x10,%esp
 10f:	01 c1                	add    %eax,%ecx
    if(x<=2) return x;
 111:	39 f2                	cmp    %esi,%edx
 113:	75 eb                	jne    100 <func+0x40>
 115:	8d 53 fe             	lea    -0x2(%ebx),%edx
 118:	83 e7 fe             	and    $0xfffffffe,%edi
 11b:	29 fa                	sub    %edi,%edx
        printf(0,"thread num: %d, global: %d , fib(%d)=%d\n",(int)t_num,global,n,fib(n));
 11d:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 122:	83 ec 08             	sub    $0x8,%esp
 125:	01 d1                	add    %edx,%ecx
 127:	51                   	push   %ecx
 128:	53                   	push   %ebx
 129:	83 c3 01             	add    $0x1,%ebx
 12c:	50                   	push   %eax
 12d:	ff 75 08             	pushl  0x8(%ebp)
 130:	68 c8 08 00 00       	push   $0x8c8
 135:	6a 00                	push   $0x0
 137:	e8 34 04 00 00       	call   570 <printf>
    for(i=0;i<5;i++){
 13c:	83 c4 20             	add    $0x20,%esp
 13f:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
 142:	75 94                	jne    d8 <func+0x18>
    exit();
 144:	e8 69 02 00 00       	call   3b2 <exit>
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(x<=2) return x;
 150:	89 da                	mov    %ebx,%edx
 152:	31 c9                	xor    %ecx,%ecx
 154:	eb c7                	jmp    11d <func+0x5d>
 156:	66 90                	xchg   %ax,%ax
 158:	66 90                	xchg   %ax,%ax
 15a:	66 90                	xchg   %ax,%ax
 15c:	66 90                	xchg   %ax,%ax
 15e:	66 90                	xchg   %ax,%ax

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	53                   	push   %ebx
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16a:	89 c2                	mov    %eax,%edx
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 170:	83 c1 01             	add    $0x1,%ecx
 173:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 177:	83 c2 01             	add    $0x1,%edx
 17a:	84 db                	test   %bl,%bl
 17c:	88 5a ff             	mov    %bl,-0x1(%edx)
 17f:	75 ef                	jne    170 <strcpy+0x10>
    ;
  return os;
}
 181:	5b                   	pop    %ebx
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    
 184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 18a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	53                   	push   %ebx
 194:	8b 55 08             	mov    0x8(%ebp),%edx
 197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 19a:	0f b6 02             	movzbl (%edx),%eax
 19d:	0f b6 19             	movzbl (%ecx),%ebx
 1a0:	84 c0                	test   %al,%al
 1a2:	75 1c                	jne    1c0 <strcmp+0x30>
 1a4:	eb 2a                	jmp    1d0 <strcmp+0x40>
 1a6:	8d 76 00             	lea    0x0(%esi),%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 1b0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1b3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 1b6:	83 c1 01             	add    $0x1,%ecx
 1b9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 1bc:	84 c0                	test   %al,%al
 1be:	74 10                	je     1d0 <strcmp+0x40>
 1c0:	38 d8                	cmp    %bl,%al
 1c2:	74 ec                	je     1b0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 1c4:	29 d8                	sub    %ebx,%eax
}
 1c6:	5b                   	pop    %ebx
 1c7:	5d                   	pop    %ebp
 1c8:	c3                   	ret    
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1d0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1d2:	29 d8                	sub    %ebx,%eax
}
 1d4:	5b                   	pop    %ebx
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    
 1d7:	89 f6                	mov    %esi,%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <strlen>:

uint
strlen(char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1e6:	80 39 00             	cmpb   $0x0,(%ecx)
 1e9:	74 15                	je     200 <strlen+0x20>
 1eb:	31 d2                	xor    %edx,%edx
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
 1f0:	83 c2 01             	add    $0x1,%edx
 1f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1f7:	89 d0                	mov    %edx,%eax
 1f9:	75 f5                	jne    1f0 <strlen+0x10>
    ;
  return n;
}
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 200:	31 c0                	xor    %eax,%eax
}
 202:	5d                   	pop    %ebp
 203:	c3                   	ret    
 204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 20a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000210 <memset>:

void*
memset(void *dst, int c, uint n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 217:	8b 4d 10             	mov    0x10(%ebp),%ecx
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 d7                	mov    %edx,%edi
 21f:	fc                   	cld    
 220:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 222:	89 d0                	mov    %edx,%eax
 224:	5f                   	pop    %edi
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <strchr>:

char*
strchr(const char *s, char c)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 23a:	0f b6 10             	movzbl (%eax),%edx
 23d:	84 d2                	test   %dl,%dl
 23f:	74 1d                	je     25e <strchr+0x2e>
    if(*s == c)
 241:	38 d3                	cmp    %dl,%bl
 243:	89 d9                	mov    %ebx,%ecx
 245:	75 0d                	jne    254 <strchr+0x24>
 247:	eb 17                	jmp    260 <strchr+0x30>
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 250:	38 ca                	cmp    %cl,%dl
 252:	74 0c                	je     260 <strchr+0x30>
  for(; *s; s++)
 254:	83 c0 01             	add    $0x1,%eax
 257:	0f b6 10             	movzbl (%eax),%edx
 25a:	84 d2                	test   %dl,%dl
 25c:	75 f2                	jne    250 <strchr+0x20>
      return (char*)s;
  return 0;
 25e:	31 c0                	xor    %eax,%eax
}
 260:	5b                   	pop    %ebx
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <gets>:

char*
gets(char *buf, int max)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	56                   	push   %esi
 275:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 276:	31 f6                	xor    %esi,%esi
 278:	89 f3                	mov    %esi,%ebx
{
 27a:	83 ec 1c             	sub    $0x1c,%esp
 27d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 280:	eb 2f                	jmp    2b1 <gets+0x41>
 282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 288:	8d 45 e7             	lea    -0x19(%ebp),%eax
 28b:	83 ec 04             	sub    $0x4,%esp
 28e:	6a 01                	push   $0x1
 290:	50                   	push   %eax
 291:	6a 00                	push   $0x0
 293:	e8 32 01 00 00       	call   3ca <read>
    if(cc < 1)
 298:	83 c4 10             	add    $0x10,%esp
 29b:	85 c0                	test   %eax,%eax
 29d:	7e 1c                	jle    2bb <gets+0x4b>
      break;
    buf[i++] = c;
 29f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2a3:	83 c7 01             	add    $0x1,%edi
 2a6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 2a9:	3c 0a                	cmp    $0xa,%al
 2ab:	74 23                	je     2d0 <gets+0x60>
 2ad:	3c 0d                	cmp    $0xd,%al
 2af:	74 1f                	je     2d0 <gets+0x60>
  for(i=0; i+1 < max; ){
 2b1:	83 c3 01             	add    $0x1,%ebx
 2b4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2b7:	89 fe                	mov    %edi,%esi
 2b9:	7c cd                	jl     288 <gets+0x18>
 2bb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 2c0:	c6 03 00             	movb   $0x0,(%ebx)
}
 2c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5f                   	pop    %edi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    
 2cb:	90                   	nop
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2d0:	8b 75 08             	mov    0x8(%ebp),%esi
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	01 de                	add    %ebx,%esi
 2d8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2da:	c6 03 00             	movb   $0x0,(%ebx)
}
 2dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e0:	5b                   	pop    %ebx
 2e1:	5e                   	pop    %esi
 2e2:	5f                   	pop    %edi
 2e3:	5d                   	pop    %ebp
 2e4:	c3                   	ret    
 2e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <stat>:

int
stat(char *n, struct stat *st)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	56                   	push   %esi
 2f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f5:	83 ec 08             	sub    $0x8,%esp
 2f8:	6a 00                	push   $0x0
 2fa:	ff 75 08             	pushl  0x8(%ebp)
 2fd:	e8 f0 00 00 00       	call   3f2 <open>
  if(fd < 0)
 302:	83 c4 10             	add    $0x10,%esp
 305:	85 c0                	test   %eax,%eax
 307:	78 27                	js     330 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 309:	83 ec 08             	sub    $0x8,%esp
 30c:	ff 75 0c             	pushl  0xc(%ebp)
 30f:	89 c3                	mov    %eax,%ebx
 311:	50                   	push   %eax
 312:	e8 f3 00 00 00       	call   40a <fstat>
  close(fd);
 317:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 31a:	89 c6                	mov    %eax,%esi
  close(fd);
 31c:	e8 b9 00 00 00       	call   3da <close>
  return r;
 321:	83 c4 10             	add    $0x10,%esp
}
 324:	8d 65 f8             	lea    -0x8(%ebp),%esp
 327:	89 f0                	mov    %esi,%eax
 329:	5b                   	pop    %ebx
 32a:	5e                   	pop    %esi
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
 32d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 330:	be ff ff ff ff       	mov    $0xffffffff,%esi
 335:	eb ed                	jmp    324 <stat+0x34>
 337:	89 f6                	mov    %esi,%esi
 339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000340 <atoi>:

int
atoi(const char *s)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 347:	0f be 11             	movsbl (%ecx),%edx
 34a:	8d 42 d0             	lea    -0x30(%edx),%eax
 34d:	3c 09                	cmp    $0x9,%al
  n = 0;
 34f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 354:	77 1f                	ja     375 <atoi+0x35>
 356:	8d 76 00             	lea    0x0(%esi),%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 360:	8d 04 80             	lea    (%eax,%eax,4),%eax
 363:	83 c1 01             	add    $0x1,%ecx
 366:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 36a:	0f be 11             	movsbl (%ecx),%edx
 36d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 370:	80 fb 09             	cmp    $0x9,%bl
 373:	76 eb                	jbe    360 <atoi+0x20>
  return n;
}
 375:	5b                   	pop    %ebx
 376:	5d                   	pop    %ebp
 377:	c3                   	ret    
 378:	90                   	nop
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000380 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	56                   	push   %esi
 384:	53                   	push   %ebx
 385:	8b 5d 10             	mov    0x10(%ebp),%ebx
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38e:	85 db                	test   %ebx,%ebx
 390:	7e 14                	jle    3a6 <memmove+0x26>
 392:	31 d2                	xor    %edx,%edx
 394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 398:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 39c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 39f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 3a2:	39 d3                	cmp    %edx,%ebx
 3a4:	75 f2                	jne    398 <memmove+0x18>
  return vdst;
}
 3a6:	5b                   	pop    %ebx
 3a7:	5e                   	pop    %esi
 3a8:	5d                   	pop    %ebp
 3a9:	c3                   	ret    

000003aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3aa:	b8 01 00 00 00       	mov    $0x1,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <exit>:
SYSCALL(exit)
 3b2:	b8 02 00 00 00       	mov    $0x2,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <wait>:
SYSCALL(wait)
 3ba:	b8 03 00 00 00       	mov    $0x3,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <pipe>:
SYSCALL(pipe)
 3c2:	b8 04 00 00 00       	mov    $0x4,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <read>:
SYSCALL(read)
 3ca:	b8 05 00 00 00       	mov    $0x5,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <write>:
SYSCALL(write)
 3d2:	b8 10 00 00 00       	mov    $0x10,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <close>:
SYSCALL(close)
 3da:	b8 15 00 00 00       	mov    $0x15,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <kill>:
SYSCALL(kill)
 3e2:	b8 06 00 00 00       	mov    $0x6,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <exec>:
SYSCALL(exec)
 3ea:	b8 07 00 00 00       	mov    $0x7,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <open>:
SYSCALL(open)
 3f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <mknod>:
SYSCALL(mknod)
 3fa:	b8 11 00 00 00       	mov    $0x11,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <unlink>:
SYSCALL(unlink)
 402:	b8 12 00 00 00       	mov    $0x12,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <fstat>:
SYSCALL(fstat)
 40a:	b8 08 00 00 00       	mov    $0x8,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <link>:
SYSCALL(link)
 412:	b8 13 00 00 00       	mov    $0x13,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <mkdir>:
SYSCALL(mkdir)
 41a:	b8 14 00 00 00       	mov    $0x14,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <chdir>:
SYSCALL(chdir)
 422:	b8 09 00 00 00       	mov    $0x9,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <dup>:
SYSCALL(dup)
 42a:	b8 0a 00 00 00       	mov    $0xa,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <getpid>:
SYSCALL(getpid)
 432:	b8 0b 00 00 00       	mov    $0xb,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <sbrk>:
SYSCALL(sbrk)
 43a:	b8 0c 00 00 00       	mov    $0xc,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <sleep>:
SYSCALL(sleep)
 442:	b8 0d 00 00 00       	mov    $0xd,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <uptime>:
SYSCALL(uptime)
 44a:	b8 0e 00 00 00       	mov    $0xe,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <getcpuid>:
SYSCALL(getcpuid)
 452:	b8 16 00 00 00       	mov    $0x16,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <changepri>:
SYSCALL(changepri)
 45a:	b8 17 00 00 00       	mov    $0x17,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <sh_var_read>:
SYSCALL(sh_var_read)
 462:	b8 16 00 00 00       	mov    $0x16,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <sh_var_write>:
SYSCALL(sh_var_write)
 46a:	b8 17 00 00 00       	mov    $0x17,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <sem_create>:
SYSCALL(sem_create)
 472:	b8 18 00 00 00       	mov    $0x18,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <sem_free>:
SYSCALL(sem_free)
 47a:	b8 19 00 00 00       	mov    $0x19,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <sem_p>:
SYSCALL(sem_p)
 482:	b8 1a 00 00 00       	mov    $0x1a,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <sem_v>:
SYSCALL(sem_v)
 48a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <myMalloc>:
SYSCALL(myMalloc)
 492:	b8 1c 00 00 00       	mov    $0x1c,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <myFree>:
SYSCALL(myFree)
 49a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <myFork>:
SYSCALL(myFork)
 4a2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <join>:
SYSCALL(join)
 4aa:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <clone>:
SYSCALL(clone)
 4b2:	b8 20 00 00 00       	mov    $0x20,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <chmod>:
SYSCALL(chmod)
 4ba:	b8 21 00 00 00       	mov    $0x21,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <open_fifo>:
 4c2:	b8 22 00 00 00       	mov    $0x22,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    
 4ca:	66 90                	xchg   %ax,%ax
 4cc:	66 90                	xchg   %ax,%ax
 4ce:	66 90                	xchg   %ax,%ax

000004d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
 4d5:	53                   	push   %ebx
 4d6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d9:	85 d2                	test   %edx,%edx
{
 4db:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 4de:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 4e0:	79 76                	jns    558 <printint+0x88>
 4e2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4e6:	74 70                	je     558 <printint+0x88>
    x = -xx;
 4e8:	f7 d8                	neg    %eax
    neg = 1;
 4ea:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 4f1:	31 f6                	xor    %esi,%esi
 4f3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 4f6:	eb 0a                	jmp    502 <printint+0x32>
 4f8:	90                   	nop
 4f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 500:	89 fe                	mov    %edi,%esi
 502:	31 d2                	xor    %edx,%edx
 504:	8d 7e 01             	lea    0x1(%esi),%edi
 507:	f7 f1                	div    %ecx
 509:	0f b6 92 fc 08 00 00 	movzbl 0x8fc(%edx),%edx
  }while((x /= base) != 0);
 510:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 512:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 515:	75 e9                	jne    500 <printint+0x30>
  if(neg)
 517:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 51a:	85 c0                	test   %eax,%eax
 51c:	74 08                	je     526 <printint+0x56>
    buf[i++] = '-';
 51e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 523:	8d 7e 02             	lea    0x2(%esi),%edi
 526:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 52a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 52d:	8d 76 00             	lea    0x0(%esi),%esi
 530:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 533:	83 ec 04             	sub    $0x4,%esp
 536:	83 ee 01             	sub    $0x1,%esi
 539:	6a 01                	push   $0x1
 53b:	53                   	push   %ebx
 53c:	57                   	push   %edi
 53d:	88 45 d7             	mov    %al,-0x29(%ebp)
 540:	e8 8d fe ff ff       	call   3d2 <write>

  while(--i >= 0)
 545:	83 c4 10             	add    $0x10,%esp
 548:	39 de                	cmp    %ebx,%esi
 54a:	75 e4                	jne    530 <printint+0x60>
    putc(fd, buf[i]);
}
 54c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 54f:	5b                   	pop    %ebx
 550:	5e                   	pop    %esi
 551:	5f                   	pop    %edi
 552:	5d                   	pop    %ebp
 553:	c3                   	ret    
 554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 558:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 55f:	eb 90                	jmp    4f1 <printint+0x21>
 561:	eb 0d                	jmp    570 <printf>
 563:	90                   	nop
 564:	90                   	nop
 565:	90                   	nop
 566:	90                   	nop
 567:	90                   	nop
 568:	90                   	nop
 569:	90                   	nop
 56a:	90                   	nop
 56b:	90                   	nop
 56c:	90                   	nop
 56d:	90                   	nop
 56e:	90                   	nop
 56f:	90                   	nop

00000570 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	56                   	push   %esi
 575:	53                   	push   %ebx
 576:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 579:	8b 75 0c             	mov    0xc(%ebp),%esi
 57c:	0f b6 1e             	movzbl (%esi),%ebx
 57f:	84 db                	test   %bl,%bl
 581:	0f 84 b3 00 00 00    	je     63a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 587:	8d 45 10             	lea    0x10(%ebp),%eax
 58a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 58d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 58f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 592:	eb 2f                	jmp    5c3 <printf+0x53>
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 598:	83 f8 25             	cmp    $0x25,%eax
 59b:	0f 84 a7 00 00 00    	je     648 <printf+0xd8>
  write(fd, &c, 1);
 5a1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5a4:	83 ec 04             	sub    $0x4,%esp
 5a7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5aa:	6a 01                	push   $0x1
 5ac:	50                   	push   %eax
 5ad:	ff 75 08             	pushl  0x8(%ebp)
 5b0:	e8 1d fe ff ff       	call   3d2 <write>
 5b5:	83 c4 10             	add    $0x10,%esp
 5b8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 5bb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5bf:	84 db                	test   %bl,%bl
 5c1:	74 77                	je     63a <printf+0xca>
    if(state == 0){
 5c3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 5c5:	0f be cb             	movsbl %bl,%ecx
 5c8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5cb:	74 cb                	je     598 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5cd:	83 ff 25             	cmp    $0x25,%edi
 5d0:	75 e6                	jne    5b8 <printf+0x48>
      if(c == 'd'){
 5d2:	83 f8 64             	cmp    $0x64,%eax
 5d5:	0f 84 05 01 00 00    	je     6e0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5db:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5e1:	83 f9 70             	cmp    $0x70,%ecx
 5e4:	74 72                	je     658 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5e6:	83 f8 73             	cmp    $0x73,%eax
 5e9:	0f 84 99 00 00 00    	je     688 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ef:	83 f8 63             	cmp    $0x63,%eax
 5f2:	0f 84 08 01 00 00    	je     700 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5f8:	83 f8 25             	cmp    $0x25,%eax
 5fb:	0f 84 ef 00 00 00    	je     6f0 <printf+0x180>
  write(fd, &c, 1);
 601:	8d 45 e7             	lea    -0x19(%ebp),%eax
 604:	83 ec 04             	sub    $0x4,%esp
 607:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 60b:	6a 01                	push   $0x1
 60d:	50                   	push   %eax
 60e:	ff 75 08             	pushl  0x8(%ebp)
 611:	e8 bc fd ff ff       	call   3d2 <write>
 616:	83 c4 0c             	add    $0xc,%esp
 619:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 61c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 61f:	6a 01                	push   $0x1
 621:	50                   	push   %eax
 622:	ff 75 08             	pushl  0x8(%ebp)
 625:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 628:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 62a:	e8 a3 fd ff ff       	call   3d2 <write>
  for(i = 0; fmt[i]; i++){
 62f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 633:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 636:	84 db                	test   %bl,%bl
 638:	75 89                	jne    5c3 <printf+0x53>
    }
  }
}
 63a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 63d:	5b                   	pop    %ebx
 63e:	5e                   	pop    %esi
 63f:	5f                   	pop    %edi
 640:	5d                   	pop    %ebp
 641:	c3                   	ret    
 642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 648:	bf 25 00 00 00       	mov    $0x25,%edi
 64d:	e9 66 ff ff ff       	jmp    5b8 <printf+0x48>
 652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 658:	83 ec 0c             	sub    $0xc,%esp
 65b:	b9 10 00 00 00       	mov    $0x10,%ecx
 660:	6a 00                	push   $0x0
 662:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 665:	8b 45 08             	mov    0x8(%ebp),%eax
 668:	8b 17                	mov    (%edi),%edx
 66a:	e8 61 fe ff ff       	call   4d0 <printint>
        ap++;
 66f:	89 f8                	mov    %edi,%eax
 671:	83 c4 10             	add    $0x10,%esp
      state = 0;
 674:	31 ff                	xor    %edi,%edi
        ap++;
 676:	83 c0 04             	add    $0x4,%eax
 679:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 67c:	e9 37 ff ff ff       	jmp    5b8 <printf+0x48>
 681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 688:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 68b:	8b 08                	mov    (%eax),%ecx
        ap++;
 68d:	83 c0 04             	add    $0x4,%eax
 690:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 693:	85 c9                	test   %ecx,%ecx
 695:	0f 84 8e 00 00 00    	je     729 <printf+0x1b9>
        while(*s != 0){
 69b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 69e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 6a0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 6a2:	84 c0                	test   %al,%al
 6a4:	0f 84 0e ff ff ff    	je     5b8 <printf+0x48>
 6aa:	89 75 d0             	mov    %esi,-0x30(%ebp)
 6ad:	89 de                	mov    %ebx,%esi
 6af:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6b2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 6b5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 6b8:	83 ec 04             	sub    $0x4,%esp
          s++;
 6bb:	83 c6 01             	add    $0x1,%esi
 6be:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 6c1:	6a 01                	push   $0x1
 6c3:	57                   	push   %edi
 6c4:	53                   	push   %ebx
 6c5:	e8 08 fd ff ff       	call   3d2 <write>
        while(*s != 0){
 6ca:	0f b6 06             	movzbl (%esi),%eax
 6cd:	83 c4 10             	add    $0x10,%esp
 6d0:	84 c0                	test   %al,%al
 6d2:	75 e4                	jne    6b8 <printf+0x148>
 6d4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 6d7:	31 ff                	xor    %edi,%edi
 6d9:	e9 da fe ff ff       	jmp    5b8 <printf+0x48>
 6de:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 6e0:	83 ec 0c             	sub    $0xc,%esp
 6e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6e8:	6a 01                	push   $0x1
 6ea:	e9 73 ff ff ff       	jmp    662 <printf+0xf2>
 6ef:	90                   	nop
  write(fd, &c, 1);
 6f0:	83 ec 04             	sub    $0x4,%esp
 6f3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 6f6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 6f9:	6a 01                	push   $0x1
 6fb:	e9 21 ff ff ff       	jmp    621 <printf+0xb1>
        putc(fd, *ap);
 700:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 703:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 706:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 708:	6a 01                	push   $0x1
        ap++;
 70a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 70d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 710:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 713:	50                   	push   %eax
 714:	ff 75 08             	pushl  0x8(%ebp)
 717:	e8 b6 fc ff ff       	call   3d2 <write>
        ap++;
 71c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 71f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 722:	31 ff                	xor    %edi,%edi
 724:	e9 8f fe ff ff       	jmp    5b8 <printf+0x48>
          s = "(null)";
 729:	bb f4 08 00 00       	mov    $0x8f4,%ebx
        while(*s != 0){
 72e:	b8 28 00 00 00       	mov    $0x28,%eax
 733:	e9 72 ff ff ff       	jmp    6aa <printf+0x13a>
 738:	66 90                	xchg   %ax,%ax
 73a:	66 90                	xchg   %ax,%ax
 73c:	66 90                	xchg   %ax,%ax
 73e:	66 90                	xchg   %ax,%ax

00000740 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 740:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 741:	a1 f4 0b 00 00       	mov    0xbf4,%eax
{
 746:	89 e5                	mov    %esp,%ebp
 748:	57                   	push   %edi
 749:	56                   	push   %esi
 74a:	53                   	push   %ebx
 74b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 74e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	39 c8                	cmp    %ecx,%eax
 75a:	8b 10                	mov    (%eax),%edx
 75c:	73 32                	jae    790 <free+0x50>
 75e:	39 d1                	cmp    %edx,%ecx
 760:	72 04                	jb     766 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 762:	39 d0                	cmp    %edx,%eax
 764:	72 32                	jb     798 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 766:	8b 73 fc             	mov    -0x4(%ebx),%esi
 769:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 76c:	39 fa                	cmp    %edi,%edx
 76e:	74 30                	je     7a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 770:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 773:	8b 50 04             	mov    0x4(%eax),%edx
 776:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 779:	39 f1                	cmp    %esi,%ecx
 77b:	74 3a                	je     7b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 77d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 77f:	a3 f4 0b 00 00       	mov    %eax,0xbf4
}
 784:	5b                   	pop    %ebx
 785:	5e                   	pop    %esi
 786:	5f                   	pop    %edi
 787:	5d                   	pop    %ebp
 788:	c3                   	ret    
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	39 d0                	cmp    %edx,%eax
 792:	72 04                	jb     798 <free+0x58>
 794:	39 d1                	cmp    %edx,%ecx
 796:	72 ce                	jb     766 <free+0x26>
{
 798:	89 d0                	mov    %edx,%eax
 79a:	eb bc                	jmp    758 <free+0x18>
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 7a0:	03 72 04             	add    0x4(%edx),%esi
 7a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a6:	8b 10                	mov    (%eax),%edx
 7a8:	8b 12                	mov    (%edx),%edx
 7aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ad:	8b 50 04             	mov    0x4(%eax),%edx
 7b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7b3:	39 f1                	cmp    %esi,%ecx
 7b5:	75 c6                	jne    77d <free+0x3d>
    p->s.size += bp->s.size;
 7b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7ba:	a3 f4 0b 00 00       	mov    %eax,0xbf4
    p->s.size += bp->s.size;
 7bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7c5:	89 10                	mov    %edx,(%eax)
}
 7c7:	5b                   	pop    %ebx
 7c8:	5e                   	pop    %esi
 7c9:	5f                   	pop    %edi
 7ca:	5d                   	pop    %ebp
 7cb:	c3                   	ret    
 7cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	57                   	push   %edi
 7d4:	56                   	push   %esi
 7d5:	53                   	push   %ebx
 7d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7dc:	8b 15 f4 0b 00 00    	mov    0xbf4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e2:	8d 78 07             	lea    0x7(%eax),%edi
 7e5:	c1 ef 03             	shr    $0x3,%edi
 7e8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7eb:	85 d2                	test   %edx,%edx
 7ed:	0f 84 9d 00 00 00    	je     890 <malloc+0xc0>
 7f3:	8b 02                	mov    (%edx),%eax
 7f5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7f8:	39 cf                	cmp    %ecx,%edi
 7fa:	76 6c                	jbe    868 <malloc+0x98>
 7fc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 802:	bb 00 10 00 00       	mov    $0x1000,%ebx
 807:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 80a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 811:	eb 0e                	jmp    821 <malloc+0x51>
 813:	90                   	nop
 814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 81a:	8b 48 04             	mov    0x4(%eax),%ecx
 81d:	39 f9                	cmp    %edi,%ecx
 81f:	73 47                	jae    868 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 821:	39 05 f4 0b 00 00    	cmp    %eax,0xbf4
 827:	89 c2                	mov    %eax,%edx
 829:	75 ed                	jne    818 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 82b:	83 ec 0c             	sub    $0xc,%esp
 82e:	56                   	push   %esi
 82f:	e8 06 fc ff ff       	call   43a <sbrk>
  if(p == (char*)-1)
 834:	83 c4 10             	add    $0x10,%esp
 837:	83 f8 ff             	cmp    $0xffffffff,%eax
 83a:	74 1c                	je     858 <malloc+0x88>
  hp->s.size = nu;
 83c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 83f:	83 ec 0c             	sub    $0xc,%esp
 842:	83 c0 08             	add    $0x8,%eax
 845:	50                   	push   %eax
 846:	e8 f5 fe ff ff       	call   740 <free>
  return freep;
 84b:	8b 15 f4 0b 00 00    	mov    0xbf4,%edx
      if((p = morecore(nunits)) == 0)
 851:	83 c4 10             	add    $0x10,%esp
 854:	85 d2                	test   %edx,%edx
 856:	75 c0                	jne    818 <malloc+0x48>
        return 0;
  }
}
 858:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 85b:	31 c0                	xor    %eax,%eax
}
 85d:	5b                   	pop    %ebx
 85e:	5e                   	pop    %esi
 85f:	5f                   	pop    %edi
 860:	5d                   	pop    %ebp
 861:	c3                   	ret    
 862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 868:	39 cf                	cmp    %ecx,%edi
 86a:	74 54                	je     8c0 <malloc+0xf0>
        p->s.size -= nunits;
 86c:	29 f9                	sub    %edi,%ecx
 86e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 871:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 874:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 877:	89 15 f4 0b 00 00    	mov    %edx,0xbf4
}
 87d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 880:	83 c0 08             	add    $0x8,%eax
}
 883:	5b                   	pop    %ebx
 884:	5e                   	pop    %esi
 885:	5f                   	pop    %edi
 886:	5d                   	pop    %ebp
 887:	c3                   	ret    
 888:	90                   	nop
 889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 890:	c7 05 f4 0b 00 00 f8 	movl   $0xbf8,0xbf4
 897:	0b 00 00 
 89a:	c7 05 f8 0b 00 00 f8 	movl   $0xbf8,0xbf8
 8a1:	0b 00 00 
    base.s.size = 0;
 8a4:	b8 f8 0b 00 00       	mov    $0xbf8,%eax
 8a9:	c7 05 fc 0b 00 00 00 	movl   $0x0,0xbfc
 8b0:	00 00 00 
 8b3:	e9 44 ff ff ff       	jmp    7fc <malloc+0x2c>
 8b8:	90                   	nop
 8b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 8c0:	8b 08                	mov    (%eax),%ecx
 8c2:	89 0a                	mov    %ecx,(%edx)
 8c4:	eb b1                	jmp    877 <malloc+0xa7>
