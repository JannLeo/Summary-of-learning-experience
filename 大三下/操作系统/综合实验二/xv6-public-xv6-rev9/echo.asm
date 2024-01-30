
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
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

  for(i = 1; i < argc; i++)
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 3f                	jle    5c <main+0x5c>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	eb 18                	jmp    3d <main+0x3d>
  25:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  28:	68 d8 07 00 00       	push   $0x7d8
  2d:	50                   	push   %eax
  2e:	68 da 07 00 00       	push   $0x7da
  33:	6a 01                	push   $0x1
  35:	e8 46 04 00 00       	call   480 <printf>
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	83 c3 04             	add    $0x4,%ebx
  40:	8b 43 fc             	mov    -0x4(%ebx),%eax
  43:	39 f3                	cmp    %esi,%ebx
  45:	75 e1                	jne    28 <main+0x28>
  47:	68 df 07 00 00       	push   $0x7df
  4c:	50                   	push   %eax
  4d:	68 da 07 00 00       	push   $0x7da
  52:	6a 01                	push   $0x1
  54:	e8 27 04 00 00       	call   480 <printf>
  59:	83 c4 10             	add    $0x10,%esp
  exit();
  5c:	e8 61 02 00 00       	call   2c2 <exit>
  61:	66 90                	xchg   %ax,%ax
  63:	66 90                	xchg   %ax,%ax
  65:	66 90                	xchg   %ax,%ax
  67:	66 90                	xchg   %ax,%ax
  69:	66 90                	xchg   %ax,%ax
  6b:	66 90                	xchg   %ax,%ax
  6d:	66 90                	xchg   %ax,%ax
  6f:	90                   	nop

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	8b 45 08             	mov    0x8(%ebp),%eax
  77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	89 c2                	mov    %eax,%edx
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  80:	83 c1 01             	add    $0x1,%ecx
  83:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  87:	83 c2 01             	add    $0x1,%edx
  8a:	84 db                	test   %bl,%bl
  8c:	88 5a ff             	mov    %bl,-0x1(%edx)
  8f:	75 ef                	jne    80 <strcpy+0x10>
    ;
  return os;
}
  91:	5b                   	pop    %ebx
  92:	5d                   	pop    %ebp
  93:	c3                   	ret    
  94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	53                   	push   %ebx
  a4:	8b 55 08             	mov    0x8(%ebp),%edx
  a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  aa:	0f b6 02             	movzbl (%edx),%eax
  ad:	0f b6 19             	movzbl (%ecx),%ebx
  b0:	84 c0                	test   %al,%al
  b2:	75 1c                	jne    d0 <strcmp+0x30>
  b4:	eb 2a                	jmp    e0 <strcmp+0x40>
  b6:	8d 76 00             	lea    0x0(%esi),%esi
  b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  c0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  c3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  c6:	83 c1 01             	add    $0x1,%ecx
  c9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
  cc:	84 c0                	test   %al,%al
  ce:	74 10                	je     e0 <strcmp+0x40>
  d0:	38 d8                	cmp    %bl,%al
  d2:	74 ec                	je     c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  d4:	29 d8                	sub    %ebx,%eax
}
  d6:	5b                   	pop    %ebx
  d7:	5d                   	pop    %ebp
  d8:	c3                   	ret    
  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  e2:	29 d8                	sub    %ebx,%eax
}
  e4:	5b                   	pop    %ebx
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    
  e7:	89 f6                	mov    %esi,%esi
  e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000f0 <strlen>:

