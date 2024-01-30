
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	8b 01                	mov    (%ecx),%eax
  15:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 2c                	jle    49 <main+0x49>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	pushl  (%ebx)
  2d:	83 c3 04             	add    $0x4,%ebx
  30:	e8 0b 02 00 00       	call   240 <atoi>
  35:	89 04 24             	mov    %eax,(%esp)
  38:	e8 a5 02 00 00       	call   2e2 <kill>
  for(i=1; i<argc; i++)
  3d:	83 c4 10             	add    $0x10,%esp
  40:	39 f3                	cmp    %esi,%ebx
  42:	75 e4                	jne    28 <main+0x28>
  exit();
  44:	e8 69 02 00 00       	call   2b2 <exit>
    printf(2, "usage: kill pid...\n");
  49:	50                   	push   %eax
  4a:	50                   	push   %eax
  4b:	68 a8 07 00 00       	push   $0x7a8
  50:	6a 02                	push   $0x2
  52:	e8 f9 03 00 00       	call   450 <printf>
    exit();
  57:	e8 56 02 00 00       	call   2b2 <exit>
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
  64:	8b 45 08             	mov    0x8(%ebp),%eax
  67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6a:	89 c2                	mov    %eax,%edx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  70:	83 c1 01             	add    $0x1,%ecx
  73:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  77:	83 c2 01             	add    $0x1,%edx
  7a:	84 db                	test   %bl,%bl
  7c:	88 5a ff             	mov    %bl,-0x1(%edx)
  7f:	75 ef                	jne    70 <strcpy+0x10>
    ;
  return os;
}
  81:	5b                   	pop    %ebx
  82:	5d                   	pop    %ebp
  83:	c3                   	ret    
  84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 55 08             	mov    0x8(%ebp),%edx
  97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  9a:	0f b6 02             	movzbl (%edx),%eax
  9d:	0f b6 19             	movzbl (%ecx),%ebx
  a0:	84 c0                	test   %al,%al
  a2:	75 1c                	jne    c0 <strcmp+0x30>
  a4:	eb 2a                	jmp    d0 <strcmp+0x40>
  a6:	8d 76 00             	lea    0x0(%esi),%esi
  a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  b0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  b3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  b6:	83 c1 01             	add    $0x1,%ecx
  b9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
  bc:	84 c0                	test   %al,%al
  be:	74 10                	je     d0 <strcmp+0x40>
  c0:	38 d8                	cmp    %bl,%al
  c2:	74 ec                	je     b0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  c4:	29 d8                	sub    %ebx,%eax
}
  c6:	5b                   	pop    %ebx
  c7:	5d                   	pop    %ebp
  c8:	c3                   	ret    
  c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  d0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  d2:	29 d8                	sub    %ebx,%eax
}
  d4:	5b                   	pop    %ebx
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    
  d7:	89 f6                	mov    %esi,%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <strlen>:

uint
strlen(char *s)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  e6:	80 39 00             	cmpb   $0x0,(%ecx)
  e9:	74 15                	je     100 <strlen+0x20>
  eb:	31 d2                	xor    %edx,%edx
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  f0:	83 c2 01             	add    $0x1,%edx
  f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  f7:	89 d0                	mov    %edx,%eax
  f9:	75 f5                	jne    f0 <strlen+0x10>
    ;
  return n;
}
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 100:	31 c0                	xor    %eax,%eax
}
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    
 104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 10a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 117:	8b 4d 10             	mov    0x10(%ebp),%ecx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 d7                	mov    %edx,%edi
 11f:	fc                   	cld    
 120:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 122:	89 d0                	mov    %edx,%eax
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    
 127:	89 f6                	mov    %esi,%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	53                   	push   %ebx
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 13a:	0f b6 10             	movzbl (%eax),%edx
 13d:	84 d2                	test   %dl,%dl
 13f:	74 1d                	je     15e <strchr+0x2e>
    if(*s == c)
 141:	38 d3                	cmp    %dl,%bl
 143:	89 d9                	mov    %ebx,%ecx
 145:	75 0d                	jne    154 <strchr+0x24>
 147:	eb 17                	jmp    160 <strchr+0x30>
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 150:	38 ca                	cmp    %cl,%dl
 152:	74 0c                	je     160 <strchr+0x30>
  for(; *s; s++)
 154:	83 c0 01             	add    $0x1,%eax
 157:	0f b6 10             	movzbl (%eax),%edx
 15a:	84 d2                	test   %dl,%dl
 15c:	75 f2                	jne    150 <strchr+0x20>
      return (char*)s;
  return 0;
 15e:	31 c0                	xor    %eax,%eax
}
 160:	5b                   	pop    %ebx
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000170 <gets>:

