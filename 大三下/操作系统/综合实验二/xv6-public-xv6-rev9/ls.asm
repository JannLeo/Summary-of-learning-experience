
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
}

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

  if(argc < 2){
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 24                	jle    41 <main+0x41>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	pushl  (%ebx)
  2d:	83 c3 04             	add    $0x4,%ebx
  30:	e8 cb 00 00 00       	call   100 <ls>
  for(i=1; i<argc; i++)
  35:	83 c4 10             	add    $0x10,%esp
  38:	39 f3                	cmp    %esi,%ebx
  3a:	75 ec                	jne    28 <main+0x28>
  exit();
  3c:	e8 81 05 00 00       	call   5c2 <exit>
    ls(".");
  41:	83 ec 0c             	sub    $0xc,%esp
  44:	68 23 0b 00 00       	push   $0xb23
  49:	e8 b2 00 00 00       	call   100 <ls>
    exit();
  4e:	e8 6f 05 00 00       	call   5c2 <exit>
  53:	66 90                	xchg   %ax,%ax
  55:	66 90                	xchg   %ax,%ax
  57:	66 90                	xchg   %ax,%ax
  59:	66 90                	xchg   %ax,%ax
  5b:	66 90                	xchg   %ax,%ax
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <fmtname>:
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  68:	83 ec 0c             	sub    $0xc,%esp
  6b:	53                   	push   %ebx
  6c:	e8 7f 03 00 00       	call   3f0 <strlen>
  71:	83 c4 10             	add    $0x10,%esp
  74:	01 d8                	add    %ebx,%eax
  76:	73 0f                	jae    87 <fmtname+0x27>
  78:	eb 12                	jmp    8c <fmtname+0x2c>
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  80:	83 e8 01             	sub    $0x1,%eax
  83:	39 c3                	cmp    %eax,%ebx
  85:	77 05                	ja     8c <fmtname+0x2c>
  87:	80 38 2f             	cmpb   $0x2f,(%eax)
  8a:	75 f4                	jne    80 <fmtname+0x20>
  p++;
  8c:	8d 58 01             	lea    0x1(%eax),%ebx
  if(strlen(p) >= DIRSIZ)
  8f:	83 ec 0c             	sub    $0xc,%esp
  92:	53                   	push   %ebx
  93:	e8 58 03 00 00       	call   3f0 <strlen>
  98:	83 c4 10             	add    $0x10,%esp
  9b:	83 f8 0d             	cmp    $0xd,%eax
  9e:	77 4a                	ja     ea <fmtname+0x8a>
  memmove(buf, p, strlen(p));
  a0:	83 ec 0c             	sub    $0xc,%esp
  a3:	53                   	push   %ebx
  a4:	e8 47 03 00 00       	call   3f0 <strlen>
  a9:	83 c4 0c             	add    $0xc,%esp
  ac:	50                   	push   %eax
  ad:	53                   	push   %ebx
  ae:	68 4c 0e 00 00       	push   $0xe4c
  b3:	e8 d8 04 00 00       	call   590 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  b8:	89 1c 24             	mov    %ebx,(%esp)
  bb:	e8 30 03 00 00       	call   3f0 <strlen>
  c0:	89 1c 24             	mov    %ebx,(%esp)
  c3:	89 c6                	mov    %eax,%esi
  return buf;
  c5:	bb 4c 0e 00 00       	mov    $0xe4c,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ca:	e8 21 03 00 00       	call   3f0 <strlen>
  cf:	ba 0e 00 00 00       	mov    $0xe,%edx
  d4:	83 c4 0c             	add    $0xc,%esp
  d7:	05 4c 0e 00 00       	add    $0xe4c,%eax
  dc:	29 f2                	sub    %esi,%edx
  de:	52                   	push   %edx
  df:	6a 20                	push   $0x20
  e1:	50                   	push   %eax
  e2:	e8 39 03 00 00       	call   420 <memset>
  return buf;
  e7:	83 c4 10             	add    $0x10,%esp
}
  ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  ed:	89 d8                	mov    %ebx,%eax
  ef:	5b                   	pop    %ebx
  f0:	5e                   	pop    %esi
  f1:	5d                   	pop    %ebp
  f2:	c3                   	ret    
  f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <ls>:
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	81 ec 64 02 00 00    	sub    $0x264,%esp
 10c:	8b 75 08             	mov    0x8(%ebp),%esi
  if((fd = open(path, 0)) < 0){
 10f:	6a 00                	push   $0x0
 111:	56                   	push   %esi
 112:	e8 eb 04 00 00       	call   602 <open>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	85 c0                	test   %eax,%eax
 11c:	78 4a                	js     168 <ls+0x68>
  if(fstat(fd, &st) < 0){
 11e:	8d bd d4 fd ff ff    	lea    -0x22c(%ebp),%edi
 124:	83 ec 08             	sub    $0x8,%esp
 127:	89 c3                	mov    %eax,%ebx
 129:	57                   	push   %edi
 12a:	50                   	push   %eax
 12b:	e8 ea 04 00 00       	call   61a <fstat>
 130:	83 c4 10             	add    $0x10,%esp
 133:	85 c0                	test   %eax,%eax
 135:	0f 88 d5 00 00 00    	js     210 <ls+0x110>
  switch(st.type){
 13b:	0f b6 85 d4 fd ff ff 	movzbl -0x22c(%ebp),%eax
 142:	3c 01                	cmp    $0x1,%al
 144:	0f 84 96 00 00 00    	je     1e0 <ls+0xe0>
 14a:	3c 02                	cmp    $0x2,%al
 14c:	74 3a                	je     188 <ls+0x88>
  close(fd);
 14e:	83 ec 0c             	sub    $0xc,%esp
 151:	53                   	push   %ebx
 152:	e8 93 04 00 00       	call   5ea <close>
 157:	83 c4 10             	add    $0x10,%esp
}
 15a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 15d:	5b                   	pop    %ebx
 15e:	5e                   	pop    %esi
 15f:	5f                   	pop    %edi
 160:	5d                   	pop    %ebp
 161:	c3                   	ret    
 162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf(2, "ls: cannot open %s\n", path);
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	56                   	push   %esi
 16c:	68 d8 0a 00 00       	push   $0xad8
 171:	6a 02                	push   $0x2
 173:	e8 08 06 00 00       	call   780 <printf>
    return;
 178:	83 c4 10             	add    $0x10,%esp
}
 17b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 17e:	5b                   	pop    %ebx
 17f:	5e                   	pop    %esi
 180:	5f                   	pop    %edi
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    
 183:	90                   	nop
 184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "%s %d %d %d %d\n", fmtname(path), st.mode, st.type, st.ino, st.size);
 188:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 18e:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 194:	83 ec 0c             	sub    $0xc,%esp
 197:	56                   	push   %esi
 198:	0f be bd d5 fd ff ff 	movsbl -0x22b(%ebp),%edi
 19f:	89 8d b0 fd ff ff    	mov    %ecx,-0x250(%ebp)
 1a5:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 1ab:	e8 b0 fe ff ff       	call   60 <fmtname>
 1b0:	8b 8d b0 fd ff ff    	mov    -0x250(%ebp),%ecx
 1b6:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 1bc:	83 c4 0c             	add    $0xc,%esp
 1bf:	51                   	push   %ecx
 1c0:	52                   	push   %edx
 1c1:	6a 02                	push   $0x2
 1c3:	57                   	push   %edi
 1c4:	50                   	push   %eax
 1c5:	68 00 0b 00 00       	push   $0xb00
 1ca:	6a 01                	push   $0x1
 1cc:	e8 af 05 00 00       	call   780 <printf>
    break;
 1d1:	83 c4 20             	add    $0x20,%esp
 1d4:	e9 75 ff ff ff       	jmp    14e <ls+0x4e>
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1e0:	83 ec 0c             	sub    $0xc,%esp
 1e3:	56                   	push   %esi
 1e4:	e8 07 02 00 00       	call   3f0 <strlen>
 1e9:	83 c0 10             	add    $0x10,%eax
 1ec:	83 c4 10             	add    $0x10,%esp
 1ef:	3d 00 02 00 00       	cmp    $0x200,%eax
 1f4:	76 42                	jbe    238 <ls+0x138>
      printf(1, "ls: path too long\n");
 1f6:	83 ec 08             	sub    $0x8,%esp
 1f9:	68 10 0b 00 00       	push   $0xb10
 1fe:	6a 01                	push   $0x1
 200:	e8 7b 05 00 00       	call   780 <printf>
      break;
 205:	83 c4 10             	add    $0x10,%esp
 208:	e9 41 ff ff ff       	jmp    14e <ls+0x4e>
 20d:	8d 76 00             	lea    0x0(%esi),%esi
    printf(2, "ls: cannot stat %s\n", path);
 210:	83 ec 04             	sub    $0x4,%esp
 213:	56                   	push   %esi
 214:	68 ec 0a 00 00       	push   $0xaec
 219:	6a 02                	push   $0x2
 21b:	e8 60 05 00 00       	call   780 <printf>
    close(fd);
 220:	89 1c 24             	mov    %ebx,(%esp)
 223:	e8 c2 03 00 00       	call   5ea <close>
    return;
 228:	83 c4 10             	add    $0x10,%esp
}
 22b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 22e:	5b                   	pop    %ebx
 22f:	5e                   	pop    %esi
 230:	5f                   	pop    %edi
 231:	5d                   	pop    %ebp
 232:	c3                   	ret    
 233:	90                   	nop
 234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    strcpy(buf, path);
 238:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 23e:	83 ec 08             	sub    $0x8,%esp
 241:	56                   	push   %esi
 242:	8d b5 c4 fd ff ff    	lea    -0x23c(%ebp),%esi
 248:	50                   	push   %eax
 249:	e8 22 01 00 00       	call   370 <strcpy>
    p = buf+strlen(buf);
 24e:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 254:	89 04 24             	mov    %eax,(%esp)
 257:	e8 94 01 00 00       	call   3f0 <strlen>
 25c:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 262:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 265:	01 d0                	add    %edx,%eax
    *p++ = '/';
 267:	8d 48 01             	lea    0x1(%eax),%ecx
    p = buf+strlen(buf);
 26a:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
    *p++ = '/';
 270:	c6 00 2f             	movb   $0x2f,(%eax)
 273:	89 8d a0 fd ff ff    	mov    %ecx,-0x260(%ebp)
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 280:	83 ec 04             	sub    $0x4,%esp
 283:	6a 10                	push   $0x10
 285:	56                   	push   %esi
 286:	53                   	push   %ebx
 287:	e8 4e 03 00 00       	call   5da <read>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	83 f8 10             	cmp    $0x10,%eax
 292:	0f 85 b6 fe ff ff    	jne    14e <ls+0x4e>
      if(de.inum == 0)
 298:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 29f:	00 
 2a0:	74 de                	je     280 <ls+0x180>
      memmove(p, de.name, DIRSIZ);
 2a2:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 2a8:	83 ec 04             	sub    $0x4,%esp
 2ab:	6a 0e                	push   $0xe
 2ad:	50                   	push   %eax
 2ae:	ff b5 a0 fd ff ff    	pushl  -0x260(%ebp)
 2b4:	e8 d7 02 00 00       	call   590 <memmove>
      p[DIRSIZ] = 0;
 2b9:	8b 85 a4 fd ff ff    	mov    -0x25c(%ebp),%eax
 2bf:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 2c3:	58                   	pop    %eax
 2c4:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 2ca:	5a                   	pop    %edx
 2cb:	57                   	push   %edi
 2cc:	50                   	push   %eax
 2cd:	e8 2e 02 00 00       	call   500 <stat>
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	85 c0                	test   %eax,%eax
 2d7:	78 77                	js     350 <ls+0x250>
      printf(1, "%s %d %d %d %d\n", fmtname(buf), st.mode, st.type, st.ino, st.size);
 2d9:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 2df:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 2e5:	83 ec 0c             	sub    $0xc,%esp
 2e8:	0f be 85 d4 fd ff ff 	movsbl -0x22c(%ebp),%eax
 2ef:	89 8d a8 fd ff ff    	mov    %ecx,-0x258(%ebp)
 2f5:	89 95 ac fd ff ff    	mov    %edx,-0x254(%ebp)
 2fb:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
 301:	0f be 95 d5 fd ff ff 	movsbl -0x22b(%ebp),%edx
 308:	51                   	push   %ecx
 309:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 30f:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 315:	e8 46 fd ff ff       	call   60 <fmtname>
 31a:	8b 8d a8 fd ff ff    	mov    -0x258(%ebp),%ecx
 320:	8b 95 ac fd ff ff    	mov    -0x254(%ebp),%edx
 326:	83 c4 0c             	add    $0xc,%esp
 329:	51                   	push   %ecx
 32a:	52                   	push   %edx
 32b:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 331:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 337:	50                   	push   %eax
 338:	68 00 0b 00 00       	push   $0xb00
 33d:	6a 01                	push   $0x1
 33f:	e8 3c 04 00 00       	call   780 <printf>
 344:	83 c4 20             	add    $0x20,%esp
 347:	e9 34 ff ff ff       	jmp    280 <ls+0x180>
 34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "ls: cannot stat %s\n", buf);
 350:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 356:	83 ec 04             	sub    $0x4,%esp
 359:	50                   	push   %eax
 35a:	68 ec 0a 00 00       	push   $0xaec
 35f:	6a 01                	push   $0x1
 361:	e8 1a 04 00 00       	call   780 <printf>
        continue;
 366:	83 c4 10             	add    $0x10,%esp
 369:	e9 12 ff ff ff       	jmp    280 <ls+0x180>
 36e:	66 90                	xchg   %ax,%ax