uint
strlen(char *s)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  f6:	80 39 00             	cmpb   $0x0,(%ecx)
  f9:	74 15                	je     110 <strlen+0x20>
  fb:	31 d2                	xor    %edx,%edx
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	83 c2 01             	add    $0x1,%edx
 103:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 107:	89 d0                	mov    %edx,%eax
 109:	75 f5                	jne    100 <strlen+0x10>
    ;
  return n;
}
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    
 10d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 110:	31 c0                	xor    %eax,%eax
}
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    
 114:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 11a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 d7                	mov    %edx,%edi
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	89 d0                	mov    %edx,%eax
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	89 f6                	mov    %esi,%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	53                   	push   %ebx
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	74 1d                	je     16e <strchr+0x2e>
    if(*s == c)
 151:	38 d3                	cmp    %dl,%bl
 153:	89 d9                	mov    %ebx,%ecx
 155:	75 0d                	jne    164 <strchr+0x24>
 157:	eb 17                	jmp    170 <strchr+0x30>
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 160:	38 ca                	cmp    %cl,%dl
 162:	74 0c                	je     170 <strchr+0x30>
  for(; *s; s++)
 164:	83 c0 01             	add    $0x1,%eax
 167:	0f b6 10             	movzbl (%eax),%edx
 16a:	84 d2                	test   %dl,%dl
 16c:	75 f2                	jne    160 <strchr+0x20>
      return (char*)s;
  return 0;
 16e:	31 c0                	xor    %eax,%eax
}
 170:	5b                   	pop    %ebx
 171:	5d                   	pop    %ebp
 172:	c3                   	ret    
 173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
 185:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	31 f6                	xor    %esi,%esi
 188:	89 f3                	mov    %esi,%ebx
{
 18a:	83 ec 1c             	sub    $0x1c,%esp
 18d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 190:	eb 2f                	jmp    1c1 <gets+0x41>
 192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 198:	8d 45 e7             	lea    -0x19(%ebp),%eax
 19b:	83 ec 04             	sub    $0x4,%esp
 19e:	6a 01                	push   $0x1
 1a0:	50                   	push   %eax
 1a1:	6a 00                	push   $0x0
 1a3:	e8 32 01 00 00       	call   2da <read>
    if(cc < 1)
 1a8:	83 c4 10             	add    $0x10,%esp
 1ab:	85 c0                	test   %eax,%eax
 1ad:	7e 1c                	jle    1cb <gets+0x4b>
      break;
    buf[i++] = c;
 1af:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1b3:	83 c7 01             	add    $0x1,%edi
 1b6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 1b9:	3c 0a                	cmp    $0xa,%al
 1bb:	74 23                	je     1e0 <gets+0x60>
 1bd:	3c 0d                	cmp    $0xd,%al
 1bf:	74 1f                	je     1e0 <gets+0x60>
  for(i=0; i+1 < max; ){
 1c1:	83 c3 01             	add    $0x1,%ebx
 1c4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1c7:	89 fe                	mov    %edi,%esi
 1c9:	7c cd                	jl     198 <gets+0x18>
 1cb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 1d0:	c6 03 00             	movb   $0x0,(%ebx)
}
 1d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1d6:	5b                   	pop    %ebx
 1d7:	5e                   	pop    %esi
 1d8:	5f                   	pop    %edi
 1d9:	5d                   	pop    %ebp
 1da:	c3                   	ret    
 1db:	90                   	nop
 1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e0:	8b 75 08             	mov    0x8(%ebp),%esi
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	01 de                	add    %ebx,%esi
 1e8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 1ea:	c6 03 00             	movb   $0x0,(%ebx)
}
 1ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f0:	5b                   	pop    %ebx
 1f1:	5e                   	pop    %esi
 1f2:	5f                   	pop    %edi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    
 1f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000200 <stat>:

int
stat(char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	56                   	push   %esi
 204:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 205:	83 ec 08             	sub    $0x8,%esp
 208:	6a 00                	push   $0x0
 20a:	ff 75 08             	pushl  0x8(%ebp)
 20d:	e8 f0 00 00 00       	call   302 <open>
  if(fd < 0)
 212:	83 c4 10             	add    $0x10,%esp
 215:	85 c0                	test   %eax,%eax
 217:	78 27                	js     240 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	ff 75 0c             	pushl  0xc(%ebp)
 21f:	89 c3                	mov    %eax,%ebx
 221:	50                   	push   %eax
 222:	e8 f3 00 00 00       	call   31a <fstat>
  close(fd);
 227:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 22a:	89 c6                	mov    %eax,%esi
  close(fd);
 22c:	e8 b9 00 00 00       	call   2ea <close>
  return r;
 231:	83 c4 10             	add    $0x10,%esp
}
 234:	8d 65 f8             	lea    -0x8(%ebp),%esp
 237:	89 f0                	mov    %esi,%eax
 239:	5b                   	pop    %ebx
 23a:	5e                   	pop    %esi
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
 23d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 240:	be ff ff ff ff       	mov    $0xffffffff,%esi
 245:	eb ed                	jmp    234 <stat+0x34>
 247:	89 f6                	mov    %esi,%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000250 <atoi>:

int
atoi(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 257:	0f be 11             	movsbl (%ecx),%edx
 25a:	8d 42 d0             	lea    -0x30(%edx),%eax
 25d:	3c 09                	cmp    $0x9,%al
  n = 0;
 25f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 264:	77 1f                	ja     285 <atoi+0x35>
 266:	8d 76 00             	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 270:	8d 04 80             	lea    (%eax,%eax,4),%eax
 273:	83 c1 01             	add    $0x1,%ecx
 276:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 27a:	0f be 11             	movsbl (%ecx),%edx
 27d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 280:	80 fb 09             	cmp    $0x9,%bl
 283:	76 eb                	jbe    270 <atoi+0x20>
  return n;
}
 285:	5b                   	pop    %ebx
 286:	5d                   	pop    %ebp
 287:	c3                   	ret    
 288:	90                   	nop
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000290 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	56                   	push   %esi
 294:	53                   	push   %ebx
 295:	8b 5d 10             	mov    0x10(%ebp),%ebx
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 db                	test   %ebx,%ebx
 2a0:	7e 14                	jle    2b6 <memmove+0x26>
 2a2:	31 d2                	xor    %edx,%edx
 2a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2af:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2b2:	39 d3                	cmp    %edx,%ebx
 2b4:	75 f2                	jne    2a8 <memmove+0x18>
  return vdst;
}
 2b6:	5b                   	pop    %ebx
 2b7:	5e                   	pop    %esi
 2b8:	5d                   	pop    %ebp
 2b9:	c3                   	ret    

000002ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ba:	b8 01 00 00 00       	mov    $0x1,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <exit>:
SYSCALL(exit)
 2c2:	b8 02 00 00 00       	mov    $0x2,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <wait>:
SYSCALL(wait)
 2ca:	b8 03 00 00 00       	mov    $0x3,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <pipe>:
SYSCALL(pipe)
 2d2:	b8 04 00 00 00       	mov    $0x4,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <read>:
SYSCALL(read)
 2da:	b8 05 00 00 00       	mov    $0x5,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <write>:
SYSCALL(write)
 2e2:	b8 10 00 00 00       	mov    $0x10,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <close>:
SYSCALL(close)
 2ea:	b8 15 00 00 00       	mov    $0x15,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <kill>:
SYSCALL(kill)
 2f2:	b8 06 00 00 00       	mov    $0x6,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <exec>:
SYSCALL(exec)
 2fa:	b8 07 00 00 00       	mov    $0x7,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <open>:
SYSCALL(open)
 302:	b8 0f 00 00 00       	mov    $0xf,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <mknod>:
SYSCALL(mknod)
 30a:	b8 11 00 00 00       	mov    $0x11,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <unlink>:
SYSCALL(unlink)
 312:	b8 12 00 00 00       	mov    $0x12,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <fstat>:
SYSCALL(fstat)
 31a:	b8 08 00 00 00       	mov    $0x8,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <link>:
SYSCALL(link)
 322:	b8 13 00 00 00       	mov    $0x13,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <mkdir>:
SYSCALL(mkdir)
 32a:	b8 14 00 00 00       	mov    $0x14,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <chdir>:
SYSCALL(chdir)
 332:	b8 09 00 00 00       	mov    $0x9,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <dup>:
SYSCALL(dup)
 33a:	b8 0a 00 00 00       	mov    $0xa,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <getpid>:
SYSCALL(getpid)
 342:	b8 0b 00 00 00       	mov    $0xb,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <sbrk>:
SYSCALL(sbrk)
 34a:	b8 0c 00 00 00       	mov    $0xc,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <sleep>:
SYSCALL(sleep)
 352:	b8 0d 00 00 00       	mov    $0xd,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <uptime>:
SYSCALL(uptime)
 35a:	b8 0e 00 00 00       	mov    $0xe,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <getcpuid>:
SYSCALL(getcpuid)
 362:	b8 16 00 00 00       	mov    $0x16,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <changepri>:
SYSCALL(changepri)
 36a:	b8 17 00 00 00       	mov    $0x17,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <sh_var_read>:
SYSCALL(sh_var_read)
 372:	b8 16 00 00 00       	mov    $0x16,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <sh_var_write>:
SYSCALL(sh_var_write)
 37a:	b8 17 00 00 00       	mov    $0x17,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <sem_create>:
SYSCALL(sem_create)
 382:	b8 18 00 00 00       	mov    $0x18,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <sem_free>:
SYSCALL(sem_free)
 38a:	b8 19 00 00 00       	mov    $0x19,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <sem_p>:
SYSCALL(sem_p)
 392:	b8 1a 00 00 00       	mov    $0x1a,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <sem_v>:
SYSCALL(sem_v)
 39a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <myMalloc>:
SYSCALL(myMalloc)
 3a2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <myFree>:
SYSCALL(myFree)
 3aa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <myFork>:
SYSCALL(myFork)
 3b2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <join>:
SYSCALL(join)
 3ba:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <clone>:
SYSCALL(clone)
 3c2:	b8 20 00 00 00       	mov    $0x20,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <chmod>:
SYSCALL(chmod)
 3ca:	b8 21 00 00 00       	mov    $0x21,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <open_fifo>:
 3d2:	b8 22 00 00 00       	mov    $0x22,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    
 3da:	66 90                	xchg   %ax,%ax
 3dc:	66 90                	xchg   %ax,%ax
 3de:	66 90                	xchg   %ax,%ax

000003e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	53                   	push   %ebx
 3e6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e9:	85 d2                	test   %edx,%edx
{
 3eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 3ee:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 3f0:	79 76                	jns    468 <printint+0x88>
 3f2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3f6:	74 70                	je     468 <printint+0x88>
    x = -xx;
 3f8:	f7 d8                	neg    %eax
    neg = 1;
 3fa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 401:	31 f6                	xor    %esi,%esi
 403:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 406:	eb 0a                	jmp    412 <printint+0x32>
 408:	90                   	nop
 409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 410:	89 fe                	mov    %edi,%esi
 412:	31 d2                	xor    %edx,%edx
 414:	8d 7e 01             	lea    0x1(%esi),%edi
 417:	f7 f1                	div    %ecx
 419:	0f b6 92 e8 07 00 00 	movzbl 0x7e8(%edx),%edx
  }while((x /= base) != 0);
 420:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 422:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 425:	75 e9                	jne    410 <printint+0x30>
  if(neg)
 427:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 42a:	85 c0                	test   %eax,%eax
 42c:	74 08                	je     436 <printint+0x56>
    buf[i++] = '-';
 42e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 433:	8d 7e 02             	lea    0x2(%esi),%edi
 436:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 43a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 43d:	8d 76 00             	lea    0x0(%esi),%esi
 440:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 443:	83 ec 04             	sub    $0x4,%esp
 446:	83 ee 01             	sub    $0x1,%esi
 449:	6a 01                	push   $0x1
 44b:	53                   	push   %ebx
 44c:	57                   	push   %edi
 44d:	88 45 d7             	mov    %al,-0x29(%ebp)
 450:	e8 8d fe ff ff       	call   2e2 <write>

  while(--i >= 0)
 455:	83 c4 10             	add    $0x10,%esp
 458:	39 de                	cmp    %ebx,%esi
 45a:	75 e4                	jne    440 <printint+0x60>
    putc(fd, buf[i]);
}
 45c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45f:	5b                   	pop    %ebx
 460:	5e                   	pop    %esi
 461:	5f                   	pop    %edi
 462:	5d                   	pop    %ebp
 463:	c3                   	ret    
 464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 468:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 46f:	eb 90                	jmp    401 <printint+0x21>
 471:	eb 0d                	jmp    480 <printf>
 473:	90                   	nop
 474:	90                   	nop
 475:	90                   	nop
 476:	90                   	nop
 477:	90                   	nop
 478:	90                   	nop
 479:	90                   	nop
 47a:	90                   	nop
 47b:	90                   	nop
 47c:	90                   	nop
 47d:	90                   	nop
 47e:	90                   	nop
 47f:	90                   	nop

