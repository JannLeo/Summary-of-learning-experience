
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 20 30 10 80       	mov    $0x80103020,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
80100046:	68 40 79 10 80       	push   $0x80107940
8010004b:	68 e0 c5 10 80       	push   $0x8010c5e0
80100050:	e8 cb 44 00 00       	call   80104520 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100055:	c7 05 f0 04 11 80 e4 	movl   $0x801104e4,0x801104f0
8010005c:	04 11 80 
  bcache.head.next = &bcache.head;
8010005f:	c7 05 f4 04 11 80 e4 	movl   $0x801104e4,0x801104f4
80100066:	04 11 80 
80100069:	83 c4 10             	add    $0x10,%esp
8010006c:	b9 e4 04 11 80       	mov    $0x801104e4,%ecx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100071:	b8 14 c6 10 80       	mov    $0x8010c614,%eax
80100076:	eb 0a                	jmp    80100082 <binit+0x42>
80100078:	90                   	nop
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d0                	mov    %edx,%eax
    b->next = bcache.head.next;
80100082:	89 48 10             	mov    %ecx,0x10(%eax)
    b->prev = &bcache.head;
80100085:	c7 40 0c e4 04 11 80 	movl   $0x801104e4,0xc(%eax)
8010008c:	89 c1                	mov    %eax,%ecx
    b->dev = -1;
8010008e:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
80100095:	8b 15 f4 04 11 80    	mov    0x801104f4,%edx
8010009b:	89 42 0c             	mov    %eax,0xc(%edx)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	8d 90 18 02 00 00    	lea    0x218(%eax),%edx
    bcache.head.next = b;
801000a4:	a3 f4 04 11 80       	mov    %eax,0x801104f4
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	81 fa e4 04 11 80    	cmp    $0x801104e4,%edx
801000af:	72 cf                	jb     80100080 <binit+0x40>
  }
}
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    
801000b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801000b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000c0 <bread>:
}

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000c0:	55                   	push   %ebp
801000c1:	89 e5                	mov    %esp,%ebp
801000c3:	57                   	push   %edi
801000c4:	56                   	push   %esi
801000c5:	53                   	push   %ebx
801000c6:	83 ec 18             	sub    $0x18,%esp
801000c9:	8b 75 08             	mov    0x8(%ebp),%esi
801000cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000cf:	68 e0 c5 10 80       	push   $0x8010c5e0
801000d4:	e8 67 44 00 00       	call   80104540 <acquire>
801000d9:	83 c4 10             	add    $0x10,%esp
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000dc:	8b 1d f4 04 11 80    	mov    0x801104f4,%ebx
801000e2:	81 fb e4 04 11 80    	cmp    $0x801104e4,%ebx
801000e8:	75 11                	jne    801000fb <bread+0x3b>
801000ea:	eb 34                	jmp    80100120 <bread+0x60>
801000ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801000f0:	8b 5b 10             	mov    0x10(%ebx),%ebx
801000f3:	81 fb e4 04 11 80    	cmp    $0x801104e4,%ebx
801000f9:	74 25                	je     80100120 <bread+0x60>
    if(b->dev == dev && b->blockno == blockno){
801000fb:	3b 73 04             	cmp    0x4(%ebx),%esi
801000fe:	75 f0                	jne    801000f0 <bread+0x30>
80100100:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100103:	75 eb                	jne    801000f0 <bread+0x30>
      if(!(b->flags & B_BUSY)){
80100105:	8b 03                	mov    (%ebx),%eax
80100107:	a8 01                	test   $0x1,%al
80100109:	74 6c                	je     80100177 <bread+0xb7>
      sleep(b, &bcache.lock);
8010010b:	83 ec 08             	sub    $0x8,%esp
8010010e:	68 e0 c5 10 80       	push   $0x8010c5e0
80100113:	53                   	push   %ebx
80100114:	e8 97 3e 00 00       	call   80103fb0 <sleep>
80100119:	83 c4 10             	add    $0x10,%esp
8010011c:	eb be                	jmp    801000dc <bread+0x1c>
8010011e:	66 90                	xchg   %ax,%ax
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d f0 04 11 80    	mov    0x801104f0,%ebx
80100126:	81 fb e4 04 11 80    	cmp    $0x801104e4,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x7b>
8010012e:	eb 5e                	jmp    8010018e <bread+0xce>
80100130:	8b 5b 0c             	mov    0xc(%ebx),%ebx
80100133:	81 fb e4 04 11 80    	cmp    $0x801104e4,%ebx
80100139:	74 53                	je     8010018e <bread+0xce>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010013b:	f6 03 05             	testb  $0x5,(%ebx)
8010013e:	75 f0                	jne    80100130 <bread+0x70>
      release(&bcache.lock);
80100140:	83 ec 0c             	sub    $0xc,%esp
      b->dev = dev;
80100143:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
80100146:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = B_BUSY;
80100149:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      release(&bcache.lock);
8010014f:	68 e0 c5 10 80       	push   $0x8010c5e0
80100154:	e8 a7 45 00 00       	call   80104700 <release>
80100159:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
8010015c:	f6 03 02             	testb  $0x2,(%ebx)
8010015f:	75 0c                	jne    8010016d <bread+0xad>
    iderw(b);
80100161:	83 ec 0c             	sub    $0xc,%esp
80100164:	53                   	push   %ebx
80100165:	e8 96 1f 00 00       	call   80102100 <iderw>
8010016a:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
8010016d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100170:	89 d8                	mov    %ebx,%eax
80100172:	5b                   	pop    %ebx
80100173:	5e                   	pop    %esi
80100174:	5f                   	pop    %edi
80100175:	5d                   	pop    %ebp
80100176:	c3                   	ret    
        release(&bcache.lock);
80100177:	83 ec 0c             	sub    $0xc,%esp
        b->flags |= B_BUSY;
8010017a:	83 c8 01             	or     $0x1,%eax
8010017d:	89 03                	mov    %eax,(%ebx)
        release(&bcache.lock);
8010017f:	68 e0 c5 10 80       	push   $0x8010c5e0
80100184:	e8 77 45 00 00       	call   80104700 <release>
80100189:	83 c4 10             	add    $0x10,%esp
8010018c:	eb ce                	jmp    8010015c <bread+0x9c>
  panic("bget: no buffers");
8010018e:	83 ec 0c             	sub    $0xc,%esp
80100191:	68 47 79 10 80       	push   $0x80107947
80100196:	e8 d5 01 00 00       	call   80100370 <panic>
8010019b:	90                   	nop
8010019c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	83 ec 08             	sub    $0x8,%esp
801001a6:	8b 55 08             	mov    0x8(%ebp),%edx
  if((b->flags & B_BUSY) == 0)
801001a9:	8b 02                	mov    (%edx),%eax
801001ab:	a8 01                	test   $0x1,%al
801001ad:	74 0b                	je     801001ba <bwrite+0x1a>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001af:	83 c8 04             	or     $0x4,%eax
801001b2:	89 02                	mov    %eax,(%edx)
  iderw(b);
}
801001b4:	c9                   	leave  
  iderw(b);
801001b5:	e9 46 1f 00 00       	jmp    80102100 <iderw>
    panic("bwrite");
801001ba:	83 ec 0c             	sub    $0xc,%esp
801001bd:	68 58 79 10 80       	push   $0x80107958
801001c2:	e8 a9 01 00 00       	call   80100370 <panic>
801001c7:	89 f6                	mov    %esi,%esi
801001c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001d0 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001d0:	55                   	push   %ebp
801001d1:	89 e5                	mov    %esp,%ebp
801001d3:	53                   	push   %ebx
801001d4:	83 ec 04             	sub    $0x4,%esp
801001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
801001da:	f6 03 01             	testb  $0x1,(%ebx)
801001dd:	74 5a                	je     80100239 <brelse+0x69>
    panic("brelse");

  acquire(&bcache.lock);
801001df:	83 ec 0c             	sub    $0xc,%esp
801001e2:	68 e0 c5 10 80       	push   $0x8010c5e0
801001e7:	e8 54 43 00 00       	call   80104540 <acquire>

  b->next->prev = b->prev;
801001ec:	8b 43 10             	mov    0x10(%ebx),%eax
801001ef:	8b 53 0c             	mov    0xc(%ebx),%edx
801001f2:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
801001f5:	8b 43 0c             	mov    0xc(%ebx),%eax
801001f8:	8b 53 10             	mov    0x10(%ebx),%edx
801001fb:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
801001fe:	a1 f4 04 11 80       	mov    0x801104f4,%eax
  b->prev = &bcache.head;
80100203:	c7 43 0c e4 04 11 80 	movl   $0x801104e4,0xc(%ebx)
  b->next = bcache.head.next;
8010020a:	89 43 10             	mov    %eax,0x10(%ebx)
  bcache.head.next->prev = b;
8010020d:	a1 f4 04 11 80       	mov    0x801104f4,%eax
80100212:	89 58 0c             	mov    %ebx,0xc(%eax)
  bcache.head.next = b;
80100215:	89 1d f4 04 11 80    	mov    %ebx,0x801104f4

  b->flags &= ~B_BUSY;
8010021b:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  wakeup(b);
8010021e:	89 1c 24             	mov    %ebx,(%esp)
80100221:	e8 3a 3f 00 00       	call   80104160 <wakeup>

  release(&bcache.lock);
80100226:	83 c4 10             	add    $0x10,%esp
80100229:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100230:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100233:	c9                   	leave  
  release(&bcache.lock);
80100234:	e9 c7 44 00 00       	jmp    80104700 <release>
    panic("brelse");
80100239:	83 ec 0c             	sub    $0xc,%esp
8010023c:	68 5f 79 10 80       	push   $0x8010795f
80100241:	e8 2a 01 00 00       	call   80100370 <panic>
80100246:	66 90                	xchg   %ax,%ax
80100248:	66 90                	xchg   %ax,%ax
8010024a:	66 90                	xchg   %ax,%ax
8010024c:	66 90                	xchg   %ax,%ax
8010024e:	66 90                	xchg   %ax,%ax

80100250 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100250:	55                   	push   %ebp
80100251:	89 e5                	mov    %esp,%ebp
80100253:	57                   	push   %edi
80100254:	56                   	push   %esi
80100255:	53                   	push   %ebx
80100256:	83 ec 28             	sub    $0x28,%esp
80100259:	8b 7d 08             	mov    0x8(%ebp),%edi
8010025c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010025f:	57                   	push   %edi
80100260:	e8 bb 14 00 00       	call   80101720 <iunlock>
  target = n;
  acquire(&cons.lock);
80100265:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010026c:	e8 cf 42 00 00       	call   80104540 <acquire>
  while(n > 0){
80100271:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100274:	83 c4 10             	add    $0x10,%esp
80100277:	31 c0                	xor    %eax,%eax
80100279:	85 db                	test   %ebx,%ebx
8010027b:	0f 8e a1 00 00 00    	jle    80100322 <consoleread+0xd2>
    while(input.r == input.w){
80100281:	8b 15 80 07 11 80    	mov    0x80110780,%edx
80100287:	39 15 84 07 11 80    	cmp    %edx,0x80110784
8010028d:	74 2c                	je     801002bb <consoleread+0x6b>
8010028f:	eb 5f                	jmp    801002f0 <consoleread+0xa0>
80100291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(proc->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100298:	83 ec 08             	sub    $0x8,%esp
8010029b:	68 20 b5 10 80       	push   $0x8010b520
801002a0:	68 80 07 11 80       	push   $0x80110780
801002a5:	e8 06 3d 00 00       	call   80103fb0 <sleep>
    while(input.r == input.w){
801002aa:	8b 15 80 07 11 80    	mov    0x80110780,%edx
801002b0:	83 c4 10             	add    $0x10,%esp
801002b3:	3b 15 84 07 11 80    	cmp    0x80110784,%edx
801002b9:	75 35                	jne    801002f0 <consoleread+0xa0>
      if(proc->killed){
801002bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002c1:	8b 40 24             	mov    0x24(%eax),%eax
801002c4:	85 c0                	test   %eax,%eax
801002c6:	74 d0                	je     80100298 <consoleread+0x48>
        release(&cons.lock);
801002c8:	83 ec 0c             	sub    $0xc,%esp
801002cb:	68 20 b5 10 80       	push   $0x8010b520
801002d0:	e8 2b 44 00 00       	call   80104700 <release>
        ilock(ip);
801002d5:	89 3c 24             	mov    %edi,(%esp)
801002d8:	e8 33 13 00 00       	call   80101610 <ilock>
        return -1;
801002dd:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
801002e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801002e8:	5b                   	pop    %ebx
801002e9:	5e                   	pop    %esi
801002ea:	5f                   	pop    %edi
801002eb:	5d                   	pop    %ebp
801002ec:	c3                   	ret    
801002ed:	8d 76 00             	lea    0x0(%esi),%esi
    c = input.buf[input.r++ % INPUT_BUF];
801002f0:	8d 42 01             	lea    0x1(%edx),%eax
801002f3:	a3 80 07 11 80       	mov    %eax,0x80110780
801002f8:	89 d0                	mov    %edx,%eax
801002fa:	83 e0 7f             	and    $0x7f,%eax
801002fd:	0f be 80 00 07 11 80 	movsbl -0x7feef900(%eax),%eax
    if(c == C('D')){  // EOF
80100304:	83 f8 04             	cmp    $0x4,%eax
80100307:	74 3f                	je     80100348 <consoleread+0xf8>
    *dst++ = c;
80100309:	83 c6 01             	add    $0x1,%esi
    --n;
8010030c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010030f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100312:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100315:	74 43                	je     8010035a <consoleread+0x10a>
  while(n > 0){
80100317:	85 db                	test   %ebx,%ebx
80100319:	0f 85 62 ff ff ff    	jne    80100281 <consoleread+0x31>
8010031f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100322:	83 ec 0c             	sub    $0xc,%esp
80100325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100328:	68 20 b5 10 80       	push   $0x8010b520
8010032d:	e8 ce 43 00 00       	call   80104700 <release>
  ilock(ip);
80100332:	89 3c 24             	mov    %edi,(%esp)
80100335:	e8 d6 12 00 00       	call   80101610 <ilock>
  return target - n;
8010033a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010033d:	83 c4 10             	add    $0x10,%esp
}
80100340:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100343:	5b                   	pop    %ebx
80100344:	5e                   	pop    %esi
80100345:	5f                   	pop    %edi
80100346:	5d                   	pop    %ebp
80100347:	c3                   	ret    
80100348:	8b 45 10             	mov    0x10(%ebp),%eax
8010034b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010034d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100350:	73 d0                	jae    80100322 <consoleread+0xd2>
        input.r--;
80100352:	89 15 80 07 11 80    	mov    %edx,0x80110780
80100358:	eb c8                	jmp    80100322 <consoleread+0xd2>
8010035a:	8b 45 10             	mov    0x10(%ebp),%eax
8010035d:	29 d8                	sub    %ebx,%eax
8010035f:	eb c1                	jmp    80100322 <consoleread+0xd2>
80100361:	eb 0d                	jmp    80100370 <panic>
80100363:	90                   	nop
80100364:	90                   	nop
80100365:	90                   	nop
80100366:	90                   	nop
80100367:	90                   	nop
80100368:	90                   	nop
80100369:	90                   	nop
8010036a:	90                   	nop
8010036b:	90                   	nop
8010036c:	90                   	nop
8010036d:	90                   	nop
8010036e:	90                   	nop
8010036f:	90                   	nop

80100370 <panic>:
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 38             	sub    $0x38,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100379:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cons.locking = 0;
8010037f:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100386:	00 00 00 
  getcallerpcs(&s, pcs);
80100389:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010038c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010038f:	0f b6 00             	movzbl (%eax),%eax
80100392:	50                   	push   %eax
80100393:	68 66 79 10 80       	push   $0x80107966
80100398:	e8 a3 02 00 00       	call   80100640 <cprintf>
  cprintf(s);
8010039d:	58                   	pop    %eax
8010039e:	ff 75 08             	pushl  0x8(%ebp)
801003a1:	e8 9a 02 00 00       	call   80100640 <cprintf>
  cprintf("\n");
801003a6:	c7 04 24 86 7e 10 80 	movl   $0x80107e86,(%esp)
801003ad:	e8 8e 02 00 00       	call   80100640 <cprintf>
  getcallerpcs(&s, pcs);
801003b2:	5a                   	pop    %edx
801003b3:	8d 45 08             	lea    0x8(%ebp),%eax
801003b6:	59                   	pop    %ecx
801003b7:	53                   	push   %ebx
801003b8:	50                   	push   %eax
801003b9:	e8 42 42 00 00       	call   80104600 <getcallerpcs>
801003be:	83 c4 10             	add    $0x10,%esp
801003c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003c8:	83 ec 08             	sub    $0x8,%esp
801003cb:	ff 33                	pushl  (%ebx)
801003cd:	83 c3 04             	add    $0x4,%ebx
801003d0:	68 82 79 10 80       	push   $0x80107982
801003d5:	e8 66 02 00 00       	call   80100640 <cprintf>
  for(i=0; i<10; i++)
801003da:	83 c4 10             	add    $0x10,%esp
801003dd:	39 f3                	cmp    %esi,%ebx
801003df:	75 e7                	jne    801003c8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003e1:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e8:	00 00 00 
801003eb:	eb fe                	jmp    801003eb <panic+0x7b>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi

801003f0 <consputc>:
  if(panicked){
801003f0:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801003f6:	85 c9                	test   %ecx,%ecx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c6                	mov    %eax,%esi
80100408:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b1 00 00 00    	je     801004c7 <consputc+0xd7>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 91 5d 00 00       	call   801061b0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 da                	mov    %ebx,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100434:	89 ca                	mov    %ecx,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 da                	mov    %ebx,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c7                	mov    %eax,%edi
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 ca                	mov    %ecx,%edx
80100449:	ec                   	in     (%dx),%al
8010044a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010044d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010044f:	83 fe 0a             	cmp    $0xa,%esi
80100452:	0f 84 f3 00 00 00    	je     8010054b <consputc+0x15b>
  else if(c == BACKSPACE){
80100458:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010045e:	0f 84 d7 00 00 00    	je     8010053b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	89 f0                	mov    %esi,%eax
80100466:	0f b6 c0             	movzbl %al,%eax
80100469:	80 cc 07             	or     $0x7,%ah
8010046c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100473:	80 
80100474:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100477:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010047d:	0f 8f ab 00 00 00    	jg     8010052e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
80100483:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100489:	7f 66                	jg     801004f1 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100490:	b8 0e 00 00 00       	mov    $0xe,%eax
80100495:	89 f2                	mov    %esi,%edx
80100497:	ee                   	out    %al,(%dx)
80100498:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	c1 f8 08             	sar    $0x8,%eax
801004a2:	89 ca                	mov    %ecx,%edx
801004a4:	ee                   	out    %al,(%dx)
801004a5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004aa:	89 f2                	mov    %esi,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	89 d8                	mov    %ebx,%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004be:	80 
}
801004bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c2:	5b                   	pop    %ebx
801004c3:	5e                   	pop    %esi
801004c4:	5f                   	pop    %edi
801004c5:	5d                   	pop    %ebp
801004c6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004c7:	83 ec 0c             	sub    $0xc,%esp
801004ca:	6a 08                	push   $0x8
801004cc:	e8 df 5c 00 00       	call   801061b0 <uartputc>
801004d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004d8:	e8 d3 5c 00 00       	call   801061b0 <uartputc>
801004dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004e4:	e8 c7 5c 00 00       	call   801061b0 <uartputc>
801004e9:	83 c4 10             	add    $0x10,%esp
801004ec:	e9 31 ff ff ff       	jmp    80100422 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f1:	52                   	push   %edx
801004f2:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
801004f7:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fa:	68 a0 80 0b 80       	push   $0x800b80a0
801004ff:	68 00 80 0b 80       	push   $0x800b8000
80100504:	e8 87 45 00 00       	call   80104a90 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100509:	b8 80 07 00 00       	mov    $0x780,%eax
8010050e:	83 c4 0c             	add    $0xc,%esp
80100511:	29 d8                	sub    %ebx,%eax
80100513:	01 c0                	add    %eax,%eax
80100515:	50                   	push   %eax
80100516:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100519:	6a 00                	push   $0x0
8010051b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100520:	50                   	push   %eax
80100521:	e8 ba 44 00 00       	call   801049e0 <memset>
80100526:	83 c4 10             	add    $0x10,%esp
80100529:	e9 5d ff ff ff       	jmp    8010048b <consputc+0x9b>
    panic("pos under/overflow");
8010052e:	83 ec 0c             	sub    $0xc,%esp
80100531:	68 86 79 10 80       	push   $0x80107986
80100536:	e8 35 fe ff ff       	call   80100370 <panic>
    if(pos > 0) --pos;
8010053b:	85 db                	test   %ebx,%ebx
8010053d:	0f 84 48 ff ff ff    	je     8010048b <consputc+0x9b>
80100543:	83 eb 01             	sub    $0x1,%ebx
80100546:	e9 2c ff ff ff       	jmp    80100477 <consputc+0x87>
    pos += 80 - pos%80;
8010054b:	89 d8                	mov    %ebx,%eax
8010054d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100552:	99                   	cltd   
80100553:	f7 f9                	idiv   %ecx
80100555:	29 d1                	sub    %edx,%ecx
80100557:	01 cb                	add    %ecx,%ebx
80100559:	e9 19 ff ff ff       	jmp    80100477 <consputc+0x87>
8010055e:	66 90                	xchg   %ax,%ax

80100560 <printint>:
{
80100560:	55                   	push   %ebp
80100561:	89 e5                	mov    %esp,%ebp
80100563:	57                   	push   %edi
80100564:	56                   	push   %esi
80100565:	53                   	push   %ebx
80100566:	89 d3                	mov    %edx,%ebx
80100568:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010056b:	85 c9                	test   %ecx,%ecx
{
8010056d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100570:	74 04                	je     80100576 <printint+0x16>
80100572:	85 c0                	test   %eax,%eax
80100574:	78 5a                	js     801005d0 <printint+0x70>
    x = xx;
80100576:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010057d:	31 c9                	xor    %ecx,%ecx
8010057f:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100582:	eb 06                	jmp    8010058a <printint+0x2a>
80100584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
80100588:	89 f9                	mov    %edi,%ecx
8010058a:	31 d2                	xor    %edx,%edx
8010058c:	8d 79 01             	lea    0x1(%ecx),%edi
8010058f:	f7 f3                	div    %ebx
80100591:	0f b6 92 b4 79 10 80 	movzbl -0x7fef864c(%edx),%edx
  }while((x /= base) != 0);
80100598:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
8010059a:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
8010059d:	75 e9                	jne    80100588 <printint+0x28>
  if(sign)
8010059f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005a2:	85 c0                	test   %eax,%eax
801005a4:	74 08                	je     801005ae <printint+0x4e>
    buf[i++] = '-';
801005a6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005ab:	8d 79 02             	lea    0x2(%ecx),%edi
801005ae:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005b8:	0f be 03             	movsbl (%ebx),%eax
801005bb:	83 eb 01             	sub    $0x1,%ebx
801005be:	e8 2d fe ff ff       	call   801003f0 <consputc>
  while(--i >= 0)
801005c3:	39 f3                	cmp    %esi,%ebx
801005c5:	75 f1                	jne    801005b8 <printint+0x58>
}
801005c7:	83 c4 2c             	add    $0x2c,%esp
801005ca:	5b                   	pop    %ebx
801005cb:	5e                   	pop    %esi
801005cc:	5f                   	pop    %edi
801005cd:	5d                   	pop    %ebp
801005ce:	c3                   	ret    
801005cf:	90                   	nop
    x = -xx;
801005d0:	f7 d8                	neg    %eax
801005d2:	eb a9                	jmp    8010057d <printint+0x1d>
801005d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005e0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005e0:	55                   	push   %ebp
801005e1:	89 e5                	mov    %esp,%ebp
801005e3:	57                   	push   %edi
801005e4:	56                   	push   %esi
801005e5:	53                   	push   %ebx
801005e6:	83 ec 18             	sub    $0x18,%esp
801005e9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ec:	ff 75 08             	pushl  0x8(%ebp)
801005ef:	e8 2c 11 00 00       	call   80101720 <iunlock>
  acquire(&cons.lock);
801005f4:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801005fb:	e8 40 3f 00 00       	call   80104540 <acquire>
  for(i = 0; i < n; i++)
80100600:	83 c4 10             	add    $0x10,%esp
80100603:	85 f6                	test   %esi,%esi
80100605:	7e 18                	jle    8010061f <consolewrite+0x3f>
80100607:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010060a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010060d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100610:	0f b6 07             	movzbl (%edi),%eax
80100613:	83 c7 01             	add    $0x1,%edi
80100616:	e8 d5 fd ff ff       	call   801003f0 <consputc>
  for(i = 0; i < n; i++)
8010061b:	39 fb                	cmp    %edi,%ebx
8010061d:	75 f1                	jne    80100610 <consolewrite+0x30>
  release(&cons.lock);
8010061f:	83 ec 0c             	sub    $0xc,%esp
80100622:	68 20 b5 10 80       	push   $0x8010b520
80100627:	e8 d4 40 00 00       	call   80104700 <release>
  ilock(ip);
8010062c:	58                   	pop    %eax
8010062d:	ff 75 08             	pushl  0x8(%ebp)
80100630:	e8 db 0f 00 00       	call   80101610 <ilock>

  return n;
}
80100635:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100638:	89 f0                	mov    %esi,%eax
8010063a:	5b                   	pop    %ebx
8010063b:	5e                   	pop    %esi
8010063c:	5f                   	pop    %edi
8010063d:	5d                   	pop    %ebp
8010063e:	c3                   	ret    
8010063f:	90                   	nop

80100640 <cprintf>:
{
80100640:	55                   	push   %ebp
80100641:	89 e5                	mov    %esp,%ebp
80100643:	57                   	push   %edi
80100644:	56                   	push   %esi
80100645:	53                   	push   %ebx
80100646:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100649:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010064e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100650:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100653:	0f 85 6f 01 00 00    	jne    801007c8 <cprintf+0x188>
  if (fmt == 0)
80100659:	8b 45 08             	mov    0x8(%ebp),%eax
8010065c:	85 c0                	test   %eax,%eax
8010065e:	89 c7                	mov    %eax,%edi
80100660:	0f 84 77 01 00 00    	je     801007dd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100666:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100669:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010066c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010066e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100671:	85 c0                	test   %eax,%eax
80100673:	75 56                	jne    801006cb <cprintf+0x8b>
80100675:	eb 79                	jmp    801006f0 <cprintf+0xb0>
80100677:	89 f6                	mov    %esi,%esi
80100679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
80100680:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
80100683:	85 d2                	test   %edx,%edx
80100685:	74 69                	je     801006f0 <cprintf+0xb0>
80100687:	83 c3 02             	add    $0x2,%ebx
    switch(c){
8010068a:	83 fa 70             	cmp    $0x70,%edx
8010068d:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
80100690:	0f 84 84 00 00 00    	je     8010071a <cprintf+0xda>
80100696:	7f 78                	jg     80100710 <cprintf+0xd0>
80100698:	83 fa 25             	cmp    $0x25,%edx
8010069b:	0f 84 ff 00 00 00    	je     801007a0 <cprintf+0x160>
801006a1:	83 fa 64             	cmp    $0x64,%edx
801006a4:	0f 85 8e 00 00 00    	jne    80100738 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006ad:	ba 0a 00 00 00       	mov    $0xa,%edx
801006b2:	8d 48 04             	lea    0x4(%eax),%ecx
801006b5:	8b 00                	mov    (%eax),%eax
801006b7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006ba:	b9 01 00 00 00       	mov    $0x1,%ecx
801006bf:	e8 9c fe ff ff       	call   80100560 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
801006c7:	85 c0                	test   %eax,%eax
801006c9:	74 25                	je     801006f0 <cprintf+0xb0>
801006cb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ce:	83 f8 25             	cmp    $0x25,%eax
801006d1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006d4:	74 aa                	je     80100680 <cprintf+0x40>
801006d6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006d9:	e8 12 fd ff ff       	call   801003f0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	0f b6 06             	movzbl (%esi),%eax
      continue;
801006e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801006e4:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e6:	85 c0                	test   %eax,%eax
801006e8:	75 e1                	jne    801006cb <cprintf+0x8b>
801006ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
801006f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801006f3:	85 c0                	test   %eax,%eax
801006f5:	74 10                	je     80100707 <cprintf+0xc7>
    release(&cons.lock);
801006f7:	83 ec 0c             	sub    $0xc,%esp
801006fa:	68 20 b5 10 80       	push   $0x8010b520
801006ff:	e8 fc 3f 00 00       	call   80104700 <release>
80100704:	83 c4 10             	add    $0x10,%esp
}
80100707:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010070a:	5b                   	pop    %ebx
8010070b:	5e                   	pop    %esi
8010070c:	5f                   	pop    %edi
8010070d:	5d                   	pop    %ebp
8010070e:	c3                   	ret    
8010070f:	90                   	nop
    switch(c){
80100710:	83 fa 73             	cmp    $0x73,%edx
80100713:	74 43                	je     80100758 <cprintf+0x118>
80100715:	83 fa 78             	cmp    $0x78,%edx
80100718:	75 1e                	jne    80100738 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010071a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010071d:	ba 10 00 00 00       	mov    $0x10,%edx
80100722:	8d 48 04             	lea    0x4(%eax),%ecx
80100725:	8b 00                	mov    (%eax),%eax
80100727:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010072a:	31 c9                	xor    %ecx,%ecx
8010072c:	e8 2f fe ff ff       	call   80100560 <printint>
      break;
80100731:	eb 91                	jmp    801006c4 <cprintf+0x84>
80100733:	90                   	nop
80100734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100738:	b8 25 00 00 00       	mov    $0x25,%eax
8010073d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100740:	e8 ab fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100745:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100748:	89 d0                	mov    %edx,%eax
8010074a:	e8 a1 fc ff ff       	call   801003f0 <consputc>
      break;
8010074f:	e9 70 ff ff ff       	jmp    801006c4 <cprintf+0x84>
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010075b:	8b 10                	mov    (%eax),%edx
8010075d:	8d 48 04             	lea    0x4(%eax),%ecx
80100760:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100763:	85 d2                	test   %edx,%edx
80100765:	74 49                	je     801007b0 <cprintf+0x170>
      for(; *s; s++)
80100767:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010076a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010076d:	84 c0                	test   %al,%al
8010076f:	0f 84 4f ff ff ff    	je     801006c4 <cprintf+0x84>
80100775:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100778:	89 d3                	mov    %edx,%ebx
8010077a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100780:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
80100783:	e8 68 fc ff ff       	call   801003f0 <consputc>
      for(; *s; s++)
80100788:	0f be 03             	movsbl (%ebx),%eax
8010078b:	84 c0                	test   %al,%al
8010078d:	75 f1                	jne    80100780 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
8010078f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100792:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100795:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100798:	e9 27 ff ff ff       	jmp    801006c4 <cprintf+0x84>
8010079d:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007a0:	b8 25 00 00 00       	mov    $0x25,%eax
801007a5:	e8 46 fc ff ff       	call   801003f0 <consputc>
      break;
801007aa:	e9 15 ff ff ff       	jmp    801006c4 <cprintf+0x84>
801007af:	90                   	nop
        s = "(null)";
801007b0:	ba 99 79 10 80       	mov    $0x80107999,%edx
      for(; *s; s++)
801007b5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007b8:	b8 28 00 00 00       	mov    $0x28,%eax
801007bd:	89 d3                	mov    %edx,%ebx
801007bf:	eb bf                	jmp    80100780 <cprintf+0x140>
801007c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007c8:	83 ec 0c             	sub    $0xc,%esp
801007cb:	68 20 b5 10 80       	push   $0x8010b520
801007d0:	e8 6b 3d 00 00       	call   80104540 <acquire>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	e9 7c fe ff ff       	jmp    80100659 <cprintf+0x19>
    panic("null fmt");
801007dd:	83 ec 0c             	sub    $0xc,%esp
801007e0:	68 a0 79 10 80       	push   $0x801079a0
801007e5:	e8 86 fb ff ff       	call   80100370 <panic>
801007ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801007f0 <consoleintr>:
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 38 3d 00 00       	call   80104540 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 e7 00 00 00    	je     80100908 <consoleintr+0x118>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 ec 00 00 00    	je     80100918 <consoleintr+0x128>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
      if(input.e != input.w){
80100831:	a1 88 07 11 80       	mov    0x80110788,%eax
80100836:	3b 05 84 07 11 80    	cmp    0x80110784,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 88 07 11 80       	mov    %eax,0x80110788
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 93 3e 00 00       	call   80104700 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 88 07 11 80       	mov    0x80110788,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 80 07 11 80    	sub    0x80110780,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 88 07 11 80    	mov    %edx,0x80110788
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 00 07 11 80    	mov    %cl,-0x7feef900(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c5 00 00 00    	je     80100991 <consoleintr+0x1a1>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 bc 00 00 00    	je     80100991 <consoleintr+0x1a1>
801008d5:	a1 80 07 11 80       	mov    0x80110780,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 88 07 11 80    	cmp    %eax,0x80110788
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801008ec:	a3 84 07 11 80       	mov    %eax,0x80110784
          wakeup(&input.r);
801008f1:	68 80 07 11 80       	push   $0x80110780
801008f6:	e8 65 38 00 00       	call   80104160 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100908:	be 01 00 00 00       	mov    $0x1,%esi
8010090d:	e9 fe fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100918:	a1 88 07 11 80       	mov    0x80110788,%eax
8010091d:	39 05 84 07 11 80    	cmp    %eax,0x80110784
80100923:	75 2b                	jne    80100950 <consoleintr+0x160>
80100925:	e9 e6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010092a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100930:	a3 88 07 11 80       	mov    %eax,0x80110788
        consputc(BACKSPACE);
80100935:	b8 00 01 00 00       	mov    $0x100,%eax
8010093a:	e8 b1 fa ff ff       	call   801003f0 <consputc>
      while(input.e != input.w &&
8010093f:	a1 88 07 11 80       	mov    0x80110788,%eax
80100944:	3b 05 84 07 11 80    	cmp    0x80110784,%eax
8010094a:	0f 84 c0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100950:	83 e8 01             	sub    $0x1,%eax
80100953:	89 c2                	mov    %eax,%edx
80100955:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100958:	80 ba 00 07 11 80 0a 	cmpb   $0xa,-0x7feef900(%edx)
8010095f:	75 cf                	jne    80100930 <consoleintr+0x140>
80100961:	e9 aa fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100966:	8d 76 00             	lea    0x0(%esi),%esi
80100969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 c4 38 00 00       	jmp    80104240 <procdump>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100980:	c6 80 00 07 11 80 0a 	movb   $0xa,-0x7feef900(%eax)
        consputc(c);
80100987:	b8 0a 00 00 00       	mov    $0xa,%eax
8010098c:	e8 5f fa ff ff       	call   801003f0 <consputc>
80100991:	a1 88 07 11 80       	mov    0x80110788,%eax
80100996:	e9 4e ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
8010099b:	90                   	nop
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009a0 <consoleinit>:

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 a9 79 10 80       	push   $0x801079a9
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 6b 3b 00 00       	call   80104520 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
801009b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
801009bc:	c7 05 4c 11 11 80 e0 	movl   $0x801005e0,0x8011114c
801009c3:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801009c6:	c7 05 48 11 11 80 50 	movl   $0x80100250,0x80111148
801009cd:	02 10 80 
  cons.locking = 1;
801009d0:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d7:	00 00 00 
  picenable(IRQ_KBD);
801009da:	e8 21 2a 00 00       	call   80103400 <picenable>
  ioapicenable(IRQ_KBD, 0);
801009df:	58                   	pop    %eax
801009e0:	5a                   	pop    %edx
801009e1:	6a 00                	push   $0x0
801009e3:	6a 01                	push   $0x1
801009e5:	e8 d6 18 00 00       	call   801022c0 <ioapicenable>
}
801009ea:	83 c4 10             	add    $0x10,%esp
801009ed:	c9                   	leave  
801009ee:	c3                   	ret    
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009fc:	e8 1f 23 00 00       	call   80102d20 <begin_op>
  if((ip = namei(path)) == 0){
80100a01:	83 ec 0c             	sub    $0xc,%esp
80100a04:	ff 75 08             	pushl  0x8(%ebp)
80100a07:	e8 a4 14 00 00       	call   80101eb0 <namei>
80100a0c:	83 c4 10             	add    $0x10,%esp
80100a0f:	85 c0                	test   %eax,%eax
80100a11:	0f 84 9d 01 00 00    	je     80100bb4 <exec+0x1c4>
    end_op();
    return -1;
  }
  ilock(ip);
80100a17:	83 ec 0c             	sub    $0xc,%esp
80100a1a:	89 c3                	mov    %eax,%ebx
80100a1c:	50                   	push   %eax
80100a1d:	e8 ee 0b 00 00       	call   80101610 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100a22:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a28:	6a 34                	push   $0x34
80100a2a:	6a 00                	push   $0x0
80100a2c:	50                   	push   %eax
80100a2d:	53                   	push   %ebx
80100a2e:	e8 fd 0e 00 00       	call   80101930 <readi>
80100a33:	83 c4 20             	add    $0x20,%esp
80100a36:	83 f8 33             	cmp    $0x33,%eax
80100a39:	77 25                	ja     80100a60 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a3b:	83 ec 0c             	sub    $0xc,%esp
80100a3e:	53                   	push   %ebx
80100a3f:	e8 9c 0e 00 00       	call   801018e0 <iunlockput>
    end_op();
80100a44:	e8 47 23 00 00       	call   80102d90 <end_op>
80100a49:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a54:	5b                   	pop    %ebx
80100a55:	5e                   	pop    %esi
80100a56:	5f                   	pop    %edi
80100a57:	5d                   	pop    %ebp
80100a58:	c3                   	ret    
80100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a60:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a67:	45 4c 46 
80100a6a:	75 cf                	jne    80100a3b <exec+0x4b>
  if((pgdir = setupkvm()) == 0)
80100a6c:	e8 7f 64 00 00       	call   80106ef0 <setupkvm>
80100a71:	85 c0                	test   %eax,%eax
80100a73:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a79:	74 c0                	je     80100a3b <exec+0x4b>
  sz = 0;
80100a7b:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a7d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a84:	00 
80100a85:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100a8b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a91:	0f 84 89 02 00 00    	je     80100d20 <exec+0x330>
80100a97:	31 f6                	xor    %esi,%esi
80100a99:	eb 7f                	jmp    80100b1a <exec+0x12a>
80100a9b:	90                   	nop
80100a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100aa0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa7:	75 63                	jne    80100b0c <exec+0x11c>
    if(ph.memsz < ph.filesz)
80100aa9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aaf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab5:	0f 82 86 00 00 00    	jb     80100b41 <exec+0x151>
80100abb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ac1:	72 7e                	jb     80100b41 <exec+0x151>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ac3:	83 ec 04             	sub    $0x4,%esp
80100ac6:	50                   	push   %eax
80100ac7:	57                   	push   %edi
80100ac8:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ace:	e8 ad 66 00 00       	call   80107180 <allocuvm>
80100ad3:	83 c4 10             	add    $0x10,%esp
80100ad6:	85 c0                	test   %eax,%eax
80100ad8:	89 c7                	mov    %eax,%edi
80100ada:	74 65                	je     80100b41 <exec+0x151>
    if(ph.vaddr % PGSIZE != 0)
80100adc:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae2:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ae7:	75 58                	jne    80100b41 <exec+0x151>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ae9:	83 ec 0c             	sub    $0xc,%esp
80100aec:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100af2:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100af8:	53                   	push   %ebx
80100af9:	50                   	push   %eax
80100afa:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b00:	e8 bb 65 00 00       	call   801070c0 <loaduvm>
80100b05:	83 c4 20             	add    $0x20,%esp
80100b08:	85 c0                	test   %eax,%eax
80100b0a:	78 35                	js     80100b41 <exec+0x151>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b0c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b13:	83 c6 01             	add    $0x1,%esi
80100b16:	39 f0                	cmp    %esi,%eax
80100b18:	7e 46                	jle    80100b60 <exec+0x170>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b1a:	89 f0                	mov    %esi,%eax
80100b1c:	6a 20                	push   $0x20
80100b1e:	c1 e0 05             	shl    $0x5,%eax
80100b21:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100b27:	50                   	push   %eax
80100b28:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b2e:	50                   	push   %eax
80100b2f:	53                   	push   %ebx
80100b30:	e8 fb 0d 00 00       	call   80101930 <readi>
80100b35:	83 c4 10             	add    $0x10,%esp
80100b38:	83 f8 20             	cmp    $0x20,%eax
80100b3b:	0f 84 5f ff ff ff    	je     80100aa0 <exec+0xb0>
    freevm(pgdir);
80100b41:	83 ec 0c             	sub    $0xc,%esp
80100b44:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b4a:	e8 91 67 00 00       	call   801072e0 <freevm>
80100b4f:	83 c4 10             	add    $0x10,%esp
80100b52:	e9 e4 fe ff ff       	jmp    80100a3b <exec+0x4b>
80100b57:	89 f6                	mov    %esi,%esi
80100b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80100b60:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b66:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b6c:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b72:	83 ec 0c             	sub    $0xc,%esp
80100b75:	53                   	push   %ebx
80100b76:	e8 65 0d 00 00       	call   801018e0 <iunlockput>
  end_op();
80100b7b:	e8 10 22 00 00       	call   80102d90 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b80:	83 c4 0c             	add    $0xc,%esp
80100b83:	56                   	push   %esi
80100b84:	57                   	push   %edi
80100b85:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b8b:	e8 f0 65 00 00       	call   80107180 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	85 c0                	test   %eax,%eax
80100b95:	89 c6                	mov    %eax,%esi
80100b97:	75 2a                	jne    80100bc3 <exec+0x1d3>
    freevm(pgdir);
80100b99:	83 ec 0c             	sub    $0xc,%esp
80100b9c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba2:	e8 39 67 00 00       	call   801072e0 <freevm>
80100ba7:	83 c4 10             	add    $0x10,%esp
  return -1;
80100baa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100baf:	e9 9d fe ff ff       	jmp    80100a51 <exec+0x61>
    end_op();
80100bb4:	e8 d7 21 00 00       	call   80102d90 <end_op>
    return -1;
80100bb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bbe:	e9 8e fe ff ff       	jmp    80100a51 <exec+0x61>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bc3:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bc9:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bcc:	31 ff                	xor    %edi,%edi
80100bce:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bd0:	50                   	push   %eax
80100bd1:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bd7:	e8 84 67 00 00       	call   80107360 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bdf:	83 c4 10             	add    $0x10,%esp
80100be2:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100be8:	8b 00                	mov    (%eax),%eax
80100bea:	85 c0                	test   %eax,%eax
80100bec:	74 6f                	je     80100c5d <exec+0x26d>
80100bee:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100bf4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100bfa:	eb 09                	jmp    80100c05 <exec+0x215>
80100bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c00:	83 ff 20             	cmp    $0x20,%edi
80100c03:	74 94                	je     80100b99 <exec+0x1a9>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c05:	83 ec 0c             	sub    $0xc,%esp
80100c08:	50                   	push   %eax
80100c09:	e8 f2 3f 00 00       	call   80104c00 <strlen>
80100c0e:	f7 d0                	not    %eax
80100c10:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c12:	58                   	pop    %eax
80100c13:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c16:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c19:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c1c:	e8 df 3f 00 00       	call   80104c00 <strlen>
80100c21:	83 c0 01             	add    $0x1,%eax
80100c24:	50                   	push   %eax
80100c25:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c28:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c2b:	53                   	push   %ebx
80100c2c:	56                   	push   %esi
80100c2d:	e8 7e 68 00 00       	call   801074b0 <copyout>
80100c32:	83 c4 20             	add    $0x20,%esp
80100c35:	85 c0                	test   %eax,%eax
80100c37:	0f 88 5c ff ff ff    	js     80100b99 <exec+0x1a9>
  for(argc = 0; argv[argc]; argc++) {
80100c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c40:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c47:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c4a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c50:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c53:	85 c0                	test   %eax,%eax
80100c55:	75 a9                	jne    80100c00 <exec+0x210>
80100c57:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c5d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c64:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c66:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c6d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100c71:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c78:	ff ff ff 
  ustack[1] = argc;
80100c7b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100c83:	83 c0 0c             	add    $0xc,%eax
80100c86:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c88:	50                   	push   %eax
80100c89:	52                   	push   %edx
80100c8a:	53                   	push   %ebx
80100c8b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c91:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c97:	e8 14 68 00 00       	call   801074b0 <copyout>
80100c9c:	83 c4 10             	add    $0x10,%esp
80100c9f:	85 c0                	test   %eax,%eax
80100ca1:	0f 88 f2 fe ff ff    	js     80100b99 <exec+0x1a9>
  for(last=s=path; *s; s++)
80100ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80100caa:	8b 55 08             	mov    0x8(%ebp),%edx
80100cad:	0f b6 00             	movzbl (%eax),%eax
80100cb0:	84 c0                	test   %al,%al
80100cb2:	74 11                	je     80100cc5 <exec+0x2d5>
80100cb4:	89 d1                	mov    %edx,%ecx
80100cb6:	83 c1 01             	add    $0x1,%ecx
80100cb9:	3c 2f                	cmp    $0x2f,%al
80100cbb:	0f b6 01             	movzbl (%ecx),%eax
80100cbe:	0f 44 d1             	cmove  %ecx,%edx
80100cc1:	84 c0                	test   %al,%al
80100cc3:	75 f1                	jne    80100cb6 <exec+0x2c6>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cc5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ccb:	83 ec 04             	sub    $0x4,%esp
80100cce:	6a 10                	push   $0x10
80100cd0:	52                   	push   %edx
80100cd1:	83 c0 6c             	add    $0x6c,%eax
80100cd4:	50                   	push   %eax
80100cd5:	e8 e6 3e 00 00       	call   80104bc0 <safestrcpy>
  oldpgdir = proc->pgdir;
80100cda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100ce0:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
  oldpgdir = proc->pgdir;
80100ce6:	8b 78 04             	mov    0x4(%eax),%edi
  proc->sz = sz;
80100ce9:	89 30                	mov    %esi,(%eax)
  proc->pgdir = pgdir;
80100ceb:	89 50 04             	mov    %edx,0x4(%eax)
  proc->tf->eip = elf.entry;  // main
80100cee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cf4:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100cfa:	8b 50 18             	mov    0x18(%eax),%edx
80100cfd:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d00:	8b 50 18             	mov    0x18(%eax),%edx
80100d03:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d06:	89 04 24             	mov    %eax,(%esp)
80100d09:	e8 92 62 00 00       	call   80106fa0 <switchuvm>
  freevm(oldpgdir);
80100d0e:	89 3c 24             	mov    %edi,(%esp)
80100d11:	e8 ca 65 00 00       	call   801072e0 <freevm>
  return 0;
80100d16:	83 c4 10             	add    $0x10,%esp
80100d19:	31 c0                	xor    %eax,%eax
80100d1b:	e9 31 fd ff ff       	jmp    80100a51 <exec+0x61>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d20:	be 00 20 00 00       	mov    $0x2000,%esi
80100d25:	e9 48 fe ff ff       	jmp    80100b72 <exec+0x182>
80100d2a:	66 90                	xchg   %ax,%ax
80100d2c:	66 90                	xchg   %ax,%ax
80100d2e:	66 90                	xchg   %ax,%ax

80100d30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d36:	68 c5 79 10 80       	push   $0x801079c5
80100d3b:	68 a0 07 11 80       	push   $0x801107a0
80100d40:	e8 db 37 00 00       	call   80104520 <initlock>
}
80100d45:	83 c4 10             	add    $0x10,%esp
80100d48:	c9                   	leave  
80100d49:	c3                   	ret    
80100d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d54:	bb d4 07 11 80       	mov    $0x801107d4,%ebx
{
80100d59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d5c:	68 a0 07 11 80       	push   $0x801107a0
80100d61:	e8 da 37 00 00       	call   80104540 <acquire>
80100d66:	83 c4 10             	add    $0x10,%esp
80100d69:	eb 10                	jmp    80100d7b <filealloc+0x2b>
80100d6b:	90                   	nop
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d70:	83 c3 18             	add    $0x18,%ebx
80100d73:	81 fb 34 11 11 80    	cmp    $0x80111134,%ebx
80100d79:	73 25                	jae    80100da0 <filealloc+0x50>
    if(f->ref == 0){
80100d7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	75 ee                	jne    80100d70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100d85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d8c:	68 a0 07 11 80       	push   $0x801107a0
80100d91:	e8 6a 39 00 00       	call   80104700 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d96:	89 d8                	mov    %ebx,%eax
      return f;
80100d98:	83 c4 10             	add    $0x10,%esp
}
80100d9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d9e:	c9                   	leave  
80100d9f:	c3                   	ret    
  release(&ftable.lock);
80100da0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100da3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100da5:	68 a0 07 11 80       	push   $0x801107a0
80100daa:	e8 51 39 00 00       	call   80104700 <release>
}
80100daf:	89 d8                	mov    %ebx,%eax
  return 0;
80100db1:	83 c4 10             	add    $0x10,%esp
}
80100db4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100db7:	c9                   	leave  
80100db8:	c3                   	ret    
80100db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100dc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
80100dc4:	83 ec 10             	sub    $0x10,%esp
80100dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dca:	68 a0 07 11 80       	push   $0x801107a0
80100dcf:	e8 6c 37 00 00       	call   80104540 <acquire>
  if(f->ref < 1)
80100dd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100dd7:	83 c4 10             	add    $0x10,%esp
80100dda:	85 c0                	test   %eax,%eax
80100ddc:	7e 1a                	jle    80100df8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dde:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100de1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100de4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100de7:	68 a0 07 11 80       	push   $0x801107a0
80100dec:	e8 0f 39 00 00       	call   80104700 <release>
  return f;
}
80100df1:	89 d8                	mov    %ebx,%eax
80100df3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100df6:	c9                   	leave  
80100df7:	c3                   	ret    
    panic("filedup");
80100df8:	83 ec 0c             	sub    $0xc,%esp
80100dfb:	68 cc 79 10 80       	push   $0x801079cc
80100e00:	e8 6b f5 ff ff       	call   80100370 <panic>
80100e05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	57                   	push   %edi
80100e14:	56                   	push   %esi
80100e15:	53                   	push   %ebx
80100e16:	83 ec 28             	sub    $0x28,%esp
80100e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e1c:	68 a0 07 11 80       	push   $0x801107a0
80100e21:	e8 1a 37 00 00       	call   80104540 <acquire>
  if(f->ref < 1)
80100e26:	8b 43 04             	mov    0x4(%ebx),%eax
80100e29:	83 c4 10             	add    $0x10,%esp
80100e2c:	85 c0                	test   %eax,%eax
80100e2e:	0f 8e 9b 00 00 00    	jle    80100ecf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e34:	83 e8 01             	sub    $0x1,%eax
80100e37:	85 c0                	test   %eax,%eax
80100e39:	89 43 04             	mov    %eax,0x4(%ebx)
80100e3c:	74 1a                	je     80100e58 <fileclose+0x48>
    release(&ftable.lock);
80100e3e:	c7 45 08 a0 07 11 80 	movl   $0x801107a0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e48:	5b                   	pop    %ebx
80100e49:	5e                   	pop    %esi
80100e4a:	5f                   	pop    %edi
80100e4b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e4c:	e9 af 38 00 00       	jmp    80104700 <release>
80100e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e58:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e5c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e5e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e61:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e64:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e6a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e6d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100e70:	68 a0 07 11 80       	push   $0x801107a0
  ff = *f;
80100e75:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e78:	e8 83 38 00 00       	call   80104700 <release>
  if(ff.type == FD_PIPE)
80100e7d:	83 c4 10             	add    $0x10,%esp
80100e80:	83 ff 01             	cmp    $0x1,%edi
80100e83:	74 13                	je     80100e98 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100e85:	83 ff 02             	cmp    $0x2,%edi
80100e88:	74 26                	je     80100eb0 <fileclose+0xa0>
}
80100e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e8d:	5b                   	pop    %ebx
80100e8e:	5e                   	pop    %esi
80100e8f:	5f                   	pop    %edi
80100e90:	5d                   	pop    %ebp
80100e91:	c3                   	ret    
80100e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100e98:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100e9c:	83 ec 08             	sub    $0x8,%esp
80100e9f:	53                   	push   %ebx
80100ea0:	56                   	push   %esi
80100ea1:	e8 3a 27 00 00       	call   801035e0 <pipeclose>
80100ea6:	83 c4 10             	add    $0x10,%esp
80100ea9:	eb df                	jmp    80100e8a <fileclose+0x7a>
80100eab:	90                   	nop
80100eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100eb0:	e8 6b 1e 00 00       	call   80102d20 <begin_op>
    iput(ff.ip);
80100eb5:	83 ec 0c             	sub    $0xc,%esp
80100eb8:	ff 75 e0             	pushl  -0x20(%ebp)
80100ebb:	e8 c0 08 00 00       	call   80101780 <iput>
    end_op();
80100ec0:	83 c4 10             	add    $0x10,%esp
}
80100ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ec6:	5b                   	pop    %ebx
80100ec7:	5e                   	pop    %esi
80100ec8:	5f                   	pop    %edi
80100ec9:	5d                   	pop    %ebp
    end_op();
80100eca:	e9 c1 1e 00 00       	jmp    80102d90 <end_op>
    panic("fileclose");
80100ecf:	83 ec 0c             	sub    $0xc,%esp
80100ed2:	68 d4 79 10 80       	push   $0x801079d4
80100ed7:	e8 94 f4 ff ff       	call   80100370 <panic>
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	53                   	push   %ebx
80100ee4:	83 ec 04             	sub    $0x4,%esp
80100ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100eed:	75 31                	jne    80100f20 <filestat+0x40>
    ilock(f->ip);
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	ff 73 10             	pushl  0x10(%ebx)
80100ef5:	e8 16 07 00 00       	call   80101610 <ilock>
    stati(f->ip, st);
80100efa:	58                   	pop    %eax
80100efb:	5a                   	pop    %edx
80100efc:	ff 75 0c             	pushl  0xc(%ebp)
80100eff:	ff 73 10             	pushl  0x10(%ebx)
80100f02:	e8 f9 09 00 00       	call   80101900 <stati>
    iunlock(f->ip);
80100f07:	59                   	pop    %ecx
80100f08:	ff 73 10             	pushl  0x10(%ebx)
80100f0b:	e8 10 08 00 00       	call   80101720 <iunlock>
    return 0;
80100f10:	83 c4 10             	add    $0x10,%esp
80100f13:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f18:	c9                   	leave  
80100f19:	c3                   	ret    
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f25:	eb ee                	jmp    80100f15 <filestat+0x35>
80100f27:	89 f6                	mov    %esi,%esi
80100f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f30 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	57                   	push   %edi
80100f34:	56                   	push   %esi
80100f35:	53                   	push   %ebx
80100f36:	83 ec 0c             	sub    $0xc,%esp
80100f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f42:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f46:	74 60                	je     80100fa8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f48:	8b 03                	mov    (%ebx),%eax
80100f4a:	83 f8 01             	cmp    $0x1,%eax
80100f4d:	74 41                	je     80100f90 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f4f:	83 f8 02             	cmp    $0x2,%eax
80100f52:	75 5b                	jne    80100faf <fileread+0x7f>
    ilock(f->ip);
80100f54:	83 ec 0c             	sub    $0xc,%esp
80100f57:	ff 73 10             	pushl  0x10(%ebx)
80100f5a:	e8 b1 06 00 00       	call   80101610 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f5f:	57                   	push   %edi
80100f60:	ff 73 14             	pushl  0x14(%ebx)
80100f63:	56                   	push   %esi
80100f64:	ff 73 10             	pushl  0x10(%ebx)
80100f67:	e8 c4 09 00 00       	call   80101930 <readi>
80100f6c:	83 c4 20             	add    $0x20,%esp
80100f6f:	85 c0                	test   %eax,%eax
80100f71:	89 c6                	mov    %eax,%esi
80100f73:	7e 03                	jle    80100f78 <fileread+0x48>
      f->off += r;
80100f75:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f78:	83 ec 0c             	sub    $0xc,%esp
80100f7b:	ff 73 10             	pushl  0x10(%ebx)
80100f7e:	e8 9d 07 00 00       	call   80101720 <iunlock>
    return r;
80100f83:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f89:	89 f0                	mov    %esi,%eax
80100f8b:	5b                   	pop    %ebx
80100f8c:	5e                   	pop    %esi
80100f8d:	5f                   	pop    %edi
80100f8e:	5d                   	pop    %ebp
80100f8f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100f90:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f93:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f99:	5b                   	pop    %ebx
80100f9a:	5e                   	pop    %esi
80100f9b:	5f                   	pop    %edi
80100f9c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100f9d:	e9 0e 28 00 00       	jmp    801037b0 <piperead>
80100fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fa8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fad:	eb d7                	jmp    80100f86 <fileread+0x56>
  panic("fileread");
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	68 de 79 10 80       	push   $0x801079de
80100fb7:	e8 b4 f3 ff ff       	call   80100370 <panic>
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 1c             	sub    $0x1c,%esp
80100fc9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fcf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80100fd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fd6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100fdc:	0f 84 aa 00 00 00    	je     8010108c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100fe2:	8b 06                	mov    (%esi),%eax
80100fe4:	83 f8 01             	cmp    $0x1,%eax
80100fe7:	0f 84 c3 00 00 00    	je     801010b0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fed:	83 f8 02             	cmp    $0x2,%eax
80100ff0:	0f 85 d9 00 00 00    	jne    801010cf <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80100ff9:	31 ff                	xor    %edi,%edi
    while(i < n){
80100ffb:	85 c0                	test   %eax,%eax
80100ffd:	7f 34                	jg     80101033 <filewrite+0x73>
80100fff:	e9 9c 00 00 00       	jmp    801010a0 <filewrite+0xe0>
80101004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101008:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010100b:	83 ec 0c             	sub    $0xc,%esp
8010100e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101011:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101014:	e8 07 07 00 00       	call   80101720 <iunlock>
      end_op();
80101019:	e8 72 1d 00 00       	call   80102d90 <end_op>
8010101e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101021:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101024:	39 c3                	cmp    %eax,%ebx
80101026:	0f 85 96 00 00 00    	jne    801010c2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010102c:	01 df                	add    %ebx,%edi
    while(i < n){
8010102e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101031:	7e 6d                	jle    801010a0 <filewrite+0xe0>
      int n1 = n - i;
80101033:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101036:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010103b:	29 fb                	sub    %edi,%ebx
8010103d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101043:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101046:	e8 d5 1c 00 00       	call   80102d20 <begin_op>
      ilock(f->ip);
8010104b:	83 ec 0c             	sub    $0xc,%esp
8010104e:	ff 76 10             	pushl  0x10(%esi)
80101051:	e8 ba 05 00 00       	call   80101610 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101056:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101059:	53                   	push   %ebx
8010105a:	ff 76 14             	pushl  0x14(%esi)
8010105d:	01 f8                	add    %edi,%eax
8010105f:	50                   	push   %eax
80101060:	ff 76 10             	pushl  0x10(%esi)
80101063:	e8 c8 09 00 00       	call   80101a30 <writei>
80101068:	83 c4 20             	add    $0x20,%esp
8010106b:	85 c0                	test   %eax,%eax
8010106d:	7f 99                	jg     80101008 <filewrite+0x48>
      iunlock(f->ip);
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	ff 76 10             	pushl  0x10(%esi)
80101075:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101078:	e8 a3 06 00 00       	call   80101720 <iunlock>
      end_op();
8010107d:	e8 0e 1d 00 00       	call   80102d90 <end_op>
      if(r < 0)
80101082:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101085:	83 c4 10             	add    $0x10,%esp
80101088:	85 c0                	test   %eax,%eax
8010108a:	74 98                	je     80101024 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010108c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010108f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101094:	89 f8                	mov    %edi,%eax
80101096:	5b                   	pop    %ebx
80101097:	5e                   	pop    %esi
80101098:	5f                   	pop    %edi
80101099:	5d                   	pop    %ebp
8010109a:	c3                   	ret    
8010109b:	90                   	nop
8010109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010a0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010a3:	75 e7                	jne    8010108c <filewrite+0xcc>
}
801010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a8:	89 f8                	mov    %edi,%eax
801010aa:	5b                   	pop    %ebx
801010ab:	5e                   	pop    %esi
801010ac:	5f                   	pop    %edi
801010ad:	5d                   	pop    %ebp
801010ae:	c3                   	ret    
801010af:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010b0:	8b 46 0c             	mov    0xc(%esi),%eax
801010b3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b9:	5b                   	pop    %ebx
801010ba:	5e                   	pop    %esi
801010bb:	5f                   	pop    %edi
801010bc:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010bd:	e9 be 25 00 00       	jmp    80103680 <pipewrite>
        panic("short filewrite");
801010c2:	83 ec 0c             	sub    $0xc,%esp
801010c5:	68 e7 79 10 80       	push   $0x801079e7
801010ca:	e8 a1 f2 ff ff       	call   80100370 <panic>
  panic("filewrite");
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	68 ed 79 10 80       	push   $0x801079ed
801010d7:	e8 94 f2 ff ff       	call   80100370 <panic>
801010dc:	66 90                	xchg   %ax,%ax
801010de:	66 90                	xchg   %ax,%ax

801010e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010e9:	8b 0d a0 11 11 80    	mov    0x801111a0,%ecx
{
801010ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801010f2:	85 c9                	test   %ecx,%ecx
801010f4:	0f 84 87 00 00 00    	je     80101181 <balloc+0xa1>
801010fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101101:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101104:	83 ec 08             	sub    $0x8,%esp
80101107:	89 f0                	mov    %esi,%eax
80101109:	c1 f8 0c             	sar    $0xc,%eax
8010110c:	03 05 b8 11 11 80    	add    0x801111b8,%eax
80101112:	50                   	push   %eax
80101113:	ff 75 d8             	pushl  -0x28(%ebp)
80101116:	e8 a5 ef ff ff       	call   801000c0 <bread>
8010111b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010111e:	a1 a0 11 11 80       	mov    0x801111a0,%eax
80101123:	83 c4 10             	add    $0x10,%esp
80101126:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101129:	31 c0                	xor    %eax,%eax
8010112b:	eb 2f                	jmp    8010115c <balloc+0x7c>
8010112d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101130:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101132:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101135:	bb 01 00 00 00       	mov    $0x1,%ebx
8010113a:	83 e1 07             	and    $0x7,%ecx
8010113d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010113f:	89 c1                	mov    %eax,%ecx
80101141:	c1 f9 03             	sar    $0x3,%ecx
80101144:	0f b6 7c 0a 18       	movzbl 0x18(%edx,%ecx,1),%edi
80101149:	85 df                	test   %ebx,%edi
8010114b:	89 fa                	mov    %edi,%edx
8010114d:	74 41                	je     80101190 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114f:	83 c0 01             	add    $0x1,%eax
80101152:	83 c6 01             	add    $0x1,%esi
80101155:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010115a:	74 05                	je     80101161 <balloc+0x81>
8010115c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010115f:	77 cf                	ja     80101130 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101161:	83 ec 0c             	sub    $0xc,%esp
80101164:	ff 75 e4             	pushl  -0x1c(%ebp)
80101167:	e8 64 f0 ff ff       	call   801001d0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010116c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101173:	83 c4 10             	add    $0x10,%esp
80101176:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101179:	39 05 a0 11 11 80    	cmp    %eax,0x801111a0
8010117f:	77 80                	ja     80101101 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101181:	83 ec 0c             	sub    $0xc,%esp
80101184:	68 f7 79 10 80       	push   $0x801079f7
80101189:	e8 e2 f1 ff ff       	call   80100370 <panic>
8010118e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101190:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101193:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101196:	09 da                	or     %ebx,%edx
80101198:	88 54 0f 18          	mov    %dl,0x18(%edi,%ecx,1)
        log_write(bp);
8010119c:	57                   	push   %edi
8010119d:	e8 4e 1d 00 00       	call   80102ef0 <log_write>
        brelse(bp);
801011a2:	89 3c 24             	mov    %edi,(%esp)
801011a5:	e8 26 f0 ff ff       	call   801001d0 <brelse>
  bp = bread(dev, bno);
801011aa:	58                   	pop    %eax
801011ab:	5a                   	pop    %edx
801011ac:	56                   	push   %esi
801011ad:	ff 75 d8             	pushl  -0x28(%ebp)
801011b0:	e8 0b ef ff ff       	call   801000c0 <bread>
801011b5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011b7:	8d 40 18             	lea    0x18(%eax),%eax
801011ba:	83 c4 0c             	add    $0xc,%esp
801011bd:	68 00 02 00 00       	push   $0x200
801011c2:	6a 00                	push   $0x0
801011c4:	50                   	push   %eax
801011c5:	e8 16 38 00 00       	call   801049e0 <memset>
  log_write(bp);
801011ca:	89 1c 24             	mov    %ebx,(%esp)
801011cd:	e8 1e 1d 00 00       	call   80102ef0 <log_write>
  brelse(bp);
801011d2:	89 1c 24             	mov    %ebx,(%esp)
801011d5:	e8 f6 ef ff ff       	call   801001d0 <brelse>
}
801011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011dd:	89 f0                	mov    %esi,%eax
801011df:	5b                   	pop    %ebx
801011e0:	5e                   	pop    %esi
801011e1:	5f                   	pop    %edi
801011e2:	5d                   	pop    %ebp
801011e3:	c3                   	ret    
801011e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801011f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	57                   	push   %edi
801011f4:	56                   	push   %esi
801011f5:	53                   	push   %ebx
801011f6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801011f8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011fa:	bb f4 11 11 80       	mov    $0x801111f4,%ebx
{
801011ff:	83 ec 28             	sub    $0x28,%esp
80101202:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101205:	68 c0 11 11 80       	push   $0x801111c0
8010120a:	e8 31 33 00 00       	call   80104540 <acquire>
8010120f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101215:	eb 14                	jmp    8010122b <iget+0x3b>
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101220:	83 c3 50             	add    $0x50,%ebx
80101223:	81 fb 94 21 11 80    	cmp    $0x80112194,%ebx
80101229:	73 1f                	jae    8010124a <iget+0x5a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010122b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010122e:	85 c9                	test   %ecx,%ecx
80101230:	7e 04                	jle    80101236 <iget+0x46>
80101232:	39 3b                	cmp    %edi,(%ebx)
80101234:	74 4a                	je     80101280 <iget+0x90>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101236:	85 f6                	test   %esi,%esi
80101238:	75 e6                	jne    80101220 <iget+0x30>
8010123a:	85 c9                	test   %ecx,%ecx
8010123c:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123f:	83 c3 50             	add    $0x50,%ebx
80101242:	81 fb 94 21 11 80    	cmp    $0x80112194,%ebx
80101248:	72 e1                	jb     8010122b <iget+0x3b>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010124a:	85 f6                	test   %esi,%esi
8010124c:	74 59                	je     801012a7 <iget+0xb7>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
8010124e:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101251:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101253:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101256:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
8010125d:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  release(&icache.lock);
80101264:	68 c0 11 11 80       	push   $0x801111c0
80101269:	e8 92 34 00 00       	call   80104700 <release>

  return ip;
8010126e:	83 c4 10             	add    $0x10,%esp
}
80101271:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101274:	89 f0                	mov    %esi,%eax
80101276:	5b                   	pop    %ebx
80101277:	5e                   	pop    %esi
80101278:	5f                   	pop    %edi
80101279:	5d                   	pop    %ebp
8010127a:	c3                   	ret    
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101280:	39 53 04             	cmp    %edx,0x4(%ebx)
80101283:	75 b1                	jne    80101236 <iget+0x46>
      release(&icache.lock);
80101285:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101288:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010128b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010128d:	68 c0 11 11 80       	push   $0x801111c0
      ip->ref++;
80101292:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101295:	e8 66 34 00 00       	call   80104700 <release>
      return ip;
8010129a:	83 c4 10             	add    $0x10,%esp
}
8010129d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012a0:	89 f0                	mov    %esi,%eax
801012a2:	5b                   	pop    %ebx
801012a3:	5e                   	pop    %esi
801012a4:	5f                   	pop    %edi
801012a5:	5d                   	pop    %ebp
801012a6:	c3                   	ret    
    panic("iget: no inodes");
801012a7:	83 ec 0c             	sub    $0xc,%esp
801012aa:	68 0d 7a 10 80       	push   $0x80107a0d
801012af:	e8 bc f0 ff ff       	call   80100370 <panic>
801012b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c6                	mov    %eax,%esi
801012c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012cb:	83 fa 0b             	cmp    $0xb,%edx
801012ce:	77 18                	ja     801012e8 <bmap+0x28>
801012d0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801012d3:	8b 5f 1c             	mov    0x1c(%edi),%ebx
801012d6:	85 db                	test   %ebx,%ebx
801012d8:	74 6e                	je     80101348 <bmap+0x88>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dd:	89 d8                	mov    %ebx,%eax
801012df:	5b                   	pop    %ebx
801012e0:	5e                   	pop    %esi
801012e1:	5f                   	pop    %edi
801012e2:	5d                   	pop    %ebp
801012e3:	c3                   	ret    
801012e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801012e8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801012eb:	83 fb 7f             	cmp    $0x7f,%ebx
801012ee:	77 7e                	ja     8010136e <bmap+0xae>
    if((addr = ip->addrs[NDIRECT]) == 0)
801012f0:	8b 50 4c             	mov    0x4c(%eax),%edx
801012f3:	8b 00                	mov    (%eax),%eax
801012f5:	85 d2                	test   %edx,%edx
801012f7:	74 67                	je     80101360 <bmap+0xa0>
    bp = bread(ip->dev, addr);
801012f9:	83 ec 08             	sub    $0x8,%esp
801012fc:	52                   	push   %edx
801012fd:	50                   	push   %eax
801012fe:	e8 bd ed ff ff       	call   801000c0 <bread>
    if((addr = a[bn]) == 0){
80101303:	8d 54 98 18          	lea    0x18(%eax,%ebx,4),%edx
80101307:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
8010130a:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010130c:	8b 1a                	mov    (%edx),%ebx
8010130e:	85 db                	test   %ebx,%ebx
80101310:	75 1d                	jne    8010132f <bmap+0x6f>
      a[bn] = addr = balloc(ip->dev);
80101312:	8b 06                	mov    (%esi),%eax
80101314:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101317:	e8 c4 fd ff ff       	call   801010e0 <balloc>
8010131c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010131f:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101322:	89 c3                	mov    %eax,%ebx
80101324:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101326:	57                   	push   %edi
80101327:	e8 c4 1b 00 00       	call   80102ef0 <log_write>
8010132c:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010132f:	83 ec 0c             	sub    $0xc,%esp
80101332:	57                   	push   %edi
80101333:	e8 98 ee ff ff       	call   801001d0 <brelse>
80101338:	83 c4 10             	add    $0x10,%esp
}
8010133b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133e:	89 d8                	mov    %ebx,%eax
80101340:	5b                   	pop    %ebx
80101341:	5e                   	pop    %esi
80101342:	5f                   	pop    %edi
80101343:	5d                   	pop    %ebp
80101344:	c3                   	ret    
80101345:	8d 76 00             	lea    0x0(%esi),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101348:	8b 00                	mov    (%eax),%eax
8010134a:	e8 91 fd ff ff       	call   801010e0 <balloc>
8010134f:	89 47 1c             	mov    %eax,0x1c(%edi)
}
80101352:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
80101355:	89 c3                	mov    %eax,%ebx
}
80101357:	89 d8                	mov    %ebx,%eax
80101359:	5b                   	pop    %ebx
8010135a:	5e                   	pop    %esi
8010135b:	5f                   	pop    %edi
8010135c:	5d                   	pop    %ebp
8010135d:	c3                   	ret    
8010135e:	66 90                	xchg   %ax,%ax
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101360:	e8 7b fd ff ff       	call   801010e0 <balloc>
80101365:	89 c2                	mov    %eax,%edx
80101367:	89 46 4c             	mov    %eax,0x4c(%esi)
8010136a:	8b 06                	mov    (%esi),%eax
8010136c:	eb 8b                	jmp    801012f9 <bmap+0x39>
  panic("bmap: out of range");
8010136e:	83 ec 0c             	sub    $0xc,%esp
80101371:	68 1d 7a 10 80       	push   $0x80107a1d
80101376:	e8 f5 ef ff ff       	call   80100370 <panic>
8010137b:	90                   	nop
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101380 <readsb>:
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	56                   	push   %esi
80101384:	53                   	push   %ebx
80101385:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101388:	83 ec 08             	sub    $0x8,%esp
8010138b:	6a 01                	push   $0x1
8010138d:	ff 75 08             	pushl  0x8(%ebp)
80101390:	e8 2b ed ff ff       	call   801000c0 <bread>
80101395:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101397:	8d 40 18             	lea    0x18(%eax),%eax
8010139a:	83 c4 0c             	add    $0xc,%esp
8010139d:	6a 1c                	push   $0x1c
8010139f:	50                   	push   %eax
801013a0:	56                   	push   %esi
801013a1:	e8 ea 36 00 00       	call   80104a90 <memmove>
  brelse(bp);
801013a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013a9:	83 c4 10             	add    $0x10,%esp
}
801013ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013af:	5b                   	pop    %ebx
801013b0:	5e                   	pop    %esi
801013b1:	5d                   	pop    %ebp
  brelse(bp);
801013b2:	e9 19 ee ff ff       	jmp    801001d0 <brelse>
801013b7:	89 f6                	mov    %esi,%esi
801013b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013c0 <bfree>:
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	56                   	push   %esi
801013c4:	53                   	push   %ebx
801013c5:	89 d3                	mov    %edx,%ebx
801013c7:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
801013c9:	83 ec 08             	sub    $0x8,%esp
801013cc:	68 a0 11 11 80       	push   $0x801111a0
801013d1:	50                   	push   %eax
801013d2:	e8 a9 ff ff ff       	call   80101380 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013d7:	58                   	pop    %eax
801013d8:	5a                   	pop    %edx
801013d9:	89 da                	mov    %ebx,%edx
801013db:	c1 ea 0c             	shr    $0xc,%edx
801013de:	03 15 b8 11 11 80    	add    0x801111b8,%edx
801013e4:	52                   	push   %edx
801013e5:	56                   	push   %esi
801013e6:	e8 d5 ec ff ff       	call   801000c0 <bread>
  m = 1 << (bi % 8);
801013eb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801013ed:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801013f0:	ba 01 00 00 00       	mov    $0x1,%edx
801013f5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801013f8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801013fe:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101401:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101403:	0f b6 4c 18 18       	movzbl 0x18(%eax,%ebx,1),%ecx
80101408:	85 d1                	test   %edx,%ecx
8010140a:	74 25                	je     80101431 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010140c:	f7 d2                	not    %edx
8010140e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101410:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101413:	21 ca                	and    %ecx,%edx
80101415:	88 54 1e 18          	mov    %dl,0x18(%esi,%ebx,1)
  log_write(bp);
80101419:	56                   	push   %esi
8010141a:	e8 d1 1a 00 00       	call   80102ef0 <log_write>
  brelse(bp);
8010141f:	89 34 24             	mov    %esi,(%esp)
80101422:	e8 a9 ed ff ff       	call   801001d0 <brelse>
}
80101427:	83 c4 10             	add    $0x10,%esp
8010142a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010142d:	5b                   	pop    %ebx
8010142e:	5e                   	pop    %esi
8010142f:	5d                   	pop    %ebp
80101430:	c3                   	ret    
    panic("freeing free block");
80101431:	83 ec 0c             	sub    $0xc,%esp
80101434:	68 30 7a 10 80       	push   $0x80107a30
80101439:	e8 32 ef ff ff       	call   80100370 <panic>
8010143e:	66 90                	xchg   %ax,%ax

80101440 <iinit>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	83 ec 10             	sub    $0x10,%esp
  initlock(&icache.lock, "icache");
80101446:	68 43 7a 10 80       	push   $0x80107a43
8010144b:	68 c0 11 11 80       	push   $0x801111c0
80101450:	e8 cb 30 00 00       	call   80104520 <initlock>
  readsb(dev, &sb);
80101455:	58                   	pop    %eax
80101456:	5a                   	pop    %edx
80101457:	68 a0 11 11 80       	push   $0x801111a0
8010145c:	ff 75 08             	pushl  0x8(%ebp)
8010145f:	e8 1c ff ff ff       	call   80101380 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101464:	ff 35 b8 11 11 80    	pushl  0x801111b8
8010146a:	ff 35 b4 11 11 80    	pushl  0x801111b4
80101470:	ff 35 b0 11 11 80    	pushl  0x801111b0
80101476:	ff 35 ac 11 11 80    	pushl  0x801111ac
8010147c:	ff 35 a8 11 11 80    	pushl  0x801111a8
80101482:	ff 35 a4 11 11 80    	pushl  0x801111a4
80101488:	ff 35 a0 11 11 80    	pushl  0x801111a0
8010148e:	68 a4 7a 10 80       	push   $0x80107aa4
80101493:	e8 a8 f1 ff ff       	call   80100640 <cprintf>
}
80101498:	83 c4 30             	add    $0x30,%esp
8010149b:	c9                   	leave  
8010149c:	c3                   	ret    
8010149d:	8d 76 00             	lea    0x0(%esi),%esi

801014a0 <ialloc>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	53                   	push   %ebx
801014a6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801014a9:	83 3d a8 11 11 80 01 	cmpl   $0x1,0x801111a8
{
801014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801014b3:	8b 75 08             	mov    0x8(%ebp),%esi
801014b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801014b9:	0f 86 91 00 00 00    	jbe    80101550 <ialloc+0xb0>
801014bf:	bb 01 00 00 00       	mov    $0x1,%ebx
801014c4:	eb 21                	jmp    801014e7 <ialloc+0x47>
801014c6:	8d 76 00             	lea    0x0(%esi),%esi
801014c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801014d0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801014d3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801014d6:	57                   	push   %edi
801014d7:	e8 f4 ec ff ff       	call   801001d0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801014dc:	83 c4 10             	add    $0x10,%esp
801014df:	39 1d a8 11 11 80    	cmp    %ebx,0x801111a8
801014e5:	76 69                	jbe    80101550 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801014e7:	89 d8                	mov    %ebx,%eax
801014e9:	83 ec 08             	sub    $0x8,%esp
801014ec:	c1 e8 03             	shr    $0x3,%eax
801014ef:	03 05 b4 11 11 80    	add    0x801111b4,%eax
801014f5:	50                   	push   %eax
801014f6:	56                   	push   %esi
801014f7:	e8 c4 eb ff ff       	call   801000c0 <bread>
801014fc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801014fe:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101500:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101503:	83 e0 07             	and    $0x7,%eax
80101506:	c1 e0 06             	shl    $0x6,%eax
80101509:	8d 4c 07 18          	lea    0x18(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010150d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101511:	75 bd                	jne    801014d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101513:	83 ec 04             	sub    $0x4,%esp
80101516:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101519:	6a 40                	push   $0x40
8010151b:	6a 00                	push   $0x0
8010151d:	51                   	push   %ecx
8010151e:	e8 bd 34 00 00       	call   801049e0 <memset>
      dip->type = type;
80101523:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101527:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010152a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010152d:	89 3c 24             	mov    %edi,(%esp)
80101530:	e8 bb 19 00 00       	call   80102ef0 <log_write>
      brelse(bp);
80101535:	89 3c 24             	mov    %edi,(%esp)
80101538:	e8 93 ec ff ff       	call   801001d0 <brelse>
      return iget(dev, inum);
8010153d:	83 c4 10             	add    $0x10,%esp
}
80101540:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101543:	89 da                	mov    %ebx,%edx
80101545:	89 f0                	mov    %esi,%eax
}
80101547:	5b                   	pop    %ebx
80101548:	5e                   	pop    %esi
80101549:	5f                   	pop    %edi
8010154a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010154b:	e9 a0 fc ff ff       	jmp    801011f0 <iget>
  panic("ialloc: no inodes");
80101550:	83 ec 0c             	sub    $0xc,%esp
80101553:	68 4a 7a 10 80       	push   $0x80107a4a
80101558:	e8 13 ee ff ff       	call   80100370 <panic>
8010155d:	8d 76 00             	lea    0x0(%esi),%esi

80101560 <iupdate>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	56                   	push   %esi
80101564:	53                   	push   %ebx
80101565:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010156e:	83 c3 1c             	add    $0x1c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101571:	c1 e8 03             	shr    $0x3,%eax
80101574:	03 05 b4 11 11 80    	add    0x801111b4,%eax
8010157a:	50                   	push   %eax
8010157b:	ff 73 e4             	pushl  -0x1c(%ebx)
8010157e:	e8 3d eb ff ff       	call   801000c0 <bread>
80101583:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101585:	8b 43 e8             	mov    -0x18(%ebx),%eax
  dip->type = ip->type;
80101588:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010158c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010158f:	83 e0 07             	and    $0x7,%eax
80101592:	c1 e0 06             	shl    $0x6,%eax
80101595:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
80101599:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010159c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015a0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801015a3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015a7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015ab:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015af:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801015b3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801015b7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801015ba:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015bd:	6a 34                	push   $0x34
801015bf:	53                   	push   %ebx
801015c0:	50                   	push   %eax
801015c1:	e8 ca 34 00 00       	call   80104a90 <memmove>
  log_write(bp);
801015c6:	89 34 24             	mov    %esi,(%esp)
801015c9:	e8 22 19 00 00       	call   80102ef0 <log_write>
  brelse(bp);
801015ce:	89 75 08             	mov    %esi,0x8(%ebp)
801015d1:	83 c4 10             	add    $0x10,%esp
}
801015d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015d7:	5b                   	pop    %ebx
801015d8:	5e                   	pop    %esi
801015d9:	5d                   	pop    %ebp
  brelse(bp);
801015da:	e9 f1 eb ff ff       	jmp    801001d0 <brelse>
801015df:	90                   	nop

801015e0 <idup>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	53                   	push   %ebx
801015e4:	83 ec 10             	sub    $0x10,%esp
801015e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801015ea:	68 c0 11 11 80       	push   $0x801111c0
801015ef:	e8 4c 2f 00 00       	call   80104540 <acquire>
  ip->ref++;
801015f4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801015f8:	c7 04 24 c0 11 11 80 	movl   $0x801111c0,(%esp)
801015ff:	e8 fc 30 00 00       	call   80104700 <release>
}
80101604:	89 d8                	mov    %ebx,%eax
80101606:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101609:	c9                   	leave  
8010160a:	c3                   	ret    
8010160b:	90                   	nop
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ilock>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101618:	85 db                	test   %ebx,%ebx
8010161a:	0f 84 e8 00 00 00    	je     80101708 <ilock+0xf8>
80101620:	8b 43 08             	mov    0x8(%ebx),%eax
80101623:	85 c0                	test   %eax,%eax
80101625:	0f 8e dd 00 00 00    	jle    80101708 <ilock+0xf8>
  acquire(&icache.lock);
8010162b:	83 ec 0c             	sub    $0xc,%esp
8010162e:	68 c0 11 11 80       	push   $0x801111c0
80101633:	e8 08 2f 00 00       	call   80104540 <acquire>
  while(ip->flags & I_BUSY)
80101638:	8b 43 0c             	mov    0xc(%ebx),%eax
8010163b:	83 c4 10             	add    $0x10,%esp
8010163e:	a8 01                	test   $0x1,%al
80101640:	74 1e                	je     80101660 <ilock+0x50>
80101642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sleep(ip, &icache.lock);
80101648:	83 ec 08             	sub    $0x8,%esp
8010164b:	68 c0 11 11 80       	push   $0x801111c0
80101650:	53                   	push   %ebx
80101651:	e8 5a 29 00 00       	call   80103fb0 <sleep>
  while(ip->flags & I_BUSY)
80101656:	8b 43 0c             	mov    0xc(%ebx),%eax
80101659:	83 c4 10             	add    $0x10,%esp
8010165c:	a8 01                	test   $0x1,%al
8010165e:	75 e8                	jne    80101648 <ilock+0x38>
  release(&icache.lock);
80101660:	83 ec 0c             	sub    $0xc,%esp
  ip->flags |= I_BUSY;
80101663:	83 c8 01             	or     $0x1,%eax
80101666:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
80101669:	68 c0 11 11 80       	push   $0x801111c0
8010166e:	e8 8d 30 00 00       	call   80104700 <release>
  if(!(ip->flags & I_VALID)){
80101673:	83 c4 10             	add    $0x10,%esp
80101676:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
8010167a:	74 0c                	je     80101688 <ilock+0x78>
}
8010167c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010167f:	5b                   	pop    %ebx
80101680:	5e                   	pop    %esi
80101681:	5d                   	pop    %ebp
80101682:	c3                   	ret    
80101683:	90                   	nop
80101684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101688:	8b 43 04             	mov    0x4(%ebx),%eax
8010168b:	83 ec 08             	sub    $0x8,%esp
8010168e:	c1 e8 03             	shr    $0x3,%eax
80101691:	03 05 b4 11 11 80    	add    0x801111b4,%eax
80101697:	50                   	push   %eax
80101698:	ff 33                	pushl  (%ebx)
8010169a:	e8 21 ea ff ff       	call   801000c0 <bread>
8010169f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016a1:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016a4:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016a7:	83 e0 07             	and    $0x7,%eax
801016aa:	c1 e0 06             	shl    $0x6,%eax
801016ad:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
801016b1:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016b4:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016b7:	66 89 53 10          	mov    %dx,0x10(%ebx)
    ip->major = dip->major;
801016bb:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016bf:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
801016c3:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016c7:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
801016cb:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016cf:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
801016d3:	8b 50 fc             	mov    -0x4(%eax),%edx
801016d6:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016d9:	6a 34                	push   $0x34
801016db:	50                   	push   %eax
801016dc:	8d 43 1c             	lea    0x1c(%ebx),%eax
801016df:	50                   	push   %eax
801016e0:	e8 ab 33 00 00       	call   80104a90 <memmove>
    brelse(bp);
801016e5:	89 34 24             	mov    %esi,(%esp)
801016e8:	e8 e3 ea ff ff       	call   801001d0 <brelse>
    ip->flags |= I_VALID;
801016ed:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
801016f1:	83 c4 10             	add    $0x10,%esp
801016f4:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
801016f9:	75 81                	jne    8010167c <ilock+0x6c>
      panic("ilock: no type");
801016fb:	83 ec 0c             	sub    $0xc,%esp
801016fe:	68 62 7a 10 80       	push   $0x80107a62
80101703:	e8 68 ec ff ff       	call   80100370 <panic>
    panic("ilock");
80101708:	83 ec 0c             	sub    $0xc,%esp
8010170b:	68 5c 7a 10 80       	push   $0x80107a5c
80101710:	e8 5b ec ff ff       	call   80100370 <panic>
80101715:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101720 <iunlock>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	53                   	push   %ebx
80101724:	83 ec 04             	sub    $0x4,%esp
80101727:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
8010172a:	85 db                	test   %ebx,%ebx
8010172c:	74 39                	je     80101767 <iunlock+0x47>
8010172e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
80101732:	74 33                	je     80101767 <iunlock+0x47>
80101734:	8b 43 08             	mov    0x8(%ebx),%eax
80101737:	85 c0                	test   %eax,%eax
80101739:	7e 2c                	jle    80101767 <iunlock+0x47>
  acquire(&icache.lock);
8010173b:	83 ec 0c             	sub    $0xc,%esp
8010173e:	68 c0 11 11 80       	push   $0x801111c0
80101743:	e8 f8 2d 00 00       	call   80104540 <acquire>
  ip->flags &= ~I_BUSY;
80101748:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
8010174c:	89 1c 24             	mov    %ebx,(%esp)
8010174f:	e8 0c 2a 00 00       	call   80104160 <wakeup>
  release(&icache.lock);
80101754:	83 c4 10             	add    $0x10,%esp
80101757:	c7 45 08 c0 11 11 80 	movl   $0x801111c0,0x8(%ebp)
}
8010175e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101761:	c9                   	leave  
  release(&icache.lock);
80101762:	e9 99 2f 00 00       	jmp    80104700 <release>
    panic("iunlock");
80101767:	83 ec 0c             	sub    $0xc,%esp
8010176a:	68 71 7a 10 80       	push   $0x80107a71
8010176f:	e8 fc eb ff ff       	call   80100370 <panic>
80101774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010177a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101780 <iput>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	57                   	push   %edi
80101784:	56                   	push   %esi
80101785:	53                   	push   %ebx
80101786:	83 ec 28             	sub    $0x28,%esp
80101789:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010178c:	68 c0 11 11 80       	push   $0x801111c0
80101791:	e8 aa 2d 00 00       	call   80104540 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101796:	8b 46 08             	mov    0x8(%esi),%eax
80101799:	83 c4 10             	add    $0x10,%esp
8010179c:	83 f8 01             	cmp    $0x1,%eax
8010179f:	0f 85 ab 00 00 00    	jne    80101850 <iput+0xd0>
801017a5:	8b 56 0c             	mov    0xc(%esi),%edx
801017a8:	f6 c2 02             	test   $0x2,%dl
801017ab:	0f 84 9f 00 00 00    	je     80101850 <iput+0xd0>
801017b1:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
801017b6:	0f 85 94 00 00 00    	jne    80101850 <iput+0xd0>
    if(ip->flags & I_BUSY)
801017bc:	f6 c2 01             	test   $0x1,%dl
801017bf:	0f 85 05 01 00 00    	jne    801018ca <iput+0x14a>
    release(&icache.lock);
801017c5:	83 ec 0c             	sub    $0xc,%esp
    ip->flags |= I_BUSY;
801017c8:	83 ca 01             	or     $0x1,%edx
801017cb:	8d 5e 1c             	lea    0x1c(%esi),%ebx
801017ce:	89 56 0c             	mov    %edx,0xc(%esi)
    release(&icache.lock);
801017d1:	68 c0 11 11 80       	push   $0x801111c0
801017d6:	8d 7e 4c             	lea    0x4c(%esi),%edi
801017d9:	e8 22 2f 00 00       	call   80104700 <release>
801017de:	83 c4 10             	add    $0x10,%esp
801017e1:	eb 0c                	jmp    801017ef <iput+0x6f>
801017e3:	90                   	nop
801017e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017e8:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801017eb:	39 fb                	cmp    %edi,%ebx
801017ed:	74 1b                	je     8010180a <iput+0x8a>
    if(ip->addrs[i]){
801017ef:	8b 13                	mov    (%ebx),%edx
801017f1:	85 d2                	test   %edx,%edx
801017f3:	74 f3                	je     801017e8 <iput+0x68>
      bfree(ip->dev, ip->addrs[i]);
801017f5:	8b 06                	mov    (%esi),%eax
801017f7:	83 c3 04             	add    $0x4,%ebx
801017fa:	e8 c1 fb ff ff       	call   801013c0 <bfree>
      ip->addrs[i] = 0;
801017ff:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
  for(i = 0; i < NDIRECT; i++){
80101806:	39 fb                	cmp    %edi,%ebx
80101808:	75 e5                	jne    801017ef <iput+0x6f>
    }
  }

  if(ip->addrs[NDIRECT]){
8010180a:	8b 46 4c             	mov    0x4c(%esi),%eax
8010180d:	85 c0                	test   %eax,%eax
8010180f:	75 5f                	jne    80101870 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101811:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101814:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
8010181b:	56                   	push   %esi
8010181c:	e8 3f fd ff ff       	call   80101560 <iupdate>
    ip->type = 0;
80101821:	31 c0                	xor    %eax,%eax
80101823:	66 89 46 10          	mov    %ax,0x10(%esi)
    iupdate(ip);
80101827:	89 34 24             	mov    %esi,(%esp)
8010182a:	e8 31 fd ff ff       	call   80101560 <iupdate>
    acquire(&icache.lock);
8010182f:	c7 04 24 c0 11 11 80 	movl   $0x801111c0,(%esp)
80101836:	e8 05 2d 00 00       	call   80104540 <acquire>
    ip->flags = 0;
8010183b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    wakeup(ip);
80101842:	89 34 24             	mov    %esi,(%esp)
80101845:	e8 16 29 00 00       	call   80104160 <wakeup>
8010184a:	8b 46 08             	mov    0x8(%esi),%eax
8010184d:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101850:	83 e8 01             	sub    $0x1,%eax
80101853:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
80101856:	c7 45 08 c0 11 11 80 	movl   $0x801111c0,0x8(%ebp)
}
8010185d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101860:	5b                   	pop    %ebx
80101861:	5e                   	pop    %esi
80101862:	5f                   	pop    %edi
80101863:	5d                   	pop    %ebp
  release(&icache.lock);
80101864:	e9 97 2e 00 00       	jmp    80104700 <release>
80101869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101870:	83 ec 08             	sub    $0x8,%esp
80101873:	50                   	push   %eax
80101874:	ff 36                	pushl  (%esi)
80101876:	e8 45 e8 ff ff       	call   801000c0 <bread>
8010187b:	83 c4 10             	add    $0x10,%esp
8010187e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101881:	8d 58 18             	lea    0x18(%eax),%ebx
80101884:	8d b8 18 02 00 00    	lea    0x218(%eax),%edi
8010188a:	eb 0b                	jmp    80101897 <iput+0x117>
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101890:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101893:	39 df                	cmp    %ebx,%edi
80101895:	74 0f                	je     801018a6 <iput+0x126>
      if(a[j])
80101897:	8b 13                	mov    (%ebx),%edx
80101899:	85 d2                	test   %edx,%edx
8010189b:	74 f3                	je     80101890 <iput+0x110>
        bfree(ip->dev, a[j]);
8010189d:	8b 06                	mov    (%esi),%eax
8010189f:	e8 1c fb ff ff       	call   801013c0 <bfree>
801018a4:	eb ea                	jmp    80101890 <iput+0x110>
    brelse(bp);
801018a6:	83 ec 0c             	sub    $0xc,%esp
801018a9:	ff 75 e4             	pushl  -0x1c(%ebp)
801018ac:	e8 1f e9 ff ff       	call   801001d0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018b1:	8b 56 4c             	mov    0x4c(%esi),%edx
801018b4:	8b 06                	mov    (%esi),%eax
801018b6:	e8 05 fb ff ff       	call   801013c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018c2:	83 c4 10             	add    $0x10,%esp
801018c5:	e9 47 ff ff ff       	jmp    80101811 <iput+0x91>
      panic("iput busy");
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	68 79 7a 10 80       	push   $0x80107a79
801018d2:	e8 99 ea ff ff       	call   80100370 <panic>
801018d7:	89 f6                	mov    %esi,%esi
801018d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801018e0 <iunlockput>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	53                   	push   %ebx
801018e4:	83 ec 10             	sub    $0x10,%esp
801018e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018ea:	53                   	push   %ebx
801018eb:	e8 30 fe ff ff       	call   80101720 <iunlock>
  iput(ip);
801018f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018f3:	83 c4 10             	add    $0x10,%esp
}
801018f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018f9:	c9                   	leave  
  iput(ip);
801018fa:	e9 81 fe ff ff       	jmp    80101780 <iput>
801018ff:	90                   	nop

80101900 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	8b 55 08             	mov    0x8(%ebp),%edx
80101906:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101909:	8b 0a                	mov    (%edx),%ecx
8010190b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010190e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101911:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101914:	0f b7 4a 10          	movzwl 0x10(%edx),%ecx
80101918:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010191b:	0f b7 4a 16          	movzwl 0x16(%edx),%ecx
8010191f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101923:	8b 52 18             	mov    0x18(%edx),%edx
80101926:	89 50 10             	mov    %edx,0x10(%eax)
}
80101929:	5d                   	pop    %ebp
8010192a:	c3                   	ret    
8010192b:	90                   	nop
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101930 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	57                   	push   %edi
80101934:	56                   	push   %esi
80101935:	53                   	push   %ebx
80101936:	83 ec 1c             	sub    $0x1c,%esp
80101939:	8b 45 08             	mov    0x8(%ebp),%eax
8010193c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010193f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101942:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)
{
80101947:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010194a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010194d:	8b 75 10             	mov    0x10(%ebp),%esi
80101950:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101953:	0f 84 a7 00 00 00    	je     80101a00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101959:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010195c:	8b 40 18             	mov    0x18(%eax),%eax
8010195f:	39 c6                	cmp    %eax,%esi
80101961:	0f 87 ba 00 00 00    	ja     80101a21 <readi+0xf1>
80101967:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010196a:	89 f9                	mov    %edi,%ecx
8010196c:	01 f1                	add    %esi,%ecx
8010196e:	0f 82 ad 00 00 00    	jb     80101a21 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101974:	89 c2                	mov    %eax,%edx
80101976:	29 f2                	sub    %esi,%edx
80101978:	39 c8                	cmp    %ecx,%eax
8010197a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010197d:	31 ff                	xor    %edi,%edi
8010197f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101981:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101984:	74 6c                	je     801019f2 <readi+0xc2>
80101986:	8d 76 00             	lea    0x0(%esi),%esi
80101989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101990:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101993:	89 f2                	mov    %esi,%edx
80101995:	c1 ea 09             	shr    $0x9,%edx
80101998:	89 d8                	mov    %ebx,%eax
8010199a:	e8 21 f9 ff ff       	call   801012c0 <bmap>
8010199f:	83 ec 08             	sub    $0x8,%esp
801019a2:	50                   	push   %eax
801019a3:	ff 33                	pushl  (%ebx)
801019a5:	e8 16 e7 ff ff       	call   801000c0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019aa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ad:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019af:	89 f0                	mov    %esi,%eax
801019b1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019b6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019bb:	83 c4 0c             	add    $0xc,%esp
801019be:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019c0:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
801019c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019c7:	29 fb                	sub    %edi,%ebx
801019c9:	39 d9                	cmp    %ebx,%ecx
801019cb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ce:	53                   	push   %ebx
801019cf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
801019d2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
801019d7:	e8 b4 30 00 00       	call   80104a90 <memmove>
    brelse(bp);
801019dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019df:	89 14 24             	mov    %edx,(%esp)
801019e2:	e8 e9 e7 ff ff       	call   801001d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019ea:	83 c4 10             	add    $0x10,%esp
801019ed:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019f0:	77 9e                	ja     80101990 <readi+0x60>
  }
  return n;
801019f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019f8:	5b                   	pop    %ebx
801019f9:	5e                   	pop    %esi
801019fa:	5f                   	pop    %edi
801019fb:	5d                   	pop    %ebp
801019fc:	c3                   	ret    
801019fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a00:	0f bf 40 12          	movswl 0x12(%eax),%eax
80101a04:	66 83 f8 09          	cmp    $0x9,%ax
80101a08:	77 17                	ja     80101a21 <readi+0xf1>
80101a0a:	8b 04 c5 40 11 11 80 	mov    -0x7feeeec0(,%eax,8),%eax
80101a11:	85 c0                	test   %eax,%eax
80101a13:	74 0c                	je     80101a21 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a1b:	5b                   	pop    %ebx
80101a1c:	5e                   	pop    %esi
80101a1d:	5f                   	pop    %edi
80101a1e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a1f:	ff e0                	jmp    *%eax
      return -1;
80101a21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a26:	eb cd                	jmp    801019f5 <readi+0xc5>
80101a28:	90                   	nop
80101a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a30 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	57                   	push   %edi
80101a34:	56                   	push   %esi
80101a35:	53                   	push   %ebx
80101a36:	83 ec 1c             	sub    $0x1c,%esp
80101a39:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a42:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)
{
80101a47:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a50:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a53:	0f 84 b7 00 00 00    	je     80101b10 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a5c:	39 70 18             	cmp    %esi,0x18(%eax)
80101a5f:	0f 82 eb 00 00 00    	jb     80101b50 <writei+0x120>
80101a65:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a68:	31 d2                	xor    %edx,%edx
80101a6a:	89 f8                	mov    %edi,%eax
80101a6c:	01 f0                	add    %esi,%eax
80101a6e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a71:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a76:	0f 87 d4 00 00 00    	ja     80101b50 <writei+0x120>
80101a7c:	85 d2                	test   %edx,%edx
80101a7e:	0f 85 cc 00 00 00    	jne    80101b50 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a84:	85 ff                	test   %edi,%edi
80101a86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a8d:	74 72                	je     80101b01 <writei+0xd1>
80101a8f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a90:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a93:	89 f2                	mov    %esi,%edx
80101a95:	c1 ea 09             	shr    $0x9,%edx
80101a98:	89 f8                	mov    %edi,%eax
80101a9a:	e8 21 f8 ff ff       	call   801012c0 <bmap>
80101a9f:	83 ec 08             	sub    $0x8,%esp
80101aa2:	50                   	push   %eax
80101aa3:	ff 37                	pushl  (%edi)
80101aa5:	e8 16 e6 ff ff       	call   801000c0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aaa:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aad:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab2:	89 f0                	mov    %esi,%eax
80101ab4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ab9:	83 c4 0c             	add    $0xc,%esp
80101abc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ac1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ac3:	8d 44 07 18          	lea    0x18(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac7:	39 d9                	cmp    %ebx,%ecx
80101ac9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101acc:	53                   	push   %ebx
80101acd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101ad2:	50                   	push   %eax
80101ad3:	e8 b8 2f 00 00       	call   80104a90 <memmove>
    log_write(bp);
80101ad8:	89 3c 24             	mov    %edi,(%esp)
80101adb:	e8 10 14 00 00       	call   80102ef0 <log_write>
    brelse(bp);
80101ae0:	89 3c 24             	mov    %edi,(%esp)
80101ae3:	e8 e8 e6 ff ff       	call   801001d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101aeb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101aee:	83 c4 10             	add    $0x10,%esp
80101af1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101af4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101af7:	77 97                	ja     80101a90 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101af9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101afc:	3b 70 18             	cmp    0x18(%eax),%esi
80101aff:	77 37                	ja     80101b38 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b01:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b07:	5b                   	pop    %ebx
80101b08:	5e                   	pop    %esi
80101b09:	5f                   	pop    %edi
80101b0a:	5d                   	pop    %ebp
80101b0b:	c3                   	ret    
80101b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b10:	0f bf 40 12          	movswl 0x12(%eax),%eax
80101b14:	66 83 f8 09          	cmp    $0x9,%ax
80101b18:	77 36                	ja     80101b50 <writei+0x120>
80101b1a:	8b 04 c5 44 11 11 80 	mov    -0x7feeeebc(,%eax,8),%eax
80101b21:	85 c0                	test   %eax,%eax
80101b23:	74 2b                	je     80101b50 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b25:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b2b:	5b                   	pop    %ebx
80101b2c:	5e                   	pop    %esi
80101b2d:	5f                   	pop    %edi
80101b2e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b2f:	ff e0                	jmp    *%eax
80101b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b38:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b3b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b3e:	89 70 18             	mov    %esi,0x18(%eax)
    iupdate(ip);
80101b41:	50                   	push   %eax
80101b42:	e8 19 fa ff ff       	call   80101560 <iupdate>
80101b47:	83 c4 10             	add    $0x10,%esp
80101b4a:	eb b5                	jmp    80101b01 <writei+0xd1>
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b55:	eb ad                	jmp    80101b04 <writei+0xd4>
80101b57:	89 f6                	mov    %esi,%esi
80101b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b60 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b66:	6a 0e                	push   $0xe
80101b68:	ff 75 0c             	pushl  0xc(%ebp)
80101b6b:	ff 75 08             	pushl  0x8(%ebp)
80101b6e:	e8 8d 2f 00 00       	call   80104b00 <strncmp>
}
80101b73:	c9                   	leave  
80101b74:	c3                   	ret    
80101b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	57                   	push   %edi
80101b84:	56                   	push   %esi
80101b85:	53                   	push   %ebx
80101b86:	83 ec 1c             	sub    $0x1c,%esp
80101b89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b8c:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80101b91:	0f 85 85 00 00 00    	jne    80101c1c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b97:	8b 53 18             	mov    0x18(%ebx),%edx
80101b9a:	31 ff                	xor    %edi,%edi
80101b9c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b9f:	85 d2                	test   %edx,%edx
80101ba1:	74 3e                	je     80101be1 <dirlookup+0x61>
80101ba3:	90                   	nop
80101ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ba8:	6a 10                	push   $0x10
80101baa:	57                   	push   %edi
80101bab:	56                   	push   %esi
80101bac:	53                   	push   %ebx
80101bad:	e8 7e fd ff ff       	call   80101930 <readi>
80101bb2:	83 c4 10             	add    $0x10,%esp
80101bb5:	83 f8 10             	cmp    $0x10,%eax
80101bb8:	75 55                	jne    80101c0f <dirlookup+0x8f>
      panic("dirlink read");
    if(de.inum == 0)
80101bba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bbf:	74 18                	je     80101bd9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bc1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bc4:	83 ec 04             	sub    $0x4,%esp
80101bc7:	6a 0e                	push   $0xe
80101bc9:	50                   	push   %eax
80101bca:	ff 75 0c             	pushl  0xc(%ebp)
80101bcd:	e8 2e 2f 00 00       	call   80104b00 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101bd2:	83 c4 10             	add    $0x10,%esp
80101bd5:	85 c0                	test   %eax,%eax
80101bd7:	74 17                	je     80101bf0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd9:	83 c7 10             	add    $0x10,%edi
80101bdc:	3b 7b 18             	cmp    0x18(%ebx),%edi
80101bdf:	72 c7                	jb     80101ba8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101be1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101be4:	31 c0                	xor    %eax,%eax
}
80101be6:	5b                   	pop    %ebx
80101be7:	5e                   	pop    %esi
80101be8:	5f                   	pop    %edi
80101be9:	5d                   	pop    %ebp
80101bea:	c3                   	ret    
80101beb:	90                   	nop
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101bf0:	8b 45 10             	mov    0x10(%ebp),%eax
80101bf3:	85 c0                	test   %eax,%eax
80101bf5:	74 05                	je     80101bfc <dirlookup+0x7c>
        *poff = off;
80101bf7:	8b 45 10             	mov    0x10(%ebp),%eax
80101bfa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101bfc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c00:	8b 03                	mov    (%ebx),%eax
80101c02:	e8 e9 f5 ff ff       	call   801011f0 <iget>
}
80101c07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0a:	5b                   	pop    %ebx
80101c0b:	5e                   	pop    %esi
80101c0c:	5f                   	pop    %edi
80101c0d:	5d                   	pop    %ebp
80101c0e:	c3                   	ret    
      panic("dirlink read");
80101c0f:	83 ec 0c             	sub    $0xc,%esp
80101c12:	68 95 7a 10 80       	push   $0x80107a95
80101c17:	e8 54 e7 ff ff       	call   80100370 <panic>
    panic("dirlookup not DIR");
80101c1c:	83 ec 0c             	sub    $0xc,%esp
80101c1f:	68 83 7a 10 80       	push   $0x80107a83
80101c24:	e8 47 e7 ff ff       	call   80100370 <panic>
80101c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c30 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	57                   	push   %edi
80101c34:	56                   	push   %esi
80101c35:	53                   	push   %ebx
80101c36:	89 cf                	mov    %ecx,%edi
80101c38:	89 c3                	mov    %eax,%ebx
80101c3a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c3d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c40:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c43:	0f 84 67 01 00 00    	je     80101db0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  acquire(&icache.lock);
80101c4f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(proc->cwd);
80101c52:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c55:	68 c0 11 11 80       	push   $0x801111c0
80101c5a:	e8 e1 28 00 00       	call   80104540 <acquire>
  ip->ref++;
80101c5f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c63:	c7 04 24 c0 11 11 80 	movl   $0x801111c0,(%esp)
80101c6a:	e8 91 2a 00 00       	call   80104700 <release>
80101c6f:	83 c4 10             	add    $0x10,%esp
80101c72:	eb 07                	jmp    80101c7b <namex+0x4b>
80101c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101c78:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101c7b:	0f b6 03             	movzbl (%ebx),%eax
80101c7e:	3c 2f                	cmp    $0x2f,%al
80101c80:	74 f6                	je     80101c78 <namex+0x48>
  if(*path == 0)
80101c82:	84 c0                	test   %al,%al
80101c84:	0f 84 ee 00 00 00    	je     80101d78 <namex+0x148>
  while(*path != '/' && *path != 0)
80101c8a:	0f b6 03             	movzbl (%ebx),%eax
80101c8d:	3c 2f                	cmp    $0x2f,%al
80101c8f:	0f 84 b3 00 00 00    	je     80101d48 <namex+0x118>
80101c95:	84 c0                	test   %al,%al
80101c97:	89 da                	mov    %ebx,%edx
80101c99:	75 09                	jne    80101ca4 <namex+0x74>
80101c9b:	e9 a8 00 00 00       	jmp    80101d48 <namex+0x118>
80101ca0:	84 c0                	test   %al,%al
80101ca2:	74 0a                	je     80101cae <namex+0x7e>
    path++;
80101ca4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ca7:	0f b6 02             	movzbl (%edx),%eax
80101caa:	3c 2f                	cmp    $0x2f,%al
80101cac:	75 f2                	jne    80101ca0 <namex+0x70>
80101cae:	89 d1                	mov    %edx,%ecx
80101cb0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cb2:	83 f9 0d             	cmp    $0xd,%ecx
80101cb5:	0f 8e 91 00 00 00    	jle    80101d4c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cbb:	83 ec 04             	sub    $0x4,%esp
80101cbe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cc1:	6a 0e                	push   $0xe
80101cc3:	53                   	push   %ebx
80101cc4:	57                   	push   %edi
80101cc5:	e8 c6 2d 00 00       	call   80104a90 <memmove>
    path++;
80101cca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101ccd:	83 c4 10             	add    $0x10,%esp
    path++;
80101cd0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101cd2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cd5:	75 11                	jne    80101ce8 <namex+0xb8>
80101cd7:	89 f6                	mov    %esi,%esi
80101cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101ce0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ce3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ce6:	74 f8                	je     80101ce0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ce8:	83 ec 0c             	sub    $0xc,%esp
80101ceb:	56                   	push   %esi
80101cec:	e8 1f f9 ff ff       	call   80101610 <ilock>
    if(ip->type != T_DIR){
80101cf1:	83 c4 10             	add    $0x10,%esp
80101cf4:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
80101cf9:	0f 85 91 00 00 00    	jne    80101d90 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101cff:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d02:	85 d2                	test   %edx,%edx
80101d04:	74 09                	je     80101d0f <namex+0xdf>
80101d06:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d09:	0f 84 b7 00 00 00    	je     80101dc6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d0f:	83 ec 04             	sub    $0x4,%esp
80101d12:	6a 00                	push   $0x0
80101d14:	57                   	push   %edi
80101d15:	56                   	push   %esi
80101d16:	e8 65 fe ff ff       	call   80101b80 <dirlookup>
80101d1b:	83 c4 10             	add    $0x10,%esp
80101d1e:	85 c0                	test   %eax,%eax
80101d20:	74 6e                	je     80101d90 <namex+0x160>
  iunlock(ip);
80101d22:	83 ec 0c             	sub    $0xc,%esp
80101d25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d28:	56                   	push   %esi
80101d29:	e8 f2 f9 ff ff       	call   80101720 <iunlock>
  iput(ip);
80101d2e:	89 34 24             	mov    %esi,(%esp)
80101d31:	e8 4a fa ff ff       	call   80101780 <iput>
80101d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d39:	83 c4 10             	add    $0x10,%esp
80101d3c:	89 c6                	mov    %eax,%esi
80101d3e:	e9 38 ff ff ff       	jmp    80101c7b <namex+0x4b>
80101d43:	90                   	nop
80101d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d48:	89 da                	mov    %ebx,%edx
80101d4a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d4c:	83 ec 04             	sub    $0x4,%esp
80101d4f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d52:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d55:	51                   	push   %ecx
80101d56:	53                   	push   %ebx
80101d57:	57                   	push   %edi
80101d58:	e8 33 2d 00 00       	call   80104a90 <memmove>
    name[len] = 0;
80101d5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d60:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d63:	83 c4 10             	add    $0x10,%esp
80101d66:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d6a:	89 d3                	mov    %edx,%ebx
80101d6c:	e9 61 ff ff ff       	jmp    80101cd2 <namex+0xa2>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d7b:	85 c0                	test   %eax,%eax
80101d7d:	75 5d                	jne    80101ddc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101d7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d82:	89 f0                	mov    %esi,%eax
80101d84:	5b                   	pop    %ebx
80101d85:	5e                   	pop    %esi
80101d86:	5f                   	pop    %edi
80101d87:	5d                   	pop    %ebp
80101d88:	c3                   	ret    
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101d90:	83 ec 0c             	sub    $0xc,%esp
80101d93:	56                   	push   %esi
80101d94:	e8 87 f9 ff ff       	call   80101720 <iunlock>
  iput(ip);
80101d99:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101d9c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101d9e:	e8 dd f9 ff ff       	call   80101780 <iput>
      return 0;
80101da3:	83 c4 10             	add    $0x10,%esp
}
80101da6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101da9:	89 f0                	mov    %esi,%eax
80101dab:	5b                   	pop    %ebx
80101dac:	5e                   	pop    %esi
80101dad:	5f                   	pop    %edi
80101dae:	5d                   	pop    %ebp
80101daf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101db0:	ba 01 00 00 00       	mov    $0x1,%edx
80101db5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dba:	e8 31 f4 ff ff       	call   801011f0 <iget>
80101dbf:	89 c6                	mov    %eax,%esi
80101dc1:	e9 b5 fe ff ff       	jmp    80101c7b <namex+0x4b>
      iunlock(ip);
80101dc6:	83 ec 0c             	sub    $0xc,%esp
80101dc9:	56                   	push   %esi
80101dca:	e8 51 f9 ff ff       	call   80101720 <iunlock>
      return ip;
80101dcf:	83 c4 10             	add    $0x10,%esp
}
80101dd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd5:	89 f0                	mov    %esi,%eax
80101dd7:	5b                   	pop    %ebx
80101dd8:	5e                   	pop    %esi
80101dd9:	5f                   	pop    %edi
80101dda:	5d                   	pop    %ebp
80101ddb:	c3                   	ret    
    iput(ip);
80101ddc:	83 ec 0c             	sub    $0xc,%esp
80101ddf:	56                   	push   %esi
    return 0;
80101de0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101de2:	e8 99 f9 ff ff       	call   80101780 <iput>
    return 0;
80101de7:	83 c4 10             	add    $0x10,%esp
80101dea:	eb 93                	jmp    80101d7f <namex+0x14f>
80101dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101df0 <dirlink>:
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 20             	sub    $0x20,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dfc:	6a 00                	push   $0x0
80101dfe:	ff 75 0c             	pushl  0xc(%ebp)
80101e01:	53                   	push   %ebx
80101e02:	e8 79 fd ff ff       	call   80101b80 <dirlookup>
80101e07:	83 c4 10             	add    $0x10,%esp
80101e0a:	85 c0                	test   %eax,%eax
80101e0c:	75 67                	jne    80101e75 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e0e:	8b 7b 18             	mov    0x18(%ebx),%edi
80101e11:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e14:	85 ff                	test   %edi,%edi
80101e16:	74 29                	je     80101e41 <dirlink+0x51>
80101e18:	31 ff                	xor    %edi,%edi
80101e1a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e1d:	eb 09                	jmp    80101e28 <dirlink+0x38>
80101e1f:	90                   	nop
80101e20:	83 c7 10             	add    $0x10,%edi
80101e23:	3b 7b 18             	cmp    0x18(%ebx),%edi
80101e26:	73 19                	jae    80101e41 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e28:	6a 10                	push   $0x10
80101e2a:	57                   	push   %edi
80101e2b:	56                   	push   %esi
80101e2c:	53                   	push   %ebx
80101e2d:	e8 fe fa ff ff       	call   80101930 <readi>
80101e32:	83 c4 10             	add    $0x10,%esp
80101e35:	83 f8 10             	cmp    $0x10,%eax
80101e38:	75 4e                	jne    80101e88 <dirlink+0x98>
    if(de.inum == 0)
80101e3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e3f:	75 df                	jne    80101e20 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e41:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e44:	83 ec 04             	sub    $0x4,%esp
80101e47:	6a 0e                	push   $0xe
80101e49:	ff 75 0c             	pushl  0xc(%ebp)
80101e4c:	50                   	push   %eax
80101e4d:	e8 0e 2d 00 00       	call   80104b60 <strncpy>
  de.inum = inum;
80101e52:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e55:	6a 10                	push   $0x10
80101e57:	57                   	push   %edi
80101e58:	56                   	push   %esi
80101e59:	53                   	push   %ebx
  de.inum = inum;
80101e5a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5e:	e8 cd fb ff ff       	call   80101a30 <writei>
80101e63:	83 c4 20             	add    $0x20,%esp
80101e66:	83 f8 10             	cmp    $0x10,%eax
80101e69:	75 2a                	jne    80101e95 <dirlink+0xa5>
  return 0;
80101e6b:	31 c0                	xor    %eax,%eax
}
80101e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e70:	5b                   	pop    %ebx
80101e71:	5e                   	pop    %esi
80101e72:	5f                   	pop    %edi
80101e73:	5d                   	pop    %ebp
80101e74:	c3                   	ret    
    iput(ip);
80101e75:	83 ec 0c             	sub    $0xc,%esp
80101e78:	50                   	push   %eax
80101e79:	e8 02 f9 ff ff       	call   80101780 <iput>
    return -1;
80101e7e:	83 c4 10             	add    $0x10,%esp
80101e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e86:	eb e5                	jmp    80101e6d <dirlink+0x7d>
      panic("dirlink read");
80101e88:	83 ec 0c             	sub    $0xc,%esp
80101e8b:	68 95 7a 10 80       	push   $0x80107a95
80101e90:	e8 db e4 ff ff       	call   80100370 <panic>
    panic("dirlink");
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	68 c2 80 10 80       	push   $0x801080c2
80101e9d:	e8 ce e4 ff ff       	call   80100370 <panic>
80101ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <namei>:

struct inode*
namei(char *path)
{
80101eb0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb1:	31 d2                	xor    %edx,%edx
{
80101eb3:	89 e5                	mov    %esp,%ebp
80101eb5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ebe:	e8 6d fd ff ff       	call   80101c30 <namex>
}
80101ec3:	c9                   	leave  
80101ec4:	c3                   	ret    
80101ec5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ed0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ed0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ed1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101ed6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ede:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101edf:	e9 4c fd ff ff       	jmp    80101c30 <namex>
80101ee4:	66 90                	xchg   %ax,%ax
80101ee6:	66 90                	xchg   %ax,%ax
80101ee8:	66 90                	xchg   %ax,%ax
80101eea:	66 90                	xchg   %ax,%ax
80101eec:	66 90                	xchg   %ax,%ax
80101eee:	66 90                	xchg   %ax,%ax

80101ef0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef0:	55                   	push   %ebp
80101ef1:	89 e5                	mov    %esp,%ebp
80101ef3:	57                   	push   %edi
80101ef4:	56                   	push   %esi
80101ef5:	53                   	push   %ebx
80101ef6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101ef9:	85 c0                	test   %eax,%eax
80101efb:	0f 84 b4 00 00 00    	je     80101fb5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f01:	8b 58 08             	mov    0x8(%eax),%ebx
80101f04:	89 c6                	mov    %eax,%esi
80101f06:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f0c:	0f 87 96 00 00 00    	ja     80101fa8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f12:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f17:	89 f6                	mov    %esi,%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f20:	89 ca                	mov    %ecx,%edx
80101f22:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f23:	83 e0 c0             	and    $0xffffffc0,%eax
80101f26:	3c 40                	cmp    $0x40,%al
80101f28:	75 f6                	jne    80101f20 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f2a:	31 ff                	xor    %edi,%edi
80101f2c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f31:	89 f8                	mov    %edi,%eax
80101f33:	ee                   	out    %al,(%dx)
80101f34:	b8 01 00 00 00       	mov    $0x1,%eax
80101f39:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f3e:	ee                   	out    %al,(%dx)
80101f3f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f44:	89 d8                	mov    %ebx,%eax
80101f46:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f47:	89 d8                	mov    %ebx,%eax
80101f49:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f4e:	c1 f8 08             	sar    $0x8,%eax
80101f51:	ee                   	out    %al,(%dx)
80101f52:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f57:	89 f8                	mov    %edi,%eax
80101f59:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f5a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f5e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f63:	c1 e0 04             	shl    $0x4,%eax
80101f66:	83 e0 10             	and    $0x10,%eax
80101f69:	83 c8 e0             	or     $0xffffffe0,%eax
80101f6c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f6d:	f6 06 04             	testb  $0x4,(%esi)
80101f70:	75 16                	jne    80101f88 <idestart+0x98>
80101f72:	b8 20 00 00 00       	mov    $0x20,%eax
80101f77:	89 ca                	mov    %ecx,%edx
80101f79:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7d:	5b                   	pop    %ebx
80101f7e:	5e                   	pop    %esi
80101f7f:	5f                   	pop    %edi
80101f80:	5d                   	pop    %ebp
80101f81:	c3                   	ret    
80101f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f88:	b8 30 00 00 00       	mov    $0x30,%eax
80101f8d:	89 ca                	mov    %ecx,%edx
80101f8f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101f90:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101f95:	83 c6 18             	add    $0x18,%esi
80101f98:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101f9d:	fc                   	cld    
80101f9e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fa3:	5b                   	pop    %ebx
80101fa4:	5e                   	pop    %esi
80101fa5:	5f                   	pop    %edi
80101fa6:	5d                   	pop    %ebp
80101fa7:	c3                   	ret    
    panic("incorrect blockno");
80101fa8:	83 ec 0c             	sub    $0xc,%esp
80101fab:	68 09 7b 10 80       	push   $0x80107b09
80101fb0:	e8 bb e3 ff ff       	call   80100370 <panic>
    panic("idestart");
80101fb5:	83 ec 0c             	sub    $0xc,%esp
80101fb8:	68 00 7b 10 80       	push   $0x80107b00
80101fbd:	e8 ae e3 ff ff       	call   80100370 <panic>
80101fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <ideinit>:
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101fd6:	68 1b 7b 10 80       	push   $0x80107b1b
80101fdb:	68 80 b5 10 80       	push   $0x8010b580
80101fe0:	e8 3b 25 00 00       	call   80104520 <initlock>
  picenable(IRQ_IDE);
80101fe5:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80101fec:	e8 0f 14 00 00       	call   80103400 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101ff1:	58                   	pop    %eax
80101ff2:	a1 c0 a8 14 80       	mov    0x8014a8c0,%eax
80101ff7:	5a                   	pop    %edx
80101ff8:	83 e8 01             	sub    $0x1,%eax
80101ffb:	50                   	push   %eax
80101ffc:	6a 0e                	push   $0xe
80101ffe:	e8 bd 02 00 00       	call   801022c0 <ioapicenable>
80102003:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102006:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010200b:	90                   	nop
8010200c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102010:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102011:	83 e0 c0             	and    $0xffffffc0,%eax
80102014:	3c 40                	cmp    $0x40,%al
80102016:	75 f8                	jne    80102010 <ideinit+0x40>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102018:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010201d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102022:	ee                   	out    %al,(%dx)
80102023:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102028:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202d:	eb 06                	jmp    80102035 <ideinit+0x65>
8010202f:	90                   	nop
  for(i=0; i<1000; i++){
80102030:	83 e9 01             	sub    $0x1,%ecx
80102033:	74 0f                	je     80102044 <ideinit+0x74>
80102035:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102036:	84 c0                	test   %al,%al
80102038:	74 f6                	je     80102030 <ideinit+0x60>
      havedisk1 = 1;
8010203a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102041:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102044:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102049:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010204e:	ee                   	out    %al,(%dx)
}
8010204f:	c9                   	leave  
80102050:	c3                   	ret    
80102051:	eb 0d                	jmp    80102060 <ideintr>
80102053:	90                   	nop
80102054:	90                   	nop
80102055:	90                   	nop
80102056:	90                   	nop
80102057:	90                   	nop
80102058:	90                   	nop
80102059:	90                   	nop
8010205a:	90                   	nop
8010205b:	90                   	nop
8010205c:	90                   	nop
8010205d:	90                   	nop
8010205e:	90                   	nop
8010205f:	90                   	nop

80102060 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102069:	68 80 b5 10 80       	push   $0x8010b580
8010206e:	e8 cd 24 00 00       	call   80104540 <acquire>
  if((b = idequeue) == 0){
80102073:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102079:	83 c4 10             	add    $0x10,%esp
8010207c:	85 db                	test   %ebx,%ebx
8010207e:	74 67                	je     801020e7 <ideintr+0x87>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
80102080:	8b 43 14             	mov    0x14(%ebx),%eax
80102083:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102088:	8b 3b                	mov    (%ebx),%edi
8010208a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102090:	75 31                	jne    801020c3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102097:	89 f6                	mov    %esi,%esi
80102099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a1:	89 c6                	mov    %eax,%esi
801020a3:	83 e6 c0             	and    $0xffffffc0,%esi
801020a6:	89 f1                	mov    %esi,%ecx
801020a8:	80 f9 40             	cmp    $0x40,%cl
801020ab:	75 f3                	jne    801020a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020ad:	a8 21                	test   $0x21,%al
801020af:	75 12                	jne    801020c3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020b1:	8d 7b 18             	lea    0x18(%ebx),%edi
  asm volatile("cld; rep insl" :
801020b4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020b9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020be:	fc                   	cld    
801020bf:	f3 6d                	rep insl (%dx),%es:(%edi)
801020c1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020c3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020c6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020c9:	89 f9                	mov    %edi,%ecx
801020cb:	83 c9 02             	or     $0x2,%ecx
801020ce:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020d0:	53                   	push   %ebx
801020d1:	e8 8a 20 00 00       	call   80104160 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020d6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801020db:	83 c4 10             	add    $0x10,%esp
801020de:	85 c0                	test   %eax,%eax
801020e0:	74 05                	je     801020e7 <ideintr+0x87>
    idestart(idequeue);
801020e2:	e8 09 fe ff ff       	call   80101ef0 <idestart>
    release(&idelock);
801020e7:	83 ec 0c             	sub    $0xc,%esp
801020ea:	68 80 b5 10 80       	push   $0x8010b580
801020ef:	e8 0c 26 00 00       	call   80104700 <release>

  release(&idelock);
}
801020f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020f7:	5b                   	pop    %ebx
801020f8:	5e                   	pop    %esi
801020f9:	5f                   	pop    %edi
801020fa:	5d                   	pop    %ebp
801020fb:	c3                   	ret    
801020fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102100 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	53                   	push   %ebx
80102104:	83 ec 04             	sub    $0x4,%esp
80102107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010210a:	8b 03                	mov    (%ebx),%eax
8010210c:	a8 01                	test   $0x1,%al
8010210e:	0f 84 c0 00 00 00    	je     801021d4 <iderw+0xd4>
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102114:	83 e0 06             	and    $0x6,%eax
80102117:	83 f8 02             	cmp    $0x2,%eax
8010211a:	0f 84 a7 00 00 00    	je     801021c7 <iderw+0xc7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102120:	8b 53 04             	mov    0x4(%ebx),%edx
80102123:	85 d2                	test   %edx,%edx
80102125:	74 0d                	je     80102134 <iderw+0x34>
80102127:	a1 60 b5 10 80       	mov    0x8010b560,%eax
8010212c:	85 c0                	test   %eax,%eax
8010212e:	0f 84 ad 00 00 00    	je     801021e1 <iderw+0xe1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102134:	83 ec 0c             	sub    $0xc,%esp
80102137:	68 80 b5 10 80       	push   $0x8010b580
8010213c:	e8 ff 23 00 00       	call   80104540 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102141:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102147:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
8010214a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102151:	85 d2                	test   %edx,%edx
80102153:	75 0d                	jne    80102162 <iderw+0x62>
80102155:	eb 69                	jmp    801021c0 <iderw+0xc0>
80102157:	89 f6                	mov    %esi,%esi
80102159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102160:	89 c2                	mov    %eax,%edx
80102162:	8b 42 14             	mov    0x14(%edx),%eax
80102165:	85 c0                	test   %eax,%eax
80102167:	75 f7                	jne    80102160 <iderw+0x60>
80102169:	83 c2 14             	add    $0x14,%edx
    ;
  *pp = b;
8010216c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010216e:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
80102174:	74 3a                	je     801021b0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102176:	8b 03                	mov    (%ebx),%eax
80102178:	83 e0 06             	and    $0x6,%eax
8010217b:	83 f8 02             	cmp    $0x2,%eax
8010217e:	74 1b                	je     8010219b <iderw+0x9b>
    sleep(b, &idelock);
80102180:	83 ec 08             	sub    $0x8,%esp
80102183:	68 80 b5 10 80       	push   $0x8010b580
80102188:	53                   	push   %ebx
80102189:	e8 22 1e 00 00       	call   80103fb0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010218e:	8b 03                	mov    (%ebx),%eax
80102190:	83 c4 10             	add    $0x10,%esp
80102193:	83 e0 06             	and    $0x6,%eax
80102196:	83 f8 02             	cmp    $0x2,%eax
80102199:	75 e5                	jne    80102180 <iderw+0x80>
  }

  release(&idelock);
8010219b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021a5:	c9                   	leave  
  release(&idelock);
801021a6:	e9 55 25 00 00       	jmp    80104700 <release>
801021ab:	90                   	nop
801021ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021b0:	89 d8                	mov    %ebx,%eax
801021b2:	e8 39 fd ff ff       	call   80101ef0 <idestart>
801021b7:	eb bd                	jmp    80102176 <iderw+0x76>
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021c0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801021c5:	eb a5                	jmp    8010216c <iderw+0x6c>
    panic("iderw: nothing to do");
801021c7:	83 ec 0c             	sub    $0xc,%esp
801021ca:	68 33 7b 10 80       	push   $0x80107b33
801021cf:	e8 9c e1 ff ff       	call   80100370 <panic>
    panic("iderw: buf not busy");
801021d4:	83 ec 0c             	sub    $0xc,%esp
801021d7:	68 1f 7b 10 80       	push   $0x80107b1f
801021dc:	e8 8f e1 ff ff       	call   80100370 <panic>
    panic("iderw: ide disk 1 not present");
801021e1:	83 ec 0c             	sub    $0xc,%esp
801021e4:	68 48 7b 10 80       	push   $0x80107b48
801021e9:	e8 82 e1 ff ff       	call   80100370 <panic>
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801021f0:	a1 c4 a2 14 80       	mov    0x8014a2c4,%eax
801021f5:	85 c0                	test   %eax,%eax
801021f7:	0f 84 b3 00 00 00    	je     801022b0 <ioapicinit+0xc0>
{
801021fd:	55                   	push   %ebp
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021fe:	c7 05 94 21 11 80 00 	movl   $0xfec00000,0x80112194
80102205:	00 c0 fe 
{
80102208:	89 e5                	mov    %esp,%ebp
8010220a:	56                   	push   %esi
8010220b:	53                   	push   %ebx
  ioapic->reg = reg;
8010220c:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102213:	00 00 00 
  return ioapic->data;
80102216:	a1 94 21 11 80       	mov    0x80112194,%eax
8010221b:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
8010221e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102224:	8b 0d 94 21 11 80    	mov    0x80112194,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010222a:	0f b6 15 c0 a2 14 80 	movzbl 0x8014a2c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102231:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102234:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102237:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010223a:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
8010223d:	39 c2                	cmp    %eax,%edx
8010223f:	75 4f                	jne    80102290 <ioapicinit+0xa0>
80102241:	83 c3 21             	add    $0x21,%ebx
{
80102244:	ba 10 00 00 00       	mov    $0x10,%edx
80102249:	b8 20 00 00 00       	mov    $0x20,%eax
8010224e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102250:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102252:	8b 0d 94 21 11 80    	mov    0x80112194,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102258:	89 c6                	mov    %eax,%esi
8010225a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102260:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102263:	89 71 10             	mov    %esi,0x10(%ecx)
80102266:	8d 72 01             	lea    0x1(%edx),%esi
80102269:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010226c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010226e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102270:	8b 0d 94 21 11 80    	mov    0x80112194,%ecx
80102276:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010227d:	75 d1                	jne    80102250 <ioapicinit+0x60>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010227f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102282:	5b                   	pop    %ebx
80102283:	5e                   	pop    %esi
80102284:	5d                   	pop    %ebp
80102285:	c3                   	ret    
80102286:	8d 76 00             	lea    0x0(%esi),%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102290:	83 ec 0c             	sub    $0xc,%esp
80102293:	68 68 7b 10 80       	push   $0x80107b68
80102298:	e8 a3 e3 ff ff       	call   80100640 <cprintf>
8010229d:	8b 0d 94 21 11 80    	mov    0x80112194,%ecx
801022a3:	83 c4 10             	add    $0x10,%esp
801022a6:	eb 99                	jmp    80102241 <ioapicinit+0x51>
801022a8:	90                   	nop
801022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022b0:	f3 c3                	repz ret 
801022b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
801022c0:	8b 15 c4 a2 14 80    	mov    0x8014a2c4,%edx
{
801022c6:	55                   	push   %ebp
801022c7:	89 e5                	mov    %esp,%ebp
  if(!ismp)
801022c9:	85 d2                	test   %edx,%edx
{
801022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801022ce:	74 2b                	je     801022fb <ioapicenable+0x3b>
  ioapic->reg = reg;
801022d0:	8b 0d 94 21 11 80    	mov    0x80112194,%ecx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022d6:	8d 50 20             	lea    0x20(%eax),%edx
801022d9:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022dd:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022df:	8b 0d 94 21 11 80    	mov    0x80112194,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e5:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022e8:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022ee:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f0:	a1 94 21 11 80       	mov    0x80112194,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f5:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022f8:	89 50 10             	mov    %edx,0x10(%eax)
}
801022fb:	5d                   	pop    %ebp
801022fc:	c3                   	ret    
801022fd:	66 90                	xchg   %ax,%ax
801022ff:	90                   	nop

80102300 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	56                   	push   %esi
80102304:	53                   	push   %ebx
80102305:	8b 75 08             	mov    0x8(%ebp),%esi
  struct run *r;
  // cprintf("kmem.pageref[V2P(v)>> PGSHIFT]=%d",kmem.pageref[V2P(v)>> PGSHIFT]);
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102308:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
8010230e:	0f 85 b1 00 00 00    	jne    801023c5 <kfree+0xc5>
80102314:	81 fe 00 fb 14 80    	cmp    $0x8014fb00,%esi
8010231a:	0f 82 a5 00 00 00    	jb     801023c5 <kfree+0xc5>
80102320:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
80102326:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
8010232c:	0f 87 93 00 00 00    	ja     801023c5 <kfree+0xc5>
    panic("kfree");
  if(kmem.use_lock)
80102332:	8b 15 d4 21 11 80    	mov    0x801121d4,%edx
80102338:	85 d2                	test   %edx,%edx
8010233a:	75 74                	jne    801023b0 <kfree+0xb0>
    acquire(&kmem.lock);
  if(kmem.pageref[V2P(v)/PGSIZE] >0)//若引用值大于0
8010233c:	c1 eb 0c             	shr    $0xc,%ebx
8010233f:	83 c3 0c             	add    $0xc,%ebx
80102342:	8b 04 9d ac 21 11 80 	mov    -0x7feede54(,%ebx,4),%eax
80102349:	85 c0                	test   %eax,%eax
8010234b:	75 33                	jne    80102380 <kfree+0x80>
    kmem.pageref[V2P(v)/PGSIZE]-=1;//单纯引用值-1即可
  // cprintf("kmem.pageref[V2P(v)>> PGSHIFT]=%d",kmem.pageref[V2P(v)>> PGSHIFT]);
  if(kmem.pageref[V2P(v)/PGSIZE]==0){//若引用值==0
    // Fill with junk to catch dangling refs.
    memset(v, 1, PGSIZE);//数字1填充该页
8010234d:	83 ec 04             	sub    $0x4,%esp
80102350:	68 00 10 00 00       	push   $0x1000
80102355:	6a 01                	push   $0x1
80102357:	56                   	push   %esi
80102358:	e8 83 26 00 00       	call   801049e0 <memset>
    r = (struct run*)v;//将页帧插入到链表头部
    r->next = kmem.freelist;
8010235d:	a1 d8 21 11 80       	mov    0x801121d8,%eax
    kmem.freelist = r;
80102362:	83 c4 10             	add    $0x10,%esp
    r->next = kmem.freelist;
80102365:	89 06                	mov    %eax,(%esi)
  }
  
  if(kmem.use_lock)
80102367:	a1 d4 21 11 80       	mov    0x801121d4,%eax
    kmem.freelist = r;
8010236c:	89 35 d8 21 11 80    	mov    %esi,0x801121d8
  if(kmem.use_lock)
80102372:	85 c0                	test   %eax,%eax
80102374:	75 21                	jne    80102397 <kfree+0x97>
    release(&kmem.lock);
}
80102376:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102379:	5b                   	pop    %ebx
8010237a:	5e                   	pop    %esi
8010237b:	5d                   	pop    %ebp
8010237c:	c3                   	ret    
8010237d:	8d 76 00             	lea    0x0(%esi),%esi
    kmem.pageref[V2P(v)/PGSIZE]-=1;//单纯引用值-1即可
80102380:	83 e8 01             	sub    $0x1,%eax
  if(kmem.pageref[V2P(v)/PGSIZE]==0){//若引用值==0
80102383:	85 c0                	test   %eax,%eax
    kmem.pageref[V2P(v)/PGSIZE]-=1;//单纯引用值-1即可
80102385:	89 04 9d ac 21 11 80 	mov    %eax,-0x7feede54(,%ebx,4)
  if(kmem.pageref[V2P(v)/PGSIZE]==0){//若引用值==0
8010238c:	74 bf                	je     8010234d <kfree+0x4d>
  if(kmem.use_lock)
8010238e:	a1 d4 21 11 80       	mov    0x801121d4,%eax
80102393:	85 c0                	test   %eax,%eax
80102395:	74 df                	je     80102376 <kfree+0x76>
    release(&kmem.lock);
80102397:	c7 45 08 a0 21 11 80 	movl   $0x801121a0,0x8(%ebp)
}
8010239e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a1:	5b                   	pop    %ebx
801023a2:	5e                   	pop    %esi
801023a3:	5d                   	pop    %ebp
    release(&kmem.lock);
801023a4:	e9 57 23 00 00       	jmp    80104700 <release>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801023b0:	83 ec 0c             	sub    $0xc,%esp
801023b3:	68 a0 21 11 80       	push   $0x801121a0
801023b8:	e8 83 21 00 00       	call   80104540 <acquire>
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	e9 77 ff ff ff       	jmp    8010233c <kfree+0x3c>
    panic("kfree");
801023c5:	83 ec 0c             	sub    $0xc,%esp
801023c8:	68 9a 7b 10 80       	push   $0x80107b9a
801023cd:	e8 9e df ff ff       	call   80100370 <panic>
801023d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023e0 <freerange>:
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fd:	39 de                	cmp    %ebx,%esi
801023ff:	72 23                	jb     80102424 <freerange+0x44>
80102401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102408:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010240e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102411:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102417:	50                   	push   %eax
80102418:	e8 e3 fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	39 f3                	cmp    %esi,%ebx
80102422:	76 e4                	jbe    80102408 <freerange+0x28>
}
80102424:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102427:	5b                   	pop    %ebx
80102428:	5e                   	pop    %esi
80102429:	5d                   	pop    %ebp
8010242a:	c3                   	ret    
8010242b:	90                   	nop
8010242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102430 <kinit1>:
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
80102435:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102438:	83 ec 08             	sub    $0x8,%esp
8010243b:	68 a0 7b 10 80       	push   $0x80107ba0
80102440:	68 a0 21 11 80       	push   $0x801121a0
80102445:	e8 d6 20 00 00       	call   80104520 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010244a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010244d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102450:	c7 05 d4 21 11 80 00 	movl   $0x0,0x801121d4
80102457:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010245a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102460:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102466:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010246c:	39 de                	cmp    %ebx,%esi
8010246e:	72 1c                	jb     8010248c <kinit1+0x5c>
    kfree(p);
80102470:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102476:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102479:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010247f:	50                   	push   %eax
80102480:	e8 7b fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102485:	83 c4 10             	add    $0x10,%esp
80102488:	39 de                	cmp    %ebx,%esi
8010248a:	73 e4                	jae    80102470 <kinit1+0x40>
}
8010248c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010248f:	5b                   	pop    %ebx
80102490:	5e                   	pop    %esi
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret    
80102493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kinit2>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024bd:	39 de                	cmp    %ebx,%esi
801024bf:	72 23                	jb     801024e4 <kinit2+0x44>
801024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024d7:	50                   	push   %eax
801024d8:	e8 23 fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	39 de                	cmp    %ebx,%esi
801024e2:	73 e4                	jae    801024c8 <kinit2+0x28>
  kmem.use_lock = 1;
801024e4:	c7 05 d4 21 11 80 01 	movl   $0x1,0x801121d4
801024eb:	00 00 00 
}
801024ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024f1:	5b                   	pop    %ebx
801024f2:	5e                   	pop    %esi
801024f3:	5d                   	pop    %ebp
801024f4:	c3                   	ret    
801024f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102500 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102500:	a1 d4 21 11 80       	mov    0x801121d4,%eax
80102505:	85 c0                	test   %eax,%eax
80102507:	75 2f                	jne    80102538 <kalloc+0x38>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102509:	a1 d8 21 11 80       	mov    0x801121d8,%eax
  if(r){
8010250e:	85 c0                	test   %eax,%eax
80102510:	74 1e                	je     80102530 <kalloc+0x30>
    kmem.freelist = r->next;
80102512:	8b 10                	mov    (%eax),%edx
80102514:	89 15 d8 21 11 80    	mov    %edx,0x801121d8
    //将r虚拟地址对应的物理地址上对应的pageref数组引用次数初始化为1
    kmem.pageref[V2P((char*)r) /PGSIZE]=1;
8010251a:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80102520:	c1 ea 0c             	shr    $0xc,%edx
80102523:	c7 04 95 dc 21 11 80 	movl   $0x1,-0x7feede24(,%edx,4)
8010252a:	01 00 00 00 
8010252e:	c3                   	ret    
8010252f:	90                   	nop
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102530:	f3 c3                	repz ret 
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102538:	55                   	push   %ebp
80102539:	89 e5                	mov    %esp,%ebp
8010253b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010253e:	68 a0 21 11 80       	push   $0x801121a0
80102543:	e8 f8 1f 00 00       	call   80104540 <acquire>
  r = kmem.freelist;
80102548:	a1 d8 21 11 80       	mov    0x801121d8,%eax
  if(r){
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	8b 0d d4 21 11 80    	mov    0x801121d4,%ecx
80102556:	85 c0                	test   %eax,%eax
80102558:	74 1c                	je     80102576 <kalloc+0x76>
    kmem.freelist = r->next;
8010255a:	8b 10                	mov    (%eax),%edx
8010255c:	89 15 d8 21 11 80    	mov    %edx,0x801121d8
    kmem.pageref[V2P((char*)r) /PGSIZE]=1;
80102562:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80102568:	c1 ea 0c             	shr    $0xc,%edx
8010256b:	c7 04 95 dc 21 11 80 	movl   $0x1,-0x7feede24(,%edx,4)
80102572:	01 00 00 00 
  if(kmem.use_lock)
80102576:	85 c9                	test   %ecx,%ecx
80102578:	74 16                	je     80102590 <kalloc+0x90>
    release(&kmem.lock);
8010257a:	83 ec 0c             	sub    $0xc,%esp
8010257d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102580:	68 a0 21 11 80       	push   $0x801121a0
80102585:	e8 76 21 00 00       	call   80104700 <release>
  return (char*)r;
8010258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
8010258d:	83 c4 10             	add    $0x10,%esp
}
80102590:	c9                   	leave  
80102591:	c3                   	ret    
80102592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025a0 <pageref_get>:

//获取对应物理地址的被引用次数函数
uint pageref_get(uint pa){
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	53                   	push   %ebx
801025a4:	83 ec 10             	sub    $0x10,%esp
  //index是根据传入的物理地址计算页号
  uint index =pa >> PGSHIFT;
  //加上自旋锁
  acquire(&kmem.lock);
801025a7:	68 a0 21 11 80       	push   $0x801121a0
801025ac:	e8 8f 1f 00 00       	call   80104540 <acquire>
  uint index =pa >> PGSHIFT;
801025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  //获取数组中引用次数
  uint count=kmem.pageref[index];
  //释放锁
  release(&kmem.lock);
801025b4:	c7 04 24 a0 21 11 80 	movl   $0x801121a0,(%esp)
  uint index =pa >> PGSHIFT;
801025bb:	c1 e8 0c             	shr    $0xc,%eax
  uint count=kmem.pageref[index];
801025be:	8b 1c 85 dc 21 11 80 	mov    -0x7feede24(,%eax,4),%ebx
  release(&kmem.lock);
801025c5:	e8 36 21 00 00       	call   80104700 <release>
  return count;//返回引用次数
}
801025ca:	89 d8                	mov    %ebx,%eax
801025cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025cf:	c9                   	leave  
801025d0:	c3                   	ret    
801025d1:	eb 0d                	jmp    801025e0 <pageref_set>
801025d3:	90                   	nop
801025d4:	90                   	nop
801025d5:	90                   	nop
801025d6:	90                   	nop
801025d7:	90                   	nop
801025d8:	90                   	nop
801025d9:	90                   	nop
801025da:	90                   	nop
801025db:	90                   	nop
801025dc:	90                   	nop
801025dd:	90                   	nop
801025de:	90                   	nop
801025df:	90                   	nop

801025e0 <pageref_set>:

//增加对应physical address计数器计数delta函数
void pageref_set(uint pa,uint delta){
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
  //index是根据传入的物理地址计算页号
  uint index = pa >> PGSHIFT;
801025e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
void pageref_set(uint pa,uint delta){
801025e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&kmem.lock);
801025eb:	83 ec 0c             	sub    $0xc,%esp
801025ee:	68 a0 21 11 80       	push   $0x801121a0
  uint index = pa >> PGSHIFT;
801025f3:	c1 eb 0c             	shr    $0xc,%ebx
  acquire(&kmem.lock);
801025f6:	e8 45 1f 00 00       	call   80104540 <acquire>
  //增加pa物理地址所对应的引用的计数
  kmem.pageref[index] += delta;
801025fb:	01 34 9d dc 21 11 80 	add    %esi,-0x7feede24(,%ebx,4)
  release(&kmem.lock);
80102602:	c7 45 08 a0 21 11 80 	movl   $0x801121a0,0x8(%ebp)
80102609:	83 c4 10             	add    $0x10,%esp
8010260c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010260f:	5b                   	pop    %ebx
80102610:	5e                   	pop    %esi
80102611:	5d                   	pop    %ebp
  release(&kmem.lock);
80102612:	e9 e9 20 00 00       	jmp    80104700 <release>
80102617:	66 90                	xchg   %ax,%ax
80102619:	66 90                	xchg   %ax,%ax
8010261b:	66 90                	xchg   %ax,%ax
8010261d:	66 90                	xchg   %ax,%ax
8010261f:	90                   	nop

80102620 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102620:	ba 64 00 00 00       	mov    $0x64,%edx
80102625:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102626:	a8 01                	test   $0x1,%al
80102628:	0f 84 c2 00 00 00    	je     801026f0 <kbdgetc+0xd0>
8010262e:	ba 60 00 00 00       	mov    $0x60,%edx
80102633:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102634:	0f b6 d0             	movzbl %al,%edx
80102637:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010263d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102643:	0f 84 7f 00 00 00    	je     801026c8 <kbdgetc+0xa8>
{
80102649:	55                   	push   %ebp
8010264a:	89 e5                	mov    %esp,%ebp
8010264c:	53                   	push   %ebx
8010264d:	89 cb                	mov    %ecx,%ebx
8010264f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102652:	84 c0                	test   %al,%al
80102654:	78 4a                	js     801026a0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102656:	85 db                	test   %ebx,%ebx
80102658:	74 09                	je     80102663 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010265a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010265d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102660:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102663:	0f b6 82 e0 7c 10 80 	movzbl -0x7fef8320(%edx),%eax
8010266a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010266c:	0f b6 82 e0 7b 10 80 	movzbl -0x7fef8420(%edx),%eax
80102673:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102675:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102677:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010267d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102680:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102683:	8b 04 85 c0 7b 10 80 	mov    -0x7fef8440(,%eax,4),%eax
8010268a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010268e:	74 31                	je     801026c1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102690:	8d 50 9f             	lea    -0x61(%eax),%edx
80102693:	83 fa 19             	cmp    $0x19,%edx
80102696:	77 40                	ja     801026d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102698:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010269b:	5b                   	pop    %ebx
8010269c:	5d                   	pop    %ebp
8010269d:	c3                   	ret    
8010269e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801026a0:	83 e0 7f             	and    $0x7f,%eax
801026a3:	85 db                	test   %ebx,%ebx
801026a5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801026a8:	0f b6 82 e0 7c 10 80 	movzbl -0x7fef8320(%edx),%eax
801026af:	83 c8 40             	or     $0x40,%eax
801026b2:	0f b6 c0             	movzbl %al,%eax
801026b5:	f7 d0                	not    %eax
801026b7:	21 c1                	and    %eax,%ecx
    return 0;
801026b9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801026bb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801026c1:	5b                   	pop    %ebx
801026c2:	5d                   	pop    %ebp
801026c3:	c3                   	ret    
801026c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801026c8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801026cb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801026cd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
801026d3:	c3                   	ret    
801026d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801026d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801026db:	8d 50 20             	lea    0x20(%eax),%edx
}
801026de:	5b                   	pop    %ebx
      c += 'a' - 'A';
801026df:	83 f9 1a             	cmp    $0x1a,%ecx
801026e2:	0f 42 c2             	cmovb  %edx,%eax
}
801026e5:	5d                   	pop    %ebp
801026e6:	c3                   	ret    
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801026f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801026f5:	c3                   	ret    
801026f6:	8d 76 00             	lea    0x0(%esi),%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102700 <kbdintr>:

void
kbdintr(void)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102706:	68 20 26 10 80       	push   $0x80102620
8010270b:	e8 e0 e0 ff ff       	call   801007f0 <consoleintr>
}
80102710:	83 c4 10             	add    $0x10,%esp
80102713:	c9                   	leave  
80102714:	c3                   	ret    
80102715:	66 90                	xchg   %ax,%ax
80102717:	66 90                	xchg   %ax,%ax
80102719:	66 90                	xchg   %ax,%ax
8010271b:	66 90                	xchg   %ax,%ax
8010271d:	66 90                	xchg   %ax,%ax
8010271f:	90                   	nop

80102720 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102720:	a1 dc a1 14 80       	mov    0x8014a1dc,%eax
{
80102725:	55                   	push   %ebp
80102726:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102728:	85 c0                	test   %eax,%eax
8010272a:	0f 84 c8 00 00 00    	je     801027f8 <lapicinit+0xd8>
  lapic[index] = value;
80102730:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102737:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010273d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102744:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102747:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010274a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102751:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102754:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102757:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010275e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102761:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102764:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010276b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010276e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102771:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102778:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010277b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010277e:	8b 50 30             	mov    0x30(%eax),%edx
80102781:	c1 ea 10             	shr    $0x10,%edx
80102784:	80 fa 03             	cmp    $0x3,%dl
80102787:	77 77                	ja     80102800 <lapicinit+0xe0>
  lapic[index] = value;
80102789:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102790:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102793:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102796:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010279d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027b0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027b7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027bd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801027c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801027d1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801027d4:	8b 50 20             	mov    0x20(%eax),%edx
801027d7:	89 f6                	mov    %esi,%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801027e0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027e6:	80 e6 10             	and    $0x10,%dh
801027e9:	75 f5                	jne    801027e0 <lapicinit+0xc0>
  lapic[index] = value;
801027eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027f2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027f8:	5d                   	pop    %ebp
801027f9:	c3                   	ret    
801027fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102800:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102807:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280a:	8b 50 20             	mov    0x20(%eax),%edx
8010280d:	e9 77 ff ff ff       	jmp    80102789 <lapicinit+0x69>
80102812:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <cpunum>:

int
cpunum(void)
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	56                   	push   %esi
80102824:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102825:	9c                   	pushf  
80102826:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102827:	f6 c4 02             	test   $0x2,%ah
8010282a:	74 12                	je     8010283e <cpunum+0x1e>
    static int n;
    if(n++ == 0)
8010282c:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80102831:	8d 50 01             	lea    0x1(%eax),%edx
80102834:	85 c0                	test   %eax,%eax
80102836:	89 15 b8 b5 10 80    	mov    %edx,0x8010b5b8
8010283c:	74 62                	je     801028a0 <cpunum+0x80>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
8010283e:	a1 dc a1 14 80       	mov    0x8014a1dc,%eax
80102843:	85 c0                	test   %eax,%eax
80102845:	74 49                	je     80102890 <cpunum+0x70>
    return 0;

  apicid = lapic[ID] >> 24;
80102847:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010284a:	8b 35 c0 a8 14 80    	mov    0x8014a8c0,%esi
  apicid = lapic[ID] >> 24;
80102850:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102853:	85 f6                	test   %esi,%esi
80102855:	7e 5e                	jle    801028b5 <cpunum+0x95>
    if (cpus[i].apicid == apicid)
80102857:	0f b6 05 e0 a2 14 80 	movzbl 0x8014a2e0,%eax
8010285e:	39 c3                	cmp    %eax,%ebx
80102860:	74 2e                	je     80102890 <cpunum+0x70>
80102862:	ba 9c a3 14 80       	mov    $0x8014a39c,%edx
  for (i = 0; i < ncpu; ++i) {
80102867:	31 c0                	xor    %eax,%eax
80102869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102870:	83 c0 01             	add    $0x1,%eax
80102873:	39 f0                	cmp    %esi,%eax
80102875:	74 3e                	je     801028b5 <cpunum+0x95>
    if (cpus[i].apicid == apicid)
80102877:	0f b6 0a             	movzbl (%edx),%ecx
8010287a:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102880:	39 d9                	cmp    %ebx,%ecx
80102882:	75 ec                	jne    80102870 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102884:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102887:	5b                   	pop    %ebx
80102888:	5e                   	pop    %esi
80102889:	5d                   	pop    %ebp
8010288a:	c3                   	ret    
8010288b:	90                   	nop
8010288c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102890:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80102893:	31 c0                	xor    %eax,%eax
}
80102895:	5b                   	pop    %ebx
80102896:	5e                   	pop    %esi
80102897:	5d                   	pop    %ebp
80102898:	c3                   	ret    
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("cpu called from %x with interrupts enabled\n",
801028a0:	83 ec 08             	sub    $0x8,%esp
801028a3:	ff 75 04             	pushl  0x4(%ebp)
801028a6:	68 e0 7d 10 80       	push   $0x80107de0
801028ab:	e8 90 dd ff ff       	call   80100640 <cprintf>
801028b0:	83 c4 10             	add    $0x10,%esp
801028b3:	eb 89                	jmp    8010283e <cpunum+0x1e>
  panic("unknown apicid\n");
801028b5:	83 ec 0c             	sub    $0xc,%esp
801028b8:	68 0c 7e 10 80       	push   $0x80107e0c
801028bd:	e8 ae da ff ff       	call   80100370 <panic>
801028c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028d0:	a1 dc a1 14 80       	mov    0x8014a1dc,%eax
{
801028d5:	55                   	push   %ebp
801028d6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801028d8:	85 c0                	test   %eax,%eax
801028da:	74 0d                	je     801028e9 <lapiceoi+0x19>
  lapic[index] = value;
801028dc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028e9:	5d                   	pop    %ebp
801028ea:	c3                   	ret    
801028eb:	90                   	nop
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
}
801028f3:	5d                   	pop    %ebp
801028f4:	c3                   	ret    
801028f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102900 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102900:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102901:	b8 0f 00 00 00       	mov    $0xf,%eax
80102906:	ba 70 00 00 00       	mov    $0x70,%edx
8010290b:	89 e5                	mov    %esp,%ebp
8010290d:	53                   	push   %ebx
8010290e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102911:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102914:	ee                   	out    %al,(%dx)
80102915:	b8 0a 00 00 00       	mov    $0xa,%eax
8010291a:	ba 71 00 00 00       	mov    $0x71,%edx
8010291f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102920:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102922:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102925:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010292b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010292d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102930:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102933:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102935:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102938:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010293e:	a1 dc a1 14 80       	mov    0x8014a1dc,%eax
80102943:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102949:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010294c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102953:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102956:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102959:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102960:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102963:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102966:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010296c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102975:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102978:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010297e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102981:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102987:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010298a:	5b                   	pop    %ebx
8010298b:	5d                   	pop    %ebp
8010298c:	c3                   	ret    
8010298d:	8d 76 00             	lea    0x0(%esi),%esi

80102990 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102990:	55                   	push   %ebp
80102991:	b8 0b 00 00 00       	mov    $0xb,%eax
80102996:	ba 70 00 00 00       	mov    $0x70,%edx
8010299b:	89 e5                	mov    %esp,%ebp
8010299d:	57                   	push   %edi
8010299e:	56                   	push   %esi
8010299f:	53                   	push   %ebx
801029a0:	83 ec 4c             	sub    $0x4c,%esp
801029a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a4:	ba 71 00 00 00       	mov    $0x71,%edx
801029a9:	ec                   	in     (%dx),%al
801029aa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ad:	bb 70 00 00 00       	mov    $0x70,%ebx
801029b2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029b5:	8d 76 00             	lea    0x0(%esi),%esi
801029b8:	31 c0                	xor    %eax,%eax
801029ba:	89 da                	mov    %ebx,%edx
801029bc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029bd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029c2:	89 ca                	mov    %ecx,%edx
801029c4:	ec                   	in     (%dx),%al
801029c5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c8:	89 da                	mov    %ebx,%edx
801029ca:	b8 02 00 00 00       	mov    $0x2,%eax
801029cf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d0:	89 ca                	mov    %ecx,%edx
801029d2:	ec                   	in     (%dx),%al
801029d3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d6:	89 da                	mov    %ebx,%edx
801029d8:	b8 04 00 00 00       	mov    $0x4,%eax
801029dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029de:	89 ca                	mov    %ecx,%edx
801029e0:	ec                   	in     (%dx),%al
801029e1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e4:	89 da                	mov    %ebx,%edx
801029e6:	b8 07 00 00 00       	mov    $0x7,%eax
801029eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ec:	89 ca                	mov    %ecx,%edx
801029ee:	ec                   	in     (%dx),%al
801029ef:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f2:	89 da                	mov    %ebx,%edx
801029f4:	b8 08 00 00 00       	mov    $0x8,%eax
801029f9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fa:	89 ca                	mov    %ecx,%edx
801029fc:	ec                   	in     (%dx),%al
801029fd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ff:	89 da                	mov    %ebx,%edx
80102a01:	b8 09 00 00 00       	mov    $0x9,%eax
80102a06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a07:	89 ca                	mov    %ecx,%edx
80102a09:	ec                   	in     (%dx),%al
80102a0a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0c:	89 da                	mov    %ebx,%edx
80102a0e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a14:	89 ca                	mov    %ecx,%edx
80102a16:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a17:	84 c0                	test   %al,%al
80102a19:	78 9d                	js     801029b8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a1b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a1f:	89 fa                	mov    %edi,%edx
80102a21:	0f b6 fa             	movzbl %dl,%edi
80102a24:	89 f2                	mov    %esi,%edx
80102a26:	0f b6 f2             	movzbl %dl,%esi
80102a29:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2c:	89 da                	mov    %ebx,%edx
80102a2e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a31:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a34:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a38:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a3b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a3f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a42:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a49:	31 c0                	xor    %eax,%eax
80102a4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4c:	89 ca                	mov    %ecx,%edx
80102a4e:	ec                   	in     (%dx),%al
80102a4f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a52:	89 da                	mov    %ebx,%edx
80102a54:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a57:	b8 02 00 00 00       	mov    $0x2,%eax
80102a5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5d:	89 ca                	mov    %ecx,%edx
80102a5f:	ec                   	in     (%dx),%al
80102a60:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a63:	89 da                	mov    %ebx,%edx
80102a65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a68:	b8 04 00 00 00       	mov    $0x4,%eax
80102a6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6e:	89 ca                	mov    %ecx,%edx
80102a70:	ec                   	in     (%dx),%al
80102a71:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a74:	89 da                	mov    %ebx,%edx
80102a76:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a79:	b8 07 00 00 00       	mov    $0x7,%eax
80102a7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7f:	89 ca                	mov    %ecx,%edx
80102a81:	ec                   	in     (%dx),%al
80102a82:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a85:	89 da                	mov    %ebx,%edx
80102a87:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a8a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a90:	89 ca                	mov    %ecx,%edx
80102a92:	ec                   	in     (%dx),%al
80102a93:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a96:	89 da                	mov    %ebx,%edx
80102a98:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a9b:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa1:	89 ca                	mov    %ecx,%edx
80102aa3:	ec                   	in     (%dx),%al
80102aa4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aa7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aaa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aad:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ab0:	6a 18                	push   $0x18
80102ab2:	50                   	push   %eax
80102ab3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ab6:	50                   	push   %eax
80102ab7:	e8 74 1f 00 00       	call   80104a30 <memcmp>
80102abc:	83 c4 10             	add    $0x10,%esp
80102abf:	85 c0                	test   %eax,%eax
80102ac1:	0f 85 f1 fe ff ff    	jne    801029b8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ac7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102acb:	75 78                	jne    80102b45 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102acd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ad0:	89 c2                	mov    %eax,%edx
80102ad2:	83 e0 0f             	and    $0xf,%eax
80102ad5:	c1 ea 04             	shr    $0x4,%edx
80102ad8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102adb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ade:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ae1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ae4:	89 c2                	mov    %eax,%edx
80102ae6:	83 e0 0f             	and    $0xf,%eax
80102ae9:	c1 ea 04             	shr    $0x4,%edx
80102aec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102af5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102af8:	89 c2                	mov    %eax,%edx
80102afa:	83 e0 0f             	and    $0xf,%eax
80102afd:	c1 ea 04             	shr    $0x4,%edx
80102b00:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b03:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b06:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b0c:	89 c2                	mov    %eax,%edx
80102b0e:	83 e0 0f             	and    $0xf,%eax
80102b11:	c1 ea 04             	shr    $0x4,%edx
80102b14:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b17:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b20:	89 c2                	mov    %eax,%edx
80102b22:	83 e0 0f             	and    $0xf,%eax
80102b25:	c1 ea 04             	shr    $0x4,%edx
80102b28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b31:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b34:	89 c2                	mov    %eax,%edx
80102b36:	83 e0 0f             	and    $0xf,%eax
80102b39:	c1 ea 04             	shr    $0x4,%edx
80102b3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b42:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b45:	8b 75 08             	mov    0x8(%ebp),%esi
80102b48:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b4b:	89 06                	mov    %eax,(%esi)
80102b4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b50:	89 46 04             	mov    %eax,0x4(%esi)
80102b53:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b56:	89 46 08             	mov    %eax,0x8(%esi)
80102b59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b62:	89 46 10             	mov    %eax,0x10(%esi)
80102b65:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b68:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b6b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b75:	5b                   	pop    %ebx
80102b76:	5e                   	pop    %esi
80102b77:	5f                   	pop    %edi
80102b78:	5d                   	pop    %ebp
80102b79:	c3                   	ret    
80102b7a:	66 90                	xchg   %ax,%ax
80102b7c:	66 90                	xchg   %ax,%ax
80102b7e:	66 90                	xchg   %ax,%ax

80102b80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b80:	8b 0d 28 a2 14 80    	mov    0x8014a228,%ecx
80102b86:	85 c9                	test   %ecx,%ecx
80102b88:	0f 8e 8a 00 00 00    	jle    80102c18 <install_trans+0x98>
{
80102b8e:	55                   	push   %ebp
80102b8f:	89 e5                	mov    %esp,%ebp
80102b91:	57                   	push   %edi
80102b92:	56                   	push   %esi
80102b93:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b94:	31 db                	xor    %ebx,%ebx
{
80102b96:	83 ec 0c             	sub    $0xc,%esp
80102b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ba0:	a1 14 a2 14 80       	mov    0x8014a214,%eax
80102ba5:	83 ec 08             	sub    $0x8,%esp
80102ba8:	01 d8                	add    %ebx,%eax
80102baa:	83 c0 01             	add    $0x1,%eax
80102bad:	50                   	push   %eax
80102bae:	ff 35 24 a2 14 80    	pushl  0x8014a224
80102bb4:	e8 07 d5 ff ff       	call   801000c0 <bread>
80102bb9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bbb:	58                   	pop    %eax
80102bbc:	5a                   	pop    %edx
80102bbd:	ff 34 9d 2c a2 14 80 	pushl  -0x7feb5dd4(,%ebx,4)
80102bc4:	ff 35 24 a2 14 80    	pushl  0x8014a224
  for (tail = 0; tail < log.lh.n; tail++) {
80102bca:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcd:	e8 ee d4 ff ff       	call   801000c0 <bread>
80102bd2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bd4:	8d 47 18             	lea    0x18(%edi),%eax
80102bd7:	83 c4 0c             	add    $0xc,%esp
80102bda:	68 00 02 00 00       	push   $0x200
80102bdf:	50                   	push   %eax
80102be0:	8d 46 18             	lea    0x18(%esi),%eax
80102be3:	50                   	push   %eax
80102be4:	e8 a7 1e 00 00       	call   80104a90 <memmove>
    bwrite(dbuf);  // write dst to disk
80102be9:	89 34 24             	mov    %esi,(%esp)
80102bec:	e8 af d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102bf1:	89 3c 24             	mov    %edi,(%esp)
80102bf4:	e8 d7 d5 ff ff       	call   801001d0 <brelse>
    brelse(dbuf);
80102bf9:	89 34 24             	mov    %esi,(%esp)
80102bfc:	e8 cf d5 ff ff       	call   801001d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	39 1d 28 a2 14 80    	cmp    %ebx,0x8014a228
80102c0a:	7f 94                	jg     80102ba0 <install_trans+0x20>
  }
}
80102c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c0f:	5b                   	pop    %ebx
80102c10:	5e                   	pop    %esi
80102c11:	5f                   	pop    %edi
80102c12:	5d                   	pop    %ebp
80102c13:	c3                   	ret    
80102c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c18:	f3 c3                	repz ret 
80102c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	53                   	push   %ebx
80102c24:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c27:	ff 35 14 a2 14 80    	pushl  0x8014a214
80102c2d:	ff 35 24 a2 14 80    	pushl  0x8014a224
80102c33:	e8 88 d4 ff ff       	call   801000c0 <bread>
80102c38:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c3a:	a1 28 a2 14 80       	mov    0x8014a228,%eax
  for (i = 0; i < log.lh.n; i++) {
80102c3f:	83 c4 10             	add    $0x10,%esp
  hb->n = log.lh.n;
80102c42:	89 43 18             	mov    %eax,0x18(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c45:	a1 28 a2 14 80       	mov    0x8014a228,%eax
80102c4a:	85 c0                	test   %eax,%eax
80102c4c:	7e 18                	jle    80102c66 <write_head+0x46>
80102c4e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102c50:	8b 0c 95 2c a2 14 80 	mov    -0x7feb5dd4(,%edx,4),%ecx
80102c57:	89 4c 93 1c          	mov    %ecx,0x1c(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c5b:	83 c2 01             	add    $0x1,%edx
80102c5e:	39 15 28 a2 14 80    	cmp    %edx,0x8014a228
80102c64:	7f ea                	jg     80102c50 <write_head+0x30>
  }
  bwrite(buf);
80102c66:	83 ec 0c             	sub    $0xc,%esp
80102c69:	53                   	push   %ebx
80102c6a:	e8 31 d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102c6f:	89 1c 24             	mov    %ebx,(%esp)
80102c72:	e8 59 d5 ff ff       	call   801001d0 <brelse>
}
80102c77:	83 c4 10             	add    $0x10,%esp
80102c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c7d:	c9                   	leave  
80102c7e:	c3                   	ret    
80102c7f:	90                   	nop

80102c80 <initlog>:
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	53                   	push   %ebx
80102c84:	83 ec 2c             	sub    $0x2c,%esp
80102c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c8a:	68 1c 7e 10 80       	push   $0x80107e1c
80102c8f:	68 e0 a1 14 80       	push   $0x8014a1e0
80102c94:	e8 87 18 00 00       	call   80104520 <initlock>
  readsb(dev, &sb);
80102c99:	58                   	pop    %eax
80102c9a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c9d:	5a                   	pop    %edx
80102c9e:	50                   	push   %eax
80102c9f:	53                   	push   %ebx
80102ca0:	e8 db e6 ff ff       	call   80101380 <readsb>
  log.size = sb.nlog;
80102ca5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cab:	59                   	pop    %ecx
  log.dev = dev;
80102cac:	89 1d 24 a2 14 80    	mov    %ebx,0x8014a224
  log.size = sb.nlog;
80102cb2:	89 15 18 a2 14 80    	mov    %edx,0x8014a218
  log.start = sb.logstart;
80102cb8:	a3 14 a2 14 80       	mov    %eax,0x8014a214
  struct buf *buf = bread(log.dev, log.start);
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 fb d3 ff ff       	call   801000c0 <bread>
  log.lh.n = lh->n;
80102cc5:	8b 58 18             	mov    0x18(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102cc8:	83 c4 10             	add    $0x10,%esp
80102ccb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102ccd:	89 1d 28 a2 14 80    	mov    %ebx,0x8014a228
  for (i = 0; i < log.lh.n; i++) {
80102cd3:	7e 1c                	jle    80102cf1 <initlog+0x71>
80102cd5:	c1 e3 02             	shl    $0x2,%ebx
80102cd8:	31 d2                	xor    %edx,%edx
80102cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102ce0:	8b 4c 10 1c          	mov    0x1c(%eax,%edx,1),%ecx
80102ce4:	83 c2 04             	add    $0x4,%edx
80102ce7:	89 8a 28 a2 14 80    	mov    %ecx,-0x7feb5dd8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102ced:	39 d3                	cmp    %edx,%ebx
80102cef:	75 ef                	jne    80102ce0 <initlog+0x60>
  brelse(buf);
80102cf1:	83 ec 0c             	sub    $0xc,%esp
80102cf4:	50                   	push   %eax
80102cf5:	e8 d6 d4 ff ff       	call   801001d0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102cfa:	e8 81 fe ff ff       	call   80102b80 <install_trans>
  log.lh.n = 0;
80102cff:	c7 05 28 a2 14 80 00 	movl   $0x0,0x8014a228
80102d06:	00 00 00 
  write_head(); // clear the log
80102d09:	e8 12 ff ff ff       	call   80102c20 <write_head>
}
80102d0e:	83 c4 10             	add    $0x10,%esp
80102d11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d14:	c9                   	leave  
80102d15:	c3                   	ret    
80102d16:	8d 76 00             	lea    0x0(%esi),%esi
80102d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d26:	68 e0 a1 14 80       	push   $0x8014a1e0
80102d2b:	e8 10 18 00 00       	call   80104540 <acquire>
80102d30:	83 c4 10             	add    $0x10,%esp
80102d33:	eb 18                	jmp    80102d4d <begin_op+0x2d>
80102d35:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d38:	83 ec 08             	sub    $0x8,%esp
80102d3b:	68 e0 a1 14 80       	push   $0x8014a1e0
80102d40:	68 e0 a1 14 80       	push   $0x8014a1e0
80102d45:	e8 66 12 00 00       	call   80103fb0 <sleep>
80102d4a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d4d:	a1 20 a2 14 80       	mov    0x8014a220,%eax
80102d52:	85 c0                	test   %eax,%eax
80102d54:	75 e2                	jne    80102d38 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d56:	a1 1c a2 14 80       	mov    0x8014a21c,%eax
80102d5b:	8b 15 28 a2 14 80    	mov    0x8014a228,%edx
80102d61:	83 c0 01             	add    $0x1,%eax
80102d64:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d67:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d6a:	83 fa 1e             	cmp    $0x1e,%edx
80102d6d:	7f c9                	jg     80102d38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d6f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d72:	a3 1c a2 14 80       	mov    %eax,0x8014a21c
      release(&log.lock);
80102d77:	68 e0 a1 14 80       	push   $0x8014a1e0
80102d7c:	e8 7f 19 00 00       	call   80104700 <release>
      break;
    }
  }
}
80102d81:	83 c4 10             	add    $0x10,%esp
80102d84:	c9                   	leave  
80102d85:	c3                   	ret    
80102d86:	8d 76 00             	lea    0x0(%esi),%esi
80102d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	57                   	push   %edi
80102d94:	56                   	push   %esi
80102d95:	53                   	push   %ebx
80102d96:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d99:	68 e0 a1 14 80       	push   $0x8014a1e0
80102d9e:	e8 9d 17 00 00       	call   80104540 <acquire>
  log.outstanding -= 1;
80102da3:	a1 1c a2 14 80       	mov    0x8014a21c,%eax
  if(log.committing)
80102da8:	8b 35 20 a2 14 80    	mov    0x8014a220,%esi
80102dae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102db1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102db4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102db6:	89 1d 1c a2 14 80    	mov    %ebx,0x8014a21c
  if(log.committing)
80102dbc:	0f 85 1a 01 00 00    	jne    80102edc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102dc2:	85 db                	test   %ebx,%ebx
80102dc4:	0f 85 ee 00 00 00    	jne    80102eb8 <end_op+0x128>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102dca:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102dcd:	c7 05 20 a2 14 80 01 	movl   $0x1,0x8014a220
80102dd4:	00 00 00 
  release(&log.lock);
80102dd7:	68 e0 a1 14 80       	push   $0x8014a1e0
80102ddc:	e8 1f 19 00 00       	call   80104700 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102de1:	8b 0d 28 a2 14 80    	mov    0x8014a228,%ecx
80102de7:	83 c4 10             	add    $0x10,%esp
80102dea:	85 c9                	test   %ecx,%ecx
80102dec:	0f 8e 85 00 00 00    	jle    80102e77 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102df2:	a1 14 a2 14 80       	mov    0x8014a214,%eax
80102df7:	83 ec 08             	sub    $0x8,%esp
80102dfa:	01 d8                	add    %ebx,%eax
80102dfc:	83 c0 01             	add    $0x1,%eax
80102dff:	50                   	push   %eax
80102e00:	ff 35 24 a2 14 80    	pushl  0x8014a224
80102e06:	e8 b5 d2 ff ff       	call   801000c0 <bread>
80102e0b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e0d:	58                   	pop    %eax
80102e0e:	5a                   	pop    %edx
80102e0f:	ff 34 9d 2c a2 14 80 	pushl  -0x7feb5dd4(,%ebx,4)
80102e16:	ff 35 24 a2 14 80    	pushl  0x8014a224
  for (tail = 0; tail < log.lh.n; tail++) {
80102e1c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e1f:	e8 9c d2 ff ff       	call   801000c0 <bread>
80102e24:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e26:	8d 40 18             	lea    0x18(%eax),%eax
80102e29:	83 c4 0c             	add    $0xc,%esp
80102e2c:	68 00 02 00 00       	push   $0x200
80102e31:	50                   	push   %eax
80102e32:	8d 46 18             	lea    0x18(%esi),%eax
80102e35:	50                   	push   %eax
80102e36:	e8 55 1c 00 00       	call   80104a90 <memmove>
    bwrite(to);  // write the log
80102e3b:	89 34 24             	mov    %esi,(%esp)
80102e3e:	e8 5d d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102e43:	89 3c 24             	mov    %edi,(%esp)
80102e46:	e8 85 d3 ff ff       	call   801001d0 <brelse>
    brelse(to);
80102e4b:	89 34 24             	mov    %esi,(%esp)
80102e4e:	e8 7d d3 ff ff       	call   801001d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e53:	83 c4 10             	add    $0x10,%esp
80102e56:	3b 1d 28 a2 14 80    	cmp    0x8014a228,%ebx
80102e5c:	7c 94                	jl     80102df2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e5e:	e8 bd fd ff ff       	call   80102c20 <write_head>
    install_trans(); // Now install writes to home locations
80102e63:	e8 18 fd ff ff       	call   80102b80 <install_trans>
    log.lh.n = 0;
80102e68:	c7 05 28 a2 14 80 00 	movl   $0x0,0x8014a228
80102e6f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e72:	e8 a9 fd ff ff       	call   80102c20 <write_head>
    acquire(&log.lock);
80102e77:	83 ec 0c             	sub    $0xc,%esp
80102e7a:	68 e0 a1 14 80       	push   $0x8014a1e0
80102e7f:	e8 bc 16 00 00       	call   80104540 <acquire>
    wakeup(&log);
80102e84:	c7 04 24 e0 a1 14 80 	movl   $0x8014a1e0,(%esp)
    log.committing = 0;
80102e8b:	c7 05 20 a2 14 80 00 	movl   $0x0,0x8014a220
80102e92:	00 00 00 
    wakeup(&log);
80102e95:	e8 c6 12 00 00       	call   80104160 <wakeup>
    release(&log.lock);
80102e9a:	c7 04 24 e0 a1 14 80 	movl   $0x8014a1e0,(%esp)
80102ea1:	e8 5a 18 00 00       	call   80104700 <release>
80102ea6:	83 c4 10             	add    $0x10,%esp
}
80102ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eac:	5b                   	pop    %ebx
80102ead:	5e                   	pop    %esi
80102eae:	5f                   	pop    %edi
80102eaf:	5d                   	pop    %ebp
80102eb0:	c3                   	ret    
80102eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102eb8:	83 ec 0c             	sub    $0xc,%esp
80102ebb:	68 e0 a1 14 80       	push   $0x8014a1e0
80102ec0:	e8 9b 12 00 00       	call   80104160 <wakeup>
  release(&log.lock);
80102ec5:	c7 04 24 e0 a1 14 80 	movl   $0x8014a1e0,(%esp)
80102ecc:	e8 2f 18 00 00       	call   80104700 <release>
80102ed1:	83 c4 10             	add    $0x10,%esp
}
80102ed4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ed7:	5b                   	pop    %ebx
80102ed8:	5e                   	pop    %esi
80102ed9:	5f                   	pop    %edi
80102eda:	5d                   	pop    %ebp
80102edb:	c3                   	ret    
    panic("log.committing");
80102edc:	83 ec 0c             	sub    $0xc,%esp
80102edf:	68 20 7e 10 80       	push   $0x80107e20
80102ee4:	e8 87 d4 ff ff       	call   80100370 <panic>
80102ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ef0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	53                   	push   %ebx
80102ef4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ef7:	8b 15 28 a2 14 80    	mov    0x8014a228,%edx
{
80102efd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f00:	83 fa 1d             	cmp    $0x1d,%edx
80102f03:	0f 8f 9d 00 00 00    	jg     80102fa6 <log_write+0xb6>
80102f09:	a1 18 a2 14 80       	mov    0x8014a218,%eax
80102f0e:	83 e8 01             	sub    $0x1,%eax
80102f11:	39 c2                	cmp    %eax,%edx
80102f13:	0f 8d 8d 00 00 00    	jge    80102fa6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f19:	a1 1c a2 14 80       	mov    0x8014a21c,%eax
80102f1e:	85 c0                	test   %eax,%eax
80102f20:	0f 8e 8d 00 00 00    	jle    80102fb3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f26:	83 ec 0c             	sub    $0xc,%esp
80102f29:	68 e0 a1 14 80       	push   $0x8014a1e0
80102f2e:	e8 0d 16 00 00       	call   80104540 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f33:	8b 0d 28 a2 14 80    	mov    0x8014a228,%ecx
80102f39:	83 c4 10             	add    $0x10,%esp
80102f3c:	83 f9 00             	cmp    $0x0,%ecx
80102f3f:	7e 57                	jle    80102f98 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f41:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102f44:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f46:	3b 15 2c a2 14 80    	cmp    0x8014a22c,%edx
80102f4c:	75 0b                	jne    80102f59 <log_write+0x69>
80102f4e:	eb 38                	jmp    80102f88 <log_write+0x98>
80102f50:	39 14 85 2c a2 14 80 	cmp    %edx,-0x7feb5dd4(,%eax,4)
80102f57:	74 2f                	je     80102f88 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f59:	83 c0 01             	add    $0x1,%eax
80102f5c:	39 c1                	cmp    %eax,%ecx
80102f5e:	75 f0                	jne    80102f50 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f60:	89 14 85 2c a2 14 80 	mov    %edx,-0x7feb5dd4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f67:	83 c0 01             	add    $0x1,%eax
80102f6a:	a3 28 a2 14 80       	mov    %eax,0x8014a228
  b->flags |= B_DIRTY; // prevent eviction
80102f6f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102f72:	c7 45 08 e0 a1 14 80 	movl   $0x8014a1e0,0x8(%ebp)
}
80102f79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f7c:	c9                   	leave  
  release(&log.lock);
80102f7d:	e9 7e 17 00 00       	jmp    80104700 <release>
80102f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102f88:	89 14 85 2c a2 14 80 	mov    %edx,-0x7feb5dd4(,%eax,4)
80102f8f:	eb de                	jmp    80102f6f <log_write+0x7f>
80102f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f98:	8b 43 08             	mov    0x8(%ebx),%eax
80102f9b:	a3 2c a2 14 80       	mov    %eax,0x8014a22c
  if (i == log.lh.n)
80102fa0:	75 cd                	jne    80102f6f <log_write+0x7f>
80102fa2:	31 c0                	xor    %eax,%eax
80102fa4:	eb c1                	jmp    80102f67 <log_write+0x77>
    panic("too big a transaction");
80102fa6:	83 ec 0c             	sub    $0xc,%esp
80102fa9:	68 2f 7e 10 80       	push   $0x80107e2f
80102fae:	e8 bd d3 ff ff       	call   80100370 <panic>
    panic("log_write outside of trans");
80102fb3:	83 ec 0c             	sub    $0xc,%esp
80102fb6:	68 45 7e 10 80       	push   $0x80107e45
80102fbb:	e8 b0 d3 ff ff       	call   80100370 <panic>

80102fc0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102fc6:	e8 55 f8 ff ff       	call   80102820 <cpunum>
80102fcb:	83 ec 08             	sub    $0x8,%esp
80102fce:	50                   	push   %eax
80102fcf:	68 60 7e 10 80       	push   $0x80107e60
80102fd4:	e8 67 d6 ff ff       	call   80100640 <cprintf>
  idtinit();       // load idt register
80102fd9:	e8 d2 2d 00 00       	call   80105db0 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102fde:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102fe5:	b8 01 00 00 00       	mov    $0x1,%eax
80102fea:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102ff1:	e8 ba 0c 00 00       	call   80103cb0 <scheduler>
80102ff6:	8d 76 00             	lea    0x0(%esi),%esi
80102ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103000 <mpenter>:
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103006:	e8 75 3f 00 00       	call   80106f80 <switchkvm>
  seginit();
8010300b:	e8 00 3e 00 00       	call   80106e10 <seginit>
  lapicinit();
80103010:	e8 0b f7 ff ff       	call   80102720 <lapicinit>
  mpmain();
80103015:	e8 a6 ff ff ff       	call   80102fc0 <mpmain>
8010301a:	66 90                	xchg   %ax,%ax
8010301c:	66 90                	xchg   %ax,%ax
8010301e:	66 90                	xchg   %ax,%ax

80103020 <main>:
{
80103020:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103024:	83 e4 f0             	and    $0xfffffff0,%esp
80103027:	ff 71 fc             	pushl  -0x4(%ecx)
8010302a:	55                   	push   %ebp
8010302b:	89 e5                	mov    %esp,%ebp
8010302d:	53                   	push   %ebx
8010302e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010302f:	83 ec 08             	sub    $0x8,%esp
80103032:	68 00 00 40 80       	push   $0x80400000
80103037:	68 00 fb 14 80       	push   $0x8014fb00
8010303c:	e8 ef f3 ff ff       	call   80102430 <kinit1>
  kvmalloc();      // kernel page table
80103041:	e8 1a 3f 00 00       	call   80106f60 <kvmalloc>
  mpinit();        // detect other processors
80103046:	e8 c5 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010304b:	e8 d0 f6 ff ff       	call   80102720 <lapicinit>
  seginit();       // segment descriptors
80103050:	e8 bb 3d 00 00       	call   80106e10 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80103055:	e8 c6 f7 ff ff       	call   80102820 <cpunum>
8010305a:	5a                   	pop    %edx
8010305b:	59                   	pop    %ecx
8010305c:	50                   	push   %eax
8010305d:	68 71 7e 10 80       	push   $0x80107e71
80103062:	e8 d9 d5 ff ff       	call   80100640 <cprintf>
  picinit();       // another interrupt controller
80103067:	e8 c4 03 00 00       	call   80103430 <picinit>
  ioapicinit();    // another interrupt controller
8010306c:	e8 7f f1 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80103071:	e8 2a d9 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103076:	e8 75 30 00 00       	call   801060f0 <uartinit>
  pinit();         // process table
8010307b:	e8 60 09 00 00       	call   801039e0 <pinit>
  tvinit();        // trap vectors
80103080:	e8 ab 2c 00 00       	call   80105d30 <tvinit>
  binit();         // buffer cache
80103085:	e8 b6 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010308a:	e8 a1 dc ff ff       	call   80100d30 <fileinit>
  ideinit();       // disk
8010308f:	e8 3c ef ff ff       	call   80101fd0 <ideinit>
  if(!ismp)
80103094:	8b 1d c4 a2 14 80    	mov    0x8014a2c4,%ebx
8010309a:	83 c4 10             	add    $0x10,%esp
8010309d:	85 db                	test   %ebx,%ebx
8010309f:	0f 84 d4 00 00 00    	je     80103179 <main+0x159>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030a5:	83 ec 04             	sub    $0x4,%esp
801030a8:	68 8a 00 00 00       	push   $0x8a
801030ad:	68 8c b4 10 80       	push   $0x8010b48c
801030b2:	68 00 70 00 80       	push   $0x80007000
801030b7:	e8 d4 19 00 00       	call   80104a90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030bc:	69 05 c0 a8 14 80 bc 	imul   $0xbc,0x8014a8c0,%eax
801030c3:	00 00 00 
801030c6:	83 c4 10             	add    $0x10,%esp
801030c9:	05 e0 a2 14 80       	add    $0x8014a2e0,%eax
801030ce:	3d e0 a2 14 80       	cmp    $0x8014a2e0,%eax
801030d3:	76 7e                	jbe    80103153 <main+0x133>
801030d5:	bb e0 a2 14 80       	mov    $0x8014a2e0,%ebx
801030da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(c == cpus+cpunum())  // We've started already.
801030e0:	e8 3b f7 ff ff       	call   80102820 <cpunum>
801030e5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801030eb:	05 e0 a2 14 80       	add    $0x8014a2e0,%eax
801030f0:	39 c3                	cmp    %eax,%ebx
801030f2:	74 46                	je     8010313a <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030f4:	e8 07 f4 ff ff       	call   80102500 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030f9:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-4) = stack + KSTACKSIZE;
801030fc:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103101:	c7 05 f8 6f 00 80 00 	movl   $0x80103000,0x80006ff8
80103108:	30 10 80 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010310b:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103110:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103117:	a0 10 00 
    lapicstartap(c->apicid, V2P(code));
8010311a:	68 00 70 00 00       	push   $0x7000
8010311f:	0f b6 03             	movzbl (%ebx),%eax
80103122:	50                   	push   %eax
80103123:	e8 d8 f7 ff ff       	call   80102900 <lapicstartap>
80103128:	83 c4 10             	add    $0x10,%esp
8010312b:	90                   	nop
8010312c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103130:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80103136:	85 c0                	test   %eax,%eax
80103138:	74 f6                	je     80103130 <main+0x110>
  for(c = cpus; c < cpus+ncpu; c++){
8010313a:	69 05 c0 a8 14 80 bc 	imul   $0xbc,0x8014a8c0,%eax
80103141:	00 00 00 
80103144:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
8010314a:	05 e0 a2 14 80       	add    $0x8014a2e0,%eax
8010314f:	39 c3                	cmp    %eax,%ebx
80103151:	72 8d                	jb     801030e0 <main+0xc0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103153:	83 ec 08             	sub    $0x8,%esp
80103156:	68 00 00 00 8e       	push   $0x8e000000
8010315b:	68 00 00 40 80       	push   $0x80400000
80103160:	e8 3b f3 ff ff       	call   801024a0 <kinit2>
  initsem();      //semaphor  ljn 在用户初始化之前 初始化信号量
80103165:	e8 e6 15 00 00       	call   80104750 <initsem>
  slab_init();    //init slab ljn 初始化slab
8010316a:	e8 e1 43 00 00       	call   80107550 <slab_init>
  userinit();      // first user process
8010316f:	e8 8c 08 00 00       	call   80103a00 <userinit>
  mpmain();        // finish this processor's setup
80103174:	e8 47 fe ff ff       	call   80102fc0 <mpmain>
    timerinit();   // uniprocessor timer
80103179:	e8 52 2b 00 00       	call   80105cd0 <timerinit>
8010317e:	e9 22 ff ff ff       	jmp    801030a5 <main+0x85>
80103183:	66 90                	xchg   %ax,%ax
80103185:	66 90                	xchg   %ax,%ax
80103187:	66 90                	xchg   %ax,%ax
80103189:	66 90                	xchg   %ax,%ax
8010318b:	66 90                	xchg   %ax,%ax
8010318d:	66 90                	xchg   %ax,%ax
8010318f:	90                   	nop

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	90                   	nop
801031a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031b0:	39 fb                	cmp    %edi,%ebx
801031b2:	89 fe                	mov    %edi,%esi
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 88 7e 10 80       	push   $0x80107e88
801031c3:	56                   	push   %esi
801031c4:	e8 67 18 00 00       	call   80104a30 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f1                	mov    %esi,%ecx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 11             	movzbl (%ecx),%edx
801031db:	83 c1 01             	add    $0x1,%ecx
801031de:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801031e0:	39 f9                	cmp    %edi,%ecx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	89 f0                	mov    %esi,%eax
801031ff:	5b                   	pop    %ebx
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010320a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	85 c0                	test   %eax,%eax
80103231:	75 1b                	jne    8010324e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103233:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010323a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103241:	c1 e0 08             	shl    $0x8,%eax
80103244:	09 d0                	or     %edx,%eax
80103246:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103249:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324e:	ba 00 04 00 00       	mov    $0x400,%edx
80103253:	e8 38 ff ff ff       	call   80103190 <mpsearch1>
80103258:	85 c0                	test   %eax,%eax
8010325a:	89 c7                	mov    %eax,%edi
8010325c:	0f 84 76 01 00 00    	je     801033d8 <mpinit+0x1c8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103262:	8b 5f 04             	mov    0x4(%edi),%ebx
80103265:	85 db                	test   %ebx,%ebx
80103267:	0f 84 e6 00 00 00    	je     80103353 <mpinit+0x143>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326d:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103273:	83 ec 04             	sub    $0x4,%esp
80103276:	6a 04                	push   $0x4
80103278:	68 8d 7e 10 80       	push   $0x80107e8d
8010327d:	56                   	push   %esi
8010327e:	e8 ad 17 00 00       	call   80104a30 <memcmp>
80103283:	83 c4 10             	add    $0x10,%esp
80103286:	85 c0                	test   %eax,%eax
80103288:	0f 85 c5 00 00 00    	jne    80103353 <mpinit+0x143>
  if(conf->version != 1 && conf->version != 4)
8010328e:	0f b6 93 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%edx
80103295:	80 fa 01             	cmp    $0x1,%dl
80103298:	0f 95 c1             	setne  %cl
8010329b:	80 fa 04             	cmp    $0x4,%dl
8010329e:	0f 95 c2             	setne  %dl
801032a1:	20 ca                	and    %cl,%dl
801032a3:	0f 85 aa 00 00 00    	jne    80103353 <mpinit+0x143>
  if(sum((uchar*)conf, conf->length) != 0)
801032a9:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
801032b0:	66 85 c9             	test   %cx,%cx
801032b3:	74 1f                	je     801032d4 <mpinit+0xc4>
801032b5:	01 f1                	add    %esi,%ecx
801032b7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032ba:	89 f2                	mov    %esi,%edx
801032bc:	89 cb                	mov    %ecx,%ebx
801032be:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801032c0:	0f b6 0a             	movzbl (%edx),%ecx
801032c3:	83 c2 01             	add    $0x1,%edx
801032c6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801032c8:	39 da                	cmp    %ebx,%edx
801032ca:	75 f4                	jne    801032c0 <mpinit+0xb0>
801032cc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801032cf:	84 c0                	test   %al,%al
801032d1:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801032d4:	85 f6                	test   %esi,%esi
801032d6:	74 7b                	je     80103353 <mpinit+0x143>
801032d8:	84 d2                	test   %dl,%dl
801032da:	75 77                	jne    80103353 <mpinit+0x143>
    return;
  ismp = 1;
801032dc:	c7 05 c4 a2 14 80 01 	movl   $0x1,0x8014a2c4
801032e3:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801032e6:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032ec:	a3 dc a1 14 80       	mov    %eax,0x8014a1dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f1:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801032f8:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032fe:	01 d6                	add    %edx,%esi
80103300:	39 f0                	cmp    %esi,%eax
80103302:	0f 83 a8 00 00 00    	jae    801033b0 <mpinit+0x1a0>
80103308:	90                   	nop
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103310:	80 38 04             	cmpb   $0x4,(%eax)
80103313:	0f 87 87 00 00 00    	ja     801033a0 <mpinit+0x190>
80103319:	0f b6 10             	movzbl (%eax),%edx
8010331c:	ff 24 95 94 7e 10 80 	jmp    *-0x7fef816c(,%edx,4)
80103323:	90                   	nop
80103324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103328:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010332b:	39 c6                	cmp    %eax,%esi
8010332d:	77 e1                	ja     80103310 <mpinit+0x100>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
8010332f:	a1 c4 a2 14 80       	mov    0x8014a2c4,%eax
80103334:	85 c0                	test   %eax,%eax
80103336:	75 78                	jne    801033b0 <mpinit+0x1a0>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103338:	c7 05 c0 a8 14 80 01 	movl   $0x1,0x8014a8c0
8010333f:	00 00 00 
    lapic = 0;
80103342:	c7 05 dc a1 14 80 00 	movl   $0x0,0x8014a1dc
80103349:	00 00 00 
    ioapicid = 0;
8010334c:	c6 05 c0 a2 14 80 00 	movb   $0x0,0x8014a2c0
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103353:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103356:	5b                   	pop    %ebx
80103357:	5e                   	pop    %esi
80103358:	5f                   	pop    %edi
80103359:	5d                   	pop    %ebp
8010335a:	c3                   	ret    
8010335b:	90                   	nop
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103360:	8b 15 c0 a8 14 80    	mov    0x8014a8c0,%edx
80103366:	83 fa 07             	cmp    $0x7,%edx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
8010336f:	69 da bc 00 00 00    	imul   $0xbc,%edx,%ebx
        ncpu++;
80103375:	83 c2 01             	add    $0x1,%edx
80103378:	89 15 c0 a8 14 80    	mov    %edx,0x8014a8c0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 8b e0 a2 14 80    	mov    %cl,-0x7feb5d20(%ebx)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	eb a2                	jmp    8010332b <mpinit+0x11b>
80103389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103390:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103394:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103397:	88 15 c0 a2 14 80    	mov    %dl,0x8014a2c0
      continue;
8010339d:	eb 8c                	jmp    8010332b <mpinit+0x11b>
8010339f:	90                   	nop
      ismp = 0;
801033a0:	c7 05 c4 a2 14 80 00 	movl   $0x0,0x8014a2c4
801033a7:	00 00 00 
      break;
801033aa:	e9 7c ff ff ff       	jmp    8010332b <mpinit+0x11b>
801033af:	90                   	nop
  if(mp->imcrp){
801033b0:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801033b4:	74 9d                	je     80103353 <mpinit+0x143>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033b6:	b8 70 00 00 00       	mov    $0x70,%eax
801033bb:	ba 22 00 00 00       	mov    $0x22,%edx
801033c0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033c1:	ba 23 00 00 00       	mov    $0x23,%edx
801033c6:	ec                   	in     (%dx),%al
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033c7:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ca:	ee                   	out    %al,(%dx)
}
801033cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ce:	5b                   	pop    %ebx
801033cf:	5e                   	pop    %esi
801033d0:	5f                   	pop    %edi
801033d1:	5d                   	pop    %ebp
801033d2:	c3                   	ret    
801033d3:	90                   	nop
801033d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033d8:	ba 00 00 01 00       	mov    $0x10000,%edx
801033dd:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033e2:	e8 a9 fd ff ff       	call   80103190 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033e7:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801033e9:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033eb:	0f 85 71 fe ff ff    	jne    80103262 <mpinit+0x52>
801033f1:	e9 5d ff ff ff       	jmp    80103353 <mpinit+0x143>
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103400:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103401:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103406:	ba 21 00 00 00       	mov    $0x21,%edx
{
8010340b:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010340d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103410:	d3 c0                	rol    %cl,%eax
80103412:	66 23 05 00 b0 10 80 	and    0x8010b000,%ax
  irqmask = mask;
80103419:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
8010341f:	ee                   	out    %al,(%dx)
80103420:	ba a1 00 00 00       	mov    $0xa1,%edx
  outb(IO_PIC2+1, mask >> 8);
80103425:	66 c1 e8 08          	shr    $0x8,%ax
80103429:	ee                   	out    %al,(%dx)
}
8010342a:	5d                   	pop    %ebp
8010342b:	c3                   	ret    
8010342c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103430 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103430:	55                   	push   %ebp
80103431:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103436:	89 e5                	mov    %esp,%ebp
80103438:	57                   	push   %edi
80103439:	56                   	push   %esi
8010343a:	53                   	push   %ebx
8010343b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103440:	89 da                	mov    %ebx,%edx
80103442:	ee                   	out    %al,(%dx)
80103443:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103448:	89 ca                	mov    %ecx,%edx
8010344a:	ee                   	out    %al,(%dx)
8010344b:	be 11 00 00 00       	mov    $0x11,%esi
80103450:	ba 20 00 00 00       	mov    $0x20,%edx
80103455:	89 f0                	mov    %esi,%eax
80103457:	ee                   	out    %al,(%dx)
80103458:	b8 20 00 00 00       	mov    $0x20,%eax
8010345d:	89 da                	mov    %ebx,%edx
8010345f:	ee                   	out    %al,(%dx)
80103460:	b8 04 00 00 00       	mov    $0x4,%eax
80103465:	ee                   	out    %al,(%dx)
80103466:	bf 03 00 00 00       	mov    $0x3,%edi
8010346b:	89 f8                	mov    %edi,%eax
8010346d:	ee                   	out    %al,(%dx)
8010346e:	ba a0 00 00 00       	mov    $0xa0,%edx
80103473:	89 f0                	mov    %esi,%eax
80103475:	ee                   	out    %al,(%dx)
80103476:	b8 28 00 00 00       	mov    $0x28,%eax
8010347b:	89 ca                	mov    %ecx,%edx
8010347d:	ee                   	out    %al,(%dx)
8010347e:	b8 02 00 00 00       	mov    $0x2,%eax
80103483:	ee                   	out    %al,(%dx)
80103484:	89 f8                	mov    %edi,%eax
80103486:	ee                   	out    %al,(%dx)
80103487:	bf 68 00 00 00       	mov    $0x68,%edi
8010348c:	ba 20 00 00 00       	mov    $0x20,%edx
80103491:	89 f8                	mov    %edi,%eax
80103493:	ee                   	out    %al,(%dx)
80103494:	be 0a 00 00 00       	mov    $0xa,%esi
80103499:	89 f0                	mov    %esi,%eax
8010349b:	ee                   	out    %al,(%dx)
8010349c:	ba a0 00 00 00       	mov    $0xa0,%edx
801034a1:	89 f8                	mov    %edi,%eax
801034a3:	ee                   	out    %al,(%dx)
801034a4:	89 f0                	mov    %esi,%eax
801034a6:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
801034a7:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
801034ae:	66 83 f8 ff          	cmp    $0xffff,%ax
801034b2:	74 0a                	je     801034be <picinit+0x8e>
801034b4:	89 da                	mov    %ebx,%edx
801034b6:	ee                   	out    %al,(%dx)
  outb(IO_PIC2+1, mask >> 8);
801034b7:	66 c1 e8 08          	shr    $0x8,%ax
801034bb:	89 ca                	mov    %ecx,%edx
801034bd:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
801034be:	5b                   	pop    %ebx
801034bf:	5e                   	pop    %esi
801034c0:	5f                   	pop    %edi
801034c1:	5d                   	pop    %ebp
801034c2:	c3                   	ret    
801034c3:	66 90                	xchg   %ax,%ax
801034c5:	66 90                	xchg   %ax,%ax
801034c7:	66 90                	xchg   %ax,%ax
801034c9:	66 90                	xchg   %ax,%ax
801034cb:	66 90                	xchg   %ax,%ax
801034cd:	66 90                	xchg   %ax,%ax
801034cf:	90                   	nop

801034d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	57                   	push   %edi
801034d4:	56                   	push   %esi
801034d5:	53                   	push   %ebx
801034d6:	83 ec 0c             	sub    $0xc,%esp
801034d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801034e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034eb:	e8 60 d8 ff ff       	call   80100d50 <filealloc>
801034f0:	85 c0                	test   %eax,%eax
801034f2:	89 03                	mov    %eax,(%ebx)
801034f4:	74 22                	je     80103518 <pipealloc+0x48>
801034f6:	e8 55 d8 ff ff       	call   80100d50 <filealloc>
801034fb:	85 c0                	test   %eax,%eax
801034fd:	89 06                	mov    %eax,(%esi)
801034ff:	74 3f                	je     80103540 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103501:	e8 fa ef ff ff       	call   80102500 <kalloc>
80103506:	85 c0                	test   %eax,%eax
80103508:	89 c7                	mov    %eax,%edi
8010350a:	75 54                	jne    80103560 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010350c:	8b 03                	mov    (%ebx),%eax
8010350e:	85 c0                	test   %eax,%eax
80103510:	75 34                	jne    80103546 <pipealloc+0x76>
80103512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103518:	8b 06                	mov    (%esi),%eax
8010351a:	85 c0                	test   %eax,%eax
8010351c:	74 0c                	je     8010352a <pipealloc+0x5a>
    fileclose(*f1);
8010351e:	83 ec 0c             	sub    $0xc,%esp
80103521:	50                   	push   %eax
80103522:	e8 e9 d8 ff ff       	call   80100e10 <fileclose>
80103527:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010352a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010352d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103532:	5b                   	pop    %ebx
80103533:	5e                   	pop    %esi
80103534:	5f                   	pop    %edi
80103535:	5d                   	pop    %ebp
80103536:	c3                   	ret    
80103537:	89 f6                	mov    %esi,%esi
80103539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103540:	8b 03                	mov    (%ebx),%eax
80103542:	85 c0                	test   %eax,%eax
80103544:	74 e4                	je     8010352a <pipealloc+0x5a>
    fileclose(*f0);
80103546:	83 ec 0c             	sub    $0xc,%esp
80103549:	50                   	push   %eax
8010354a:	e8 c1 d8 ff ff       	call   80100e10 <fileclose>
  if(*f1)
8010354f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103551:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103554:	85 c0                	test   %eax,%eax
80103556:	75 c6                	jne    8010351e <pipealloc+0x4e>
80103558:	eb d0                	jmp    8010352a <pipealloc+0x5a>
8010355a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103560:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103563:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010356a:	00 00 00 
  p->writeopen = 1;
8010356d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103574:	00 00 00 
  p->nwrite = 0;
80103577:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010357e:	00 00 00 
  p->nread = 0;
80103581:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103588:	00 00 00 
  initlock(&p->lock, "pipe");
8010358b:	68 a8 7e 10 80       	push   $0x80107ea8
80103590:	50                   	push   %eax
80103591:	e8 8a 0f 00 00       	call   80104520 <initlock>
  (*f0)->type = FD_PIPE;
80103596:	8b 03                	mov    (%ebx),%eax
  return 0;
80103598:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010359b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035a1:	8b 03                	mov    (%ebx),%eax
801035a3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035a7:	8b 03                	mov    (%ebx),%eax
801035a9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035ad:	8b 03                	mov    (%ebx),%eax
801035af:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035b2:	8b 06                	mov    (%esi),%eax
801035b4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035ba:	8b 06                	mov    (%esi),%eax
801035bc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035c0:	8b 06                	mov    (%esi),%eax
801035c2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035c6:	8b 06                	mov    (%esi),%eax
801035c8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801035cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035ce:	31 c0                	xor    %eax,%eax
}
801035d0:	5b                   	pop    %ebx
801035d1:	5e                   	pop    %esi
801035d2:	5f                   	pop    %edi
801035d3:	5d                   	pop    %ebp
801035d4:	c3                   	ret    
801035d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	56                   	push   %esi
801035e4:	53                   	push   %ebx
801035e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035eb:	83 ec 0c             	sub    $0xc,%esp
801035ee:	53                   	push   %ebx
801035ef:	e8 4c 0f 00 00       	call   80104540 <acquire>
  if(writable){
801035f4:	83 c4 10             	add    $0x10,%esp
801035f7:	85 f6                	test   %esi,%esi
801035f9:	74 45                	je     80103640 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801035fb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103601:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103604:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010360b:	00 00 00 
    wakeup(&p->nread);
8010360e:	50                   	push   %eax
8010360f:	e8 4c 0b 00 00       	call   80104160 <wakeup>
80103614:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103617:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010361d:	85 d2                	test   %edx,%edx
8010361f:	75 0a                	jne    8010362b <pipeclose+0x4b>
80103621:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103627:	85 c0                	test   %eax,%eax
80103629:	74 35                	je     80103660 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010362b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010362e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103631:	5b                   	pop    %ebx
80103632:	5e                   	pop    %esi
80103633:	5d                   	pop    %ebp
    release(&p->lock);
80103634:	e9 c7 10 00 00       	jmp    80104700 <release>
80103639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103640:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103646:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103649:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103650:	00 00 00 
    wakeup(&p->nwrite);
80103653:	50                   	push   %eax
80103654:	e8 07 0b 00 00       	call   80104160 <wakeup>
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	eb b9                	jmp    80103617 <pipeclose+0x37>
8010365e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103660:	83 ec 0c             	sub    $0xc,%esp
80103663:	53                   	push   %ebx
80103664:	e8 97 10 00 00       	call   80104700 <release>
    kfree((char*)p);
80103669:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010366c:	83 c4 10             	add    $0x10,%esp
}
8010366f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103672:	5b                   	pop    %ebx
80103673:	5e                   	pop    %esi
80103674:	5d                   	pop    %ebp
    kfree((char*)p);
80103675:	e9 86 ec ff ff       	jmp    80102300 <kfree>
8010367a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103680 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	57                   	push   %edi
80103684:	56                   	push   %esi
80103685:	53                   	push   %ebx
80103686:	83 ec 28             	sub    $0x28,%esp
80103689:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010368c:	57                   	push   %edi
8010368d:	e8 ae 0e 00 00       	call   80104540 <acquire>
  for(i = 0; i < n; i++){
80103692:	8b 45 10             	mov    0x10(%ebp),%eax
80103695:	83 c4 10             	add    $0x10,%esp
80103698:	85 c0                	test   %eax,%eax
8010369a:	0f 8e c6 00 00 00    	jle    80103766 <pipewrite+0xe6>
801036a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801036a3:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
801036a9:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
801036af:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
801036b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036b8:	03 45 10             	add    0x10(%ebp),%eax
801036bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036be:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801036c4:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801036ca:	39 d1                	cmp    %edx,%ecx
801036cc:	0f 85 cf 00 00 00    	jne    801037a1 <pipewrite+0x121>
      if(p->readopen == 0 || proc->killed){
801036d2:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
801036d8:	85 d2                	test   %edx,%edx
801036da:	0f 84 a8 00 00 00    	je     80103788 <pipewrite+0x108>
801036e0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801036e7:	8b 42 24             	mov    0x24(%edx),%eax
801036ea:	85 c0                	test   %eax,%eax
801036ec:	74 25                	je     80103713 <pipewrite+0x93>
801036ee:	e9 95 00 00 00       	jmp    80103788 <pipewrite+0x108>
801036f3:	90                   	nop
801036f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036f8:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
801036fe:	85 c0                	test   %eax,%eax
80103700:	0f 84 82 00 00 00    	je     80103788 <pipewrite+0x108>
80103706:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010370c:	8b 40 24             	mov    0x24(%eax),%eax
8010370f:	85 c0                	test   %eax,%eax
80103711:	75 75                	jne    80103788 <pipewrite+0x108>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103713:	83 ec 0c             	sub    $0xc,%esp
80103716:	56                   	push   %esi
80103717:	e8 44 0a 00 00       	call   80104160 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010371c:	59                   	pop    %ecx
8010371d:	58                   	pop    %eax
8010371e:	57                   	push   %edi
8010371f:	53                   	push   %ebx
80103720:	e8 8b 08 00 00       	call   80103fb0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103725:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
8010372b:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
80103731:	83 c4 10             	add    $0x10,%esp
80103734:	05 00 02 00 00       	add    $0x200,%eax
80103739:	39 c2                	cmp    %eax,%edx
8010373b:	74 bb                	je     801036f8 <pipewrite+0x78>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010373d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103740:	8d 4a 01             	lea    0x1(%edx),%ecx
80103743:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103747:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010374d:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
80103753:	0f b6 00             	movzbl (%eax),%eax
80103756:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
8010375a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(i = 0; i < n; i++){
8010375d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80103760:	0f 85 58 ff ff ff    	jne    801036be <pipewrite+0x3e>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103766:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	52                   	push   %edx
80103770:	e8 eb 09 00 00       	call   80104160 <wakeup>
  release(&p->lock);
80103775:	89 3c 24             	mov    %edi,(%esp)
80103778:	e8 83 0f 00 00       	call   80104700 <release>
  return n;
8010377d:	83 c4 10             	add    $0x10,%esp
80103780:	8b 45 10             	mov    0x10(%ebp),%eax
80103783:	eb 14                	jmp    80103799 <pipewrite+0x119>
80103785:	8d 76 00             	lea    0x0(%esi),%esi
        release(&p->lock);
80103788:	83 ec 0c             	sub    $0xc,%esp
8010378b:	57                   	push   %edi
8010378c:	e8 6f 0f 00 00       	call   80104700 <release>
        return -1;
80103791:	83 c4 10             	add    $0x10,%esp
80103794:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103799:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010379c:	5b                   	pop    %ebx
8010379d:	5e                   	pop    %esi
8010379e:	5f                   	pop    %edi
8010379f:	5d                   	pop    %ebp
801037a0:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037a1:	89 ca                	mov    %ecx,%edx
801037a3:	eb 98                	jmp    8010373d <pipewrite+0xbd>
801037a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	57                   	push   %edi
801037b4:	56                   	push   %esi
801037b5:	53                   	push   %ebx
801037b6:	83 ec 18             	sub    $0x18,%esp
801037b9:	8b 75 08             	mov    0x8(%ebp),%esi
801037bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037bf:	56                   	push   %esi
801037c0:	e8 7b 0d 00 00       	call   80104540 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037c5:	83 c4 10             	add    $0x10,%esp
801037c8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801037ce:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801037d4:	75 64                	jne    8010383a <piperead+0x8a>
801037d6:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801037dc:	85 c0                	test   %eax,%eax
801037de:	0f 84 bc 00 00 00    	je     801038a0 <piperead+0xf0>
    if(proc->killed){
801037e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801037ea:	8b 58 24             	mov    0x24(%eax),%ebx
801037ed:	85 db                	test   %ebx,%ebx
801037ef:	0f 85 b3 00 00 00    	jne    801038a8 <piperead+0xf8>
801037f5:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037fb:	eb 22                	jmp    8010381f <piperead+0x6f>
801037fd:	8d 76 00             	lea    0x0(%esi),%esi
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103800:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103806:	85 d2                	test   %edx,%edx
80103808:	0f 84 92 00 00 00    	je     801038a0 <piperead+0xf0>
    if(proc->killed){
8010380e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103814:	8b 48 24             	mov    0x24(%eax),%ecx
80103817:	85 c9                	test   %ecx,%ecx
80103819:	0f 85 89 00 00 00    	jne    801038a8 <piperead+0xf8>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010381f:	83 ec 08             	sub    $0x8,%esp
80103822:	56                   	push   %esi
80103823:	53                   	push   %ebx
80103824:	e8 87 07 00 00       	call   80103fb0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103829:	83 c4 10             	add    $0x10,%esp
8010382c:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103832:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103838:	74 c6                	je     80103800 <piperead+0x50>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010383a:	8b 45 10             	mov    0x10(%ebp),%eax
8010383d:	85 c0                	test   %eax,%eax
8010383f:	7e 5f                	jle    801038a0 <piperead+0xf0>
    if(p->nread == p->nwrite)
80103841:	31 db                	xor    %ebx,%ebx
80103843:	eb 11                	jmp    80103856 <piperead+0xa6>
80103845:	8d 76 00             	lea    0x0(%esi),%esi
80103848:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010384e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103854:	74 1f                	je     80103875 <piperead+0xc5>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103856:	8d 41 01             	lea    0x1(%ecx),%eax
80103859:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
8010385f:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103865:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
8010386a:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010386d:	83 c3 01             	add    $0x1,%ebx
80103870:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103873:	75 d3                	jne    80103848 <piperead+0x98>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103875:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
8010387b:	83 ec 0c             	sub    $0xc,%esp
8010387e:	50                   	push   %eax
8010387f:	e8 dc 08 00 00       	call   80104160 <wakeup>
  release(&p->lock);
80103884:	89 34 24             	mov    %esi,(%esp)
80103887:	e8 74 0e 00 00       	call   80104700 <release>
  return i;
8010388c:	83 c4 10             	add    $0x10,%esp
}
8010388f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103892:	89 d8                	mov    %ebx,%eax
80103894:	5b                   	pop    %ebx
80103895:	5e                   	pop    %esi
80103896:	5f                   	pop    %edi
80103897:	5d                   	pop    %ebp
80103898:	c3                   	ret    
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
801038a0:	31 db                	xor    %ebx,%ebx
801038a2:	eb d1                	jmp    80103875 <piperead+0xc5>
801038a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
801038a8:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038ab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038b0:	56                   	push   %esi
801038b1:	e8 4a 0e 00 00       	call   80104700 <release>
      return -1;
801038b6:	83 c4 10             	add    $0x10,%esp
}
801038b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038bc:	89 d8                	mov    %ebx,%eax
801038be:	5b                   	pop    %ebx
801038bf:	5e                   	pop    %esi
801038c0:	5f                   	pop    %edi
801038c1:	5d                   	pop    %ebp
801038c2:	c3                   	ret    
801038c3:	66 90                	xchg   %ax,%ax
801038c5:	66 90                	xchg   %ax,%ax
801038c7:	66 90                	xchg   %ax,%ax
801038c9:	66 90                	xchg   %ax,%ax
801038cb:	66 90                	xchg   %ax,%ax
801038cd:	66 90                	xchg   %ax,%ax
801038cf:	90                   	nop

801038d0 <allocproc>:
// state required to run in the kernel.
// Otherwise return 0.
// Must hold ptable.lock.
static struct proc*
allocproc(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038d4:	bb 14 a9 14 80       	mov    $0x8014a914,%ebx
{
801038d9:	83 ec 04             	sub    $0x4,%esp
801038dc:	eb 10                	jmp    801038ee <allocproc+0x1e>
801038de:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e0:	81 c3 84 00 00 00    	add    $0x84,%ebx
801038e6:	81 fb 14 ca 14 80    	cmp    $0x8014ca14,%ebx
801038ec:	73 7c                	jae    8010396a <allocproc+0x9a>
    if(p->state == UNUSED)
801038ee:	8b 43 0c             	mov    0xc(%ebx),%eax
801038f1:	85 c0                	test   %eax,%eax
801038f3:	75 eb                	jne    801038e0 <allocproc+0x10>
      goto found;
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038f5:	a1 08 b0 10 80       	mov    0x8010b008,%eax
  p->state = EMBRYO;
801038fa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->tickk=8;    //将时间片变成8
80103901:	c7 43 7c 08 00 00 00 	movl   $0x8,0x7c(%ebx)
  p->priority=10; //优先级设置为10
80103908:	c7 83 80 00 00 00 0a 	movl   $0xa,0x80(%ebx)
8010390f:	00 00 00 
  p->pid = nextpid++;
80103912:	8d 50 01             	lea    0x1(%eax),%edx
80103915:	89 43 10             	mov    %eax,0x10(%ebx)
80103918:	89 15 08 b0 10 80    	mov    %edx,0x8010b008

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010391e:	e8 dd eb ff ff       	call   80102500 <kalloc>
80103923:	85 c0                	test   %eax,%eax
80103925:	89 43 08             	mov    %eax,0x8(%ebx)
80103928:	74 39                	je     80103963 <allocproc+0x93>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010392a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103930:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103933:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103938:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010393b:	c7 40 14 1e 5d 10 80 	movl   $0x80105d1e,0x14(%eax)
  p->context = (struct context*)sp;
80103942:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103945:	6a 14                	push   $0x14
80103947:	6a 00                	push   $0x0
80103949:	50                   	push   %eax
8010394a:	e8 91 10 00 00       	call   801049e0 <memset>
  p->context->eip = (uint)forkret;
8010394f:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103952:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103955:	c7 40 10 80 39 10 80 	movl   $0x80103980,0x10(%eax)
}
8010395c:	89 d8                	mov    %ebx,%eax
8010395e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103961:	c9                   	leave  
80103962:	c3                   	ret    
    p->state = UNUSED;
80103963:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010396a:	31 db                	xor    %ebx,%ebx
}
8010396c:	89 d8                	mov    %ebx,%eax
8010396e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103971:	c9                   	leave  
80103972:	c3                   	ret    
80103973:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103980 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103986:	68 e0 a8 14 80       	push   $0x8014a8e0
8010398b:	e8 70 0d 00 00       	call   80104700 <release>

  if (first) {
80103990:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80103995:	83 c4 10             	add    $0x10,%esp
80103998:	85 c0                	test   %eax,%eax
8010399a:	75 04                	jne    801039a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010399c:	c9                   	leave  
8010399d:	c3                   	ret    
8010399e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801039a0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801039a3:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
801039aa:	00 00 00 
    iinit(ROOTDEV);
801039ad:	6a 01                	push   $0x1
801039af:	e8 8c da ff ff       	call   80101440 <iinit>
    initlog(ROOTDEV);
801039b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039bb:	e8 c0 f2 ff ff       	call   80102c80 <initlog>
801039c0:	83 c4 10             	add    $0x10,%esp
}
801039c3:	c9                   	leave  
801039c4:	c3                   	ret    
801039c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039d0 <getcpuid>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
}
801039d3:	5d                   	pop    %ebp
return cpunum();
801039d4:	e9 47 ee ff ff       	jmp    80102820 <cpunum>
801039d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039e0 <pinit>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039e6:	68 ad 7e 10 80       	push   $0x80107ead
801039eb:	68 e0 a8 14 80       	push   $0x8014a8e0
801039f0:	e8 2b 0b 00 00       	call   80104520 <initlock>
}
801039f5:	83 c4 10             	add    $0x10,%esp
801039f8:	c9                   	leave  
801039f9:	c3                   	ret    
801039fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a00 <userinit>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	53                   	push   %ebx
80103a04:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103a07:	68 e0 a8 14 80       	push   $0x8014a8e0
80103a0c:	e8 2f 0b 00 00       	call   80104540 <acquire>
  p = allocproc();
80103a11:	e8 ba fe ff ff       	call   801038d0 <allocproc>
80103a16:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a18:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
  if((p->pgdir = setupkvm()) == 0)
80103a1d:	e8 ce 34 00 00       	call   80106ef0 <setupkvm>
80103a22:	83 c4 10             	add    $0x10,%esp
80103a25:	85 c0                	test   %eax,%eax
80103a27:	89 43 04             	mov    %eax,0x4(%ebx)
80103a2a:	0f 84 b1 00 00 00    	je     80103ae1 <userinit+0xe1>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a30:	83 ec 04             	sub    $0x4,%esp
80103a33:	68 2c 00 00 00       	push   $0x2c
80103a38:	68 60 b4 10 80       	push   $0x8010b460
80103a3d:	50                   	push   %eax
80103a3e:	e8 fd 35 00 00       	call   80107040 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a43:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a46:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a4c:	6a 4c                	push   $0x4c
80103a4e:	6a 00                	push   $0x0
80103a50:	ff 73 18             	pushl  0x18(%ebx)
80103a53:	e8 88 0f 00 00       	call   801049e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a58:	8b 43 18             	mov    0x18(%ebx),%eax
80103a5b:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a60:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a65:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a68:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a6f:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a73:	8b 43 18             	mov    0x18(%ebx),%eax
80103a76:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a7a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a7e:	8b 43 18             	mov    0x18(%ebx),%eax
80103a81:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a85:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a89:	8b 43 18             	mov    0x18(%ebx),%eax
80103a8c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a93:	8b 43 18             	mov    0x18(%ebx),%eax
80103a96:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a9d:	8b 43 18             	mov    0x18(%ebx),%eax
80103aa0:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aa7:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103aaa:	6a 10                	push   $0x10
80103aac:	68 cd 7e 10 80       	push   $0x80107ecd
80103ab1:	50                   	push   %eax
80103ab2:	e8 09 11 00 00       	call   80104bc0 <safestrcpy>
  p->cwd = namei("/");
80103ab7:	c7 04 24 d6 7e 10 80 	movl   $0x80107ed6,(%esp)
80103abe:	e8 ed e3 ff ff       	call   80101eb0 <namei>
  p->state = RUNNABLE;
80103ac3:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->cwd = namei("/");
80103aca:	89 43 68             	mov    %eax,0x68(%ebx)
  release(&ptable.lock);
80103acd:	c7 04 24 e0 a8 14 80 	movl   $0x8014a8e0,(%esp)
80103ad4:	e8 27 0c 00 00       	call   80104700 <release>
}
80103ad9:	83 c4 10             	add    $0x10,%esp
80103adc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103adf:	c9                   	leave  
80103ae0:	c3                   	ret    
    panic("userinit: out of memory?");
80103ae1:	83 ec 0c             	sub    $0xc,%esp
80103ae4:	68 b4 7e 10 80       	push   $0x80107eb4
80103ae9:	e8 82 c8 ff ff       	call   80100370 <panic>
80103aee:	66 90                	xchg   %ax,%ax

80103af0 <growproc>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	83 ec 08             	sub    $0x8,%esp
  sz = proc->sz;
80103af6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
{
80103afd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  sz = proc->sz;
80103b00:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103b02:	83 f9 00             	cmp    $0x0,%ecx
80103b05:	7f 21                	jg     80103b28 <growproc+0x38>
  } else if(n < 0){
80103b07:	75 47                	jne    80103b50 <growproc+0x60>
  proc->sz = sz;
80103b09:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
80103b0b:	83 ec 0c             	sub    $0xc,%esp
80103b0e:	65 ff 35 04 00 00 00 	pushl  %gs:0x4
80103b15:	e8 86 34 00 00       	call   80106fa0 <switchuvm>
  return 0;
80103b1a:	83 c4 10             	add    $0x10,%esp
80103b1d:	31 c0                	xor    %eax,%eax
}
80103b1f:	c9                   	leave  
80103b20:	c3                   	ret    
80103b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103b28:	83 ec 04             	sub    $0x4,%esp
80103b2b:	01 c1                	add    %eax,%ecx
80103b2d:	51                   	push   %ecx
80103b2e:	50                   	push   %eax
80103b2f:	ff 72 04             	pushl  0x4(%edx)
80103b32:	e8 49 36 00 00       	call   80107180 <allocuvm>
80103b37:	83 c4 10             	add    $0x10,%esp
80103b3a:	85 c0                	test   %eax,%eax
80103b3c:	74 28                	je     80103b66 <growproc+0x76>
80103b3e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103b45:	eb c2                	jmp    80103b09 <growproc+0x19>
80103b47:	89 f6                	mov    %esi,%esi
80103b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103b50:	83 ec 04             	sub    $0x4,%esp
80103b53:	01 c1                	add    %eax,%ecx
80103b55:	51                   	push   %ecx
80103b56:	50                   	push   %eax
80103b57:	ff 72 04             	pushl  0x4(%edx)
80103b5a:	e8 51 37 00 00       	call   801072b0 <deallocuvm>
80103b5f:	83 c4 10             	add    $0x10,%esp
80103b62:	85 c0                	test   %eax,%eax
80103b64:	75 d8                	jne    80103b3e <growproc+0x4e>
      return -1;
80103b66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b6b:	c9                   	leave  
80103b6c:	c3                   	ret    
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi

80103b70 <fork>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	57                   	push   %edi
80103b74:	56                   	push   %esi
80103b75:	53                   	push   %ebx
80103b76:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80103b79:	68 e0 a8 14 80       	push   $0x8014a8e0
80103b7e:	e8 bd 09 00 00       	call   80104540 <acquire>
  if((np = allocproc()) == 0){
80103b83:	e8 48 fd ff ff       	call   801038d0 <allocproc>
80103b88:	83 c4 10             	add    $0x10,%esp
80103b8b:	85 c0                	test   %eax,%eax
80103b8d:	0f 84 cd 00 00 00    	je     80103c60 <fork+0xf0>
80103b93:	89 c3                	mov    %eax,%ebx
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103b95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b9b:	83 ec 08             	sub    $0x8,%esp
80103b9e:	ff 30                	pushl  (%eax)
80103ba0:	ff 70 04             	pushl  0x4(%eax)
80103ba3:	e8 e8 37 00 00       	call   80107390 <copyuvm>
80103ba8:	83 c4 10             	add    $0x10,%esp
80103bab:	85 c0                	test   %eax,%eax
80103bad:	89 43 04             	mov    %eax,0x4(%ebx)
80103bb0:	0f 84 c1 00 00 00    	je     80103c77 <fork+0x107>
  np->sz = proc->sz;
80103bb6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  *np->tf = *proc->tf;
80103bbc:	8b 7b 18             	mov    0x18(%ebx),%edi
80103bbf:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = proc->sz;
80103bc4:	8b 00                	mov    (%eax),%eax
80103bc6:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103bc8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103bce:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103bd1:	8b 70 18             	mov    0x18(%eax),%esi
80103bd4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bd6:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bd8:	8b 43 18             	mov    0x18(%ebx),%eax
80103bdb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103be2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->ofile[i])
80103bf0:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103bf4:	85 c0                	test   %eax,%eax
80103bf6:	74 17                	je     80103c0f <fork+0x9f>
      np->ofile[i] = filedup(proc->ofile[i]);
80103bf8:	83 ec 0c             	sub    $0xc,%esp
80103bfb:	50                   	push   %eax
80103bfc:	e8 bf d1 ff ff       	call   80100dc0 <filedup>
80103c01:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103c05:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c0c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
80103c0f:	83 c6 01             	add    $0x1,%esi
80103c12:	83 fe 10             	cmp    $0x10,%esi
80103c15:	75 d9                	jne    80103bf0 <fork+0x80>
  np->cwd = idup(proc->cwd);
80103c17:	83 ec 0c             	sub    $0xc,%esp
80103c1a:	ff 72 68             	pushl  0x68(%edx)
80103c1d:	e8 be d9 ff ff       	call   801015e0 <idup>
80103c22:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103c25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c2b:	83 c4 0c             	add    $0xc,%esp
80103c2e:	6a 10                	push   $0x10
80103c30:	83 c0 6c             	add    $0x6c,%eax
80103c33:	50                   	push   %eax
80103c34:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c37:	50                   	push   %eax
80103c38:	e8 83 0f 00 00       	call   80104bc0 <safestrcpy>
  np->state = RUNNABLE;
80103c3d:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pid = np->pid;
80103c44:	8b 73 10             	mov    0x10(%ebx),%esi
  release(&ptable.lock);
80103c47:	c7 04 24 e0 a8 14 80 	movl   $0x8014a8e0,(%esp)
80103c4e:	e8 ad 0a 00 00       	call   80104700 <release>
  return pid;
80103c53:	83 c4 10             	add    $0x10,%esp
}
80103c56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c59:	89 f0                	mov    %esi,%eax
80103c5b:	5b                   	pop    %ebx
80103c5c:	5e                   	pop    %esi
80103c5d:	5f                   	pop    %edi
80103c5e:	5d                   	pop    %ebp
80103c5f:	c3                   	ret    
    release(&ptable.lock);
80103c60:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103c63:	be ff ff ff ff       	mov    $0xffffffff,%esi
    release(&ptable.lock);
80103c68:	68 e0 a8 14 80       	push   $0x8014a8e0
80103c6d:	e8 8e 0a 00 00       	call   80104700 <release>
    return -1;
80103c72:	83 c4 10             	add    $0x10,%esp
80103c75:	eb df                	jmp    80103c56 <fork+0xe6>
    kfree(np->kstack);
80103c77:	83 ec 0c             	sub    $0xc,%esp
80103c7a:	ff 73 08             	pushl  0x8(%ebx)
    return -1;
80103c7d:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103c82:	e8 79 e6 ff ff       	call   80102300 <kfree>
    np->kstack = 0;
80103c87:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c8e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    release(&ptable.lock);
80103c95:	c7 04 24 e0 a8 14 80 	movl   $0x8014a8e0,(%esp)
80103c9c:	e8 5f 0a 00 00       	call   80104700 <release>
    return -1;
80103ca1:	83 c4 10             	add    $0x10,%esp
80103ca4:	eb b0                	jmp    80103c56 <fork+0xe6>
80103ca6:	8d 76 00             	lea    0x0(%esi),%esi
80103ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cb0 <scheduler>:
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	56                   	push   %esi
80103cb4:	53                   	push   %ebx
80103cb5:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103cb8:	fb                   	sti    
    acquire(&ptable.lock);
80103cb9:	83 ec 0c             	sub    $0xc,%esp
80103cbc:	68 e0 a8 14 80       	push   $0x8014a8e0
80103cc1:	e8 7a 08 00 00       	call   80104540 <acquire>
80103cc6:	83 c4 10             	add    $0x10,%esp
    priority = 19;  //设置pri为19
80103cc9:	ba 13 00 00 00       	mov    $0x13,%edx
    for(temp  = ptable.proc; temp < &ptable.proc[NPROC]; temp++) //获取当前可运行的最高当前优先级
80103cce:	b8 14 a9 14 80       	mov    $0x8014a914,%eax
80103cd3:	90                   	nop
80103cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(temp->state == RUNNABLE&&temp->priority < priority)
80103cd8:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103cdc:	75 0b                	jne    80103ce9 <scheduler+0x39>
80103cde:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80103ce4:	39 ca                	cmp    %ecx,%edx
80103ce6:	0f 4f d1             	cmovg  %ecx,%edx
    for(temp  = ptable.proc; temp < &ptable.proc[NPROC]; temp++) //获取当前可运行的最高当前优先级
80103ce9:	05 84 00 00 00       	add    $0x84,%eax
80103cee:	3d 14 ca 14 80       	cmp    $0x8014ca14,%eax
80103cf3:	72 e3                	jb     80103cd8 <scheduler+0x28>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf5:	bb 14 a9 14 80       	mov    $0x8014a914,%ebx
80103cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103d00:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d04:	75 4a                	jne    80103d50 <scheduler+0xa0>
      if(p->priority > priority)
80103d06:	8b b3 80 00 00 00    	mov    0x80(%ebx),%esi
80103d0c:	39 d6                	cmp    %edx,%esi
80103d0e:	7f 40                	jg     80103d50 <scheduler+0xa0>
      switchuvm(p);
80103d10:	83 ec 0c             	sub    $0xc,%esp
      proc = p;
80103d13:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
80103d1a:	53                   	push   %ebx
80103d1b:	e8 80 32 00 00       	call   80106fa0 <switchuvm>
      swtch(&cpu->scheduler, p->context);
80103d20:	58                   	pop    %eax
80103d21:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
      p->state = RUNNING;
80103d27:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&cpu->scheduler, p->context);
80103d2e:	5a                   	pop    %edx
80103d2f:	ff 73 1c             	pushl  0x1c(%ebx)
80103d32:	83 c0 04             	add    $0x4,%eax
80103d35:	50                   	push   %eax
80103d36:	e8 e0 0e 00 00       	call   80104c1b <swtch>
      switchkvm();
80103d3b:	e8 40 32 00 00       	call   80106f80 <switchkvm>
      proc = 0;
80103d40:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103d47:	00 00 00 00 
80103d4b:	83 c4 10             	add    $0x10,%esp
80103d4e:	89 f2                	mov    %esi,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d50:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103d56:	81 fb 14 ca 14 80    	cmp    $0x8014ca14,%ebx
80103d5c:	72 a2                	jb     80103d00 <scheduler+0x50>
    release(&ptable.lock);
80103d5e:	83 ec 0c             	sub    $0xc,%esp
80103d61:	68 e0 a8 14 80       	push   $0x8014a8e0
80103d66:	e8 95 09 00 00       	call   80104700 <release>
    sti();
80103d6b:	83 c4 10             	add    $0x10,%esp
80103d6e:	e9 45 ff ff ff       	jmp    80103cb8 <scheduler+0x8>
80103d73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d80 <sched>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	53                   	push   %ebx
80103d84:	83 ec 10             	sub    $0x10,%esp
  if(!holding(&ptable.lock))
80103d87:	68 e0 a8 14 80       	push   $0x8014a8e0
80103d8c:	e8 bf 08 00 00       	call   80104650 <holding>
80103d91:	83 c4 10             	add    $0x10,%esp
80103d94:	85 c0                	test   %eax,%eax
80103d96:	74 4c                	je     80103de4 <sched+0x64>
  if(cpu->ncli != 1)
80103d98:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103d9f:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
80103da6:	75 63                	jne    80103e0b <sched+0x8b>
  if(proc->state == RUNNING)
80103da8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103dae:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80103db2:	74 4a                	je     80103dfe <sched+0x7e>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103db4:	9c                   	pushf  
80103db5:	59                   	pop    %ecx
  if(readeflags()&FL_IF)
80103db6:	80 e5 02             	and    $0x2,%ch
80103db9:	75 36                	jne    80103df1 <sched+0x71>
  swtch(&proc->context, cpu->scheduler);
80103dbb:	83 ec 08             	sub    $0x8,%esp
80103dbe:	83 c0 1c             	add    $0x1c,%eax
  intena = cpu->intena;
80103dc1:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
  swtch(&proc->context, cpu->scheduler);
80103dc7:	ff 72 04             	pushl  0x4(%edx)
80103dca:	50                   	push   %eax
80103dcb:	e8 4b 0e 00 00       	call   80104c1b <swtch>
  cpu->intena = intena;
80103dd0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
}
80103dd6:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80103dd9:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103ddf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103de2:	c9                   	leave  
80103de3:	c3                   	ret    
    panic("sched ptable.lock");
80103de4:	83 ec 0c             	sub    $0xc,%esp
80103de7:	68 d8 7e 10 80       	push   $0x80107ed8
80103dec:	e8 7f c5 ff ff       	call   80100370 <panic>
    panic("sched interruptible");
80103df1:	83 ec 0c             	sub    $0xc,%esp
80103df4:	68 04 7f 10 80       	push   $0x80107f04
80103df9:	e8 72 c5 ff ff       	call   80100370 <panic>
    panic("sched running");
80103dfe:	83 ec 0c             	sub    $0xc,%esp
80103e01:	68 f6 7e 10 80       	push   $0x80107ef6
80103e06:	e8 65 c5 ff ff       	call   80100370 <panic>
    panic("sched locks");
80103e0b:	83 ec 0c             	sub    $0xc,%esp
80103e0e:	68 ea 7e 10 80       	push   $0x80107eea
80103e13:	e8 58 c5 ff ff       	call   80100370 <panic>
80103e18:	90                   	nop
80103e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e20 <exit>:
{
80103e20:	55                   	push   %ebp
  if(proc == initproc)
80103e21:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
{
80103e28:	89 e5                	mov    %esp,%ebp
80103e2a:	56                   	push   %esi
80103e2b:	53                   	push   %ebx
80103e2c:	31 db                	xor    %ebx,%ebx
  if(proc == initproc)
80103e2e:	3b 15 bc b5 10 80    	cmp    0x8010b5bc,%edx
80103e34:	0f 84 27 01 00 00    	je     80103f61 <exit+0x141>
80103e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(proc->ofile[fd]){
80103e40:	8d 73 08             	lea    0x8(%ebx),%esi
80103e43:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103e47:	85 c0                	test   %eax,%eax
80103e49:	74 1b                	je     80103e66 <exit+0x46>
      fileclose(proc->ofile[fd]);
80103e4b:	83 ec 0c             	sub    $0xc,%esp
80103e4e:	50                   	push   %eax
80103e4f:	e8 bc cf ff ff       	call   80100e10 <fileclose>
      proc->ofile[fd] = 0;
80103e54:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103e5b:	83 c4 10             	add    $0x10,%esp
80103e5e:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103e65:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103e66:	83 c3 01             	add    $0x1,%ebx
80103e69:	83 fb 10             	cmp    $0x10,%ebx
80103e6c:	75 d2                	jne    80103e40 <exit+0x20>
  begin_op();
80103e6e:	e8 ad ee ff ff       	call   80102d20 <begin_op>
  iput(proc->cwd);
80103e73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e79:	83 ec 0c             	sub    $0xc,%esp
80103e7c:	ff 70 68             	pushl  0x68(%eax)
80103e7f:	e8 fc d8 ff ff       	call   80101780 <iput>
  end_op();
80103e84:	e8 07 ef ff ff       	call   80102d90 <end_op>
  proc->cwd = 0;
80103e89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e8f:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  acquire(&ptable.lock);
80103e96:	c7 04 24 e0 a8 14 80 	movl   $0x8014a8e0,(%esp)
80103e9d:	e8 9e 06 00 00       	call   80104540 <acquire>
  wakeup1(proc->parent);
80103ea2:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
80103ea9:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eac:	b8 14 a9 14 80       	mov    $0x8014a914,%eax
  wakeup1(proc->parent);
80103eb1:	8b 53 14             	mov    0x14(%ebx),%edx
80103eb4:	eb 16                	jmp    80103ecc <exit+0xac>
80103eb6:	8d 76 00             	lea    0x0(%esi),%esi
80103eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec0:	05 84 00 00 00       	add    $0x84,%eax
80103ec5:	3d 14 ca 14 80       	cmp    $0x8014ca14,%eax
80103eca:	73 1e                	jae    80103eea <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
80103ecc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ed0:	75 ee                	jne    80103ec0 <exit+0xa0>
80103ed2:	3b 50 20             	cmp    0x20(%eax),%edx
80103ed5:	75 e9                	jne    80103ec0 <exit+0xa0>
      p->state = RUNNABLE;
80103ed7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ede:	05 84 00 00 00       	add    $0x84,%eax
80103ee3:	3d 14 ca 14 80       	cmp    $0x8014ca14,%eax
80103ee8:	72 e2                	jb     80103ecc <exit+0xac>
      p->parent = initproc;
80103eea:	8b 0d bc b5 10 80    	mov    0x8010b5bc,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef0:	ba 14 a9 14 80       	mov    $0x8014a914,%edx
80103ef5:	eb 17                	jmp    80103f0e <exit+0xee>
80103ef7:	89 f6                	mov    %esi,%esi
80103ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103f00:	81 c2 84 00 00 00    	add    $0x84,%edx
80103f06:	81 fa 14 ca 14 80    	cmp    $0x8014ca14,%edx
80103f0c:	73 3a                	jae    80103f48 <exit+0x128>
    if(p->parent == proc){
80103f0e:	3b 5a 14             	cmp    0x14(%edx),%ebx
80103f11:	75 ed                	jne    80103f00 <exit+0xe0>
      if(p->state == ZOMBIE)
80103f13:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f17:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f1a:	75 e4                	jne    80103f00 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f1c:	b8 14 a9 14 80       	mov    $0x8014a914,%eax
80103f21:	eb 11                	jmp    80103f34 <exit+0x114>
80103f23:	90                   	nop
80103f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f28:	05 84 00 00 00       	add    $0x84,%eax
80103f2d:	3d 14 ca 14 80       	cmp    $0x8014ca14,%eax
80103f32:	73 cc                	jae    80103f00 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80103f34:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f38:	75 ee                	jne    80103f28 <exit+0x108>
80103f3a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f3d:	75 e9                	jne    80103f28 <exit+0x108>
      p->state = RUNNABLE;
80103f3f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f46:	eb e0                	jmp    80103f28 <exit+0x108>
  proc->state = ZOMBIE;
80103f48:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f4f:	e8 2c fe ff ff       	call   80103d80 <sched>
  panic("zombie exit");
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	68 25 7f 10 80       	push   $0x80107f25
80103f5c:	e8 0f c4 ff ff       	call   80100370 <panic>
    panic("init exiting");
80103f61:	83 ec 0c             	sub    $0xc,%esp
80103f64:	68 18 7f 10 80       	push   $0x80107f18
80103f69:	e8 02 c4 ff ff       	call   80100370 <panic>
80103f6e:	66 90                	xchg   %ax,%ax

80103f70 <yield>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f76:	68 e0 a8 14 80       	push   $0x8014a8e0
80103f7b:	e8 c0 05 00 00       	call   80104540 <acquire>
  proc->state = RUNNABLE;
80103f80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f86:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103f8d:	e8 ee fd ff ff       	call   80103d80 <sched>
  release(&ptable.lock);
80103f92:	c7 04 24 e0 a8 14 80 	movl   $0x8014a8e0,(%esp)
80103f99:	e8 62 07 00 00       	call   80104700 <release>
}
80103f9e:	83 c4 10             	add    $0x10,%esp
80103fa1:	c9                   	leave  
80103fa2:	c3                   	ret    
80103fa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fb0 <sleep>:
  if(proc == 0)
80103fb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
{
80103fb6:	55                   	push   %ebp
80103fb7:	89 e5                	mov    %esp,%ebp
80103fb9:	56                   	push   %esi
80103fba:	53                   	push   %ebx
  if(proc == 0)
80103fbb:	85 c0                	test   %eax,%eax
{
80103fbd:	8b 75 08             	mov    0x8(%ebp),%esi
80103fc0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103fc3:	0f 84 97 00 00 00    	je     80104060 <sleep+0xb0>
  if(lk == 0)
80103fc9:	85 db                	test   %ebx,%ebx
80103fcb:	0f 84 82 00 00 00    	je     80104053 <sleep+0xa3>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103fd1:	81 fb e0 a8 14 80    	cmp    $0x8014a8e0,%ebx
80103fd7:	74 57                	je     80104030 <sleep+0x80>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103fd9:	83 ec 0c             	sub    $0xc,%esp
80103fdc:	68 e0 a8 14 80       	push   $0x8014a8e0
80103fe1:	e8 5a 05 00 00       	call   80104540 <acquire>
    release(lk);
80103fe6:	89 1c 24             	mov    %ebx,(%esp)
80103fe9:	e8 12 07 00 00       	call   80104700 <release>
  proc->chan = chan;
80103fee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ff4:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103ff7:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103ffe:	e8 7d fd ff ff       	call   80103d80 <sched>
  proc->chan = 0;
80104003:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104009:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
    release(&ptable.lock);
80104010:	c7 04 24 e0 a8 14 80 	movl   $0x8014a8e0,(%esp)
80104017:	e8 e4 06 00 00       	call   80104700 <release>
    acquire(lk);
8010401c:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010401f:	83 c4 10             	add    $0x10,%esp
}
80104022:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104025:	5b                   	pop    %ebx
80104026:	5e                   	pop    %esi
80104027:	5d                   	pop    %ebp
    acquire(lk);
80104028:	e9 13 05 00 00       	jmp    80104540 <acquire>
8010402d:	8d 76 00             	lea    0x0(%esi),%esi
  proc->chan = chan;
80104030:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80104033:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
8010403a:	e8 41 fd ff ff       	call   80103d80 <sched>
  proc->chan = 0;
8010403f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104045:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
}
8010404c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010404f:	5b                   	pop    %ebx
80104050:	5e                   	pop    %esi
80104051:	5d                   	pop    %ebp
80104052:	c3                   	ret    
    panic("sleep without lk");
80104053:	83 ec 0c             	sub    $0xc,%esp
80104056:	68 37 7f 10 80       	push   $0x80107f37
8010405b:	e8 10 c3 ff ff       	call   80100370 <panic>
    panic("sleep");
80104060:	83 ec 0c             	sub    $0xc,%esp
80104063:	68 31 7f 10 80       	push   $0x80107f31
80104068:	e8 03 c3 ff ff       	call   80100370 <panic>
8010406d:	8d 76 00             	lea    0x0(%esi),%esi

80104070 <wait>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	56                   	push   %esi
80104074:	53                   	push   %ebx
  acquire(&ptable.lock);
80104075:	83 ec 0c             	sub    $0xc,%esp
80104078:	68 e0 a8 14 80       	push   $0x8014a8e0
8010407d:	e8 be 04 00 00       	call   80104540 <acquire>
80104082:	83 c4 10             	add    $0x10,%esp
      if(p->parent != proc)
80104085:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    havekids = 0;
8010408b:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010408d:	bb 14 a9 14 80       	mov    $0x8014a914,%ebx
80104092:	eb 12                	jmp    801040a6 <wait+0x36>
80104094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104098:	81 c3 84 00 00 00    	add    $0x84,%ebx
8010409e:	81 fb 14 ca 14 80    	cmp    $0x8014ca14,%ebx
801040a4:	73 1e                	jae    801040c4 <wait+0x54>
      if(p->parent != proc)
801040a6:	39 43 14             	cmp    %eax,0x14(%ebx)
801040a9:	75 ed                	jne    80104098 <wait+0x28>
      if(p->state == ZOMBIE){
801040ab:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801040af:	74 37                	je     801040e8 <wait+0x78>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b1:	81 c3 84 00 00 00    	add    $0x84,%ebx
      havekids = 1;
801040b7:	ba 01 00 00 00       	mov    $0x1,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040bc:	81 fb 14 ca 14 80    	cmp    $0x8014ca14,%ebx
801040c2:	72 e2                	jb     801040a6 <wait+0x36>
    if(!havekids || proc->killed){
801040c4:	85 d2                	test   %edx,%edx
801040c6:	74 76                	je     8010413e <wait+0xce>
801040c8:	8b 50 24             	mov    0x24(%eax),%edx
801040cb:	85 d2                	test   %edx,%edx
801040cd:	75 6f                	jne    8010413e <wait+0xce>
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801040cf:	83 ec 08             	sub    $0x8,%esp
801040d2:	68 e0 a8 14 80       	push   $0x8014a8e0
801040d7:	50                   	push   %eax
801040d8:	e8 d3 fe ff ff       	call   80103fb0 <sleep>
    havekids = 0;
801040dd:	83 c4 10             	add    $0x10,%esp
801040e0:	eb a3                	jmp    80104085 <wait+0x15>
801040e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801040e8:	83 ec 0c             	sub    $0xc,%esp
801040eb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801040ee:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040f1:	e8 0a e2 ff ff       	call   80102300 <kfree>
        freevm(p->pgdir);
801040f6:	59                   	pop    %ecx
801040f7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801040fa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104101:	e8 da 31 00 00       	call   801072e0 <freevm>
        release(&ptable.lock);
80104106:	c7 04 24 e0 a8 14 80 	movl   $0x8014a8e0,(%esp)
        p->pid = 0;
8010410d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104114:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010411b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010411f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104126:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010412d:	e8 ce 05 00 00       	call   80104700 <release>
        return pid;
80104132:	83 c4 10             	add    $0x10,%esp
}
80104135:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104138:	89 f0                	mov    %esi,%eax
8010413a:	5b                   	pop    %ebx
8010413b:	5e                   	pop    %esi
8010413c:	5d                   	pop    %ebp
8010413d:	c3                   	ret    
      release(&ptable.lock);
8010413e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104141:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104146:	68 e0 a8 14 80       	push   $0x8014a8e0
8010414b:	e8 b0 05 00 00       	call   80104700 <release>
      return -1;
80104150:	83 c4 10             	add    $0x10,%esp
80104153:	eb e0                	jmp    80104135 <wait+0xc5>
80104155:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104160 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 10             	sub    $0x10,%esp
80104167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010416a:	68 e0 a8 14 80       	push   $0x8014a8e0
8010416f:	e8 cc 03 00 00       	call   80104540 <acquire>
80104174:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104177:	b8 14 a9 14 80       	mov    $0x8014a914,%eax
8010417c:	eb 0e                	jmp    8010418c <wakeup+0x2c>
8010417e:	66 90                	xchg   %ax,%ax
80104180:	05 84 00 00 00       	add    $0x84,%eax
80104185:	3d 14 ca 14 80       	cmp    $0x8014ca14,%eax
8010418a:	73 1e                	jae    801041aa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010418c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104190:	75 ee                	jne    80104180 <wakeup+0x20>
80104192:	3b 58 20             	cmp    0x20(%eax),%ebx
80104195:	75 e9                	jne    80104180 <wakeup+0x20>
      p->state = RUNNABLE;
80104197:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010419e:	05 84 00 00 00       	add    $0x84,%eax
801041a3:	3d 14 ca 14 80       	cmp    $0x8014ca14,%eax
801041a8:	72 e2                	jb     8010418c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801041aa:	c7 45 08 e0 a8 14 80 	movl   $0x8014a8e0,0x8(%ebp)
}
801041b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b4:	c9                   	leave  
  release(&ptable.lock);
801041b5:	e9 46 05 00 00       	jmp    80104700 <release>
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 10             	sub    $0x10,%esp
801041c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041ca:	68 e0 a8 14 80       	push   $0x8014a8e0
801041cf:	e8 6c 03 00 00       	call   80104540 <acquire>
801041d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d7:	b8 14 a9 14 80       	mov    $0x8014a914,%eax
801041dc:	eb 0e                	jmp    801041ec <kill+0x2c>
801041de:	66 90                	xchg   %ax,%ax
801041e0:	05 84 00 00 00       	add    $0x84,%eax
801041e5:	3d 14 ca 14 80       	cmp    $0x8014ca14,%eax
801041ea:	73 34                	jae    80104220 <kill+0x60>
    if(p->pid == pid){
801041ec:	39 58 10             	cmp    %ebx,0x10(%eax)
801041ef:	75 ef                	jne    801041e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041f1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041f5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041fc:	75 07                	jne    80104205 <kill+0x45>
        p->state = RUNNABLE;
801041fe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104205:	83 ec 0c             	sub    $0xc,%esp
80104208:	68 e0 a8 14 80       	push   $0x8014a8e0
8010420d:	e8 ee 04 00 00       	call   80104700 <release>
      return 0;
80104212:	83 c4 10             	add    $0x10,%esp
80104215:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104217:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010421a:	c9                   	leave  
8010421b:	c3                   	ret    
8010421c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104220:	83 ec 0c             	sub    $0xc,%esp
80104223:	68 e0 a8 14 80       	push   $0x8014a8e0
80104228:	e8 d3 04 00 00       	call   80104700 <release>
  return -1;
8010422d:	83 c4 10             	add    $0x10,%esp
80104230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104238:	c9                   	leave  
80104239:	c3                   	ret    
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	57                   	push   %edi
80104244:	56                   	push   %esi
80104245:	53                   	push   %ebx
80104246:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104249:	bb 14 a9 14 80       	mov    $0x8014a914,%ebx
{
8010424e:	83 ec 3c             	sub    $0x3c,%esp
80104251:	eb 27                	jmp    8010427a <procdump+0x3a>
80104253:	90                   	nop
80104254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	68 86 7e 10 80       	push   $0x80107e86
80104260:	e8 db c3 ff ff       	call   80100640 <cprintf>
80104265:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104268:	81 c3 84 00 00 00    	add    $0x84,%ebx
8010426e:	81 fb 14 ca 14 80    	cmp    $0x8014ca14,%ebx
80104274:	0f 83 96 00 00 00    	jae    80104310 <procdump+0xd0>
    if(p->state == UNUSED)
8010427a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010427d:	85 c0                	test   %eax,%eax
8010427f:	74 e7                	je     80104268 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104281:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104284:	ba 48 7f 10 80       	mov    $0x80107f48,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104289:	77 11                	ja     8010429c <procdump+0x5c>
8010428b:	8b 14 85 98 7f 10 80 	mov    -0x7fef8068(,%eax,4),%edx
      state = "???";
80104292:	b8 48 7f 10 80       	mov    $0x80107f48,%eax
80104297:	85 d2                	test   %edx,%edx
80104299:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s,ticks left: %d,prio=%d", p->pid, state, p->name,p->tickk,p->priority);
8010429c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010429f:	83 ec 08             	sub    $0x8,%esp
801042a2:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
801042a8:	ff 73 7c             	pushl  0x7c(%ebx)
801042ab:	50                   	push   %eax
801042ac:	52                   	push   %edx
801042ad:	ff 73 10             	pushl  0x10(%ebx)
801042b0:	68 78 7f 10 80       	push   $0x80107f78
801042b5:	e8 86 c3 ff ff       	call   80100640 <cprintf>
    if(p->state == SLEEPING){
801042ba:	83 c4 20             	add    $0x20,%esp
801042bd:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801042c1:	75 95                	jne    80104258 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042c3:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042c6:	83 ec 08             	sub    $0x8,%esp
801042c9:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042cc:	50                   	push   %eax
801042cd:	8b 43 1c             	mov    0x1c(%ebx),%eax
801042d0:	8b 40 0c             	mov    0xc(%eax),%eax
801042d3:	83 c0 08             	add    $0x8,%eax
801042d6:	50                   	push   %eax
801042d7:	e8 24 03 00 00       	call   80104600 <getcallerpcs>
801042dc:	83 c4 10             	add    $0x10,%esp
801042df:	90                   	nop
      for(i=0; i<10 && pc[i] != 0; i++)
801042e0:	8b 17                	mov    (%edi),%edx
801042e2:	85 d2                	test   %edx,%edx
801042e4:	0f 84 6e ff ff ff    	je     80104258 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042ea:	83 ec 08             	sub    $0x8,%esp
801042ed:	83 c7 04             	add    $0x4,%edi
801042f0:	52                   	push   %edx
801042f1:	68 82 79 10 80       	push   $0x80107982
801042f6:	e8 45 c3 ff ff       	call   80100640 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042fb:	83 c4 10             	add    $0x10,%esp
801042fe:	39 fe                	cmp    %edi,%esi
80104300:	75 de                	jne    801042e0 <procdump+0xa0>
80104302:	e9 51 ff ff ff       	jmp    80104258 <procdump+0x18>
80104307:	89 f6                	mov    %esi,%esi
80104309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
}
80104310:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104313:	5b                   	pop    %ebx
80104314:	5e                   	pop    %esi
80104315:	5f                   	pop    %edi
80104316:	5d                   	pop    %ebp
80104317:	c3                   	ret    
80104318:	90                   	nop
80104319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104320 <changepri>:

//修改进程优先级   
int changepri( int pid, int priority ) {
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	53                   	push   %ebx
80104324:	83 ec 10             	sub    $0x10,%esp
80104327:	8b 5d 08             	mov    0x8(%ebp),%ebx

  struct proc *p;
  //获取锁
  acquire(&ptable.lock);
8010432a:	68 e0 a8 14 80       	push   $0x8014a8e0
8010432f:	e8 0c 02 00 00       	call   80104540 <acquire>
80104334:	83 c4 10             	add    $0x10,%esp
  //遍历当前所有进程，找到pid所属进程，并将其优先级改为priority
  for ( p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104337:	ba 14 a9 14 80       	mov    $0x8014a914,%edx
8010433c:	eb 10                	jmp    8010434e <changepri+0x2e>
8010433e:	66 90                	xchg   %ax,%ax
80104340:	81 c2 84 00 00 00    	add    $0x84,%edx
80104346:	81 fa 14 ca 14 80    	cmp    $0x8014ca14,%edx
8010434c:	73 0e                	jae    8010435c <changepri+0x3c>
    if ( p->pid == pid ) {
8010434e:	39 5a 10             	cmp    %ebx,0x10(%edx)
80104351:	75 ed                	jne    80104340 <changepri+0x20>
    p->priority = priority;
80104353:	8b 45 0c             	mov    0xc(%ebp),%eax
80104356:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
    break;
    }
  }
  //释放锁
  release(&ptable.lock);
8010435c:	83 ec 0c             	sub    $0xc,%esp
8010435f:	68 e0 a8 14 80       	push   $0x8014a8e0
80104364:	e8 97 03 00 00       	call   80104700 <release>
  return pid;
}
80104369:	89 d8                	mov    %ebx,%eax
8010436b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010436e:	c9                   	leave  
8010436f:	c3                   	ret    

80104370 <wakeup1p>:

//只唤醒特定信号量的进程的函数
void wakeup1p(void *chan) {
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	53                   	push   %ebx
80104374:	83 ec 10             	sub    $0x10,%esp
80104377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);//加锁
8010437a:	68 e0 a8 14 80       	push   $0x8014a8e0
8010437f:	e8 bc 01 00 00       	call   80104540 <acquire>
80104384:	83 c4 10             	add    $0x10,%esp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {//遍历进程
80104387:	b8 14 a9 14 80       	mov    $0x8014a914,%eax
8010438c:	eb 0e                	jmp    8010439c <wakeup1p+0x2c>
8010438e:	66 90                	xchg   %ax,%ax
80104390:	05 84 00 00 00       	add    $0x84,%eax
80104395:	3d 14 ca 14 80       	cmp    $0x8014ca14,%eax
8010439a:	73 12                	jae    801043ae <wakeup1p+0x3e>
    if(p->state == SLEEPING && p->chan == chan) {//找到该信号量对应进程，若其属于睡眠或阻塞
8010439c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043a0:	75 ee                	jne    80104390 <wakeup1p+0x20>
801043a2:	39 58 20             	cmp    %ebx,0x20(%eax)
801043a5:	75 e9                	jne    80104390 <wakeup1p+0x20>
      p->state = RUNNABLE;//让该进程处于就绪状态
801043a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      break;
    }
  }
  release(&ptable.lock);//释放锁
801043ae:	c7 45 08 e0 a8 14 80 	movl   $0x8014a8e0,0x8(%ebp)
}
801043b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b8:	c9                   	leave  
  release(&ptable.lock);//释放锁
801043b9:	e9 42 03 00 00       	jmp    80104700 <release>
801043be:	66 90                	xchg   %ax,%ax

801043c0 <myMalloc>:

//进程页表分配
void* myMalloc(int size){
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 08             	sub    $0x8,%esp
  //获取分配slab后低12位物理页地址偏移
  int page_offset=slab_alloc(proc->pgdir,(char*)proc->sz,size);
801043c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043cd:	ff 75 08             	pushl  0x8(%ebp)
801043d0:	ff 30                	pushl  (%eax)
801043d2:	ff 70 04             	pushl  0x4(%eax)
801043d5:	e8 e6 31 00 00       	call   801075c0 <slab_alloc>
  uint oldsize=proc->sz;//记录进程原本大小
801043da:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
801043e1:	8b 11                	mov    (%ecx),%edx
  proc->sz+=4096;//虚拟页之间增加间隔4kb也就是一页，让他们每个虚拟地址有个单独的页表项
801043e3:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
  return (void*)oldsize+page_offset;//返回分配后的物理地址末端
801043e9:	01 d0                	add    %edx,%eax
  proc->sz+=4096;//虚拟页之间增加间隔4kb也就是一页，让他们每个虚拟地址有个单独的页表项
801043eb:	89 19                	mov    %ebx,(%ecx)
}
801043ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043f0:	c9                   	leave  
801043f1:	c3                   	ret    
801043f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104400 <myFree>:

int myFree(void* va){
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	83 ec 10             	sub    $0x10,%esp
  int res = slab_free(proc->pgdir,va);//释放slab
80104406:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010440c:	ff 75 08             	pushl  0x8(%ebp)
8010440f:	ff 70 04             	pushl  0x4(%eax)
80104412:	e8 79 32 00 00       	call   80107690 <slab_free>
  return res;//返回结果
}
80104417:	c9                   	leave  
80104418:	c3                   	ret    
80104419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104420 <myFork>:

int myFork(void){
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	57                   	push   %edi
80104424:	56                   	push   %esi
80104425:	53                   	push   %ebx
80104426:	83 ec 18             	sub    $0x18,%esp
  int i,pid;
  struct proc *np;

  acquire(&ptable.lock);
80104429:	68 e0 a8 14 80       	push   $0x8014a8e0
8010442e:	e8 0d 01 00 00       	call   80104540 <acquire>
  if((np=allocproc())==0){
80104433:	e8 98 f4 ff ff       	call   801038d0 <allocproc>
80104438:	83 c4 10             	add    $0x10,%esp
8010443b:	85 c0                	test   %eax,%eax
8010443d:	0f 84 c5 00 00 00    	je     80104508 <myFork+0xe8>
80104443:	89 c3                	mov    %eax,%ebx
    release(&ptable.lock);
    return -1;
  }
  //复制页表变成copyuvm_onwrite
  np->pgdir = copyuvm_onwrite(proc->pgdir,proc->sz);
80104445:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010444b:	83 ec 08             	sub    $0x8,%esp
8010444e:	ff 30                	pushl  (%eax)
80104450:	ff 70 04             	pushl  0x4(%eax)
80104453:	e8 e8 32 00 00       	call   80107740 <copyuvm_onwrite>
80104458:	89 43 04             	mov    %eax,0x4(%ebx)

  np->sz = proc->sz;
8010445b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent=proc;
  *np->tf=*proc->tf;
80104461:	b9 13 00 00 00       	mov    $0x13,%ecx
80104466:	8b 7b 18             	mov    0x18(%ebx),%edi
80104469:	83 c4 10             	add    $0x10,%esp
  np->sz = proc->sz;
8010446c:	8b 00                	mov    (%eax),%eax
8010446e:	89 03                	mov    %eax,(%ebx)
  np->parent=proc;
80104470:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104476:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf=*proc->tf;
80104479:	8b 70 18             	mov    0x18(%eax),%esi
8010447c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax=0;
  for(i = 0; i < NOFILE; i++)
8010447e:	31 f6                	xor    %esi,%esi
  np->tf->eax=0;
80104480:	8b 43 18             	mov    0x18(%ebx),%eax
80104483:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010448a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80104491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->ofile[i])
80104498:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
8010449c:	85 c0                	test   %eax,%eax
8010449e:	74 17                	je     801044b7 <myFork+0x97>
      np->ofile[i] = filedup(proc->ofile[i]);
801044a0:	83 ec 0c             	sub    $0xc,%esp
801044a3:	50                   	push   %eax
801044a4:	e8 17 c9 ff ff       	call   80100dc0 <filedup>
801044a9:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
801044ad:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801044b4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
801044b7:	83 c6 01             	add    $0x1,%esi
801044ba:	83 fe 10             	cmp    $0x10,%esi
801044bd:	75 d9                	jne    80104498 <myFork+0x78>
  np->cwd = idup(proc->cwd);
801044bf:	83 ec 0c             	sub    $0xc,%esp
801044c2:	ff 72 68             	pushl  0x68(%edx)
801044c5:	e8 16 d1 ff ff       	call   801015e0 <idup>
801044ca:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801044cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044d3:	83 c4 0c             	add    $0xc,%esp
801044d6:	6a 10                	push   $0x10
801044d8:	83 c0 6c             	add    $0x6c,%eax
801044db:	50                   	push   %eax
801044dc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801044df:	50                   	push   %eax
801044e0:	e8 db 06 00 00       	call   80104bc0 <safestrcpy>

  pid = np->pid;

  np->state = RUNNABLE;
801044e5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pid = np->pid;
801044ec:	8b 73 10             	mov    0x10(%ebx),%esi

  release(&ptable.lock);
801044ef:	c7 04 24 e0 a8 14 80 	movl   $0x8014a8e0,(%esp)
801044f6:	e8 05 02 00 00       	call   80104700 <release>

  return pid;
801044fb:	83 c4 10             	add    $0x10,%esp
801044fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104501:	89 f0                	mov    %esi,%eax
80104503:	5b                   	pop    %ebx
80104504:	5e                   	pop    %esi
80104505:	5f                   	pop    %edi
80104506:	5d                   	pop    %ebp
80104507:	c3                   	ret    
    release(&ptable.lock);
80104508:	83 ec 0c             	sub    $0xc,%esp
    return -1;
8010450b:	be ff ff ff ff       	mov    $0xffffffff,%esi
    release(&ptable.lock);
80104510:	68 e0 a8 14 80       	push   $0x8014a8e0
80104515:	e8 e6 01 00 00       	call   80104700 <release>
    return -1;
8010451a:	83 c4 10             	add    $0x10,%esp
8010451d:	eb df                	jmp    801044fe <myFork+0xde>
8010451f:	90                   	nop

80104520 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104526:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104529:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010452f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104532:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104539:	5d                   	pop    %ebp
8010453a:	c3                   	ret    
8010453b:	90                   	nop
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104540 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	53                   	push   %ebx
80104544:	83 ec 04             	sub    $0x4,%esp
80104547:	9c                   	pushf  
80104548:	5a                   	pop    %edx
  asm volatile("cli");
80104549:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
8010454a:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80104551:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
80104557:	85 c0                	test   %eax,%eax
80104559:	75 0c                	jne    80104567 <acquire+0x27>
    cpu->intena = eflags & FL_IF;
8010455b:	81 e2 00 02 00 00    	and    $0x200,%edx
80104561:	89 91 b0 00 00 00    	mov    %edx,0xb0(%ecx)
  if(holding(lk))
80104567:	8b 55 08             	mov    0x8(%ebp),%edx
  cpu->ncli += 1;
8010456a:	83 c0 01             	add    $0x1,%eax
8010456d:	89 81 ac 00 00 00    	mov    %eax,0xac(%ecx)
  return lock->locked && lock->cpu == cpu;
80104573:	8b 02                	mov    (%edx),%eax
80104575:	85 c0                	test   %eax,%eax
80104577:	74 05                	je     8010457e <acquire+0x3e>
80104579:	39 4a 08             	cmp    %ecx,0x8(%edx)
8010457c:	74 74                	je     801045f2 <acquire+0xb2>
  asm volatile("lock; xchgl %0, %1" :
8010457e:	b9 01 00 00 00       	mov    $0x1,%ecx
80104583:	90                   	nop
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104588:	89 c8                	mov    %ecx,%eax
8010458a:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
8010458d:	85 c0                	test   %eax,%eax
8010458f:	75 f7                	jne    80104588 <acquire+0x48>
  __sync_synchronize();
80104591:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = cpu;
80104596:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104599:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  for(i = 0; i < 10; i++){
8010459f:	31 d2                	xor    %edx,%edx
  lk->cpu = cpu;
801045a1:	89 41 08             	mov    %eax,0x8(%ecx)
  getcallerpcs(&lk, lk->pcs);
801045a4:	83 c1 0c             	add    $0xc,%ecx
  ebp = (uint*)v - 2;
801045a7:	89 e8                	mov    %ebp,%eax
801045a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045b0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045bc:	77 1a                	ja     801045d8 <acquire+0x98>
    pcs[i] = ebp[1];     // saved %eip
801045be:	8b 58 04             	mov    0x4(%eax),%ebx
801045c1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801045c4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801045c7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801045c9:	83 fa 0a             	cmp    $0xa,%edx
801045cc:	75 e2                	jne    801045b0 <acquire+0x70>
}
801045ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d1:	c9                   	leave  
801045d2:	c3                   	ret    
801045d3:	90                   	nop
801045d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045d8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801045db:	83 c1 28             	add    $0x28,%ecx
801045de:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801045e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801045e6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801045e9:	39 c8                	cmp    %ecx,%eax
801045eb:	75 f3                	jne    801045e0 <acquire+0xa0>
}
801045ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f0:	c9                   	leave  
801045f1:	c3                   	ret    
    panic("acquire");
801045f2:	83 ec 0c             	sub    $0xc,%esp
801045f5:	68 b0 7f 10 80       	push   $0x80107fb0
801045fa:	e8 71 bd ff ff       	call   80100370 <panic>
801045ff:	90                   	nop

80104600 <getcallerpcs>:
{
80104600:	55                   	push   %ebp
  for(i = 0; i < 10; i++){
80104601:	31 d2                	xor    %edx,%edx
{
80104603:	89 e5                	mov    %esp,%ebp
80104605:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104606:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104609:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010460c:	83 e8 08             	sub    $0x8,%eax
8010460f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104610:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104616:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010461c:	77 1a                	ja     80104638 <getcallerpcs+0x38>
    pcs[i] = ebp[1];     // saved %eip
8010461e:	8b 58 04             	mov    0x4(%eax),%ebx
80104621:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104624:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104627:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104629:	83 fa 0a             	cmp    $0xa,%edx
8010462c:	75 e2                	jne    80104610 <getcallerpcs+0x10>
}
8010462e:	5b                   	pop    %ebx
8010462f:	5d                   	pop    %ebp
80104630:	c3                   	ret    
80104631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104638:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010463b:	83 c1 28             	add    $0x28,%ecx
8010463e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104646:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104649:	39 c1                	cmp    %eax,%ecx
8010464b:	75 f3                	jne    80104640 <getcallerpcs+0x40>
}
8010464d:	5b                   	pop    %ebx
8010464e:	5d                   	pop    %ebp
8010464f:	c3                   	ret    

80104650 <holding>:
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104656:	8b 02                	mov    (%edx),%eax
80104658:	85 c0                	test   %eax,%eax
8010465a:	74 14                	je     80104670 <holding+0x20>
8010465c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104662:	39 42 08             	cmp    %eax,0x8(%edx)
}
80104665:	5d                   	pop    %ebp
  return lock->locked && lock->cpu == cpu;
80104666:	0f 94 c0             	sete   %al
80104669:	0f b6 c0             	movzbl %al,%eax
}
8010466c:	c3                   	ret    
8010466d:	8d 76 00             	lea    0x0(%esi),%esi
80104670:	31 c0                	xor    %eax,%eax
80104672:	5d                   	pop    %ebp
80104673:	c3                   	ret    
80104674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010467a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104680 <pushcli>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104683:	9c                   	pushf  
80104684:	59                   	pop    %ecx
  asm volatile("cli");
80104685:	fa                   	cli    
  if(cpu->ncli == 0)
80104686:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010468d:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104693:	85 c0                	test   %eax,%eax
80104695:	75 0c                	jne    801046a3 <pushcli+0x23>
    cpu->intena = eflags & FL_IF;
80104697:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010469d:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
  cpu->ncli += 1;
801046a3:	83 c0 01             	add    $0x1,%eax
801046a6:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
}
801046ac:	5d                   	pop    %ebp
801046ad:	c3                   	ret    
801046ae:	66 90                	xchg   %ax,%ax

801046b0 <popcli>:

void
popcli(void)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046b6:	9c                   	pushf  
801046b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046b8:	f6 c4 02             	test   $0x2,%ah
801046bb:	75 2c                	jne    801046e9 <popcli+0x39>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
801046bd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801046c4:	83 aa ac 00 00 00 01 	subl   $0x1,0xac(%edx)
801046cb:	78 0f                	js     801046dc <popcli+0x2c>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
801046cd:	75 0b                	jne    801046da <popcli+0x2a>
801046cf:	8b 82 b0 00 00 00    	mov    0xb0(%edx),%eax
801046d5:	85 c0                	test   %eax,%eax
801046d7:	74 01                	je     801046da <popcli+0x2a>
  asm volatile("sti");
801046d9:	fb                   	sti    
    sti();
}
801046da:	c9                   	leave  
801046db:	c3                   	ret    
    panic("popcli");
801046dc:	83 ec 0c             	sub    $0xc,%esp
801046df:	68 cf 7f 10 80       	push   $0x80107fcf
801046e4:	e8 87 bc ff ff       	call   80100370 <panic>
    panic("popcli - interruptible");
801046e9:	83 ec 0c             	sub    $0xc,%esp
801046ec:	68 b8 7f 10 80       	push   $0x80107fb8
801046f1:	e8 7a bc ff ff       	call   80100370 <panic>
801046f6:	8d 76 00             	lea    0x0(%esi),%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <release>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	83 ec 08             	sub    $0x8,%esp
80104706:	8b 45 08             	mov    0x8(%ebp),%eax
  return lock->locked && lock->cpu == cpu;
80104709:	8b 10                	mov    (%eax),%edx
8010470b:	85 d2                	test   %edx,%edx
8010470d:	74 2b                	je     8010473a <release+0x3a>
8010470f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104716:	39 50 08             	cmp    %edx,0x8(%eax)
80104719:	75 1f                	jne    8010473a <release+0x3a>
  lk->pcs[0] = 0;
8010471b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104722:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  __sync_synchronize();
80104729:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->locked = 0;
8010472e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80104734:	c9                   	leave  
  popcli();
80104735:	e9 76 ff ff ff       	jmp    801046b0 <popcli>
    panic("release");
8010473a:	83 ec 0c             	sub    $0xc,%esp
8010473d:	68 d6 7f 10 80       	push   $0x80107fd6
80104742:	e8 29 bc ff ff       	call   80100370 <panic>
80104747:	89 f6                	mov    %esi,%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104750 <initsem>:
//资源计数初值为0
int sem_used_count =0;
//定义sems数组
struct sem sems[SEM_MAX_NUM];
//初始化信号量
void initsem () {
80104750:	55                   	push   %ebp
80104751:	b8 20 ca 14 80       	mov    $0x8014ca20,%eax
80104756:	89 e5                	mov    %esp,%ebp
80104758:	90                   	nop
80104759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lk->name = name;
80104760:	c7 40 04 de 7f 10 80 	movl   $0x80107fde,0x4(%eax)
  lk->locked = 0;
80104767:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010476d:	83 c0 40             	add    $0x40,%eax
  lk->cpu = 0;
80104770:	c7 40 c8 00 00 00 00 	movl   $0x0,-0x38(%eax)
int i;
//对每个信号量添加自旋锁
for(i=0;i<SEM_MAX_NUM;i++){
  initlock(&(sems[i].lock), "semaphore");
  sems[i].allocated=0;//每个信号量状态初始化为未分配
80104777:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
for(i=0;i<SEM_MAX_NUM;i++){
8010477e:	3d 20 ea 14 80       	cmp    $0x8014ea20,%eax
80104783:	75 db                	jne    80104760 <initsem+0x10>
}
return;
}
80104785:	5d                   	pop    %ebp
80104786:	c3                   	ret    
80104787:	89 f6                	mov    %esi,%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104790 <sys_sem_create>:

//创建信号量
int sys_sem_create() {
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
  int n_sem, i;
  if(argint(0, &n_sem) < 0 )//error检测
80104795:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sem_create() {
80104798:	83 ec 18             	sub    $0x18,%esp
  if(argint(0, &n_sem) < 0 )//error检测
8010479b:	50                   	push   %eax
8010479c:	6a 00                	push   $0x0
8010479e:	e8 1d 05 00 00       	call   80104cc0 <argint>
801047a3:	83 c4 10             	add    $0x10,%esp
801047a6:	85 c0                	test   %eax,%eax
801047a8:	78 76                	js     80104820 <sys_sem_create+0x90>
801047aa:	bb 20 ca 14 80       	mov    $0x8014ca20,%ebx
    return -1;
  for(i = 0; i < SEM_MAX_NUM; i++) {
801047af:	31 f6                	xor    %esi,%esi
801047b1:	eb 1f                	jmp    801047d2 <sys_sem_create+0x42>
801047b3:	90                   	nop
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sems[i].resource_count = n_sem;
      cprintf("create %d sem\n",i);
      release(&sems[i].lock);//解该信号量自旋锁
      return i;
    }
    release(&sems[i].lock);//解开信号量id自旋锁
801047b8:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < SEM_MAX_NUM; i++) {
801047bb:	83 c6 01             	add    $0x1,%esi
    release(&sems[i].lock);//解开信号量id自旋锁
801047be:	53                   	push   %ebx
801047bf:	83 c3 40             	add    $0x40,%ebx
801047c2:	e8 39 ff ff ff       	call   80104700 <release>
  for(i = 0; i < SEM_MAX_NUM; i++) {
801047c7:	83 c4 10             	add    $0x10,%esp
801047ca:	81 fe 80 00 00 00    	cmp    $0x80,%esi
801047d0:	74 4e                	je     80104820 <sys_sem_create+0x90>
    acquire(&sems[i].lock);//加自旋锁
801047d2:	83 ec 0c             	sub    $0xc,%esp
801047d5:	53                   	push   %ebx
801047d6:	e8 65 fd ff ff       	call   80104540 <acquire>
    if(sems[i].allocated == 0) {//如果该信号量未被分配，那就将参数的信号量分配给他
801047db:	8b 43 3c             	mov    0x3c(%ebx),%eax
801047de:	83 c4 10             	add    $0x10,%esp
801047e1:	85 c0                	test   %eax,%eax
801047e3:	75 d3                	jne    801047b8 <sys_sem_create+0x28>
      cprintf("create %d sem\n",i);
801047e5:	83 ec 08             	sub    $0x8,%esp
      sems[i].resource_count = n_sem;
801047e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
      sems[i].allocated = 1;
801047eb:	89 f0                	mov    %esi,%eax
      cprintf("create %d sem\n",i);
801047ed:	56                   	push   %esi
801047ee:	68 e8 7f 10 80       	push   $0x80107fe8
      sems[i].allocated = 1;
801047f3:	c1 e0 06             	shl    $0x6,%eax
801047f6:	c7 80 5c ca 14 80 01 	movl   $0x1,-0x7feb35a4(%eax)
801047fd:	00 00 00 
      sems[i].resource_count = n_sem;
80104800:	89 90 54 ca 14 80    	mov    %edx,-0x7feb35ac(%eax)
      cprintf("create %d sem\n",i);
80104806:	e8 35 be ff ff       	call   80100640 <cprintf>
      release(&sems[i].lock);//解该信号量自旋锁
8010480b:	89 1c 24             	mov    %ebx,(%esp)
8010480e:	e8 ed fe ff ff       	call   80104700 <release>
      return i;
80104813:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
}
80104816:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104819:	89 f0                	mov    %esi,%eax
8010481b:	5b                   	pop    %ebx
8010481c:	5e                   	pop    %esi
8010481d:	5d                   	pop    %ebp
8010481e:	c3                   	ret    
8010481f:	90                   	nop
80104820:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104823:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
80104828:	89 f0                	mov    %esi,%eax
8010482a:	5b                   	pop    %ebx
8010482b:	5e                   	pop    %esi
8010482c:	5d                   	pop    %ebp
8010482d:	c3                   	ret    
8010482e:	66 90                	xchg   %ax,%ax

80104830 <sys_sem_free>:
//释放信号量函数
int sys_sem_free(){
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	83 ec 20             	sub    $0x20,%esp
  int id;//传进来的参数 为信号量数组下标
  if(argint(0,&id)<0)
80104836:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104839:	50                   	push   %eax
8010483a:	6a 00                	push   $0x0
8010483c:	e8 7f 04 00 00       	call   80104cc0 <argint>
80104841:	83 c4 10             	add    $0x10,%esp
80104844:	85 c0                	test   %eax,%eax
80104846:	78 70                	js     801048b8 <sys_sem_free+0x88>
    return -1;
  acquire(&sems[id].lock);//加锁
80104848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484b:	83 ec 0c             	sub    $0xc,%esp
8010484e:	c1 e0 06             	shl    $0x6,%eax
80104851:	05 20 ca 14 80       	add    $0x8014ca20,%eax
80104856:	50                   	push   %eax
80104857:	e8 e4 fc ff ff       	call   80104540 <acquire>
  if(sems[id].allocated == 1 && sems[id].resource_count > 0){//信号量被分配使用且信号量资源计数大于0
8010485c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010485f:	83 c4 10             	add    $0x10,%esp
80104862:	89 c2                	mov    %eax,%edx
80104864:	c1 e2 06             	shl    $0x6,%edx
80104867:	81 c2 20 ca 14 80    	add    $0x8014ca20,%edx
8010486d:	83 7a 3c 01          	cmpl   $0x1,0x3c(%edx)
80104871:	74 1d                	je     80104890 <sys_sem_free+0x60>
    sems[id].allocated = 0;//释放信号量
    cprintf("free %d sem\n", id);
  }
  release(&sems[id].lock);//解锁
80104873:	c1 e0 06             	shl    $0x6,%eax
80104876:	83 ec 0c             	sub    $0xc,%esp
80104879:	05 20 ca 14 80       	add    $0x8014ca20,%eax
8010487e:	50                   	push   %eax
8010487f:	e8 7c fe ff ff       	call   80104700 <release>
  return 0;
80104884:	83 c4 10             	add    $0x10,%esp
80104887:	31 c0                	xor    %eax,%eax
}
80104889:	c9                   	leave  
8010488a:	c3                   	ret    
8010488b:	90                   	nop
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(sems[id].allocated == 1 && sems[id].resource_count > 0){//信号量被分配使用且信号量资源计数大于0
80104890:	8b 4a 34             	mov    0x34(%edx),%ecx
80104893:	85 c9                	test   %ecx,%ecx
80104895:	7e dc                	jle    80104873 <sys_sem_free+0x43>
    cprintf("free %d sem\n", id);
80104897:	83 ec 08             	sub    $0x8,%esp
    sems[id].allocated = 0;//释放信号量
8010489a:	c7 42 3c 00 00 00 00 	movl   $0x0,0x3c(%edx)
    cprintf("free %d sem\n", id);
801048a1:	50                   	push   %eax
801048a2:	68 f7 7f 10 80       	push   $0x80107ff7
801048a7:	e8 94 bd ff ff       	call   80100640 <cprintf>
801048ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048af:	83 c4 10             	add    $0x10,%esp
801048b2:	eb bf                	jmp    80104873 <sys_sem_free+0x43>
801048b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048bd:	c9                   	leave  
801048be:	c3                   	ret    
801048bf:	90                   	nop

801048c0 <sys_sem_p>:
//信号量--函数
int sys_sem_p()
{ 
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	83 ec 20             	sub    $0x20,%esp
  int id;//穿的参数  为信号量下标
  if(argint(0, &id) < 0)
801048c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048c9:	50                   	push   %eax
801048ca:	6a 00                	push   $0x0
801048cc:	e8 ef 03 00 00       	call   80104cc0 <argint>
801048d1:	83 c4 10             	add    $0x10,%esp
801048d4:	85 c0                	test   %eax,%eax
801048d6:	78 68                	js     80104940 <sys_sem_p+0x80>
    return -1;
  acquire(&sems[id].lock);//加锁
801048d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048db:	83 ec 0c             	sub    $0xc,%esp
801048de:	c1 e0 06             	shl    $0x6,%eax
801048e1:	05 20 ca 14 80       	add    $0x8014ca20,%eax
801048e6:	50                   	push   %eax
801048e7:	e8 54 fc ff ff       	call   80104540 <acquire>
  sems[id]. resource_count--;//资源计数-1
801048ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  if(sems[id].resource_count<0) //首次进入、或被唤醒时，资源不足
801048ef:	83 c4 10             	add    $0x10,%esp
  sems[id]. resource_count--;//资源计数-1
801048f2:	c1 e0 06             	shl    $0x6,%eax
801048f5:	05 20 ca 14 80       	add    $0x8014ca20,%eax
801048fa:	8b 48 34             	mov    0x34(%eax),%ecx
801048fd:	8d 51 ff             	lea    -0x1(%ecx),%edx
  if(sems[id].resource_count<0) //首次进入、或被唤醒时，资源不足
80104900:	85 d2                	test   %edx,%edx
  sems[id]. resource_count--;//资源计数-1
80104902:	89 50 34             	mov    %edx,0x34(%eax)
  if(sems[id].resource_count<0) //首次进入、或被唤醒时，资源不足
80104905:	78 19                	js     80104920 <sys_sem_p+0x60>
    sleep(&sems[id],&sems[id].lock); //睡眠（会释放 sems[id].lock 才阻塞）
  release(&sems[id].lock); //解锁（唤醒到此处时，重新持有 sems[id].lock）
80104907:	83 ec 0c             	sub    $0xc,%esp
8010490a:	50                   	push   %eax
8010490b:	e8 f0 fd ff ff       	call   80104700 <release>
  return 0; //此时获得信号量资源
80104910:	83 c4 10             	add    $0x10,%esp
80104913:	31 c0                	xor    %eax,%eax
}
80104915:	c9                   	leave  
80104916:	c3                   	ret    
80104917:	89 f6                	mov    %esi,%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    sleep(&sems[id],&sems[id].lock); //睡眠（会释放 sems[id].lock 才阻塞）
80104920:	83 ec 08             	sub    $0x8,%esp
80104923:	50                   	push   %eax
80104924:	50                   	push   %eax
80104925:	e8 86 f6 ff ff       	call   80103fb0 <sleep>
8010492a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010492d:	83 c4 10             	add    $0x10,%esp
80104930:	c1 e0 06             	shl    $0x6,%eax
80104933:	05 20 ca 14 80       	add    $0x8014ca20,%eax
80104938:	eb cd                	jmp    80104907 <sys_sem_p+0x47>
8010493a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104945:	c9                   	leave  
80104946:	c3                   	ret    
80104947:	89 f6                	mov    %esi,%esi
80104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104950 <sys_sem_v>:

//信号量++函数
int sys_sem_v(int sem_id)
{ 
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	83 ec 20             	sub    $0x20,%esp
  int id;//传信号量下标参数
  if(argint(0,&id)<0)
80104956:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104959:	50                   	push   %eax
8010495a:	6a 00                	push   $0x0
8010495c:	e8 5f 03 00 00       	call   80104cc0 <argint>
80104961:	83 c4 10             	add    $0x10,%esp
80104964:	85 c0                	test   %eax,%eax
80104966:	78 68                	js     801049d0 <sys_sem_v+0x80>
    return -1;
  acquire(&sems[id].lock);//加锁
80104968:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010496b:	83 ec 0c             	sub    $0xc,%esp
8010496e:	c1 e0 06             	shl    $0x6,%eax
80104971:	05 20 ca 14 80       	add    $0x8014ca20,%eax
80104976:	50                   	push   %eax
80104977:	e8 c4 fb ff ff       	call   80104540 <acquire>
  sems[id]. resource_count+=1; //由于释放了信号量，资源计数++
8010497c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  if(sems[id].resource_count<1) //有阻塞等待该资源的进程
8010497f:	83 c4 10             	add    $0x10,%esp
  sems[id]. resource_count+=1; //由于释放了信号量，资源计数++
80104982:	c1 e0 06             	shl    $0x6,%eax
80104985:	05 20 ca 14 80       	add    $0x8014ca20,%eax
8010498a:	8b 48 34             	mov    0x34(%eax),%ecx
8010498d:	8d 51 01             	lea    0x1(%ecx),%edx
  if(sems[id].resource_count<1) //有阻塞等待该资源的进程
80104990:	85 d2                	test   %edx,%edx
  sems[id]. resource_count+=1; //由于释放了信号量，资源计数++
80104992:	89 50 34             	mov    %edx,0x34(%eax)
  if(sems[id].resource_count<1) //有阻塞等待该资源的进程
80104995:	7e 19                	jle    801049b0 <sys_sem_v+0x60>
    wakeup1p(&sems[id]); //唤醒等待该资源的 1 个进程
  release(&sems[id].lock); //释放锁
80104997:	83 ec 0c             	sub    $0xc,%esp
8010499a:	50                   	push   %eax
8010499b:	e8 60 fd ff ff       	call   80104700 <release>
  return 0;
801049a0:	83 c4 10             	add    $0x10,%esp
801049a3:	31 c0                	xor    %eax,%eax
}
801049a5:	c9                   	leave  
801049a6:	c3                   	ret    
801049a7:	89 f6                	mov    %esi,%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    wakeup1p(&sems[id]); //唤醒等待该资源的 1 个进程
801049b0:	83 ec 0c             	sub    $0xc,%esp
801049b3:	50                   	push   %eax
801049b4:	e8 b7 f9 ff ff       	call   80104370 <wakeup1p>
801049b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049bc:	83 c4 10             	add    $0x10,%esp
801049bf:	c1 e0 06             	shl    $0x6,%eax
801049c2:	05 20 ca 14 80       	add    $0x8014ca20,%eax
801049c7:	eb ce                	jmp    80104997 <sys_sem_v+0x47>
801049c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049d5:	c9                   	leave  
801049d6:	c3                   	ret    
801049d7:	66 90                	xchg   %ax,%ax
801049d9:	66 90                	xchg   %ax,%ax
801049db:	66 90                	xchg   %ax,%ax
801049dd:	66 90                	xchg   %ax,%ax
801049df:	90                   	nop

801049e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	57                   	push   %edi
801049e4:	53                   	push   %ebx
801049e5:	8b 55 08             	mov    0x8(%ebp),%edx
801049e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801049eb:	f6 c2 03             	test   $0x3,%dl
801049ee:	75 05                	jne    801049f5 <memset+0x15>
801049f0:	f6 c1 03             	test   $0x3,%cl
801049f3:	74 13                	je     80104a08 <memset+0x28>
  asm volatile("cld; rep stosb" :
801049f5:	89 d7                	mov    %edx,%edi
801049f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801049fa:	fc                   	cld    
801049fb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801049fd:	5b                   	pop    %ebx
801049fe:	89 d0                	mov    %edx,%eax
80104a00:	5f                   	pop    %edi
80104a01:	5d                   	pop    %ebp
80104a02:	c3                   	ret    
80104a03:	90                   	nop
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104a08:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a0c:	c1 e9 02             	shr    $0x2,%ecx
80104a0f:	89 f8                	mov    %edi,%eax
80104a11:	89 fb                	mov    %edi,%ebx
80104a13:	c1 e0 18             	shl    $0x18,%eax
80104a16:	c1 e3 10             	shl    $0x10,%ebx
80104a19:	09 d8                	or     %ebx,%eax
80104a1b:	09 f8                	or     %edi,%eax
80104a1d:	c1 e7 08             	shl    $0x8,%edi
80104a20:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104a22:	89 d7                	mov    %edx,%edi
80104a24:	fc                   	cld    
80104a25:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104a27:	5b                   	pop    %ebx
80104a28:	89 d0                	mov    %edx,%eax
80104a2a:	5f                   	pop    %edi
80104a2b:	5d                   	pop    %ebp
80104a2c:	c3                   	ret    
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi

80104a30 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	57                   	push   %edi
80104a34:	56                   	push   %esi
80104a35:	53                   	push   %ebx
80104a36:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a39:	8b 75 08             	mov    0x8(%ebp),%esi
80104a3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a3f:	85 db                	test   %ebx,%ebx
80104a41:	74 29                	je     80104a6c <memcmp+0x3c>
    if(*s1 != *s2)
80104a43:	0f b6 16             	movzbl (%esi),%edx
80104a46:	0f b6 0f             	movzbl (%edi),%ecx
80104a49:	38 d1                	cmp    %dl,%cl
80104a4b:	75 2b                	jne    80104a78 <memcmp+0x48>
80104a4d:	b8 01 00 00 00       	mov    $0x1,%eax
80104a52:	eb 14                	jmp    80104a68 <memcmp+0x38>
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a58:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104a5c:	83 c0 01             	add    $0x1,%eax
80104a5f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104a64:	38 ca                	cmp    %cl,%dl
80104a66:	75 10                	jne    80104a78 <memcmp+0x48>
  while(n-- > 0){
80104a68:	39 d8                	cmp    %ebx,%eax
80104a6a:	75 ec                	jne    80104a58 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104a6c:	5b                   	pop    %ebx
  return 0;
80104a6d:	31 c0                	xor    %eax,%eax
}
80104a6f:	5e                   	pop    %esi
80104a70:	5f                   	pop    %edi
80104a71:	5d                   	pop    %ebp
80104a72:	c3                   	ret    
80104a73:	90                   	nop
80104a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104a78:	0f b6 c2             	movzbl %dl,%eax
}
80104a7b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104a7c:	29 c8                	sub    %ecx,%eax
}
80104a7e:	5e                   	pop    %esi
80104a7f:	5f                   	pop    %edi
80104a80:	5d                   	pop    %ebp
80104a81:	c3                   	ret    
80104a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	53                   	push   %ebx
80104a95:	8b 45 08             	mov    0x8(%ebp),%eax
80104a98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a9b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a9e:	39 c3                	cmp    %eax,%ebx
80104aa0:	73 26                	jae    80104ac8 <memmove+0x38>
80104aa2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104aa5:	39 c8                	cmp    %ecx,%eax
80104aa7:	73 1f                	jae    80104ac8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104aa9:	85 f6                	test   %esi,%esi
80104aab:	8d 56 ff             	lea    -0x1(%esi),%edx
80104aae:	74 0f                	je     80104abf <memmove+0x2f>
      *--d = *--s;
80104ab0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ab4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104ab7:	83 ea 01             	sub    $0x1,%edx
80104aba:	83 fa ff             	cmp    $0xffffffff,%edx
80104abd:	75 f1                	jne    80104ab0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104abf:	5b                   	pop    %ebx
80104ac0:	5e                   	pop    %esi
80104ac1:	5d                   	pop    %ebp
80104ac2:	c3                   	ret    
80104ac3:	90                   	nop
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104ac8:	31 d2                	xor    %edx,%edx
80104aca:	85 f6                	test   %esi,%esi
80104acc:	74 f1                	je     80104abf <memmove+0x2f>
80104ace:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104ad0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ad4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ad7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104ada:	39 d6                	cmp    %edx,%esi
80104adc:	75 f2                	jne    80104ad0 <memmove+0x40>
}
80104ade:	5b                   	pop    %ebx
80104adf:	5e                   	pop    %esi
80104ae0:	5d                   	pop    %ebp
80104ae1:	c3                   	ret    
80104ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104af0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104af3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104af4:	eb 9a                	jmp    80104a90 <memmove>
80104af6:	8d 76 00             	lea    0x0(%esi),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	8b 7d 10             	mov    0x10(%ebp),%edi
80104b08:	53                   	push   %ebx
80104b09:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104b0f:	85 ff                	test   %edi,%edi
80104b11:	74 2f                	je     80104b42 <strncmp+0x42>
80104b13:	0f b6 01             	movzbl (%ecx),%eax
80104b16:	0f b6 1e             	movzbl (%esi),%ebx
80104b19:	84 c0                	test   %al,%al
80104b1b:	74 37                	je     80104b54 <strncmp+0x54>
80104b1d:	38 c3                	cmp    %al,%bl
80104b1f:	75 33                	jne    80104b54 <strncmp+0x54>
80104b21:	01 f7                	add    %esi,%edi
80104b23:	eb 13                	jmp    80104b38 <strncmp+0x38>
80104b25:	8d 76 00             	lea    0x0(%esi),%esi
80104b28:	0f b6 01             	movzbl (%ecx),%eax
80104b2b:	84 c0                	test   %al,%al
80104b2d:	74 21                	je     80104b50 <strncmp+0x50>
80104b2f:	0f b6 1a             	movzbl (%edx),%ebx
80104b32:	89 d6                	mov    %edx,%esi
80104b34:	38 d8                	cmp    %bl,%al
80104b36:	75 1c                	jne    80104b54 <strncmp+0x54>
    n--, p++, q++;
80104b38:	8d 56 01             	lea    0x1(%esi),%edx
80104b3b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104b3e:	39 fa                	cmp    %edi,%edx
80104b40:	75 e6                	jne    80104b28 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104b42:	5b                   	pop    %ebx
    return 0;
80104b43:	31 c0                	xor    %eax,%eax
}
80104b45:	5e                   	pop    %esi
80104b46:	5f                   	pop    %edi
80104b47:	5d                   	pop    %ebp
80104b48:	c3                   	ret    
80104b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b50:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104b54:	29 d8                	sub    %ebx,%eax
}
80104b56:	5b                   	pop    %ebx
80104b57:	5e                   	pop    %esi
80104b58:	5f                   	pop    %edi
80104b59:	5d                   	pop    %ebp
80104b5a:	c3                   	ret    
80104b5b:	90                   	nop
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b60 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
80104b65:	8b 45 08             	mov    0x8(%ebp),%eax
80104b68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b6e:	89 c2                	mov    %eax,%edx
80104b70:	eb 19                	jmp    80104b8b <strncpy+0x2b>
80104b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b78:	83 c3 01             	add    $0x1,%ebx
80104b7b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104b7f:	83 c2 01             	add    $0x1,%edx
80104b82:	84 c9                	test   %cl,%cl
80104b84:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b87:	74 09                	je     80104b92 <strncpy+0x32>
80104b89:	89 f1                	mov    %esi,%ecx
80104b8b:	85 c9                	test   %ecx,%ecx
80104b8d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104b90:	7f e6                	jg     80104b78 <strncpy+0x18>
    ;
  while(n-- > 0)
80104b92:	31 c9                	xor    %ecx,%ecx
80104b94:	85 f6                	test   %esi,%esi
80104b96:	7e 17                	jle    80104baf <strncpy+0x4f>
80104b98:	90                   	nop
80104b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ba0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ba4:	89 f3                	mov    %esi,%ebx
80104ba6:	83 c1 01             	add    $0x1,%ecx
80104ba9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104bab:	85 db                	test   %ebx,%ebx
80104bad:	7f f1                	jg     80104ba0 <strncpy+0x40>
  return os;
}
80104baf:	5b                   	pop    %ebx
80104bb0:	5e                   	pop    %esi
80104bb1:	5d                   	pop    %ebp
80104bb2:	c3                   	ret    
80104bb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104bc8:	8b 45 08             	mov    0x8(%ebp),%eax
80104bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104bce:	85 c9                	test   %ecx,%ecx
80104bd0:	7e 26                	jle    80104bf8 <safestrcpy+0x38>
80104bd2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104bd6:	89 c1                	mov    %eax,%ecx
80104bd8:	eb 17                	jmp    80104bf1 <safestrcpy+0x31>
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104be0:	83 c2 01             	add    $0x1,%edx
80104be3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104be7:	83 c1 01             	add    $0x1,%ecx
80104bea:	84 db                	test   %bl,%bl
80104bec:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104bef:	74 04                	je     80104bf5 <safestrcpy+0x35>
80104bf1:	39 f2                	cmp    %esi,%edx
80104bf3:	75 eb                	jne    80104be0 <safestrcpy+0x20>
    ;
  *s = 0;
80104bf5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104bf8:	5b                   	pop    %ebx
80104bf9:	5e                   	pop    %esi
80104bfa:	5d                   	pop    %ebp
80104bfb:	c3                   	ret    
80104bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c00 <strlen>:

int
strlen(const char *s)
{
80104c00:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c01:	31 c0                	xor    %eax,%eax
{
80104c03:	89 e5                	mov    %esp,%ebp
80104c05:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c08:	80 3a 00             	cmpb   $0x0,(%edx)
80104c0b:	74 0c                	je     80104c19 <strlen+0x19>
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi
80104c10:	83 c0 01             	add    $0x1,%eax
80104c13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c17:	75 f7                	jne    80104c10 <strlen+0x10>
    ;
  return n;
}
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    

80104c1b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c1b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c1f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104c23:	55                   	push   %ebp
  pushl %ebx
80104c24:	53                   	push   %ebx
  pushl %esi
80104c25:	56                   	push   %esi
  pushl %edi
80104c26:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c27:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c29:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104c2b:	5f                   	pop    %edi
  popl %esi
80104c2c:	5e                   	pop    %esi
  popl %ebx
80104c2d:	5b                   	pop    %ebx
  popl %ebp
80104c2e:	5d                   	pop    %ebp
  ret
80104c2f:	c3                   	ret    

80104c30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c30:	55                   	push   %ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104c31:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
{
80104c38:	89 e5                	mov    %esp,%ebp
80104c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
80104c3d:	8b 12                	mov    (%edx),%edx
80104c3f:	39 c2                	cmp    %eax,%edx
80104c41:	76 15                	jbe    80104c58 <fetchint+0x28>
80104c43:	8d 48 04             	lea    0x4(%eax),%ecx
80104c46:	39 ca                	cmp    %ecx,%edx
80104c48:	72 0e                	jb     80104c58 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
80104c4a:	8b 10                	mov    (%eax),%edx
80104c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4f:	89 10                	mov    %edx,(%eax)
  return 0;
80104c51:	31 c0                	xor    %eax,%eax
}
80104c53:	5d                   	pop    %ebp
80104c54:	c3                   	ret    
80104c55:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c5d:	5d                   	pop    %ebp
80104c5e:	c3                   	ret    
80104c5f:	90                   	nop

80104c60 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c60:	55                   	push   %ebp
  char *s, *ep;

  if(addr >= proc->sz)
80104c61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
{
80104c67:	89 e5                	mov    %esp,%ebp
80104c69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz)
80104c6c:	39 08                	cmp    %ecx,(%eax)
80104c6e:	76 2c                	jbe    80104c9c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104c70:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c73:	89 c8                	mov    %ecx,%eax
80104c75:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104c77:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c7e:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104c80:	39 d1                	cmp    %edx,%ecx
80104c82:	73 18                	jae    80104c9c <fetchstr+0x3c>
    if(*s == 0)
80104c84:	80 39 00             	cmpb   $0x0,(%ecx)
80104c87:	75 0c                	jne    80104c95 <fetchstr+0x35>
80104c89:	eb 25                	jmp    80104cb0 <fetchstr+0x50>
80104c8b:	90                   	nop
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c90:	80 38 00             	cmpb   $0x0,(%eax)
80104c93:	74 13                	je     80104ca8 <fetchstr+0x48>
  for(s = *pp; s < ep; s++)
80104c95:	83 c0 01             	add    $0x1,%eax
80104c98:	39 c2                	cmp    %eax,%edx
80104c9a:	77 f4                	ja     80104c90 <fetchstr+0x30>
    return -1;
80104c9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  return -1;
}
80104ca1:	5d                   	pop    %ebp
80104ca2:	c3                   	ret    
80104ca3:	90                   	nop
80104ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ca8:	29 c8                	sub    %ecx,%eax
80104caa:	5d                   	pop    %ebp
80104cab:	c3                   	ret    
80104cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
80104cb0:	31 c0                	xor    %eax,%eax
}
80104cb2:	5d                   	pop    %ebp
80104cb3:	c3                   	ret    
80104cb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104cc0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104cc0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
{
80104cc7:	55                   	push   %ebp
80104cc8:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104cca:	8b 42 18             	mov    0x18(%edx),%eax
80104ccd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
80104cd0:	8b 12                	mov    (%edx),%edx
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104cd2:	8b 40 44             	mov    0x44(%eax),%eax
80104cd5:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104cd8:	8d 48 04             	lea    0x4(%eax),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
80104cdb:	39 d1                	cmp    %edx,%ecx
80104cdd:	73 19                	jae    80104cf8 <argint+0x38>
80104cdf:	8d 48 08             	lea    0x8(%eax),%ecx
80104ce2:	39 ca                	cmp    %ecx,%edx
80104ce4:	72 12                	jb     80104cf8 <argint+0x38>
  *ip = *(int*)(addr);
80104ce6:	8b 50 04             	mov    0x4(%eax),%edx
80104ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cec:	89 10                	mov    %edx,(%eax)
  return 0;
80104cee:	31 c0                	xor    %eax,%eax
}
80104cf0:	5d                   	pop    %ebp
80104cf1:	c3                   	ret    
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104cf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cfd:	5d                   	pop    %ebp
80104cfe:	c3                   	ret    
80104cff:	90                   	nop

80104d00 <argptr>:
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104d00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d06:	55                   	push   %ebp
80104d07:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104d09:	8b 50 18             	mov    0x18(%eax),%edx
80104d0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
80104d0f:	8b 00                	mov    (%eax),%eax
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104d11:	8b 52 44             	mov    0x44(%edx),%edx
80104d14:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104d17:	8d 4a 04             	lea    0x4(%edx),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
80104d1a:	39 c1                	cmp    %eax,%ecx
80104d1c:	73 22                	jae    80104d40 <argptr+0x40>
80104d1e:	8d 4a 08             	lea    0x8(%edx),%ecx
80104d21:	39 c8                	cmp    %ecx,%eax
80104d23:	72 1b                	jb     80104d40 <argptr+0x40>
  *ip = *(int*)(addr);
80104d25:	8b 52 04             	mov    0x4(%edx),%edx
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80104d28:	39 c2                	cmp    %eax,%edx
80104d2a:	73 14                	jae    80104d40 <argptr+0x40>
80104d2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d2f:	01 d1                	add    %edx,%ecx
80104d31:	39 c1                	cmp    %eax,%ecx
80104d33:	77 0b                	ja     80104d40 <argptr+0x40>
    return -1;
  *pp = (char*)i;
80104d35:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d38:	89 10                	mov    %edx,(%eax)
  return 0;
80104d3a:	31 c0                	xor    %eax,%eax
}
80104d3c:	5d                   	pop    %ebp
80104d3d:	c3                   	ret    
80104d3e:	66 90                	xchg   %ax,%ax
    return -1;
80104d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d45:	5d                   	pop    %ebp
80104d46:	c3                   	ret    
80104d47:	89 f6                	mov    %esi,%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d50 <argstr>:
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104d50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d56:	55                   	push   %ebp
80104d57:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104d59:	8b 50 18             	mov    0x18(%eax),%edx
80104d5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
80104d5f:	8b 00                	mov    (%eax),%eax
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104d61:	8b 52 44             	mov    0x44(%edx),%edx
80104d64:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104d67:	8d 4a 04             	lea    0x4(%edx),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
80104d6a:	39 c1                	cmp    %eax,%ecx
80104d6c:	73 3e                	jae    80104dac <argstr+0x5c>
80104d6e:	8d 4a 08             	lea    0x8(%edx),%ecx
80104d71:	39 c8                	cmp    %ecx,%eax
80104d73:	72 37                	jb     80104dac <argstr+0x5c>
  *ip = *(int*)(addr);
80104d75:	8b 4a 04             	mov    0x4(%edx),%ecx
  if(addr >= proc->sz)
80104d78:	39 c1                	cmp    %eax,%ecx
80104d7a:	73 30                	jae    80104dac <argstr+0x5c>
  *pp = (char*)addr;
80104d7c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d7f:	89 c8                	mov    %ecx,%eax
80104d81:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104d83:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d8a:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104d8c:	39 d1                	cmp    %edx,%ecx
80104d8e:	73 1c                	jae    80104dac <argstr+0x5c>
    if(*s == 0)
80104d90:	80 39 00             	cmpb   $0x0,(%ecx)
80104d93:	75 10                	jne    80104da5 <argstr+0x55>
80104d95:	eb 29                	jmp    80104dc0 <argstr+0x70>
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104da0:	80 38 00             	cmpb   $0x0,(%eax)
80104da3:	74 13                	je     80104db8 <argstr+0x68>
  for(s = *pp; s < ep; s++)
80104da5:	83 c0 01             	add    $0x1,%eax
80104da8:	39 c2                	cmp    %eax,%edx
80104daa:	77 f4                	ja     80104da0 <argstr+0x50>
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104dac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104db1:	5d                   	pop    %ebp
80104db2:	c3                   	ret    
80104db3:	90                   	nop
80104db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104db8:	29 c8                	sub    %ecx,%eax
80104dba:	5d                   	pop    %ebp
80104dbb:	c3                   	ret    
80104dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
80104dc0:	31 c0                	xor    %eax,%eax
}
80104dc2:	5d                   	pop    %ebp
80104dc3:	c3                   	ret    
80104dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104dd0 <syscall>:
[SYS_myFork] sys_myFork,
};

void
syscall(void)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	83 ec 08             	sub    $0x8,%esp
  int num;

  num = proc->tf->eax;
80104dd6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ddd:	8b 42 18             	mov    0x18(%edx),%eax
80104de0:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104de3:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104de6:	83 f9 1d             	cmp    $0x1d,%ecx
80104de9:	77 25                	ja     80104e10 <syscall+0x40>
80104deb:	8b 0c 85 20 80 10 80 	mov    -0x7fef7fe0(,%eax,4),%ecx
80104df2:	85 c9                	test   %ecx,%ecx
80104df4:	74 1a                	je     80104e10 <syscall+0x40>
    proc->tf->eax = syscalls[num]();
80104df6:	ff d1                	call   *%ecx
80104df8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104dff:	8b 52 18             	mov    0x18(%edx),%edx
80104e02:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
80104e05:	c9                   	leave  
80104e06:	c3                   	ret    
80104e07:	89 f6                	mov    %esi,%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("%d %s: unknown sys call %d\n",
80104e10:	50                   	push   %eax
            proc->pid, proc->name, num);
80104e11:	8d 42 6c             	lea    0x6c(%edx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e14:	50                   	push   %eax
80104e15:	ff 72 10             	pushl  0x10(%edx)
80104e18:	68 04 80 10 80       	push   $0x80108004
80104e1d:	e8 1e b8 ff ff       	call   80100640 <cprintf>
    proc->tf->eax = -1;
80104e22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e28:	83 c4 10             	add    $0x10,%esp
80104e2b:	8b 40 18             	mov    0x18(%eax),%eax
80104e2e:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e35:	c9                   	leave  
80104e36:	c3                   	ret    
80104e37:	66 90                	xchg   %ax,%ax
80104e39:	66 90                	xchg   %ax,%ax
80104e3b:	66 90                	xchg   %ax,%ax
80104e3d:	66 90                	xchg   %ax,%ax
80104e3f:	90                   	nop

80104e40 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	56                   	push   %esi
80104e45:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e46:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104e49:	83 ec 44             	sub    $0x44,%esp
80104e4c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104e4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e52:	56                   	push   %esi
80104e53:	50                   	push   %eax
{
80104e54:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104e57:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e5a:	e8 71 d0 ff ff       	call   80101ed0 <nameiparent>
80104e5f:	83 c4 10             	add    $0x10,%esp
80104e62:	85 c0                	test   %eax,%eax
80104e64:	0f 84 46 01 00 00    	je     80104fb0 <create+0x170>
    return 0;
  ilock(dp);
80104e6a:	83 ec 0c             	sub    $0xc,%esp
80104e6d:	89 c3                	mov    %eax,%ebx
80104e6f:	50                   	push   %eax
80104e70:	e8 9b c7 ff ff       	call   80101610 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104e75:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104e78:	83 c4 0c             	add    $0xc,%esp
80104e7b:	50                   	push   %eax
80104e7c:	56                   	push   %esi
80104e7d:	53                   	push   %ebx
80104e7e:	e8 fd cc ff ff       	call   80101b80 <dirlookup>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	85 c0                	test   %eax,%eax
80104e88:	89 c7                	mov    %eax,%edi
80104e8a:	74 34                	je     80104ec0 <create+0x80>
    iunlockput(dp);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	53                   	push   %ebx
80104e90:	e8 4b ca ff ff       	call   801018e0 <iunlockput>
    ilock(ip);
80104e95:	89 3c 24             	mov    %edi,(%esp)
80104e98:	e8 73 c7 ff ff       	call   80101610 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e9d:	83 c4 10             	add    $0x10,%esp
80104ea0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104ea5:	0f 85 95 00 00 00    	jne    80104f40 <create+0x100>
80104eab:	66 83 7f 10 02       	cmpw   $0x2,0x10(%edi)
80104eb0:	0f 85 8a 00 00 00    	jne    80104f40 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104eb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eb9:	89 f8                	mov    %edi,%eax
80104ebb:	5b                   	pop    %ebx
80104ebc:	5e                   	pop    %esi
80104ebd:	5f                   	pop    %edi
80104ebe:	5d                   	pop    %ebp
80104ebf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104ec0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104ec4:	83 ec 08             	sub    $0x8,%esp
80104ec7:	50                   	push   %eax
80104ec8:	ff 33                	pushl  (%ebx)
80104eca:	e8 d1 c5 ff ff       	call   801014a0 <ialloc>
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	89 c7                	mov    %eax,%edi
80104ed6:	0f 84 e8 00 00 00    	je     80104fc4 <create+0x184>
  ilock(ip);
80104edc:	83 ec 0c             	sub    $0xc,%esp
80104edf:	50                   	push   %eax
80104ee0:	e8 2b c7 ff ff       	call   80101610 <ilock>
  ip->major = major;
80104ee5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104ee9:	66 89 47 12          	mov    %ax,0x12(%edi)
  ip->minor = minor;
80104eed:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104ef1:	66 89 47 14          	mov    %ax,0x14(%edi)
  ip->nlink = 1;
80104ef5:	b8 01 00 00 00       	mov    $0x1,%eax
80104efa:	66 89 47 16          	mov    %ax,0x16(%edi)
  iupdate(ip);
80104efe:	89 3c 24             	mov    %edi,(%esp)
80104f01:	e8 5a c6 ff ff       	call   80101560 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104f0e:	74 50                	je     80104f60 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f10:	83 ec 04             	sub    $0x4,%esp
80104f13:	ff 77 04             	pushl  0x4(%edi)
80104f16:	56                   	push   %esi
80104f17:	53                   	push   %ebx
80104f18:	e8 d3 ce ff ff       	call   80101df0 <dirlink>
80104f1d:	83 c4 10             	add    $0x10,%esp
80104f20:	85 c0                	test   %eax,%eax
80104f22:	0f 88 8f 00 00 00    	js     80104fb7 <create+0x177>
  iunlockput(dp);
80104f28:	83 ec 0c             	sub    $0xc,%esp
80104f2b:	53                   	push   %ebx
80104f2c:	e8 af c9 ff ff       	call   801018e0 <iunlockput>
  return ip;
80104f31:	83 c4 10             	add    $0x10,%esp
}
80104f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f37:	89 f8                	mov    %edi,%eax
80104f39:	5b                   	pop    %ebx
80104f3a:	5e                   	pop    %esi
80104f3b:	5f                   	pop    %edi
80104f3c:	5d                   	pop    %ebp
80104f3d:	c3                   	ret    
80104f3e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104f40:	83 ec 0c             	sub    $0xc,%esp
80104f43:	57                   	push   %edi
    return 0;
80104f44:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104f46:	e8 95 c9 ff ff       	call   801018e0 <iunlockput>
    return 0;
80104f4b:	83 c4 10             	add    $0x10,%esp
}
80104f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f51:	89 f8                	mov    %edi,%eax
80104f53:	5b                   	pop    %ebx
80104f54:	5e                   	pop    %esi
80104f55:	5f                   	pop    %edi
80104f56:	5d                   	pop    %ebp
80104f57:	c3                   	ret    
80104f58:	90                   	nop
80104f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104f60:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
    iupdate(dp);
80104f65:	83 ec 0c             	sub    $0xc,%esp
80104f68:	53                   	push   %ebx
80104f69:	e8 f2 c5 ff ff       	call   80101560 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f6e:	83 c4 0c             	add    $0xc,%esp
80104f71:	ff 77 04             	pushl  0x4(%edi)
80104f74:	68 b8 80 10 80       	push   $0x801080b8
80104f79:	57                   	push   %edi
80104f7a:	e8 71 ce ff ff       	call   80101df0 <dirlink>
80104f7f:	83 c4 10             	add    $0x10,%esp
80104f82:	85 c0                	test   %eax,%eax
80104f84:	78 1c                	js     80104fa2 <create+0x162>
80104f86:	83 ec 04             	sub    $0x4,%esp
80104f89:	ff 73 04             	pushl  0x4(%ebx)
80104f8c:	68 b7 80 10 80       	push   $0x801080b7
80104f91:	57                   	push   %edi
80104f92:	e8 59 ce ff ff       	call   80101df0 <dirlink>
80104f97:	83 c4 10             	add    $0x10,%esp
80104f9a:	85 c0                	test   %eax,%eax
80104f9c:	0f 89 6e ff ff ff    	jns    80104f10 <create+0xd0>
      panic("create dots");
80104fa2:	83 ec 0c             	sub    $0xc,%esp
80104fa5:	68 ab 80 10 80       	push   $0x801080ab
80104faa:	e8 c1 b3 ff ff       	call   80100370 <panic>
80104faf:	90                   	nop
    return 0;
80104fb0:	31 ff                	xor    %edi,%edi
80104fb2:	e9 ff fe ff ff       	jmp    80104eb6 <create+0x76>
    panic("create: dirlink");
80104fb7:	83 ec 0c             	sub    $0xc,%esp
80104fba:	68 ba 80 10 80       	push   $0x801080ba
80104fbf:	e8 ac b3 ff ff       	call   80100370 <panic>
    panic("create: ialloc");
80104fc4:	83 ec 0c             	sub    $0xc,%esp
80104fc7:	68 9c 80 10 80       	push   $0x8010809c
80104fcc:	e8 9f b3 ff ff       	call   80100370 <panic>
80104fd1:	eb 0d                	jmp    80104fe0 <argfd.constprop.0>
80104fd3:	90                   	nop
80104fd4:	90                   	nop
80104fd5:	90                   	nop
80104fd6:	90                   	nop
80104fd7:	90                   	nop
80104fd8:	90                   	nop
80104fd9:	90                   	nop
80104fda:	90                   	nop
80104fdb:	90                   	nop
80104fdc:	90                   	nop
80104fdd:	90                   	nop
80104fde:	90                   	nop
80104fdf:	90                   	nop

80104fe0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
80104fe5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104fe7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104fea:	89 d6                	mov    %edx,%esi
80104fec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fef:	50                   	push   %eax
80104ff0:	6a 00                	push   $0x0
80104ff2:	e8 c9 fc ff ff       	call   80104cc0 <argint>
80104ff7:	83 c4 10             	add    $0x10,%esp
80104ffa:	85 c0                	test   %eax,%eax
80104ffc:	78 32                	js     80105030 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105001:	83 f8 0f             	cmp    $0xf,%eax
80105004:	77 2a                	ja     80105030 <argfd.constprop.0+0x50>
80105006:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010500d:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
80105011:	85 c9                	test   %ecx,%ecx
80105013:	74 1b                	je     80105030 <argfd.constprop.0+0x50>
  if(pfd)
80105015:	85 db                	test   %ebx,%ebx
80105017:	74 02                	je     8010501b <argfd.constprop.0+0x3b>
    *pfd = fd;
80105019:	89 03                	mov    %eax,(%ebx)
    *pf = f;
8010501b:	89 0e                	mov    %ecx,(%esi)
  return 0;
8010501d:	31 c0                	xor    %eax,%eax
}
8010501f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105022:	5b                   	pop    %ebx
80105023:	5e                   	pop    %esi
80105024:	5d                   	pop    %ebp
80105025:	c3                   	ret    
80105026:	8d 76 00             	lea    0x0(%esi),%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105035:	eb e8                	jmp    8010501f <argfd.constprop.0+0x3f>
80105037:	89 f6                	mov    %esi,%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105040 <sys_dup>:
{
80105040:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105041:	31 c0                	xor    %eax,%eax
{
80105043:	89 e5                	mov    %esp,%ebp
80105045:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105046:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105049:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
8010504c:	e8 8f ff ff ff       	call   80104fe0 <argfd.constprop.0>
80105051:	85 c0                	test   %eax,%eax
80105053:	78 3b                	js     80105090 <sys_dup+0x50>
  if((fd=fdalloc(f)) < 0)
80105055:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if(proc->ofile[fd] == 0){
80105058:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(fd = 0; fd < NOFILE; fd++){
8010505e:	31 db                	xor    %ebx,%ebx
80105060:	eb 0e                	jmp    80105070 <sys_dup+0x30>
80105062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105068:	83 c3 01             	add    $0x1,%ebx
8010506b:	83 fb 10             	cmp    $0x10,%ebx
8010506e:	74 20                	je     80105090 <sys_dup+0x50>
    if(proc->ofile[fd] == 0){
80105070:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80105074:	85 c9                	test   %ecx,%ecx
80105076:	75 f0                	jne    80105068 <sys_dup+0x28>
  filedup(f);
80105078:	83 ec 0c             	sub    $0xc,%esp
      proc->ofile[fd] = f;
8010507b:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)
  filedup(f);
8010507f:	52                   	push   %edx
80105080:	e8 3b bd ff ff       	call   80100dc0 <filedup>
}
80105085:	89 d8                	mov    %ebx,%eax
  return fd;
80105087:	83 c4 10             	add    $0x10,%esp
}
8010508a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010508d:	c9                   	leave  
8010508e:	c3                   	ret    
8010508f:	90                   	nop
    return -1;
80105090:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105095:	89 d8                	mov    %ebx,%eax
80105097:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010509a:	c9                   	leave  
8010509b:	c3                   	ret    
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050a0 <sys_read>:
{
801050a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050a1:	31 c0                	xor    %eax,%eax
{
801050a3:	89 e5                	mov    %esp,%ebp
801050a5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050a8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050ab:	e8 30 ff ff ff       	call   80104fe0 <argfd.constprop.0>
801050b0:	85 c0                	test   %eax,%eax
801050b2:	78 4c                	js     80105100 <sys_read+0x60>
801050b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b7:	83 ec 08             	sub    $0x8,%esp
801050ba:	50                   	push   %eax
801050bb:	6a 02                	push   $0x2
801050bd:	e8 fe fb ff ff       	call   80104cc0 <argint>
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	85 c0                	test   %eax,%eax
801050c7:	78 37                	js     80105100 <sys_read+0x60>
801050c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050cc:	83 ec 04             	sub    $0x4,%esp
801050cf:	ff 75 f0             	pushl  -0x10(%ebp)
801050d2:	50                   	push   %eax
801050d3:	6a 01                	push   $0x1
801050d5:	e8 26 fc ff ff       	call   80104d00 <argptr>
801050da:	83 c4 10             	add    $0x10,%esp
801050dd:	85 c0                	test   %eax,%eax
801050df:	78 1f                	js     80105100 <sys_read+0x60>
  return fileread(f, p, n);
801050e1:	83 ec 04             	sub    $0x4,%esp
801050e4:	ff 75 f0             	pushl  -0x10(%ebp)
801050e7:	ff 75 f4             	pushl  -0xc(%ebp)
801050ea:	ff 75 ec             	pushl  -0x14(%ebp)
801050ed:	e8 3e be ff ff       	call   80100f30 <fileread>
801050f2:	83 c4 10             	add    $0x10,%esp
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
801050f7:	89 f6                	mov    %esi,%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105105:	c9                   	leave  
80105106:	c3                   	ret    
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105110 <sys_write>:
{
80105110:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105111:	31 c0                	xor    %eax,%eax
{
80105113:	89 e5                	mov    %esp,%ebp
80105115:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105118:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010511b:	e8 c0 fe ff ff       	call   80104fe0 <argfd.constprop.0>
80105120:	85 c0                	test   %eax,%eax
80105122:	78 4c                	js     80105170 <sys_write+0x60>
80105124:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105127:	83 ec 08             	sub    $0x8,%esp
8010512a:	50                   	push   %eax
8010512b:	6a 02                	push   $0x2
8010512d:	e8 8e fb ff ff       	call   80104cc0 <argint>
80105132:	83 c4 10             	add    $0x10,%esp
80105135:	85 c0                	test   %eax,%eax
80105137:	78 37                	js     80105170 <sys_write+0x60>
80105139:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010513c:	83 ec 04             	sub    $0x4,%esp
8010513f:	ff 75 f0             	pushl  -0x10(%ebp)
80105142:	50                   	push   %eax
80105143:	6a 01                	push   $0x1
80105145:	e8 b6 fb ff ff       	call   80104d00 <argptr>
8010514a:	83 c4 10             	add    $0x10,%esp
8010514d:	85 c0                	test   %eax,%eax
8010514f:	78 1f                	js     80105170 <sys_write+0x60>
  return filewrite(f, p, n);
80105151:	83 ec 04             	sub    $0x4,%esp
80105154:	ff 75 f0             	pushl  -0x10(%ebp)
80105157:	ff 75 f4             	pushl  -0xc(%ebp)
8010515a:	ff 75 ec             	pushl  -0x14(%ebp)
8010515d:	e8 5e be ff ff       	call   80100fc0 <filewrite>
80105162:	83 c4 10             	add    $0x10,%esp
}
80105165:	c9                   	leave  
80105166:	c3                   	ret    
80105167:	89 f6                	mov    %esi,%esi
80105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105175:	c9                   	leave  
80105176:	c3                   	ret    
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <sys_close>:
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105186:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105189:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010518c:	e8 4f fe ff ff       	call   80104fe0 <argfd.constprop.0>
80105191:	85 c0                	test   %eax,%eax
80105193:	78 2b                	js     801051c0 <sys_close+0x40>
  proc->ofile[fd] = 0;
80105195:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010519b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010519e:	83 ec 0c             	sub    $0xc,%esp
  proc->ofile[fd] = 0;
801051a1:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801051a8:	00 
  fileclose(f);
801051a9:	ff 75 f4             	pushl  -0xc(%ebp)
801051ac:	e8 5f bc ff ff       	call   80100e10 <fileclose>
  return 0;
801051b1:	83 c4 10             	add    $0x10,%esp
801051b4:	31 c0                	xor    %eax,%eax
}
801051b6:	c9                   	leave  
801051b7:	c3                   	ret    
801051b8:	90                   	nop
801051b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c5:	c9                   	leave  
801051c6:	c3                   	ret    
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <sys_fstat>:
{
801051d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051d1:	31 c0                	xor    %eax,%eax
{
801051d3:	89 e5                	mov    %esp,%ebp
801051d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051d8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801051db:	e8 00 fe ff ff       	call   80104fe0 <argfd.constprop.0>
801051e0:	85 c0                	test   %eax,%eax
801051e2:	78 2c                	js     80105210 <sys_fstat+0x40>
801051e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051e7:	83 ec 04             	sub    $0x4,%esp
801051ea:	6a 14                	push   $0x14
801051ec:	50                   	push   %eax
801051ed:	6a 01                	push   $0x1
801051ef:	e8 0c fb ff ff       	call   80104d00 <argptr>
801051f4:	83 c4 10             	add    $0x10,%esp
801051f7:	85 c0                	test   %eax,%eax
801051f9:	78 15                	js     80105210 <sys_fstat+0x40>
  return filestat(f, st);
801051fb:	83 ec 08             	sub    $0x8,%esp
801051fe:	ff 75 f4             	pushl  -0xc(%ebp)
80105201:	ff 75 f0             	pushl  -0x10(%ebp)
80105204:	e8 d7 bc ff ff       	call   80100ee0 <filestat>
80105209:	83 c4 10             	add    $0x10,%esp
}
8010520c:	c9                   	leave  
8010520d:	c3                   	ret    
8010520e:	66 90                	xchg   %ax,%ax
    return -1;
80105210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105215:	c9                   	leave  
80105216:	c3                   	ret    
80105217:	89 f6                	mov    %esi,%esi
80105219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105220 <sys_link>:
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	57                   	push   %edi
80105224:	56                   	push   %esi
80105225:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105226:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105229:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010522c:	50                   	push   %eax
8010522d:	6a 00                	push   $0x0
8010522f:	e8 1c fb ff ff       	call   80104d50 <argstr>
80105234:	83 c4 10             	add    $0x10,%esp
80105237:	85 c0                	test   %eax,%eax
80105239:	0f 88 fb 00 00 00    	js     8010533a <sys_link+0x11a>
8010523f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105242:	83 ec 08             	sub    $0x8,%esp
80105245:	50                   	push   %eax
80105246:	6a 01                	push   $0x1
80105248:	e8 03 fb ff ff       	call   80104d50 <argstr>
8010524d:	83 c4 10             	add    $0x10,%esp
80105250:	85 c0                	test   %eax,%eax
80105252:	0f 88 e2 00 00 00    	js     8010533a <sys_link+0x11a>
  begin_op();
80105258:	e8 c3 da ff ff       	call   80102d20 <begin_op>
  if((ip = namei(old)) == 0){
8010525d:	83 ec 0c             	sub    $0xc,%esp
80105260:	ff 75 d4             	pushl  -0x2c(%ebp)
80105263:	e8 48 cc ff ff       	call   80101eb0 <namei>
80105268:	83 c4 10             	add    $0x10,%esp
8010526b:	85 c0                	test   %eax,%eax
8010526d:	89 c3                	mov    %eax,%ebx
8010526f:	0f 84 ea 00 00 00    	je     8010535f <sys_link+0x13f>
  ilock(ip);
80105275:	83 ec 0c             	sub    $0xc,%esp
80105278:	50                   	push   %eax
80105279:	e8 92 c3 ff ff       	call   80101610 <ilock>
  if(ip->type == T_DIR){
8010527e:	83 c4 10             	add    $0x10,%esp
80105281:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80105286:	0f 84 bb 00 00 00    	je     80105347 <sys_link+0x127>
  ip->nlink++;
8010528c:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
80105291:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105294:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105297:	53                   	push   %ebx
80105298:	e8 c3 c2 ff ff       	call   80101560 <iupdate>
  iunlock(ip);
8010529d:	89 1c 24             	mov    %ebx,(%esp)
801052a0:	e8 7b c4 ff ff       	call   80101720 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801052a5:	58                   	pop    %eax
801052a6:	5a                   	pop    %edx
801052a7:	57                   	push   %edi
801052a8:	ff 75 d0             	pushl  -0x30(%ebp)
801052ab:	e8 20 cc ff ff       	call   80101ed0 <nameiparent>
801052b0:	83 c4 10             	add    $0x10,%esp
801052b3:	85 c0                	test   %eax,%eax
801052b5:	89 c6                	mov    %eax,%esi
801052b7:	74 5b                	je     80105314 <sys_link+0xf4>
  ilock(dp);
801052b9:	83 ec 0c             	sub    $0xc,%esp
801052bc:	50                   	push   %eax
801052bd:	e8 4e c3 ff ff       	call   80101610 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052c2:	83 c4 10             	add    $0x10,%esp
801052c5:	8b 03                	mov    (%ebx),%eax
801052c7:	39 06                	cmp    %eax,(%esi)
801052c9:	75 3d                	jne    80105308 <sys_link+0xe8>
801052cb:	83 ec 04             	sub    $0x4,%esp
801052ce:	ff 73 04             	pushl  0x4(%ebx)
801052d1:	57                   	push   %edi
801052d2:	56                   	push   %esi
801052d3:	e8 18 cb ff ff       	call   80101df0 <dirlink>
801052d8:	83 c4 10             	add    $0x10,%esp
801052db:	85 c0                	test   %eax,%eax
801052dd:	78 29                	js     80105308 <sys_link+0xe8>
  iunlockput(dp);
801052df:	83 ec 0c             	sub    $0xc,%esp
801052e2:	56                   	push   %esi
801052e3:	e8 f8 c5 ff ff       	call   801018e0 <iunlockput>
  iput(ip);
801052e8:	89 1c 24             	mov    %ebx,(%esp)
801052eb:	e8 90 c4 ff ff       	call   80101780 <iput>
  end_op();
801052f0:	e8 9b da ff ff       	call   80102d90 <end_op>
  return 0;
801052f5:	83 c4 10             	add    $0x10,%esp
801052f8:	31 c0                	xor    %eax,%eax
}
801052fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052fd:	5b                   	pop    %ebx
801052fe:	5e                   	pop    %esi
801052ff:	5f                   	pop    %edi
80105300:	5d                   	pop    %ebp
80105301:	c3                   	ret    
80105302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105308:	83 ec 0c             	sub    $0xc,%esp
8010530b:	56                   	push   %esi
8010530c:	e8 cf c5 ff ff       	call   801018e0 <iunlockput>
    goto bad;
80105311:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105314:	83 ec 0c             	sub    $0xc,%esp
80105317:	53                   	push   %ebx
80105318:	e8 f3 c2 ff ff       	call   80101610 <ilock>
  ip->nlink--;
8010531d:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80105322:	89 1c 24             	mov    %ebx,(%esp)
80105325:	e8 36 c2 ff ff       	call   80101560 <iupdate>
  iunlockput(ip);
8010532a:	89 1c 24             	mov    %ebx,(%esp)
8010532d:	e8 ae c5 ff ff       	call   801018e0 <iunlockput>
  end_op();
80105332:	e8 59 da ff ff       	call   80102d90 <end_op>
  return -1;
80105337:	83 c4 10             	add    $0x10,%esp
}
8010533a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010533d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105342:	5b                   	pop    %ebx
80105343:	5e                   	pop    %esi
80105344:	5f                   	pop    %edi
80105345:	5d                   	pop    %ebp
80105346:	c3                   	ret    
    iunlockput(ip);
80105347:	83 ec 0c             	sub    $0xc,%esp
8010534a:	53                   	push   %ebx
8010534b:	e8 90 c5 ff ff       	call   801018e0 <iunlockput>
    end_op();
80105350:	e8 3b da ff ff       	call   80102d90 <end_op>
    return -1;
80105355:	83 c4 10             	add    $0x10,%esp
80105358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535d:	eb 9b                	jmp    801052fa <sys_link+0xda>
    end_op();
8010535f:	e8 2c da ff ff       	call   80102d90 <end_op>
    return -1;
80105364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105369:	eb 8f                	jmp    801052fa <sys_link+0xda>
8010536b:	90                   	nop
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105370 <sys_unlink>:
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	57                   	push   %edi
80105374:	56                   	push   %esi
80105375:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105376:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105379:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010537c:	50                   	push   %eax
8010537d:	6a 00                	push   $0x0
8010537f:	e8 cc f9 ff ff       	call   80104d50 <argstr>
80105384:	83 c4 10             	add    $0x10,%esp
80105387:	85 c0                	test   %eax,%eax
80105389:	0f 88 77 01 00 00    	js     80105506 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010538f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105392:	e8 89 d9 ff ff       	call   80102d20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105397:	83 ec 08             	sub    $0x8,%esp
8010539a:	53                   	push   %ebx
8010539b:	ff 75 c0             	pushl  -0x40(%ebp)
8010539e:	e8 2d cb ff ff       	call   80101ed0 <nameiparent>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	89 c6                	mov    %eax,%esi
801053aa:	0f 84 60 01 00 00    	je     80105510 <sys_unlink+0x1a0>
  ilock(dp);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	50                   	push   %eax
801053b4:	e8 57 c2 ff ff       	call   80101610 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053b9:	58                   	pop    %eax
801053ba:	5a                   	pop    %edx
801053bb:	68 b8 80 10 80       	push   $0x801080b8
801053c0:	53                   	push   %ebx
801053c1:	e8 9a c7 ff ff       	call   80101b60 <namecmp>
801053c6:	83 c4 10             	add    $0x10,%esp
801053c9:	85 c0                	test   %eax,%eax
801053cb:	0f 84 03 01 00 00    	je     801054d4 <sys_unlink+0x164>
801053d1:	83 ec 08             	sub    $0x8,%esp
801053d4:	68 b7 80 10 80       	push   $0x801080b7
801053d9:	53                   	push   %ebx
801053da:	e8 81 c7 ff ff       	call   80101b60 <namecmp>
801053df:	83 c4 10             	add    $0x10,%esp
801053e2:	85 c0                	test   %eax,%eax
801053e4:	0f 84 ea 00 00 00    	je     801054d4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801053ea:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801053ed:	83 ec 04             	sub    $0x4,%esp
801053f0:	50                   	push   %eax
801053f1:	53                   	push   %ebx
801053f2:	56                   	push   %esi
801053f3:	e8 88 c7 ff ff       	call   80101b80 <dirlookup>
801053f8:	83 c4 10             	add    $0x10,%esp
801053fb:	85 c0                	test   %eax,%eax
801053fd:	89 c3                	mov    %eax,%ebx
801053ff:	0f 84 cf 00 00 00    	je     801054d4 <sys_unlink+0x164>
  ilock(ip);
80105405:	83 ec 0c             	sub    $0xc,%esp
80105408:	50                   	push   %eax
80105409:	e8 02 c2 ff ff       	call   80101610 <ilock>
  if(ip->nlink < 1)
8010540e:	83 c4 10             	add    $0x10,%esp
80105411:	66 83 7b 16 00       	cmpw   $0x0,0x16(%ebx)
80105416:	0f 8e 10 01 00 00    	jle    8010552c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010541c:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80105421:	74 6d                	je     80105490 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105423:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105426:	83 ec 04             	sub    $0x4,%esp
80105429:	6a 10                	push   $0x10
8010542b:	6a 00                	push   $0x0
8010542d:	50                   	push   %eax
8010542e:	e8 ad f5 ff ff       	call   801049e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105433:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105436:	6a 10                	push   $0x10
80105438:	ff 75 c4             	pushl  -0x3c(%ebp)
8010543b:	50                   	push   %eax
8010543c:	56                   	push   %esi
8010543d:	e8 ee c5 ff ff       	call   80101a30 <writei>
80105442:	83 c4 20             	add    $0x20,%esp
80105445:	83 f8 10             	cmp    $0x10,%eax
80105448:	0f 85 eb 00 00 00    	jne    80105539 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010544e:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80105453:	0f 84 97 00 00 00    	je     801054f0 <sys_unlink+0x180>
  iunlockput(dp);
80105459:	83 ec 0c             	sub    $0xc,%esp
8010545c:	56                   	push   %esi
8010545d:	e8 7e c4 ff ff       	call   801018e0 <iunlockput>
  ip->nlink--;
80105462:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80105467:	89 1c 24             	mov    %ebx,(%esp)
8010546a:	e8 f1 c0 ff ff       	call   80101560 <iupdate>
  iunlockput(ip);
8010546f:	89 1c 24             	mov    %ebx,(%esp)
80105472:	e8 69 c4 ff ff       	call   801018e0 <iunlockput>
  end_op();
80105477:	e8 14 d9 ff ff       	call   80102d90 <end_op>
  return 0;
8010547c:	83 c4 10             	add    $0x10,%esp
8010547f:	31 c0                	xor    %eax,%eax
}
80105481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105484:	5b                   	pop    %ebx
80105485:	5e                   	pop    %esi
80105486:	5f                   	pop    %edi
80105487:	5d                   	pop    %ebp
80105488:	c3                   	ret    
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105490:	83 7b 18 20          	cmpl   $0x20,0x18(%ebx)
80105494:	76 8d                	jbe    80105423 <sys_unlink+0xb3>
80105496:	bf 20 00 00 00       	mov    $0x20,%edi
8010549b:	eb 0f                	jmp    801054ac <sys_unlink+0x13c>
8010549d:	8d 76 00             	lea    0x0(%esi),%esi
801054a0:	83 c7 10             	add    $0x10,%edi
801054a3:	3b 7b 18             	cmp    0x18(%ebx),%edi
801054a6:	0f 83 77 ff ff ff    	jae    80105423 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054ac:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054af:	6a 10                	push   $0x10
801054b1:	57                   	push   %edi
801054b2:	50                   	push   %eax
801054b3:	53                   	push   %ebx
801054b4:	e8 77 c4 ff ff       	call   80101930 <readi>
801054b9:	83 c4 10             	add    $0x10,%esp
801054bc:	83 f8 10             	cmp    $0x10,%eax
801054bf:	75 5e                	jne    8010551f <sys_unlink+0x1af>
    if(de.inum != 0)
801054c1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054c6:	74 d8                	je     801054a0 <sys_unlink+0x130>
    iunlockput(ip);
801054c8:	83 ec 0c             	sub    $0xc,%esp
801054cb:	53                   	push   %ebx
801054cc:	e8 0f c4 ff ff       	call   801018e0 <iunlockput>
    goto bad;
801054d1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801054d4:	83 ec 0c             	sub    $0xc,%esp
801054d7:	56                   	push   %esi
801054d8:	e8 03 c4 ff ff       	call   801018e0 <iunlockput>
  end_op();
801054dd:	e8 ae d8 ff ff       	call   80102d90 <end_op>
  return -1;
801054e2:	83 c4 10             	add    $0x10,%esp
801054e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ea:	eb 95                	jmp    80105481 <sys_unlink+0x111>
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801054f0:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
    iupdate(dp);
801054f5:	83 ec 0c             	sub    $0xc,%esp
801054f8:	56                   	push   %esi
801054f9:	e8 62 c0 ff ff       	call   80101560 <iupdate>
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	e9 53 ff ff ff       	jmp    80105459 <sys_unlink+0xe9>
    return -1;
80105506:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550b:	e9 71 ff ff ff       	jmp    80105481 <sys_unlink+0x111>
    end_op();
80105510:	e8 7b d8 ff ff       	call   80102d90 <end_op>
    return -1;
80105515:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551a:	e9 62 ff ff ff       	jmp    80105481 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010551f:	83 ec 0c             	sub    $0xc,%esp
80105522:	68 dc 80 10 80       	push   $0x801080dc
80105527:	e8 44 ae ff ff       	call   80100370 <panic>
    panic("unlink: nlink < 1");
8010552c:	83 ec 0c             	sub    $0xc,%esp
8010552f:	68 ca 80 10 80       	push   $0x801080ca
80105534:	e8 37 ae ff ff       	call   80100370 <panic>
    panic("unlink: writei");
80105539:	83 ec 0c             	sub    $0xc,%esp
8010553c:	68 ee 80 10 80       	push   $0x801080ee
80105541:	e8 2a ae ff ff       	call   80100370 <panic>
80105546:	8d 76 00             	lea    0x0(%esi),%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105550 <sys_open>:

int
sys_open(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	57                   	push   %edi
80105554:	56                   	push   %esi
80105555:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105556:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105559:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010555c:	50                   	push   %eax
8010555d:	6a 00                	push   $0x0
8010555f:	e8 ec f7 ff ff       	call   80104d50 <argstr>
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	85 c0                	test   %eax,%eax
80105569:	0f 88 1d 01 00 00    	js     8010568c <sys_open+0x13c>
8010556f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105572:	83 ec 08             	sub    $0x8,%esp
80105575:	50                   	push   %eax
80105576:	6a 01                	push   $0x1
80105578:	e8 43 f7 ff ff       	call   80104cc0 <argint>
8010557d:	83 c4 10             	add    $0x10,%esp
80105580:	85 c0                	test   %eax,%eax
80105582:	0f 88 04 01 00 00    	js     8010568c <sys_open+0x13c>
    return -1;

  begin_op();
80105588:	e8 93 d7 ff ff       	call   80102d20 <begin_op>

  if(omode & O_CREATE){
8010558d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105591:	0f 85 a9 00 00 00    	jne    80105640 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105597:	83 ec 0c             	sub    $0xc,%esp
8010559a:	ff 75 e0             	pushl  -0x20(%ebp)
8010559d:	e8 0e c9 ff ff       	call   80101eb0 <namei>
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	85 c0                	test   %eax,%eax
801055a7:	89 c6                	mov    %eax,%esi
801055a9:	0f 84 b2 00 00 00    	je     80105661 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801055af:	83 ec 0c             	sub    $0xc,%esp
801055b2:	50                   	push   %eax
801055b3:	e8 58 c0 ff ff       	call   80101610 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055b8:	83 c4 10             	add    $0x10,%esp
801055bb:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
801055c0:	0f 84 aa 00 00 00    	je     80105670 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055c6:	e8 85 b7 ff ff       	call   80100d50 <filealloc>
801055cb:	85 c0                	test   %eax,%eax
801055cd:	89 c7                	mov    %eax,%edi
801055cf:	0f 84 a6 00 00 00    	je     8010567b <sys_open+0x12b>
    if(proc->ofile[fd] == 0){
801055d5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  for(fd = 0; fd < NOFILE; fd++){
801055dc:	31 db                	xor    %ebx,%ebx
801055de:	eb 0c                	jmp    801055ec <sys_open+0x9c>
801055e0:	83 c3 01             	add    $0x1,%ebx
801055e3:	83 fb 10             	cmp    $0x10,%ebx
801055e6:	0f 84 ac 00 00 00    	je     80105698 <sys_open+0x148>
    if(proc->ofile[fd] == 0){
801055ec:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
801055f0:	85 c0                	test   %eax,%eax
801055f2:	75 ec                	jne    801055e0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055f4:	83 ec 0c             	sub    $0xc,%esp
      proc->ofile[fd] = f;
801055f7:	89 7c 9a 28          	mov    %edi,0x28(%edx,%ebx,4)
  iunlock(ip);
801055fb:	56                   	push   %esi
801055fc:	e8 1f c1 ff ff       	call   80101720 <iunlock>
  end_op();
80105601:	e8 8a d7 ff ff       	call   80102d90 <end_op>

  f->type = FD_INODE;
80105606:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010560c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010560f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105612:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105615:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010561c:	89 d0                	mov    %edx,%eax
8010561e:	f7 d0                	not    %eax
80105620:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105623:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105626:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105629:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010562d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105630:	89 d8                	mov    %ebx,%eax
80105632:	5b                   	pop    %ebx
80105633:	5e                   	pop    %esi
80105634:	5f                   	pop    %edi
80105635:	5d                   	pop    %ebp
80105636:	c3                   	ret    
80105637:	89 f6                	mov    %esi,%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105646:	31 c9                	xor    %ecx,%ecx
80105648:	6a 00                	push   $0x0
8010564a:	ba 02 00 00 00       	mov    $0x2,%edx
8010564f:	e8 ec f7 ff ff       	call   80104e40 <create>
    if(ip == 0){
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105659:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010565b:	0f 85 65 ff ff ff    	jne    801055c6 <sys_open+0x76>
      end_op();
80105661:	e8 2a d7 ff ff       	call   80102d90 <end_op>
      return -1;
80105666:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010566b:	eb c0                	jmp    8010562d <sys_open+0xdd>
8010566d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105670:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105673:	85 d2                	test   %edx,%edx
80105675:	0f 84 4b ff ff ff    	je     801055c6 <sys_open+0x76>
    iunlockput(ip);
8010567b:	83 ec 0c             	sub    $0xc,%esp
8010567e:	56                   	push   %esi
8010567f:	e8 5c c2 ff ff       	call   801018e0 <iunlockput>
    end_op();
80105684:	e8 07 d7 ff ff       	call   80102d90 <end_op>
    return -1;
80105689:	83 c4 10             	add    $0x10,%esp
8010568c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105691:	eb 9a                	jmp    8010562d <sys_open+0xdd>
80105693:	90                   	nop
80105694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105698:	83 ec 0c             	sub    $0xc,%esp
8010569b:	57                   	push   %edi
8010569c:	e8 6f b7 ff ff       	call   80100e10 <fileclose>
801056a1:	83 c4 10             	add    $0x10,%esp
801056a4:	eb d5                	jmp    8010567b <sys_open+0x12b>
801056a6:	8d 76 00             	lea    0x0(%esi),%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056b0 <sys_mkdir>:

int
sys_mkdir(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801056b6:	e8 65 d6 ff ff       	call   80102d20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801056bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056be:	83 ec 08             	sub    $0x8,%esp
801056c1:	50                   	push   %eax
801056c2:	6a 00                	push   $0x0
801056c4:	e8 87 f6 ff ff       	call   80104d50 <argstr>
801056c9:	83 c4 10             	add    $0x10,%esp
801056cc:	85 c0                	test   %eax,%eax
801056ce:	78 30                	js     80105700 <sys_mkdir+0x50>
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d6:	31 c9                	xor    %ecx,%ecx
801056d8:	6a 00                	push   $0x0
801056da:	ba 01 00 00 00       	mov    $0x1,%edx
801056df:	e8 5c f7 ff ff       	call   80104e40 <create>
801056e4:	83 c4 10             	add    $0x10,%esp
801056e7:	85 c0                	test   %eax,%eax
801056e9:	74 15                	je     80105700 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056eb:	83 ec 0c             	sub    $0xc,%esp
801056ee:	50                   	push   %eax
801056ef:	e8 ec c1 ff ff       	call   801018e0 <iunlockput>
  end_op();
801056f4:	e8 97 d6 ff ff       	call   80102d90 <end_op>
  return 0;
801056f9:	83 c4 10             	add    $0x10,%esp
801056fc:	31 c0                	xor    %eax,%eax
}
801056fe:	c9                   	leave  
801056ff:	c3                   	ret    
    end_op();
80105700:	e8 8b d6 ff ff       	call   80102d90 <end_op>
    return -1;
80105705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010570a:	c9                   	leave  
8010570b:	c3                   	ret    
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_mknod>:

int
sys_mknod(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105716:	e8 05 d6 ff ff       	call   80102d20 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010571b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010571e:	83 ec 08             	sub    $0x8,%esp
80105721:	50                   	push   %eax
80105722:	6a 00                	push   $0x0
80105724:	e8 27 f6 ff ff       	call   80104d50 <argstr>
80105729:	83 c4 10             	add    $0x10,%esp
8010572c:	85 c0                	test   %eax,%eax
8010572e:	78 60                	js     80105790 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105730:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105733:	83 ec 08             	sub    $0x8,%esp
80105736:	50                   	push   %eax
80105737:	6a 01                	push   $0x1
80105739:	e8 82 f5 ff ff       	call   80104cc0 <argint>
  if((argstr(0, &path)) < 0 ||
8010573e:	83 c4 10             	add    $0x10,%esp
80105741:	85 c0                	test   %eax,%eax
80105743:	78 4b                	js     80105790 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105745:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105748:	83 ec 08             	sub    $0x8,%esp
8010574b:	50                   	push   %eax
8010574c:	6a 02                	push   $0x2
8010574e:	e8 6d f5 ff ff       	call   80104cc0 <argint>
     argint(1, &major) < 0 ||
80105753:	83 c4 10             	add    $0x10,%esp
80105756:	85 c0                	test   %eax,%eax
80105758:	78 36                	js     80105790 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010575a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010575e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105761:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105765:	ba 03 00 00 00       	mov    $0x3,%edx
8010576a:	50                   	push   %eax
8010576b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010576e:	e8 cd f6 ff ff       	call   80104e40 <create>
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	85 c0                	test   %eax,%eax
80105778:	74 16                	je     80105790 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010577a:	83 ec 0c             	sub    $0xc,%esp
8010577d:	50                   	push   %eax
8010577e:	e8 5d c1 ff ff       	call   801018e0 <iunlockput>
  end_op();
80105783:	e8 08 d6 ff ff       	call   80102d90 <end_op>
  return 0;
80105788:	83 c4 10             	add    $0x10,%esp
8010578b:	31 c0                	xor    %eax,%eax
}
8010578d:	c9                   	leave  
8010578e:	c3                   	ret    
8010578f:	90                   	nop
    end_op();
80105790:	e8 fb d5 ff ff       	call   80102d90 <end_op>
    return -1;
80105795:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010579a:	c9                   	leave  
8010579b:	c3                   	ret    
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_chdir>:

int
sys_chdir(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	53                   	push   %ebx
801057a4:	83 ec 14             	sub    $0x14,%esp
  char *path;
  struct inode *ip;

  begin_op();
801057a7:	e8 74 d5 ff ff       	call   80102d20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057af:	83 ec 08             	sub    $0x8,%esp
801057b2:	50                   	push   %eax
801057b3:	6a 00                	push   $0x0
801057b5:	e8 96 f5 ff ff       	call   80104d50 <argstr>
801057ba:	83 c4 10             	add    $0x10,%esp
801057bd:	85 c0                	test   %eax,%eax
801057bf:	78 7f                	js     80105840 <sys_chdir+0xa0>
801057c1:	83 ec 0c             	sub    $0xc,%esp
801057c4:	ff 75 f4             	pushl  -0xc(%ebp)
801057c7:	e8 e4 c6 ff ff       	call   80101eb0 <namei>
801057cc:	83 c4 10             	add    $0x10,%esp
801057cf:	85 c0                	test   %eax,%eax
801057d1:	89 c3                	mov    %eax,%ebx
801057d3:	74 6b                	je     80105840 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057d5:	83 ec 0c             	sub    $0xc,%esp
801057d8:	50                   	push   %eax
801057d9:	e8 32 be ff ff       	call   80101610 <ilock>
  if(ip->type != T_DIR){
801057de:	83 c4 10             	add    $0x10,%esp
801057e1:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
801057e6:	75 38                	jne    80105820 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057e8:	83 ec 0c             	sub    $0xc,%esp
801057eb:	53                   	push   %ebx
801057ec:	e8 2f bf ff ff       	call   80101720 <iunlock>
  iput(proc->cwd);
801057f1:	58                   	pop    %eax
801057f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057f8:	ff 70 68             	pushl  0x68(%eax)
801057fb:	e8 80 bf ff ff       	call   80101780 <iput>
  end_op();
80105800:	e8 8b d5 ff ff       	call   80102d90 <end_op>
  proc->cwd = ip;
80105805:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return 0;
8010580b:	83 c4 10             	add    $0x10,%esp
  proc->cwd = ip;
8010580e:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
80105811:	31 c0                	xor    %eax,%eax
}
80105813:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105816:	c9                   	leave  
80105817:	c3                   	ret    
80105818:	90                   	nop
80105819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	53                   	push   %ebx
80105824:	e8 b7 c0 ff ff       	call   801018e0 <iunlockput>
    end_op();
80105829:	e8 62 d5 ff ff       	call   80102d90 <end_op>
    return -1;
8010582e:	83 c4 10             	add    $0x10,%esp
80105831:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105836:	eb db                	jmp    80105813 <sys_chdir+0x73>
80105838:	90                   	nop
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105840:	e8 4b d5 ff ff       	call   80102d90 <end_op>
    return -1;
80105845:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584a:	eb c7                	jmp    80105813 <sys_chdir+0x73>
8010584c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105850 <sys_exec>:

int
sys_exec(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	57                   	push   %edi
80105854:	56                   	push   %esi
80105855:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105856:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010585c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105862:	50                   	push   %eax
80105863:	6a 00                	push   $0x0
80105865:	e8 e6 f4 ff ff       	call   80104d50 <argstr>
8010586a:	83 c4 10             	add    $0x10,%esp
8010586d:	85 c0                	test   %eax,%eax
8010586f:	0f 88 87 00 00 00    	js     801058fc <sys_exec+0xac>
80105875:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010587b:	83 ec 08             	sub    $0x8,%esp
8010587e:	50                   	push   %eax
8010587f:	6a 01                	push   $0x1
80105881:	e8 3a f4 ff ff       	call   80104cc0 <argint>
80105886:	83 c4 10             	add    $0x10,%esp
80105889:	85 c0                	test   %eax,%eax
8010588b:	78 6f                	js     801058fc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010588d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105893:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105896:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105898:	68 80 00 00 00       	push   $0x80
8010589d:	6a 00                	push   $0x0
8010589f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801058a5:	50                   	push   %eax
801058a6:	e8 35 f1 ff ff       	call   801049e0 <memset>
801058ab:	83 c4 10             	add    $0x10,%esp
801058ae:	eb 2c                	jmp    801058dc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801058b0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058b6:	85 c0                	test   %eax,%eax
801058b8:	74 56                	je     80105910 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058ba:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801058c0:	83 ec 08             	sub    $0x8,%esp
801058c3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801058c6:	52                   	push   %edx
801058c7:	50                   	push   %eax
801058c8:	e8 93 f3 ff ff       	call   80104c60 <fetchstr>
801058cd:	83 c4 10             	add    $0x10,%esp
801058d0:	85 c0                	test   %eax,%eax
801058d2:	78 28                	js     801058fc <sys_exec+0xac>
  for(i=0;; i++){
801058d4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801058d7:	83 fb 20             	cmp    $0x20,%ebx
801058da:	74 20                	je     801058fc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058dc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058e2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801058e9:	83 ec 08             	sub    $0x8,%esp
801058ec:	57                   	push   %edi
801058ed:	01 f0                	add    %esi,%eax
801058ef:	50                   	push   %eax
801058f0:	e8 3b f3 ff ff       	call   80104c30 <fetchint>
801058f5:	83 c4 10             	add    $0x10,%esp
801058f8:	85 c0                	test   %eax,%eax
801058fa:	79 b4                	jns    801058b0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801058fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801058ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105904:	5b                   	pop    %ebx
80105905:	5e                   	pop    %esi
80105906:	5f                   	pop    %edi
80105907:	5d                   	pop    %ebp
80105908:	c3                   	ret    
80105909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105910:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105916:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105919:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105920:	00 00 00 00 
  return exec(path, argv);
80105924:	50                   	push   %eax
80105925:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010592b:	e8 c0 b0 ff ff       	call   801009f0 <exec>
80105930:	83 c4 10             	add    $0x10,%esp
}
80105933:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105936:	5b                   	pop    %ebx
80105937:	5e                   	pop    %esi
80105938:	5f                   	pop    %edi
80105939:	5d                   	pop    %ebp
8010593a:	c3                   	ret    
8010593b:	90                   	nop
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_pipe>:

int
sys_pipe(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	57                   	push   %edi
80105944:	56                   	push   %esi
80105945:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105946:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105949:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010594c:	6a 08                	push   $0x8
8010594e:	50                   	push   %eax
8010594f:	6a 00                	push   $0x0
80105951:	e8 aa f3 ff ff       	call   80104d00 <argptr>
80105956:	83 c4 10             	add    $0x10,%esp
80105959:	85 c0                	test   %eax,%eax
8010595b:	0f 88 a4 00 00 00    	js     80105a05 <sys_pipe+0xc5>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105961:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105964:	83 ec 08             	sub    $0x8,%esp
80105967:	50                   	push   %eax
80105968:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010596b:	50                   	push   %eax
8010596c:	e8 5f db ff ff       	call   801034d0 <pipealloc>
80105971:	83 c4 10             	add    $0x10,%esp
80105974:	85 c0                	test   %eax,%eax
80105976:	0f 88 89 00 00 00    	js     80105a05 <sys_pipe+0xc5>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010597c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
    if(proc->ofile[fd] == 0){
8010597f:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
  for(fd = 0; fd < NOFILE; fd++){
80105986:	31 c0                	xor    %eax,%eax
80105988:	eb 0e                	jmp    80105998 <sys_pipe+0x58>
8010598a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105990:	83 c0 01             	add    $0x1,%eax
80105993:	83 f8 10             	cmp    $0x10,%eax
80105996:	74 58                	je     801059f0 <sys_pipe+0xb0>
    if(proc->ofile[fd] == 0){
80105998:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
8010599c:	85 d2                	test   %edx,%edx
8010599e:	75 f0                	jne    80105990 <sys_pipe+0x50>
801059a0:	8d 34 81             	lea    (%ecx,%eax,4),%esi
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801059a6:	31 d2                	xor    %edx,%edx
      proc->ofile[fd] = f;
801059a8:	89 5e 28             	mov    %ebx,0x28(%esi)
801059ab:	eb 0b                	jmp    801059b8 <sys_pipe+0x78>
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801059b0:	83 c2 01             	add    $0x1,%edx
801059b3:	83 fa 10             	cmp    $0x10,%edx
801059b6:	74 28                	je     801059e0 <sys_pipe+0xa0>
    if(proc->ofile[fd] == 0){
801059b8:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
801059bd:	75 f1                	jne    801059b0 <sys_pipe+0x70>
      proc->ofile[fd] = f;
801059bf:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801059c3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801059c6:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
801059c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059cb:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801059ce:	31 c0                	xor    %eax,%eax
}
801059d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059d3:	5b                   	pop    %ebx
801059d4:	5e                   	pop    %esi
801059d5:	5f                   	pop    %edi
801059d6:	5d                   	pop    %ebp
801059d7:	c3                   	ret    
801059d8:	90                   	nop
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      proc->ofile[fd0] = 0;
801059e0:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
801059e7:	89 f6                	mov    %esi,%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    fileclose(rf);
801059f0:	83 ec 0c             	sub    $0xc,%esp
801059f3:	53                   	push   %ebx
801059f4:	e8 17 b4 ff ff       	call   80100e10 <fileclose>
    fileclose(wf);
801059f9:	58                   	pop    %eax
801059fa:	ff 75 e4             	pushl  -0x1c(%ebp)
801059fd:	e8 0e b4 ff ff       	call   80100e10 <fileclose>
    return -1;
80105a02:	83 c4 10             	add    $0x10,%esp
80105a05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0a:	eb c4                	jmp    801059d0 <sys_pipe+0x90>
80105a0c:	66 90                	xchg   %ax,%ax
80105a0e:	66 90                	xchg   %ax,%ax

80105a10 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105a13:	5d                   	pop    %ebp
  return fork();
80105a14:	e9 57 e1 ff ff       	jmp    80103b70 <fork>
80105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_exit>:

int
sys_exit(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a26:	e8 f5 e3 ff ff       	call   80103e20 <exit>
  return 0;  // not reached
}
80105a2b:	31 c0                	xor    %eax,%eax
80105a2d:	c9                   	leave  
80105a2e:	c3                   	ret    
80105a2f:	90                   	nop

80105a30 <sys_wait>:

int
sys_wait(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105a33:	5d                   	pop    %ebp
  return wait();
80105a34:	e9 37 e6 ff ff       	jmp    80104070 <wait>
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_kill>:

int
sys_kill(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a49:	50                   	push   %eax
80105a4a:	6a 00                	push   $0x0
80105a4c:	e8 6f f2 ff ff       	call   80104cc0 <argint>
80105a51:	83 c4 10             	add    $0x10,%esp
80105a54:	85 c0                	test   %eax,%eax
80105a56:	78 18                	js     80105a70 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a58:	83 ec 0c             	sub    $0xc,%esp
80105a5b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a5e:	e8 5d e7 ff ff       	call   801041c0 <kill>
80105a63:	83 c4 10             	add    $0x10,%esp
}
80105a66:	c9                   	leave  
80105a67:	c3                   	ret    
80105a68:	90                   	nop
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a75:	c9                   	leave  
80105a76:	c3                   	ret    
80105a77:	89 f6                	mov    %esi,%esi
80105a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a80 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105a80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
{
80105a86:	55                   	push   %ebp
80105a87:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105a89:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a8c:	5d                   	pop    %ebp
80105a8d:	c3                   	ret    
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a9a:	50                   	push   %eax
80105a9b:	6a 00                	push   $0x0
80105a9d:	e8 1e f2 ff ff       	call   80104cc0 <argint>
80105aa2:	83 c4 10             	add    $0x10,%esp
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	78 27                	js     80105ad0 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
80105aa9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
80105aaf:	83 ec 0c             	sub    $0xc,%esp
  addr = proc->sz;
80105ab2:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ab4:	ff 75 f4             	pushl  -0xc(%ebp)
80105ab7:	e8 34 e0 ff ff       	call   80103af0 <growproc>
80105abc:	83 c4 10             	add    $0x10,%esp
80105abf:	85 c0                	test   %eax,%eax
80105ac1:	78 0d                	js     80105ad0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ac3:	89 d8                	mov    %ebx,%eax
80105ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ac8:	c9                   	leave  
80105ac9:	c3                   	ret    
80105aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105ad0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ad5:	eb ec                	jmp    80105ac3 <sys_sbrk+0x33>
80105ad7:	89 f6                	mov    %esi,%esi
80105ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ae0 <sys_sleep>:

int
sys_sleep(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ae4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ae7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aea:	50                   	push   %eax
80105aeb:	6a 00                	push   $0x0
80105aed:	e8 ce f1 ff ff       	call   80104cc0 <argint>
80105af2:	83 c4 10             	add    $0x10,%esp
80105af5:	85 c0                	test   %eax,%eax
80105af7:	0f 88 8a 00 00 00    	js     80105b87 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105afd:	83 ec 0c             	sub    $0xc,%esp
80105b00:	68 20 ea 14 80       	push   $0x8014ea20
80105b05:	e8 36 ea ff ff       	call   80104540 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b0d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105b10:	8b 1d 60 f2 14 80    	mov    0x8014f260,%ebx
  while(ticks - ticks0 < n){
80105b16:	85 d2                	test   %edx,%edx
80105b18:	75 27                	jne    80105b41 <sys_sleep+0x61>
80105b1a:	eb 54                	jmp    80105b70 <sys_sleep+0x90>
80105b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b20:	83 ec 08             	sub    $0x8,%esp
80105b23:	68 20 ea 14 80       	push   $0x8014ea20
80105b28:	68 60 f2 14 80       	push   $0x8014f260
80105b2d:	e8 7e e4 ff ff       	call   80103fb0 <sleep>
  while(ticks - ticks0 < n){
80105b32:	a1 60 f2 14 80       	mov    0x8014f260,%eax
80105b37:	83 c4 10             	add    $0x10,%esp
80105b3a:	29 d8                	sub    %ebx,%eax
80105b3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b3f:	73 2f                	jae    80105b70 <sys_sleep+0x90>
    if(proc->killed){
80105b41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b47:	8b 40 24             	mov    0x24(%eax),%eax
80105b4a:	85 c0                	test   %eax,%eax
80105b4c:	74 d2                	je     80105b20 <sys_sleep+0x40>
      release(&tickslock);
80105b4e:	83 ec 0c             	sub    $0xc,%esp
80105b51:	68 20 ea 14 80       	push   $0x8014ea20
80105b56:	e8 a5 eb ff ff       	call   80104700 <release>
      return -1;
80105b5b:	83 c4 10             	add    $0x10,%esp
80105b5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105b63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b66:	c9                   	leave  
80105b67:	c3                   	ret    
80105b68:	90                   	nop
80105b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	68 20 ea 14 80       	push   $0x8014ea20
80105b78:	e8 83 eb ff ff       	call   80104700 <release>
  return 0;
80105b7d:	83 c4 10             	add    $0x10,%esp
80105b80:	31 c0                	xor    %eax,%eax
}
80105b82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b85:	c9                   	leave  
80105b86:	c3                   	ret    
    return -1;
80105b87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b8c:	eb f4                	jmp    80105b82 <sys_sleep+0xa2>
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	53                   	push   %ebx
80105b94:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b97:	68 20 ea 14 80       	push   $0x8014ea20
80105b9c:	e8 9f e9 ff ff       	call   80104540 <acquire>
  xticks = ticks;
80105ba1:	8b 1d 60 f2 14 80    	mov    0x8014f260,%ebx
  release(&tickslock);
80105ba7:	c7 04 24 20 ea 14 80 	movl   $0x8014ea20,(%esp)
80105bae:	e8 4d eb ff ff       	call   80104700 <release>
  return xticks;
}
80105bb3:	89 d8                	mov    %ebx,%eax
80105bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bb8:	c9                   	leave  
80105bb9:	c3                   	ret    
80105bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bc0 <sys_getcpuid>:

//ljn
int sys_getcpuid()
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
return getcpuid ();
}
80105bc3:	5d                   	pop    %ebp
return getcpuid ();
80105bc4:	e9 07 de ff ff       	jmp    801039d0 <getcpuid>
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_changepri>:
int sys_changepri (void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 20             	sub    $0x20,%esp
  int pid, pr;
  if ( argint(0, &pid) < 0 )
80105bd6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bd9:	50                   	push   %eax
80105bda:	6a 00                	push   $0x0
80105bdc:	e8 df f0 ff ff       	call   80104cc0 <argint>
80105be1:	83 c4 10             	add    $0x10,%esp
80105be4:	85 c0                	test   %eax,%eax
80105be6:	78 28                	js     80105c10 <sys_changepri+0x40>
        return -1;
  if ( argint(1, &pr) < 0 )
80105be8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105beb:	83 ec 08             	sub    $0x8,%esp
80105bee:	50                   	push   %eax
80105bef:	6a 01                	push   $0x1
80105bf1:	e8 ca f0 ff ff       	call   80104cc0 <argint>
80105bf6:	83 c4 10             	add    $0x10,%esp
80105bf9:	85 c0                	test   %eax,%eax
80105bfb:	78 13                	js     80105c10 <sys_changepri+0x40>
        return -1;
  return changepri ( pid, pr );
80105bfd:	83 ec 08             	sub    $0x8,%esp
80105c00:	ff 75 f4             	pushl  -0xc(%ebp)
80105c03:	ff 75 f0             	pushl  -0x10(%ebp)
80105c06:	e8 15 e7 ff ff       	call   80104320 <changepri>
80105c0b:	83 c4 10             	add    $0x10,%esp
}
80105c0e:	c9                   	leave  
80105c0f:	c3                   	ret    
        return -1;
80105c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c15:	c9                   	leave  
80105c16:	c3                   	ret    
80105c17:	89 f6                	mov    %esi,%esi
80105c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c20 <sys_sh_var_read>:
int sys_sh_var_read(){
80105c20:	55                   	push   %ebp
  return sh_var_for_sem_demo;//读取全局变量也就是临界资源
}
80105c21:	a1 fc 06 11 80       	mov    0x801106fc,%eax
int sys_sh_var_read(){
80105c26:	89 e5                	mov    %esp,%ebp
}
80105c28:	5d                   	pop    %ebp
80105c29:	c3                   	ret    
80105c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c30 <sys_sh_var_write>:
int sys_sh_var_write(){
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	83 ec 20             	sub    $0x20,%esp
  int n;//参数
  if(argint(0,&n) < 0)//如果参数小于零就返回-1 error
80105c36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c39:	50                   	push   %eax
80105c3a:	6a 00                	push   $0x0
80105c3c:	e8 7f f0 ff ff       	call   80104cc0 <argint>
80105c41:	83 c4 10             	add    $0x10,%esp
80105c44:	85 c0                	test   %eax,%eax
80105c46:	78 10                	js     80105c58 <sys_sh_var_write+0x28>
    return -1;
  sh_var_for_sem_demo = n;//设置临界资源为参数n
80105c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4b:	a3 fc 06 11 80       	mov    %eax,0x801106fc
  return sh_var_for_sem_demo;//返回参数数值
}
80105c50:	c9                   	leave  
80105c51:	c3                   	ret    
80105c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105c58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c5d:	c9                   	leave  
80105c5e:	c3                   	ret    
80105c5f:	90                   	nop

80105c60 <sys_myMalloc>:

int sys_myMalloc(){
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	83 ec 20             	sub    $0x20,%esp
  int size;
  if(argint(0,&size)<0) return 0;//接受传进来的size参数
80105c66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c69:	50                   	push   %eax
80105c6a:	6a 00                	push   $0x0
80105c6c:	e8 4f f0 ff ff       	call   80104cc0 <argint>
80105c71:	83 c4 10             	add    $0x10,%esp
80105c74:	31 d2                	xor    %edx,%edx
80105c76:	85 c0                	test   %eax,%eax
80105c78:	78 10                	js     80105c8a <sys_myMalloc+0x2a>
  void* res=myMalloc(size);//分配slab
80105c7a:	83 ec 0c             	sub    $0xc,%esp
80105c7d:	ff 75 f4             	pushl  -0xc(%ebp)
80105c80:	e8 3b e7 ff ff       	call   801043c0 <myMalloc>
  return (int)res;//返回操作结果
80105c85:	83 c4 10             	add    $0x10,%esp
  void* res=myMalloc(size);//分配slab
80105c88:	89 c2                	mov    %eax,%edx
}
80105c8a:	89 d0                	mov    %edx,%eax
80105c8c:	c9                   	leave  
80105c8d:	c3                   	ret    
80105c8e:	66 90                	xchg   %ax,%ax

80105c90 <sys_myFree>:
int sys_myFree(){
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	83 ec 20             	sub    $0x20,%esp
  int va;
  if(argint(0,&va)<0) return 0;//接受传进来的虚拟地址参数
80105c96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c99:	50                   	push   %eax
80105c9a:	6a 00                	push   $0x0
80105c9c:	e8 1f f0 ff ff       	call   80104cc0 <argint>
80105ca1:	83 c4 10             	add    $0x10,%esp
80105ca4:	31 d2                	xor    %edx,%edx
80105ca6:	85 c0                	test   %eax,%eax
80105ca8:	78 10                	js     80105cba <sys_myFree+0x2a>
  int res=myFree((void*)va);//释放slab
80105caa:	83 ec 0c             	sub    $0xc,%esp
80105cad:	ff 75 f4             	pushl  -0xc(%ebp)
80105cb0:	e8 4b e7 ff ff       	call   80104400 <myFree>
  return res;//返回操作结果
80105cb5:	83 c4 10             	add    $0x10,%esp
  int res=myFree((void*)va);//释放slab
80105cb8:	89 c2                	mov    %eax,%edx
}
80105cba:	89 d0                	mov    %edx,%eax
80105cbc:	c9                   	leave  
80105cbd:	c3                   	ret    
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <sys_myFork>:

int sys_myFork(void){
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
  return myFork();
80105cc3:	5d                   	pop    %ebp
  return myFork();
80105cc4:	e9 57 e7 ff ff       	jmp    80104420 <myFork>
80105cc9:	66 90                	xchg   %ax,%ax
80105ccb:	66 90                	xchg   %ax,%ax
80105ccd:	66 90                	xchg   %ax,%ax
80105ccf:	90                   	nop

80105cd0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105cd0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cd1:	b8 34 00 00 00       	mov    $0x34,%eax
80105cd6:	ba 43 00 00 00       	mov    $0x43,%edx
80105cdb:	89 e5                	mov    %esp,%ebp
80105cdd:	83 ec 14             	sub    $0x14,%esp
80105ce0:	ee                   	out    %al,(%dx)
80105ce1:	ba 40 00 00 00       	mov    $0x40,%edx
80105ce6:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
80105ceb:	ee                   	out    %al,(%dx)
80105cec:	b8 2e 00 00 00       	mov    $0x2e,%eax
80105cf1:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
80105cf2:	6a 00                	push   $0x0
80105cf4:	e8 07 d7 ff ff       	call   80103400 <picenable>
}
80105cf9:	83 c4 10             	add    $0x10,%esp
80105cfc:	c9                   	leave  
80105cfd:	c3                   	ret    

80105cfe <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105cfe:	1e                   	push   %ds
  pushl %es
80105cff:	06                   	push   %es
  pushl %fs
80105d00:	0f a0                	push   %fs
  pushl %gs
80105d02:	0f a8                	push   %gs
  pushal
80105d04:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105d05:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d09:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d0b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80105d0d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105d11:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105d13:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d15:	54                   	push   %esp
  call trap
80105d16:	e8 c5 00 00 00       	call   80105de0 <trap>
  addl $4, %esp
80105d1b:	83 c4 04             	add    $0x4,%esp

80105d1e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d1e:	61                   	popa   
  popl %gs
80105d1f:	0f a9                	pop    %gs
  popl %fs
80105d21:	0f a1                	pop    %fs
  popl %es
80105d23:	07                   	pop    %es
  popl %ds
80105d24:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d25:	83 c4 08             	add    $0x8,%esp
  iret
80105d28:	cf                   	iret   
80105d29:	66 90                	xchg   %ax,%ax
80105d2b:	66 90                	xchg   %ax,%ax
80105d2d:	66 90                	xchg   %ax,%ax
80105d2f:	90                   	nop

80105d30 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d30:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d31:	31 c0                	xor    %eax,%eax
{
80105d33:	89 e5                	mov    %esp,%ebp
80105d35:	83 ec 08             	sub    $0x8,%esp
80105d38:	90                   	nop
80105d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d40:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105d47:	c7 04 c5 62 ea 14 80 	movl   $0x8e000008,-0x7feb159e(,%eax,8)
80105d4e:	08 00 00 8e 
80105d52:	66 89 14 c5 60 ea 14 	mov    %dx,-0x7feb15a0(,%eax,8)
80105d59:	80 
80105d5a:	c1 ea 10             	shr    $0x10,%edx
80105d5d:	66 89 14 c5 66 ea 14 	mov    %dx,-0x7feb159a(,%eax,8)
80105d64:	80 
  for(i = 0; i < 256; i++)
80105d65:	83 c0 01             	add    $0x1,%eax
80105d68:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d6d:	75 d1                	jne    80105d40 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d6f:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

  initlock(&tickslock, "time");
80105d74:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d77:	c7 05 62 ec 14 80 08 	movl   $0xef000008,0x8014ec62
80105d7e:	00 00 ef 
  initlock(&tickslock, "time");
80105d81:	68 fd 80 10 80       	push   $0x801080fd
80105d86:	68 20 ea 14 80       	push   $0x8014ea20
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d8b:	66 a3 60 ec 14 80    	mov    %ax,0x8014ec60
80105d91:	c1 e8 10             	shr    $0x10,%eax
80105d94:	66 a3 66 ec 14 80    	mov    %ax,0x8014ec66
  initlock(&tickslock, "time");
80105d9a:	e8 81 e7 ff ff       	call   80104520 <initlock>
}
80105d9f:	83 c4 10             	add    $0x10,%esp
80105da2:	c9                   	leave  
80105da3:	c3                   	ret    
80105da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105db0 <idtinit>:

void
idtinit(void)
{
80105db0:	55                   	push   %ebp
  pd[0] = size-1;
80105db1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105db6:	89 e5                	mov    %esp,%ebp
80105db8:	83 ec 10             	sub    $0x10,%esp
80105dbb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105dbf:	b8 60 ea 14 80       	mov    $0x8014ea60,%eax
80105dc4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105dc8:	c1 e8 10             	shr    $0x10,%eax
80105dcb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105dcf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105dd2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105dd5:	c9                   	leave  
80105dd6:	c3                   	ret    
80105dd7:	89 f6                	mov    %esi,%esi
80105dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105de0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	57                   	push   %edi
80105de4:	56                   	push   %esi
80105de5:	53                   	push   %ebx
80105de6:	83 ec 0c             	sub    $0xc,%esp
80105de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105dec:	8b 43 30             	mov    0x30(%ebx),%eax
80105def:	83 f8 40             	cmp    $0x40,%eax
80105df2:	74 6c                	je     80105e60 <trap+0x80>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105df4:	83 e8 0e             	sub    $0xe,%eax
80105df7:	83 f8 31             	cmp    $0x31,%eax
80105dfa:	0f 87 98 00 00 00    	ja     80105e98 <trap+0xb8>
80105e00:	ff 24 85 b0 81 10 80 	jmp    *-0x7fef7e50(,%eax,4)
80105e07:	89 f6                	mov    %esi,%esi
80105e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105e10:	e8 0b ca ff ff       	call   80102820 <cpunum>
80105e15:	85 c0                	test   %eax,%eax
80105e17:	0f 84 f3 01 00 00    	je     80106010 <trap+0x230>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105e1d:	e8 ae ca ff ff       	call   801028d0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105e22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e28:	85 c0                	test   %eax,%eax
80105e2a:	74 29                	je     80105e55 <trap+0x75>
80105e2c:	8b 50 24             	mov    0x24(%eax),%edx
80105e2f:	85 d2                	test   %edx,%edx
80105e31:	0f 85 b6 00 00 00    	jne    80105eed <trap+0x10d>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80105e37:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e3b:	0f 84 77 01 00 00    	je     80105fb8 <trap+0x1d8>
      yield(); 
    }
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105e41:	8b 40 24             	mov    0x24(%eax),%eax
80105e44:	85 c0                	test   %eax,%eax
80105e46:	74 0d                	je     80105e55 <trap+0x75>
80105e48:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e4c:	83 e0 03             	and    $0x3,%eax
80105e4f:	66 83 f8 03          	cmp    $0x3,%ax
80105e53:	74 31                	je     80105e86 <trap+0xa6>
    exit();
}
80105e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e58:	5b                   	pop    %ebx
80105e59:	5e                   	pop    %esi
80105e5a:	5f                   	pop    %edi
80105e5b:	5d                   	pop    %ebp
80105e5c:	c3                   	ret    
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(proc->killed)
80105e60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e66:	8b 50 24             	mov    0x24(%eax),%edx
80105e69:	85 d2                	test   %edx,%edx
80105e6b:	0f 85 67 01 00 00    	jne    80105fd8 <trap+0x1f8>
    proc->tf = tf;
80105e71:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e74:	e8 57 ef ff ff       	call   80104dd0 <syscall>
    if(proc->killed)
80105e79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e7f:	8b 40 24             	mov    0x24(%eax),%eax
80105e82:	85 c0                	test   %eax,%eax
80105e84:	74 cf                	je     80105e55 <trap+0x75>
}
80105e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e89:	5b                   	pop    %ebx
80105e8a:	5e                   	pop    %esi
80105e8b:	5f                   	pop    %edi
80105e8c:	5d                   	pop    %ebp
      exit();
80105e8d:	e9 8e df ff ff       	jmp    80103e20 <exit>
80105e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(proc == 0 || (tf->cs&3) == 0){
80105e98:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80105e9f:	8b 73 38             	mov    0x38(%ebx),%esi
80105ea2:	85 c9                	test   %ecx,%ecx
80105ea4:	0f 84 9a 01 00 00    	je     80106044 <trap+0x264>
80105eaa:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105eae:	0f 84 90 01 00 00    	je     80106044 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105eb4:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eb7:	e8 64 c9 ff ff       	call   80102820 <cpunum>
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105ebc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ec3:	57                   	push   %edi
80105ec4:	56                   	push   %esi
80105ec5:	50                   	push   %eax
80105ec6:	ff 73 34             	pushl  0x34(%ebx)
80105ec9:	ff 73 30             	pushl  0x30(%ebx)
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105ecc:	8d 42 6c             	lea    0x6c(%edx),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ecf:	50                   	push   %eax
80105ed0:	ff 72 10             	pushl  0x10(%edx)
80105ed3:	68 6c 81 10 80       	push   $0x8010816c
80105ed8:	e8 63 a7 ff ff       	call   80100640 <cprintf>
    proc->killed = 1;
80105edd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ee3:	83 c4 20             	add    $0x20,%esp
80105ee6:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105eed:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105ef1:	83 e2 03             	and    $0x3,%edx
80105ef4:	66 83 fa 03          	cmp    $0x3,%dx
80105ef8:	0f 85 39 ff ff ff    	jne    80105e37 <trap+0x57>
    exit();
80105efe:	e8 1d df ff ff       	call   80103e20 <exit>
80105f03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80105f09:	85 c0                	test   %eax,%eax
80105f0b:	0f 85 26 ff ff ff    	jne    80105e37 <trap+0x57>
80105f11:	e9 3f ff ff ff       	jmp    80105e55 <trap+0x75>
80105f16:	8d 76 00             	lea    0x0(%esi),%esi
80105f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f20:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f24:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f27:	e8 f4 c8 ff ff       	call   80102820 <cpunum>
80105f2c:	57                   	push   %edi
80105f2d:	56                   	push   %esi
80105f2e:	50                   	push   %eax
80105f2f:	68 14 81 10 80       	push   $0x80108114
80105f34:	e8 07 a7 ff ff       	call   80100640 <cprintf>
    lapiceoi();
80105f39:	e8 92 c9 ff ff       	call   801028d0 <lapiceoi>
    break;
80105f3e:	83 c4 10             	add    $0x10,%esp
80105f41:	e9 dc fe ff ff       	jmp    80105e22 <trap+0x42>
80105f46:	8d 76 00             	lea    0x0(%esi),%esi
80105f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    kbdintr();
80105f50:	e8 ab c7 ff ff       	call   80102700 <kbdintr>
    lapiceoi();
80105f55:	e8 76 c9 ff ff       	call   801028d0 <lapiceoi>
    break;
80105f5a:	e9 c3 fe ff ff       	jmp    80105e22 <trap+0x42>
80105f5f:	90                   	nop
    uartintr();
80105f60:	e8 7b 02 00 00       	call   801061e0 <uartintr>
    lapiceoi();
80105f65:	e8 66 c9 ff ff       	call   801028d0 <lapiceoi>
    break;
80105f6a:	e9 b3 fe ff ff       	jmp    80105e22 <trap+0x42>
80105f6f:	90                   	nop
    cprintf("pid:%d trap,",proc->pid);
80105f70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f76:	83 ec 08             	sub    $0x8,%esp
80105f79:	ff 70 10             	pushl  0x10(%eax)
80105f7c:	68 02 81 10 80       	push   $0x80108102
80105f81:	e8 ba a6 ff ff       	call   80100640 <cprintf>
80105f86:	0f 20 d0             	mov    %cr2,%eax
    copy_on_write(proc->pgdir,(char*)(rcr2()));
80105f89:	5e                   	pop    %esi
80105f8a:	5f                   	pop    %edi
80105f8b:	50                   	push   %eax
80105f8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f92:	ff 70 04             	pushl  0x4(%eax)
80105f95:	e8 e6 18 00 00       	call   80107880 <copy_on_write>
    break;
80105f9a:	83 c4 10             	add    $0x10,%esp
80105f9d:	e9 80 fe ff ff       	jmp    80105e22 <trap+0x42>
80105fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ideintr();
80105fa8:	e8 b3 c0 ff ff       	call   80102060 <ideintr>
80105fad:	e9 6b fe ff ff       	jmp    80105e1d <trap+0x3d>
80105fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80105fb8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105fbc:	0f 85 7f fe ff ff    	jne    80105e41 <trap+0x61>
    if(!proc->tickk){
80105fc2:	8b 50 7c             	mov    0x7c(%eax),%edx
80105fc5:	83 ea 01             	sub    $0x1,%edx
80105fc8:	74 26                	je     80105ff0 <trap+0x210>
    proc->tickk--;
80105fca:	89 50 7c             	mov    %edx,0x7c(%eax)
80105fcd:	e9 6f fe ff ff       	jmp    80105e41 <trap+0x61>
80105fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105fd8:	e8 43 de ff ff       	call   80103e20 <exit>
80105fdd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105fe3:	e9 89 fe ff ff       	jmp    80105e71 <trap+0x91>
80105fe8:	90                   	nop
80105fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      proc->tickk=8;
80105ff0:	c7 40 7c 08 00 00 00 	movl   $0x8,0x7c(%eax)
      yield(); 
80105ff7:	e8 74 df ff ff       	call   80103f70 <yield>
80105ffc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106002:	85 c0                	test   %eax,%eax
80106004:	0f 85 37 fe ff ff    	jne    80105e41 <trap+0x61>
8010600a:	e9 46 fe ff ff       	jmp    80105e55 <trap+0x75>
8010600f:	90                   	nop
      acquire(&tickslock);
80106010:	83 ec 0c             	sub    $0xc,%esp
80106013:	68 20 ea 14 80       	push   $0x8014ea20
80106018:	e8 23 e5 ff ff       	call   80104540 <acquire>
      wakeup(&ticks);
8010601d:	c7 04 24 60 f2 14 80 	movl   $0x8014f260,(%esp)
      ticks++;
80106024:	83 05 60 f2 14 80 01 	addl   $0x1,0x8014f260
      wakeup(&ticks);
8010602b:	e8 30 e1 ff ff       	call   80104160 <wakeup>
      release(&tickslock);
80106030:	c7 04 24 20 ea 14 80 	movl   $0x8014ea20,(%esp)
80106037:	e8 c4 e6 ff ff       	call   80104700 <release>
8010603c:	83 c4 10             	add    $0x10,%esp
8010603f:	e9 d9 fd ff ff       	jmp    80105e1d <trap+0x3d>
80106044:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106047:	e8 d4 c7 ff ff       	call   80102820 <cpunum>
8010604c:	83 ec 0c             	sub    $0xc,%esp
8010604f:	57                   	push   %edi
80106050:	56                   	push   %esi
80106051:	50                   	push   %eax
80106052:	ff 73 30             	pushl  0x30(%ebx)
80106055:	68 38 81 10 80       	push   $0x80108138
8010605a:	e8 e1 a5 ff ff       	call   80100640 <cprintf>
      panic("trap");
8010605f:	83 c4 14             	add    $0x14,%esp
80106062:	68 0f 81 10 80       	push   $0x8010810f
80106067:	e8 04 a3 ff ff       	call   80100370 <panic>
8010606c:	66 90                	xchg   %ax,%ax
8010606e:	66 90                	xchg   %ax,%ax

80106070 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106070:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
{
80106075:	55                   	push   %ebp
80106076:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106078:	85 c0                	test   %eax,%eax
8010607a:	74 1c                	je     80106098 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010607c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106081:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106082:	a8 01                	test   $0x1,%al
80106084:	74 12                	je     80106098 <uartgetc+0x28>
80106086:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010608b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010608c:	0f b6 c0             	movzbl %al,%eax
}
8010608f:	5d                   	pop    %ebp
80106090:	c3                   	ret    
80106091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010609d:	5d                   	pop    %ebp
8010609e:	c3                   	ret    
8010609f:	90                   	nop

801060a0 <uartputc.part.0>:
uartputc(int c)
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	57                   	push   %edi
801060a4:	56                   	push   %esi
801060a5:	53                   	push   %ebx
801060a6:	89 c7                	mov    %eax,%edi
801060a8:	bb 80 00 00 00       	mov    $0x80,%ebx
801060ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801060b2:	83 ec 0c             	sub    $0xc,%esp
801060b5:	eb 1b                	jmp    801060d2 <uartputc.part.0+0x32>
801060b7:	89 f6                	mov    %esi,%esi
801060b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801060c0:	83 ec 0c             	sub    $0xc,%esp
801060c3:	6a 0a                	push   $0xa
801060c5:	e8 26 c8 ff ff       	call   801028f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060ca:	83 c4 10             	add    $0x10,%esp
801060cd:	83 eb 01             	sub    $0x1,%ebx
801060d0:	74 07                	je     801060d9 <uartputc.part.0+0x39>
801060d2:	89 f2                	mov    %esi,%edx
801060d4:	ec                   	in     (%dx),%al
801060d5:	a8 20                	test   $0x20,%al
801060d7:	74 e7                	je     801060c0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060d9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060de:	89 f8                	mov    %edi,%eax
801060e0:	ee                   	out    %al,(%dx)
}
801060e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060e4:	5b                   	pop    %ebx
801060e5:	5e                   	pop    %esi
801060e6:	5f                   	pop    %edi
801060e7:	5d                   	pop    %ebp
801060e8:	c3                   	ret    
801060e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060f0 <uartinit>:
{
801060f0:	55                   	push   %ebp
801060f1:	31 c9                	xor    %ecx,%ecx
801060f3:	89 c8                	mov    %ecx,%eax
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	57                   	push   %edi
801060f8:	56                   	push   %esi
801060f9:	53                   	push   %ebx
801060fa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801060ff:	89 da                	mov    %ebx,%edx
80106101:	83 ec 0c             	sub    $0xc,%esp
80106104:	ee                   	out    %al,(%dx)
80106105:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010610a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010610f:	89 fa                	mov    %edi,%edx
80106111:	ee                   	out    %al,(%dx)
80106112:	b8 0c 00 00 00       	mov    $0xc,%eax
80106117:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010611c:	ee                   	out    %al,(%dx)
8010611d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106122:	89 c8                	mov    %ecx,%eax
80106124:	89 f2                	mov    %esi,%edx
80106126:	ee                   	out    %al,(%dx)
80106127:	b8 03 00 00 00       	mov    $0x3,%eax
8010612c:	89 fa                	mov    %edi,%edx
8010612e:	ee                   	out    %al,(%dx)
8010612f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106134:	89 c8                	mov    %ecx,%eax
80106136:	ee                   	out    %al,(%dx)
80106137:	b8 01 00 00 00       	mov    $0x1,%eax
8010613c:	89 f2                	mov    %esi,%edx
8010613e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010613f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106144:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106145:	3c ff                	cmp    $0xff,%al
80106147:	74 5a                	je     801061a3 <uartinit+0xb3>
  uart = 1;
80106149:	c7 05 c4 b5 10 80 01 	movl   $0x1,0x8010b5c4
80106150:	00 00 00 
80106153:	89 da                	mov    %ebx,%edx
80106155:	ec                   	in     (%dx),%al
80106156:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010615b:	ec                   	in     (%dx),%al
  picenable(IRQ_COM1);
8010615c:	83 ec 0c             	sub    $0xc,%esp
8010615f:	6a 04                	push   $0x4
80106161:	e8 9a d2 ff ff       	call   80103400 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106166:	59                   	pop    %ecx
80106167:	5b                   	pop    %ebx
80106168:	6a 00                	push   $0x0
8010616a:	6a 04                	push   $0x4
  for(p="xv6...\n"; *p; p++)
8010616c:	bb 78 82 10 80       	mov    $0x80108278,%ebx
  ioapicenable(IRQ_COM1, 0);
80106171:	e8 4a c1 ff ff       	call   801022c0 <ioapicenable>
80106176:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106179:	b8 78 00 00 00       	mov    $0x78,%eax
8010617e:	eb 0a                	jmp    8010618a <uartinit+0x9a>
80106180:	83 c3 01             	add    $0x1,%ebx
80106183:	0f be 03             	movsbl (%ebx),%eax
80106186:	84 c0                	test   %al,%al
80106188:	74 19                	je     801061a3 <uartinit+0xb3>
  if(!uart)
8010618a:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
80106190:	85 d2                	test   %edx,%edx
80106192:	74 ec                	je     80106180 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106194:	83 c3 01             	add    $0x1,%ebx
80106197:	e8 04 ff ff ff       	call   801060a0 <uartputc.part.0>
8010619c:	0f be 03             	movsbl (%ebx),%eax
8010619f:	84 c0                	test   %al,%al
801061a1:	75 e7                	jne    8010618a <uartinit+0x9a>
}
801061a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061a6:	5b                   	pop    %ebx
801061a7:	5e                   	pop    %esi
801061a8:	5f                   	pop    %edi
801061a9:	5d                   	pop    %ebp
801061aa:	c3                   	ret    
801061ab:	90                   	nop
801061ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061b0 <uartputc>:
  if(!uart)
801061b0:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
{
801061b6:	55                   	push   %ebp
801061b7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801061b9:	85 d2                	test   %edx,%edx
{
801061bb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801061be:	74 10                	je     801061d0 <uartputc+0x20>
}
801061c0:	5d                   	pop    %ebp
801061c1:	e9 da fe ff ff       	jmp    801060a0 <uartputc.part.0>
801061c6:	8d 76 00             	lea    0x0(%esi),%esi
801061c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801061d0:	5d                   	pop    %ebp
801061d1:	c3                   	ret    
801061d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061e0 <uartintr>:

void
uartintr(void)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061e6:	68 70 60 10 80       	push   $0x80106070
801061eb:	e8 00 a6 ff ff       	call   801007f0 <consoleintr>
}
801061f0:	83 c4 10             	add    $0x10,%esp
801061f3:	c9                   	leave  
801061f4:	c3                   	ret    

801061f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $0
801061f7:	6a 00                	push   $0x0
  jmp alltraps
801061f9:	e9 00 fb ff ff       	jmp    80105cfe <alltraps>

801061fe <vector1>:
.globl vector1
vector1:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $1
80106200:	6a 01                	push   $0x1
  jmp alltraps
80106202:	e9 f7 fa ff ff       	jmp    80105cfe <alltraps>

80106207 <vector2>:
.globl vector2
vector2:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $2
80106209:	6a 02                	push   $0x2
  jmp alltraps
8010620b:	e9 ee fa ff ff       	jmp    80105cfe <alltraps>

80106210 <vector3>:
.globl vector3
vector3:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $3
80106212:	6a 03                	push   $0x3
  jmp alltraps
80106214:	e9 e5 fa ff ff       	jmp    80105cfe <alltraps>

80106219 <vector4>:
.globl vector4
vector4:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $4
8010621b:	6a 04                	push   $0x4
  jmp alltraps
8010621d:	e9 dc fa ff ff       	jmp    80105cfe <alltraps>

80106222 <vector5>:
.globl vector5
vector5:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $5
80106224:	6a 05                	push   $0x5
  jmp alltraps
80106226:	e9 d3 fa ff ff       	jmp    80105cfe <alltraps>

8010622b <vector6>:
.globl vector6
vector6:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $6
8010622d:	6a 06                	push   $0x6
  jmp alltraps
8010622f:	e9 ca fa ff ff       	jmp    80105cfe <alltraps>

80106234 <vector7>:
.globl vector7
vector7:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $7
80106236:	6a 07                	push   $0x7
  jmp alltraps
80106238:	e9 c1 fa ff ff       	jmp    80105cfe <alltraps>

8010623d <vector8>:
.globl vector8
vector8:
  pushl $8
8010623d:	6a 08                	push   $0x8
  jmp alltraps
8010623f:	e9 ba fa ff ff       	jmp    80105cfe <alltraps>

80106244 <vector9>:
.globl vector9
vector9:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $9
80106246:	6a 09                	push   $0x9
  jmp alltraps
80106248:	e9 b1 fa ff ff       	jmp    80105cfe <alltraps>

8010624d <vector10>:
.globl vector10
vector10:
  pushl $10
8010624d:	6a 0a                	push   $0xa
  jmp alltraps
8010624f:	e9 aa fa ff ff       	jmp    80105cfe <alltraps>

80106254 <vector11>:
.globl vector11
vector11:
  pushl $11
80106254:	6a 0b                	push   $0xb
  jmp alltraps
80106256:	e9 a3 fa ff ff       	jmp    80105cfe <alltraps>

8010625b <vector12>:
.globl vector12
vector12:
  pushl $12
8010625b:	6a 0c                	push   $0xc
  jmp alltraps
8010625d:	e9 9c fa ff ff       	jmp    80105cfe <alltraps>

80106262 <vector13>:
.globl vector13
vector13:
  pushl $13
80106262:	6a 0d                	push   $0xd
  jmp alltraps
80106264:	e9 95 fa ff ff       	jmp    80105cfe <alltraps>

80106269 <vector14>:
.globl vector14
vector14:
  pushl $14
80106269:	6a 0e                	push   $0xe
  jmp alltraps
8010626b:	e9 8e fa ff ff       	jmp    80105cfe <alltraps>

80106270 <vector15>:
.globl vector15
vector15:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $15
80106272:	6a 0f                	push   $0xf
  jmp alltraps
80106274:	e9 85 fa ff ff       	jmp    80105cfe <alltraps>

80106279 <vector16>:
.globl vector16
vector16:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $16
8010627b:	6a 10                	push   $0x10
  jmp alltraps
8010627d:	e9 7c fa ff ff       	jmp    80105cfe <alltraps>

80106282 <vector17>:
.globl vector17
vector17:
  pushl $17
80106282:	6a 11                	push   $0x11
  jmp alltraps
80106284:	e9 75 fa ff ff       	jmp    80105cfe <alltraps>

80106289 <vector18>:
.globl vector18
vector18:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $18
8010628b:	6a 12                	push   $0x12
  jmp alltraps
8010628d:	e9 6c fa ff ff       	jmp    80105cfe <alltraps>

80106292 <vector19>:
.globl vector19
vector19:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $19
80106294:	6a 13                	push   $0x13
  jmp alltraps
80106296:	e9 63 fa ff ff       	jmp    80105cfe <alltraps>

8010629b <vector20>:
.globl vector20
vector20:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $20
8010629d:	6a 14                	push   $0x14
  jmp alltraps
8010629f:	e9 5a fa ff ff       	jmp    80105cfe <alltraps>

801062a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $21
801062a6:	6a 15                	push   $0x15
  jmp alltraps
801062a8:	e9 51 fa ff ff       	jmp    80105cfe <alltraps>

801062ad <vector22>:
.globl vector22
vector22:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $22
801062af:	6a 16                	push   $0x16
  jmp alltraps
801062b1:	e9 48 fa ff ff       	jmp    80105cfe <alltraps>

801062b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $23
801062b8:	6a 17                	push   $0x17
  jmp alltraps
801062ba:	e9 3f fa ff ff       	jmp    80105cfe <alltraps>

801062bf <vector24>:
.globl vector24
vector24:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $24
801062c1:	6a 18                	push   $0x18
  jmp alltraps
801062c3:	e9 36 fa ff ff       	jmp    80105cfe <alltraps>

801062c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $25
801062ca:	6a 19                	push   $0x19
  jmp alltraps
801062cc:	e9 2d fa ff ff       	jmp    80105cfe <alltraps>

801062d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $26
801062d3:	6a 1a                	push   $0x1a
  jmp alltraps
801062d5:	e9 24 fa ff ff       	jmp    80105cfe <alltraps>

801062da <vector27>:
.globl vector27
vector27:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $27
801062dc:	6a 1b                	push   $0x1b
  jmp alltraps
801062de:	e9 1b fa ff ff       	jmp    80105cfe <alltraps>

801062e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $28
801062e5:	6a 1c                	push   $0x1c
  jmp alltraps
801062e7:	e9 12 fa ff ff       	jmp    80105cfe <alltraps>

801062ec <vector29>:
.globl vector29
vector29:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $29
801062ee:	6a 1d                	push   $0x1d
  jmp alltraps
801062f0:	e9 09 fa ff ff       	jmp    80105cfe <alltraps>

801062f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $30
801062f7:	6a 1e                	push   $0x1e
  jmp alltraps
801062f9:	e9 00 fa ff ff       	jmp    80105cfe <alltraps>

801062fe <vector31>:
.globl vector31
vector31:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $31
80106300:	6a 1f                	push   $0x1f
  jmp alltraps
80106302:	e9 f7 f9 ff ff       	jmp    80105cfe <alltraps>

80106307 <vector32>:
.globl vector32
vector32:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $32
80106309:	6a 20                	push   $0x20
  jmp alltraps
8010630b:	e9 ee f9 ff ff       	jmp    80105cfe <alltraps>

80106310 <vector33>:
.globl vector33
vector33:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $33
80106312:	6a 21                	push   $0x21
  jmp alltraps
80106314:	e9 e5 f9 ff ff       	jmp    80105cfe <alltraps>

80106319 <vector34>:
.globl vector34
vector34:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $34
8010631b:	6a 22                	push   $0x22
  jmp alltraps
8010631d:	e9 dc f9 ff ff       	jmp    80105cfe <alltraps>

80106322 <vector35>:
.globl vector35
vector35:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $35
80106324:	6a 23                	push   $0x23
  jmp alltraps
80106326:	e9 d3 f9 ff ff       	jmp    80105cfe <alltraps>

8010632b <vector36>:
.globl vector36
vector36:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $36
8010632d:	6a 24                	push   $0x24
  jmp alltraps
8010632f:	e9 ca f9 ff ff       	jmp    80105cfe <alltraps>

80106334 <vector37>:
.globl vector37
vector37:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $37
80106336:	6a 25                	push   $0x25
  jmp alltraps
80106338:	e9 c1 f9 ff ff       	jmp    80105cfe <alltraps>

8010633d <vector38>:
.globl vector38
vector38:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $38
8010633f:	6a 26                	push   $0x26
  jmp alltraps
80106341:	e9 b8 f9 ff ff       	jmp    80105cfe <alltraps>

80106346 <vector39>:
.globl vector39
vector39:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $39
80106348:	6a 27                	push   $0x27
  jmp alltraps
8010634a:	e9 af f9 ff ff       	jmp    80105cfe <alltraps>

8010634f <vector40>:
.globl vector40
vector40:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $40
80106351:	6a 28                	push   $0x28
  jmp alltraps
80106353:	e9 a6 f9 ff ff       	jmp    80105cfe <alltraps>

80106358 <vector41>:
.globl vector41
vector41:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $41
8010635a:	6a 29                	push   $0x29
  jmp alltraps
8010635c:	e9 9d f9 ff ff       	jmp    80105cfe <alltraps>

80106361 <vector42>:
.globl vector42
vector42:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $42
80106363:	6a 2a                	push   $0x2a
  jmp alltraps
80106365:	e9 94 f9 ff ff       	jmp    80105cfe <alltraps>

8010636a <vector43>:
.globl vector43
vector43:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $43
8010636c:	6a 2b                	push   $0x2b
  jmp alltraps
8010636e:	e9 8b f9 ff ff       	jmp    80105cfe <alltraps>

80106373 <vector44>:
.globl vector44
vector44:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $44
80106375:	6a 2c                	push   $0x2c
  jmp alltraps
80106377:	e9 82 f9 ff ff       	jmp    80105cfe <alltraps>

8010637c <vector45>:
.globl vector45
vector45:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $45
8010637e:	6a 2d                	push   $0x2d
  jmp alltraps
80106380:	e9 79 f9 ff ff       	jmp    80105cfe <alltraps>

80106385 <vector46>:
.globl vector46
vector46:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $46
80106387:	6a 2e                	push   $0x2e
  jmp alltraps
80106389:	e9 70 f9 ff ff       	jmp    80105cfe <alltraps>

8010638e <vector47>:
.globl vector47
vector47:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $47
80106390:	6a 2f                	push   $0x2f
  jmp alltraps
80106392:	e9 67 f9 ff ff       	jmp    80105cfe <alltraps>

80106397 <vector48>:
.globl vector48
vector48:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $48
80106399:	6a 30                	push   $0x30
  jmp alltraps
8010639b:	e9 5e f9 ff ff       	jmp    80105cfe <alltraps>

801063a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $49
801063a2:	6a 31                	push   $0x31
  jmp alltraps
801063a4:	e9 55 f9 ff ff       	jmp    80105cfe <alltraps>

801063a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $50
801063ab:	6a 32                	push   $0x32
  jmp alltraps
801063ad:	e9 4c f9 ff ff       	jmp    80105cfe <alltraps>

801063b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $51
801063b4:	6a 33                	push   $0x33
  jmp alltraps
801063b6:	e9 43 f9 ff ff       	jmp    80105cfe <alltraps>

801063bb <vector52>:
.globl vector52
vector52:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $52
801063bd:	6a 34                	push   $0x34
  jmp alltraps
801063bf:	e9 3a f9 ff ff       	jmp    80105cfe <alltraps>

801063c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $53
801063c6:	6a 35                	push   $0x35
  jmp alltraps
801063c8:	e9 31 f9 ff ff       	jmp    80105cfe <alltraps>

801063cd <vector54>:
.globl vector54
vector54:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $54
801063cf:	6a 36                	push   $0x36
  jmp alltraps
801063d1:	e9 28 f9 ff ff       	jmp    80105cfe <alltraps>

801063d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $55
801063d8:	6a 37                	push   $0x37
  jmp alltraps
801063da:	e9 1f f9 ff ff       	jmp    80105cfe <alltraps>

801063df <vector56>:
.globl vector56
vector56:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $56
801063e1:	6a 38                	push   $0x38
  jmp alltraps
801063e3:	e9 16 f9 ff ff       	jmp    80105cfe <alltraps>

801063e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $57
801063ea:	6a 39                	push   $0x39
  jmp alltraps
801063ec:	e9 0d f9 ff ff       	jmp    80105cfe <alltraps>

801063f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $58
801063f3:	6a 3a                	push   $0x3a
  jmp alltraps
801063f5:	e9 04 f9 ff ff       	jmp    80105cfe <alltraps>

801063fa <vector59>:
.globl vector59
vector59:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $59
801063fc:	6a 3b                	push   $0x3b
  jmp alltraps
801063fe:	e9 fb f8 ff ff       	jmp    80105cfe <alltraps>

80106403 <vector60>:
.globl vector60
vector60:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $60
80106405:	6a 3c                	push   $0x3c
  jmp alltraps
80106407:	e9 f2 f8 ff ff       	jmp    80105cfe <alltraps>

8010640c <vector61>:
.globl vector61
vector61:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $61
8010640e:	6a 3d                	push   $0x3d
  jmp alltraps
80106410:	e9 e9 f8 ff ff       	jmp    80105cfe <alltraps>

80106415 <vector62>:
.globl vector62
vector62:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $62
80106417:	6a 3e                	push   $0x3e
  jmp alltraps
80106419:	e9 e0 f8 ff ff       	jmp    80105cfe <alltraps>

8010641e <vector63>:
.globl vector63
vector63:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $63
80106420:	6a 3f                	push   $0x3f
  jmp alltraps
80106422:	e9 d7 f8 ff ff       	jmp    80105cfe <alltraps>

80106427 <vector64>:
.globl vector64
vector64:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $64
80106429:	6a 40                	push   $0x40
  jmp alltraps
8010642b:	e9 ce f8 ff ff       	jmp    80105cfe <alltraps>

80106430 <vector65>:
.globl vector65
vector65:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $65
80106432:	6a 41                	push   $0x41
  jmp alltraps
80106434:	e9 c5 f8 ff ff       	jmp    80105cfe <alltraps>

80106439 <vector66>:
.globl vector66
vector66:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $66
8010643b:	6a 42                	push   $0x42
  jmp alltraps
8010643d:	e9 bc f8 ff ff       	jmp    80105cfe <alltraps>

80106442 <vector67>:
.globl vector67
vector67:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $67
80106444:	6a 43                	push   $0x43
  jmp alltraps
80106446:	e9 b3 f8 ff ff       	jmp    80105cfe <alltraps>

8010644b <vector68>:
.globl vector68
vector68:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $68
8010644d:	6a 44                	push   $0x44
  jmp alltraps
8010644f:	e9 aa f8 ff ff       	jmp    80105cfe <alltraps>

80106454 <vector69>:
.globl vector69
vector69:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $69
80106456:	6a 45                	push   $0x45
  jmp alltraps
80106458:	e9 a1 f8 ff ff       	jmp    80105cfe <alltraps>

8010645d <vector70>:
.globl vector70
vector70:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $70
8010645f:	6a 46                	push   $0x46
  jmp alltraps
80106461:	e9 98 f8 ff ff       	jmp    80105cfe <alltraps>

80106466 <vector71>:
.globl vector71
vector71:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $71
80106468:	6a 47                	push   $0x47
  jmp alltraps
8010646a:	e9 8f f8 ff ff       	jmp    80105cfe <alltraps>

8010646f <vector72>:
.globl vector72
vector72:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $72
80106471:	6a 48                	push   $0x48
  jmp alltraps
80106473:	e9 86 f8 ff ff       	jmp    80105cfe <alltraps>

80106478 <vector73>:
.globl vector73
vector73:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $73
8010647a:	6a 49                	push   $0x49
  jmp alltraps
8010647c:	e9 7d f8 ff ff       	jmp    80105cfe <alltraps>

80106481 <vector74>:
.globl vector74
vector74:
  pushl $0
80106481:	6a 00                	push   $0x0
  pushl $74
80106483:	6a 4a                	push   $0x4a
  jmp alltraps
80106485:	e9 74 f8 ff ff       	jmp    80105cfe <alltraps>

8010648a <vector75>:
.globl vector75
vector75:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $75
8010648c:	6a 4b                	push   $0x4b
  jmp alltraps
8010648e:	e9 6b f8 ff ff       	jmp    80105cfe <alltraps>

80106493 <vector76>:
.globl vector76
vector76:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $76
80106495:	6a 4c                	push   $0x4c
  jmp alltraps
80106497:	e9 62 f8 ff ff       	jmp    80105cfe <alltraps>

8010649c <vector77>:
.globl vector77
vector77:
  pushl $0
8010649c:	6a 00                	push   $0x0
  pushl $77
8010649e:	6a 4d                	push   $0x4d
  jmp alltraps
801064a0:	e9 59 f8 ff ff       	jmp    80105cfe <alltraps>

801064a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064a5:	6a 00                	push   $0x0
  pushl $78
801064a7:	6a 4e                	push   $0x4e
  jmp alltraps
801064a9:	e9 50 f8 ff ff       	jmp    80105cfe <alltraps>

801064ae <vector79>:
.globl vector79
vector79:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $79
801064b0:	6a 4f                	push   $0x4f
  jmp alltraps
801064b2:	e9 47 f8 ff ff       	jmp    80105cfe <alltraps>

801064b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $80
801064b9:	6a 50                	push   $0x50
  jmp alltraps
801064bb:	e9 3e f8 ff ff       	jmp    80105cfe <alltraps>

801064c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064c0:	6a 00                	push   $0x0
  pushl $81
801064c2:	6a 51                	push   $0x51
  jmp alltraps
801064c4:	e9 35 f8 ff ff       	jmp    80105cfe <alltraps>

801064c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064c9:	6a 00                	push   $0x0
  pushl $82
801064cb:	6a 52                	push   $0x52
  jmp alltraps
801064cd:	e9 2c f8 ff ff       	jmp    80105cfe <alltraps>

801064d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $83
801064d4:	6a 53                	push   $0x53
  jmp alltraps
801064d6:	e9 23 f8 ff ff       	jmp    80105cfe <alltraps>

801064db <vector84>:
.globl vector84
vector84:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $84
801064dd:	6a 54                	push   $0x54
  jmp alltraps
801064df:	e9 1a f8 ff ff       	jmp    80105cfe <alltraps>

801064e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $85
801064e6:	6a 55                	push   $0x55
  jmp alltraps
801064e8:	e9 11 f8 ff ff       	jmp    80105cfe <alltraps>

801064ed <vector86>:
.globl vector86
vector86:
  pushl $0
801064ed:	6a 00                	push   $0x0
  pushl $86
801064ef:	6a 56                	push   $0x56
  jmp alltraps
801064f1:	e9 08 f8 ff ff       	jmp    80105cfe <alltraps>

801064f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $87
801064f8:	6a 57                	push   $0x57
  jmp alltraps
801064fa:	e9 ff f7 ff ff       	jmp    80105cfe <alltraps>

801064ff <vector88>:
.globl vector88
vector88:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $88
80106501:	6a 58                	push   $0x58
  jmp alltraps
80106503:	e9 f6 f7 ff ff       	jmp    80105cfe <alltraps>

80106508 <vector89>:
.globl vector89
vector89:
  pushl $0
80106508:	6a 00                	push   $0x0
  pushl $89
8010650a:	6a 59                	push   $0x59
  jmp alltraps
8010650c:	e9 ed f7 ff ff       	jmp    80105cfe <alltraps>

80106511 <vector90>:
.globl vector90
vector90:
  pushl $0
80106511:	6a 00                	push   $0x0
  pushl $90
80106513:	6a 5a                	push   $0x5a
  jmp alltraps
80106515:	e9 e4 f7 ff ff       	jmp    80105cfe <alltraps>

8010651a <vector91>:
.globl vector91
vector91:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $91
8010651c:	6a 5b                	push   $0x5b
  jmp alltraps
8010651e:	e9 db f7 ff ff       	jmp    80105cfe <alltraps>

80106523 <vector92>:
.globl vector92
vector92:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $92
80106525:	6a 5c                	push   $0x5c
  jmp alltraps
80106527:	e9 d2 f7 ff ff       	jmp    80105cfe <alltraps>

8010652c <vector93>:
.globl vector93
vector93:
  pushl $0
8010652c:	6a 00                	push   $0x0
  pushl $93
8010652e:	6a 5d                	push   $0x5d
  jmp alltraps
80106530:	e9 c9 f7 ff ff       	jmp    80105cfe <alltraps>

80106535 <vector94>:
.globl vector94
vector94:
  pushl $0
80106535:	6a 00                	push   $0x0
  pushl $94
80106537:	6a 5e                	push   $0x5e
  jmp alltraps
80106539:	e9 c0 f7 ff ff       	jmp    80105cfe <alltraps>

8010653e <vector95>:
.globl vector95
vector95:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $95
80106540:	6a 5f                	push   $0x5f
  jmp alltraps
80106542:	e9 b7 f7 ff ff       	jmp    80105cfe <alltraps>

80106547 <vector96>:
.globl vector96
vector96:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $96
80106549:	6a 60                	push   $0x60
  jmp alltraps
8010654b:	e9 ae f7 ff ff       	jmp    80105cfe <alltraps>

80106550 <vector97>:
.globl vector97
vector97:
  pushl $0
80106550:	6a 00                	push   $0x0
  pushl $97
80106552:	6a 61                	push   $0x61
  jmp alltraps
80106554:	e9 a5 f7 ff ff       	jmp    80105cfe <alltraps>

80106559 <vector98>:
.globl vector98
vector98:
  pushl $0
80106559:	6a 00                	push   $0x0
  pushl $98
8010655b:	6a 62                	push   $0x62
  jmp alltraps
8010655d:	e9 9c f7 ff ff       	jmp    80105cfe <alltraps>

80106562 <vector99>:
.globl vector99
vector99:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $99
80106564:	6a 63                	push   $0x63
  jmp alltraps
80106566:	e9 93 f7 ff ff       	jmp    80105cfe <alltraps>

8010656b <vector100>:
.globl vector100
vector100:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $100
8010656d:	6a 64                	push   $0x64
  jmp alltraps
8010656f:	e9 8a f7 ff ff       	jmp    80105cfe <alltraps>

80106574 <vector101>:
.globl vector101
vector101:
  pushl $0
80106574:	6a 00                	push   $0x0
  pushl $101
80106576:	6a 65                	push   $0x65
  jmp alltraps
80106578:	e9 81 f7 ff ff       	jmp    80105cfe <alltraps>

8010657d <vector102>:
.globl vector102
vector102:
  pushl $0
8010657d:	6a 00                	push   $0x0
  pushl $102
8010657f:	6a 66                	push   $0x66
  jmp alltraps
80106581:	e9 78 f7 ff ff       	jmp    80105cfe <alltraps>

80106586 <vector103>:
.globl vector103
vector103:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $103
80106588:	6a 67                	push   $0x67
  jmp alltraps
8010658a:	e9 6f f7 ff ff       	jmp    80105cfe <alltraps>

8010658f <vector104>:
.globl vector104
vector104:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $104
80106591:	6a 68                	push   $0x68
  jmp alltraps
80106593:	e9 66 f7 ff ff       	jmp    80105cfe <alltraps>

80106598 <vector105>:
.globl vector105
vector105:
  pushl $0
80106598:	6a 00                	push   $0x0
  pushl $105
8010659a:	6a 69                	push   $0x69
  jmp alltraps
8010659c:	e9 5d f7 ff ff       	jmp    80105cfe <alltraps>

801065a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065a1:	6a 00                	push   $0x0
  pushl $106
801065a3:	6a 6a                	push   $0x6a
  jmp alltraps
801065a5:	e9 54 f7 ff ff       	jmp    80105cfe <alltraps>

801065aa <vector107>:
.globl vector107
vector107:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $107
801065ac:	6a 6b                	push   $0x6b
  jmp alltraps
801065ae:	e9 4b f7 ff ff       	jmp    80105cfe <alltraps>

801065b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $108
801065b5:	6a 6c                	push   $0x6c
  jmp alltraps
801065b7:	e9 42 f7 ff ff       	jmp    80105cfe <alltraps>

801065bc <vector109>:
.globl vector109
vector109:
  pushl $0
801065bc:	6a 00                	push   $0x0
  pushl $109
801065be:	6a 6d                	push   $0x6d
  jmp alltraps
801065c0:	e9 39 f7 ff ff       	jmp    80105cfe <alltraps>

801065c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065c5:	6a 00                	push   $0x0
  pushl $110
801065c7:	6a 6e                	push   $0x6e
  jmp alltraps
801065c9:	e9 30 f7 ff ff       	jmp    80105cfe <alltraps>

801065ce <vector111>:
.globl vector111
vector111:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $111
801065d0:	6a 6f                	push   $0x6f
  jmp alltraps
801065d2:	e9 27 f7 ff ff       	jmp    80105cfe <alltraps>

801065d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $112
801065d9:	6a 70                	push   $0x70
  jmp alltraps
801065db:	e9 1e f7 ff ff       	jmp    80105cfe <alltraps>

801065e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $113
801065e2:	6a 71                	push   $0x71
  jmp alltraps
801065e4:	e9 15 f7 ff ff       	jmp    80105cfe <alltraps>

801065e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $114
801065eb:	6a 72                	push   $0x72
  jmp alltraps
801065ed:	e9 0c f7 ff ff       	jmp    80105cfe <alltraps>

801065f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $115
801065f4:	6a 73                	push   $0x73
  jmp alltraps
801065f6:	e9 03 f7 ff ff       	jmp    80105cfe <alltraps>

801065fb <vector116>:
.globl vector116
vector116:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $116
801065fd:	6a 74                	push   $0x74
  jmp alltraps
801065ff:	e9 fa f6 ff ff       	jmp    80105cfe <alltraps>

80106604 <vector117>:
.globl vector117
vector117:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $117
80106606:	6a 75                	push   $0x75
  jmp alltraps
80106608:	e9 f1 f6 ff ff       	jmp    80105cfe <alltraps>

8010660d <vector118>:
.globl vector118
vector118:
  pushl $0
8010660d:	6a 00                	push   $0x0
  pushl $118
8010660f:	6a 76                	push   $0x76
  jmp alltraps
80106611:	e9 e8 f6 ff ff       	jmp    80105cfe <alltraps>

80106616 <vector119>:
.globl vector119
vector119:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $119
80106618:	6a 77                	push   $0x77
  jmp alltraps
8010661a:	e9 df f6 ff ff       	jmp    80105cfe <alltraps>

8010661f <vector120>:
.globl vector120
vector120:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $120
80106621:	6a 78                	push   $0x78
  jmp alltraps
80106623:	e9 d6 f6 ff ff       	jmp    80105cfe <alltraps>

80106628 <vector121>:
.globl vector121
vector121:
  pushl $0
80106628:	6a 00                	push   $0x0
  pushl $121
8010662a:	6a 79                	push   $0x79
  jmp alltraps
8010662c:	e9 cd f6 ff ff       	jmp    80105cfe <alltraps>

80106631 <vector122>:
.globl vector122
vector122:
  pushl $0
80106631:	6a 00                	push   $0x0
  pushl $122
80106633:	6a 7a                	push   $0x7a
  jmp alltraps
80106635:	e9 c4 f6 ff ff       	jmp    80105cfe <alltraps>

8010663a <vector123>:
.globl vector123
vector123:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $123
8010663c:	6a 7b                	push   $0x7b
  jmp alltraps
8010663e:	e9 bb f6 ff ff       	jmp    80105cfe <alltraps>

80106643 <vector124>:
.globl vector124
vector124:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $124
80106645:	6a 7c                	push   $0x7c
  jmp alltraps
80106647:	e9 b2 f6 ff ff       	jmp    80105cfe <alltraps>

8010664c <vector125>:
.globl vector125
vector125:
  pushl $0
8010664c:	6a 00                	push   $0x0
  pushl $125
8010664e:	6a 7d                	push   $0x7d
  jmp alltraps
80106650:	e9 a9 f6 ff ff       	jmp    80105cfe <alltraps>

80106655 <vector126>:
.globl vector126
vector126:
  pushl $0
80106655:	6a 00                	push   $0x0
  pushl $126
80106657:	6a 7e                	push   $0x7e
  jmp alltraps
80106659:	e9 a0 f6 ff ff       	jmp    80105cfe <alltraps>

8010665e <vector127>:
.globl vector127
vector127:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $127
80106660:	6a 7f                	push   $0x7f
  jmp alltraps
80106662:	e9 97 f6 ff ff       	jmp    80105cfe <alltraps>

80106667 <vector128>:
.globl vector128
vector128:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $128
80106669:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010666e:	e9 8b f6 ff ff       	jmp    80105cfe <alltraps>

80106673 <vector129>:
.globl vector129
vector129:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $129
80106675:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010667a:	e9 7f f6 ff ff       	jmp    80105cfe <alltraps>

8010667f <vector130>:
.globl vector130
vector130:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $130
80106681:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106686:	e9 73 f6 ff ff       	jmp    80105cfe <alltraps>

8010668b <vector131>:
.globl vector131
vector131:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $131
8010668d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106692:	e9 67 f6 ff ff       	jmp    80105cfe <alltraps>

80106697 <vector132>:
.globl vector132
vector132:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $132
80106699:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010669e:	e9 5b f6 ff ff       	jmp    80105cfe <alltraps>

801066a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $133
801066a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066aa:	e9 4f f6 ff ff       	jmp    80105cfe <alltraps>

801066af <vector134>:
.globl vector134
vector134:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $134
801066b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066b6:	e9 43 f6 ff ff       	jmp    80105cfe <alltraps>

801066bb <vector135>:
.globl vector135
vector135:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $135
801066bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066c2:	e9 37 f6 ff ff       	jmp    80105cfe <alltraps>

801066c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $136
801066c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066ce:	e9 2b f6 ff ff       	jmp    80105cfe <alltraps>

801066d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $137
801066d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066da:	e9 1f f6 ff ff       	jmp    80105cfe <alltraps>

801066df <vector138>:
.globl vector138
vector138:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $138
801066e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066e6:	e9 13 f6 ff ff       	jmp    80105cfe <alltraps>

801066eb <vector139>:
.globl vector139
vector139:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $139
801066ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801066f2:	e9 07 f6 ff ff       	jmp    80105cfe <alltraps>

801066f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $140
801066f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801066fe:	e9 fb f5 ff ff       	jmp    80105cfe <alltraps>

80106703 <vector141>:
.globl vector141
vector141:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $141
80106705:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010670a:	e9 ef f5 ff ff       	jmp    80105cfe <alltraps>

8010670f <vector142>:
.globl vector142
vector142:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $142
80106711:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106716:	e9 e3 f5 ff ff       	jmp    80105cfe <alltraps>

8010671b <vector143>:
.globl vector143
vector143:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $143
8010671d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106722:	e9 d7 f5 ff ff       	jmp    80105cfe <alltraps>

80106727 <vector144>:
.globl vector144
vector144:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $144
80106729:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010672e:	e9 cb f5 ff ff       	jmp    80105cfe <alltraps>

80106733 <vector145>:
.globl vector145
vector145:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $145
80106735:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010673a:	e9 bf f5 ff ff       	jmp    80105cfe <alltraps>

8010673f <vector146>:
.globl vector146
vector146:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $146
80106741:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106746:	e9 b3 f5 ff ff       	jmp    80105cfe <alltraps>

8010674b <vector147>:
.globl vector147
vector147:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $147
8010674d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106752:	e9 a7 f5 ff ff       	jmp    80105cfe <alltraps>

80106757 <vector148>:
.globl vector148
vector148:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $148
80106759:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010675e:	e9 9b f5 ff ff       	jmp    80105cfe <alltraps>

80106763 <vector149>:
.globl vector149
vector149:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $149
80106765:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010676a:	e9 8f f5 ff ff       	jmp    80105cfe <alltraps>

8010676f <vector150>:
.globl vector150
vector150:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $150
80106771:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106776:	e9 83 f5 ff ff       	jmp    80105cfe <alltraps>

8010677b <vector151>:
.globl vector151
vector151:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $151
8010677d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106782:	e9 77 f5 ff ff       	jmp    80105cfe <alltraps>

80106787 <vector152>:
.globl vector152
vector152:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $152
80106789:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010678e:	e9 6b f5 ff ff       	jmp    80105cfe <alltraps>

80106793 <vector153>:
.globl vector153
vector153:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $153
80106795:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010679a:	e9 5f f5 ff ff       	jmp    80105cfe <alltraps>

8010679f <vector154>:
.globl vector154
vector154:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $154
801067a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067a6:	e9 53 f5 ff ff       	jmp    80105cfe <alltraps>

801067ab <vector155>:
.globl vector155
vector155:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $155
801067ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067b2:	e9 47 f5 ff ff       	jmp    80105cfe <alltraps>

801067b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $156
801067b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067be:	e9 3b f5 ff ff       	jmp    80105cfe <alltraps>

801067c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $157
801067c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067ca:	e9 2f f5 ff ff       	jmp    80105cfe <alltraps>

801067cf <vector158>:
.globl vector158
vector158:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $158
801067d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067d6:	e9 23 f5 ff ff       	jmp    80105cfe <alltraps>

801067db <vector159>:
.globl vector159
vector159:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $159
801067dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067e2:	e9 17 f5 ff ff       	jmp    80105cfe <alltraps>

801067e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $160
801067e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067ee:	e9 0b f5 ff ff       	jmp    80105cfe <alltraps>

801067f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $161
801067f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801067fa:	e9 ff f4 ff ff       	jmp    80105cfe <alltraps>

801067ff <vector162>:
.globl vector162
vector162:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $162
80106801:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106806:	e9 f3 f4 ff ff       	jmp    80105cfe <alltraps>

8010680b <vector163>:
.globl vector163
vector163:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $163
8010680d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106812:	e9 e7 f4 ff ff       	jmp    80105cfe <alltraps>

80106817 <vector164>:
.globl vector164
vector164:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $164
80106819:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010681e:	e9 db f4 ff ff       	jmp    80105cfe <alltraps>

80106823 <vector165>:
.globl vector165
vector165:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $165
80106825:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010682a:	e9 cf f4 ff ff       	jmp    80105cfe <alltraps>

8010682f <vector166>:
.globl vector166
vector166:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $166
80106831:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106836:	e9 c3 f4 ff ff       	jmp    80105cfe <alltraps>

8010683b <vector167>:
.globl vector167
vector167:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $167
8010683d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106842:	e9 b7 f4 ff ff       	jmp    80105cfe <alltraps>

80106847 <vector168>:
.globl vector168
vector168:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $168
80106849:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010684e:	e9 ab f4 ff ff       	jmp    80105cfe <alltraps>

80106853 <vector169>:
.globl vector169
vector169:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $169
80106855:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010685a:	e9 9f f4 ff ff       	jmp    80105cfe <alltraps>

8010685f <vector170>:
.globl vector170
vector170:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $170
80106861:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106866:	e9 93 f4 ff ff       	jmp    80105cfe <alltraps>

8010686b <vector171>:
.globl vector171
vector171:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $171
8010686d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106872:	e9 87 f4 ff ff       	jmp    80105cfe <alltraps>

80106877 <vector172>:
.globl vector172
vector172:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $172
80106879:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010687e:	e9 7b f4 ff ff       	jmp    80105cfe <alltraps>

80106883 <vector173>:
.globl vector173
vector173:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $173
80106885:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010688a:	e9 6f f4 ff ff       	jmp    80105cfe <alltraps>

8010688f <vector174>:
.globl vector174
vector174:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $174
80106891:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106896:	e9 63 f4 ff ff       	jmp    80105cfe <alltraps>

8010689b <vector175>:
.globl vector175
vector175:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $175
8010689d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068a2:	e9 57 f4 ff ff       	jmp    80105cfe <alltraps>

801068a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $176
801068a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068ae:	e9 4b f4 ff ff       	jmp    80105cfe <alltraps>

801068b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $177
801068b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068ba:	e9 3f f4 ff ff       	jmp    80105cfe <alltraps>

801068bf <vector178>:
.globl vector178
vector178:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $178
801068c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068c6:	e9 33 f4 ff ff       	jmp    80105cfe <alltraps>

801068cb <vector179>:
.globl vector179
vector179:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $179
801068cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068d2:	e9 27 f4 ff ff       	jmp    80105cfe <alltraps>

801068d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $180
801068d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068de:	e9 1b f4 ff ff       	jmp    80105cfe <alltraps>

801068e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $181
801068e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068ea:	e9 0f f4 ff ff       	jmp    80105cfe <alltraps>

801068ef <vector182>:
.globl vector182
vector182:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $182
801068f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801068f6:	e9 03 f4 ff ff       	jmp    80105cfe <alltraps>

801068fb <vector183>:
.globl vector183
vector183:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $183
801068fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106902:	e9 f7 f3 ff ff       	jmp    80105cfe <alltraps>

80106907 <vector184>:
.globl vector184
vector184:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $184
80106909:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010690e:	e9 eb f3 ff ff       	jmp    80105cfe <alltraps>

80106913 <vector185>:
.globl vector185
vector185:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $185
80106915:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010691a:	e9 df f3 ff ff       	jmp    80105cfe <alltraps>

8010691f <vector186>:
.globl vector186
vector186:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $186
80106921:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106926:	e9 d3 f3 ff ff       	jmp    80105cfe <alltraps>

8010692b <vector187>:
.globl vector187
vector187:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $187
8010692d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106932:	e9 c7 f3 ff ff       	jmp    80105cfe <alltraps>

80106937 <vector188>:
.globl vector188
vector188:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $188
80106939:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010693e:	e9 bb f3 ff ff       	jmp    80105cfe <alltraps>

80106943 <vector189>:
.globl vector189
vector189:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $189
80106945:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010694a:	e9 af f3 ff ff       	jmp    80105cfe <alltraps>

8010694f <vector190>:
.globl vector190
vector190:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $190
80106951:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106956:	e9 a3 f3 ff ff       	jmp    80105cfe <alltraps>

8010695b <vector191>:
.globl vector191
vector191:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $191
8010695d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106962:	e9 97 f3 ff ff       	jmp    80105cfe <alltraps>

80106967 <vector192>:
.globl vector192
vector192:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $192
80106969:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010696e:	e9 8b f3 ff ff       	jmp    80105cfe <alltraps>

80106973 <vector193>:
.globl vector193
vector193:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $193
80106975:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010697a:	e9 7f f3 ff ff       	jmp    80105cfe <alltraps>

8010697f <vector194>:
.globl vector194
vector194:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $194
80106981:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106986:	e9 73 f3 ff ff       	jmp    80105cfe <alltraps>

8010698b <vector195>:
.globl vector195
vector195:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $195
8010698d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106992:	e9 67 f3 ff ff       	jmp    80105cfe <alltraps>

80106997 <vector196>:
.globl vector196
vector196:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $196
80106999:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010699e:	e9 5b f3 ff ff       	jmp    80105cfe <alltraps>

801069a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $197
801069a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069aa:	e9 4f f3 ff ff       	jmp    80105cfe <alltraps>

801069af <vector198>:
.globl vector198
vector198:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $198
801069b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069b6:	e9 43 f3 ff ff       	jmp    80105cfe <alltraps>

801069bb <vector199>:
.globl vector199
vector199:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $199
801069bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069c2:	e9 37 f3 ff ff       	jmp    80105cfe <alltraps>

801069c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $200
801069c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069ce:	e9 2b f3 ff ff       	jmp    80105cfe <alltraps>

801069d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $201
801069d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069da:	e9 1f f3 ff ff       	jmp    80105cfe <alltraps>

801069df <vector202>:
.globl vector202
vector202:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $202
801069e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069e6:	e9 13 f3 ff ff       	jmp    80105cfe <alltraps>

801069eb <vector203>:
.globl vector203
vector203:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $203
801069ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801069f2:	e9 07 f3 ff ff       	jmp    80105cfe <alltraps>

801069f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $204
801069f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801069fe:	e9 fb f2 ff ff       	jmp    80105cfe <alltraps>

80106a03 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $205
80106a05:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a0a:	e9 ef f2 ff ff       	jmp    80105cfe <alltraps>

80106a0f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $206
80106a11:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a16:	e9 e3 f2 ff ff       	jmp    80105cfe <alltraps>

80106a1b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $207
80106a1d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a22:	e9 d7 f2 ff ff       	jmp    80105cfe <alltraps>

80106a27 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $208
80106a29:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a2e:	e9 cb f2 ff ff       	jmp    80105cfe <alltraps>

80106a33 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $209
80106a35:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a3a:	e9 bf f2 ff ff       	jmp    80105cfe <alltraps>

80106a3f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $210
80106a41:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a46:	e9 b3 f2 ff ff       	jmp    80105cfe <alltraps>

80106a4b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $211
80106a4d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a52:	e9 a7 f2 ff ff       	jmp    80105cfe <alltraps>

80106a57 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $212
80106a59:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a5e:	e9 9b f2 ff ff       	jmp    80105cfe <alltraps>

80106a63 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $213
80106a65:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a6a:	e9 8f f2 ff ff       	jmp    80105cfe <alltraps>

80106a6f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $214
80106a71:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a76:	e9 83 f2 ff ff       	jmp    80105cfe <alltraps>

80106a7b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $215
80106a7d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a82:	e9 77 f2 ff ff       	jmp    80105cfe <alltraps>

80106a87 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $216
80106a89:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a8e:	e9 6b f2 ff ff       	jmp    80105cfe <alltraps>

80106a93 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $217
80106a95:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a9a:	e9 5f f2 ff ff       	jmp    80105cfe <alltraps>

80106a9f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $218
80106aa1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106aa6:	e9 53 f2 ff ff       	jmp    80105cfe <alltraps>

80106aab <vector219>:
.globl vector219
vector219:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $219
80106aad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ab2:	e9 47 f2 ff ff       	jmp    80105cfe <alltraps>

80106ab7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $220
80106ab9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106abe:	e9 3b f2 ff ff       	jmp    80105cfe <alltraps>

80106ac3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $221
80106ac5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106aca:	e9 2f f2 ff ff       	jmp    80105cfe <alltraps>

80106acf <vector222>:
.globl vector222
vector222:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $222
80106ad1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ad6:	e9 23 f2 ff ff       	jmp    80105cfe <alltraps>

80106adb <vector223>:
.globl vector223
vector223:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $223
80106add:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ae2:	e9 17 f2 ff ff       	jmp    80105cfe <alltraps>

80106ae7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $224
80106ae9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106aee:	e9 0b f2 ff ff       	jmp    80105cfe <alltraps>

80106af3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $225
80106af5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106afa:	e9 ff f1 ff ff       	jmp    80105cfe <alltraps>

80106aff <vector226>:
.globl vector226
vector226:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $226
80106b01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b06:	e9 f3 f1 ff ff       	jmp    80105cfe <alltraps>

80106b0b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $227
80106b0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b12:	e9 e7 f1 ff ff       	jmp    80105cfe <alltraps>

80106b17 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $228
80106b19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b1e:	e9 db f1 ff ff       	jmp    80105cfe <alltraps>

80106b23 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $229
80106b25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b2a:	e9 cf f1 ff ff       	jmp    80105cfe <alltraps>

80106b2f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $230
80106b31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b36:	e9 c3 f1 ff ff       	jmp    80105cfe <alltraps>

80106b3b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $231
80106b3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b42:	e9 b7 f1 ff ff       	jmp    80105cfe <alltraps>

80106b47 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $232
80106b49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b4e:	e9 ab f1 ff ff       	jmp    80105cfe <alltraps>

80106b53 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $233
80106b55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b5a:	e9 9f f1 ff ff       	jmp    80105cfe <alltraps>

80106b5f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $234
80106b61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b66:	e9 93 f1 ff ff       	jmp    80105cfe <alltraps>

80106b6b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $235
80106b6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b72:	e9 87 f1 ff ff       	jmp    80105cfe <alltraps>

80106b77 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $236
80106b79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b7e:	e9 7b f1 ff ff       	jmp    80105cfe <alltraps>

80106b83 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $237
80106b85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b8a:	e9 6f f1 ff ff       	jmp    80105cfe <alltraps>

80106b8f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $238
80106b91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b96:	e9 63 f1 ff ff       	jmp    80105cfe <alltraps>

80106b9b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $239
80106b9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ba2:	e9 57 f1 ff ff       	jmp    80105cfe <alltraps>

80106ba7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $240
80106ba9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bae:	e9 4b f1 ff ff       	jmp    80105cfe <alltraps>

80106bb3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $241
80106bb5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106bba:	e9 3f f1 ff ff       	jmp    80105cfe <alltraps>

80106bbf <vector242>:
.globl vector242
vector242:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $242
80106bc1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106bc6:	e9 33 f1 ff ff       	jmp    80105cfe <alltraps>

80106bcb <vector243>:
.globl vector243
vector243:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $243
80106bcd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106bd2:	e9 27 f1 ff ff       	jmp    80105cfe <alltraps>

80106bd7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $244
80106bd9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bde:	e9 1b f1 ff ff       	jmp    80105cfe <alltraps>

80106be3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $245
80106be5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106bea:	e9 0f f1 ff ff       	jmp    80105cfe <alltraps>

80106bef <vector246>:
.globl vector246
vector246:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $246
80106bf1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106bf6:	e9 03 f1 ff ff       	jmp    80105cfe <alltraps>

80106bfb <vector247>:
.globl vector247
vector247:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $247
80106bfd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c02:	e9 f7 f0 ff ff       	jmp    80105cfe <alltraps>

80106c07 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $248
80106c09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c0e:	e9 eb f0 ff ff       	jmp    80105cfe <alltraps>

80106c13 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $249
80106c15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c1a:	e9 df f0 ff ff       	jmp    80105cfe <alltraps>

80106c1f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $250
80106c21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c26:	e9 d3 f0 ff ff       	jmp    80105cfe <alltraps>

80106c2b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $251
80106c2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c32:	e9 c7 f0 ff ff       	jmp    80105cfe <alltraps>

80106c37 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $252
80106c39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c3e:	e9 bb f0 ff ff       	jmp    80105cfe <alltraps>

80106c43 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $253
80106c45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c4a:	e9 af f0 ff ff       	jmp    80105cfe <alltraps>

80106c4f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $254
80106c51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c56:	e9 a3 f0 ff ff       	jmp    80105cfe <alltraps>

80106c5b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $255
80106c5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c62:	e9 97 f0 ff ff       	jmp    80105cfe <alltraps>
80106c67:	66 90                	xchg   %ax,%ax
80106c69:	66 90                	xchg   %ax,%ax
80106c6b:	66 90                	xchg   %ax,%ax
80106c6d:	66 90                	xchg   %ax,%ax
80106c6f:	90                   	nop

80106c70 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	57                   	push   %edi
80106c74:	56                   	push   %esi
80106c75:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106c76:	89 d3                	mov    %edx,%ebx
{
80106c78:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106c7a:	c1 eb 16             	shr    $0x16,%ebx
80106c7d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106c80:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106c83:	8b 06                	mov    (%esi),%eax
80106c85:	a8 01                	test   $0x1,%al
80106c87:	74 27                	je     80106cb0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c8e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106c94:	c1 ef 0a             	shr    $0xa,%edi
}
80106c97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106c9a:	89 fa                	mov    %edi,%edx
80106c9c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ca2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106ca5:	5b                   	pop    %ebx
80106ca6:	5e                   	pop    %esi
80106ca7:	5f                   	pop    %edi
80106ca8:	5d                   	pop    %ebp
80106ca9:	c3                   	ret    
80106caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106cb0:	85 c9                	test   %ecx,%ecx
80106cb2:	74 2c                	je     80106ce0 <walkpgdir+0x70>
80106cb4:	e8 47 b8 ff ff       	call   80102500 <kalloc>
80106cb9:	85 c0                	test   %eax,%eax
80106cbb:	89 c3                	mov    %eax,%ebx
80106cbd:	74 21                	je     80106ce0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106cbf:	83 ec 04             	sub    $0x4,%esp
80106cc2:	68 00 10 00 00       	push   $0x1000
80106cc7:	6a 00                	push   $0x0
80106cc9:	50                   	push   %eax
80106cca:	e8 11 dd ff ff       	call   801049e0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ccf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cd5:	83 c4 10             	add    $0x10,%esp
80106cd8:	83 c8 07             	or     $0x7,%eax
80106cdb:	89 06                	mov    %eax,(%esi)
80106cdd:	eb b5                	jmp    80106c94 <walkpgdir+0x24>
80106cdf:	90                   	nop
}
80106ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ce3:	31 c0                	xor    %eax,%eax
}
80106ce5:	5b                   	pop    %ebx
80106ce6:	5e                   	pop    %esi
80106ce7:	5f                   	pop    %edi
80106ce8:	5d                   	pop    %ebp
80106ce9:	c3                   	ret    
80106cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cf0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
80106cf5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106cf6:	89 d3                	mov    %edx,%ebx
80106cf8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106cfe:	83 ec 1c             	sub    $0x1c,%esp
80106d01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d08:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    // if(*pte & PTE_P)
    //   panic("remap");
    *pte = pa | perm | PTE_P;
80106d13:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d16:	29 df                	sub    %ebx,%edi
80106d18:	83 c8 01             	or     $0x1,%eax
80106d1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d1e:	eb 10                	jmp    80106d30 <mappages+0x40>
80106d20:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106d23:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106d26:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d28:	74 2e                	je     80106d58 <mappages+0x68>
      break;
    a += PGSIZE;
80106d2a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d33:	b9 01 00 00 00       	mov    $0x1,%ecx
80106d38:	89 da                	mov    %ebx,%edx
80106d3a:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106d3d:	e8 2e ff ff ff       	call   80106c70 <walkpgdir>
80106d42:	85 c0                	test   %eax,%eax
80106d44:	75 da                	jne    80106d20 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106d46:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106d49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d4e:	5b                   	pop    %ebx
80106d4f:	5e                   	pop    %esi
80106d50:	5f                   	pop    %edi
80106d51:	5d                   	pop    %ebp
80106d52:	c3                   	ret    
80106d53:	90                   	nop
80106d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d58:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106d5b:	31 c0                	xor    %eax,%eax
}
80106d5d:	5b                   	pop    %ebx
80106d5e:	5e                   	pop    %esi
80106d5f:	5f                   	pop    %edi
80106d60:	5d                   	pop    %ebp
80106d61:	c3                   	ret    
80106d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d76:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d7c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106d7e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d84:	83 ec 1c             	sub    $0x1c,%esp
80106d87:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d8a:	39 d3                	cmp    %edx,%ebx
80106d8c:	73 60                	jae    80106dee <deallocuvm.part.0+0x7e>
80106d8e:	89 d6                	mov    %edx,%esi
80106d90:	eb 3d                	jmp    80106dcf <deallocuvm.part.0+0x5f>
80106d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
80106d98:	8b 10                	mov    (%eax),%edx
80106d9a:	f6 c2 01             	test   $0x1,%dl
80106d9d:	74 26                	je     80106dc5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106d9f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106da5:	74 52                	je     80106df9 <deallocuvm.part.0+0x89>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106da7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106daa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106db0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106db3:	52                   	push   %edx
80106db4:	e8 47 b5 ff ff       	call   80102300 <kfree>
      *pte = 0;
80106db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dbc:	83 c4 10             	add    $0x10,%esp
80106dbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106dc5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dcb:	39 f3                	cmp    %esi,%ebx
80106dcd:	73 1f                	jae    80106dee <deallocuvm.part.0+0x7e>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106dcf:	31 c9                	xor    %ecx,%ecx
80106dd1:	89 da                	mov    %ebx,%edx
80106dd3:	89 f8                	mov    %edi,%eax
80106dd5:	e8 96 fe ff ff       	call   80106c70 <walkpgdir>
    if(!pte)
80106dda:	85 c0                	test   %eax,%eax
80106ddc:	75 ba                	jne    80106d98 <deallocuvm.part.0+0x28>
      a += (NPTENTRIES - 1) * PGSIZE;
80106dde:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106de4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dea:	39 f3                	cmp    %esi,%ebx
80106dec:	72 e1                	jb     80106dcf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106dee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106df4:	5b                   	pop    %ebx
80106df5:	5e                   	pop    %esi
80106df6:	5f                   	pop    %edi
80106df7:	5d                   	pop    %ebp
80106df8:	c3                   	ret    
        panic("kfree");
80106df9:	83 ec 0c             	sub    $0xc,%esp
80106dfc:	68 9a 7b 10 80       	push   $0x80107b9a
80106e01:	e8 6a 95 ff ff       	call   80100370 <panic>
80106e06:	8d 76 00             	lea    0x0(%esi),%esi
80106e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e10 <seginit>:
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	53                   	push   %ebx
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106e14:	31 db                	xor    %ebx,%ebx
{
80106e16:	83 ec 14             	sub    $0x14,%esp
  c = &cpus[cpunum()];
80106e19:	e8 02 ba ff ff       	call   80102820 <cpunum>
80106e1e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106e24:	8d 90 e0 a2 14 80    	lea    -0x7feb5d20(%eax),%edx
80106e2a:	8d 88 94 a3 14 80    	lea    -0x7feb5c6c(%eax),%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e30:	c7 80 58 a3 14 80 ff 	movl   $0xffff,-0x7feb5ca8(%eax)
80106e37:	ff 00 00 
80106e3a:	c7 80 5c a3 14 80 00 	movl   $0xcf9a00,-0x7feb5ca4(%eax)
80106e41:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e44:	c7 80 60 a3 14 80 ff 	movl   $0xffff,-0x7feb5ca0(%eax)
80106e4b:	ff 00 00 
80106e4e:	c7 80 64 a3 14 80 00 	movl   $0xcf9200,-0x7feb5c9c(%eax)
80106e55:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e58:	c7 80 70 a3 14 80 ff 	movl   $0xffff,-0x7feb5c90(%eax)
80106e5f:	ff 00 00 
80106e62:	c7 80 74 a3 14 80 00 	movl   $0xcffa00,-0x7feb5c8c(%eax)
80106e69:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e6c:	c7 80 78 a3 14 80 ff 	movl   $0xffff,-0x7feb5c88(%eax)
80106e73:	ff 00 00 
80106e76:	c7 80 7c a3 14 80 00 	movl   $0xcff200,-0x7feb5c84(%eax)
80106e7d:	f2 cf 00 
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106e80:	66 89 9a 88 00 00 00 	mov    %bx,0x88(%edx)
80106e87:	89 cb                	mov    %ecx,%ebx
80106e89:	c1 eb 10             	shr    $0x10,%ebx
80106e8c:	66 89 8a 8a 00 00 00 	mov    %cx,0x8a(%edx)
80106e93:	c1 e9 18             	shr    $0x18,%ecx
80106e96:	88 9a 8c 00 00 00    	mov    %bl,0x8c(%edx)
80106e9c:	bb 92 c0 ff ff       	mov    $0xffffc092,%ebx
80106ea1:	66 89 98 6d a3 14 80 	mov    %bx,-0x7feb5c93(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106ea8:	05 50 a3 14 80       	add    $0x8014a350,%eax
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106ead:	88 8a 8f 00 00 00    	mov    %cl,0x8f(%edx)
  pd[0] = size-1;
80106eb3:	b9 37 00 00 00       	mov    $0x37,%ecx
80106eb8:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
80106ebc:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ec0:	c1 e8 10             	shr    $0x10,%eax
80106ec3:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106ec7:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106eca:	0f 01 10             	lgdtl  (%eax)
  asm volatile("movw %0, %%gs" : : "r" (v));
80106ecd:	b8 18 00 00 00       	mov    $0x18,%eax
80106ed2:	8e e8                	mov    %eax,%gs
  proc = 0;
80106ed4:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106edb:	00 00 00 00 
  c = &cpus[cpunum()];
80106edf:	65 89 15 00 00 00 00 	mov    %edx,%gs:0x0
}
80106ee6:	83 c4 14             	add    $0x14,%esp
80106ee9:	5b                   	pop    %ebx
80106eea:	5d                   	pop    %ebp
80106eeb:	c3                   	ret    
80106eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ef0 <setupkvm>:
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	56                   	push   %esi
80106ef4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106ef5:	e8 06 b6 ff ff       	call   80102500 <kalloc>
80106efa:	85 c0                	test   %eax,%eax
80106efc:	74 52                	je     80106f50 <setupkvm+0x60>
  memset(pgdir, 0, PGSIZE);
80106efe:	83 ec 04             	sub    $0x4,%esp
80106f01:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f03:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80106f08:	68 00 10 00 00       	push   $0x1000
80106f0d:	6a 00                	push   $0x0
80106f0f:	50                   	push   %eax
80106f10:	e8 cb da ff ff       	call   801049e0 <memset>
80106f15:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0)
80106f18:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f1b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f1e:	83 ec 08             	sub    $0x8,%esp
80106f21:	8b 13                	mov    (%ebx),%edx
80106f23:	ff 73 0c             	pushl  0xc(%ebx)
80106f26:	50                   	push   %eax
80106f27:	29 c1                	sub    %eax,%ecx
80106f29:	89 f0                	mov    %esi,%eax
80106f2b:	e8 c0 fd ff ff       	call   80106cf0 <mappages>
80106f30:	83 c4 10             	add    $0x10,%esp
80106f33:	85 c0                	test   %eax,%eax
80106f35:	78 19                	js     80106f50 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f37:	83 c3 10             	add    $0x10,%ebx
80106f3a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80106f40:	75 d6                	jne    80106f18 <setupkvm+0x28>
}
80106f42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f45:	89 f0                	mov    %esi,%eax
80106f47:	5b                   	pop    %ebx
80106f48:	5e                   	pop    %esi
80106f49:	5d                   	pop    %ebp
80106f4a:	c3                   	ret    
80106f4b:	90                   	nop
80106f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f50:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80106f53:	31 f6                	xor    %esi,%esi
}
80106f55:	89 f0                	mov    %esi,%eax
80106f57:	5b                   	pop    %ebx
80106f58:	5e                   	pop    %esi
80106f59:	5d                   	pop    %ebp
80106f5a:	c3                   	ret    
80106f5b:	90                   	nop
80106f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f60 <kvmalloc>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f66:	e8 85 ff ff ff       	call   80106ef0 <setupkvm>
80106f6b:	a3 80 f2 14 80       	mov    %eax,0x8014f280
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f70:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f75:	0f 22 d8             	mov    %eax,%cr3
}
80106f78:	c9                   	leave  
80106f79:	c3                   	ret    
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f80 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f80:	a1 80 f2 14 80       	mov    0x8014f280,%eax
{
80106f85:	55                   	push   %ebp
80106f86:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f88:	05 00 00 00 80       	add    $0x80000000,%eax
80106f8d:	0f 22 d8             	mov    %eax,%cr3
}
80106f90:	5d                   	pop    %ebp
80106f91:	c3                   	ret    
80106f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fa0 <switchuvm>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	53                   	push   %ebx
80106fa4:	83 ec 04             	sub    $0x4,%esp
80106fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106faa:	e8 d1 d6 ff ff       	call   80104680 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106faf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106fb5:	b9 67 00 00 00       	mov    $0x67,%ecx
80106fba:	8d 50 08             	lea    0x8(%eax),%edx
80106fbd:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106fc4:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106fcb:	89 d1                	mov    %edx,%ecx
80106fcd:	c1 ea 18             	shr    $0x18,%edx
80106fd0:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80106fd6:	ba 89 40 00 00       	mov    $0x4089,%edx
80106fdb:	c1 e9 10             	shr    $0x10,%ecx
80106fde:	66 89 90 a5 00 00 00 	mov    %dx,0xa5(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106fe5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106fec:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80106ff2:	b9 10 00 00 00       	mov    $0x10,%ecx
80106ff7:	66 89 48 10          	mov    %cx,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106ffb:	8b 52 08             	mov    0x8(%edx),%edx
80106ffe:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107004:	89 50 0c             	mov    %edx,0xc(%eax)
  cpu->ts.iomb = (ushort) 0xFFFF;
80107007:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010700c:	66 89 50 6e          	mov    %dx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107010:	b8 30 00 00 00       	mov    $0x30,%eax
80107015:	0f 00 d8             	ltr    %ax
  if(p->pgdir == 0)
80107018:	8b 43 04             	mov    0x4(%ebx),%eax
8010701b:	85 c0                	test   %eax,%eax
8010701d:	74 11                	je     80107030 <switchuvm+0x90>
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010701f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107024:	0f 22 d8             	mov    %eax,%cr3
}
80107027:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010702a:	c9                   	leave  
  popcli();
8010702b:	e9 80 d6 ff ff       	jmp    801046b0 <popcli>
    panic("switchuvm: no pgdir");
80107030:	83 ec 0c             	sub    $0xc,%esp
80107033:	68 80 82 10 80       	push   $0x80108280
80107038:	e8 33 93 ff ff       	call   80100370 <panic>
8010703d:	8d 76 00             	lea    0x0(%esi),%esi

80107040 <inituvm>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 1c             	sub    $0x1c,%esp
80107049:	8b 75 10             	mov    0x10(%ebp),%esi
8010704c:	8b 45 08             	mov    0x8(%ebp),%eax
8010704f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107052:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010705b:	77 49                	ja     801070a6 <inituvm+0x66>
  mem = kalloc();
8010705d:	e8 9e b4 ff ff       	call   80102500 <kalloc>
  memset(mem, 0, PGSIZE);
80107062:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107065:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107067:	68 00 10 00 00       	push   $0x1000
8010706c:	6a 00                	push   $0x0
8010706e:	50                   	push   %eax
8010706f:	e8 6c d9 ff ff       	call   801049e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107074:	58                   	pop    %eax
80107075:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010707b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107080:	5a                   	pop    %edx
80107081:	6a 06                	push   $0x6
80107083:	50                   	push   %eax
80107084:	31 d2                	xor    %edx,%edx
80107086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107089:	e8 62 fc ff ff       	call   80106cf0 <mappages>
  memmove(mem, init, sz);
8010708e:	89 75 10             	mov    %esi,0x10(%ebp)
80107091:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107094:	83 c4 10             	add    $0x10,%esp
80107097:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010709a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709d:	5b                   	pop    %ebx
8010709e:	5e                   	pop    %esi
8010709f:	5f                   	pop    %edi
801070a0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070a1:	e9 ea d9 ff ff       	jmp    80104a90 <memmove>
    panic("inituvm: more than a page");
801070a6:	83 ec 0c             	sub    $0xc,%esp
801070a9:	68 94 82 10 80       	push   $0x80108294
801070ae:	e8 bd 92 ff ff       	call   80100370 <panic>
801070b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070c0 <loaduvm>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801070c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801070d0:	0f 85 91 00 00 00    	jne    80107167 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801070d6:	8b 75 18             	mov    0x18(%ebp),%esi
801070d9:	31 db                	xor    %ebx,%ebx
801070db:	85 f6                	test   %esi,%esi
801070dd:	75 1a                	jne    801070f9 <loaduvm+0x39>
801070df:	eb 6f                	jmp    80107150 <loaduvm+0x90>
801070e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070ee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801070f4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801070f7:	76 57                	jbe    80107150 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801070fc:	8b 45 08             	mov    0x8(%ebp),%eax
801070ff:	31 c9                	xor    %ecx,%ecx
80107101:	01 da                	add    %ebx,%edx
80107103:	e8 68 fb ff ff       	call   80106c70 <walkpgdir>
80107108:	85 c0                	test   %eax,%eax
8010710a:	74 4e                	je     8010715a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010710c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010710e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107111:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107116:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010711b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107121:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107124:	01 d9                	add    %ebx,%ecx
80107126:	05 00 00 00 80       	add    $0x80000000,%eax
8010712b:	57                   	push   %edi
8010712c:	51                   	push   %ecx
8010712d:	50                   	push   %eax
8010712e:	ff 75 10             	pushl  0x10(%ebp)
80107131:	e8 fa a7 ff ff       	call   80101930 <readi>
80107136:	83 c4 10             	add    $0x10,%esp
80107139:	39 f8                	cmp    %edi,%eax
8010713b:	74 ab                	je     801070e8 <loaduvm+0x28>
}
8010713d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107145:	5b                   	pop    %ebx
80107146:	5e                   	pop    %esi
80107147:	5f                   	pop    %edi
80107148:	5d                   	pop    %ebp
80107149:	c3                   	ret    
8010714a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107153:	31 c0                	xor    %eax,%eax
}
80107155:	5b                   	pop    %ebx
80107156:	5e                   	pop    %esi
80107157:	5f                   	pop    %edi
80107158:	5d                   	pop    %ebp
80107159:	c3                   	ret    
      panic("loaduvm: address should exist");
8010715a:	83 ec 0c             	sub    $0xc,%esp
8010715d:	68 ae 82 10 80       	push   $0x801082ae
80107162:	e8 09 92 ff ff       	call   80100370 <panic>
    panic("loaduvm: addr must be page aligned");
80107167:	83 ec 0c             	sub    $0xc,%esp
8010716a:	68 a0 83 10 80       	push   $0x801083a0
8010716f:	e8 fc 91 ff ff       	call   80100370 <panic>
80107174:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010717a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107180 <allocuvm>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
80107186:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107189:	8b 7d 10             	mov    0x10(%ebp),%edi
8010718c:	85 ff                	test   %edi,%edi
8010718e:	0f 88 8e 00 00 00    	js     80107222 <allocuvm+0xa2>
  if(newsz < oldsz)
80107194:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107197:	0f 82 93 00 00 00    	jb     80107230 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010719d:	8b 45 0c             	mov    0xc(%ebp),%eax
801071a0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801071a6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801071ac:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801071af:	0f 86 7e 00 00 00    	jbe    80107233 <allocuvm+0xb3>
801071b5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801071b8:	8b 7d 08             	mov    0x8(%ebp),%edi
801071bb:	eb 42                	jmp    801071ff <allocuvm+0x7f>
801071bd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801071c0:	83 ec 04             	sub    $0x4,%esp
801071c3:	68 00 10 00 00       	push   $0x1000
801071c8:	6a 00                	push   $0x0
801071ca:	50                   	push   %eax
801071cb:	e8 10 d8 ff ff       	call   801049e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801071d0:	58                   	pop    %eax
801071d1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801071d7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071dc:	5a                   	pop    %edx
801071dd:	6a 06                	push   $0x6
801071df:	50                   	push   %eax
801071e0:	89 da                	mov    %ebx,%edx
801071e2:	89 f8                	mov    %edi,%eax
801071e4:	e8 07 fb ff ff       	call   80106cf0 <mappages>
801071e9:	83 c4 10             	add    $0x10,%esp
801071ec:	85 c0                	test   %eax,%eax
801071ee:	78 50                	js     80107240 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801071f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071f6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801071f9:	0f 86 81 00 00 00    	jbe    80107280 <allocuvm+0x100>
    mem = kalloc();
801071ff:	e8 fc b2 ff ff       	call   80102500 <kalloc>
    if(mem == 0){
80107204:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107206:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107208:	75 b6                	jne    801071c0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010720a:	83 ec 0c             	sub    $0xc,%esp
8010720d:	68 cc 82 10 80       	push   $0x801082cc
80107212:	e8 29 94 ff ff       	call   80100640 <cprintf>
  if(newsz >= oldsz)
80107217:	83 c4 10             	add    $0x10,%esp
8010721a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010721d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107220:	77 6e                	ja     80107290 <allocuvm+0x110>
}
80107222:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107225:	31 ff                	xor    %edi,%edi
}
80107227:	89 f8                	mov    %edi,%eax
80107229:	5b                   	pop    %ebx
8010722a:	5e                   	pop    %esi
8010722b:	5f                   	pop    %edi
8010722c:	5d                   	pop    %ebp
8010722d:	c3                   	ret    
8010722e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107230:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107233:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107236:	89 f8                	mov    %edi,%eax
80107238:	5b                   	pop    %ebx
80107239:	5e                   	pop    %esi
8010723a:	5f                   	pop    %edi
8010723b:	5d                   	pop    %ebp
8010723c:	c3                   	ret    
8010723d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107240:	83 ec 0c             	sub    $0xc,%esp
80107243:	68 e4 82 10 80       	push   $0x801082e4
80107248:	e8 f3 93 ff ff       	call   80100640 <cprintf>
  if(newsz >= oldsz)
8010724d:	83 c4 10             	add    $0x10,%esp
80107250:	8b 45 0c             	mov    0xc(%ebp),%eax
80107253:	39 45 10             	cmp    %eax,0x10(%ebp)
80107256:	76 0d                	jbe    80107265 <allocuvm+0xe5>
80107258:	89 c1                	mov    %eax,%ecx
8010725a:	8b 55 10             	mov    0x10(%ebp),%edx
8010725d:	8b 45 08             	mov    0x8(%ebp),%eax
80107260:	e8 0b fb ff ff       	call   80106d70 <deallocuvm.part.0>
      kfree(mem);
80107265:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107268:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010726a:	56                   	push   %esi
8010726b:	e8 90 b0 ff ff       	call   80102300 <kfree>
      return 0;
80107270:	83 c4 10             	add    $0x10,%esp
}
80107273:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107276:	89 f8                	mov    %edi,%eax
80107278:	5b                   	pop    %ebx
80107279:	5e                   	pop    %esi
8010727a:	5f                   	pop    %edi
8010727b:	5d                   	pop    %ebp
8010727c:	c3                   	ret    
8010727d:	8d 76 00             	lea    0x0(%esi),%esi
80107280:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107283:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107286:	5b                   	pop    %ebx
80107287:	89 f8                	mov    %edi,%eax
80107289:	5e                   	pop    %esi
8010728a:	5f                   	pop    %edi
8010728b:	5d                   	pop    %ebp
8010728c:	c3                   	ret    
8010728d:	8d 76 00             	lea    0x0(%esi),%esi
80107290:	89 c1                	mov    %eax,%ecx
80107292:	8b 55 10             	mov    0x10(%ebp),%edx
80107295:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107298:	31 ff                	xor    %edi,%edi
8010729a:	e8 d1 fa ff ff       	call   80106d70 <deallocuvm.part.0>
8010729f:	eb 92                	jmp    80107233 <allocuvm+0xb3>
801072a1:	eb 0d                	jmp    801072b0 <deallocuvm>
801072a3:	90                   	nop
801072a4:	90                   	nop
801072a5:	90                   	nop
801072a6:	90                   	nop
801072a7:	90                   	nop
801072a8:	90                   	nop
801072a9:	90                   	nop
801072aa:	90                   	nop
801072ab:	90                   	nop
801072ac:	90                   	nop
801072ad:	90                   	nop
801072ae:	90                   	nop
801072af:	90                   	nop

801072b0 <deallocuvm>:
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801072b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801072b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801072bc:	39 d1                	cmp    %edx,%ecx
801072be:	73 10                	jae    801072d0 <deallocuvm+0x20>
}
801072c0:	5d                   	pop    %ebp
801072c1:	e9 aa fa ff ff       	jmp    80106d70 <deallocuvm.part.0>
801072c6:	8d 76 00             	lea    0x0(%esi),%esi
801072c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801072d0:	89 d0                	mov    %edx,%eax
801072d2:	5d                   	pop    %ebp
801072d3:	c3                   	ret    
801072d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801072e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx
801072e6:	83 ec 0c             	sub    $0xc,%esp
801072e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801072ec:	85 f6                	test   %esi,%esi
801072ee:	74 59                	je     80107349 <freevm+0x69>
801072f0:	31 c9                	xor    %ecx,%ecx
801072f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072f7:	89 f0                	mov    %esi,%eax
801072f9:	e8 72 fa ff ff       	call   80106d70 <deallocuvm.part.0>
801072fe:	89 f3                	mov    %esi,%ebx
80107300:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107306:	eb 0f                	jmp    80107317 <freevm+0x37>
80107308:	90                   	nop
80107309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107310:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107313:	39 fb                	cmp    %edi,%ebx
80107315:	74 23                	je     8010733a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107317:	8b 03                	mov    (%ebx),%eax
80107319:	a8 01                	test   $0x1,%al
8010731b:	74 f3                	je     80107310 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010731d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107322:	83 ec 0c             	sub    $0xc,%esp
80107325:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107328:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010732d:	50                   	push   %eax
8010732e:	e8 cd af ff ff       	call   80102300 <kfree>
80107333:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107336:	39 fb                	cmp    %edi,%ebx
80107338:	75 dd                	jne    80107317 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010733a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010733d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107340:	5b                   	pop    %ebx
80107341:	5e                   	pop    %esi
80107342:	5f                   	pop    %edi
80107343:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107344:	e9 b7 af ff ff       	jmp    80102300 <kfree>
    panic("freevm: no pgdir");
80107349:	83 ec 0c             	sub    $0xc,%esp
8010734c:	68 00 83 10 80       	push   $0x80108300
80107351:	e8 1a 90 ff ff       	call   80100370 <panic>
80107356:	8d 76 00             	lea    0x0(%esi),%esi
80107359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107360 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107360:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107361:	31 c9                	xor    %ecx,%ecx
{
80107363:	89 e5                	mov    %esp,%ebp
80107365:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107368:	8b 55 0c             	mov    0xc(%ebp),%edx
8010736b:	8b 45 08             	mov    0x8(%ebp),%eax
8010736e:	e8 fd f8 ff ff       	call   80106c70 <walkpgdir>
  if(pte == 0)
80107373:	85 c0                	test   %eax,%eax
80107375:	74 05                	je     8010737c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107377:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010737a:	c9                   	leave  
8010737b:	c3                   	ret    
    panic("clearpteu");
8010737c:	83 ec 0c             	sub    $0xc,%esp
8010737f:	68 11 83 10 80       	push   $0x80108311
80107384:	e8 e7 8f ff ff       	call   80100370 <panic>
80107389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107390 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
80107395:	53                   	push   %ebx
80107396:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107399:	e8 52 fb ff ff       	call   80106ef0 <setupkvm>
8010739e:	85 c0                	test   %eax,%eax
801073a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801073a3:	0f 84 a0 00 00 00    	je     80107449 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801073a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073ac:	85 c9                	test   %ecx,%ecx
801073ae:	0f 84 95 00 00 00    	je     80107449 <copyuvm+0xb9>
801073b4:	31 f6                	xor    %esi,%esi
801073b6:	eb 4e                	jmp    80107406 <copyuvm+0x76>
801073b8:	90                   	nop
801073b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801073c0:	83 ec 04             	sub    $0x4,%esp
801073c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801073c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073cc:	68 00 10 00 00       	push   $0x1000
801073d1:	57                   	push   %edi
801073d2:	50                   	push   %eax
801073d3:	e8 b8 d6 ff ff       	call   80104a90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801073d8:	58                   	pop    %eax
801073d9:	5a                   	pop    %edx
801073da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801073dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073e5:	53                   	push   %ebx
801073e6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801073ec:	52                   	push   %edx
801073ed:	89 f2                	mov    %esi,%edx
801073ef:	e8 fc f8 ff ff       	call   80106cf0 <mappages>
801073f4:	83 c4 10             	add    $0x10,%esp
801073f7:	85 c0                	test   %eax,%eax
801073f9:	78 39                	js     80107434 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
801073fb:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107401:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107404:	76 43                	jbe    80107449 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107406:	8b 45 08             	mov    0x8(%ebp),%eax
80107409:	31 c9                	xor    %ecx,%ecx
8010740b:	89 f2                	mov    %esi,%edx
8010740d:	e8 5e f8 ff ff       	call   80106c70 <walkpgdir>
80107412:	85 c0                	test   %eax,%eax
80107414:	74 3e                	je     80107454 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107416:	8b 18                	mov    (%eax),%ebx
80107418:	f6 c3 01             	test   $0x1,%bl
8010741b:	74 44                	je     80107461 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
8010741d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010741f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107425:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010742b:	e8 d0 b0 ff ff       	call   80102500 <kalloc>
80107430:	85 c0                	test   %eax,%eax
80107432:	75 8c                	jne    801073c0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107434:	83 ec 0c             	sub    $0xc,%esp
80107437:	ff 75 e0             	pushl  -0x20(%ebp)
8010743a:	e8 a1 fe ff ff       	call   801072e0 <freevm>
  return 0;
8010743f:	83 c4 10             	add    $0x10,%esp
80107442:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107449:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010744c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010744f:	5b                   	pop    %ebx
80107450:	5e                   	pop    %esi
80107451:	5f                   	pop    %edi
80107452:	5d                   	pop    %ebp
80107453:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107454:	83 ec 0c             	sub    $0xc,%esp
80107457:	68 1b 83 10 80       	push   $0x8010831b
8010745c:	e8 0f 8f ff ff       	call   80100370 <panic>
      panic("copyuvm: page not present");
80107461:	83 ec 0c             	sub    $0xc,%esp
80107464:	68 35 83 10 80       	push   $0x80108335
80107469:	e8 02 8f ff ff       	call   80100370 <panic>
8010746e:	66 90                	xchg   %ax,%ax

80107470 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107470:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107471:	31 c9                	xor    %ecx,%ecx
{
80107473:	89 e5                	mov    %esp,%ebp
80107475:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107478:	8b 55 0c             	mov    0xc(%ebp),%edx
8010747b:	8b 45 08             	mov    0x8(%ebp),%eax
8010747e:	e8 ed f7 ff ff       	call   80106c70 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107483:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107485:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107486:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107488:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010748d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107490:	05 00 00 00 80       	add    $0x80000000,%eax
80107495:	83 fa 05             	cmp    $0x5,%edx
80107498:	ba 00 00 00 00       	mov    $0x0,%edx
8010749d:	0f 45 c2             	cmovne %edx,%eax
}
801074a0:	c3                   	ret    
801074a1:	eb 0d                	jmp    801074b0 <copyout>
801074a3:	90                   	nop
801074a4:	90                   	nop
801074a5:	90                   	nop
801074a6:	90                   	nop
801074a7:	90                   	nop
801074a8:	90                   	nop
801074a9:	90                   	nop
801074aa:	90                   	nop
801074ab:	90                   	nop
801074ac:	90                   	nop
801074ad:	90                   	nop
801074ae:	90                   	nop
801074af:	90                   	nop

801074b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
801074b6:	83 ec 1c             	sub    $0x1c,%esp
801074b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801074bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801074bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801074c2:	85 db                	test   %ebx,%ebx
801074c4:	75 40                	jne    80107506 <copyout+0x56>
801074c6:	eb 70                	jmp    80107538 <copyout+0x88>
801074c8:	90                   	nop
801074c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801074d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074d3:	89 f1                	mov    %esi,%ecx
801074d5:	29 d1                	sub    %edx,%ecx
801074d7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801074dd:	39 d9                	cmp    %ebx,%ecx
801074df:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801074e2:	29 f2                	sub    %esi,%edx
801074e4:	83 ec 04             	sub    $0x4,%esp
801074e7:	01 d0                	add    %edx,%eax
801074e9:	51                   	push   %ecx
801074ea:	57                   	push   %edi
801074eb:	50                   	push   %eax
801074ec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801074ef:	e8 9c d5 ff ff       	call   80104a90 <memmove>
    len -= n;
    buf += n;
801074f4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801074f7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801074fa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107500:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107502:	29 cb                	sub    %ecx,%ebx
80107504:	74 32                	je     80107538 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107506:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107508:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010750b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010750e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107514:	56                   	push   %esi
80107515:	ff 75 08             	pushl  0x8(%ebp)
80107518:	e8 53 ff ff ff       	call   80107470 <uva2ka>
    if(pa0 == 0)
8010751d:	83 c4 10             	add    $0x10,%esp
80107520:	85 c0                	test   %eax,%eax
80107522:	75 ac                	jne    801074d0 <copyout+0x20>
  }
  return 0;
}
80107524:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010752c:	5b                   	pop    %ebx
8010752d:	5e                   	pop    %esi
8010752e:	5f                   	pop    %edi
8010752f:	5d                   	pop    %ebp
80107530:	c3                   	ret    
80107531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107538:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010753b:	31 c0                	xor    %eax,%eax
}
8010753d:	5b                   	pop    %ebx
8010753e:	5e                   	pop    %esi
8010753f:	5f                   	pop    %edi
80107540:	5d                   	pop    %ebp
80107541:	c3                   	ret    
80107542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107550 <slab_init>:
}slab;

slab slabs[8];//8个slab的object

//初始化slab
void slab_init(){
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	57                   	push   %edi
80107554:	56                   	push   %esi
80107555:	53                   	push   %ebx
  int size,i;
  for(size=16,i=0;size<=2048;size*=2,i++){//size从16到2048依次分配
80107556:	be 10 00 00 00       	mov    $0x10,%esi
8010755b:	bb a8 f2 14 80       	mov    $0x8014f2a8,%ebx
    slabs[i].size=size;//分配大小
    slabs[i].num=4096/size;//分配数量
80107560:	bf 00 10 00 00       	mov    $0x1000,%edi
void slab_init(){
80107565:	83 ec 0c             	sub    $0xc,%esp
80107568:	90                   	nop
80107569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    slabs[i].num=4096/size;//分配数量
80107570:	89 f8                	mov    %edi,%eax
    memset(slabs[i].used_mask,0,256);//状态位设置成0  未使用
80107572:	83 ec 04             	sub    $0x4,%esp
    slabs[i].size=size;//分配大小
80107575:	89 73 f8             	mov    %esi,-0x8(%ebx)
    slabs[i].num=4096/size;//分配数量
80107578:	99                   	cltd   
    memset(slabs[i].used_mask,0,256);//状态位设置成0  未使用
80107579:	68 00 01 00 00       	push   $0x100
8010757e:	6a 00                	push   $0x0
    slabs[i].num=4096/size;//分配数量
80107580:	f7 fe                	idiv   %esi
    memset(slabs[i].used_mask,0,256);//状态位设置成0  未使用
80107582:	53                   	push   %ebx
80107583:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
    slabs[i].num=4096/size;//分配数量
80107589:	89 83 f0 fe ff ff    	mov    %eax,-0x110(%ebx)
    memset(slabs[i].used_mask,0,256);//状态位设置成0  未使用
8010758f:	e8 4c d4 ff ff       	call   801049e0 <memset>
    slabs[i].phy_address=kalloc();//分配起始物理地址位置
80107594:	e8 67 af ff ff       	call   80102500 <kalloc>
    cprintf("slab %d was assigned! address: %p\n",size,slabs[i].phy_address);
80107599:	83 c4 0c             	add    $0xc,%esp
    slabs[i].phy_address=kalloc();//分配起始物理地址位置
8010759c:	89 43 f4             	mov    %eax,-0xc(%ebx)
    cprintf("slab %d was assigned! address: %p\n",size,slabs[i].phy_address);
8010759f:	50                   	push   %eax
801075a0:	56                   	push   %esi
  for(size=16,i=0;size<=2048;size*=2,i++){//size从16到2048依次分配
801075a1:	01 f6                	add    %esi,%esi
    cprintf("slab %d was assigned! address: %p\n",size,slabs[i].phy_address);
801075a3:	68 c4 83 10 80       	push   $0x801083c4
801075a8:	e8 93 90 ff ff       	call   80100640 <cprintf>
  for(size=16,i=0;size<=2048;size*=2,i++){//size从16到2048依次分配
801075ad:	83 c4 10             	add    $0x10,%esp
801075b0:	81 fb 08 fb 14 80    	cmp    $0x8014fb08,%ebx
801075b6:	75 b8                	jne    80107570 <slab_init+0x20>
  }
}
801075b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075bb:	5b                   	pop    %ebx
801075bc:	5e                   	pop    %esi
801075bd:	5f                   	pop    %edi
801075be:	5d                   	pop    %ebp
801075bf:	c3                   	ret    

801075c0 <slab_alloc>:

int slab_alloc(pde_t* pgdir,void* va,uint sz){//参数分别为：页表指针 内核区间起始地址 待装入大小
801075c0:	55                   	push   %ebp
  if(sz>2048||sz<=0)return 0;//超出slab范围  error
801075c1:	31 c0                	xor    %eax,%eax
int slab_alloc(pde_t* pgdir,void* va,uint sz){//参数分别为：页表指针 内核区间起始地址 待装入大小
801075c3:	89 e5                	mov    %esp,%ebp
801075c5:	57                   	push   %edi
801075c6:	56                   	push   %esi
801075c7:	53                   	push   %ebx
801075c8:	83 ec 0c             	sub    $0xc,%esp
801075cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if(sz>2048||sz<=0)return 0;//超出slab范围  error
801075ce:	8d 51 ff             	lea    -0x1(%ecx),%edx
801075d1:	81 fa ff 07 00 00    	cmp    $0x7ff,%edx
801075d7:	77 4a                	ja     80107623 <slab_alloc+0x63>
  int size=16,i=0;//设置size初始值
801075d9:	31 d2                	xor    %edx,%edx
  while(size<sz) size*=2,i++;//确定size最适合的值
801075db:	83 f9 10             	cmp    $0x10,%ecx
801075de:	76 11                	jbe    801075f1 <slab_alloc+0x31>
  int size=16,i=0;//设置size初始值
801075e0:	b8 10 00 00 00       	mov    $0x10,%eax
801075e5:	8d 76 00             	lea    0x0(%esi),%esi
  while(size<sz) size*=2,i++;//确定size最适合的值
801075e8:	01 c0                	add    %eax,%eax
801075ea:	83 c2 01             	add    $0x1,%edx
801075ed:	39 c8                	cmp    %ecx,%eax
801075ef:	72 f7                	jb     801075e8 <slab_alloc+0x28>
  int j;
  for(j=0;j<slabs[i].num;j++)//遍历slabs数组
801075f1:	69 ca 0c 01 00 00    	imul   $0x10c,%edx,%ecx
801075f7:	8b 81 a4 f2 14 80    	mov    -0x7feb0d5c(%ecx),%eax
801075fd:	83 f8 00             	cmp    $0x0,%eax
80107600:	7e 2e                	jle    80107630 <slab_alloc+0x70>
80107602:	31 db                	xor    %ebx,%ebx
    if(slabs[i].used_mask[j]==0)break;//找到第一个未被使用的slab object
80107604:	80 b9 a8 f2 14 80 00 	cmpb   $0x0,-0x7feb0d58(%ecx)
8010760b:	75 0d                	jne    8010761a <slab_alloc+0x5a>
8010760d:	eb 25                	jmp    80107634 <slab_alloc+0x74>
8010760f:	90                   	nop
80107610:	80 bc 19 a8 f2 14 80 	cmpb   $0x0,-0x7feb0d58(%ecx,%ebx,1)
80107617:	00 
80107618:	74 1a                	je     80107634 <slab_alloc+0x74>
  for(j=0;j<slabs[i].num;j++)//遍历slabs数组
8010761a:	83 c3 01             	add    $0x1,%ebx
8010761d:	39 d8                	cmp    %ebx,%eax
8010761f:	75 ef                	jne    80107610 <slab_alloc+0x50>
  if(sz>2048||sz<=0)return 0;//超出slab范围  error
80107621:	31 c0                	xor    %eax,%eax
  uint pa=(uint) slabs[i].phy_address + j*slabs[i].size;//计算physical address
  cprintf("assign from physical address: %p \n",pa);//输出
  //按照用户页或者可改页将slab的起始地址及其大小的虚拟地址所在页映射到物理页中
  mappages(pgdir,va,4096,V2P(pa),PTE_W|PTE_U);
  return j*slabs[i].size;//返回在物理页上的地址偏移
}
80107623:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107626:	5b                   	pop    %ebx
80107627:	5e                   	pop    %esi
80107628:	5f                   	pop    %edi
80107629:	5d                   	pop    %ebp
8010762a:	c3                   	ret    
8010762b:	90                   	nop
8010762c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(j==slabs[i].num) return 0;//未查找到未被使用的slab  error
80107630:	74 f1                	je     80107623 <slab_alloc+0x63>
80107632:	31 db                	xor    %ebx,%ebx
  slabs[i].used_mask[j]=1;//对查找到的适合的object设置使用标志位为1
80107634:	69 f2 0c 01 00 00    	imul   $0x10c,%edx,%esi
  cprintf("assign from physical address: %p \n",pa);//输出
8010763a:	83 ec 08             	sub    $0x8,%esp
  uint pa=(uint) slabs[i].phy_address + j*slabs[i].size;//计算physical address
8010763d:	8b be a0 f2 14 80    	mov    -0x7feb0d60(%esi),%edi
  slabs[i].used_mask[j]=1;//对查找到的适合的object设置使用标志位为1
80107643:	c6 84 33 a8 f2 14 80 	movb   $0x1,-0x7feb0d58(%ebx,%esi,1)
8010764a:	01 
  uint pa=(uint) slabs[i].phy_address + j*slabs[i].size;//计算physical address
8010764b:	0f af fb             	imul   %ebx,%edi
8010764e:	03 be a8 f3 14 80    	add    -0x7feb0c58(%esi),%edi
  cprintf("assign from physical address: %p \n",pa);//输出
80107654:	57                   	push   %edi
80107655:	68 e8 83 10 80       	push   $0x801083e8
  mappages(pgdir,va,4096,V2P(pa),PTE_W|PTE_U);
8010765a:	81 c7 00 00 00 80    	add    $0x80000000,%edi
  cprintf("assign from physical address: %p \n",pa);//输出
80107660:	e8 db 8f ff ff       	call   80100640 <cprintf>
  mappages(pgdir,va,4096,V2P(pa),PTE_W|PTE_U);
80107665:	58                   	pop    %eax
80107666:	5a                   	pop    %edx
80107667:	8b 45 08             	mov    0x8(%ebp),%eax
8010766a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010766d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107672:	6a 06                	push   $0x6
80107674:	57                   	push   %edi
80107675:	e8 76 f6 ff ff       	call   80106cf0 <mappages>
  return j*slabs[i].size;//返回在物理页上的地址偏移
8010767a:	8b 86 a0 f2 14 80    	mov    -0x7feb0d60(%esi),%eax
80107680:	83 c4 10             	add    $0x10,%esp
}
80107683:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return j*slabs[i].size;//返回在物理页上的地址偏移
80107686:	0f af c3             	imul   %ebx,%eax
}
80107689:	5b                   	pop    %ebx
8010768a:	5e                   	pop    %esi
8010768b:	5f                   	pop    %edi
8010768c:	5d                   	pop    %ebp
8010768d:	c3                   	ret    
8010768e:	66 90                	xchg   %ax,%ax

80107690 <slab_free>:

int slab_free(pde_t* pgdir,void* va){//传入页表指针，内核区间起始地址
80107690:	55                   	push   %ebp
80107691:	89 e5                	mov    %esp,%ebp
80107693:	57                   	push   %edi
80107694:	56                   	push   %esi
80107695:	53                   	push   %ebx
  uint page_addr=(uint)uva2ka(pgdir,va);//虚拟地址映射到内核地址
  uint page_offset=(uint)va&4095;//页内偏移
  uint pa = page_addr+page_offset;//计算内核物理页地址
  cprintf("free physical address: %p\n",pa);
  int i;
  for(i=0;i<8;i++){//遍历slabs数组
80107696:	31 db                	xor    %ebx,%ebx
int slab_free(pde_t* pgdir,void* va){//传入页表指针，内核区间起始地址
80107698:	83 ec 14             	sub    $0x14,%esp
  uint page_addr=(uint)uva2ka(pgdir,va);//虚拟地址映射到内核地址
8010769b:	ff 75 0c             	pushl  0xc(%ebp)
8010769e:	ff 75 08             	pushl  0x8(%ebp)
801076a1:	e8 ca fd ff ff       	call   80107470 <uva2ka>
  uint page_offset=(uint)va&4095;//页内偏移
801076a6:	8b 55 0c             	mov    0xc(%ebp),%edx
801076a9:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  uint pa = page_addr+page_offset;//计算内核物理页地址
801076af:	8d 34 10             	lea    (%eax,%edx,1),%esi
  cprintf("free physical address: %p\n",pa);
801076b2:	58                   	pop    %eax
801076b3:	5a                   	pop    %edx
801076b4:	56                   	push   %esi
801076b5:	68 4f 83 10 80       	push   $0x8010834f
801076ba:	e8 81 8f ff ff       	call   80100640 <cprintf>
801076bf:	b9 a0 f2 14 80       	mov    $0x8014f2a0,%ecx
801076c4:	83 c4 10             	add    $0x10,%esp
    uint start=(uint)slabs[i].phy_address;//slab object对应的物理页帧起始地址
    uint end =start+slabs[i].num*(uint)slabs[i].size;//slab object对应的物理页帧结束地址
801076c7:	8b 39                	mov    (%ecx),%edi
801076c9:	8b 51 04             	mov    0x4(%ecx),%edx
    uint start=(uint)slabs[i].phy_address;//slab object对应的物理页帧起始地址
801076cc:	8b 81 08 01 00 00    	mov    0x108(%ecx),%eax
    uint end =start+slabs[i].num*(uint)slabs[i].size;//slab object对应的物理页帧结束地址
801076d2:	0f af d7             	imul   %edi,%edx
801076d5:	01 c2                	add    %eax,%edx
    if(start<=pa&&pa<end) break;//找到对应的slab  跳出循环
801076d7:	39 d6                	cmp    %edx,%esi
801076d9:	73 04                	jae    801076df <slab_free+0x4f>
801076db:	39 c6                	cmp    %eax,%esi
801076dd:	73 21                	jae    80107700 <slab_free+0x70>
  for(i=0;i<8;i++){//遍历slabs数组
801076df:	83 c3 01             	add    $0x1,%ebx
801076e2:	81 c1 0c 01 00 00    	add    $0x10c,%ecx
801076e8:	83 fb 08             	cmp    $0x8,%ebx
801076eb:	75 da                	jne    801076c7 <slab_free+0x37>
  int j=offset/slabs[i].size;//找到slab[i]的索引值
  slabs[i].used_mask[j]=0;//将其状态位设置为0
  pte_t* pte=walkpgdir(pgdir,va,0);//获取页表
  *pte=(uint)0;//将页表设置为0  也就是清空解除映射
  return 1;//1表示返回成功free
}
801076ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(i==8) return 0;  //如果没找到则该虚拟地址无效
801076f0:	31 c0                	xor    %eax,%eax
}
801076f2:	5b                   	pop    %ebx
801076f3:	5e                   	pop    %esi
801076f4:	5f                   	pop    %edi
801076f5:	5d                   	pop    %ebp
801076f6:	c3                   	ret    
801076f7:	89 f6                	mov    %esi,%esi
801076f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint offset =pa-(uint)slabs[i].phy_address;//计算slabs对应的物理页帧偏移
80107700:	29 c6                	sub    %eax,%esi
  int j=offset/slabs[i].size;//找到slab[i]的索引值
80107702:	31 d2                	xor    %edx,%edx
  pte_t* pte=walkpgdir(pgdir,va,0);//获取页表
80107704:	31 c9                	xor    %ecx,%ecx
  uint offset =pa-(uint)slabs[i].phy_address;//计算slabs对应的物理页帧偏移
80107706:	89 f0                	mov    %esi,%eax
  int j=offset/slabs[i].size;//找到slab[i]的索引值
80107708:	f7 f7                	div    %edi
  pte_t* pte=walkpgdir(pgdir,va,0);//获取页表
8010770a:	8b 55 0c             	mov    0xc(%ebp),%edx
  slabs[i].used_mask[j]=0;//将其状态位设置为0
8010770d:	69 db 0c 01 00 00    	imul   $0x10c,%ebx,%ebx
80107713:	c6 84 18 a8 f2 14 80 	movb   $0x0,-0x7feb0d58(%eax,%ebx,1)
8010771a:	00 
  pte_t* pte=walkpgdir(pgdir,va,0);//获取页表
8010771b:	8b 45 08             	mov    0x8(%ebp),%eax
8010771e:	e8 4d f5 ff ff       	call   80106c70 <walkpgdir>
  *pte=(uint)0;//将页表设置为0  也就是清空解除映射
80107723:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80107729:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;//1表示返回成功free
8010772c:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107731:	5b                   	pop    %ebx
80107732:	5e                   	pop    %esi
80107733:	5f                   	pop    %edi
80107734:	5d                   	pop    %ebp
80107735:	c3                   	ret    
80107736:	8d 76 00             	lea    0x0(%esi),%esi
80107739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107740 <copyuvm_onwrite>:

pde_t*
copyuvm_onwrite(pde_t *pgdir, uint sz)
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	57                   	push   %edi
80107744:	56                   	push   %esi
80107745:	53                   	push   %ebx
80107746:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0) //建立页表项以建立内核空间映射
80107749:	e8 a2 f7 ff ff       	call   80106ef0 <setupkvm>
8010774e:	85 c0                	test   %eax,%eax
80107750:	89 c7                	mov    %eax,%edi
80107752:	0f 84 8a 00 00 00    	je     801077e2 <copyuvm_onwrite+0xa2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){//在用户空间逐页处理
80107758:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010775b:	85 c9                	test   %ecx,%ecx
8010775d:	0f 84 7f 00 00 00    	je     801077e2 <copyuvm_onwrite+0xa2>
80107763:	31 db                	xor    %ebx,%ebx
80107765:	8d 76 00             	lea    0x0(%esi),%esi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)//获取该页的PTE
80107768:	8b 45 08             	mov    0x8(%ebp),%eax
8010776b:	31 c9                	xor    %ecx,%ecx
8010776d:	89 da                	mov    %ebx,%edx
8010776f:	e8 fc f4 ff ff       	call   80106c70 <walkpgdir>
80107774:	85 c0                	test   %eax,%eax
80107776:	0f 84 f7 00 00 00    	je     80107873 <copyuvm_onwrite+0x133>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))//PTE未映射页帧
8010777c:	8b 10                	mov    (%eax),%edx
8010777e:	f6 c2 01             	test   $0x1,%dl
80107781:	0f 84 df 00 00 00    	je     80107866 <copyuvm_onwrite+0x126>
80107787:	89 d6                	mov    %edx,%esi
80107789:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
      panic("copyuvm: page not present");
    if(i>=3*PGSIZE){
8010778f:	81 fb ff 2f 00 00    	cmp    $0x2fff,%ebx
80107795:	76 59                	jbe    801077f0 <copyuvm_onwrite+0xb0>
        *pte=((*pte)&(~PTE_W));
80107797:	89 d1                	mov    %edx,%ecx
      if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)//将新页帧映射到i
        goto bad;
      cprintf("copy %p->%p\n",P2V(pa),mem);
    }
    else{
      mappages(d,(void*)i,PGSIZE,pa,flags);//将新页帧映射到i
80107799:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
8010779c:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
        *pte=((*pte)&(~PTE_W));
801077a2:	83 e1 fd             	and    $0xfffffffd,%ecx
801077a5:	89 08                	mov    %ecx,(%eax)
      mappages(d,(void*)i,PGSIZE,pa,flags);//将新页帧映射到i
801077a7:	52                   	push   %edx
801077a8:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077ad:	56                   	push   %esi
801077ae:	89 da                	mov    %ebx,%edx
801077b0:	89 f8                	mov    %edi,%eax
801077b2:	e8 39 f5 ff ff       	call   80106cf0 <mappages>
      cprintf("lazy %p\n",P2V(pa));
801077b7:	59                   	pop    %ecx
801077b8:	58                   	pop    %eax
801077b9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801077bf:	50                   	push   %eax
801077c0:	68 6a 83 10 80       	push   $0x8010836a
801077c5:	e8 76 8e ff ff       	call   80100640 <cprintf>
      pageref_set(pa,1);//引用次数设置为1
801077ca:	58                   	pop    %eax
801077cb:	5a                   	pop    %edx
801077cc:	6a 01                	push   $0x1
801077ce:	56                   	push   %esi
801077cf:	e8 0c ae ff ff       	call   801025e0 <pageref_set>
801077d4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE){//在用户空间逐页处理
801077d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077dd:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
801077e0:	77 86                	ja     80107768 <copyuvm_onwrite+0x28>
  }
  return d;
bad:
  freevm(d);
  return 0;
}
801077e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077e5:	89 f8                	mov    %edi,%eax
801077e7:	5b                   	pop    %ebx
801077e8:	5e                   	pop    %esi
801077e9:	5f                   	pop    %edi
801077ea:	5d                   	pop    %ebp
801077eb:	c3                   	ret    
801077ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
801077f0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
801077f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      if((mem = kalloc()) == 0)//分配一个新页帧
801077f9:	e8 02 ad ff ff       	call   80102500 <kalloc>
801077fe:	85 c0                	test   %eax,%eax
80107800:	74 51                	je     80107853 <copyuvm_onwrite+0x113>
      memmove(mem, (char*)P2V(pa), PGSIZE);//从父进程拷贝一个页
80107802:	83 ec 04             	sub    $0x4,%esp
80107805:	81 c6 00 00 00 80    	add    $0x80000000,%esi
8010780b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010780e:	68 00 10 00 00       	push   $0x1000
80107813:	56                   	push   %esi
80107814:	50                   	push   %eax
80107815:	e8 76 d2 ff ff       	call   80104a90 <memmove>
      if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)//将新页帧映射到i
8010781a:	58                   	pop    %eax
8010781b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010781e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107823:	5a                   	pop    %edx
80107824:	ff 75 e0             	pushl  -0x20(%ebp)
80107827:	89 da                	mov    %ebx,%edx
80107829:	05 00 00 00 80       	add    $0x80000000,%eax
8010782e:	50                   	push   %eax
8010782f:	89 f8                	mov    %edi,%eax
80107831:	e8 ba f4 ff ff       	call   80106cf0 <mappages>
80107836:	83 c4 10             	add    $0x10,%esp
80107839:	85 c0                	test   %eax,%eax
8010783b:	78 16                	js     80107853 <copyuvm_onwrite+0x113>
      cprintf("copy %p->%p\n",P2V(pa),mem);
8010783d:	83 ec 04             	sub    $0x4,%esp
80107840:	ff 75 e4             	pushl  -0x1c(%ebp)
80107843:	56                   	push   %esi
80107844:	68 73 83 10 80       	push   $0x80108373
80107849:	e8 f2 8d ff ff       	call   80100640 <cprintf>
8010784e:	83 c4 10             	add    $0x10,%esp
80107851:	eb 84                	jmp    801077d7 <copyuvm_onwrite+0x97>
  freevm(d);
80107853:	83 ec 0c             	sub    $0xc,%esp
80107856:	57                   	push   %edi
  return 0;
80107857:	31 ff                	xor    %edi,%edi
  freevm(d);
80107859:	e8 82 fa ff ff       	call   801072e0 <freevm>
  return 0;
8010785e:	83 c4 10             	add    $0x10,%esp
80107861:	e9 7c ff ff ff       	jmp    801077e2 <copyuvm_onwrite+0xa2>
      panic("copyuvm: page not present");
80107866:	83 ec 0c             	sub    $0xc,%esp
80107869:	68 35 83 10 80       	push   $0x80108335
8010786e:	e8 fd 8a ff ff       	call   80100370 <panic>
      panic("copyuvm: pte should exist");
80107873:	83 ec 0c             	sub    $0xc,%esp
80107876:	68 1b 83 10 80       	push   $0x8010831b
8010787b:	e8 f0 8a ff ff       	call   80100370 <panic>

80107880 <copy_on_write>:

//考虑引用次数为1时已经独享不用复制，减少物理页浪费
void copy_on_write(pde_t* pgdir,void* va){
80107880:	55                   	push   %ebp
  pte_t* pte=walkpgdir(pgdir,va,0);
80107881:	31 c9                	xor    %ecx,%ecx
void copy_on_write(pde_t* pgdir,void* va){
80107883:	89 e5                	mov    %esp,%ebp
80107885:	57                   	push   %edi
80107886:	56                   	push   %esi
80107887:	53                   	push   %ebx
80107888:	83 ec 1c             	sub    $0x1c,%esp
8010788b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010788e:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t* pte=walkpgdir(pgdir,va,0);
80107891:	89 f2                	mov    %esi,%edx
80107893:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107896:	e8 d5 f3 ff ff       	call   80106c70 <walkpgdir>
  uint pa=PTE_ADDR(*pte);
8010789b:	8b 18                	mov    (%eax),%ebx
  uint ref=pageref_get(pa);
8010789d:	83 ec 0c             	sub    $0xc,%esp
  pte_t* pte=walkpgdir(pgdir,va,0);
801078a0:	89 c7                	mov    %eax,%edi
  uint pa=PTE_ADDR(*pte);
801078a2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  uint ref=pageref_get(pa);
801078a8:	53                   	push   %ebx
801078a9:	e8 f2 ac ff ff       	call   801025a0 <pageref_get>
  if(ref>1){//若引用次数大于1,则复制父进程页
801078ae:	83 c4 10             	add    $0x10,%esp
801078b1:	83 f8 01             	cmp    $0x1,%eax
801078b4:	76 62                	jbe    80107918 <copy_on_write+0x98>
    pageref_set(pa,-1);
801078b6:	83 ec 08             	sub    $0x8,%esp
801078b9:	6a ff                	push   $0xffffffff
801078bb:	53                   	push   %ebx
    char* mem=kalloc();
    memmove(mem,(char*)P2V(pa),PGSIZE);
801078bc:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    pageref_set(pa,-1);
801078c2:	e8 19 ad ff ff       	call   801025e0 <pageref_set>
    char* mem=kalloc();
801078c7:	e8 34 ac ff ff       	call   80102500 <kalloc>
    memmove(mem,(char*)P2V(pa),PGSIZE);
801078cc:	83 c4 0c             	add    $0xc,%esp
    char* mem=kalloc();
801078cf:	89 c7                	mov    %eax,%edi
    memmove(mem,(char*)P2V(pa),PGSIZE);
801078d1:	68 00 10 00 00       	push   $0x1000
801078d6:	53                   	push   %ebx
801078d7:	50                   	push   %eax
801078d8:	e8 b3 d1 ff ff       	call   80104a90 <memmove>
    mappages(pgdir,va,PGSIZE,V2P(mem),PTE_W|PTE_U);
801078dd:	58                   	pop    %eax
801078de:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801078e4:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078e9:	5a                   	pop    %edx
801078ea:	6a 06                	push   $0x6
801078ec:	50                   	push   %eax
801078ed:	89 f2                	mov    %esi,%edx
801078ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078f2:	e8 f9 f3 ff ff       	call   80106cf0 <mappages>
    cprintf("copy on write! copy: %p ->%p\n",P2V(pa),mem);
801078f7:	83 c4 0c             	add    $0xc,%esp
801078fa:	57                   	push   %edi
801078fb:	53                   	push   %ebx
801078fc:	68 80 83 10 80       	push   $0x80108380
80107901:	e8 3a 8d ff ff       	call   80100640 <cprintf>
80107906:	83 c4 10             	add    $0x10,%esp
  }else{//否则不复制
    *pte=(*pte)|PTE_W;
    cprintf("page ref=1,remove write forbidden!\n");
  }
80107909:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010790c:	5b                   	pop    %ebx
8010790d:	5e                   	pop    %esi
8010790e:	5f                   	pop    %edi
8010790f:	5d                   	pop    %ebp
80107910:	c3                   	ret    
80107911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *pte=(*pte)|PTE_W;
80107918:	83 0f 02             	orl    $0x2,(%edi)
    cprintf("page ref=1,remove write forbidden!\n");
8010791b:	c7 45 08 0c 84 10 80 	movl   $0x8010840c,0x8(%ebp)
80107922:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107925:	5b                   	pop    %ebx
80107926:	5e                   	pop    %esi
80107927:	5f                   	pop    %edi
80107928:	5d                   	pop    %ebp
    cprintf("page ref=1,remove write forbidden!\n");
80107929:	e9 12 8d ff ff       	jmp    80100640 <cprintf>