00000370 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 37a:	89 c2                	mov    %eax,%edx
 37c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 380:	83 c1 01             	add    $0x1,%ecx
 383:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 387:	83 c2 01             	add    $0x1,%edx
 38a:	84 db                	test   %bl,%bl
 38c:	88 5a ff             	mov    %bl,-0x1(%edx)
 38f:	75 ef                	jne    380 <strcpy+0x10>
    ;
  return os;
}
 391:	5b                   	pop    %ebx
 392:	5d                   	pop    %ebp
 393:	c3                   	ret    
 394:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 39a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	53                   	push   %ebx
 3a4:	8b 55 08             	mov    0x8(%ebp),%edx
 3a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3aa:	0f b6 02             	movzbl (%edx),%eax
 3ad:	0f b6 19             	movzbl (%ecx),%ebx
 3b0:	84 c0                	test   %al,%al
 3b2:	75 1c                	jne    3d0 <strcmp+0x30>
 3b4:	eb 2a                	jmp    3e0 <strcmp+0x40>
 3b6:	8d 76 00             	lea    0x0(%esi),%esi
 3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 3c0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 3c3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 3c6:	83 c1 01             	add    $0x1,%ecx
 3c9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 3cc:	84 c0                	test   %al,%al
 3ce:	74 10                	je     3e0 <strcmp+0x40>
 3d0:	38 d8                	cmp    %bl,%al
 3d2:	74 ec                	je     3c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 3d4:	29 d8                	sub    %ebx,%eax
}
 3d6:	5b                   	pop    %ebx
 3d7:	5d                   	pop    %ebp
 3d8:	c3                   	ret    
 3d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 3e2:	29 d8                	sub    %ebx,%eax
}
 3e4:	5b                   	pop    %ebx
 3e5:	5d                   	pop    %ebp
 3e6:	c3                   	ret    
 3e7:	89 f6                	mov    %esi,%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003f0 <strlen>:

uint
strlen(char *s)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3f6:	80 39 00             	cmpb   $0x0,(%ecx)
 3f9:	74 15                	je     410 <strlen+0x20>
 3fb:	31 d2                	xor    %edx,%edx
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
 400:	83 c2 01             	add    $0x1,%edx
 403:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 407:	89 d0                	mov    %edx,%eax
 409:	75 f5                	jne    400 <strlen+0x10>
    ;
  return n;
}
 40b:	5d                   	pop    %ebp
 40c:	c3                   	ret    
 40d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 410:	31 c0                	xor    %eax,%eax
}
 412:	5d                   	pop    %ebp
 413:	c3                   	ret    
 414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 41a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000420 <memset>:

void*
memset(void *dst, int c, uint n)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 427:	8b 4d 10             	mov    0x10(%ebp),%ecx
 42a:	8b 45 0c             	mov    0xc(%ebp),%eax
 42d:	89 d7                	mov    %edx,%edi
 42f:	fc                   	cld    
 430:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 432:	89 d0                	mov    %edx,%eax
 434:	5f                   	pop    %edi
 435:	5d                   	pop    %ebp
 436:	c3                   	ret    
 437:	89 f6                	mov    %esi,%esi
 439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000440 <strchr>:

char*
strchr(const char *s, char c)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	53                   	push   %ebx
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 44a:	0f b6 10             	movzbl (%eax),%edx
 44d:	84 d2                	test   %dl,%dl
 44f:	74 1d                	je     46e <strchr+0x2e>
    if(*s == c)
 451:	38 d3                	cmp    %dl,%bl
 453:	89 d9                	mov    %ebx,%ecx
 455:	75 0d                	jne    464 <strchr+0x24>
 457:	eb 17                	jmp    470 <strchr+0x30>
 459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 460:	38 ca                	cmp    %cl,%dl
 462:	74 0c                	je     470 <strchr+0x30>
  for(; *s; s++)
 464:	83 c0 01             	add    $0x1,%eax
 467:	0f b6 10             	movzbl (%eax),%edx
 46a:	84 d2                	test   %dl,%dl
 46c:	75 f2                	jne    460 <strchr+0x20>
      return (char*)s;
  return 0;
 46e:	31 c0                	xor    %eax,%eax
}
 470:	5b                   	pop    %ebx
 471:	5d                   	pop    %ebp
 472:	c3                   	ret    
 473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000480 <gets>:

char*
gets(char *buf, int max)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 486:	31 f6                	xor    %esi,%esi
 488:	89 f3                	mov    %esi,%ebx
{
 48a:	83 ec 1c             	sub    $0x1c,%esp
 48d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 490:	eb 2f                	jmp    4c1 <gets+0x41>
 492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 498:	8d 45 e7             	lea    -0x19(%ebp),%eax
 49b:	83 ec 04             	sub    $0x4,%esp
 49e:	6a 01                	push   $0x1
 4a0:	50                   	push   %eax
 4a1:	6a 00                	push   $0x0
 4a3:	e8 32 01 00 00       	call   5da <read>
    if(cc < 1)
 4a8:	83 c4 10             	add    $0x10,%esp
 4ab:	85 c0                	test   %eax,%eax
 4ad:	7e 1c                	jle    4cb <gets+0x4b>
      break;
    buf[i++] = c;
 4af:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4b3:	83 c7 01             	add    $0x1,%edi
 4b6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 4b9:	3c 0a                	cmp    $0xa,%al
 4bb:	74 23                	je     4e0 <gets+0x60>
 4bd:	3c 0d                	cmp    $0xd,%al
 4bf:	74 1f                	je     4e0 <gets+0x60>
  for(i=0; i+1 < max; ){
 4c1:	83 c3 01             	add    $0x1,%ebx
 4c4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4c7:	89 fe                	mov    %edi,%esi
 4c9:	7c cd                	jl     498 <gets+0x18>
 4cb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 4cd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 4d0:	c6 03 00             	movb   $0x0,(%ebx)
}
 4d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d6:	5b                   	pop    %ebx
 4d7:	5e                   	pop    %esi
 4d8:	5f                   	pop    %edi
 4d9:	5d                   	pop    %ebp
 4da:	c3                   	ret    
 4db:	90                   	nop
 4dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4e0:	8b 75 08             	mov    0x8(%ebp),%esi
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	01 de                	add    %ebx,%esi
 4e8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 4ea:	c6 03 00             	movb   $0x0,(%ebx)
}
 4ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f0:	5b                   	pop    %ebx
 4f1:	5e                   	pop    %esi
 4f2:	5f                   	pop    %edi
 4f3:	5d                   	pop    %ebp
 4f4:	c3                   	ret    
 4f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000500 <stat>:

int
stat(char *n, struct stat *st)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	56                   	push   %esi
 504:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 505:	83 ec 08             	sub    $0x8,%esp
 508:	6a 00                	push   $0x0
 50a:	ff 75 08             	pushl  0x8(%ebp)
 50d:	e8 f0 00 00 00       	call   602 <open>
  if(fd < 0)
 512:	83 c4 10             	add    $0x10,%esp
 515:	85 c0                	test   %eax,%eax
 517:	78 27                	js     540 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 519:	83 ec 08             	sub    $0x8,%esp
 51c:	ff 75 0c             	pushl  0xc(%ebp)
 51f:	89 c3                	mov    %eax,%ebx
 521:	50                   	push   %eax
 522:	e8 f3 00 00 00       	call   61a <fstat>
  close(fd);
 527:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 52a:	89 c6                	mov    %eax,%esi
  close(fd);
 52c:	e8 b9 00 00 00       	call   5ea <close>
  return r;
 531:	83 c4 10             	add    $0x10,%esp
}
 534:	8d 65 f8             	lea    -0x8(%ebp),%esp
 537:	89 f0                	mov    %esi,%eax
 539:	5b                   	pop    %ebx
 53a:	5e                   	pop    %esi
 53b:	5d                   	pop    %ebp
 53c:	c3                   	ret    
 53d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 540:	be ff ff ff ff       	mov    $0xffffffff,%esi
 545:	eb ed                	jmp    534 <stat+0x34>
 547:	89 f6                	mov    %esi,%esi
 549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000550 <atoi>:

int
atoi(const char *s)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	53                   	push   %ebx
 554:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 557:	0f be 11             	movsbl (%ecx),%edx
 55a:	8d 42 d0             	lea    -0x30(%edx),%eax
 55d:	3c 09                	cmp    $0x9,%al
  n = 0;
 55f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 564:	77 1f                	ja     585 <atoi+0x35>
 566:	8d 76 00             	lea    0x0(%esi),%esi
 569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 570:	8d 04 80             	lea    (%eax,%eax,4),%eax
 573:	83 c1 01             	add    $0x1,%ecx
 576:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 57a:	0f be 11             	movsbl (%ecx),%edx
 57d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 580:	80 fb 09             	cmp    $0x9,%bl
 583:	76 eb                	jbe    570 <atoi+0x20>
  return n;
}
 585:	5b                   	pop    %ebx
 586:	5d                   	pop    %ebp
 587:	c3                   	ret    
 588:	90                   	nop
 589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000590 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	56                   	push   %esi
 594:	53                   	push   %ebx
 595:	8b 5d 10             	mov    0x10(%ebp),%ebx
 598:	8b 45 08             	mov    0x8(%ebp),%eax
 59b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 59e:	85 db                	test   %ebx,%ebx
 5a0:	7e 14                	jle    5b6 <memmove+0x26>
 5a2:	31 d2                	xor    %edx,%edx
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 5a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 5ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 5af:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 5b2:	39 d3                	cmp    %edx,%ebx
 5b4:	75 f2                	jne    5a8 <memmove+0x18>
  return vdst;
}
 5b6:	5b                   	pop    %ebx
 5b7:	5e                   	pop    %esi
 5b8:	5d                   	pop    %ebp
 5b9:	c3                   	ret    

000005ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ba:	b8 01 00 00 00       	mov    $0x1,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <exit>:
SYSCALL(exit)
 5c2:	b8 02 00 00 00       	mov    $0x2,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <wait>:
SYSCALL(wait)
 5ca:	b8 03 00 00 00       	mov    $0x3,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <pipe>:
SYSCALL(pipe)
 5d2:	b8 04 00 00 00       	mov    $0x4,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <read>:
SYSCALL(read)
 5da:	b8 05 00 00 00       	mov    $0x5,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <write>:
SYSCALL(write)
 5e2:	b8 10 00 00 00       	mov    $0x10,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <close>:
SYSCALL(close)
 5ea:	b8 15 00 00 00       	mov    $0x15,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <kill>:
SYSCALL(kill)
 5f2:	b8 06 00 00 00       	mov    $0x6,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <exec>:
SYSCALL(exec)
 5fa:	b8 07 00 00 00       	mov    $0x7,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <open>:
SYSCALL(open)
 602:	b8 0f 00 00 00       	mov    $0xf,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <mknod>:
SYSCALL(mknod)
 60a:	b8 11 00 00 00       	mov    $0x11,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <unlink>:
SYSCALL(unlink)
 612:	b8 12 00 00 00       	mov    $0x12,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <fstat>:
SYSCALL(fstat)
 61a:	b8 08 00 00 00       	mov    $0x8,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <link>:
SYSCALL(link)
 622:	b8 13 00 00 00       	mov    $0x13,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <mkdir>:
SYSCALL(mkdir)
 62a:	b8 14 00 00 00       	mov    $0x14,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <chdir>:
SYSCALL(chdir)
 632:	b8 09 00 00 00       	mov    $0x9,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <dup>:
SYSCALL(dup)
 63a:	b8 0a 00 00 00       	mov    $0xa,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <getpid>:
SYSCALL(getpid)
 642:	b8 0b 00 00 00       	mov    $0xb,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <sbrk>:
SYSCALL(sbrk)
 64a:	b8 0c 00 00 00       	mov    $0xc,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <sleep>:
SYSCALL(sleep)
 652:	b8 0d 00 00 00       	mov    $0xd,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <uptime>:
SYSCALL(uptime)
 65a:	b8 0e 00 00 00       	mov    $0xe,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <getcpuid>:
SYSCALL(getcpuid)
 662:	b8 16 00 00 00       	mov    $0x16,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <changepri>:
SYSCALL(changepri)
 66a:	b8 17 00 00 00       	mov    $0x17,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <sh_var_read>:
SYSCALL(sh_var_read)
 672:	b8 16 00 00 00       	mov    $0x16,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <sh_var_write>:
SYSCALL(sh_var_write)
 67a:	b8 17 00 00 00       	mov    $0x17,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <sem_create>:
SYSCALL(sem_create)
 682:	b8 18 00 00 00       	mov    $0x18,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <sem_free>:
SYSCALL(sem_free)
 68a:	b8 19 00 00 00       	mov    $0x19,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <sem_p>:
SYSCALL(sem_p)
 692:	b8 1a 00 00 00       	mov    $0x1a,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <sem_v>:
SYSCALL(sem_v)
 69a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <myMalloc>:
SYSCALL(myMalloc)
 6a2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <myFree>:
SYSCALL(myFree)
 6aa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    

000006b2 <myFork>:
SYSCALL(myFork)
 6b2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6b7:	cd 40                	int    $0x40
 6b9:	c3                   	ret    

000006ba <join>:
SYSCALL(join)
 6ba:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6bf:	cd 40                	int    $0x40
 6c1:	c3                   	ret    

000006c2 <clone>:
SYSCALL(clone)
 6c2:	b8 20 00 00 00       	mov    $0x20,%eax
 6c7:	cd 40                	int    $0x40
 6c9:	c3                   	ret    

000006ca <chmod>:
SYSCALL(chmod)
 6ca:	b8 21 00 00 00       	mov    $0x21,%eax
 6cf:	cd 40                	int    $0x40
 6d1:	c3                   	ret    

000006d2 <open_fifo>:
 6d2:	b8 22 00 00 00       	mov    $0x22,%eax
 6d7:	cd 40                	int    $0x40
 6d9:	c3                   	ret    
 6da:	66 90                	xchg   %ax,%ax
 6dc:	66 90                	xchg   %ax,%ax
 6de:	66 90                	xchg   %ax,%ax

