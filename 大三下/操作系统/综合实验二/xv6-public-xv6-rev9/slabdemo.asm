
_slabdemo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"


int main(int argc,char*argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 18             	sub    $0x18,%esp
    char* a1;
    a1=(char*)myMalloc(30);
  13:	6a 1e                	push   $0x1e
  15:	e8 18 04 00 00       	call   432 <myMalloc>
    printf(1,"a1 virtural address :%p\n",a1);
  1a:	83 c4 0c             	add    $0xc,%esp
    a1=(char*)myMalloc(30);
  1d:	89 c3                	mov    %eax,%ebx
    printf(1,"a1 virtural address :%p\n",a1);
  1f:	50                   	push   %eax
  20:	68 68 08 00 00       	push   $0x868
  25:	6a 01                	push   $0x1
  27:	e8 e4 04 00 00       	call   510 <printf>
    a1[0]='A';
    printf(1,"a1[0]:%c\n\n",a1[0]);
  2c:	83 c4 0c             	add    $0xc,%esp
    a1[0]='A';
  2f:	c6 03 41             	movb   $0x41,(%ebx)
    printf(1,"a1[0]:%c\n\n",a1[0]);
  32:	6a 41                	push   $0x41
  34:	68 81 08 00 00       	push   $0x881
  39:	6a 01                	push   $0x1
  3b:	e8 d0 04 00 00       	call   510 <printf>

    char* a2;
    a2=(char*)myMalloc(31);
  40:	c7 04 24 1f 00 00 00 	movl   $0x1f,(%esp)
  47:	e8 e6 03 00 00       	call   432 <myMalloc>
    printf(1,"a2 virtural address :%p\n",a2);
  4c:	83 c4 0c             	add    $0xc,%esp
    a2=(char*)myMalloc(31);
  4f:	89 c3                	mov    %eax,%ebx
    printf(1,"a2 virtural address :%p\n",a2);
  51:	50                   	push   %eax
  52:	68 8c 08 00 00       	push   $0x88c
  57:	6a 01                	push   $0x1
  59:	e8 b2 04 00 00       	call   510 <printf>
    a2[0]='B';
    printf(1,"a2[0]:%c\n\n",a2[0]);
  5e:	83 c4 0c             	add    $0xc,%esp
    a2[0]='B';
  61:	c6 03 42             	movb   $0x42,(%ebx)
    printf(1,"a2[0]:%c\n\n",a2[0]);
  64:	6a 42                	push   $0x42
  66:	68 a5 08 00 00       	push   $0x8a5
  6b:	6a 01                	push   $0x1
  6d:	e8 9e 04 00 00       	call   510 <printf>

    char* a3;
    a3=(char*)myMalloc(29);
  72:	c7 04 24 1d 00 00 00 	movl   $0x1d,(%esp)
  79:	e8 b4 03 00 00       	call   432 <myMalloc>
    printf(1,"a3 virtural address :%p\n",a3);
  7e:	83 c4 0c             	add    $0xc,%esp
    a3=(char*)myMalloc(29);
  81:	89 c6                	mov    %eax,%esi
    printf(1,"a3 virtural address :%p\n",a3);
  83:	50                   	push   %eax
  84:	68 b0 08 00 00       	push   $0x8b0
  89:	6a 01                	push   $0x1
  8b:	e8 80 04 00 00       	call   510 <printf>
    a3[0]='C';
    printf(1,"a3[0]:%c\n\n",a3[0]);
  90:	83 c4 0c             	add    $0xc,%esp
    a3[0]='C';
  93:	c6 06 43             	movb   $0x43,(%esi)
    printf(1,"a3[0]:%c\n\n",a3[0]);
  96:	6a 43                	push   $0x43
  98:	68 c9 08 00 00       	push   $0x8c9
  9d:	6a 01                	push   $0x1
  9f:	e8 6c 04 00 00       	call   510 <printf>

    myFree(a2);
  a4:	89 1c 24             	mov    %ebx,(%esp)
  a7:	e8 8e 03 00 00       	call   43a <myFree>
    printf(1,"free virtual address a2:%p\n\n",a2);
  ac:	83 c4 0c             	add    $0xc,%esp
  af:	53                   	push   %ebx
  b0:	68 d4 08 00 00       	push   $0x8d4
  b5:	6a 01                	push   $0x1
  b7:	e8 54 04 00 00       	call   510 <printf>

    char* a4;
    a4=(char*)myMalloc(28);
  bc:	c7 04 24 1c 00 00 00 	movl   $0x1c,(%esp)
  c3:	e8 6a 03 00 00       	call   432 <myMalloc>
    printf(1,"a4 virtural address :%p\n",a4);
  c8:	83 c4 0c             	add    $0xc,%esp
    a4=(char*)myMalloc(28);
  cb:	89 c3                	mov    %eax,%ebx
    printf(1,"a4 virtural address :%p\n",a4);
  cd:	50                   	push   %eax
  ce:	68 f1 08 00 00       	push   $0x8f1
  d3:	6a 01                	push   $0x1
  d5:	e8 36 04 00 00       	call   510 <printf>
    a4[0]='D';
    printf(1,"a4[0]:%c\n\n",a4[0]);
  da:	83 c4 0c             	add    $0xc,%esp
    a4[0]='D';
  dd:	c6 03 44             	movb   $0x44,(%ebx)
    printf(1,"a4[0]:%c\n\n",a4[0]);
  e0:	6a 44                	push   $0x44
  e2:	68 0a 09 00 00       	push   $0x90a
  e7:	6a 01                	push   $0x1
  e9:	e8 22 04 00 00       	call   510 <printf>
    exit();
  ee:	e8 5f 02 00 00       	call   352 <exit>
  f3:	66 90                	xchg   %ax,%ax
  f5:	66 90                	xchg   %ax,%ax
  f7:	66 90                	xchg   %ax,%ax
  f9:	66 90                	xchg   %ax,%ax
  fb:	66 90                	xchg   %ax,%ax
  fd:	66 90                	xchg   %ax,%ax
  ff:	90                   	nop

00000100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10a:	89 c2                	mov    %eax,%edx
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 110:	83 c1 01             	add    $0x1,%ecx
 113:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 117:	83 c2 01             	add    $0x1,%edx
 11a:	84 db                	test   %bl,%bl
 11c:	88 5a ff             	mov    %bl,-0x1(%edx)
 11f:	75 ef                	jne    110 <strcpy+0x10>
    ;
  return os;
}
 121:	5b                   	pop    %ebx
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    
 124:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 12a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	53                   	push   %ebx
 134:	8b 55 08             	mov    0x8(%ebp),%edx
 137:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 13a:	0f b6 02             	movzbl (%edx),%eax
 13d:	0f b6 19             	movzbl (%ecx),%ebx
 140:	84 c0                	test   %al,%al
 142:	75 1c                	jne    160 <strcmp+0x30>
 144:	eb 2a                	jmp    170 <strcmp+0x40>
 146:	8d 76 00             	lea    0x0(%esi),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 150:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 153:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 156:	83 c1 01             	add    $0x1,%ecx
 159:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 15c:	84 c0                	test   %al,%al
 15e:	74 10                	je     170 <strcmp+0x40>
 160:	38 d8                	cmp    %bl,%al
 162:	74 ec                	je     150 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 164:	29 d8                	sub    %ebx,%eax
}
 166:	5b                   	pop    %ebx
 167:	5d                   	pop    %ebp
 168:	c3                   	ret    
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 170:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 172:	29 d8                	sub    %ebx,%eax
}
 174:	5b                   	pop    %ebx
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    
 177:	89 f6                	mov    %esi,%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <strlen>:

uint
strlen(char *s)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 186:	80 39 00             	cmpb   $0x0,(%ecx)
 189:	74 15                	je     1a0 <strlen+0x20>
 18b:	31 d2                	xor    %edx,%edx
 18d:	8d 76 00             	lea    0x0(%esi),%esi
 190:	83 c2 01             	add    $0x1,%edx
 193:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 197:	89 d0                	mov    %edx,%eax
 199:	75 f5                	jne    190 <strlen+0x10>
    ;
  return n;
}
 19b:	5d                   	pop    %ebp
 19c:	c3                   	ret    
 19d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 1a0:	31 c0                	xor    %eax,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    
 1a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bd:	89 d7                	mov    %edx,%edi
 1bf:	fc                   	cld    
 1c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1c2:	89 d0                	mov    %edx,%eax
 1c4:	5f                   	pop    %edi
 1c5:	5d                   	pop    %ebp
 1c6:	c3                   	ret    
 1c7:	89 f6                	mov    %esi,%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	53                   	push   %ebx
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1da:	0f b6 10             	movzbl (%eax),%edx
 1dd:	84 d2                	test   %dl,%dl
 1df:	74 1d                	je     1fe <strchr+0x2e>
    if(*s == c)
 1e1:	38 d3                	cmp    %dl,%bl
 1e3:	89 d9                	mov    %ebx,%ecx
 1e5:	75 0d                	jne    1f4 <strchr+0x24>
 1e7:	eb 17                	jmp    200 <strchr+0x30>
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1f0:	38 ca                	cmp    %cl,%dl
 1f2:	74 0c                	je     200 <strchr+0x30>
  for(; *s; s++)
 1f4:	83 c0 01             	add    $0x1,%eax
 1f7:	0f b6 10             	movzbl (%eax),%edx
 1fa:	84 d2                	test   %dl,%dl
 1fc:	75 f2                	jne    1f0 <strchr+0x20>
      return (char*)s;
  return 0;
 1fe:	31 c0                	xor    %eax,%eax
}
 200:	5b                   	pop    %ebx
 201:	5d                   	pop    %ebp
 202:	c3                   	ret    
 203:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000210 <gets>:

char*
gets(char *buf, int max)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	56                   	push   %esi
 215:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 216:	31 f6                	xor    %esi,%esi
 218:	89 f3                	mov    %esi,%ebx
{
 21a:	83 ec 1c             	sub    $0x1c,%esp
 21d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 220:	eb 2f                	jmp    251 <gets+0x41>
 222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 228:	8d 45 e7             	lea    -0x19(%ebp),%eax
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	6a 01                	push   $0x1
 230:	50                   	push   %eax
 231:	6a 00                	push   $0x0
 233:	e8 32 01 00 00       	call   36a <read>
    if(cc < 1)
 238:	83 c4 10             	add    $0x10,%esp
 23b:	85 c0                	test   %eax,%eax
 23d:	7e 1c                	jle    25b <gets+0x4b>
      break;
    buf[i++] = c;
 23f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 243:	83 c7 01             	add    $0x1,%edi
 246:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 249:	3c 0a                	cmp    $0xa,%al
 24b:	74 23                	je     270 <gets+0x60>
 24d:	3c 0d                	cmp    $0xd,%al
 24f:	74 1f                	je     270 <gets+0x60>
  for(i=0; i+1 < max; ){
 251:	83 c3 01             	add    $0x1,%ebx
 254:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 257:	89 fe                	mov    %edi,%esi
 259:	7c cd                	jl     228 <gets+0x18>
 25b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 260:	c6 03 00             	movb   $0x0,(%ebx)
}
 263:	8d 65 f4             	lea    -0xc(%ebp),%esp
 266:	5b                   	pop    %ebx
 267:	5e                   	pop    %esi
 268:	5f                   	pop    %edi
 269:	5d                   	pop    %ebp
 26a:	c3                   	ret    
 26b:	90                   	nop
 26c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 270:	8b 75 08             	mov    0x8(%ebp),%esi
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	01 de                	add    %ebx,%esi
 278:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 27a:	c6 03 00             	movb   $0x0,(%ebx)
}
 27d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 280:	5b                   	pop    %ebx
 281:	5e                   	pop    %esi
 282:	5f                   	pop    %edi
 283:	5d                   	pop    %ebp
 284:	c3                   	ret    
 285:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000290 <stat>:

int
stat(char *n, struct stat *st)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	56                   	push   %esi
 294:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 295:	83 ec 08             	sub    $0x8,%esp
 298:	6a 00                	push   $0x0
 29a:	ff 75 08             	pushl  0x8(%ebp)
 29d:	e8 f0 00 00 00       	call   392 <open>
  if(fd < 0)
 2a2:	83 c4 10             	add    $0x10,%esp
 2a5:	85 c0                	test   %eax,%eax
 2a7:	78 27                	js     2d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 2a9:	83 ec 08             	sub    $0x8,%esp
 2ac:	ff 75 0c             	pushl  0xc(%ebp)
 2af:	89 c3                	mov    %eax,%ebx
 2b1:	50                   	push   %eax
 2b2:	e8 f3 00 00 00       	call   3aa <fstat>
  close(fd);
 2b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2ba:	89 c6                	mov    %eax,%esi
  close(fd);
 2bc:	e8 b9 00 00 00       	call   37a <close>
  return r;
 2c1:	83 c4 10             	add    $0x10,%esp
}
 2c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2c7:	89 f0                	mov    %esi,%eax
 2c9:	5b                   	pop    %ebx
 2ca:	5e                   	pop    %esi
 2cb:	5d                   	pop    %ebp
 2cc:	c3                   	ret    
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2d5:	eb ed                	jmp    2c4 <stat+0x34>
 2d7:	89 f6                	mov    %esi,%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002e0 <atoi>:

int
atoi(const char *s)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	53                   	push   %ebx
 2e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e7:	0f be 11             	movsbl (%ecx),%edx
 2ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 2ed:	3c 09                	cmp    $0x9,%al
  n = 0;
 2ef:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2f4:	77 1f                	ja     315 <atoi+0x35>
 2f6:	8d 76 00             	lea    0x0(%esi),%esi
 2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 300:	8d 04 80             	lea    (%eax,%eax,4),%eax
 303:	83 c1 01             	add    $0x1,%ecx
 306:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 30a:	0f be 11             	movsbl (%ecx),%edx
 30d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 310:	80 fb 09             	cmp    $0x9,%bl
 313:	76 eb                	jbe    300 <atoi+0x20>
  return n;
}
 315:	5b                   	pop    %ebx
 316:	5d                   	pop    %ebp
 317:	c3                   	ret    
 318:	90                   	nop
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000320 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	56                   	push   %esi
 324:	53                   	push   %ebx
 325:	8b 5d 10             	mov    0x10(%ebp),%ebx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 32e:	85 db                	test   %ebx,%ebx
 330:	7e 14                	jle    346 <memmove+0x26>
 332:	31 d2                	xor    %edx,%edx
 334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 338:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 33c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 33f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 342:	39 d3                	cmp    %edx,%ebx
 344:	75 f2                	jne    338 <memmove+0x18>
  return vdst;
}
 346:	5b                   	pop    %ebx
 347:	5e                   	pop    %esi
 348:	5d                   	pop    %ebp
 349:	c3                   	ret    

0000034a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34a:	b8 01 00 00 00       	mov    $0x1,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <exit>:
SYSCALL(exit)
 352:	b8 02 00 00 00       	mov    $0x2,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <wait>:
SYSCALL(wait)
 35a:	b8 03 00 00 00       	mov    $0x3,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <pipe>:
SYSCALL(pipe)
 362:	b8 04 00 00 00       	mov    $0x4,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <read>:
SYSCALL(read)
 36a:	b8 05 00 00 00       	mov    $0x5,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <write>:
SYSCALL(write)
 372:	b8 10 00 00 00       	mov    $0x10,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <close>:
SYSCALL(close)
 37a:	b8 15 00 00 00       	mov    $0x15,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <kill>:
SYSCALL(kill)
 382:	b8 06 00 00 00       	mov    $0x6,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <exec>:
SYSCALL(exec)
 38a:	b8 07 00 00 00       	mov    $0x7,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <open>:
SYSCALL(open)
 392:	b8 0f 00 00 00       	mov    $0xf,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <mknod>:
SYSCALL(mknod)
 39a:	b8 11 00 00 00       	mov    $0x11,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <unlink>:
SYSCALL(unlink)
 3a2:	b8 12 00 00 00       	mov    $0x12,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <fstat>:
SYSCALL(fstat)
 3aa:	b8 08 00 00 00       	mov    $0x8,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <link>:
SYSCALL(link)
 3b2:	b8 13 00 00 00       	mov    $0x13,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <mkdir>:
SYSCALL(mkdir)
 3ba:	b8 14 00 00 00       	mov    $0x14,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <chdir>:
SYSCALL(chdir)
 3c2:	b8 09 00 00 00       	mov    $0x9,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <dup>:
SYSCALL(dup)
 3ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <getpid>:
SYSCALL(getpid)
 3d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <sbrk>:
SYSCALL(sbrk)
 3da:	b8 0c 00 00 00       	mov    $0xc,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <sleep>:
SYSCALL(sleep)
 3e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <uptime>:
SYSCALL(uptime)
 3ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <getcpuid>:
SYSCALL(getcpuid)
 3f2:	b8 16 00 00 00       	mov    $0x16,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <changepri>:
SYSCALL(changepri)
 3fa:	b8 17 00 00 00       	mov    $0x17,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <sh_var_read>:
SYSCALL(sh_var_read)
 402:	b8 16 00 00 00       	mov    $0x16,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <sh_var_write>:
SYSCALL(sh_var_write)
 40a:	b8 17 00 00 00       	mov    $0x17,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <sem_create>:
SYSCALL(sem_create)
 412:	b8 18 00 00 00       	mov    $0x18,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <sem_free>:
SYSCALL(sem_free)
 41a:	b8 19 00 00 00       	mov    $0x19,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <sem_p>:
SYSCALL(sem_p)
 422:	b8 1a 00 00 00       	mov    $0x1a,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <sem_v>:
SYSCALL(sem_v)
 42a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <myMalloc>:
SYSCALL(myMalloc)
 432:	b8 1c 00 00 00       	mov    $0x1c,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <myFree>:
SYSCALL(myFree)
 43a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <myFork>:
SYSCALL(myFork)
 442:	b8 1e 00 00 00       	mov    $0x1e,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <join>:
SYSCALL(join)
 44a:	b8 1f 00 00 00       	mov    $0x1f,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <clone>:
SYSCALL(clone)
 452:	b8 20 00 00 00       	mov    $0x20,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <chmod>:
SYSCALL(chmod)
 45a:	b8 21 00 00 00       	mov    $0x21,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <open_fifo>:
 462:	b8 22 00 00 00       	mov    $0x22,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    
 46a:	66 90                	xchg   %ax,%ax
 46c:	66 90                	xchg   %ax,%ax
 46e:	66 90                	xchg   %ax,%ax

00000470 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 479:	85 d2                	test   %edx,%edx
{
 47b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 47e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 480:	79 76                	jns    4f8 <printint+0x88>
 482:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 486:	74 70                	je     4f8 <printint+0x88>
    x = -xx;
 488:	f7 d8                	neg    %eax
    neg = 1;
 48a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 491:	31 f6                	xor    %esi,%esi
 493:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 496:	eb 0a                	jmp    4a2 <printint+0x32>
 498:	90                   	nop
 499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 4a0:	89 fe                	mov    %edi,%esi
 4a2:	31 d2                	xor    %edx,%edx
 4a4:	8d 7e 01             	lea    0x1(%esi),%edi
 4a7:	f7 f1                	div    %ecx
 4a9:	0f b6 92 1c 09 00 00 	movzbl 0x91c(%edx),%edx
  }while((x /= base) != 0);
 4b0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 4b2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 4b5:	75 e9                	jne    4a0 <printint+0x30>
  if(neg)
 4b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4ba:	85 c0                	test   %eax,%eax
 4bc:	74 08                	je     4c6 <printint+0x56>
    buf[i++] = '-';
 4be:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 4c3:	8d 7e 02             	lea    0x2(%esi),%edi
 4c6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 4ca:	8b 7d c0             	mov    -0x40(%ebp),%edi
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
 4d0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 4d3:	83 ec 04             	sub    $0x4,%esp
 4d6:	83 ee 01             	sub    $0x1,%esi
 4d9:	6a 01                	push   $0x1
 4db:	53                   	push   %ebx
 4dc:	57                   	push   %edi
 4dd:	88 45 d7             	mov    %al,-0x29(%ebp)
 4e0:	e8 8d fe ff ff       	call   372 <write>

  while(--i >= 0)
 4e5:	83 c4 10             	add    $0x10,%esp
 4e8:	39 de                	cmp    %ebx,%esi
 4ea:	75 e4                	jne    4d0 <printint+0x60>
    putc(fd, buf[i]);
}
 4ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ef:	5b                   	pop    %ebx
 4f0:	5e                   	pop    %esi
 4f1:	5f                   	pop    %edi
 4f2:	5d                   	pop    %ebp
 4f3:	c3                   	ret    
 4f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4f8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 4ff:	eb 90                	jmp    491 <printint+0x21>
 501:	eb 0d                	jmp    510 <printf>
 503:	90                   	nop
 504:	90                   	nop
 505:	90                   	nop
 506:	90                   	nop
 507:	90                   	nop
 508:	90                   	nop
 509:	90                   	nop
 50a:	90                   	nop
 50b:	90                   	nop
 50c:	90                   	nop
 50d:	90                   	nop
 50e:	90                   	nop
 50f:	90                   	nop