char*
gets(char *buf, int max)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	56                   	push   %esi
 175:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 176:	31 f6                	xor    %esi,%esi
 178:	89 f3                	mov    %esi,%ebx
{
 17a:	83 ec 1c             	sub    $0x1c,%esp
 17d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 180:	eb 2f                	jmp    1b1 <gets+0x41>
 182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 188:	8d 45 e7             	lea    -0x19(%ebp),%eax
 18b:	83 ec 04             	sub    $0x4,%esp
 18e:	6a 01                	push   $0x1
 190:	50                   	push   %eax
 191:	6a 00                	push   $0x0
 193:	e8 32 01 00 00       	call   2ca <read>
    if(cc < 1)
 198:	83 c4 10             	add    $0x10,%esp
 19b:	85 c0                	test   %eax,%eax
 19d:	7e 1c                	jle    1bb <gets+0x4b>
      break;
    buf[i++] = c;
 19f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a3:	83 c7 01             	add    $0x1,%edi
 1a6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 1a9:	3c 0a                	cmp    $0xa,%al
 1ab:	74 23                	je     1d0 <gets+0x60>
 1ad:	3c 0d                	cmp    $0xd,%al
 1af:	74 1f                	je     1d0 <gets+0x60>
  for(i=0; i+1 < max; ){
 1b1:	83 c3 01             	add    $0x1,%ebx
 1b4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1b7:	89 fe                	mov    %edi,%esi
 1b9:	7c cd                	jl     188 <gets+0x18>
 1bb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 1c0:	c6 03 00             	movb   $0x0,(%ebx)
}
 1c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c6:	5b                   	pop    %ebx
 1c7:	5e                   	pop    %esi
 1c8:	5f                   	pop    %edi
 1c9:	5d                   	pop    %ebp
 1ca:	c3                   	ret    
 1cb:	90                   	nop
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d0:	8b 75 08             	mov    0x8(%ebp),%esi
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	01 de                	add    %ebx,%esi
 1d8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 1da:	c6 03 00             	movb   $0x0,(%ebx)
}
 1dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e0:	5b                   	pop    %ebx
 1e1:	5e                   	pop    %esi
 1e2:	5f                   	pop    %edi
 1e3:	5d                   	pop    %ebp
 1e4:	c3                   	ret    
 1e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <stat>:

int
stat(char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	6a 00                	push   $0x0
 1fa:	ff 75 08             	pushl  0x8(%ebp)
 1fd:	e8 f0 00 00 00       	call   2f2 <open>
  if(fd < 0)
 202:	83 c4 10             	add    $0x10,%esp
 205:	85 c0                	test   %eax,%eax
 207:	78 27                	js     230 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 209:	83 ec 08             	sub    $0x8,%esp
 20c:	ff 75 0c             	pushl  0xc(%ebp)
 20f:	89 c3                	mov    %eax,%ebx
 211:	50                   	push   %eax
 212:	e8 f3 00 00 00       	call   30a <fstat>
  close(fd);
 217:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 21a:	89 c6                	mov    %eax,%esi
  close(fd);
 21c:	e8 b9 00 00 00       	call   2da <close>
  return r;
 221:	83 c4 10             	add    $0x10,%esp
}
 224:	8d 65 f8             	lea    -0x8(%ebp),%esp
 227:	89 f0                	mov    %esi,%eax
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 230:	be ff ff ff ff       	mov    $0xffffffff,%esi
 235:	eb ed                	jmp    224 <stat+0x34>
 237:	89 f6                	mov    %esi,%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000240 <atoi>:

int
atoi(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 247:	0f be 11             	movsbl (%ecx),%edx
 24a:	8d 42 d0             	lea    -0x30(%edx),%eax
 24d:	3c 09                	cmp    $0x9,%al
  n = 0;
 24f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 254:	77 1f                	ja     275 <atoi+0x35>
 256:	8d 76 00             	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 260:	8d 04 80             	lea    (%eax,%eax,4),%eax
 263:	83 c1 01             	add    $0x1,%ecx
 266:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 26a:	0f be 11             	movsbl (%ecx),%edx
 26d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 270:	80 fb 09             	cmp    $0x9,%bl
 273:	76 eb                	jbe    260 <atoi+0x20>
  return n;
}
 275:	5b                   	pop    %ebx
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    
 278:	90                   	nop
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000280 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
 285:	8b 5d 10             	mov    0x10(%ebp),%ebx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28e:	85 db                	test   %ebx,%ebx
 290:	7e 14                	jle    2a6 <memmove+0x26>
 292:	31 d2                	xor    %edx,%edx
 294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 298:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 29c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 29f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2a2:	39 d3                	cmp    %edx,%ebx
 2a4:	75 f2                	jne    298 <memmove+0x18>
  return vdst;
}
 2a6:	5b                   	pop    %ebx
 2a7:	5e                   	pop    %esi
 2a8:	5d                   	pop    %ebp
 2a9:	c3                   	ret    

000002aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2aa:	b8 01 00 00 00       	mov    $0x1,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <exit>:
SYSCALL(exit)
 2b2:	b8 02 00 00 00       	mov    $0x2,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <wait>:
SYSCALL(wait)
 2ba:	b8 03 00 00 00       	mov    $0x3,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <pipe>:
SYSCALL(pipe)
 2c2:	b8 04 00 00 00       	mov    $0x4,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <read>:
SYSCALL(read)
 2ca:	b8 05 00 00 00       	mov    $0x5,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <write>:
SYSCALL(write)
 2d2:	b8 10 00 00 00       	mov    $0x10,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <close>:
SYSCALL(close)
 2da:	b8 15 00 00 00       	mov    $0x15,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <kill>:
SYSCALL(kill)
 2e2:	b8 06 00 00 00       	mov    $0x6,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <exec>:
SYSCALL(exec)
 2ea:	b8 07 00 00 00       	mov    $0x7,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <open>:
SYSCALL(open)
 2f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <mknod>:
SYSCALL(mknod)
 2fa:	b8 11 00 00 00       	mov    $0x11,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <unlink>:
SYSCALL(unlink)
 302:	b8 12 00 00 00       	mov    $0x12,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <fstat>:
SYSCALL(fstat)
 30a:	b8 08 00 00 00       	mov    $0x8,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <link>:
SYSCALL(link)
 312:	b8 13 00 00 00       	mov    $0x13,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <mkdir>:
SYSCALL(mkdir)
 31a:	b8 14 00 00 00       	mov    $0x14,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <chdir>:
SYSCALL(chdir)
 322:	b8 09 00 00 00       	mov    $0x9,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <dup>:
SYSCALL(dup)
 32a:	b8 0a 00 00 00       	mov    $0xa,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <getpid>:
SYSCALL(getpid)
 332:	b8 0b 00 00 00       	mov    $0xb,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <sbrk>:
SYSCALL(sbrk)
 33a:	b8 0c 00 00 00       	mov    $0xc,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <sleep>:
SYSCALL(sleep)
 342:	b8 0d 00 00 00       	mov    $0xd,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <uptime>:
SYSCALL(uptime)
 34a:	b8 0e 00 00 00       	mov    $0xe,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <getcpuid>:
SYSCALL(getcpuid)
 352:	b8 16 00 00 00       	mov    $0x16,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <changepri>:
SYSCALL(changepri)
 35a:	b8 17 00 00 00       	mov    $0x17,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <sh_var_read>:
SYSCALL(sh_var_read)
 362:	b8 16 00 00 00       	mov    $0x16,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <sh_var_write>:
SYSCALL(sh_var_write)
 36a:	b8 17 00 00 00       	mov    $0x17,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <sem_create>:
SYSCALL(sem_create)
 372:	b8 18 00 00 00       	mov    $0x18,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <sem_free>:
SYSCALL(sem_free)
 37a:	b8 19 00 00 00       	mov    $0x19,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <sem_p>:
SYSCALL(sem_p)
 382:	b8 1a 00 00 00       	mov    $0x1a,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <sem_v>:
SYSCALL(sem_v)
 38a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <myMalloc>:
SYSCALL(myMalloc)
 392:	b8 1c 00 00 00       	mov    $0x1c,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <myFree>:
SYSCALL(myFree)
 39a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <myFork>:
 3a2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    
 3aa:	66 90                	xchg   %ax,%ax
 3ac:	66 90                	xchg   %ax,%ax
 3ae:	66 90                	xchg   %ax,%ax

000003b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b9:	85 d2                	test   %edx,%edx
{
 3bb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 3be:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 3c0:	79 76                	jns    438 <printint+0x88>
 3c2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3c6:	74 70                	je     438 <printint+0x88>
    x = -xx;
 3c8:	f7 d8                	neg    %eax
    neg = 1;
 3ca:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3d1:	31 f6                	xor    %esi,%esi
 3d3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3d6:	eb 0a                	jmp    3e2 <printint+0x32>
 3d8:	90                   	nop
 3d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 3e0:	89 fe                	mov    %edi,%esi
 3e2:	31 d2                	xor    %edx,%edx
 3e4:	8d 7e 01             	lea    0x1(%esi),%edi
 3e7:	f7 f1                	div    %ecx
 3e9:	0f b6 92 c4 07 00 00 	movzbl 0x7c4(%edx),%edx
  }while((x /= base) != 0);
 3f0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 3f2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 3f5:	75 e9                	jne    3e0 <printint+0x30>
  if(neg)
 3f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3fa:	85 c0                	test   %eax,%eax
 3fc:	74 08                	je     406 <printint+0x56>
    buf[i++] = '-';
 3fe:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 403:	8d 7e 02             	lea    0x2(%esi),%edi
 406:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 40a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 40d:	8d 76 00             	lea    0x0(%esi),%esi
 410:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 413:	83 ec 04             	sub    $0x4,%esp
 416:	83 ee 01             	sub    $0x1,%esi
 419:	6a 01                	push   $0x1
 41b:	53                   	push   %ebx
 41c:	57                   	push   %edi
 41d:	88 45 d7             	mov    %al,-0x29(%ebp)
 420:	e8 ad fe ff ff       	call   2d2 <write>

  while(--i >= 0)
 425:	83 c4 10             	add    $0x10,%esp
 428:	39 de                	cmp    %ebx,%esi
 42a:	75 e4                	jne    410 <printint+0x60>
    putc(fd, buf[i]);
}
 42c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42f:	5b                   	pop    %ebx
 430:	5e                   	pop    %esi
 431:	5f                   	pop    %edi
 432:	5d                   	pop    %ebp
 433:	c3                   	ret    
 434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 438:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 43f:	eb 90                	jmp    3d1 <printint+0x21>
 441:	eb 0d                	jmp    450 <printf>
 443:	90                   	nop
 444:	90                   	nop
 445:	90                   	nop
 446:	90                   	nop
 447:	90                   	nop
 448:	90                   	nop
 449:	90                   	nop
 44a:	90                   	nop
 44b:	90                   	nop
 44c:	90                   	nop
 44d:	90                   	nop
 44e:	90                   	nop
 44f:	90                   	nop