000006e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6e9:	85 d2                	test   %edx,%edx
{
 6eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 6ee:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 6f0:	79 76                	jns    768 <printint+0x88>
 6f2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6f6:	74 70                	je     768 <printint+0x88>
    x = -xx;
 6f8:	f7 d8                	neg    %eax
    neg = 1;
 6fa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 701:	31 f6                	xor    %esi,%esi
 703:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 706:	eb 0a                	jmp    712 <printint+0x32>
 708:	90                   	nop
 709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 710:	89 fe                	mov    %edi,%esi
 712:	31 d2                	xor    %edx,%edx
 714:	8d 7e 01             	lea    0x1(%esi),%edi
 717:	f7 f1                	div    %ecx
 719:	0f b6 92 2c 0b 00 00 	movzbl 0xb2c(%edx),%edx
  }while((x /= base) != 0);
 720:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 722:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 725:	75 e9                	jne    710 <printint+0x30>
  if(neg)
 727:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 72a:	85 c0                	test   %eax,%eax
 72c:	74 08                	je     736 <printint+0x56>
    buf[i++] = '-';
 72e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 733:	8d 7e 02             	lea    0x2(%esi),%edi
 736:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 73a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 73d:	8d 76 00             	lea    0x0(%esi),%esi
 740:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 743:	83 ec 04             	sub    $0x4,%esp
 746:	83 ee 01             	sub    $0x1,%esi
 749:	6a 01                	push   $0x1
 74b:	53                   	push   %ebx
 74c:	57                   	push   %edi
 74d:	88 45 d7             	mov    %al,-0x29(%ebp)
 750:	e8 8d fe ff ff       	call   5e2 <write>

  while(--i >= 0)
 755:	83 c4 10             	add    $0x10,%esp
 758:	39 de                	cmp    %ebx,%esi
 75a:	75 e4                	jne    740 <printint+0x60>
    putc(fd, buf[i]);
}
 75c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 75f:	5b                   	pop    %ebx
 760:	5e                   	pop    %esi
 761:	5f                   	pop    %edi
 762:	5d                   	pop    %ebp
 763:	c3                   	ret    
 764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 768:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 76f:	eb 90                	jmp    701 <printint+0x21>
 771:	eb 0d                	jmp    780 <printf>
 773:	90                   	nop
 774:	90                   	nop
 775:	90                   	nop
 776:	90                   	nop
 777:	90                   	nop
 778:	90                   	nop
 779:	90                   	nop
 77a:	90                   	nop
 77b:	90                   	nop
 77c:	90                   	nop
 77d:	90                   	nop
 77e:	90                   	nop
 77f:	90                   	nop