00000480 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	53                   	push   %ebx
 486:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 489:	8b 75 0c             	mov    0xc(%ebp),%esi
 48c:	0f b6 1e             	movzbl (%esi),%ebx
 48f:	84 db                	test   %bl,%bl
 491:	0f 84 b3 00 00 00    	je     54a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 497:	8d 45 10             	lea    0x10(%ebp),%eax
 49a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 49d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 49f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4a2:	eb 2f                	jmp    4d3 <printf+0x53>
 4a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4a8:	83 f8 25             	cmp    $0x25,%eax
 4ab:	0f 84 a7 00 00 00    	je     558 <printf+0xd8>
  write(fd, &c, 1);
 4b1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4b4:	83 ec 04             	sub    $0x4,%esp
 4b7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 4ba:	6a 01                	push   $0x1
 4bc:	50                   	push   %eax
 4bd:	ff 75 08             	pushl  0x8(%ebp)
 4c0:	e8 1d fe ff ff       	call   2e2 <write>
 4c5:	83 c4 10             	add    $0x10,%esp
 4c8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4cb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4cf:	84 db                	test   %bl,%bl
 4d1:	74 77                	je     54a <printf+0xca>
    if(state == 0){
 4d3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 4d5:	0f be cb             	movsbl %bl,%ecx
 4d8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4db:	74 cb                	je     4a8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4dd:	83 ff 25             	cmp    $0x25,%edi
 4e0:	75 e6                	jne    4c8 <printf+0x48>
      if(c == 'd'){
 4e2:	83 f8 64             	cmp    $0x64,%eax
 4e5:	0f 84 05 01 00 00    	je     5f0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4eb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4f1:	83 f9 70             	cmp    $0x70,%ecx
 4f4:	74 72                	je     568 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4f6:	83 f8 73             	cmp    $0x73,%eax
 4f9:	0f 84 99 00 00 00    	je     598 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ff:	83 f8 63             	cmp    $0x63,%eax
 502:	0f 84 08 01 00 00    	je     610 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 508:	83 f8 25             	cmp    $0x25,%eax
 50b:	0f 84 ef 00 00 00    	je     600 <printf+0x180>
  write(fd, &c, 1);
 511:	8d 45 e7             	lea    -0x19(%ebp),%eax
 514:	83 ec 04             	sub    $0x4,%esp
 517:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 51b:	6a 01                	push   $0x1
 51d:	50                   	push   %eax
 51e:	ff 75 08             	pushl  0x8(%ebp)
 521:	e8 bc fd ff ff       	call   2e2 <write>
 526:	83 c4 0c             	add    $0xc,%esp
 529:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 52c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 52f:	6a 01                	push   $0x1
 531:	50                   	push   %eax
 532:	ff 75 08             	pushl  0x8(%ebp)
 535:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 538:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 53a:	e8 a3 fd ff ff       	call   2e2 <write>
  for(i = 0; fmt[i]; i++){
 53f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 543:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 546:	84 db                	test   %bl,%bl
 548:	75 89                	jne    4d3 <printf+0x53>
    }
  }
}
 54a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 54d:	5b                   	pop    %ebx
 54e:	5e                   	pop    %esi
 54f:	5f                   	pop    %edi
 550:	5d                   	pop    %ebp
 551:	c3                   	ret    
 552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 558:	bf 25 00 00 00       	mov    $0x25,%edi
 55d:	e9 66 ff ff ff       	jmp    4c8 <printf+0x48>
 562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 568:	83 ec 0c             	sub    $0xc,%esp
 56b:	b9 10 00 00 00       	mov    $0x10,%ecx
 570:	6a 00                	push   $0x0
 572:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	8b 17                	mov    (%edi),%edx
 57a:	e8 61 fe ff ff       	call   3e0 <printint>
        ap++;
 57f:	89 f8                	mov    %edi,%eax
 581:	83 c4 10             	add    $0x10,%esp
      state = 0;
 584:	31 ff                	xor    %edi,%edi
        ap++;
 586:	83 c0 04             	add    $0x4,%eax
 589:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 58c:	e9 37 ff ff ff       	jmp    4c8 <printf+0x48>
 591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 598:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 59b:	8b 08                	mov    (%eax),%ecx
        ap++;
 59d:	83 c0 04             	add    $0x4,%eax
 5a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 5a3:	85 c9                	test   %ecx,%ecx
 5a5:	0f 84 8e 00 00 00    	je     639 <printf+0x1b9>
        while(*s != 0){
 5ab:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 5ae:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 5b0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 5b2:	84 c0                	test   %al,%al
 5b4:	0f 84 0e ff ff ff    	je     4c8 <printf+0x48>
 5ba:	89 75 d0             	mov    %esi,-0x30(%ebp)
 5bd:	89 de                	mov    %ebx,%esi
 5bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5c2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 5c5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5c8:	83 ec 04             	sub    $0x4,%esp
          s++;
 5cb:	83 c6 01             	add    $0x1,%esi
 5ce:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 5d1:	6a 01                	push   $0x1
 5d3:	57                   	push   %edi
 5d4:	53                   	push   %ebx
 5d5:	e8 08 fd ff ff       	call   2e2 <write>
        while(*s != 0){
 5da:	0f b6 06             	movzbl (%esi),%eax
 5dd:	83 c4 10             	add    $0x10,%esp
 5e0:	84 c0                	test   %al,%al
 5e2:	75 e4                	jne    5c8 <printf+0x148>
 5e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 5e7:	31 ff                	xor    %edi,%edi
 5e9:	e9 da fe ff ff       	jmp    4c8 <printf+0x48>
 5ee:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 5f0:	83 ec 0c             	sub    $0xc,%esp
 5f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5f8:	6a 01                	push   $0x1
 5fa:	e9 73 ff ff ff       	jmp    572 <printf+0xf2>
 5ff:	90                   	nop
  write(fd, &c, 1);
 600:	83 ec 04             	sub    $0x4,%esp
 603:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 606:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 609:	6a 01                	push   $0x1
 60b:	e9 21 ff ff ff       	jmp    531 <printf+0xb1>
        putc(fd, *ap);
 610:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 613:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 616:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 618:	6a 01                	push   $0x1
        ap++;
 61a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 61d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 620:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 623:	50                   	push   %eax
 624:	ff 75 08             	pushl  0x8(%ebp)
 627:	e8 b6 fc ff ff       	call   2e2 <write>
        ap++;
 62c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 62f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 632:	31 ff                	xor    %edi,%edi
 634:	e9 8f fe ff ff       	jmp    4c8 <printf+0x48>
          s = "(null)";
 639:	bb e1 07 00 00       	mov    $0x7e1,%ebx
        while(*s != 0){
 63e:	b8 28 00 00 00       	mov    $0x28,%eax
 643:	e9 72 ff ff ff       	jmp    5ba <printf+0x13a>
 648:	66 90                	xchg   %ax,%ax
 64a:	66 90                	xchg   %ax,%ax
 64c:	66 90                	xchg   %ax,%ax
 64e:	66 90                	xchg   %ax,%ax

00000650 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 650:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	a1 94 0a 00 00       	mov    0xa94,%eax
{
 656:	89 e5                	mov    %esp,%ebp
 658:	57                   	push   %edi
 659:	56                   	push   %esi
 65a:	53                   	push   %ebx
 65b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 65e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 668:	39 c8                	cmp    %ecx,%eax
 66a:	8b 10                	mov    (%eax),%edx
 66c:	73 32                	jae    6a0 <free+0x50>
 66e:	39 d1                	cmp    %edx,%ecx
 670:	72 04                	jb     676 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 672:	39 d0                	cmp    %edx,%eax
 674:	72 32                	jb     6a8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 676:	8b 73 fc             	mov    -0x4(%ebx),%esi
 679:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 67c:	39 fa                	cmp    %edi,%edx
 67e:	74 30                	je     6b0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 680:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 683:	8b 50 04             	mov    0x4(%eax),%edx
 686:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 689:	39 f1                	cmp    %esi,%ecx
 68b:	74 3a                	je     6c7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 68d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 68f:	a3 94 0a 00 00       	mov    %eax,0xa94
}
 694:	5b                   	pop    %ebx
 695:	5e                   	pop    %esi
 696:	5f                   	pop    %edi
 697:	5d                   	pop    %ebp
 698:	c3                   	ret    
 699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a0:	39 d0                	cmp    %edx,%eax
 6a2:	72 04                	jb     6a8 <free+0x58>
 6a4:	39 d1                	cmp    %edx,%ecx
 6a6:	72 ce                	jb     676 <free+0x26>
{
 6a8:	89 d0                	mov    %edx,%eax
 6aa:	eb bc                	jmp    668 <free+0x18>
 6ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 6b0:	03 72 04             	add    0x4(%edx),%esi
 6b3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b6:	8b 10                	mov    (%eax),%edx
 6b8:	8b 12                	mov    (%edx),%edx
 6ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6bd:	8b 50 04             	mov    0x4(%eax),%edx
 6c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6c3:	39 f1                	cmp    %esi,%ecx
 6c5:	75 c6                	jne    68d <free+0x3d>
    p->s.size += bp->s.size;
 6c7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6ca:	a3 94 0a 00 00       	mov    %eax,0xa94
    p->s.size += bp->s.size;
 6cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6d5:	89 10                	mov    %edx,(%eax)
}
 6d7:	5b                   	pop    %ebx
 6d8:	5e                   	pop    %esi
 6d9:	5f                   	pop    %edi
 6da:	5d                   	pop    %ebp
 6db:	c3                   	ret    
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6ec:	8b 15 94 0a 00 00    	mov    0xa94,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f2:	8d 78 07             	lea    0x7(%eax),%edi
 6f5:	c1 ef 03             	shr    $0x3,%edi
 6f8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6fb:	85 d2                	test   %edx,%edx
 6fd:	0f 84 9d 00 00 00    	je     7a0 <malloc+0xc0>
 703:	8b 02                	mov    (%edx),%eax
 705:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 708:	39 cf                	cmp    %ecx,%edi
 70a:	76 6c                	jbe    778 <malloc+0x98>
 70c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 712:	bb 00 10 00 00       	mov    $0x1000,%ebx
 717:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 71a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 721:	eb 0e                	jmp    731 <malloc+0x51>
 723:	90                   	nop
 724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 728:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 72a:	8b 48 04             	mov    0x4(%eax),%ecx
 72d:	39 f9                	cmp    %edi,%ecx
 72f:	73 47                	jae    778 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 731:	39 05 94 0a 00 00    	cmp    %eax,0xa94
 737:	89 c2                	mov    %eax,%edx
 739:	75 ed                	jne    728 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 73b:	83 ec 0c             	sub    $0xc,%esp
 73e:	56                   	push   %esi
 73f:	e8 06 fc ff ff       	call   34a <sbrk>
  if(p == (char*)-1)
 744:	83 c4 10             	add    $0x10,%esp
 747:	83 f8 ff             	cmp    $0xffffffff,%eax
 74a:	74 1c                	je     768 <malloc+0x88>
  hp->s.size = nu;
 74c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 74f:	83 ec 0c             	sub    $0xc,%esp
 752:	83 c0 08             	add    $0x8,%eax
 755:	50                   	push   %eax
 756:	e8 f5 fe ff ff       	call   650 <free>
  return freep;
 75b:	8b 15 94 0a 00 00    	mov    0xa94,%edx
      if((p = morecore(nunits)) == 0)
 761:	83 c4 10             	add    $0x10,%esp
 764:	85 d2                	test   %edx,%edx
 766:	75 c0                	jne    728 <malloc+0x48>
        return 0;
  }
}
 768:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 76b:	31 c0                	xor    %eax,%eax
}
 76d:	5b                   	pop    %ebx
 76e:	5e                   	pop    %esi
 76f:	5f                   	pop    %edi
 770:	5d                   	pop    %ebp
 771:	c3                   	ret    
 772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 778:	39 cf                	cmp    %ecx,%edi
 77a:	74 54                	je     7d0 <malloc+0xf0>
        p->s.size -= nunits;
 77c:	29 f9                	sub    %edi,%ecx
 77e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 781:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 784:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 787:	89 15 94 0a 00 00    	mov    %edx,0xa94
}
 78d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 790:	83 c0 08             	add    $0x8,%eax
}
 793:	5b                   	pop    %ebx
 794:	5e                   	pop    %esi
 795:	5f                   	pop    %edi
 796:	5d                   	pop    %ebp
 797:	c3                   	ret    
 798:	90                   	nop
 799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 7a0:	c7 05 94 0a 00 00 98 	movl   $0xa98,0xa94
 7a7:	0a 00 00 
 7aa:	c7 05 98 0a 00 00 98 	movl   $0xa98,0xa98
 7b1:	0a 00 00 
    base.s.size = 0;
 7b4:	b8 98 0a 00 00       	mov    $0xa98,%eax
 7b9:	c7 05 9c 0a 00 00 00 	movl   $0x0,0xa9c
 7c0:	00 00 00 
 7c3:	e9 44 ff ff ff       	jmp    70c <malloc+0x2c>
 7c8:	90                   	nop
 7c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 7d0:	8b 08                	mov    (%eax),%ecx
 7d2:	89 0a                	mov    %ecx,(%edx)
 7d4:	eb b1                	jmp    787 <malloc+0xa7>