00000450 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 459:	8b 75 0c             	mov    0xc(%ebp),%esi
 45c:	0f b6 1e             	movzbl (%esi),%ebx
 45f:	84 db                	test   %bl,%bl
 461:	0f 84 b3 00 00 00    	je     51a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 467:	8d 45 10             	lea    0x10(%ebp),%eax
 46a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 46d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 46f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 472:	eb 2f                	jmp    4a3 <printf+0x53>
 474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 478:	83 f8 25             	cmp    $0x25,%eax
 47b:	0f 84 a7 00 00 00    	je     528 <printf+0xd8>
  write(fd, &c, 1);
 481:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 484:	83 ec 04             	sub    $0x4,%esp
 487:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 48a:	6a 01                	push   $0x1
 48c:	50                   	push   %eax
 48d:	ff 75 08             	pushl  0x8(%ebp)
 490:	e8 3d fe ff ff       	call   2d2 <write>
 495:	83 c4 10             	add    $0x10,%esp
 498:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 49b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 49f:	84 db                	test   %bl,%bl
 4a1:	74 77                	je     51a <printf+0xca>
    if(state == 0){
 4a3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 4a5:	0f be cb             	movsbl %bl,%ecx
 4a8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4ab:	74 cb                	je     478 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ad:	83 ff 25             	cmp    $0x25,%edi
 4b0:	75 e6                	jne    498 <printf+0x48>
      if(c == 'd'){
 4b2:	83 f8 64             	cmp    $0x64,%eax
 4b5:	0f 84 05 01 00 00    	je     5c0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4bb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4c1:	83 f9 70             	cmp    $0x70,%ecx
 4c4:	74 72                	je     538 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4c6:	83 f8 73             	cmp    $0x73,%eax
 4c9:	0f 84 99 00 00 00    	je     568 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4cf:	83 f8 63             	cmp    $0x63,%eax
 4d2:	0f 84 08 01 00 00    	je     5e0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4d8:	83 f8 25             	cmp    $0x25,%eax
 4db:	0f 84 ef 00 00 00    	je     5d0 <printf+0x180>
  write(fd, &c, 1);
 4e1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4e4:	83 ec 04             	sub    $0x4,%esp
 4e7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4eb:	6a 01                	push   $0x1
 4ed:	50                   	push   %eax
 4ee:	ff 75 08             	pushl  0x8(%ebp)
 4f1:	e8 dc fd ff ff       	call   2d2 <write>
 4f6:	83 c4 0c             	add    $0xc,%esp
 4f9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4fc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4ff:	6a 01                	push   $0x1
 501:	50                   	push   %eax
 502:	ff 75 08             	pushl  0x8(%ebp)
 505:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 508:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 50a:	e8 c3 fd ff ff       	call   2d2 <write>
  for(i = 0; fmt[i]; i++){
 50f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 513:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 516:	84 db                	test   %bl,%bl
 518:	75 89                	jne    4a3 <printf+0x53>
    }
  }
}
 51a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 51d:	5b                   	pop    %ebx
 51e:	5e                   	pop    %esi
 51f:	5f                   	pop    %edi
 520:	5d                   	pop    %ebp
 521:	c3                   	ret    
 522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 528:	bf 25 00 00 00       	mov    $0x25,%edi
 52d:	e9 66 ff ff ff       	jmp    498 <printf+0x48>
 532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 538:	83 ec 0c             	sub    $0xc,%esp
 53b:	b9 10 00 00 00       	mov    $0x10,%ecx
 540:	6a 00                	push   $0x0
 542:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 545:	8b 45 08             	mov    0x8(%ebp),%eax
 548:	8b 17                	mov    (%edi),%edx
 54a:	e8 61 fe ff ff       	call   3b0 <printint>
        ap++;
 54f:	89 f8                	mov    %edi,%eax
 551:	83 c4 10             	add    $0x10,%esp
      state = 0;
 554:	31 ff                	xor    %edi,%edi
        ap++;
 556:	83 c0 04             	add    $0x4,%eax
 559:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 55c:	e9 37 ff ff ff       	jmp    498 <printf+0x48>
 561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 568:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 56b:	8b 08                	mov    (%eax),%ecx
        ap++;
 56d:	83 c0 04             	add    $0x4,%eax
 570:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 573:	85 c9                	test   %ecx,%ecx
 575:	0f 84 8e 00 00 00    	je     609 <printf+0x1b9>
        while(*s != 0){
 57b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 57e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 580:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 582:	84 c0                	test   %al,%al
 584:	0f 84 0e ff ff ff    	je     498 <printf+0x48>
 58a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 58d:	89 de                	mov    %ebx,%esi
 58f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 592:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 595:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 598:	83 ec 04             	sub    $0x4,%esp
          s++;
 59b:	83 c6 01             	add    $0x1,%esi
 59e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 5a1:	6a 01                	push   $0x1
 5a3:	57                   	push   %edi
 5a4:	53                   	push   %ebx
 5a5:	e8 28 fd ff ff       	call   2d2 <write>
        while(*s != 0){
 5aa:	0f b6 06             	movzbl (%esi),%eax
 5ad:	83 c4 10             	add    $0x10,%esp
 5b0:	84 c0                	test   %al,%al
 5b2:	75 e4                	jne    598 <printf+0x148>
 5b4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 5b7:	31 ff                	xor    %edi,%edi
 5b9:	e9 da fe ff ff       	jmp    498 <printf+0x48>
 5be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 5c0:	83 ec 0c             	sub    $0xc,%esp
 5c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5c8:	6a 01                	push   $0x1
 5ca:	e9 73 ff ff ff       	jmp    542 <printf+0xf2>
 5cf:	90                   	nop
  write(fd, &c, 1);
 5d0:	83 ec 04             	sub    $0x4,%esp
 5d3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5d6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5d9:	6a 01                	push   $0x1
 5db:	e9 21 ff ff ff       	jmp    501 <printf+0xb1>
        putc(fd, *ap);
 5e0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 5e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5e6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 5e8:	6a 01                	push   $0x1
        ap++;
 5ea:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 5ed:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5f3:	50                   	push   %eax
 5f4:	ff 75 08             	pushl  0x8(%ebp)
 5f7:	e8 d6 fc ff ff       	call   2d2 <write>
        ap++;
 5fc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5ff:	83 c4 10             	add    $0x10,%esp
      state = 0;
 602:	31 ff                	xor    %edi,%edi
 604:	e9 8f fe ff ff       	jmp    498 <printf+0x48>
          s = "(null)";
 609:	bb bc 07 00 00       	mov    $0x7bc,%ebx
        while(*s != 0){
 60e:	b8 28 00 00 00       	mov    $0x28,%eax
 613:	e9 72 ff ff ff       	jmp    58a <printf+0x13a>
 618:	66 90                	xchg   %ax,%ax
 61a:	66 90                	xchg   %ax,%ax
 61c:	66 90                	xchg   %ax,%ax
 61e:	66 90                	xchg   %ax,%ax

00000620 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 620:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	a1 70 0a 00 00       	mov    0xa70,%eax
{
 626:	89 e5                	mov    %esp,%ebp
 628:	57                   	push   %edi
 629:	56                   	push   %esi
 62a:	53                   	push   %ebx
 62b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 62e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 638:	39 c8                	cmp    %ecx,%eax
 63a:	8b 10                	mov    (%eax),%edx
 63c:	73 32                	jae    670 <free+0x50>
 63e:	39 d1                	cmp    %edx,%ecx
 640:	72 04                	jb     646 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 642:	39 d0                	cmp    %edx,%eax
 644:	72 32                	jb     678 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 646:	8b 73 fc             	mov    -0x4(%ebx),%esi
 649:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 64c:	39 fa                	cmp    %edi,%edx
 64e:	74 30                	je     680 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 650:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 653:	8b 50 04             	mov    0x4(%eax),%edx
 656:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 659:	39 f1                	cmp    %esi,%ecx
 65b:	74 3a                	je     697 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 65d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 65f:	a3 70 0a 00 00       	mov    %eax,0xa70
}
 664:	5b                   	pop    %ebx
 665:	5e                   	pop    %esi
 666:	5f                   	pop    %edi
 667:	5d                   	pop    %ebp
 668:	c3                   	ret    
 669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 670:	39 d0                	cmp    %edx,%eax
 672:	72 04                	jb     678 <free+0x58>
 674:	39 d1                	cmp    %edx,%ecx
 676:	72 ce                	jb     646 <free+0x26>
{
 678:	89 d0                	mov    %edx,%eax
 67a:	eb bc                	jmp    638 <free+0x18>
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 680:	03 72 04             	add    0x4(%edx),%esi
 683:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 686:	8b 10                	mov    (%eax),%edx
 688:	8b 12                	mov    (%edx),%edx
 68a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 68d:	8b 50 04             	mov    0x4(%eax),%edx
 690:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 693:	39 f1                	cmp    %esi,%ecx
 695:	75 c6                	jne    65d <free+0x3d>
    p->s.size += bp->s.size;
 697:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 69a:	a3 70 0a 00 00       	mov    %eax,0xa70
    p->s.size += bp->s.size;
 69f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6a5:	89 10                	mov    %edx,(%eax)
}
 6a7:	5b                   	pop    %ebx
 6a8:	5e                   	pop    %esi
 6a9:	5f                   	pop    %edi
 6aa:	5d                   	pop    %ebp
 6ab:	c3                   	ret    
 6ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6bc:	8b 15 70 0a 00 00    	mov    0xa70,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c2:	8d 78 07             	lea    0x7(%eax),%edi
 6c5:	c1 ef 03             	shr    $0x3,%edi
 6c8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6cb:	85 d2                	test   %edx,%edx
 6cd:	0f 84 9d 00 00 00    	je     770 <malloc+0xc0>
 6d3:	8b 02                	mov    (%edx),%eax
 6d5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6d8:	39 cf                	cmp    %ecx,%edi
 6da:	76 6c                	jbe    748 <malloc+0x98>
 6dc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6e2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6e7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6ea:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6f1:	eb 0e                	jmp    701 <malloc+0x51>
 6f3:	90                   	nop
 6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6fa:	8b 48 04             	mov    0x4(%eax),%ecx
 6fd:	39 f9                	cmp    %edi,%ecx
 6ff:	73 47                	jae    748 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 701:	39 05 70 0a 00 00    	cmp    %eax,0xa70
 707:	89 c2                	mov    %eax,%edx
 709:	75 ed                	jne    6f8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 70b:	83 ec 0c             	sub    $0xc,%esp
 70e:	56                   	push   %esi
 70f:	e8 26 fc ff ff       	call   33a <sbrk>
  if(p == (char*)-1)
 714:	83 c4 10             	add    $0x10,%esp
 717:	83 f8 ff             	cmp    $0xffffffff,%eax
 71a:	74 1c                	je     738 <malloc+0x88>
  hp->s.size = nu;
 71c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 71f:	83 ec 0c             	sub    $0xc,%esp
 722:	83 c0 08             	add    $0x8,%eax
 725:	50                   	push   %eax
 726:	e8 f5 fe ff ff       	call   620 <free>
  return freep;
 72b:	8b 15 70 0a 00 00    	mov    0xa70,%edx
      if((p = morecore(nunits)) == 0)
 731:	83 c4 10             	add    $0x10,%esp
 734:	85 d2                	test   %edx,%edx
 736:	75 c0                	jne    6f8 <malloc+0x48>
        return 0;
  }
}
 738:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 73b:	31 c0                	xor    %eax,%eax
}
 73d:	5b                   	pop    %ebx
 73e:	5e                   	pop    %esi
 73f:	5f                   	pop    %edi
 740:	5d                   	pop    %ebp
 741:	c3                   	ret    
 742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 748:	39 cf                	cmp    %ecx,%edi
 74a:	74 54                	je     7a0 <malloc+0xf0>
        p->s.size -= nunits;
 74c:	29 f9                	sub    %edi,%ecx
 74e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 751:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 754:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 757:	89 15 70 0a 00 00    	mov    %edx,0xa70
}
 75d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 760:	83 c0 08             	add    $0x8,%eax
}
 763:	5b                   	pop    %ebx
 764:	5e                   	pop    %esi
 765:	5f                   	pop    %edi
 766:	5d                   	pop    %ebp
 767:	c3                   	ret    
 768:	90                   	nop
 769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 770:	c7 05 70 0a 00 00 74 	movl   $0xa74,0xa70
 777:	0a 00 00 
 77a:	c7 05 74 0a 00 00 74 	movl   $0xa74,0xa74
 781:	0a 00 00 
    base.s.size = 0;
 784:	b8 74 0a 00 00       	mov    $0xa74,%eax
 789:	c7 05 78 0a 00 00 00 	movl   $0x0,0xa78
 790:	00 00 00 
 793:	e9 44 ff ff ff       	jmp    6dc <malloc+0x2c>
 798:	90                   	nop
 799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 7a0:	8b 08                	mov    (%eax),%ecx
 7a2:	89 0a                	mov    %ecx,(%edx)
 7a4:	eb b1                	jmp    757 <malloc+0xa7>