00000780 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	57                   	push   %edi
 784:	56                   	push   %esi
 785:	53                   	push   %ebx
 786:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 789:	8b 75 0c             	mov    0xc(%ebp),%esi
 78c:	0f b6 1e             	movzbl (%esi),%ebx
 78f:	84 db                	test   %bl,%bl
 791:	0f 84 b3 00 00 00    	je     84a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 797:	8d 45 10             	lea    0x10(%ebp),%eax
 79a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 79d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 79f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 7a2:	eb 2f                	jmp    7d3 <printf+0x53>
 7a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 7a8:	83 f8 25             	cmp    $0x25,%eax
 7ab:	0f 84 a7 00 00 00    	je     858 <printf+0xd8>
  write(fd, &c, 1);
 7b1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 7b4:	83 ec 04             	sub    $0x4,%esp
 7b7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 7ba:	6a 01                	push   $0x1
 7bc:	50                   	push   %eax
 7bd:	ff 75 08             	pushl  0x8(%ebp)
 7c0:	e8 1d fe ff ff       	call   5e2 <write>
 7c5:	83 c4 10             	add    $0x10,%esp
 7c8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 7cb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 7cf:	84 db                	test   %bl,%bl
 7d1:	74 77                	je     84a <printf+0xca>
    if(state == 0){
 7d3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 7d5:	0f be cb             	movsbl %bl,%ecx
 7d8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7db:	74 cb                	je     7a8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7dd:	83 ff 25             	cmp    $0x25,%edi
 7e0:	75 e6                	jne    7c8 <printf+0x48>
      if(c == 'd'){
 7e2:	83 f8 64             	cmp    $0x64,%eax
 7e5:	0f 84 05 01 00 00    	je     8f0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7eb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7f1:	83 f9 70             	cmp    $0x70,%ecx
 7f4:	74 72                	je     868 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7f6:	83 f8 73             	cmp    $0x73,%eax
 7f9:	0f 84 99 00 00 00    	je     898 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ff:	83 f8 63             	cmp    $0x63,%eax
 802:	0f 84 08 01 00 00    	je     910 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 808:	83 f8 25             	cmp    $0x25,%eax
 80b:	0f 84 ef 00 00 00    	je     900 <printf+0x180>
  write(fd, &c, 1);
 811:	8d 45 e7             	lea    -0x19(%ebp),%eax
 814:	83 ec 04             	sub    $0x4,%esp
 817:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 81b:	6a 01                	push   $0x1
 81d:	50                   	push   %eax
 81e:	ff 75 08             	pushl  0x8(%ebp)
 821:	e8 bc fd ff ff       	call   5e2 <write>
 826:	83 c4 0c             	add    $0xc,%esp
 829:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 82c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 82f:	6a 01                	push   $0x1
 831:	50                   	push   %eax
 832:	ff 75 08             	pushl  0x8(%ebp)
 835:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 838:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 83a:	e8 a3 fd ff ff       	call   5e2 <write>
  for(i = 0; fmt[i]; i++){
 83f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 843:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 846:	84 db                	test   %bl,%bl
 848:	75 89                	jne    7d3 <printf+0x53>
    }
  }
}
 84a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 84d:	5b                   	pop    %ebx
 84e:	5e                   	pop    %esi
 84f:	5f                   	pop    %edi
 850:	5d                   	pop    %ebp
 851:	c3                   	ret    
 852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 858:	bf 25 00 00 00       	mov    $0x25,%edi
 85d:	e9 66 ff ff ff       	jmp    7c8 <printf+0x48>
 862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 868:	83 ec 0c             	sub    $0xc,%esp
 86b:	b9 10 00 00 00       	mov    $0x10,%ecx
 870:	6a 00                	push   $0x0
 872:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 875:	8b 45 08             	mov    0x8(%ebp),%eax
 878:	8b 17                	mov    (%edi),%edx
 87a:	e8 61 fe ff ff       	call   6e0 <printint>
        ap++;
 87f:	89 f8                	mov    %edi,%eax
 881:	83 c4 10             	add    $0x10,%esp
      state = 0;
 884:	31 ff                	xor    %edi,%edi
        ap++;
 886:	83 c0 04             	add    $0x4,%eax
 889:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 88c:	e9 37 ff ff ff       	jmp    7c8 <printf+0x48>
 891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 89b:	8b 08                	mov    (%eax),%ecx
        ap++;
 89d:	83 c0 04             	add    $0x4,%eax
 8a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 8a3:	85 c9                	test   %ecx,%ecx
 8a5:	0f 84 8e 00 00 00    	je     939 <printf+0x1b9>
        while(*s != 0){
 8ab:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 8ae:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 8b0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 8b2:	84 c0                	test   %al,%al
 8b4:	0f 84 0e ff ff ff    	je     7c8 <printf+0x48>
 8ba:	89 75 d0             	mov    %esi,-0x30(%ebp)
 8bd:	89 de                	mov    %ebx,%esi
 8bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8c2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 8c5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 8c8:	83 ec 04             	sub    $0x4,%esp
          s++;
 8cb:	83 c6 01             	add    $0x1,%esi
 8ce:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 8d1:	6a 01                	push   $0x1
 8d3:	57                   	push   %edi
 8d4:	53                   	push   %ebx
 8d5:	e8 08 fd ff ff       	call   5e2 <write>
        while(*s != 0){
 8da:	0f b6 06             	movzbl (%esi),%eax
 8dd:	83 c4 10             	add    $0x10,%esp
 8e0:	84 c0                	test   %al,%al
 8e2:	75 e4                	jne    8c8 <printf+0x148>
 8e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 8e7:	31 ff                	xor    %edi,%edi
 8e9:	e9 da fe ff ff       	jmp    7c8 <printf+0x48>
 8ee:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 8f0:	83 ec 0c             	sub    $0xc,%esp
 8f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8f8:	6a 01                	push   $0x1
 8fa:	e9 73 ff ff ff       	jmp    872 <printf+0xf2>
 8ff:	90                   	nop
  write(fd, &c, 1);
 900:	83 ec 04             	sub    $0x4,%esp
 903:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 906:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 909:	6a 01                	push   $0x1
 90b:	e9 21 ff ff ff       	jmp    831 <printf+0xb1>
        putc(fd, *ap);
 910:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 913:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 916:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 918:	6a 01                	push   $0x1
        ap++;
 91a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 91d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 920:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 923:	50                   	push   %eax
 924:	ff 75 08             	pushl  0x8(%ebp)
 927:	e8 b6 fc ff ff       	call   5e2 <write>
        ap++;
 92c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 92f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 932:	31 ff                	xor    %edi,%edi
 934:	e9 8f fe ff ff       	jmp    7c8 <printf+0x48>
          s = "(null)";
 939:	bb 25 0b 00 00       	mov    $0xb25,%ebx
        while(*s != 0){
 93e:	b8 28 00 00 00       	mov    $0x28,%eax
 943:	e9 72 ff ff ff       	jmp    8ba <printf+0x13a>
 948:	66 90                	xchg   %ax,%ax
 94a:	66 90                	xchg   %ax,%ax
 94c:	66 90                	xchg   %ax,%ax
 94e:	66 90                	xchg   %ax,%ax

00000950 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 950:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 951:	a1 5c 0e 00 00       	mov    0xe5c,%eax
{
 956:	89 e5                	mov    %esp,%ebp
 958:	57                   	push   %edi
 959:	56                   	push   %esi
 95a:	53                   	push   %ebx
 95b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 95e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 968:	39 c8                	cmp    %ecx,%eax
 96a:	8b 10                	mov    (%eax),%edx
 96c:	73 32                	jae    9a0 <free+0x50>
 96e:	39 d1                	cmp    %edx,%ecx
 970:	72 04                	jb     976 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 972:	39 d0                	cmp    %edx,%eax
 974:	72 32                	jb     9a8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 976:	8b 73 fc             	mov    -0x4(%ebx),%esi
 979:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 97c:	39 fa                	cmp    %edi,%edx
 97e:	74 30                	je     9b0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 980:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 983:	8b 50 04             	mov    0x4(%eax),%edx
 986:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 989:	39 f1                	cmp    %esi,%ecx
 98b:	74 3a                	je     9c7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 98d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 98f:	a3 5c 0e 00 00       	mov    %eax,0xe5c
}
 994:	5b                   	pop    %ebx
 995:	5e                   	pop    %esi
 996:	5f                   	pop    %edi
 997:	5d                   	pop    %ebp
 998:	c3                   	ret    
 999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a0:	39 d0                	cmp    %edx,%eax
 9a2:	72 04                	jb     9a8 <free+0x58>
 9a4:	39 d1                	cmp    %edx,%ecx
 9a6:	72 ce                	jb     976 <free+0x26>
{
 9a8:	89 d0                	mov    %edx,%eax
 9aa:	eb bc                	jmp    968 <free+0x18>
 9ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 9b0:	03 72 04             	add    0x4(%edx),%esi
 9b3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b6:	8b 10                	mov    (%eax),%edx
 9b8:	8b 12                	mov    (%edx),%edx
 9ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 9bd:	8b 50 04             	mov    0x4(%eax),%edx
 9c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 9c3:	39 f1                	cmp    %esi,%ecx
 9c5:	75 c6                	jne    98d <free+0x3d>
    p->s.size += bp->s.size;
 9c7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 9ca:	a3 5c 0e 00 00       	mov    %eax,0xe5c
    p->s.size += bp->s.size;
 9cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9d2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9d5:	89 10                	mov    %edx,(%eax)
}
 9d7:	5b                   	pop    %ebx
 9d8:	5e                   	pop    %esi
 9d9:	5f                   	pop    %edi
 9da:	5d                   	pop    %ebp
 9db:	c3                   	ret    
 9dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e0:	55                   	push   %ebp
 9e1:	89 e5                	mov    %esp,%ebp
 9e3:	57                   	push   %edi
 9e4:	56                   	push   %esi
 9e5:	53                   	push   %ebx
 9e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9ec:	8b 15 5c 0e 00 00    	mov    0xe5c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f2:	8d 78 07             	lea    0x7(%eax),%edi
 9f5:	c1 ef 03             	shr    $0x3,%edi
 9f8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 9fb:	85 d2                	test   %edx,%edx
 9fd:	0f 84 9d 00 00 00    	je     aa0 <malloc+0xc0>
 a03:	8b 02                	mov    (%edx),%eax
 a05:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 a08:	39 cf                	cmp    %ecx,%edi
 a0a:	76 6c                	jbe    a78 <malloc+0x98>
 a0c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 a12:	bb 00 10 00 00       	mov    $0x1000,%ebx
 a17:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 a1a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 a21:	eb 0e                	jmp    a31 <malloc+0x51>
 a23:	90                   	nop
 a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a28:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a2a:	8b 48 04             	mov    0x4(%eax),%ecx
 a2d:	39 f9                	cmp    %edi,%ecx
 a2f:	73 47                	jae    a78 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a31:	39 05 5c 0e 00 00    	cmp    %eax,0xe5c
 a37:	89 c2                	mov    %eax,%edx
 a39:	75 ed                	jne    a28 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 a3b:	83 ec 0c             	sub    $0xc,%esp
 a3e:	56                   	push   %esi
 a3f:	e8 06 fc ff ff       	call   64a <sbrk>
  if(p == (char*)-1)
 a44:	83 c4 10             	add    $0x10,%esp
 a47:	83 f8 ff             	cmp    $0xffffffff,%eax
 a4a:	74 1c                	je     a68 <malloc+0x88>
  hp->s.size = nu;
 a4c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a4f:	83 ec 0c             	sub    $0xc,%esp
 a52:	83 c0 08             	add    $0x8,%eax
 a55:	50                   	push   %eax
 a56:	e8 f5 fe ff ff       	call   950 <free>
  return freep;
 a5b:	8b 15 5c 0e 00 00    	mov    0xe5c,%edx
      if((p = morecore(nunits)) == 0)
 a61:	83 c4 10             	add    $0x10,%esp
 a64:	85 d2                	test   %edx,%edx
 a66:	75 c0                	jne    a28 <malloc+0x48>
        return 0;
  }
}
 a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a6b:	31 c0                	xor    %eax,%eax
}
 a6d:	5b                   	pop    %ebx
 a6e:	5e                   	pop    %esi
 a6f:	5f                   	pop    %edi
 a70:	5d                   	pop    %ebp
 a71:	c3                   	ret    
 a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a78:	39 cf                	cmp    %ecx,%edi
 a7a:	74 54                	je     ad0 <malloc+0xf0>
        p->s.size -= nunits;
 a7c:	29 f9                	sub    %edi,%ecx
 a7e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a81:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a84:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 a87:	89 15 5c 0e 00 00    	mov    %edx,0xe5c
}
 a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a90:	83 c0 08             	add    $0x8,%eax
}
 a93:	5b                   	pop    %ebx
 a94:	5e                   	pop    %esi
 a95:	5f                   	pop    %edi
 a96:	5d                   	pop    %ebp
 a97:	c3                   	ret    
 a98:	90                   	nop
 a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 aa0:	c7 05 5c 0e 00 00 60 	movl   $0xe60,0xe5c
 aa7:	0e 00 00 
 aaa:	c7 05 60 0e 00 00 60 	movl   $0xe60,0xe60
 ab1:	0e 00 00 
    base.s.size = 0;
 ab4:	b8 60 0e 00 00       	mov    $0xe60,%eax
 ab9:	c7 05 64 0e 00 00 00 	movl   $0x0,0xe64
 ac0:	00 00 00 
 ac3:	e9 44 ff ff ff       	jmp    a0c <malloc+0x2c>
 ac8:	90                   	nop
 ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 ad0:	8b 08                	mov    (%eax),%ecx
 ad2:	89 0a                	mov    %ecx,(%edx)
 ad4:	eb b1                	jmp    a87 <malloc+0xa7>