00000510 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 519:	8b 75 0c             	mov    0xc(%ebp),%esi
 51c:	0f b6 1e             	movzbl (%esi),%ebx
 51f:	84 db                	test   %bl,%bl
 521:	0f 84 b3 00 00 00    	je     5da <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 527:	8d 45 10             	lea    0x10(%ebp),%eax
 52a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 52d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 52f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 532:	eb 2f                	jmp    563 <printf+0x53>
 534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 538:	83 f8 25             	cmp    $0x25,%eax
 53b:	0f 84 a7 00 00 00    	je     5e8 <printf+0xd8>
  write(fd, &c, 1);
 541:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 544:	83 ec 04             	sub    $0x4,%esp
 547:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 54a:	6a 01                	push   $0x1
 54c:	50                   	push   %eax
 54d:	ff 75 08             	pushl  0x8(%ebp)
 550:	e8 1d fe ff ff       	call   372 <write>
 555:	83 c4 10             	add    $0x10,%esp
 558:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 55b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 55f:	84 db                	test   %bl,%bl
 561:	74 77                	je     5da <printf+0xca>
    if(state == 0){
 563:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 565:	0f be cb             	movsbl %bl,%ecx
 568:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 56b:	74 cb                	je     538 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 56d:	83 ff 25             	cmp    $0x25,%edi
 570:	75 e6                	jne    558 <printf+0x48>
      if(c == 'd'){
 572:	83 f8 64             	cmp    $0x64,%eax
 575:	0f 84 05 01 00 00    	je     680 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 57b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 581:	83 f9 70             	cmp    $0x70,%ecx
 584:	74 72                	je     5f8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 586:	83 f8 73             	cmp    $0x73,%eax
 589:	0f 84 99 00 00 00    	je     628 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58f:	83 f8 63             	cmp    $0x63,%eax
 592:	0f 84 08 01 00 00    	je     6a0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 598:	83 f8 25             	cmp    $0x25,%eax
 59b:	0f 84 ef 00 00 00    	je     690 <printf+0x180>
  write(fd, &c, 1);
 5a1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5a4:	83 ec 04             	sub    $0x4,%esp
 5a7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5ab:	6a 01                	push   $0x1
 5ad:	50                   	push   %eax
 5ae:	ff 75 08             	pushl  0x8(%ebp)
 5b1:	e8 bc fd ff ff       	call   372 <write>
 5b6:	83 c4 0c             	add    $0xc,%esp
 5b9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5bc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 5bf:	6a 01                	push   $0x1
 5c1:	50                   	push   %eax
 5c2:	ff 75 08             	pushl  0x8(%ebp)
 5c5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 5ca:	e8 a3 fd ff ff       	call   372 <write>
  for(i = 0; fmt[i]; i++){
 5cf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 5d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5d6:	84 db                	test   %bl,%bl
 5d8:	75 89                	jne    563 <printf+0x53>
    }
  }
}
 5da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5dd:	5b                   	pop    %ebx
 5de:	5e                   	pop    %esi
 5df:	5f                   	pop    %edi
 5e0:	5d                   	pop    %ebp
 5e1:	c3                   	ret    
 5e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 5e8:	bf 25 00 00 00       	mov    $0x25,%edi
 5ed:	e9 66 ff ff ff       	jmp    558 <printf+0x48>
 5f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 5f8:	83 ec 0c             	sub    $0xc,%esp
 5fb:	b9 10 00 00 00       	mov    $0x10,%ecx
 600:	6a 00                	push   $0x0
 602:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 605:	8b 45 08             	mov    0x8(%ebp),%eax
 608:	8b 17                	mov    (%edi),%edx
 60a:	e8 61 fe ff ff       	call   470 <printint>
        ap++;
 60f:	89 f8                	mov    %edi,%eax
 611:	83 c4 10             	add    $0x10,%esp
      state = 0;
 614:	31 ff                	xor    %edi,%edi
        ap++;
 616:	83 c0 04             	add    $0x4,%eax
 619:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 61c:	e9 37 ff ff ff       	jmp    558 <printf+0x48>
 621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 628:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 62b:	8b 08                	mov    (%eax),%ecx
        ap++;
 62d:	83 c0 04             	add    $0x4,%eax
 630:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 633:	85 c9                	test   %ecx,%ecx
 635:	0f 84 8e 00 00 00    	je     6c9 <printf+0x1b9>
        while(*s != 0){
 63b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 63e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 640:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 642:	84 c0                	test   %al,%al
 644:	0f 84 0e ff ff ff    	je     558 <printf+0x48>
 64a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 64d:	89 de                	mov    %ebx,%esi
 64f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 652:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 655:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 658:	83 ec 04             	sub    $0x4,%esp
          s++;
 65b:	83 c6 01             	add    $0x1,%esi
 65e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 661:	6a 01                	push   $0x1
 663:	57                   	push   %edi
 664:	53                   	push   %ebx
 665:	e8 08 fd ff ff       	call   372 <write>
        while(*s != 0){
 66a:	0f b6 06             	movzbl (%esi),%eax
 66d:	83 c4 10             	add    $0x10,%esp
 670:	84 c0                	test   %al,%al
 672:	75 e4                	jne    658 <printf+0x148>
 674:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 677:	31 ff                	xor    %edi,%edi
 679:	e9 da fe ff ff       	jmp    558 <printf+0x48>
 67e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 680:	83 ec 0c             	sub    $0xc,%esp
 683:	b9 0a 00 00 00       	mov    $0xa,%ecx
 688:	6a 01                	push   $0x1
 68a:	e9 73 ff ff ff       	jmp    602 <printf+0xf2>
 68f:	90                   	nop
  write(fd, &c, 1);
 690:	83 ec 04             	sub    $0x4,%esp
 693:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 696:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 699:	6a 01                	push   $0x1
 69b:	e9 21 ff ff ff       	jmp    5c1 <printf+0xb1>
        putc(fd, *ap);
 6a0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 6a3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6a6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 6a8:	6a 01                	push   $0x1
        ap++;
 6aa:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 6ad:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 6b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6b3:	50                   	push   %eax
 6b4:	ff 75 08             	pushl  0x8(%ebp)
 6b7:	e8 b6 fc ff ff       	call   372 <write>
        ap++;
 6bc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 6bf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6c2:	31 ff                	xor    %edi,%edi
 6c4:	e9 8f fe ff ff       	jmp    558 <printf+0x48>
          s = "(null)";
 6c9:	bb 15 09 00 00       	mov    $0x915,%ebx
        while(*s != 0){
 6ce:	b8 28 00 00 00       	mov    $0x28,%eax
 6d3:	e9 72 ff ff ff       	jmp    64a <printf+0x13a>
 6d8:	66 90                	xchg   %ax,%ax
 6da:	66 90                	xchg   %ax,%ax
 6dc:	66 90                	xchg   %ax,%ax
 6de:	66 90                	xchg   %ax,%ax

000006e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	a1 c8 0b 00 00       	mov    0xbc8,%eax
{
 6e6:	89 e5                	mov    %esp,%ebp
 6e8:	57                   	push   %edi
 6e9:	56                   	push   %esi
 6ea:	53                   	push   %ebx
 6eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 6f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f8:	39 c8                	cmp    %ecx,%eax
 6fa:	8b 10                	mov    (%eax),%edx
 6fc:	73 32                	jae    730 <free+0x50>
 6fe:	39 d1                	cmp    %edx,%ecx
 700:	72 04                	jb     706 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 702:	39 d0                	cmp    %edx,%eax
 704:	72 32                	jb     738 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 706:	8b 73 fc             	mov    -0x4(%ebx),%esi
 709:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 70c:	39 fa                	cmp    %edi,%edx
 70e:	74 30                	je     740 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 710:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 713:	8b 50 04             	mov    0x4(%eax),%edx
 716:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 719:	39 f1                	cmp    %esi,%ecx
 71b:	74 3a                	je     757 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 71d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 71f:	a3 c8 0b 00 00       	mov    %eax,0xbc8
}
 724:	5b                   	pop    %ebx
 725:	5e                   	pop    %esi
 726:	5f                   	pop    %edi
 727:	5d                   	pop    %ebp
 728:	c3                   	ret    
 729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	39 d0                	cmp    %edx,%eax
 732:	72 04                	jb     738 <free+0x58>
 734:	39 d1                	cmp    %edx,%ecx
 736:	72 ce                	jb     706 <free+0x26>
{
 738:	89 d0                	mov    %edx,%eax
 73a:	eb bc                	jmp    6f8 <free+0x18>
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 740:	03 72 04             	add    0x4(%edx),%esi
 743:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 746:	8b 10                	mov    (%eax),%edx
 748:	8b 12                	mov    (%edx),%edx
 74a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 74d:	8b 50 04             	mov    0x4(%eax),%edx
 750:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 753:	39 f1                	cmp    %esi,%ecx
 755:	75 c6                	jne    71d <free+0x3d>
    p->s.size += bp->s.size;
 757:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 75a:	a3 c8 0b 00 00       	mov    %eax,0xbc8
    p->s.size += bp->s.size;
 75f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 762:	8b 53 f8             	mov    -0x8(%ebx),%edx
 765:	89 10                	mov    %edx,(%eax)
}
 767:	5b                   	pop    %ebx
 768:	5e                   	pop    %esi
 769:	5f                   	pop    %edi
 76a:	5d                   	pop    %ebp
 76b:	c3                   	ret    
 76c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000770 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
 776:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 779:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 77c:	8b 15 c8 0b 00 00    	mov    0xbc8,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 782:	8d 78 07             	lea    0x7(%eax),%edi
 785:	c1 ef 03             	shr    $0x3,%edi
 788:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 78b:	85 d2                	test   %edx,%edx
 78d:	0f 84 9d 00 00 00    	je     830 <malloc+0xc0>
 793:	8b 02                	mov    (%edx),%eax
 795:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 798:	39 cf                	cmp    %ecx,%edi
 79a:	76 6c                	jbe    808 <malloc+0x98>
 79c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 7a2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7a7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 7aa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7b1:	eb 0e                	jmp    7c1 <malloc+0x51>
 7b3:	90                   	nop
 7b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7ba:	8b 48 04             	mov    0x4(%eax),%ecx
 7bd:	39 f9                	cmp    %edi,%ecx
 7bf:	73 47                	jae    808 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c1:	39 05 c8 0b 00 00    	cmp    %eax,0xbc8
 7c7:	89 c2                	mov    %eax,%edx
 7c9:	75 ed                	jne    7b8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 7cb:	83 ec 0c             	sub    $0xc,%esp
 7ce:	56                   	push   %esi
 7cf:	e8 06 fc ff ff       	call   3da <sbrk>
  if(p == (char*)-1)
 7d4:	83 c4 10             	add    $0x10,%esp
 7d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 7da:	74 1c                	je     7f8 <malloc+0x88>
  hp->s.size = nu;
 7dc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7df:	83 ec 0c             	sub    $0xc,%esp
 7e2:	83 c0 08             	add    $0x8,%eax
 7e5:	50                   	push   %eax
 7e6:	e8 f5 fe ff ff       	call   6e0 <free>
  return freep;
 7eb:	8b 15 c8 0b 00 00    	mov    0xbc8,%edx
      if((p = morecore(nunits)) == 0)
 7f1:	83 c4 10             	add    $0x10,%esp
 7f4:	85 d2                	test   %edx,%edx
 7f6:	75 c0                	jne    7b8 <malloc+0x48>
        return 0;
  }
}
 7f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7fb:	31 c0                	xor    %eax,%eax
}
 7fd:	5b                   	pop    %ebx
 7fe:	5e                   	pop    %esi
 7ff:	5f                   	pop    %edi
 800:	5d                   	pop    %ebp
 801:	c3                   	ret    
 802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 808:	39 cf                	cmp    %ecx,%edi
 80a:	74 54                	je     860 <malloc+0xf0>
        p->s.size -= nunits;
 80c:	29 f9                	sub    %edi,%ecx
 80e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 811:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 814:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 817:	89 15 c8 0b 00 00    	mov    %edx,0xbc8
}
 81d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 820:	83 c0 08             	add    $0x8,%eax
}
 823:	5b                   	pop    %ebx
 824:	5e                   	pop    %esi
 825:	5f                   	pop    %edi
 826:	5d                   	pop    %ebp
 827:	c3                   	ret    
 828:	90                   	nop
 829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 830:	c7 05 c8 0b 00 00 cc 	movl   $0xbcc,0xbc8
 837:	0b 00 00 
 83a:	c7 05 cc 0b 00 00 cc 	movl   $0xbcc,0xbcc
 841:	0b 00 00 
    base.s.size = 0;
 844:	b8 cc 0b 00 00       	mov    $0xbcc,%eax
 849:	c7 05 d0 0b 00 00 00 	movl   $0x0,0xbd0
 850:	00 00 00 
 853:	e9 44 ff ff ff       	jmp    79c <malloc+0x2c>
 858:	90                   	nop
 859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 860:	8b 08                	mov    (%eax),%ecx
 862:	89 0a                	mov    %ecx,(%edx)
 864:	eb b1                	jmp    817 <malloc+0xa7>
