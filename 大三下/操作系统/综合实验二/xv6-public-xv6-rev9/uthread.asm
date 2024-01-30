
_uthread:     file format elf32-i386


Disassembly of section .text:

00000000 <add_thread>:
    int pid;
    void* ustack;
    int used;
} threads[NTHREAD]; // TCB 表
 // add a TCB to thread table
void add_thread(int* pid, void* ustack) {
   0:	ba 00 0d 00 00       	mov    $0xd00,%edx
    for(int i = 0; i < NTHREAD; i++) {
   5:	31 c0                	xor    %eax,%eax
        if(threads[i].used == 0) {
   7:	8b 4a 08             	mov    0x8(%edx),%ecx
   a:	85 c9                	test   %ecx,%ecx
   c:	74 12                	je     20 <add_thread+0x20>
    for(int i = 0; i < NTHREAD; i++) {
   e:	83 c0 01             	add    $0x1,%eax
  11:	83 c2 0c             	add    $0xc,%edx
  14:	83 f8 04             	cmp    $0x4,%eax
  17:	75 ee                	jne    7 <add_thread+0x7>
  19:	f3 c3                	repz ret 
  1b:	90                   	nop
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void add_thread(int* pid, void* ustack) {
  20:	55                   	push   %ebp
            threads[i].pid = *pid;
  21:	8d 04 40             	lea    (%eax,%eax,2),%eax
void add_thread(int* pid, void* ustack) {
  24:	89 e5                	mov    %esp,%ebp
            threads[i].pid = *pid;
  26:	c1 e0 02             	shl    $0x2,%eax
  29:	8b 55 08             	mov    0x8(%ebp),%edx
  2c:	8b 0a                	mov    (%edx),%ecx
  2e:	8d 90 00 0d 00 00    	lea    0xd00(%eax),%edx
            threads[i].ustack = ustack;
            threads[i].used = 1;
  34:	c7 42 08 01 00 00 00 	movl   $0x1,0x8(%edx)
            threads[i].pid = *pid;
  3b:	89 88 00 0d 00 00    	mov    %ecx,0xd00(%eax)
            threads[i].ustack = ustack;
  41:	8b 45 0c             	mov    0xc(%ebp),%eax
  44:	89 42 04             	mov    %eax,0x4(%edx)
            break;
        }
    }
 }
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    
  49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000050 <remove_thread>:
 void remove_thread(int* pid) {
  50:	55                   	push   %ebp
  51:	b8 00 0d 00 00       	mov    $0xd00,%eax
    for(int i = 0; i < NTHREAD; i ++) {
  56:	31 d2                	xor    %edx,%edx
 void remove_thread(int* pid) {
  58:	89 e5                	mov    %esp,%ebp
  5a:	56                   	push   %esi
  5b:	53                   	push   %ebx
  5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
        if(threads[i].used && threads[i].pid == *pid) {
  5f:	8b 58 08             	mov    0x8(%eax),%ebx
  62:	85 db                	test   %ebx,%ebx
  64:	74 06                	je     6c <remove_thread+0x1c>
  66:	8b 31                	mov    (%ecx),%esi
  68:	39 30                	cmp    %esi,(%eax)
  6a:	74 14                	je     80 <remove_thread+0x30>
    for(int i = 0; i < NTHREAD; i ++) {
  6c:	83 c2 01             	add    $0x1,%edx
  6f:	83 c0 0c             	add    $0xc,%eax
  72:	83 fa 04             	cmp    $0x4,%edx
  75:	75 e8                	jne    5f <remove_thread+0xf>
            threads[i].ustack = 0;
            threads[i].used = 0;
            break;
        }
    }
 }
  77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  7a:	5b                   	pop    %ebx
  7b:	5e                   	pop    %esi
  7c:	5d                   	pop    %ebp
  7d:	c3                   	ret    
  7e:	66 90                	xchg   %ax,%ax
            free(threads[i].ustack); // 释放用户栈
  80:	8d 1c 52             	lea    (%edx,%edx,2),%ebx
  83:	83 ec 0c             	sub    $0xc,%esp
  86:	c1 e3 02             	shl    $0x2,%ebx
  89:	ff b3 04 0d 00 00    	pushl  0xd04(%ebx)
  8f:	e8 4c 07 00 00       	call   7e0 <free>
            threads[i].pid = 0;
  94:	c7 83 00 0d 00 00 00 	movl   $0x0,0xd00(%ebx)
  9b:	00 00 00 
            threads[i].ustack = 0;
  9e:	c7 83 04 0d 00 00 00 	movl   $0x0,0xd04(%ebx)
  a5:	00 00 00 
            break;
  a8:	83 c4 10             	add    $0x10,%esp
            threads[i].used = 0;
  ab:	c7 83 08 0d 00 00 00 	movl   $0x0,0xd08(%ebx)
  b2:	00 00 00 
 }
  b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  b8:	5b                   	pop    %ebx
  b9:	5e                   	pop    %esi
  ba:	5d                   	pop    %ebp
  bb:	c3                   	ret    
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000c0 <thread_create>:
int thread_create(void (*start_routine)(void*), void* arg) {
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	53                   	push   %ebx
  c4:	83 ec 04             	sub    $0x4,%esp
    // If first time running any threads, initialize thread table with zeros
    static int first = 1;
    if(first) {
  c7:	a1 c8 0c 00 00       	mov    0xcc8,%eax
  cc:	85 c0                	test   %eax,%eax
  ce:	74 2d                	je     fd <thread_create+0x3d>
        first = 0;
  d0:	c7 05 c8 0c 00 00 00 	movl   $0x0,0xcc8
  d7:	00 00 00 
  da:	b8 00 0d 00 00       	mov    $0xd00,%eax
        for(int i = 0; i < NTHREAD; i++) {
            threads[i].pid = 0;
  df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            threads[i].ustack = 0;
  e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  ec:	83 c0 0c             	add    $0xc,%eax
            threads[i].used = 0;
  ef:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
        for(int i = 0; i < NTHREAD; i++) {
  f6:	3d 30 0d 00 00       	cmp    $0xd30,%eax
  fb:	75 e2                	jne    df <thread_create+0x1f>
        }
    }
    void* stack = malloc(PGSIZE); // allocate one page for user stack
  fd:	83 ec 0c             	sub    $0xc,%esp
 100:	68 00 10 00 00       	push   $0x1000
 105:	e8 66 07 00 00       	call   870 <malloc>
    int pid = clone(start_routine, arg, stack); // system call for kernel thread
 10a:	83 c4 0c             	add    $0xc,%esp
    void* stack = malloc(PGSIZE); // allocate one page for user stack
 10d:	89 c3                	mov    %eax,%ebx
    int pid = clone(start_routine, arg, stack); // system call for kernel thread
 10f:	50                   	push   %eax
 110:	ff 75 0c             	pushl  0xc(%ebp)
 113:	ff 75 08             	pushl  0x8(%ebp)
 116:	e8 37 04 00 00       	call   552 <clone>
 11b:	b9 00 0d 00 00       	mov    $0xd00,%ecx
 120:	83 c4 10             	add    $0x10,%esp
    for(int i = 0; i < NTHREAD; i++) {
 123:	31 d2                	xor    %edx,%edx
        if(threads[i].used == 0) {
 125:	83 79 08 00          	cmpl   $0x0,0x8(%ecx)
 129:	74 15                	je     140 <thread_create+0x80>
    for(int i = 0; i < NTHREAD; i++) {
 12b:	83 c2 01             	add    $0x1,%edx
 12e:	83 c1 0c             	add    $0xc,%ecx
 131:	83 fa 04             	cmp    $0x4,%edx
 134:	75 ef                	jne    125 <thread_create+0x65>
    add_thread(&pid, stack); // save new thread to thread table
    return pid;
}
 136:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 139:	c9                   	leave  
 13a:	c3                   	ret    
 13b:	90                   	nop
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            threads[i].pid = *pid;
 140:	8d 14 52             	lea    (%edx,%edx,2),%edx
 143:	c1 e2 02             	shl    $0x2,%edx
            threads[i].ustack = ustack;
 146:	89 9a 04 0d 00 00    	mov    %ebx,0xd04(%edx)
            threads[i].pid = *pid;
 14c:	89 82 00 0d 00 00    	mov    %eax,0xd00(%edx)
            threads[i].used = 1;
 152:	c7 82 08 0d 00 00 01 	movl   $0x1,0xd08(%edx)
 159:	00 00 00 
}
 15c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 15f:	c9                   	leave  
 160:	c3                   	ret    
 161:	eb 0d                	jmp    170 <thread_join>
 163:	90                   	nop
 164:	90                   	nop
 165:	90                   	nop
 166:	90                   	nop
 167:	90                   	nop
 168:	90                   	nop
 169:	90                   	nop
 16a:	90                   	nop
 16b:	90                   	nop
 16c:	90                   	nop
 16d:	90                   	nop
 16e:	90                   	nop
 16f:	90                   	nop

00000170 <thread_join>:
int thread_join(void) {
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	53                   	push   %ebx
 174:	bb 00 0d 00 00       	mov    $0xd00,%ebx
 179:	83 ec 14             	sub    $0x14,%esp
    for(int i = 0; i < NTHREAD; i ++) {
        if(threads[i].used == 1) {
 17c:	83 7b 08 01          	cmpl   $0x1,0x8(%ebx)
 180:	74 16                	je     198 <thread_join+0x28>
 182:	83 c3 0c             	add    $0xc,%ebx
    for(int i = 0; i < NTHREAD; i ++) {
 185:	81 fb 30 0d 00 00    	cmp    $0xd30,%ebx
 18b:	75 ef                	jne    17c <thread_join+0xc>
                remove_thread(&pid);
                return pid;
            }
        }
    }
    return 0;
 18d:	31 c0                	xor    %eax,%eax
}
 18f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 192:	c9                   	leave  
 193:	c3                   	ret    
 194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            int pid = join(&threads[i].ustack); // 回收子线程
 198:	8d 43 04             	lea    0x4(%ebx),%eax
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	50                   	push   %eax
 19f:	e8 a6 03 00 00       	call   54a <join>
            if(pid > 0) {
 1a4:	83 c4 10             	add    $0x10,%esp
 1a7:	85 c0                	test   %eax,%eax
            int pid = join(&threads[i].ustack); // 回收子线程
 1a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if(pid > 0) {
 1ac:	7e d4                	jle    182 <thread_join+0x12>
                remove_thread(&pid);
 1ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
 1b1:	83 ec 0c             	sub    $0xc,%esp
 1b4:	50                   	push   %eax
 1b5:	e8 96 fe ff ff       	call   50 <remove_thread>
                return pid;
 1ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	eb cd                	jmp    18f <thread_join+0x1f>
 1c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <printTCB>:
void printTCB(void) {
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	53                   	push   %ebx
    for(int i = 0; i < NTHREAD; i ++)
 1d4:	31 db                	xor    %ebx,%ebx
void printTCB(void) {
 1d6:	83 ec 04             	sub    $0x4,%esp
    printf(1, "TCB %d: %d\n", i, threads[i].used);
 1d9:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
 1dc:	ff 34 85 08 0d 00 00 	pushl  0xd08(,%eax,4)
 1e3:	53                   	push   %ebx
    for(int i = 0; i < NTHREAD; i ++)
 1e4:	83 c3 01             	add    $0x1,%ebx
    printf(1, "TCB %d: %d\n", i, threads[i].used);
 1e7:	68 68 09 00 00       	push   $0x968
 1ec:	6a 01                	push   $0x1
 1ee:	e8 1d 04 00 00       	call   610 <printf>
    for(int i = 0; i < NTHREAD; i ++)
 1f3:	83 c4 10             	add    $0x10,%esp
 1f6:	83 fb 04             	cmp    $0x4,%ebx
 1f9:	75 de                	jne    1d9 <printTCB+0x9>
 1fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1fe:	c9                   	leave  
 1ff:	c3                   	ret    

00000200 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 20a:	89 c2                	mov    %eax,%edx
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 210:	83 c1 01             	add    $0x1,%ecx
 213:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 217:	83 c2 01             	add    $0x1,%edx
 21a:	84 db                	test   %bl,%bl
 21c:	88 5a ff             	mov    %bl,-0x1(%edx)
 21f:	75 ef                	jne    210 <strcpy+0x10>
    ;
  return os;
}
 221:	5b                   	pop    %ebx
 222:	5d                   	pop    %ebp
 223:	c3                   	ret    
 224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 22a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000230 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 55 08             	mov    0x8(%ebp),%edx
 237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 23a:	0f b6 02             	movzbl (%edx),%eax
 23d:	0f b6 19             	movzbl (%ecx),%ebx
 240:	84 c0                	test   %al,%al
 242:	75 1c                	jne    260 <strcmp+0x30>
 244:	eb 2a                	jmp    270 <strcmp+0x40>
 246:	8d 76 00             	lea    0x0(%esi),%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 250:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 253:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 256:	83 c1 01             	add    $0x1,%ecx
 259:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 25c:	84 c0                	test   %al,%al
 25e:	74 10                	je     270 <strcmp+0x40>
 260:	38 d8                	cmp    %bl,%al
 262:	74 ec                	je     250 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 264:	29 d8                	sub    %ebx,%eax
}
 266:	5b                   	pop    %ebx
 267:	5d                   	pop    %ebp
 268:	c3                   	ret    
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 270:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 272:	29 d8                	sub    %ebx,%eax
}
 274:	5b                   	pop    %ebx
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
 277:	89 f6                	mov    %esi,%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <strlen>:

uint
strlen(char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 286:	80 39 00             	cmpb   $0x0,(%ecx)
 289:	74 15                	je     2a0 <strlen+0x20>
 28b:	31 d2                	xor    %edx,%edx
 28d:	8d 76 00             	lea    0x0(%esi),%esi
 290:	83 c2 01             	add    $0x1,%edx
 293:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 297:	89 d0                	mov    %edx,%eax
 299:	75 f5                	jne    290 <strlen+0x10>
    ;
  return n;
}
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2a0:	31 c0                	xor    %eax,%eax
}
 2a2:	5d                   	pop    %ebp
 2a3:	c3                   	ret    
 2a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bd:	89 d7                	mov    %edx,%edi
 2bf:	fc                   	cld    
 2c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2c2:	89 d0                	mov    %edx,%eax
 2c4:	5f                   	pop    %edi
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret    
 2c7:	89 f6                	mov    %esi,%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002d0 <strchr>:

char*
strchr(const char *s, char c)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 2da:	0f b6 10             	movzbl (%eax),%edx
 2dd:	84 d2                	test   %dl,%dl
 2df:	74 1d                	je     2fe <strchr+0x2e>
    if(*s == c)
 2e1:	38 d3                	cmp    %dl,%bl
 2e3:	89 d9                	mov    %ebx,%ecx
 2e5:	75 0d                	jne    2f4 <strchr+0x24>
 2e7:	eb 17                	jmp    300 <strchr+0x30>
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2f0:	38 ca                	cmp    %cl,%dl
 2f2:	74 0c                	je     300 <strchr+0x30>
  for(; *s; s++)
 2f4:	83 c0 01             	add    $0x1,%eax
 2f7:	0f b6 10             	movzbl (%eax),%edx
 2fa:	84 d2                	test   %dl,%dl
 2fc:	75 f2                	jne    2f0 <strchr+0x20>
      return (char*)s;
  return 0;
 2fe:	31 c0                	xor    %eax,%eax
}
 300:	5b                   	pop    %ebx
 301:	5d                   	pop    %ebp
 302:	c3                   	ret    
 303:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000310 <gets>:

char*
gets(char *buf, int max)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	56                   	push   %esi
 315:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 316:	31 f6                	xor    %esi,%esi
 318:	89 f3                	mov    %esi,%ebx
{
 31a:	83 ec 1c             	sub    $0x1c,%esp
 31d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 320:	eb 2f                	jmp    351 <gets+0x41>
 322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 328:	8d 45 e7             	lea    -0x19(%ebp),%eax
 32b:	83 ec 04             	sub    $0x4,%esp
 32e:	6a 01                	push   $0x1
 330:	50                   	push   %eax
 331:	6a 00                	push   $0x0
 333:	e8 32 01 00 00       	call   46a <read>
    if(cc < 1)
 338:	83 c4 10             	add    $0x10,%esp
 33b:	85 c0                	test   %eax,%eax
 33d:	7e 1c                	jle    35b <gets+0x4b>
      break;
    buf[i++] = c;
 33f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 343:	83 c7 01             	add    $0x1,%edi
 346:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 349:	3c 0a                	cmp    $0xa,%al
 34b:	74 23                	je     370 <gets+0x60>
 34d:	3c 0d                	cmp    $0xd,%al
 34f:	74 1f                	je     370 <gets+0x60>
  for(i=0; i+1 < max; ){
 351:	83 c3 01             	add    $0x1,%ebx
 354:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 357:	89 fe                	mov    %edi,%esi
 359:	7c cd                	jl     328 <gets+0x18>
 35b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 360:	c6 03 00             	movb   $0x0,(%ebx)
}
 363:	8d 65 f4             	lea    -0xc(%ebp),%esp
 366:	5b                   	pop    %ebx
 367:	5e                   	pop    %esi
 368:	5f                   	pop    %edi
 369:	5d                   	pop    %ebp
 36a:	c3                   	ret    
 36b:	90                   	nop
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 370:	8b 75 08             	mov    0x8(%ebp),%esi
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	01 de                	add    %ebx,%esi
 378:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 37a:	c6 03 00             	movb   $0x0,(%ebx)
}
 37d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 380:	5b                   	pop    %ebx
 381:	5e                   	pop    %esi
 382:	5f                   	pop    %edi
 383:	5d                   	pop    %ebp
 384:	c3                   	ret    
 385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000390 <stat>:

int
stat(char *n, struct stat *st)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	56                   	push   %esi
 394:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 395:	83 ec 08             	sub    $0x8,%esp
 398:	6a 00                	push   $0x0
 39a:	ff 75 08             	pushl  0x8(%ebp)
 39d:	e8 f0 00 00 00       	call   492 <open>
  if(fd < 0)
 3a2:	83 c4 10             	add    $0x10,%esp
 3a5:	85 c0                	test   %eax,%eax
 3a7:	78 27                	js     3d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3a9:	83 ec 08             	sub    $0x8,%esp
 3ac:	ff 75 0c             	pushl  0xc(%ebp)
 3af:	89 c3                	mov    %eax,%ebx
 3b1:	50                   	push   %eax
 3b2:	e8 f3 00 00 00       	call   4aa <fstat>
  close(fd);
 3b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3ba:	89 c6                	mov    %eax,%esi
  close(fd);
 3bc:	e8 b9 00 00 00       	call   47a <close>
  return r;
 3c1:	83 c4 10             	add    $0x10,%esp
}
 3c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3c7:	89 f0                	mov    %esi,%eax
 3c9:	5b                   	pop    %ebx
 3ca:	5e                   	pop    %esi
 3cb:	5d                   	pop    %ebp
 3cc:	c3                   	ret    
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3d5:	eb ed                	jmp    3c4 <stat+0x34>
 3d7:	89 f6                	mov    %esi,%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <atoi>:

int
atoi(const char *s)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	53                   	push   %ebx
 3e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e7:	0f be 11             	movsbl (%ecx),%edx
 3ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 3ed:	3c 09                	cmp    $0x9,%al
  n = 0;
 3ef:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 3f4:	77 1f                	ja     415 <atoi+0x35>
 3f6:	8d 76 00             	lea    0x0(%esi),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 400:	8d 04 80             	lea    (%eax,%eax,4),%eax
 403:	83 c1 01             	add    $0x1,%ecx
 406:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 40a:	0f be 11             	movsbl (%ecx),%edx
 40d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 410:	80 fb 09             	cmp    $0x9,%bl
 413:	76 eb                	jbe    400 <atoi+0x20>
  return n;
}
 415:	5b                   	pop    %ebx
 416:	5d                   	pop    %ebp
 417:	c3                   	ret    
 418:	90                   	nop
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000420 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	56                   	push   %esi
 424:	53                   	push   %ebx
 425:	8b 5d 10             	mov    0x10(%ebp),%ebx
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 42e:	85 db                	test   %ebx,%ebx
 430:	7e 14                	jle    446 <memmove+0x26>
 432:	31 d2                	xor    %edx,%edx
 434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 438:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 43c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 43f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 442:	39 d3                	cmp    %edx,%ebx
 444:	75 f2                	jne    438 <memmove+0x18>
  return vdst;
}
 446:	5b                   	pop    %ebx
 447:	5e                   	pop    %esi
 448:	5d                   	pop    %ebp
 449:	c3                   	ret    

0000044a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 44a:	b8 01 00 00 00       	mov    $0x1,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <exit>:
SYSCALL(exit)
 452:	b8 02 00 00 00       	mov    $0x2,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <wait>:
SYSCALL(wait)
 45a:	b8 03 00 00 00       	mov    $0x3,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <pipe>:
SYSCALL(pipe)
 462:	b8 04 00 00 00       	mov    $0x4,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <read>:
SYSCALL(read)
 46a:	b8 05 00 00 00       	mov    $0x5,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <write>:
SYSCALL(write)
 472:	b8 10 00 00 00       	mov    $0x10,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <close>:
SYSCALL(close)
 47a:	b8 15 00 00 00       	mov    $0x15,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <kill>:
SYSCALL(kill)
 482:	b8 06 00 00 00       	mov    $0x6,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <exec>:
SYSCALL(exec)
 48a:	b8 07 00 00 00       	mov    $0x7,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <open>:
SYSCALL(open)
 492:	b8 0f 00 00 00       	mov    $0xf,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <mknod>:
SYSCALL(mknod)
 49a:	b8 11 00 00 00       	mov    $0x11,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <unlink>:
SYSCALL(unlink)
 4a2:	b8 12 00 00 00       	mov    $0x12,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <fstat>:
SYSCALL(fstat)
 4aa:	b8 08 00 00 00       	mov    $0x8,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <link>:
SYSCALL(link)
 4b2:	b8 13 00 00 00       	mov    $0x13,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <mkdir>:
SYSCALL(mkdir)
 4ba:	b8 14 00 00 00       	mov    $0x14,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <chdir>:
SYSCALL(chdir)
 4c2:	b8 09 00 00 00       	mov    $0x9,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <dup>:
SYSCALL(dup)
 4ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <getpid>:
SYSCALL(getpid)
 4d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <sbrk>:
SYSCALL(sbrk)
 4da:	b8 0c 00 00 00       	mov    $0xc,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <sleep>:
SYSCALL(sleep)
 4e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <uptime>:
SYSCALL(uptime)
 4ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <getcpuid>:
SYSCALL(getcpuid)
 4f2:	b8 16 00 00 00       	mov    $0x16,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <changepri>:
SYSCALL(changepri)
 4fa:	b8 17 00 00 00       	mov    $0x17,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <sh_var_read>:
SYSCALL(sh_var_read)
 502:	b8 16 00 00 00       	mov    $0x16,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <sh_var_write>:
SYSCALL(sh_var_write)
 50a:	b8 17 00 00 00       	mov    $0x17,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <sem_create>:
SYSCALL(sem_create)
 512:	b8 18 00 00 00       	mov    $0x18,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <sem_free>:
SYSCALL(sem_free)
 51a:	b8 19 00 00 00       	mov    $0x19,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <sem_p>:
SYSCALL(sem_p)
 522:	b8 1a 00 00 00       	mov    $0x1a,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <sem_v>:
SYSCALL(sem_v)
 52a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <myMalloc>:
SYSCALL(myMalloc)
 532:	b8 1c 00 00 00       	mov    $0x1c,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <myFree>:
SYSCALL(myFree)
 53a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <myFork>:
SYSCALL(myFork)
 542:	b8 1e 00 00 00       	mov    $0x1e,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <join>:
SYSCALL(join)
 54a:	b8 1f 00 00 00       	mov    $0x1f,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <clone>:
SYSCALL(clone)
 552:	b8 20 00 00 00       	mov    $0x20,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <chmod>:
SYSCALL(chmod)
 55a:	b8 21 00 00 00       	mov    $0x21,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <open_fifo>:
 562:	b8 22 00 00 00       	mov    $0x22,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    
 56a:	66 90                	xchg   %ax,%ax
 56c:	66 90                	xchg   %ax,%ax
 56e:	66 90                	xchg   %ax,%ax

00000570 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	56                   	push   %esi
 575:	53                   	push   %ebx
 576:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 579:	85 d2                	test   %edx,%edx
{
 57b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 57e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 580:	79 76                	jns    5f8 <printint+0x88>
 582:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 586:	74 70                	je     5f8 <printint+0x88>
    x = -xx;
 588:	f7 d8                	neg    %eax
    neg = 1;
 58a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 591:	31 f6                	xor    %esi,%esi
 593:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 596:	eb 0a                	jmp    5a2 <printint+0x32>
 598:	90                   	nop
 599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 5a0:	89 fe                	mov    %edi,%esi
 5a2:	31 d2                	xor    %edx,%edx
 5a4:	8d 7e 01             	lea    0x1(%esi),%edi
 5a7:	f7 f1                	div    %ecx
 5a9:	0f b6 92 7c 09 00 00 	movzbl 0x97c(%edx),%edx
  }while((x /= base) != 0);
 5b0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 5b2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 5b5:	75 e9                	jne    5a0 <printint+0x30>
  if(neg)
 5b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5ba:	85 c0                	test   %eax,%eax
 5bc:	74 08                	je     5c6 <printint+0x56>
    buf[i++] = '-';
 5be:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 5c3:	8d 7e 02             	lea    0x2(%esi),%edi
 5c6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 5ca:	8b 7d c0             	mov    -0x40(%ebp),%edi
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
 5d0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 5d3:	83 ec 04             	sub    $0x4,%esp
 5d6:	83 ee 01             	sub    $0x1,%esi
 5d9:	6a 01                	push   $0x1
 5db:	53                   	push   %ebx
 5dc:	57                   	push   %edi
 5dd:	88 45 d7             	mov    %al,-0x29(%ebp)
 5e0:	e8 8d fe ff ff       	call   472 <write>

  while(--i >= 0)
 5e5:	83 c4 10             	add    $0x10,%esp
 5e8:	39 de                	cmp    %ebx,%esi
 5ea:	75 e4                	jne    5d0 <printint+0x60>
    putc(fd, buf[i]);
}
 5ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ef:	5b                   	pop    %ebx
 5f0:	5e                   	pop    %esi
 5f1:	5f                   	pop    %edi
 5f2:	5d                   	pop    %ebp
 5f3:	c3                   	ret    
 5f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5f8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5ff:	eb 90                	jmp    591 <printint+0x21>
 601:	eb 0d                	jmp    610 <printf>
 603:	90                   	nop
 604:	90                   	nop
 605:	90                   	nop
 606:	90                   	nop
 607:	90                   	nop
 608:	90                   	nop
 609:	90                   	nop
 60a:	90                   	nop
 60b:	90                   	nop
 60c:	90                   	nop
 60d:	90                   	nop
 60e:	90                   	nop
 60f:	90                   	nop

00000610 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 619:	8b 75 0c             	mov    0xc(%ebp),%esi
 61c:	0f b6 1e             	movzbl (%esi),%ebx
 61f:	84 db                	test   %bl,%bl
 621:	0f 84 b3 00 00 00    	je     6da <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 627:	8d 45 10             	lea    0x10(%ebp),%eax
 62a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 62d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 62f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 632:	eb 2f                	jmp    663 <printf+0x53>
 634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 638:	83 f8 25             	cmp    $0x25,%eax
 63b:	0f 84 a7 00 00 00    	je     6e8 <printf+0xd8>
  write(fd, &c, 1);
 641:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 644:	83 ec 04             	sub    $0x4,%esp
 647:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 64a:	6a 01                	push   $0x1
 64c:	50                   	push   %eax
 64d:	ff 75 08             	pushl  0x8(%ebp)
 650:	e8 1d fe ff ff       	call   472 <write>
 655:	83 c4 10             	add    $0x10,%esp
 658:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 65b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 65f:	84 db                	test   %bl,%bl
 661:	74 77                	je     6da <printf+0xca>
    if(state == 0){
 663:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 665:	0f be cb             	movsbl %bl,%ecx
 668:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 66b:	74 cb                	je     638 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 66d:	83 ff 25             	cmp    $0x25,%edi
 670:	75 e6                	jne    658 <printf+0x48>
      if(c == 'd'){
 672:	83 f8 64             	cmp    $0x64,%eax
 675:	0f 84 05 01 00 00    	je     780 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 67b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 681:	83 f9 70             	cmp    $0x70,%ecx
 684:	74 72                	je     6f8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 686:	83 f8 73             	cmp    $0x73,%eax
 689:	0f 84 99 00 00 00    	je     728 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68f:	83 f8 63             	cmp    $0x63,%eax
 692:	0f 84 08 01 00 00    	je     7a0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 698:	83 f8 25             	cmp    $0x25,%eax
 69b:	0f 84 ef 00 00 00    	je     790 <printf+0x180>
  write(fd, &c, 1);
 6a1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6a4:	83 ec 04             	sub    $0x4,%esp
 6a7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6ab:	6a 01                	push   $0x1
 6ad:	50                   	push   %eax
 6ae:	ff 75 08             	pushl  0x8(%ebp)
 6b1:	e8 bc fd ff ff       	call   472 <write>
 6b6:	83 c4 0c             	add    $0xc,%esp
 6b9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6bc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 6bf:	6a 01                	push   $0x1
 6c1:	50                   	push   %eax
 6c2:	ff 75 08             	pushl  0x8(%ebp)
 6c5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6c8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 6ca:	e8 a3 fd ff ff       	call   472 <write>
  for(i = 0; fmt[i]; i++){
 6cf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 6d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6d6:	84 db                	test   %bl,%bl
 6d8:	75 89                	jne    663 <printf+0x53>
    }
  }
}
 6da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6dd:	5b                   	pop    %ebx
 6de:	5e                   	pop    %esi
 6df:	5f                   	pop    %edi
 6e0:	5d                   	pop    %ebp
 6e1:	c3                   	ret    
 6e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 6e8:	bf 25 00 00 00       	mov    $0x25,%edi
 6ed:	e9 66 ff ff ff       	jmp    658 <printf+0x48>
 6f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6f8:	83 ec 0c             	sub    $0xc,%esp
 6fb:	b9 10 00 00 00       	mov    $0x10,%ecx
 700:	6a 00                	push   $0x0
 702:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 705:	8b 45 08             	mov    0x8(%ebp),%eax
 708:	8b 17                	mov    (%edi),%edx
 70a:	e8 61 fe ff ff       	call   570 <printint>
        ap++;
 70f:	89 f8                	mov    %edi,%eax
 711:	83 c4 10             	add    $0x10,%esp
      state = 0;
 714:	31 ff                	xor    %edi,%edi
        ap++;
 716:	83 c0 04             	add    $0x4,%eax
 719:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 71c:	e9 37 ff ff ff       	jmp    658 <printf+0x48>
 721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 728:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 72b:	8b 08                	mov    (%eax),%ecx
        ap++;
 72d:	83 c0 04             	add    $0x4,%eax
 730:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 733:	85 c9                	test   %ecx,%ecx
 735:	0f 84 8e 00 00 00    	je     7c9 <printf+0x1b9>
        while(*s != 0){
 73b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 73e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 740:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 742:	84 c0                	test   %al,%al
 744:	0f 84 0e ff ff ff    	je     658 <printf+0x48>
 74a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 74d:	89 de                	mov    %ebx,%esi
 74f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 752:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 755:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 758:	83 ec 04             	sub    $0x4,%esp
          s++;
 75b:	83 c6 01             	add    $0x1,%esi
 75e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 761:	6a 01                	push   $0x1
 763:	57                   	push   %edi
 764:	53                   	push   %ebx
 765:	e8 08 fd ff ff       	call   472 <write>
        while(*s != 0){
 76a:	0f b6 06             	movzbl (%esi),%eax
 76d:	83 c4 10             	add    $0x10,%esp
 770:	84 c0                	test   %al,%al
 772:	75 e4                	jne    758 <printf+0x148>
 774:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 777:	31 ff                	xor    %edi,%edi
 779:	e9 da fe ff ff       	jmp    658 <printf+0x48>
 77e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	b9 0a 00 00 00       	mov    $0xa,%ecx
 788:	6a 01                	push   $0x1
 78a:	e9 73 ff ff ff       	jmp    702 <printf+0xf2>
 78f:	90                   	nop
  write(fd, &c, 1);
 790:	83 ec 04             	sub    $0x4,%esp
 793:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 796:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 799:	6a 01                	push   $0x1
 79b:	e9 21 ff ff ff       	jmp    6c1 <printf+0xb1>
        putc(fd, *ap);
 7a0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 7a3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7a6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 7a8:	6a 01                	push   $0x1
        ap++;
 7aa:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 7ad:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 7b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7b3:	50                   	push   %eax
 7b4:	ff 75 08             	pushl  0x8(%ebp)
 7b7:	e8 b6 fc ff ff       	call   472 <write>
        ap++;
 7bc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 7bf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7c2:	31 ff                	xor    %edi,%edi
 7c4:	e9 8f fe ff ff       	jmp    658 <printf+0x48>
          s = "(null)";
 7c9:	bb 74 09 00 00       	mov    $0x974,%ebx
        while(*s != 0){
 7ce:	b8 28 00 00 00       	mov    $0x28,%eax
 7d3:	e9 72 ff ff ff       	jmp    74a <printf+0x13a>
 7d8:	66 90                	xchg   %ax,%ax
 7da:	66 90                	xchg   %ax,%ax
 7dc:	66 90                	xchg   %ax,%ax
 7de:	66 90                	xchg   %ax,%ax

000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e1:	a1 e0 0c 00 00       	mov    0xce0,%eax
{
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	57                   	push   %edi
 7e9:	56                   	push   %esi
 7ea:	53                   	push   %ebx
 7eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 7f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f8:	39 c8                	cmp    %ecx,%eax
 7fa:	8b 10                	mov    (%eax),%edx
 7fc:	73 32                	jae    830 <free+0x50>
 7fe:	39 d1                	cmp    %edx,%ecx
 800:	72 04                	jb     806 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 802:	39 d0                	cmp    %edx,%eax
 804:	72 32                	jb     838 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 806:	8b 73 fc             	mov    -0x4(%ebx),%esi
 809:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 80c:	39 fa                	cmp    %edi,%edx
 80e:	74 30                	je     840 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 810:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 813:	8b 50 04             	mov    0x4(%eax),%edx
 816:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 819:	39 f1                	cmp    %esi,%ecx
 81b:	74 3a                	je     857 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 81d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 81f:	a3 e0 0c 00 00       	mov    %eax,0xce0
}
 824:	5b                   	pop    %ebx
 825:	5e                   	pop    %esi
 826:	5f                   	pop    %edi
 827:	5d                   	pop    %ebp
 828:	c3                   	ret    
 829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	39 d0                	cmp    %edx,%eax
 832:	72 04                	jb     838 <free+0x58>
 834:	39 d1                	cmp    %edx,%ecx
 836:	72 ce                	jb     806 <free+0x26>
{
 838:	89 d0                	mov    %edx,%eax
 83a:	eb bc                	jmp    7f8 <free+0x18>
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 840:	03 72 04             	add    0x4(%edx),%esi
 843:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	8b 10                	mov    (%eax),%edx
 848:	8b 12                	mov    (%edx),%edx
 84a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 84d:	8b 50 04             	mov    0x4(%eax),%edx
 850:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 853:	39 f1                	cmp    %esi,%ecx
 855:	75 c6                	jne    81d <free+0x3d>
    p->s.size += bp->s.size;
 857:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 85a:	a3 e0 0c 00 00       	mov    %eax,0xce0
    p->s.size += bp->s.size;
 85f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 862:	8b 53 f8             	mov    -0x8(%ebx),%edx
 865:	89 10                	mov    %edx,(%eax)
}
 867:	5b                   	pop    %ebx
 868:	5e                   	pop    %esi
 869:	5f                   	pop    %edi
 86a:	5d                   	pop    %ebp
 86b:	c3                   	ret    
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000870 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	57                   	push   %edi
 874:	56                   	push   %esi
 875:	53                   	push   %ebx
 876:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 879:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 87c:	8b 15 e0 0c 00 00    	mov    0xce0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 882:	8d 78 07             	lea    0x7(%eax),%edi
 885:	c1 ef 03             	shr    $0x3,%edi
 888:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 88b:	85 d2                	test   %edx,%edx
 88d:	0f 84 9d 00 00 00    	je     930 <malloc+0xc0>
 893:	8b 02                	mov    (%edx),%eax
 895:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 898:	39 cf                	cmp    %ecx,%edi
 89a:	76 6c                	jbe    908 <malloc+0x98>
 89c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 8a2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8a7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8aa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8b1:	eb 0e                	jmp    8c1 <malloc+0x51>
 8b3:	90                   	nop
 8b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8ba:	8b 48 04             	mov    0x4(%eax),%ecx
 8bd:	39 f9                	cmp    %edi,%ecx
 8bf:	73 47                	jae    908 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c1:	39 05 e0 0c 00 00    	cmp    %eax,0xce0
 8c7:	89 c2                	mov    %eax,%edx
 8c9:	75 ed                	jne    8b8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8cb:	83 ec 0c             	sub    $0xc,%esp
 8ce:	56                   	push   %esi
 8cf:	e8 06 fc ff ff       	call   4da <sbrk>
  if(p == (char*)-1)
 8d4:	83 c4 10             	add    $0x10,%esp
 8d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 8da:	74 1c                	je     8f8 <malloc+0x88>
  hp->s.size = nu;
 8dc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8df:	83 ec 0c             	sub    $0xc,%esp
 8e2:	83 c0 08             	add    $0x8,%eax
 8e5:	50                   	push   %eax
 8e6:	e8 f5 fe ff ff       	call   7e0 <free>
  return freep;
 8eb:	8b 15 e0 0c 00 00    	mov    0xce0,%edx
      if((p = morecore(nunits)) == 0)
 8f1:	83 c4 10             	add    $0x10,%esp
 8f4:	85 d2                	test   %edx,%edx
 8f6:	75 c0                	jne    8b8 <malloc+0x48>
        return 0;
  }
}
 8f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8fb:	31 c0                	xor    %eax,%eax
}
 8fd:	5b                   	pop    %ebx
 8fe:	5e                   	pop    %esi
 8ff:	5f                   	pop    %edi
 900:	5d                   	pop    %ebp
 901:	c3                   	ret    
 902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 908:	39 cf                	cmp    %ecx,%edi
 90a:	74 54                	je     960 <malloc+0xf0>
        p->s.size -= nunits;
 90c:	29 f9                	sub    %edi,%ecx
 90e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 911:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 914:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 917:	89 15 e0 0c 00 00    	mov    %edx,0xce0
}
 91d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 920:	83 c0 08             	add    $0x8,%eax
}
 923:	5b                   	pop    %ebx
 924:	5e                   	pop    %esi
 925:	5f                   	pop    %edi
 926:	5d                   	pop    %ebp
 927:	c3                   	ret    
 928:	90                   	nop
 929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 930:	c7 05 e0 0c 00 00 e4 	movl   $0xce4,0xce0
 937:	0c 00 00 
 93a:	c7 05 e4 0c 00 00 e4 	movl   $0xce4,0xce4
 941:	0c 00 00 
    base.s.size = 0;
 944:	b8 e4 0c 00 00       	mov    $0xce4,%eax
 949:	c7 05 e8 0c 00 00 00 	movl   $0x0,0xce8
 950:	00 00 00 
 953:	e9 44 ff ff ff       	jmp    89c <malloc+0x2c>
 958:	90                   	nop
 959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 960:	8b 08                	mov    (%eax),%ecx
 962:	89 0a                	mov    %ecx,(%edx)
 964:	eb b1                	jmp    917 <malloc+0xa7>
