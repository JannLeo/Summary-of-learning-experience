
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc d0 d5 10 80       	mov    $0x8010d5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 32 10 80       	mov    $0x801032a0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	57                   	push   %edi
80100044:	56                   	push   %esi
80100045:	53                   	push   %ebx
80100046:	89 c6                	mov    %eax,%esi
80100048:	89 d7                	mov    %edx,%edi
8010004a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
8010004d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100052:	e8 09 4a 00 00       	call   80104a60 <acquire>
80100057:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010005a:	8b 1d f4 14 11 80    	mov    0x801114f4,%ebx
80100060:	81 fb e4 14 11 80    	cmp    $0x801114e4,%ebx
80100066:	75 13                	jne    8010007b <bget+0x3b>
80100068:	eb 36                	jmp    801000a0 <bget+0x60>
8010006a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100070:	8b 5b 10             	mov    0x10(%ebx),%ebx
80100073:	81 fb e4 14 11 80    	cmp    $0x801114e4,%ebx
80100079:	74 25                	je     801000a0 <bget+0x60>
    if(b->dev == dev && b->blockno == blockno){
8010007b:	39 73 04             	cmp    %esi,0x4(%ebx)
8010007e:	75 f0                	jne    80100070 <bget+0x30>
80100080:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100083:	75 eb                	jne    80100070 <bget+0x30>
      if(!(b->flags & B_BUSY)){
80100085:	8b 03                	mov    (%ebx),%eax
80100087:	a8 01                	test   $0x1,%al
80100089:	74 5b                	je     801000e6 <bget+0xa6>
        b->flags |= B_BUSY;
        release(&bcache.lock);
        return b;
      }
      sleep(b, &bcache.lock);
8010008b:	83 ec 08             	sub    $0x8,%esp
8010008e:	68 e0 d5 10 80       	push   $0x8010d5e0
80100093:	53                   	push   %ebx
80100094:	e8 17 42 00 00       	call   801042b0 <sleep>
      goto loop;
80100099:	83 c4 10             	add    $0x10,%esp
8010009c:	eb bc                	jmp    8010005a <bget+0x1a>
8010009e:	66 90                	xchg   %ax,%ax
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801000a0:	8b 1d f0 14 11 80    	mov    0x801114f0,%ebx
801000a6:	81 fb e4 14 11 80    	cmp    $0x801114e4,%ebx
801000ac:	75 0d                	jne    801000bb <bget+0x7b>
801000ae:	eb 4d                	jmp    801000fd <bget+0xbd>
801000b0:	8b 5b 0c             	mov    0xc(%ebx),%ebx
801000b3:	81 fb e4 14 11 80    	cmp    $0x801114e4,%ebx
801000b9:	74 42                	je     801000fd <bget+0xbd>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
801000bb:	f6 03 05             	testb  $0x5,(%ebx)
801000be:	75 f0                	jne    801000b0 <bget+0x70>
      b->dev = dev;
      b->blockno = blockno;
      b->flags = B_BUSY;
      release(&bcache.lock);
801000c0:	83 ec 0c             	sub    $0xc,%esp
      b->dev = dev;
801000c3:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000c6:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = B_BUSY;
801000c9:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      release(&bcache.lock);
801000cf:	68 e0 d5 10 80       	push   $0x8010d5e0
801000d4:	e8 47 4b 00 00       	call   80104c20 <release>
      return b;
801000d9:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000df:	89 d8                	mov    %ebx,%eax
801000e1:	5b                   	pop    %ebx
801000e2:	5e                   	pop    %esi
801000e3:	5f                   	pop    %edi
801000e4:	5d                   	pop    %ebp
801000e5:	c3                   	ret    
        release(&bcache.lock);
801000e6:	83 ec 0c             	sub    $0xc,%esp
        b->flags |= B_BUSY;
801000e9:	83 c8 01             	or     $0x1,%eax
801000ec:	89 03                	mov    %eax,(%ebx)
        release(&bcache.lock);
801000ee:	68 e0 d5 10 80       	push   $0x8010d5e0
801000f3:	e8 28 4b 00 00       	call   80104c20 <release>
        return b;
801000f8:	83 c4 10             	add    $0x10,%esp
801000fb:	eb df                	jmp    801000dc <bget+0x9c>
  panic("bget: no buffers");
801000fd:	83 ec 0c             	sub    $0xc,%esp
80100100:	68 20 84 10 80       	push   $0x80108420
80100105:	e8 76 03 00 00       	call   80100480 <panic>
8010010a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100110 <binit>:
{
80100110:	55                   	push   %ebp
80100111:	89 e5                	mov    %esp,%ebp
80100113:	83 ec 10             	sub    $0x10,%esp
  initlock(&bcache.lock, "bcache");
80100116:	68 31 84 10 80       	push   $0x80108431
8010011b:	68 e0 d5 10 80       	push   $0x8010d5e0
80100120:	e8 1b 49 00 00       	call   80104a40 <initlock>
  bcache.head.prev = &bcache.head;
80100125:	c7 05 f0 14 11 80 e4 	movl   $0x801114e4,0x801114f0
8010012c:	14 11 80 
  bcache.head.next = &bcache.head;
8010012f:	c7 05 f4 14 11 80 e4 	movl   $0x801114e4,0x801114f4
80100136:	14 11 80 
80100139:	83 c4 10             	add    $0x10,%esp
8010013c:	b9 e4 14 11 80       	mov    $0x801114e4,%ecx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100141:	b8 14 d6 10 80       	mov    $0x8010d614,%eax
80100146:	eb 0a                	jmp    80100152 <binit+0x42>
80100148:	90                   	nop
80100149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100150:	89 d0                	mov    %edx,%eax
    b->next = bcache.head.next;
80100152:	89 48 10             	mov    %ecx,0x10(%eax)
    b->prev = &bcache.head;
80100155:	c7 40 0c e4 14 11 80 	movl   $0x801114e4,0xc(%eax)
8010015c:	89 c1                	mov    %eax,%ecx
    b->dev = -1;
8010015e:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
80100165:	8b 15 f4 14 11 80    	mov    0x801114f4,%edx
8010016b:	89 42 0c             	mov    %eax,0xc(%edx)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010016e:	8d 90 18 02 00 00    	lea    0x218(%eax),%edx
    bcache.head.next = b;
80100174:	a3 f4 14 11 80       	mov    %eax,0x801114f4
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100179:	81 fa e4 14 11 80    	cmp    $0x801114e4,%edx
8010017f:	72 cf                	jb     80100150 <binit+0x40>
}
80100181:	c9                   	leave  
80100182:	c3                   	ret    
80100183:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100190 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100190:	55                   	push   %ebp
80100191:	89 e5                	mov    %esp,%ebp
80100193:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100196:	8b 55 0c             	mov    0xc(%ebp),%edx
80100199:	8b 45 08             	mov    0x8(%ebp),%eax
8010019c:	e8 9f fe ff ff       	call   80100040 <bget>
  if(!(b->flags & B_VALID)) {
801001a1:	f6 00 02             	testb  $0x2,(%eax)
801001a4:	74 0a                	je     801001b0 <bread+0x20>
    iderw(b);
  }
  return b;
}
801001a6:	c9                   	leave  
801001a7:	c3                   	ret    
801001a8:	90                   	nop
801001a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
801001b0:	83 ec 0c             	sub    $0xc,%esp
801001b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001b6:	50                   	push   %eax
801001b7:	e8 c4 21 00 00       	call   80102380 <iderw>
801001bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001bf:	83 c4 10             	add    $0x10,%esp
}
801001c2:	c9                   	leave  
801001c3:	c3                   	ret    
801001c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801001ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001d0 <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001d0:	55                   	push   %ebp
801001d1:	89 e5                	mov    %esp,%ebp
801001d3:	83 ec 08             	sub    $0x8,%esp
801001d6:	8b 55 08             	mov    0x8(%ebp),%edx
  if((b->flags & B_BUSY) == 0)
801001d9:	8b 02                	mov    (%edx),%eax
801001db:	a8 01                	test   $0x1,%al
801001dd:	74 0b                	je     801001ea <bwrite+0x1a>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001df:	83 c8 04             	or     $0x4,%eax
801001e2:	89 02                	mov    %eax,(%edx)
  iderw(b);
}
801001e4:	c9                   	leave  
  iderw(b);
801001e5:	e9 96 21 00 00       	jmp    80102380 <iderw>
    panic("bwrite");
801001ea:	83 ec 0c             	sub    $0xc,%esp
801001ed:	68 38 84 10 80       	push   $0x80108438
801001f2:	e8 89 02 00 00       	call   80100480 <panic>
801001f7:	89 f6                	mov    %esi,%esi
801001f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100200 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100200:	55                   	push   %ebp
80100201:	89 e5                	mov    %esp,%ebp
80100203:	53                   	push   %ebx
80100204:	83 ec 04             	sub    $0x4,%esp
80100207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
8010020a:	f6 03 01             	testb  $0x1,(%ebx)
8010020d:	74 5a                	je     80100269 <brelse+0x69>
    panic("brelse");

  acquire(&bcache.lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	68 e0 d5 10 80       	push   $0x8010d5e0
80100217:	e8 44 48 00 00       	call   80104a60 <acquire>

  b->next->prev = b->prev;
8010021c:	8b 43 10             	mov    0x10(%ebx),%eax
8010021f:	8b 53 0c             	mov    0xc(%ebx),%edx
80100222:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100225:	8b 43 0c             	mov    0xc(%ebx),%eax
80100228:	8b 53 10             	mov    0x10(%ebx),%edx
8010022b:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010022e:	a1 f4 14 11 80       	mov    0x801114f4,%eax
  b->prev = &bcache.head;
80100233:	c7 43 0c e4 14 11 80 	movl   $0x801114e4,0xc(%ebx)
  b->next = bcache.head.next;
8010023a:	89 43 10             	mov    %eax,0x10(%ebx)
  bcache.head.next->prev = b;
8010023d:	a1 f4 14 11 80       	mov    0x801114f4,%eax
80100242:	89 58 0c             	mov    %ebx,0xc(%eax)
  bcache.head.next = b;
80100245:	89 1d f4 14 11 80    	mov    %ebx,0x801114f4

  b->flags &= ~B_BUSY;
8010024b:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  wakeup(b);
8010024e:	89 1c 24             	mov    %ebx,(%esp)
80100251:	e8 0a 42 00 00       	call   80104460 <wakeup>

  release(&bcache.lock);
80100256:	83 c4 10             	add    $0x10,%esp
80100259:	c7 45 08 e0 d5 10 80 	movl   $0x8010d5e0,0x8(%ebp)
}
80100260:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100263:	c9                   	leave  
  release(&bcache.lock);
80100264:	e9 b7 49 00 00       	jmp    80104c20 <release>
    panic("brelse");
80100269:	83 ec 0c             	sub    $0xc,%esp
8010026c:	68 3f 84 10 80       	push   $0x8010843f
80100271:	e8 0a 02 00 00       	call   80100480 <panic>
80100276:	8d 76 00             	lea    0x0(%esi),%esi
80100279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100280 <read_page_from_disk>:
//PAGEBREAK!
// Blank page.

void read_page_from_disk(int dev,char* va,uint blockno){
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 1c             	sub    $0x1c,%esp
80100289:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010028c:	8b 75 10             	mov    0x10(%ebp),%esi
8010028f:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
80100295:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100298:	90                   	nop
80100299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct buf* b;
  for(int i=0;i<8;i++){
    b=bread(dev,blockno+i);
801002a0:	83 ec 08             	sub    $0x8,%esp
801002a3:	56                   	push   %esi
801002a4:	ff 75 08             	pushl  0x8(%ebp)
801002a7:	83 c6 01             	add    $0x1,%esi
801002aa:	e8 e1 fe ff ff       	call   80100190 <bread>
801002af:	89 c7                	mov    %eax,%edi
    memmove(va+i*512,b->data,512);
801002b1:	8d 40 18             	lea    0x18(%eax),%eax
801002b4:	83 c4 0c             	add    $0xc,%esp
801002b7:	68 00 02 00 00       	push   $0x200
801002bc:	50                   	push   %eax
801002bd:	53                   	push   %ebx
801002be:	81 c3 00 02 00 00    	add    $0x200,%ebx
801002c4:	e8 e7 4c 00 00       	call   80104fb0 <memmove>
    brelse(b);
801002c9:	89 3c 24             	mov    %edi,(%esp)
801002cc:	e8 2f ff ff ff       	call   80100200 <brelse>
  for(int i=0;i<8;i++){
801002d1:	83 c4 10             	add    $0x10,%esp
801002d4:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
801002d7:	75 c7                	jne    801002a0 <read_page_from_disk+0x20>
  }
}
801002d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002dc:	5b                   	pop    %ebx
801002dd:	5e                   	pop    %esi
801002de:	5f                   	pop    %edi
801002df:	5d                   	pop    %ebp
801002e0:	c3                   	ret    
801002e1:	eb 0d                	jmp    801002f0 <write_page_to_disk>
801002e3:	90                   	nop
801002e4:	90                   	nop
801002e5:	90                   	nop
801002e6:	90                   	nop
801002e7:	90                   	nop
801002e8:	90                   	nop
801002e9:	90                   	nop
801002ea:	90                   	nop
801002eb:	90                   	nop
801002ec:	90                   	nop
801002ed:	90                   	nop
801002ee:	90                   	nop
801002ef:	90                   	nop

801002f0 <write_page_to_disk>:

void write_page_to_disk(int dev,char *va,uint blockno){
801002f0:	55                   	push   %ebp
801002f1:	89 e5                	mov    %esp,%ebp
801002f3:	57                   	push   %edi
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 1c             	sub    $0x1c,%esp
801002f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801002fc:	8b 7d 10             	mov    0x10(%ebp),%edi
801002ff:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
80100305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100308:	90                   	nop
80100309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct buf* b;
  for(int i=0;i<8;i++){
    b=bget(dev,blockno+i);
80100310:	8b 45 08             	mov    0x8(%ebp),%eax
80100313:	89 fa                	mov    %edi,%edx
80100315:	83 c7 01             	add    $0x1,%edi
80100318:	e8 23 fd ff ff       	call   80100040 <bget>
8010031d:	89 c6                	mov    %eax,%esi
    memmove(b->data,va+i*512,512);
8010031f:	8d 40 18             	lea    0x18(%eax),%eax
80100322:	83 ec 04             	sub    $0x4,%esp
80100325:	68 00 02 00 00       	push   $0x200
8010032a:	53                   	push   %ebx
8010032b:	81 c3 00 02 00 00    	add    $0x200,%ebx
80100331:	50                   	push   %eax
80100332:	e8 79 4c 00 00       	call   80104fb0 <memmove>
    bwrite(b);
80100337:	89 34 24             	mov    %esi,(%esp)
8010033a:	e8 91 fe ff ff       	call   801001d0 <bwrite>
    brelse(b);
8010033f:	89 34 24             	mov    %esi,(%esp)
80100342:	e8 b9 fe ff ff       	call   80100200 <brelse>
  for(int i=0;i<8;i++){
80100347:	83 c4 10             	add    $0x10,%esp
8010034a:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010034d:	75 c1                	jne    80100310 <write_page_to_disk+0x20>
  }
8010034f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100352:	5b                   	pop    %ebx
80100353:	5e                   	pop    %esi
80100354:	5f                   	pop    %edi
80100355:	5d                   	pop    %ebp
80100356:	c3                   	ret    
80100357:	66 90                	xchg   %ax,%ax
80100359:	66 90                	xchg   %ax,%ax
8010035b:	66 90                	xchg   %ax,%ax
8010035d:	66 90                	xchg   %ax,%ax
8010035f:	90                   	nop

80100360 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	57                   	push   %edi
80100364:	56                   	push   %esi
80100365:	53                   	push   %ebx
80100366:	83 ec 28             	sub    $0x28,%esp
80100369:	8b 7d 08             	mov    0x8(%ebp),%edi
8010036c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010036f:	57                   	push   %edi
80100370:	e8 4b 15 00 00       	call   801018c0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100375:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010037c:	e8 df 46 00 00       	call   80104a60 <acquire>
  while(n > 0){
80100381:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100384:	83 c4 10             	add    $0x10,%esp
80100387:	31 c0                	xor    %eax,%eax
80100389:	85 db                	test   %ebx,%ebx
8010038b:	0f 8e a1 00 00 00    	jle    80100432 <consoleread+0xd2>
    while(input.r == input.w){
80100391:	8b 15 80 17 11 80    	mov    0x80111780,%edx
80100397:	39 15 84 17 11 80    	cmp    %edx,0x80111784
8010039d:	74 2c                	je     801003cb <consoleread+0x6b>
8010039f:	eb 5f                	jmp    80100400 <consoleread+0xa0>
801003a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(proc->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801003a8:	83 ec 08             	sub    $0x8,%esp
801003ab:	68 20 c5 10 80       	push   $0x8010c520
801003b0:	68 80 17 11 80       	push   $0x80111780
801003b5:	e8 f6 3e 00 00       	call   801042b0 <sleep>
    while(input.r == input.w){
801003ba:	8b 15 80 17 11 80    	mov    0x80111780,%edx
801003c0:	83 c4 10             	add    $0x10,%esp
801003c3:	3b 15 84 17 11 80    	cmp    0x80111784,%edx
801003c9:	75 35                	jne    80100400 <consoleread+0xa0>
      if(proc->killed){
801003cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801003d1:	8b 40 24             	mov    0x24(%eax),%eax
801003d4:	85 c0                	test   %eax,%eax
801003d6:	74 d0                	je     801003a8 <consoleread+0x48>
        release(&cons.lock);
801003d8:	83 ec 0c             	sub    $0xc,%esp
801003db:	68 20 c5 10 80       	push   $0x8010c520
801003e0:	e8 3b 48 00 00       	call   80104c20 <release>
        ilock(ip);
801003e5:	89 3c 24             	mov    %edi,(%esp)
801003e8:	e8 c3 13 00 00       	call   801017b0 <ilock>
        return -1;
801003ed:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801003f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
801003f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801003f8:	5b                   	pop    %ebx
801003f9:	5e                   	pop    %esi
801003fa:	5f                   	pop    %edi
801003fb:	5d                   	pop    %ebp
801003fc:	c3                   	ret    
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100400:	8d 42 01             	lea    0x1(%edx),%eax
80100403:	a3 80 17 11 80       	mov    %eax,0x80111780
80100408:	89 d0                	mov    %edx,%eax
8010040a:	83 e0 7f             	and    $0x7f,%eax
8010040d:	0f be 80 00 17 11 80 	movsbl -0x7feee900(%eax),%eax
    if(c == C('D')){  // EOF
80100414:	83 f8 04             	cmp    $0x4,%eax
80100417:	74 3f                	je     80100458 <consoleread+0xf8>
    *dst++ = c;
80100419:	83 c6 01             	add    $0x1,%esi
    --n;
8010041c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010041f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100422:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100425:	74 43                	je     8010046a <consoleread+0x10a>
  while(n > 0){
80100427:	85 db                	test   %ebx,%ebx
80100429:	0f 85 62 ff ff ff    	jne    80100391 <consoleread+0x31>
8010042f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100432:	83 ec 0c             	sub    $0xc,%esp
80100435:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100438:	68 20 c5 10 80       	push   $0x8010c520
8010043d:	e8 de 47 00 00       	call   80104c20 <release>
  ilock(ip);
80100442:	89 3c 24             	mov    %edi,(%esp)
80100445:	e8 66 13 00 00       	call   801017b0 <ilock>
  return target - n;
8010044a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044d:	83 c4 10             	add    $0x10,%esp
}
80100450:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100453:	5b                   	pop    %ebx
80100454:	5e                   	pop    %esi
80100455:	5f                   	pop    %edi
80100456:	5d                   	pop    %ebp
80100457:	c3                   	ret    
80100458:	8b 45 10             	mov    0x10(%ebp),%eax
8010045b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010045d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100460:	73 d0                	jae    80100432 <consoleread+0xd2>
        input.r--;
80100462:	89 15 80 17 11 80    	mov    %edx,0x80111780
80100468:	eb c8                	jmp    80100432 <consoleread+0xd2>
8010046a:	8b 45 10             	mov    0x10(%ebp),%eax
8010046d:	29 d8                	sub    %ebx,%eax
8010046f:	eb c1                	jmp    80100432 <consoleread+0xd2>
80100471:	eb 0d                	jmp    80100480 <panic>
80100473:	90                   	nop
80100474:	90                   	nop
80100475:	90                   	nop
80100476:	90                   	nop
80100477:	90                   	nop
80100478:	90                   	nop
80100479:	90                   	nop
8010047a:	90                   	nop
8010047b:	90                   	nop
8010047c:	90                   	nop
8010047d:	90                   	nop
8010047e:	90                   	nop
8010047f:	90                   	nop

80100480 <panic>:
{
80100480:	55                   	push   %ebp
80100481:	89 e5                	mov    %esp,%ebp
80100483:	56                   	push   %esi
80100484:	53                   	push   %ebx
80100485:	83 ec 38             	sub    $0x38,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100488:	fa                   	cli    
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100489:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cons.locking = 0;
8010048f:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
80100496:	00 00 00 
  getcallerpcs(&s, pcs);
80100499:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010049c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010049f:	0f b6 00             	movzbl (%eax),%eax
801004a2:	50                   	push   %eax
801004a3:	68 46 84 10 80       	push   $0x80108446
801004a8:	e8 a3 02 00 00       	call   80100750 <cprintf>
  cprintf(s);
801004ad:	58                   	pop    %eax
801004ae:	ff 75 08             	pushl  0x8(%ebp)
801004b1:	e8 9a 02 00 00       	call   80100750 <cprintf>
  cprintf("\n");
801004b6:	c7 04 24 a6 89 10 80 	movl   $0x801089a6,(%esp)
801004bd:	e8 8e 02 00 00       	call   80100750 <cprintf>
  getcallerpcs(&s, pcs);
801004c2:	5a                   	pop    %edx
801004c3:	8d 45 08             	lea    0x8(%ebp),%eax
801004c6:	59                   	pop    %ecx
801004c7:	53                   	push   %ebx
801004c8:	50                   	push   %eax
801004c9:	e8 52 46 00 00       	call   80104b20 <getcallerpcs>
801004ce:	83 c4 10             	add    $0x10,%esp
801004d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801004d8:	83 ec 08             	sub    $0x8,%esp
801004db:	ff 33                	pushl  (%ebx)
801004dd:	83 c3 04             	add    $0x4,%ebx
801004e0:	68 62 84 10 80       	push   $0x80108462
801004e5:	e8 66 02 00 00       	call   80100750 <cprintf>
  for(i=0; i<10; i++)
801004ea:	83 c4 10             	add    $0x10,%esp
801004ed:	39 f3                	cmp    %esi,%ebx
801004ef:	75 e7                	jne    801004d8 <panic+0x58>
  panicked = 1; // freeze other CPU
801004f1:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
801004f8:	00 00 00 
801004fb:	eb fe                	jmp    801004fb <panic+0x7b>
801004fd:	8d 76 00             	lea    0x0(%esi),%esi

80100500 <consputc>:
  if(panicked){
80100500:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
80100506:	85 c9                	test   %ecx,%ecx
80100508:	74 06                	je     80100510 <consputc+0x10>
8010050a:	fa                   	cli    
8010050b:	eb fe                	jmp    8010050b <consputc+0xb>
8010050d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100510:	55                   	push   %ebp
80100511:	89 e5                	mov    %esp,%ebp
80100513:	57                   	push   %edi
80100514:	56                   	push   %esi
80100515:	53                   	push   %ebx
80100516:	89 c6                	mov    %eax,%esi
80100518:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010051b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100520:	0f 84 b1 00 00 00    	je     801005d7 <consputc+0xd7>
    uartputc(c);
80100526:	83 ec 0c             	sub    $0xc,%esp
80100529:	50                   	push   %eax
8010052a:	e8 71 65 00 00       	call   80106aa0 <uartputc>
8010052f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100532:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100537:	b8 0e 00 00 00       	mov    $0xe,%eax
8010053c:	89 da                	mov    %ebx,%edx
8010053e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010053f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100544:	89 ca                	mov    %ecx,%edx
80100546:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100547:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010054a:	89 da                	mov    %ebx,%edx
8010054c:	c1 e0 08             	shl    $0x8,%eax
8010054f:	89 c7                	mov    %eax,%edi
80100551:	b8 0f 00 00 00       	mov    $0xf,%eax
80100556:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100557:	89 ca                	mov    %ecx,%edx
80100559:	ec                   	in     (%dx),%al
8010055a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010055d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010055f:	83 fe 0a             	cmp    $0xa,%esi
80100562:	0f 84 f3 00 00 00    	je     8010065b <consputc+0x15b>
  else if(c == BACKSPACE){
80100568:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010056e:	0f 84 d7 00 00 00    	je     8010064b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100574:	89 f0                	mov    %esi,%eax
80100576:	0f b6 c0             	movzbl %al,%eax
80100579:	80 cc 07             	or     $0x7,%ah
8010057c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100583:	80 
80100584:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100587:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010058d:	0f 8f ab 00 00 00    	jg     8010063e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
80100593:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100599:	7f 66                	jg     80100601 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010059b:	be d4 03 00 00       	mov    $0x3d4,%esi
801005a0:	b8 0e 00 00 00       	mov    $0xe,%eax
801005a5:	89 f2                	mov    %esi,%edx
801005a7:	ee                   	out    %al,(%dx)
801005a8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801005ad:	89 d8                	mov    %ebx,%eax
801005af:	c1 f8 08             	sar    $0x8,%eax
801005b2:	89 ca                	mov    %ecx,%edx
801005b4:	ee                   	out    %al,(%dx)
801005b5:	b8 0f 00 00 00       	mov    $0xf,%eax
801005ba:	89 f2                	mov    %esi,%edx
801005bc:	ee                   	out    %al,(%dx)
801005bd:	89 d8                	mov    %ebx,%eax
801005bf:	89 ca                	mov    %ecx,%edx
801005c1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801005c2:	b8 20 07 00 00       	mov    $0x720,%eax
801005c7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801005ce:	80 
}
801005cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005d2:	5b                   	pop    %ebx
801005d3:	5e                   	pop    %esi
801005d4:	5f                   	pop    %edi
801005d5:	5d                   	pop    %ebp
801005d6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801005d7:	83 ec 0c             	sub    $0xc,%esp
801005da:	6a 08                	push   $0x8
801005dc:	e8 bf 64 00 00       	call   80106aa0 <uartputc>
801005e1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005e8:	e8 b3 64 00 00       	call   80106aa0 <uartputc>
801005ed:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005f4:	e8 a7 64 00 00       	call   80106aa0 <uartputc>
801005f9:	83 c4 10             	add    $0x10,%esp
801005fc:	e9 31 ff ff ff       	jmp    80100532 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100601:	52                   	push   %edx
80100602:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100607:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010060a:	68 a0 80 0b 80       	push   $0x800b80a0
8010060f:	68 00 80 0b 80       	push   $0x800b8000
80100614:	e8 97 49 00 00       	call   80104fb0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100619:	b8 80 07 00 00       	mov    $0x780,%eax
8010061e:	83 c4 0c             	add    $0xc,%esp
80100621:	29 d8                	sub    %ebx,%eax
80100623:	01 c0                	add    %eax,%eax
80100625:	50                   	push   %eax
80100626:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100629:	6a 00                	push   $0x0
8010062b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100630:	50                   	push   %eax
80100631:	e8 ca 48 00 00       	call   80104f00 <memset>
80100636:	83 c4 10             	add    $0x10,%esp
80100639:	e9 5d ff ff ff       	jmp    8010059b <consputc+0x9b>
    panic("pos under/overflow");
8010063e:	83 ec 0c             	sub    $0xc,%esp
80100641:	68 66 84 10 80       	push   $0x80108466
80100646:	e8 35 fe ff ff       	call   80100480 <panic>
    if(pos > 0) --pos;
8010064b:	85 db                	test   %ebx,%ebx
8010064d:	0f 84 48 ff ff ff    	je     8010059b <consputc+0x9b>
80100653:	83 eb 01             	sub    $0x1,%ebx
80100656:	e9 2c ff ff ff       	jmp    80100587 <consputc+0x87>
    pos += 80 - pos%80;
8010065b:	89 d8                	mov    %ebx,%eax
8010065d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100662:	99                   	cltd   
80100663:	f7 f9                	idiv   %ecx
80100665:	29 d1                	sub    %edx,%ecx
80100667:	01 cb                	add    %ecx,%ebx
80100669:	e9 19 ff ff ff       	jmp    80100587 <consputc+0x87>
8010066e:	66 90                	xchg   %ax,%ax

80100670 <printint>:
{
80100670:	55                   	push   %ebp
80100671:	89 e5                	mov    %esp,%ebp
80100673:	57                   	push   %edi
80100674:	56                   	push   %esi
80100675:	53                   	push   %ebx
80100676:	89 d3                	mov    %edx,%ebx
80100678:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010067b:	85 c9                	test   %ecx,%ecx
{
8010067d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100680:	74 04                	je     80100686 <printint+0x16>
80100682:	85 c0                	test   %eax,%eax
80100684:	78 5a                	js     801006e0 <printint+0x70>
    x = xx;
80100686:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010068d:	31 c9                	xor    %ecx,%ecx
8010068f:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100692:	eb 06                	jmp    8010069a <printint+0x2a>
80100694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
80100698:	89 f9                	mov    %edi,%ecx
8010069a:	31 d2                	xor    %edx,%edx
8010069c:	8d 79 01             	lea    0x1(%ecx),%edi
8010069f:	f7 f3                	div    %ebx
801006a1:	0f b6 92 94 84 10 80 	movzbl -0x7fef7b6c(%edx),%edx
  }while((x /= base) != 0);
801006a8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801006aa:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801006ad:	75 e9                	jne    80100698 <printint+0x28>
  if(sign)
801006af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801006b2:	85 c0                	test   %eax,%eax
801006b4:	74 08                	je     801006be <printint+0x4e>
    buf[i++] = '-';
801006b6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801006bb:	8d 79 02             	lea    0x2(%ecx),%edi
801006be:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801006c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801006c8:	0f be 03             	movsbl (%ebx),%eax
801006cb:	83 eb 01             	sub    $0x1,%ebx
801006ce:	e8 2d fe ff ff       	call   80100500 <consputc>
  while(--i >= 0)
801006d3:	39 f3                	cmp    %esi,%ebx
801006d5:	75 f1                	jne    801006c8 <printint+0x58>
}
801006d7:	83 c4 2c             	add    $0x2c,%esp
801006da:	5b                   	pop    %ebx
801006db:	5e                   	pop    %esi
801006dc:	5f                   	pop    %edi
801006dd:	5d                   	pop    %ebp
801006de:	c3                   	ret    
801006df:	90                   	nop
    x = -xx;
801006e0:	f7 d8                	neg    %eax
801006e2:	eb a9                	jmp    8010068d <printint+0x1d>
801006e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801006ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801006f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801006f0:	55                   	push   %ebp
801006f1:	89 e5                	mov    %esp,%ebp
801006f3:	57                   	push   %edi
801006f4:	56                   	push   %esi
801006f5:	53                   	push   %ebx
801006f6:	83 ec 18             	sub    $0x18,%esp
801006f9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801006fc:	ff 75 08             	pushl  0x8(%ebp)
801006ff:	e8 bc 11 00 00       	call   801018c0 <iunlock>
  acquire(&cons.lock);
80100704:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010070b:	e8 50 43 00 00       	call   80104a60 <acquire>
  for(i = 0; i < n; i++)
80100710:	83 c4 10             	add    $0x10,%esp
80100713:	85 f6                	test   %esi,%esi
80100715:	7e 18                	jle    8010072f <consolewrite+0x3f>
80100717:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010071a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100720:	0f b6 07             	movzbl (%edi),%eax
80100723:	83 c7 01             	add    $0x1,%edi
80100726:	e8 d5 fd ff ff       	call   80100500 <consputc>
  for(i = 0; i < n; i++)
8010072b:	39 fb                	cmp    %edi,%ebx
8010072d:	75 f1                	jne    80100720 <consolewrite+0x30>
  release(&cons.lock);
8010072f:	83 ec 0c             	sub    $0xc,%esp
80100732:	68 20 c5 10 80       	push   $0x8010c520
80100737:	e8 e4 44 00 00       	call   80104c20 <release>
  ilock(ip);
8010073c:	58                   	pop    %eax
8010073d:	ff 75 08             	pushl  0x8(%ebp)
80100740:	e8 6b 10 00 00       	call   801017b0 <ilock>

  return n;
}
80100745:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100748:	89 f0                	mov    %esi,%eax
8010074a:	5b                   	pop    %ebx
8010074b:	5e                   	pop    %esi
8010074c:	5f                   	pop    %edi
8010074d:	5d                   	pop    %ebp
8010074e:	c3                   	ret    
8010074f:	90                   	nop

80100750 <cprintf>:
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	57                   	push   %edi
80100754:	56                   	push   %esi
80100755:	53                   	push   %ebx
80100756:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100759:	a1 54 c5 10 80       	mov    0x8010c554,%eax
  if(locking)
8010075e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100760:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100763:	0f 85 6f 01 00 00    	jne    801008d8 <cprintf+0x188>
  if (fmt == 0)
80100769:	8b 45 08             	mov    0x8(%ebp),%eax
8010076c:	85 c0                	test   %eax,%eax
8010076e:	89 c7                	mov    %eax,%edi
80100770:	0f 84 77 01 00 00    	je     801008ed <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100776:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100779:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010077e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100781:	85 c0                	test   %eax,%eax
80100783:	75 56                	jne    801007db <cprintf+0x8b>
80100785:	eb 79                	jmp    80100800 <cprintf+0xb0>
80100787:	89 f6                	mov    %esi,%esi
80100789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
80100790:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
80100793:	85 d2                	test   %edx,%edx
80100795:	74 69                	je     80100800 <cprintf+0xb0>
80100797:	83 c3 02             	add    $0x2,%ebx
    switch(c){
8010079a:	83 fa 70             	cmp    $0x70,%edx
8010079d:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801007a0:	0f 84 84 00 00 00    	je     8010082a <cprintf+0xda>
801007a6:	7f 78                	jg     80100820 <cprintf+0xd0>
801007a8:	83 fa 25             	cmp    $0x25,%edx
801007ab:	0f 84 ff 00 00 00    	je     801008b0 <cprintf+0x160>
801007b1:	83 fa 64             	cmp    $0x64,%edx
801007b4:	0f 85 8e 00 00 00    	jne    80100848 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801007ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007bd:	ba 0a 00 00 00       	mov    $0xa,%edx
801007c2:	8d 48 04             	lea    0x4(%eax),%ecx
801007c5:	8b 00                	mov    (%eax),%eax
801007c7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801007ca:	b9 01 00 00 00       	mov    $0x1,%ecx
801007cf:	e8 9c fe ff ff       	call   80100670 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007d4:	0f b6 06             	movzbl (%esi),%eax
801007d7:	85 c0                	test   %eax,%eax
801007d9:	74 25                	je     80100800 <cprintf+0xb0>
801007db:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801007de:	83 f8 25             	cmp    $0x25,%eax
801007e1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801007e4:	74 aa                	je     80100790 <cprintf+0x40>
801007e6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801007e9:	e8 12 fd ff ff       	call   80100500 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ee:	0f b6 06             	movzbl (%esi),%eax
      continue;
801007f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801007f4:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007f6:	85 c0                	test   %eax,%eax
801007f8:	75 e1                	jne    801007db <cprintf+0x8b>
801007fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100800:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100803:	85 c0                	test   %eax,%eax
80100805:	74 10                	je     80100817 <cprintf+0xc7>
    release(&cons.lock);
80100807:	83 ec 0c             	sub    $0xc,%esp
8010080a:	68 20 c5 10 80       	push   $0x8010c520
8010080f:	e8 0c 44 00 00       	call   80104c20 <release>
80100814:	83 c4 10             	add    $0x10,%esp
}
80100817:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010081a:	5b                   	pop    %ebx
8010081b:	5e                   	pop    %esi
8010081c:	5f                   	pop    %edi
8010081d:	5d                   	pop    %ebp
8010081e:	c3                   	ret    
8010081f:	90                   	nop
    switch(c){
80100820:	83 fa 73             	cmp    $0x73,%edx
80100823:	74 43                	je     80100868 <cprintf+0x118>
80100825:	83 fa 78             	cmp    $0x78,%edx
80100828:	75 1e                	jne    80100848 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010082a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010082d:	ba 10 00 00 00       	mov    $0x10,%edx
80100832:	8d 48 04             	lea    0x4(%eax),%ecx
80100835:	8b 00                	mov    (%eax),%eax
80100837:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010083a:	31 c9                	xor    %ecx,%ecx
8010083c:	e8 2f fe ff ff       	call   80100670 <printint>
      break;
80100841:	eb 91                	jmp    801007d4 <cprintf+0x84>
80100843:	90                   	nop
80100844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100848:	b8 25 00 00 00       	mov    $0x25,%eax
8010084d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100850:	e8 ab fc ff ff       	call   80100500 <consputc>
      consputc(c);
80100855:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100858:	89 d0                	mov    %edx,%eax
8010085a:	e8 a1 fc ff ff       	call   80100500 <consputc>
      break;
8010085f:	e9 70 ff ff ff       	jmp    801007d4 <cprintf+0x84>
80100864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100868:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010086b:	8b 10                	mov    (%eax),%edx
8010086d:	8d 48 04             	lea    0x4(%eax),%ecx
80100870:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100873:	85 d2                	test   %edx,%edx
80100875:	74 49                	je     801008c0 <cprintf+0x170>
      for(; *s; s++)
80100877:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010087a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010087d:	84 c0                	test   %al,%al
8010087f:	0f 84 4f ff ff ff    	je     801007d4 <cprintf+0x84>
80100885:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100888:	89 d3                	mov    %edx,%ebx
8010088a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100890:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
80100893:	e8 68 fc ff ff       	call   80100500 <consputc>
      for(; *s; s++)
80100898:	0f be 03             	movsbl (%ebx),%eax
8010089b:	84 c0                	test   %al,%al
8010089d:	75 f1                	jne    80100890 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
8010089f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801008a2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801008a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801008a8:	e9 27 ff ff ff       	jmp    801007d4 <cprintf+0x84>
801008ad:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801008b0:	b8 25 00 00 00       	mov    $0x25,%eax
801008b5:	e8 46 fc ff ff       	call   80100500 <consputc>
      break;
801008ba:	e9 15 ff ff ff       	jmp    801007d4 <cprintf+0x84>
801008bf:	90                   	nop
        s = "(null)";
801008c0:	ba 79 84 10 80       	mov    $0x80108479,%edx
      for(; *s; s++)
801008c5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801008c8:	b8 28 00 00 00       	mov    $0x28,%eax
801008cd:	89 d3                	mov    %edx,%ebx
801008cf:	eb bf                	jmp    80100890 <cprintf+0x140>
801008d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801008d8:	83 ec 0c             	sub    $0xc,%esp
801008db:	68 20 c5 10 80       	push   $0x8010c520
801008e0:	e8 7b 41 00 00       	call   80104a60 <acquire>
801008e5:	83 c4 10             	add    $0x10,%esp
801008e8:	e9 7c fe ff ff       	jmp    80100769 <cprintf+0x19>
    panic("null fmt");
801008ed:	83 ec 0c             	sub    $0xc,%esp
801008f0:	68 80 84 10 80       	push   $0x80108480
801008f5:	e8 86 fb ff ff       	call   80100480 <panic>
801008fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100900 <consoleintr>:
{
80100900:	55                   	push   %ebp
80100901:	89 e5                	mov    %esp,%ebp
80100903:	57                   	push   %edi
80100904:	56                   	push   %esi
80100905:	53                   	push   %ebx
  int c, doprocdump = 0;
80100906:	31 f6                	xor    %esi,%esi
{
80100908:	83 ec 18             	sub    $0x18,%esp
8010090b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010090e:	68 20 c5 10 80       	push   $0x8010c520
80100913:	e8 48 41 00 00       	call   80104a60 <acquire>
  while((c = getc()) >= 0){
80100918:	83 c4 10             	add    $0x10,%esp
8010091b:	90                   	nop
8010091c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100920:	ff d3                	call   *%ebx
80100922:	85 c0                	test   %eax,%eax
80100924:	89 c7                	mov    %eax,%edi
80100926:	78 48                	js     80100970 <consoleintr+0x70>
    switch(c){
80100928:	83 ff 10             	cmp    $0x10,%edi
8010092b:	0f 84 e7 00 00 00    	je     80100a18 <consoleintr+0x118>
80100931:	7e 5d                	jle    80100990 <consoleintr+0x90>
80100933:	83 ff 15             	cmp    $0x15,%edi
80100936:	0f 84 ec 00 00 00    	je     80100a28 <consoleintr+0x128>
8010093c:	83 ff 7f             	cmp    $0x7f,%edi
8010093f:	75 54                	jne    80100995 <consoleintr+0x95>
      if(input.e != input.w){
80100941:	a1 88 17 11 80       	mov    0x80111788,%eax
80100946:	3b 05 84 17 11 80    	cmp    0x80111784,%eax
8010094c:	74 d2                	je     80100920 <consoleintr+0x20>
        input.e--;
8010094e:	83 e8 01             	sub    $0x1,%eax
80100951:	a3 88 17 11 80       	mov    %eax,0x80111788
        consputc(BACKSPACE);
80100956:	b8 00 01 00 00       	mov    $0x100,%eax
8010095b:	e8 a0 fb ff ff       	call   80100500 <consputc>
  while((c = getc()) >= 0){
80100960:	ff d3                	call   *%ebx
80100962:	85 c0                	test   %eax,%eax
80100964:	89 c7                	mov    %eax,%edi
80100966:	79 c0                	jns    80100928 <consoleintr+0x28>
80100968:	90                   	nop
80100969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100970:	83 ec 0c             	sub    $0xc,%esp
80100973:	68 20 c5 10 80       	push   $0x8010c520
80100978:	e8 a3 42 00 00       	call   80104c20 <release>
  if(doprocdump) {
8010097d:	83 c4 10             	add    $0x10,%esp
80100980:	85 f6                	test   %esi,%esi
80100982:	0f 85 f8 00 00 00    	jne    80100a80 <consoleintr+0x180>
}
80100988:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010098b:	5b                   	pop    %ebx
8010098c:	5e                   	pop    %esi
8010098d:	5f                   	pop    %edi
8010098e:	5d                   	pop    %ebp
8010098f:	c3                   	ret    
    switch(c){
80100990:	83 ff 08             	cmp    $0x8,%edi
80100993:	74 ac                	je     80100941 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100995:	85 ff                	test   %edi,%edi
80100997:	74 87                	je     80100920 <consoleintr+0x20>
80100999:	a1 88 17 11 80       	mov    0x80111788,%eax
8010099e:	89 c2                	mov    %eax,%edx
801009a0:	2b 15 80 17 11 80    	sub    0x80111780,%edx
801009a6:	83 fa 7f             	cmp    $0x7f,%edx
801009a9:	0f 87 71 ff ff ff    	ja     80100920 <consoleintr+0x20>
801009af:	8d 50 01             	lea    0x1(%eax),%edx
801009b2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009b5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801009b8:	89 15 88 17 11 80    	mov    %edx,0x80111788
        c = (c == '\r') ? '\n' : c;
801009be:	0f 84 cc 00 00 00    	je     80100a90 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801009c4:	89 f9                	mov    %edi,%ecx
801009c6:	88 88 00 17 11 80    	mov    %cl,-0x7feee900(%eax)
        consputc(c);
801009cc:	89 f8                	mov    %edi,%eax
801009ce:	e8 2d fb ff ff       	call   80100500 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009d3:	83 ff 0a             	cmp    $0xa,%edi
801009d6:	0f 84 c5 00 00 00    	je     80100aa1 <consoleintr+0x1a1>
801009dc:	83 ff 04             	cmp    $0x4,%edi
801009df:	0f 84 bc 00 00 00    	je     80100aa1 <consoleintr+0x1a1>
801009e5:	a1 80 17 11 80       	mov    0x80111780,%eax
801009ea:	83 e8 80             	sub    $0xffffff80,%eax
801009ed:	39 05 88 17 11 80    	cmp    %eax,0x80111788
801009f3:	0f 85 27 ff ff ff    	jne    80100920 <consoleintr+0x20>
          wakeup(&input.r);
801009f9:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801009fc:	a3 84 17 11 80       	mov    %eax,0x80111784
          wakeup(&input.r);
80100a01:	68 80 17 11 80       	push   $0x80111780
80100a06:	e8 55 3a 00 00       	call   80104460 <wakeup>
80100a0b:	83 c4 10             	add    $0x10,%esp
80100a0e:	e9 0d ff ff ff       	jmp    80100920 <consoleintr+0x20>
80100a13:	90                   	nop
80100a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100a18:	be 01 00 00 00       	mov    $0x1,%esi
80100a1d:	e9 fe fe ff ff       	jmp    80100920 <consoleintr+0x20>
80100a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100a28:	a1 88 17 11 80       	mov    0x80111788,%eax
80100a2d:	39 05 84 17 11 80    	cmp    %eax,0x80111784
80100a33:	75 2b                	jne    80100a60 <consoleintr+0x160>
80100a35:	e9 e6 fe ff ff       	jmp    80100920 <consoleintr+0x20>
80100a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100a40:	a3 88 17 11 80       	mov    %eax,0x80111788
        consputc(BACKSPACE);
80100a45:	b8 00 01 00 00       	mov    $0x100,%eax
80100a4a:	e8 b1 fa ff ff       	call   80100500 <consputc>
      while(input.e != input.w &&
80100a4f:	a1 88 17 11 80       	mov    0x80111788,%eax
80100a54:	3b 05 84 17 11 80    	cmp    0x80111784,%eax
80100a5a:	0f 84 c0 fe ff ff    	je     80100920 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a60:	83 e8 01             	sub    $0x1,%eax
80100a63:	89 c2                	mov    %eax,%edx
80100a65:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a68:	80 ba 00 17 11 80 0a 	cmpb   $0xa,-0x7feee900(%edx)
80100a6f:	75 cf                	jne    80100a40 <consoleintr+0x140>
80100a71:	e9 aa fe ff ff       	jmp    80100920 <consoleintr+0x20>
80100a76:	8d 76 00             	lea    0x0(%esi),%esi
80100a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a83:	5b                   	pop    %ebx
80100a84:	5e                   	pop    %esi
80100a85:	5f                   	pop    %edi
80100a86:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a87:	e9 b4 3a 00 00       	jmp    80104540 <procdump>
80100a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100a90:	c6 80 00 17 11 80 0a 	movb   $0xa,-0x7feee900(%eax)
        consputc(c);
80100a97:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a9c:	e8 5f fa ff ff       	call   80100500 <consputc>
80100aa1:	a1 88 17 11 80       	mov    0x80111788,%eax
80100aa6:	e9 4e ff ff ff       	jmp    801009f9 <consoleintr+0xf9>
80100aab:	90                   	nop
80100aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ab0 <consoleinit>:

void
consoleinit(void)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ab6:	68 89 84 10 80       	push   $0x80108489
80100abb:	68 20 c5 10 80       	push   $0x8010c520
80100ac0:	e8 7b 3f 00 00       	call   80104a40 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
80100ac5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100acc:	c7 05 4c 21 11 80 f0 	movl   $0x801006f0,0x8011214c
80100ad3:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100ad6:	c7 05 48 21 11 80 60 	movl   $0x80100360,0x80112148
80100add:	03 10 80 
  cons.locking = 1;
80100ae0:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
80100ae7:	00 00 00 
  picenable(IRQ_KBD);
80100aea:	e8 91 2b 00 00       	call   80103680 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100aef:	58                   	pop    %eax
80100af0:	5a                   	pop    %edx
80100af1:	6a 00                	push   $0x0
80100af3:	6a 01                	push   $0x1
80100af5:	e8 46 1a 00 00       	call   80102540 <ioapicenable>
}
80100afa:	83 c4 10             	add    $0x10,%esp
80100afd:	c9                   	leave  
80100afe:	c3                   	ret    
80100aff:	90                   	nop

80100b00 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b00:	55                   	push   %ebp
80100b01:	89 e5                	mov    %esp,%ebp
80100b03:	57                   	push   %edi
80100b04:	56                   	push   %esi
80100b05:	53                   	push   %ebx
80100b06:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b0c:	e8 8f 24 00 00       	call   80102fa0 <begin_op>
  if((ip = namei(path)) == 0){
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff 75 08             	pushl  0x8(%ebp)
80100b17:	e8 34 15 00 00       	call   80102050 <namei>
80100b1c:	83 c4 10             	add    $0x10,%esp
80100b1f:	85 c0                	test   %eax,%eax
80100b21:	0f 84 9d 01 00 00    	je     80100cc4 <exec+0x1c4>
    end_op();
    return -1;
  }
  ilock(ip);
80100b27:	83 ec 0c             	sub    $0xc,%esp
80100b2a:	89 c3                	mov    %eax,%ebx
80100b2c:	50                   	push   %eax
80100b2d:	e8 7e 0c 00 00       	call   801017b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b32:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b38:	6a 34                	push   $0x34
80100b3a:	6a 00                	push   $0x0
80100b3c:	50                   	push   %eax
80100b3d:	53                   	push   %ebx
80100b3e:	e8 9d 0f 00 00       	call   80101ae0 <readi>
80100b43:	83 c4 20             	add    $0x20,%esp
80100b46:	83 f8 33             	cmp    $0x33,%eax
80100b49:	77 25                	ja     80100b70 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b4b:	83 ec 0c             	sub    $0xc,%esp
80100b4e:	53                   	push   %ebx
80100b4f:	e8 2c 0f 00 00       	call   80101a80 <iunlockput>
    end_op();
80100b54:	e8 b7 24 00 00       	call   80103010 <end_op>
80100b59:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b64:	5b                   	pop    %ebx
80100b65:	5e                   	pop    %esi
80100b66:	5f                   	pop    %edi
80100b67:	5d                   	pop    %ebp
80100b68:	c3                   	ret    
80100b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b70:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b77:	45 4c 46 
80100b7a:	75 cf                	jne    80100b4b <exec+0x4b>
  if((pgdir = setupkvm()) == 0)
80100b7c:	e8 6f 6c 00 00       	call   801077f0 <setupkvm>
80100b81:	85 c0                	test   %eax,%eax
80100b83:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b89:	74 c0                	je     80100b4b <exec+0x4b>
  sz = 0;
80100b8b:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b94:	00 
80100b95:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100b9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ba1:	0f 84 8f 02 00 00    	je     80100e36 <exec+0x336>
80100ba7:	31 f6                	xor    %esi,%esi
80100ba9:	eb 7f                	jmp    80100c2a <exec+0x12a>
80100bab:	90                   	nop
80100bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100bb0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bb7:	75 63                	jne    80100c1c <exec+0x11c>
    if(ph.memsz < ph.filesz)
80100bb9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bbf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bc5:	0f 82 86 00 00 00    	jb     80100c51 <exec+0x151>
80100bcb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bd1:	72 7e                	jb     80100c51 <exec+0x151>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bd3:	83 ec 04             	sub    $0x4,%esp
80100bd6:	50                   	push   %eax
80100bd7:	57                   	push   %edi
80100bd8:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bde:	e8 9d 6e 00 00       	call   80107a80 <allocuvm>
80100be3:	83 c4 10             	add    $0x10,%esp
80100be6:	85 c0                	test   %eax,%eax
80100be8:	89 c7                	mov    %eax,%edi
80100bea:	74 65                	je     80100c51 <exec+0x151>
    if(ph.vaddr % PGSIZE != 0)
80100bec:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bf2:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bf7:	75 58                	jne    80100c51 <exec+0x151>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bf9:	83 ec 0c             	sub    $0xc,%esp
80100bfc:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100c02:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100c08:	53                   	push   %ebx
80100c09:	50                   	push   %eax
80100c0a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c10:	e8 ab 6d 00 00       	call   801079c0 <loaduvm>
80100c15:	83 c4 20             	add    $0x20,%esp
80100c18:	85 c0                	test   %eax,%eax
80100c1a:	78 35                	js     80100c51 <exec+0x151>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c1c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c23:	83 c6 01             	add    $0x1,%esi
80100c26:	39 f0                	cmp    %esi,%eax
80100c28:	7e 46                	jle    80100c70 <exec+0x170>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c2a:	89 f0                	mov    %esi,%eax
80100c2c:	6a 20                	push   $0x20
80100c2e:	c1 e0 05             	shl    $0x5,%eax
80100c31:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100c37:	50                   	push   %eax
80100c38:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c3e:	50                   	push   %eax
80100c3f:	53                   	push   %ebx
80100c40:	e8 9b 0e 00 00       	call   80101ae0 <readi>
80100c45:	83 c4 10             	add    $0x10,%esp
80100c48:	83 f8 20             	cmp    $0x20,%eax
80100c4b:	0f 84 5f ff ff ff    	je     80100bb0 <exec+0xb0>
    freevm(pgdir);
80100c51:	83 ec 0c             	sub    $0xc,%esp
80100c54:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c5a:	e8 71 6f 00 00       	call   80107bd0 <freevm>
80100c5f:	83 c4 10             	add    $0x10,%esp
80100c62:	e9 e4 fe ff ff       	jmp    80100b4b <exec+0x4b>
80100c67:	89 f6                	mov    %esi,%esi
80100c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80100c70:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c76:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c7c:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c82:	83 ec 0c             	sub    $0xc,%esp
80100c85:	53                   	push   %ebx
80100c86:	e8 f5 0d 00 00       	call   80101a80 <iunlockput>
  end_op();
80100c8b:	e8 80 23 00 00       	call   80103010 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c90:	83 c4 0c             	add    $0xc,%esp
80100c93:	56                   	push   %esi
80100c94:	57                   	push   %edi
80100c95:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c9b:	e8 e0 6d 00 00       	call   80107a80 <allocuvm>
80100ca0:	83 c4 10             	add    $0x10,%esp
80100ca3:	85 c0                	test   %eax,%eax
80100ca5:	89 c6                	mov    %eax,%esi
80100ca7:	75 2a                	jne    80100cd3 <exec+0x1d3>
    freevm(pgdir);
80100ca9:	83 ec 0c             	sub    $0xc,%esp
80100cac:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cb2:	e8 19 6f 00 00       	call   80107bd0 <freevm>
80100cb7:	83 c4 10             	add    $0x10,%esp
  return -1;
80100cba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cbf:	e9 9d fe ff ff       	jmp    80100b61 <exec+0x61>
    end_op();
80100cc4:	e8 47 23 00 00       	call   80103010 <end_op>
    return -1;
80100cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cce:	e9 8e fe ff ff       	jmp    80100b61 <exec+0x61>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd3:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100cd9:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100cdc:	31 ff                	xor    %edi,%edi
80100cde:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ce0:	50                   	push   %eax
80100ce1:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce7:	e8 64 6f 00 00       	call   80107c50 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cec:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cef:	83 c4 10             	add    $0x10,%esp
80100cf2:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100cf8:	8b 00                	mov    (%eax),%eax
80100cfa:	85 c0                	test   %eax,%eax
80100cfc:	74 6f                	je     80100d6d <exec+0x26d>
80100cfe:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100d04:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100d0a:	eb 09                	jmp    80100d15 <exec+0x215>
80100d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100d10:	83 ff 20             	cmp    $0x20,%edi
80100d13:	74 94                	je     80100ca9 <exec+0x1a9>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d15:	83 ec 0c             	sub    $0xc,%esp
80100d18:	50                   	push   %eax
80100d19:	e8 02 44 00 00       	call   80105120 <strlen>
80100d1e:	f7 d0                	not    %eax
80100d20:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d22:	58                   	pop    %eax
80100d23:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d26:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d29:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d2c:	e8 ef 43 00 00       	call   80105120 <strlen>
80100d31:	83 c0 01             	add    $0x1,%eax
80100d34:	50                   	push   %eax
80100d35:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d38:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d3b:	53                   	push   %ebx
80100d3c:	56                   	push   %esi
80100d3d:	e8 5e 70 00 00       	call   80107da0 <copyout>
80100d42:	83 c4 20             	add    $0x20,%esp
80100d45:	85 c0                	test   %eax,%eax
80100d47:	0f 88 5c ff ff ff    	js     80100ca9 <exec+0x1a9>
  for(argc = 0; argv[argc]; argc++) {
80100d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100d50:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100d57:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100d5a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100d60:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d63:	85 c0                	test   %eax,%eax
80100d65:	75 a9                	jne    80100d10 <exec+0x210>
80100d67:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d6d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d74:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d76:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d7d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100d81:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d88:	ff ff ff 
  ustack[1] = argc;
80100d8b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d91:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d93:	83 c0 0c             	add    $0xc,%eax
80100d96:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d98:	50                   	push   %eax
80100d99:	52                   	push   %edx
80100d9a:	53                   	push   %ebx
80100d9b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100da1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100da7:	e8 f4 6f 00 00       	call   80107da0 <copyout>
80100dac:	83 c4 10             	add    $0x10,%esp
80100daf:	85 c0                	test   %eax,%eax
80100db1:	0f 88 f2 fe ff ff    	js     80100ca9 <exec+0x1a9>
  for(last=s=path; *s; s++)
80100db7:	8b 45 08             	mov    0x8(%ebp),%eax
80100dba:	8b 55 08             	mov    0x8(%ebp),%edx
80100dbd:	0f b6 00             	movzbl (%eax),%eax
80100dc0:	84 c0                	test   %al,%al
80100dc2:	74 11                	je     80100dd5 <exec+0x2d5>
80100dc4:	89 d1                	mov    %edx,%ecx
80100dc6:	83 c1 01             	add    $0x1,%ecx
80100dc9:	3c 2f                	cmp    $0x2f,%al
80100dcb:	0f b6 01             	movzbl (%ecx),%eax
80100dce:	0f 44 d1             	cmove  %ecx,%edx
80100dd1:	84 c0                	test   %al,%al
80100dd3:	75 f1                	jne    80100dc6 <exec+0x2c6>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100dd5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ddb:	83 ec 04             	sub    $0x4,%esp
80100dde:	6a 10                	push   $0x10
80100de0:	52                   	push   %edx
80100de1:	83 c0 6c             	add    $0x6c,%eax
80100de4:	50                   	push   %eax
80100de5:	e8 f6 42 00 00       	call   801050e0 <safestrcpy>
  oldpgdir = proc->pgdir;
80100dea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100df0:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
  oldpgdir = proc->pgdir;
80100df6:	8b 78 04             	mov    0x4(%eax),%edi
  proc->sz = sz;
80100df9:	89 30                	mov    %esi,(%eax)
  proc->pgdir = pgdir;
80100dfb:	89 50 04             	mov    %edx,0x4(%eax)
  proc->swap_start=sz;
80100dfe:	89 b0 8c 00 00 00    	mov    %esi,0x8c(%eax)
  proc->tf->eip = elf.entry;  // main
80100e04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e0a:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100e10:	8b 50 18             	mov    0x18(%eax),%edx
80100e13:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100e16:	8b 50 18             	mov    0x18(%eax),%edx
80100e19:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100e1c:	89 04 24             	mov    %eax,(%esp)
80100e1f:	e8 7c 6a 00 00       	call   801078a0 <switchuvm>
  freevm(oldpgdir);
80100e24:	89 3c 24             	mov    %edi,(%esp)
80100e27:	e8 a4 6d 00 00       	call   80107bd0 <freevm>
  return 0;
80100e2c:	83 c4 10             	add    $0x10,%esp
80100e2f:	31 c0                	xor    %eax,%eax
80100e31:	e9 2b fd ff ff       	jmp    80100b61 <exec+0x61>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e36:	be 00 20 00 00       	mov    $0x2000,%esi
80100e3b:	e9 42 fe ff ff       	jmp    80100c82 <exec+0x182>

80100e40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e46:	68 a5 84 10 80       	push   $0x801084a5
80100e4b:	68 a0 17 11 80       	push   $0x801117a0
80100e50:	e8 eb 3b 00 00       	call   80104a40 <initlock>
}
80100e55:	83 c4 10             	add    $0x10,%esp
80100e58:	c9                   	leave  
80100e59:	c3                   	ret    
80100e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e64:	bb d4 17 11 80       	mov    $0x801117d4,%ebx
{
80100e69:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e6c:	68 a0 17 11 80       	push   $0x801117a0
80100e71:	e8 ea 3b 00 00       	call   80104a60 <acquire>
80100e76:	83 c4 10             	add    $0x10,%esp
80100e79:	eb 10                	jmp    80100e8b <filealloc+0x2b>
80100e7b:	90                   	nop
80100e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e80:	83 c3 18             	add    $0x18,%ebx
80100e83:	81 fb 34 21 11 80    	cmp    $0x80112134,%ebx
80100e89:	73 25                	jae    80100eb0 <filealloc+0x50>
    if(f->ref == 0){
80100e8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	75 ee                	jne    80100e80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e92:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e95:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e9c:	68 a0 17 11 80       	push   $0x801117a0
80100ea1:	e8 7a 3d 00 00       	call   80104c20 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ea6:	89 d8                	mov    %ebx,%eax
      return f;
80100ea8:	83 c4 10             	add    $0x10,%esp
}
80100eab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eae:	c9                   	leave  
80100eaf:	c3                   	ret    
  release(&ftable.lock);
80100eb0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100eb3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100eb5:	68 a0 17 11 80       	push   $0x801117a0
80100eba:	e8 61 3d 00 00       	call   80104c20 <release>
}
80100ebf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ec1:	83 c4 10             	add    $0x10,%esp
}
80100ec4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ec7:	c9                   	leave  
80100ec8:	c3                   	ret    
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ed0:	55                   	push   %ebp
80100ed1:	89 e5                	mov    %esp,%ebp
80100ed3:	53                   	push   %ebx
80100ed4:	83 ec 10             	sub    $0x10,%esp
80100ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eda:	68 a0 17 11 80       	push   $0x801117a0
80100edf:	e8 7c 3b 00 00       	call   80104a60 <acquire>
  if(f->ref < 1)
80100ee4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ee7:	83 c4 10             	add    $0x10,%esp
80100eea:	85 c0                	test   %eax,%eax
80100eec:	7e 1a                	jle    80100f08 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100eee:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ef1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ef4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ef7:	68 a0 17 11 80       	push   $0x801117a0
80100efc:	e8 1f 3d 00 00       	call   80104c20 <release>
  return f;
}
80100f01:	89 d8                	mov    %ebx,%eax
80100f03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f06:	c9                   	leave  
80100f07:	c3                   	ret    
    panic("filedup");
80100f08:	83 ec 0c             	sub    $0xc,%esp
80100f0b:	68 ac 84 10 80       	push   $0x801084ac
80100f10:	e8 6b f5 ff ff       	call   80100480 <panic>
80100f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f20 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	57                   	push   %edi
80100f24:	56                   	push   %esi
80100f25:	53                   	push   %ebx
80100f26:	83 ec 28             	sub    $0x28,%esp
80100f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f2c:	68 a0 17 11 80       	push   $0x801117a0
80100f31:	e8 2a 3b 00 00       	call   80104a60 <acquire>
  if(f->ref < 1)
80100f36:	8b 43 04             	mov    0x4(%ebx),%eax
80100f39:	83 c4 10             	add    $0x10,%esp
80100f3c:	85 c0                	test   %eax,%eax
80100f3e:	0f 8e 9b 00 00 00    	jle    80100fdf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f44:	83 e8 01             	sub    $0x1,%eax
80100f47:	85 c0                	test   %eax,%eax
80100f49:	89 43 04             	mov    %eax,0x4(%ebx)
80100f4c:	74 1a                	je     80100f68 <fileclose+0x48>
    release(&ftable.lock);
80100f4e:	c7 45 08 a0 17 11 80 	movl   $0x801117a0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f58:	5b                   	pop    %ebx
80100f59:	5e                   	pop    %esi
80100f5a:	5f                   	pop    %edi
80100f5b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f5c:	e9 bf 3c 00 00       	jmp    80104c20 <release>
80100f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f68:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f6c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100f6e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f71:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f74:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f7a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f7d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f80:	68 a0 17 11 80       	push   $0x801117a0
  ff = *f;
80100f85:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f88:	e8 93 3c 00 00       	call   80104c20 <release>
  if(ff.type == FD_PIPE)
80100f8d:	83 c4 10             	add    $0x10,%esp
80100f90:	83 ff 01             	cmp    $0x1,%edi
80100f93:	74 13                	je     80100fa8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f95:	83 ff 02             	cmp    $0x2,%edi
80100f98:	74 26                	je     80100fc0 <fileclose+0xa0>
}
80100f9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9d:	5b                   	pop    %ebx
80100f9e:	5e                   	pop    %esi
80100f9f:	5f                   	pop    %edi
80100fa0:	5d                   	pop    %ebp
80100fa1:	c3                   	ret    
80100fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100fa8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fac:	83 ec 08             	sub    $0x8,%esp
80100faf:	53                   	push   %ebx
80100fb0:	56                   	push   %esi
80100fb1:	e8 aa 28 00 00       	call   80103860 <pipeclose>
80100fb6:	83 c4 10             	add    $0x10,%esp
80100fb9:	eb df                	jmp    80100f9a <fileclose+0x7a>
80100fbb:	90                   	nop
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100fc0:	e8 db 1f 00 00       	call   80102fa0 <begin_op>
    iput(ff.ip);
80100fc5:	83 ec 0c             	sub    $0xc,%esp
80100fc8:	ff 75 e0             	pushl  -0x20(%ebp)
80100fcb:	e8 50 09 00 00       	call   80101920 <iput>
    end_op();
80100fd0:	83 c4 10             	add    $0x10,%esp
}
80100fd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd6:	5b                   	pop    %ebx
80100fd7:	5e                   	pop    %esi
80100fd8:	5f                   	pop    %edi
80100fd9:	5d                   	pop    %ebp
    end_op();
80100fda:	e9 31 20 00 00       	jmp    80103010 <end_op>
    panic("fileclose");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 b4 84 10 80       	push   $0x801084b4
80100fe7:	e8 94 f4 ff ff       	call   80100480 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	pushl  0x10(%ebx)
80101005:	e8 a6 07 00 00       	call   801017b0 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	pushl  0xc(%ebp)
8010100f:	ff 73 10             	pushl  0x10(%ebx)
80101012:	e8 89 0a 00 00       	call   80101aa0 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	pushl  0x10(%ebx)
8010101b:	e8 a0 08 00 00       	call   801018c0 <iunlock>
    return 0;
80101020:	83 c4 10             	add    $0x10,%esp
80101023:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101035:	eb ee                	jmp    80101025 <filestat+0x35>
80101037:	89 f6                	mov    %esi,%esi
80101039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	0f 84 a4 00 00 00    	je     80101100 <fileread+0xc0>
    return -1;
  if(f->type == FD_PIPE)
8010105c:	8b 03                	mov    (%ebx),%eax
8010105e:	83 f8 01             	cmp    $0x1,%eax
80101061:	74 5d                	je     801010c0 <fileread+0x80>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101063:	83 f8 02             	cmp    $0x2,%eax
80101066:	0f 85 9b 00 00 00    	jne    80101107 <fileread+0xc7>
    ilock(f->ip);
8010106c:	83 ec 0c             	sub    $0xc,%esp
8010106f:	ff 73 10             	pushl  0x10(%ebx)
80101072:	e8 39 07 00 00       	call   801017b0 <ilock>
    //ljn 读文件的时候检查权限
    if((f->ip->mode&1)==0 && f->ip->mode !=111){
80101077:	8b 43 10             	mov    0x10(%ebx),%eax
8010107a:	83 c4 10             	add    $0x10,%esp
8010107d:	0f b6 50 11          	movzbl 0x11(%eax),%edx
80101081:	80 fa 6f             	cmp    $0x6f,%dl
80101084:	74 05                	je     8010108b <fileread+0x4b>
80101086:	83 e2 01             	and    $0x1,%edx
80101089:	74 4d                	je     801010d8 <fileread+0x98>
      iunlock(f->ip);
      cprintf("error! Please try to change the file's mode!\n");
      return -1;
    }
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010108b:	57                   	push   %edi
8010108c:	ff 73 14             	pushl  0x14(%ebx)
8010108f:	56                   	push   %esi
80101090:	50                   	push   %eax
80101091:	e8 4a 0a 00 00       	call   80101ae0 <readi>
80101096:	83 c4 10             	add    $0x10,%esp
80101099:	85 c0                	test   %eax,%eax
8010109b:	89 c6                	mov    %eax,%esi
8010109d:	7e 03                	jle    801010a2 <fileread+0x62>
      f->off += r;
8010109f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010a2:	83 ec 0c             	sub    $0xc,%esp
801010a5:	ff 73 10             	pushl  0x10(%ebx)
801010a8:	e8 13 08 00 00       	call   801018c0 <iunlock>
    return r;
801010ad:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b3:	89 f0                	mov    %esi,%eax
801010b5:	5b                   	pop    %ebx
801010b6:	5e                   	pop    %esi
801010b7:	5f                   	pop    %edi
801010b8:	5d                   	pop    %ebp
801010b9:	c3                   	ret    
801010ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return piperead(f->pipe, addr, n);
801010c0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010c3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	5b                   	pop    %ebx
801010ca:	5e                   	pop    %esi
801010cb:	5f                   	pop    %edi
801010cc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010cd:	e9 5e 29 00 00       	jmp    80103a30 <piperead>
801010d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      iunlock(f->ip);
801010d8:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801010db:	be ff ff ff ff       	mov    $0xffffffff,%esi
      iunlock(f->ip);
801010e0:	50                   	push   %eax
801010e1:	e8 da 07 00 00       	call   801018c0 <iunlock>
      cprintf("error! Please try to change the file's mode!\n");
801010e6:	c7 04 24 d8 84 10 80 	movl   $0x801084d8,(%esp)
801010ed:	e8 5e f6 ff ff       	call   80100750 <cprintf>
      return -1;
801010f2:	83 c4 10             	add    $0x10,%esp
801010f5:	eb b9                	jmp    801010b0 <fileread+0x70>
801010f7:	89 f6                	mov    %esi,%esi
801010f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80101100:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101105:	eb a9                	jmp    801010b0 <fileread+0x70>
  panic("fileread");
80101107:	83 ec 0c             	sub    $0xc,%esp
8010110a:	68 be 84 10 80       	push   $0x801084be
8010110f:	e8 6c f3 ff ff       	call   80100480 <panic>
80101114:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010111a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101120 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 1c             	sub    $0x1c,%esp
80101129:	8b 75 08             	mov    0x8(%ebp),%esi
8010112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010112f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101133:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101136:	8b 45 10             	mov    0x10(%ebp),%eax
80101139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010113c:	0f 84 bd 00 00 00    	je     801011ff <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101142:	8b 06                	mov    (%esi),%eax
80101144:	83 f8 01             	cmp    $0x1,%eax
80101147:	0f 84 f3 00 00 00    	je     80101240 <filewrite+0x120>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010114d:	83 f8 02             	cmp    $0x2,%eax
80101150:	0f 85 09 01 00 00    	jne    8010125f <filewrite+0x13f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101159:	31 ff                	xor    %edi,%edi
    while(i < n){
8010115b:	85 c0                	test   %eax,%eax
8010115d:	7f 34                	jg     80101193 <filewrite+0x73>
8010115f:	e9 ac 00 00 00       	jmp    80101210 <filewrite+0xf0>
80101164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        end_op();
        cprintf("error! Please try to change the file's mode!\n");
        return -1;  
      }
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101168:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010116b:	83 ec 0c             	sub    $0xc,%esp
8010116e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101171:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101174:	e8 47 07 00 00       	call   801018c0 <iunlock>
      end_op();
80101179:	e8 92 1e 00 00       	call   80103010 <end_op>
8010117e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101181:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101184:	39 d8                	cmp    %ebx,%eax
80101186:	0f 85 c6 00 00 00    	jne    80101252 <filewrite+0x132>
        panic("short filewrite");
      i += r;
8010118c:	01 c7                	add    %eax,%edi
    while(i < n){
8010118e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101191:	7e 7d                	jle    80101210 <filewrite+0xf0>
      int n1 = n - i;
80101193:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101196:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010119b:	29 fb                	sub    %edi,%ebx
8010119d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
801011a3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801011a6:	e8 f5 1d 00 00       	call   80102fa0 <begin_op>
      ilock(f->ip);
801011ab:	83 ec 0c             	sub    $0xc,%esp
801011ae:	ff 76 10             	pushl  0x10(%esi)
801011b1:	e8 fa 05 00 00       	call   801017b0 <ilock>
      if((f->ip->mode&2)==0 && f->ip->mode!=111){
801011b6:	8b 46 10             	mov    0x10(%esi),%eax
801011b9:	83 c4 10             	add    $0x10,%esp
801011bc:	0f b6 50 11          	movzbl 0x11(%eax),%edx
801011c0:	f6 c2 02             	test   $0x2,%dl
801011c3:	75 05                	jne    801011ca <filewrite+0xaa>
801011c5:	80 fa 6f             	cmp    $0x6f,%dl
801011c8:	75 56                	jne    80101220 <filewrite+0x100>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801011cd:	53                   	push   %ebx
801011ce:	ff 76 14             	pushl  0x14(%esi)
801011d1:	8d 14 39             	lea    (%ecx,%edi,1),%edx
801011d4:	52                   	push   %edx
801011d5:	50                   	push   %eax
801011d6:	e8 f5 09 00 00       	call   80101bd0 <writei>
801011db:	83 c4 10             	add    $0x10,%esp
801011de:	85 c0                	test   %eax,%eax
801011e0:	7f 86                	jg     80101168 <filewrite+0x48>
      iunlock(f->ip);
801011e2:	83 ec 0c             	sub    $0xc,%esp
801011e5:	ff 76 10             	pushl  0x10(%esi)
801011e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011eb:	e8 d0 06 00 00       	call   801018c0 <iunlock>
      end_op();
801011f0:	e8 1b 1e 00 00       	call   80103010 <end_op>
      if(r < 0)
801011f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011f8:	83 c4 10             	add    $0x10,%esp
801011fb:	85 c0                	test   %eax,%eax
801011fd:	74 85                	je     80101184 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801011ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;  
80101202:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101207:	5b                   	pop    %ebx
80101208:	5e                   	pop    %esi
80101209:	5f                   	pop    %edi
8010120a:	5d                   	pop    %ebp
8010120b:	c3                   	ret    
8010120c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101210:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101213:	75 ea                	jne    801011ff <filewrite+0xdf>
}
80101215:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101218:	89 f8                	mov    %edi,%eax
8010121a:	5b                   	pop    %ebx
8010121b:	5e                   	pop    %esi
8010121c:	5f                   	pop    %edi
8010121d:	5d                   	pop    %ebp
8010121e:	c3                   	ret    
8010121f:	90                   	nop
        iunlock(f->ip);
80101220:	83 ec 0c             	sub    $0xc,%esp
80101223:	50                   	push   %eax
80101224:	e8 97 06 00 00       	call   801018c0 <iunlock>
        end_op();
80101229:	e8 e2 1d 00 00       	call   80103010 <end_op>
        cprintf("error! Please try to change the file's mode!\n");
8010122e:	c7 04 24 d8 84 10 80 	movl   $0x801084d8,(%esp)
80101235:	e8 16 f5 ff ff       	call   80100750 <cprintf>
        return -1;  
8010123a:	83 c4 10             	add    $0x10,%esp
8010123d:	eb c0                	jmp    801011ff <filewrite+0xdf>
8010123f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101240:	8b 46 0c             	mov    0xc(%esi),%eax
80101243:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101246:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101249:	5b                   	pop    %ebx
8010124a:	5e                   	pop    %esi
8010124b:	5f                   	pop    %edi
8010124c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010124d:	e9 ae 26 00 00       	jmp    80103900 <pipewrite>
        panic("short filewrite");
80101252:	83 ec 0c             	sub    $0xc,%esp
80101255:	68 c7 84 10 80       	push   $0x801084c7
8010125a:	e8 21 f2 ff ff       	call   80100480 <panic>
  panic("filewrite");
8010125f:	83 ec 0c             	sub    $0xc,%esp
80101262:	68 cd 84 10 80       	push   $0x801084cd
80101267:	e8 14 f2 ff ff       	call   80100480 <panic>
8010126c:	66 90                	xchg   %ax,%ax
8010126e:	66 90                	xchg   %ax,%ax

80101270 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101270:	55                   	push   %ebp
80101271:	89 e5                	mov    %esp,%ebp
80101273:	57                   	push   %edi
80101274:	56                   	push   %esi
80101275:	53                   	push   %ebx
80101276:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101279:	8b 0d a0 21 11 80    	mov    0x801121a0,%ecx
{
8010127f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101282:	85 c9                	test   %ecx,%ecx
80101284:	0f 84 87 00 00 00    	je     80101311 <balloc+0xa1>
8010128a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101291:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101294:	83 ec 08             	sub    $0x8,%esp
80101297:	89 f0                	mov    %esi,%eax
80101299:	c1 f8 0c             	sar    $0xc,%eax
8010129c:	03 05 b8 21 11 80    	add    0x801121b8,%eax
801012a2:	50                   	push   %eax
801012a3:	ff 75 d8             	pushl  -0x28(%ebp)
801012a6:	e8 e5 ee ff ff       	call   80100190 <bread>
801012ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012ae:	a1 a0 21 11 80       	mov    0x801121a0,%eax
801012b3:	83 c4 10             	add    $0x10,%esp
801012b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012b9:	31 c0                	xor    %eax,%eax
801012bb:	eb 2f                	jmp    801012ec <balloc+0x7c>
801012bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012c0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012c5:	bb 01 00 00 00       	mov    $0x1,%ebx
801012ca:	83 e1 07             	and    $0x7,%ecx
801012cd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012cf:	89 c1                	mov    %eax,%ecx
801012d1:	c1 f9 03             	sar    $0x3,%ecx
801012d4:	0f b6 7c 0a 18       	movzbl 0x18(%edx,%ecx,1),%edi
801012d9:	85 df                	test   %ebx,%edi
801012db:	89 fa                	mov    %edi,%edx
801012dd:	74 41                	je     80101320 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012df:	83 c0 01             	add    $0x1,%eax
801012e2:	83 c6 01             	add    $0x1,%esi
801012e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ea:	74 05                	je     801012f1 <balloc+0x81>
801012ec:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012ef:	77 cf                	ja     801012c0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012f7:	e8 04 ef ff ff       	call   80100200 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012fc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101303:	83 c4 10             	add    $0x10,%esp
80101306:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101309:	39 05 a0 21 11 80    	cmp    %eax,0x801121a0
8010130f:	77 80                	ja     80101291 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101311:	83 ec 0c             	sub    $0xc,%esp
80101314:	68 06 85 10 80       	push   $0x80108506
80101319:	e8 62 f1 ff ff       	call   80100480 <panic>
8010131e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101320:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101323:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101326:	09 da                	or     %ebx,%edx
80101328:	88 54 0f 18          	mov    %dl,0x18(%edi,%ecx,1)
        log_write(bp);
8010132c:	57                   	push   %edi
8010132d:	e8 3e 1e 00 00       	call   80103170 <log_write>
        brelse(bp);
80101332:	89 3c 24             	mov    %edi,(%esp)
80101335:	e8 c6 ee ff ff       	call   80100200 <brelse>
  bp = bread(dev, bno);
8010133a:	58                   	pop    %eax
8010133b:	5a                   	pop    %edx
8010133c:	56                   	push   %esi
8010133d:	ff 75 d8             	pushl  -0x28(%ebp)
80101340:	e8 4b ee ff ff       	call   80100190 <bread>
80101345:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101347:	8d 40 18             	lea    0x18(%eax),%eax
8010134a:	83 c4 0c             	add    $0xc,%esp
8010134d:	68 00 02 00 00       	push   $0x200
80101352:	6a 00                	push   $0x0
80101354:	50                   	push   %eax
80101355:	e8 a6 3b 00 00       	call   80104f00 <memset>
  log_write(bp);
8010135a:	89 1c 24             	mov    %ebx,(%esp)
8010135d:	e8 0e 1e 00 00       	call   80103170 <log_write>
  brelse(bp);
80101362:	89 1c 24             	mov    %ebx,(%esp)
80101365:	e8 96 ee ff ff       	call   80100200 <brelse>
}
8010136a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010136d:	89 f0                	mov    %esi,%eax
8010136f:	5b                   	pop    %ebx
80101370:	5e                   	pop    %esi
80101371:	5f                   	pop    %edi
80101372:	5d                   	pop    %ebp
80101373:	c3                   	ret    
80101374:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010137a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101380 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	57                   	push   %edi
80101384:	56                   	push   %esi
80101385:	53                   	push   %ebx
80101386:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101388:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138a:	bb f4 21 11 80       	mov    $0x801121f4,%ebx
{
8010138f:	83 ec 28             	sub    $0x28,%esp
80101392:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101395:	68 c0 21 11 80       	push   $0x801121c0
8010139a:	e8 c1 36 00 00       	call   80104a60 <acquire>
8010139f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013a5:	eb 14                	jmp    801013bb <iget+0x3b>
801013a7:	89 f6                	mov    %esi,%esi
801013a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801013b0:	83 c3 50             	add    $0x50,%ebx
801013b3:	81 fb 94 31 11 80    	cmp    $0x80113194,%ebx
801013b9:	73 1f                	jae    801013da <iget+0x5a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013bb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013be:	85 c9                	test   %ecx,%ecx
801013c0:	7e 04                	jle    801013c6 <iget+0x46>
801013c2:	39 3b                	cmp    %edi,(%ebx)
801013c4:	74 4a                	je     80101410 <iget+0x90>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013c6:	85 f6                	test   %esi,%esi
801013c8:	75 e6                	jne    801013b0 <iget+0x30>
801013ca:	85 c9                	test   %ecx,%ecx
801013cc:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013cf:	83 c3 50             	add    $0x50,%ebx
801013d2:	81 fb 94 31 11 80    	cmp    $0x80113194,%ebx
801013d8:	72 e1                	jb     801013bb <iget+0x3b>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013da:	85 f6                	test   %esi,%esi
801013dc:	74 59                	je     80101437 <iget+0xb7>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
801013de:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013e1:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013e3:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013e6:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801013ed:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  release(&icache.lock);
801013f4:	68 c0 21 11 80       	push   $0x801121c0
801013f9:	e8 22 38 00 00       	call   80104c20 <release>

  return ip;
801013fe:	83 c4 10             	add    $0x10,%esp
}
80101401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101404:	89 f0                	mov    %esi,%eax
80101406:	5b                   	pop    %ebx
80101407:	5e                   	pop    %esi
80101408:	5f                   	pop    %edi
80101409:	5d                   	pop    %ebp
8010140a:	c3                   	ret    
8010140b:	90                   	nop
8010140c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101410:	39 53 04             	cmp    %edx,0x4(%ebx)
80101413:	75 b1                	jne    801013c6 <iget+0x46>
      release(&icache.lock);
80101415:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101418:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010141b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010141d:	68 c0 21 11 80       	push   $0x801121c0
      ip->ref++;
80101422:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101425:	e8 f6 37 00 00       	call   80104c20 <release>
      return ip;
8010142a:	83 c4 10             	add    $0x10,%esp
}
8010142d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101430:	89 f0                	mov    %esi,%eax
80101432:	5b                   	pop    %ebx
80101433:	5e                   	pop    %esi
80101434:	5f                   	pop    %edi
80101435:	5d                   	pop    %ebp
80101436:	c3                   	ret    
    panic("iget: no inodes");
80101437:	83 ec 0c             	sub    $0xc,%esp
8010143a:	68 1c 85 10 80       	push   $0x8010851c
8010143f:	e8 3c f0 ff ff       	call   80100480 <panic>
80101444:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010144a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	53                   	push   %ebx
80101456:	89 c6                	mov    %eax,%esi
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	77 18                	ja     80101478 <bmap+0x28>
80101460:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101463:	8b 5f 1c             	mov    0x1c(%edi),%ebx
80101466:	85 db                	test   %ebx,%ebx
80101468:	74 6e                	je     801014d8 <bmap+0x88>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010146a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010146d:	89 d8                	mov    %ebx,%eax
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5f                   	pop    %edi
80101472:	5d                   	pop    %ebp
80101473:	c3                   	ret    
80101474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101478:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010147b:	83 fb 7f             	cmp    $0x7f,%ebx
8010147e:	77 7e                	ja     801014fe <bmap+0xae>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101480:	8b 50 4c             	mov    0x4c(%eax),%edx
80101483:	8b 00                	mov    (%eax),%eax
80101485:	85 d2                	test   %edx,%edx
80101487:	74 67                	je     801014f0 <bmap+0xa0>
    bp = bread(ip->dev, addr);
80101489:	83 ec 08             	sub    $0x8,%esp
8010148c:	52                   	push   %edx
8010148d:	50                   	push   %eax
8010148e:	e8 fd ec ff ff       	call   80100190 <bread>
    if((addr = a[bn]) == 0){
80101493:	8d 54 98 18          	lea    0x18(%eax,%ebx,4),%edx
80101497:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
8010149a:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010149c:	8b 1a                	mov    (%edx),%ebx
8010149e:	85 db                	test   %ebx,%ebx
801014a0:	75 1d                	jne    801014bf <bmap+0x6f>
      a[bn] = addr = balloc(ip->dev);
801014a2:	8b 06                	mov    (%esi),%eax
801014a4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014a7:	e8 c4 fd ff ff       	call   80101270 <balloc>
801014ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014af:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014b2:	89 c3                	mov    %eax,%ebx
801014b4:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014b6:	57                   	push   %edi
801014b7:	e8 b4 1c 00 00       	call   80103170 <log_write>
801014bc:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801014bf:	83 ec 0c             	sub    $0xc,%esp
801014c2:	57                   	push   %edi
801014c3:	e8 38 ed ff ff       	call   80100200 <brelse>
801014c8:	83 c4 10             	add    $0x10,%esp
}
801014cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014ce:	89 d8                	mov    %ebx,%eax
801014d0:	5b                   	pop    %ebx
801014d1:	5e                   	pop    %esi
801014d2:	5f                   	pop    %edi
801014d3:	5d                   	pop    %ebp
801014d4:	c3                   	ret    
801014d5:	8d 76 00             	lea    0x0(%esi),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d8:	8b 00                	mov    (%eax),%eax
801014da:	e8 91 fd ff ff       	call   80101270 <balloc>
801014df:	89 47 1c             	mov    %eax,0x1c(%edi)
}
801014e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801014e5:	89 c3                	mov    %eax,%ebx
}
801014e7:	89 d8                	mov    %ebx,%eax
801014e9:	5b                   	pop    %ebx
801014ea:	5e                   	pop    %esi
801014eb:	5f                   	pop    %edi
801014ec:	5d                   	pop    %ebp
801014ed:	c3                   	ret    
801014ee:	66 90                	xchg   %ax,%ax
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f0:	e8 7b fd ff ff       	call   80101270 <balloc>
801014f5:	89 c2                	mov    %eax,%edx
801014f7:	89 46 4c             	mov    %eax,0x4c(%esi)
801014fa:	8b 06                	mov    (%esi),%eax
801014fc:	eb 8b                	jmp    80101489 <bmap+0x39>
  panic("bmap: out of range");
801014fe:	83 ec 0c             	sub    $0xc,%esp
80101501:	68 2c 85 10 80       	push   $0x8010852c
80101506:	e8 75 ef ff ff       	call   80100480 <panic>
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <readsb>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	56                   	push   %esi
80101514:	53                   	push   %ebx
80101515:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101518:	83 ec 08             	sub    $0x8,%esp
8010151b:	6a 01                	push   $0x1
8010151d:	ff 75 08             	pushl  0x8(%ebp)
80101520:	e8 6b ec ff ff       	call   80100190 <bread>
80101525:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101527:	8d 40 18             	lea    0x18(%eax),%eax
8010152a:	83 c4 0c             	add    $0xc,%esp
8010152d:	6a 1c                	push   $0x1c
8010152f:	50                   	push   %eax
80101530:	56                   	push   %esi
80101531:	e8 7a 3a 00 00       	call   80104fb0 <memmove>
  brelse(bp);
80101536:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101539:	83 c4 10             	add    $0x10,%esp
}
8010153c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010153f:	5b                   	pop    %ebx
80101540:	5e                   	pop    %esi
80101541:	5d                   	pop    %ebp
  brelse(bp);
80101542:	e9 b9 ec ff ff       	jmp    80100200 <brelse>
80101547:	89 f6                	mov    %esi,%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101550 <bfree>:
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	56                   	push   %esi
80101554:	53                   	push   %ebx
80101555:	89 d3                	mov    %edx,%ebx
80101557:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	68 a0 21 11 80       	push   $0x801121a0
80101561:	50                   	push   %eax
80101562:	e8 a9 ff ff ff       	call   80101510 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101567:	58                   	pop    %eax
80101568:	5a                   	pop    %edx
80101569:	89 da                	mov    %ebx,%edx
8010156b:	c1 ea 0c             	shr    $0xc,%edx
8010156e:	03 15 b8 21 11 80    	add    0x801121b8,%edx
80101574:	52                   	push   %edx
80101575:	56                   	push   %esi
80101576:	e8 15 ec ff ff       	call   80100190 <bread>
  m = 1 << (bi % 8);
8010157b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010157d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101580:	ba 01 00 00 00       	mov    $0x1,%edx
80101585:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101588:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010158e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101591:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101593:	0f b6 4c 18 18       	movzbl 0x18(%eax,%ebx,1),%ecx
80101598:	85 d1                	test   %edx,%ecx
8010159a:	74 25                	je     801015c1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010159c:	f7 d2                	not    %edx
8010159e:	89 c6                	mov    %eax,%esi
  log_write(bp);
801015a0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801015a3:	21 ca                	and    %ecx,%edx
801015a5:	88 54 1e 18          	mov    %dl,0x18(%esi,%ebx,1)
  log_write(bp);
801015a9:	56                   	push   %esi
801015aa:	e8 c1 1b 00 00       	call   80103170 <log_write>
  brelse(bp);
801015af:	89 34 24             	mov    %esi,(%esp)
801015b2:	e8 49 ec ff ff       	call   80100200 <brelse>
}
801015b7:	83 c4 10             	add    $0x10,%esp
801015ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015bd:	5b                   	pop    %ebx
801015be:	5e                   	pop    %esi
801015bf:	5d                   	pop    %ebp
801015c0:	c3                   	ret    
    panic("freeing free block");
801015c1:	83 ec 0c             	sub    $0xc,%esp
801015c4:	68 3f 85 10 80       	push   $0x8010853f
801015c9:	e8 b2 ee ff ff       	call   80100480 <panic>
801015ce:	66 90                	xchg   %ax,%ax

801015d0 <iinit>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&icache.lock, "icache");
801015d6:	68 52 85 10 80       	push   $0x80108552
801015db:	68 c0 21 11 80       	push   $0x801121c0
801015e0:	e8 5b 34 00 00       	call   80104a40 <initlock>
  readsb(dev, &sb);
801015e5:	58                   	pop    %eax
801015e6:	5a                   	pop    %edx
801015e7:	68 a0 21 11 80       	push   $0x801121a0
801015ec:	ff 75 08             	pushl  0x8(%ebp)
801015ef:	e8 1c ff ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015f4:	ff 35 b8 21 11 80    	pushl  0x801121b8
801015fa:	ff 35 b4 21 11 80    	pushl  0x801121b4
80101600:	ff 35 b0 21 11 80    	pushl  0x801121b0
80101606:	ff 35 ac 21 11 80    	pushl  0x801121ac
8010160c:	ff 35 a8 21 11 80    	pushl  0x801121a8
80101612:	ff 35 a4 21 11 80    	pushl  0x801121a4
80101618:	ff 35 a0 21 11 80    	pushl  0x801121a0
8010161e:	68 c8 85 10 80       	push   $0x801085c8
80101623:	e8 28 f1 ff ff       	call   80100750 <cprintf>
}
80101628:	83 c4 30             	add    $0x30,%esp
8010162b:	c9                   	leave  
8010162c:	c3                   	ret    
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101639:	83 3d a8 21 11 80 01 	cmpl   $0x1,0x801121a8
{
80101640:	8b 45 0c             	mov    0xc(%ebp),%eax
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 93 00 00 00    	jbe    801016e2 <ialloc+0xb2>
8010164f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	8d 76 00             	lea    0x0(%esi),%esi
80101659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101666:	57                   	push   %edi
80101667:	e8 94 eb ff ff       	call   80100200 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	39 1d a8 21 11 80    	cmp    %ebx,0x801121a8
80101675:	76 6b                	jbe    801016e2 <ialloc+0xb2>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 d8                	mov    %ebx,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 b4 21 11 80    	add    0x801121b4,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 04 eb ff ff       	call   80100190 <bread>
8010168c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010168e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101690:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 07 18          	lea    0x18(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	80 39 00             	cmpb   $0x0,(%ecx)
801016a0:	75 be                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a2:	83 ec 04             	sub    $0x4,%esp
801016a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016a8:	6a 40                	push   $0x40
801016aa:	6a 00                	push   $0x0
801016ac:	51                   	push   %ecx
801016ad:	e8 4e 38 00 00       	call   80104f00 <memset>
      dip->type = type;
801016b2:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801016b6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      dip->mode=3;
801016b9:	c6 41 01 03          	movb   $0x3,0x1(%ecx)
      dip->type = type;
801016bd:	88 01                	mov    %al,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bf:	89 3c 24             	mov    %edi,(%esp)
801016c2:	e8 a9 1a 00 00       	call   80103170 <log_write>
      brelse(bp);
801016c7:	89 3c 24             	mov    %edi,(%esp)
801016ca:	e8 31 eb ff ff       	call   80100200 <brelse>
      return iget(dev, inum);
801016cf:	83 c4 10             	add    $0x10,%esp
}
801016d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d5:	89 da                	mov    %ebx,%edx
801016d7:	89 f0                	mov    %esi,%eax
}
801016d9:	5b                   	pop    %ebx
801016da:	5e                   	pop    %esi
801016db:	5f                   	pop    %edi
801016dc:	5d                   	pop    %ebp
      return iget(dev, inum);
801016dd:	e9 9e fc ff ff       	jmp    80101380 <iget>
  panic("ialloc: no inodes");
801016e2:	83 ec 0c             	sub    $0xc,%esp
801016e5:	68 59 85 10 80       	push   $0x80108559
801016ea:	e8 91 ed ff ff       	call   80100480 <panic>
801016ef:	90                   	nop

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	83 ec 08             	sub    $0x8,%esp
801016fb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fe:	83 c3 1c             	add    $0x1c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 b4 21 11 80    	add    0x801121b4,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 e4             	pushl  -0x1c(%ebx)
8010170e:	e8 7d ea ff ff       	call   80100190 <bread>
80101713:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101715:	8b 43 e8             	mov    -0x18(%ebx),%eax
  dip->type = ip->type;
80101718:	0f b6 53 f4          	movzbl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010171c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	88 10                	mov    %dl,(%eax)
  dip->mode = ip->mode;
8010172b:	0f b6 53 f5          	movzbl -0xb(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172f:	83 c0 0c             	add    $0xc,%eax
  dip->mode = ip->mode;
80101732:	88 50 f5             	mov    %dl,-0xb(%eax)
  dip->major = ip->major;
80101735:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
80101739:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010173d:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101741:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101745:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101749:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010174d:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101750:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101753:	6a 34                	push   $0x34
80101755:	53                   	push   %ebx
80101756:	50                   	push   %eax
80101757:	e8 54 38 00 00       	call   80104fb0 <memmove>
  log_write(bp);
8010175c:	89 34 24             	mov    %esi,(%esp)
8010175f:	e8 0c 1a 00 00       	call   80103170 <log_write>
  brelse(bp);
80101764:	89 75 08             	mov    %esi,0x8(%ebp)
80101767:	83 c4 10             	add    $0x10,%esp
}
8010176a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010176d:	5b                   	pop    %ebx
8010176e:	5e                   	pop    %esi
8010176f:	5d                   	pop    %ebp
  brelse(bp);
80101770:	e9 8b ea ff ff       	jmp    80100200 <brelse>
80101775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101780 <idup>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	53                   	push   %ebx
80101784:	83 ec 10             	sub    $0x10,%esp
80101787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010178a:	68 c0 21 11 80       	push   $0x801121c0
8010178f:	e8 cc 32 00 00       	call   80104a60 <acquire>
  ip->ref++;
80101794:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101798:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
8010179f:	e8 7c 34 00 00       	call   80104c20 <release>
}
801017a4:	89 d8                	mov    %ebx,%eax
801017a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017a9:	c9                   	leave  
801017aa:	c3                   	ret    
801017ab:	90                   	nop
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017b0 <ilock>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	56                   	push   %esi
801017b4:	53                   	push   %ebx
801017b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017b8:	85 db                	test   %ebx,%ebx
801017ba:	0f 84 f1 00 00 00    	je     801018b1 <ilock+0x101>
801017c0:	8b 43 08             	mov    0x8(%ebx),%eax
801017c3:	85 c0                	test   %eax,%eax
801017c5:	0f 8e e6 00 00 00    	jle    801018b1 <ilock+0x101>
  acquire(&icache.lock);
801017cb:	83 ec 0c             	sub    $0xc,%esp
801017ce:	68 c0 21 11 80       	push   $0x801121c0
801017d3:	e8 88 32 00 00       	call   80104a60 <acquire>
  while(ip->flags & I_BUSY)
801017d8:	8b 43 0c             	mov    0xc(%ebx),%eax
801017db:	83 c4 10             	add    $0x10,%esp
801017de:	a8 01                	test   $0x1,%al
801017e0:	74 1e                	je     80101800 <ilock+0x50>
801017e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sleep(ip, &icache.lock);
801017e8:	83 ec 08             	sub    $0x8,%esp
801017eb:	68 c0 21 11 80       	push   $0x801121c0
801017f0:	53                   	push   %ebx
801017f1:	e8 ba 2a 00 00       	call   801042b0 <sleep>
  while(ip->flags & I_BUSY)
801017f6:	8b 43 0c             	mov    0xc(%ebx),%eax
801017f9:	83 c4 10             	add    $0x10,%esp
801017fc:	a8 01                	test   $0x1,%al
801017fe:	75 e8                	jne    801017e8 <ilock+0x38>
  release(&icache.lock);
80101800:	83 ec 0c             	sub    $0xc,%esp
  ip->flags |= I_BUSY;
80101803:	83 c8 01             	or     $0x1,%eax
80101806:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
80101809:	68 c0 21 11 80       	push   $0x801121c0
8010180e:	e8 0d 34 00 00       	call   80104c20 <release>
  if(!(ip->flags & I_VALID)){
80101813:	83 c4 10             	add    $0x10,%esp
80101816:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
8010181a:	74 0c                	je     80101828 <ilock+0x78>
}
8010181c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010181f:	5b                   	pop    %ebx
80101820:	5e                   	pop    %esi
80101821:	5d                   	pop    %ebp
80101822:	c3                   	ret    
80101823:	90                   	nop
80101824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101828:	8b 43 04             	mov    0x4(%ebx),%eax
8010182b:	83 ec 08             	sub    $0x8,%esp
8010182e:	c1 e8 03             	shr    $0x3,%eax
80101831:	03 05 b4 21 11 80    	add    0x801121b4,%eax
80101837:	50                   	push   %eax
80101838:	ff 33                	pushl  (%ebx)
8010183a:	e8 51 e9 ff ff       	call   80100190 <bread>
8010183f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101841:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101844:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101847:	83 e0 07             	and    $0x7,%eax
8010184a:	c1 e0 06             	shl    $0x6,%eax
8010184d:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
80101851:	0f b6 10             	movzbl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101854:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101857:	88 53 10             	mov    %dl,0x10(%ebx)
    ip->mode = dip->mode;
8010185a:	0f b6 50 f5          	movzbl -0xb(%eax),%edx
8010185e:	88 53 11             	mov    %dl,0x11(%ebx)
    ip->major = dip->major;
80101861:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101865:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
80101869:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010186d:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
80101871:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101875:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
80101879:	8b 50 fc             	mov    -0x4(%eax),%edx
8010187c:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010187f:	6a 34                	push   $0x34
80101881:	50                   	push   %eax
80101882:	8d 43 1c             	lea    0x1c(%ebx),%eax
80101885:	50                   	push   %eax
80101886:	e8 25 37 00 00       	call   80104fb0 <memmove>
    brelse(bp);
8010188b:	89 34 24             	mov    %esi,(%esp)
8010188e:	e8 6d e9 ff ff       	call   80100200 <brelse>
    ip->flags |= I_VALID;
80101893:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
80101897:	83 c4 10             	add    $0x10,%esp
8010189a:	80 7b 10 00          	cmpb   $0x0,0x10(%ebx)
8010189e:	0f 85 78 ff ff ff    	jne    8010181c <ilock+0x6c>
      panic("ilock: no type");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 71 85 10 80       	push   $0x80108571
801018ac:	e8 cf eb ff ff       	call   80100480 <panic>
    panic("ilock");
801018b1:	83 ec 0c             	sub    $0xc,%esp
801018b4:	68 6b 85 10 80       	push   $0x8010856b
801018b9:	e8 c2 eb ff ff       	call   80100480 <panic>
801018be:	66 90                	xchg   %ax,%ax

801018c0 <iunlock>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	53                   	push   %ebx
801018c4:	83 ec 04             	sub    $0x4,%esp
801018c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801018ca:	85 db                	test   %ebx,%ebx
801018cc:	74 39                	je     80101907 <iunlock+0x47>
801018ce:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
801018d2:	74 33                	je     80101907 <iunlock+0x47>
801018d4:	8b 43 08             	mov    0x8(%ebx),%eax
801018d7:	85 c0                	test   %eax,%eax
801018d9:	7e 2c                	jle    80101907 <iunlock+0x47>
  acquire(&icache.lock);
801018db:	83 ec 0c             	sub    $0xc,%esp
801018de:	68 c0 21 11 80       	push   $0x801121c0
801018e3:	e8 78 31 00 00       	call   80104a60 <acquire>
  ip->flags &= ~I_BUSY;
801018e8:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
801018ec:	89 1c 24             	mov    %ebx,(%esp)
801018ef:	e8 6c 2b 00 00       	call   80104460 <wakeup>
  release(&icache.lock);
801018f4:	83 c4 10             	add    $0x10,%esp
801018f7:	c7 45 08 c0 21 11 80 	movl   $0x801121c0,0x8(%ebp)
}
801018fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101901:	c9                   	leave  
  release(&icache.lock);
80101902:	e9 19 33 00 00       	jmp    80104c20 <release>
    panic("iunlock");
80101907:	83 ec 0c             	sub    $0xc,%esp
8010190a:	68 80 85 10 80       	push   $0x80108580
8010190f:	e8 6c eb ff ff       	call   80100480 <panic>
80101914:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010191a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101920 <iput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 28             	sub    $0x28,%esp
80101929:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010192c:	68 c0 21 11 80       	push   $0x801121c0
80101931:	e8 2a 31 00 00       	call   80104a60 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101936:	8b 46 08             	mov    0x8(%esi),%eax
80101939:	83 c4 10             	add    $0x10,%esp
8010193c:	83 f8 01             	cmp    $0x1,%eax
8010193f:	0f 85 a9 00 00 00    	jne    801019ee <iput+0xce>
80101945:	8b 56 0c             	mov    0xc(%esi),%edx
80101948:	f6 c2 02             	test   $0x2,%dl
8010194b:	0f 84 9d 00 00 00    	je     801019ee <iput+0xce>
80101951:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
80101956:	0f 85 92 00 00 00    	jne    801019ee <iput+0xce>
    if(ip->flags & I_BUSY)
8010195c:	f6 c2 01             	test   $0x1,%dl
8010195f:	0f 85 05 01 00 00    	jne    80101a6a <iput+0x14a>
    release(&icache.lock);
80101965:	83 ec 0c             	sub    $0xc,%esp
    ip->flags |= I_BUSY;
80101968:	83 ca 01             	or     $0x1,%edx
8010196b:	8d 5e 1c             	lea    0x1c(%esi),%ebx
8010196e:	89 56 0c             	mov    %edx,0xc(%esi)
    release(&icache.lock);
80101971:	68 c0 21 11 80       	push   $0x801121c0
80101976:	8d 7e 4c             	lea    0x4c(%esi),%edi
80101979:	e8 a2 32 00 00       	call   80104c20 <release>
8010197e:	83 c4 10             	add    $0x10,%esp
80101981:	eb 0c                	jmp    8010198f <iput+0x6f>
80101983:	90                   	nop
80101984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101988:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
8010198b:	39 fb                	cmp    %edi,%ebx
8010198d:	74 1b                	je     801019aa <iput+0x8a>
    if(ip->addrs[i]){
8010198f:	8b 13                	mov    (%ebx),%edx
80101991:	85 d2                	test   %edx,%edx
80101993:	74 f3                	je     80101988 <iput+0x68>
      bfree(ip->dev, ip->addrs[i]);
80101995:	8b 06                	mov    (%esi),%eax
80101997:	83 c3 04             	add    $0x4,%ebx
8010199a:	e8 b1 fb ff ff       	call   80101550 <bfree>
      ip->addrs[i] = 0;
8010199f:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
  for(i = 0; i < NDIRECT; i++){
801019a6:	39 fb                	cmp    %edi,%ebx
801019a8:	75 e5                	jne    8010198f <iput+0x6f>
    }
  }

  if(ip->addrs[NDIRECT]){
801019aa:	8b 46 4c             	mov    0x4c(%esi),%eax
801019ad:	85 c0                	test   %eax,%eax
801019af:	75 5f                	jne    80101a10 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019b1:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019b4:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
801019bb:	56                   	push   %esi
801019bc:	e8 2f fd ff ff       	call   801016f0 <iupdate>
    ip->type = 0;
801019c1:	c6 46 10 00          	movb   $0x0,0x10(%esi)
    iupdate(ip);
801019c5:	89 34 24             	mov    %esi,(%esp)
801019c8:	e8 23 fd ff ff       	call   801016f0 <iupdate>
    acquire(&icache.lock);
801019cd:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
801019d4:	e8 87 30 00 00       	call   80104a60 <acquire>
    ip->flags = 0;
801019d9:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    wakeup(ip);
801019e0:	89 34 24             	mov    %esi,(%esp)
801019e3:	e8 78 2a 00 00       	call   80104460 <wakeup>
801019e8:	8b 46 08             	mov    0x8(%esi),%eax
801019eb:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
801019ee:	83 e8 01             	sub    $0x1,%eax
801019f1:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
801019f4:	c7 45 08 c0 21 11 80 	movl   $0x801121c0,0x8(%ebp)
}
801019fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019fe:	5b                   	pop    %ebx
801019ff:	5e                   	pop    %esi
80101a00:	5f                   	pop    %edi
80101a01:	5d                   	pop    %ebp
  release(&icache.lock);
80101a02:	e9 19 32 00 00       	jmp    80104c20 <release>
80101a07:	89 f6                	mov    %esi,%esi
80101a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a10:	83 ec 08             	sub    $0x8,%esp
80101a13:	50                   	push   %eax
80101a14:	ff 36                	pushl  (%esi)
80101a16:	e8 75 e7 ff ff       	call   80100190 <bread>
80101a1b:	83 c4 10             	add    $0x10,%esp
80101a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101a21:	8d 58 18             	lea    0x18(%eax),%ebx
80101a24:	8d b8 18 02 00 00    	lea    0x218(%eax),%edi
80101a2a:	eb 0b                	jmp    80101a37 <iput+0x117>
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a30:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101a33:	39 df                	cmp    %ebx,%edi
80101a35:	74 0f                	je     80101a46 <iput+0x126>
      if(a[j])
80101a37:	8b 13                	mov    (%ebx),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a3d:	8b 06                	mov    (%esi),%eax
80101a3f:	e8 0c fb ff ff       	call   80101550 <bfree>
80101a44:	eb ea                	jmp    80101a30 <iput+0x110>
    brelse(bp);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a4c:	e8 af e7 ff ff       	call   80100200 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a51:	8b 56 4c             	mov    0x4c(%esi),%edx
80101a54:	8b 06                	mov    (%esi),%eax
80101a56:	e8 f5 fa ff ff       	call   80101550 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a5b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101a62:	83 c4 10             	add    $0x10,%esp
80101a65:	e9 47 ff ff ff       	jmp    801019b1 <iput+0x91>
      panic("iput busy");
80101a6a:	83 ec 0c             	sub    $0xc,%esp
80101a6d:	68 88 85 10 80       	push   $0x80108588
80101a72:	e8 09 ea ff ff       	call   80100480 <panic>
80101a77:	89 f6                	mov    %esi,%esi
80101a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101a80 <iunlockput>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	53                   	push   %ebx
80101a84:	83 ec 10             	sub    $0x10,%esp
80101a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a8a:	53                   	push   %ebx
80101a8b:	e8 30 fe ff ff       	call   801018c0 <iunlock>
  iput(ip);
80101a90:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a93:	83 c4 10             	add    $0x10,%esp
}
80101a96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a99:	c9                   	leave  
  iput(ip);
80101a9a:	e9 81 fe ff ff       	jmp    80101920 <iput>
80101a9f:	90                   	nop

80101aa0 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	8b 55 08             	mov    0x8(%ebp),%edx
80101aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->mode=ip->mode;
80101aa9:	0f b6 4a 11          	movzbl 0x11(%edx),%ecx
80101aad:	88 48 01             	mov    %cl,0x1(%eax)
  st->dev = ip->dev;
80101ab0:	8b 0a                	mov    (%edx),%ecx
80101ab2:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ab5:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ab8:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101abb:	0f b6 4a 10          	movzbl 0x10(%edx),%ecx
80101abf:	88 08                	mov    %cl,(%eax)
  st->nlink = ip->nlink;
80101ac1:	0f b7 4a 16          	movzwl 0x16(%edx),%ecx
80101ac5:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ac9:	8b 52 18             	mov    0x18(%edx),%edx
80101acc:	89 50 10             	mov    %edx,0x10(%eax)
}
80101acf:	5d                   	pop    %ebp
80101ad0:	c3                   	ret    
80101ad1:	eb 0d                	jmp    80101ae0 <readi>
80101ad3:	90                   	nop
80101ad4:	90                   	nop
80101ad5:	90                   	nop
80101ad6:	90                   	nop
80101ad7:	90                   	nop
80101ad8:	90                   	nop
80101ad9:	90                   	nop
80101ada:	90                   	nop
80101adb:	90                   	nop
80101adc:	90                   	nop
80101add:	90                   	nop
80101ade:	90                   	nop
80101adf:	90                   	nop

80101ae0 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 1c             	sub    $0x1c,%esp
80101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aec:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aef:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af2:	80 78 10 03          	cmpb   $0x3,0x10(%eax)
{
80101af6:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101af9:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101afc:	8b 75 10             	mov    0x10(%ebp),%esi
80101aff:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b02:	0f 84 a0 00 00 00    	je     80101ba8 <readi+0xc8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b08:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0b:	8b 40 18             	mov    0x18(%eax),%eax
80101b0e:	39 c6                	cmp    %eax,%esi
80101b10:	0f 87 b3 00 00 00    	ja     80101bc9 <readi+0xe9>
80101b16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b19:	89 f9                	mov    %edi,%ecx
80101b1b:	01 f1                	add    %esi,%ecx
80101b1d:	0f 82 a6 00 00 00    	jb     80101bc9 <readi+0xe9>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b23:	89 c2                	mov    %eax,%edx
80101b25:	29 f2                	sub    %esi,%edx
80101b27:	39 c8                	cmp    %ecx,%eax
80101b29:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2c:	31 ff                	xor    %edi,%edi
80101b2e:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101b30:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b33:	74 65                	je     80101b9a <readi+0xba>
80101b35:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b38:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b3b:	89 f2                	mov    %esi,%edx
80101b3d:	c1 ea 09             	shr    $0x9,%edx
80101b40:	89 d8                	mov    %ebx,%eax
80101b42:	e8 09 f9 ff ff       	call   80101450 <bmap>
80101b47:	83 ec 08             	sub    $0x8,%esp
80101b4a:	50                   	push   %eax
80101b4b:	ff 33                	pushl  (%ebx)
80101b4d:	e8 3e e6 ff ff       	call   80100190 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b52:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b55:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b57:	89 f0                	mov    %esi,%eax
80101b59:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b5e:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b63:	83 c4 0c             	add    $0xc,%esp
80101b66:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b68:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
80101b6c:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b6f:	29 fb                	sub    %edi,%ebx
80101b71:	39 d9                	cmp    %ebx,%ecx
80101b73:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b76:	53                   	push   %ebx
80101b77:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b78:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b7a:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b7d:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b7f:	e8 2c 34 00 00       	call   80104fb0 <memmove>
    brelse(bp);
80101b84:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b87:	89 14 24             	mov    %edx,(%esp)
80101b8a:	e8 71 e6 ff ff       	call   80100200 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b8f:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b92:	83 c4 10             	add    $0x10,%esp
80101b95:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b98:	77 9e                	ja     80101b38 <readi+0x58>
  }
  return n;
80101b9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ba0:	5b                   	pop    %ebx
80101ba1:	5e                   	pop    %esi
80101ba2:	5f                   	pop    %edi
80101ba3:	5d                   	pop    %ebp
80101ba4:	c3                   	ret    
80101ba5:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ba8:	0f bf 40 12          	movswl 0x12(%eax),%eax
80101bac:	66 83 f8 09          	cmp    $0x9,%ax
80101bb0:	77 17                	ja     80101bc9 <readi+0xe9>
80101bb2:	8b 04 c5 40 21 11 80 	mov    -0x7feedec0(,%eax,8),%eax
80101bb9:	85 c0                	test   %eax,%eax
80101bbb:	74 0c                	je     80101bc9 <readi+0xe9>
    return devsw[ip->major].read(ip, dst, n);
80101bbd:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc3:	5b                   	pop    %ebx
80101bc4:	5e                   	pop    %esi
80101bc5:	5f                   	pop    %edi
80101bc6:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bc7:	ff e0                	jmp    *%eax
      return -1;
80101bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bce:	eb cd                	jmp    80101b9d <readi+0xbd>

80101bd0 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 1c             	sub    $0x1c,%esp
80101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bdf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101be2:	80 78 10 03          	cmpb   $0x3,0x10(%eax)
{
80101be6:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101be9:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bec:	8b 75 10             	mov    0x10(%ebp),%esi
80101bef:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bf2:	0f 84 b8 00 00 00    	je     80101cb0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bfb:	39 70 18             	cmp    %esi,0x18(%eax)
80101bfe:	0f 82 ec 00 00 00    	jb     80101cf0 <writei+0x120>
80101c04:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c07:	31 d2                	xor    %edx,%edx
80101c09:	89 f8                	mov    %edi,%eax
80101c0b:	01 f0                	add    %esi,%eax
80101c0d:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c10:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c15:	0f 87 d5 00 00 00    	ja     80101cf0 <writei+0x120>
80101c1b:	85 d2                	test   %edx,%edx
80101c1d:	0f 85 cd 00 00 00    	jne    80101cf0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c23:	85 ff                	test   %edi,%edi
80101c25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c2c:	74 73                	je     80101ca1 <writei+0xd1>
80101c2e:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c30:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c33:	89 f2                	mov    %esi,%edx
80101c35:	c1 ea 09             	shr    $0x9,%edx
80101c38:	89 f8                	mov    %edi,%eax
80101c3a:	e8 11 f8 ff ff       	call   80101450 <bmap>
80101c3f:	83 ec 08             	sub    $0x8,%esp
80101c42:	50                   	push   %eax
80101c43:	ff 37                	pushl  (%edi)
80101c45:	e8 46 e5 ff ff       	call   80100190 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c4a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c4d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c50:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c52:	89 f0                	mov    %esi,%eax
80101c54:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c59:	83 c4 0c             	add    $0xc,%esp
80101c5c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c61:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c63:	8d 44 07 18          	lea    0x18(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c67:	39 d9                	cmp    %ebx,%ecx
80101c69:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c6c:	53                   	push   %ebx
80101c6d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c70:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c72:	50                   	push   %eax
80101c73:	e8 38 33 00 00       	call   80104fb0 <memmove>
    log_write(bp);
80101c78:	89 3c 24             	mov    %edi,(%esp)
80101c7b:	e8 f0 14 00 00       	call   80103170 <log_write>
    brelse(bp);
80101c80:	89 3c 24             	mov    %edi,(%esp)
80101c83:	e8 78 e5 ff ff       	call   80100200 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c88:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c8b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c8e:	83 c4 10             	add    $0x10,%esp
80101c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c94:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c97:	77 97                	ja     80101c30 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c9c:	3b 70 18             	cmp    0x18(%eax),%esi
80101c9f:	77 37                	ja     80101cd8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ca1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ca7:	5b                   	pop    %ebx
80101ca8:	5e                   	pop    %esi
80101ca9:	5f                   	pop    %edi
80101caa:	5d                   	pop    %ebp
80101cab:	c3                   	ret    
80101cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cb0:	0f bf 40 12          	movswl 0x12(%eax),%eax
80101cb4:	66 83 f8 09          	cmp    $0x9,%ax
80101cb8:	77 36                	ja     80101cf0 <writei+0x120>
80101cba:	8b 04 c5 44 21 11 80 	mov    -0x7feedebc(,%eax,8),%eax
80101cc1:	85 c0                	test   %eax,%eax
80101cc3:	74 2b                	je     80101cf0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101cc5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ccb:	5b                   	pop    %ebx
80101ccc:	5e                   	pop    %esi
80101ccd:	5f                   	pop    %edi
80101cce:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101ccf:	ff e0                	jmp    *%eax
80101cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101cd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cdb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cde:	89 70 18             	mov    %esi,0x18(%eax)
    iupdate(ip);
80101ce1:	50                   	push   %eax
80101ce2:	e8 09 fa ff ff       	call   801016f0 <iupdate>
80101ce7:	83 c4 10             	add    $0x10,%esp
80101cea:	eb b5                	jmp    80101ca1 <writei+0xd1>
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cf5:	eb ad                	jmp    80101ca4 <writei+0xd4>
80101cf7:	89 f6                	mov    %esi,%esi
80101cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d00 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d06:	6a 0e                	push   $0xe
80101d08:	ff 75 0c             	pushl  0xc(%ebp)
80101d0b:	ff 75 08             	pushl  0x8(%ebp)
80101d0e:	e8 0d 33 00 00       	call   80105020 <strncmp>
}
80101d13:	c9                   	leave  
80101d14:	c3                   	ret    
80101d15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	57                   	push   %edi
80101d24:	56                   	push   %esi
80101d25:	53                   	push   %ebx
80101d26:	83 ec 1c             	sub    $0x1c,%esp
80101d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d2c:	80 7b 10 01          	cmpb   $0x1,0x10(%ebx)
80101d30:	0f 85 86 00 00 00    	jne    80101dbc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d36:	8b 53 18             	mov    0x18(%ebx),%edx
80101d39:	31 ff                	xor    %edi,%edi
80101d3b:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d3e:	85 d2                	test   %edx,%edx
80101d40:	74 3f                	je     80101d81 <dirlookup+0x61>
80101d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d48:	6a 10                	push   $0x10
80101d4a:	57                   	push   %edi
80101d4b:	56                   	push   %esi
80101d4c:	53                   	push   %ebx
80101d4d:	e8 8e fd ff ff       	call   80101ae0 <readi>
80101d52:	83 c4 10             	add    $0x10,%esp
80101d55:	83 f8 10             	cmp    $0x10,%eax
80101d58:	75 55                	jne    80101daf <dirlookup+0x8f>
      panic("dirlink read");
    if(de.inum == 0)
80101d5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d5f:	74 18                	je     80101d79 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d61:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d64:	83 ec 04             	sub    $0x4,%esp
80101d67:	6a 0e                	push   $0xe
80101d69:	50                   	push   %eax
80101d6a:	ff 75 0c             	pushl  0xc(%ebp)
80101d6d:	e8 ae 32 00 00       	call   80105020 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d72:	83 c4 10             	add    $0x10,%esp
80101d75:	85 c0                	test   %eax,%eax
80101d77:	74 17                	je     80101d90 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d79:	83 c7 10             	add    $0x10,%edi
80101d7c:	3b 7b 18             	cmp    0x18(%ebx),%edi
80101d7f:	72 c7                	jb     80101d48 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d84:	31 c0                	xor    %eax,%eax
}
80101d86:	5b                   	pop    %ebx
80101d87:	5e                   	pop    %esi
80101d88:	5f                   	pop    %edi
80101d89:	5d                   	pop    %ebp
80101d8a:	c3                   	ret    
80101d8b:	90                   	nop
80101d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101d90:	8b 45 10             	mov    0x10(%ebp),%eax
80101d93:	85 c0                	test   %eax,%eax
80101d95:	74 05                	je     80101d9c <dirlookup+0x7c>
        *poff = off;
80101d97:	8b 45 10             	mov    0x10(%ebp),%eax
80101d9a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d9c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101da0:	8b 03                	mov    (%ebx),%eax
80101da2:	e8 d9 f5 ff ff       	call   80101380 <iget>
}
80101da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101daa:	5b                   	pop    %ebx
80101dab:	5e                   	pop    %esi
80101dac:	5f                   	pop    %edi
80101dad:	5d                   	pop    %ebp
80101dae:	c3                   	ret    
      panic("dirlink read");
80101daf:	83 ec 0c             	sub    $0xc,%esp
80101db2:	68 a4 85 10 80       	push   $0x801085a4
80101db7:	e8 c4 e6 ff ff       	call   80100480 <panic>
    panic("dirlookup not DIR");
80101dbc:	83 ec 0c             	sub    $0xc,%esp
80101dbf:	68 92 85 10 80       	push   $0x80108592
80101dc4:	e8 b7 e6 ff ff       	call   80100480 <panic>
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101dd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	89 cf                	mov    %ecx,%edi
80101dd8:	89 c3                	mov    %eax,%ebx
80101dda:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ddd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101de0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101de3:	0f 84 67 01 00 00    	je     80101f50 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101de9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  acquire(&icache.lock);
80101def:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(proc->cwd);
80101df2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101df5:	68 c0 21 11 80       	push   $0x801121c0
80101dfa:	e8 61 2c 00 00       	call   80104a60 <acquire>
  ip->ref++;
80101dff:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e03:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
80101e0a:	e8 11 2e 00 00       	call   80104c20 <release>
80101e0f:	83 c4 10             	add    $0x10,%esp
80101e12:	eb 07                	jmp    80101e1b <namex+0x4b>
80101e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e18:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e1b:	0f b6 03             	movzbl (%ebx),%eax
80101e1e:	3c 2f                	cmp    $0x2f,%al
80101e20:	74 f6                	je     80101e18 <namex+0x48>
  if(*path == 0)
80101e22:	84 c0                	test   %al,%al
80101e24:	0f 84 ee 00 00 00    	je     80101f18 <namex+0x148>
  while(*path != '/' && *path != 0)
80101e2a:	0f b6 03             	movzbl (%ebx),%eax
80101e2d:	3c 2f                	cmp    $0x2f,%al
80101e2f:	0f 84 b3 00 00 00    	je     80101ee8 <namex+0x118>
80101e35:	84 c0                	test   %al,%al
80101e37:	89 da                	mov    %ebx,%edx
80101e39:	75 09                	jne    80101e44 <namex+0x74>
80101e3b:	e9 a8 00 00 00       	jmp    80101ee8 <namex+0x118>
80101e40:	84 c0                	test   %al,%al
80101e42:	74 0a                	je     80101e4e <namex+0x7e>
    path++;
80101e44:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101e47:	0f b6 02             	movzbl (%edx),%eax
80101e4a:	3c 2f                	cmp    $0x2f,%al
80101e4c:	75 f2                	jne    80101e40 <namex+0x70>
80101e4e:	89 d1                	mov    %edx,%ecx
80101e50:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101e52:	83 f9 0d             	cmp    $0xd,%ecx
80101e55:	0f 8e 91 00 00 00    	jle    80101eec <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101e5b:	83 ec 04             	sub    $0x4,%esp
80101e5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101e61:	6a 0e                	push   $0xe
80101e63:	53                   	push   %ebx
80101e64:	57                   	push   %edi
80101e65:	e8 46 31 00 00       	call   80104fb0 <memmove>
    path++;
80101e6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101e6d:	83 c4 10             	add    $0x10,%esp
    path++;
80101e70:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101e72:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101e75:	75 11                	jne    80101e88 <namex+0xb8>
80101e77:	89 f6                	mov    %esi,%esi
80101e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101e80:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e83:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e86:	74 f8                	je     80101e80 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e88:	83 ec 0c             	sub    $0xc,%esp
80101e8b:	56                   	push   %esi
80101e8c:	e8 1f f9 ff ff       	call   801017b0 <ilock>
    if(ip->type != T_DIR){
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	80 7e 10 01          	cmpb   $0x1,0x10(%esi)
80101e98:	0f 85 92 00 00 00    	jne    80101f30 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ea1:	85 d2                	test   %edx,%edx
80101ea3:	74 09                	je     80101eae <namex+0xde>
80101ea5:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ea8:	0f 84 b8 00 00 00    	je     80101f66 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101eae:	83 ec 04             	sub    $0x4,%esp
80101eb1:	6a 00                	push   $0x0
80101eb3:	57                   	push   %edi
80101eb4:	56                   	push   %esi
80101eb5:	e8 66 fe ff ff       	call   80101d20 <dirlookup>
80101eba:	83 c4 10             	add    $0x10,%esp
80101ebd:	85 c0                	test   %eax,%eax
80101ebf:	74 6f                	je     80101f30 <namex+0x160>
  iunlock(ip);
80101ec1:	83 ec 0c             	sub    $0xc,%esp
80101ec4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101ec7:	56                   	push   %esi
80101ec8:	e8 f3 f9 ff ff       	call   801018c0 <iunlock>
  iput(ip);
80101ecd:	89 34 24             	mov    %esi,(%esp)
80101ed0:	e8 4b fa ff ff       	call   80101920 <iput>
80101ed5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ed8:	83 c4 10             	add    $0x10,%esp
80101edb:	89 c6                	mov    %eax,%esi
80101edd:	e9 39 ff ff ff       	jmp    80101e1b <namex+0x4b>
80101ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ee8:	89 da                	mov    %ebx,%edx
80101eea:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101eec:	83 ec 04             	sub    $0x4,%esp
80101eef:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ef2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101ef5:	51                   	push   %ecx
80101ef6:	53                   	push   %ebx
80101ef7:	57                   	push   %edi
80101ef8:	e8 b3 30 00 00       	call   80104fb0 <memmove>
    name[len] = 0;
80101efd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f00:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101f03:	83 c4 10             	add    $0x10,%esp
80101f06:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101f0a:	89 d3                	mov    %edx,%ebx
80101f0c:	e9 61 ff ff ff       	jmp    80101e72 <namex+0xa2>
80101f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f1b:	85 c0                	test   %eax,%eax
80101f1d:	75 5d                	jne    80101f7c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f22:	89 f0                	mov    %esi,%eax
80101f24:	5b                   	pop    %ebx
80101f25:	5e                   	pop    %esi
80101f26:	5f                   	pop    %edi
80101f27:	5d                   	pop    %ebp
80101f28:	c3                   	ret    
80101f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 87 f9 ff ff       	call   801018c0 <iunlock>
  iput(ip);
80101f39:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f3c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f3e:	e8 dd f9 ff ff       	call   80101920 <iput>
      return 0;
80101f43:	83 c4 10             	add    $0x10,%esp
}
80101f46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f49:	89 f0                	mov    %esi,%eax
80101f4b:	5b                   	pop    %ebx
80101f4c:	5e                   	pop    %esi
80101f4d:	5f                   	pop    %edi
80101f4e:	5d                   	pop    %ebp
80101f4f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101f50:	ba 01 00 00 00       	mov    $0x1,%edx
80101f55:	b8 01 00 00 00       	mov    $0x1,%eax
80101f5a:	e8 21 f4 ff ff       	call   80101380 <iget>
80101f5f:	89 c6                	mov    %eax,%esi
80101f61:	e9 b5 fe ff ff       	jmp    80101e1b <namex+0x4b>
      iunlock(ip);
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	56                   	push   %esi
80101f6a:	e8 51 f9 ff ff       	call   801018c0 <iunlock>
      return ip;
80101f6f:	83 c4 10             	add    $0x10,%esp
}
80101f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f75:	89 f0                	mov    %esi,%eax
80101f77:	5b                   	pop    %ebx
80101f78:	5e                   	pop    %esi
80101f79:	5f                   	pop    %edi
80101f7a:	5d                   	pop    %ebp
80101f7b:	c3                   	ret    
    iput(ip);
80101f7c:	83 ec 0c             	sub    $0xc,%esp
80101f7f:	56                   	push   %esi
    return 0;
80101f80:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f82:	e8 99 f9 ff ff       	call   80101920 <iput>
    return 0;
80101f87:	83 c4 10             	add    $0x10,%esp
80101f8a:	eb 93                	jmp    80101f1f <namex+0x14f>
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f90 <dirlink>:
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	57                   	push   %edi
80101f94:	56                   	push   %esi
80101f95:	53                   	push   %ebx
80101f96:	83 ec 20             	sub    $0x20,%esp
80101f99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f9c:	6a 00                	push   $0x0
80101f9e:	ff 75 0c             	pushl  0xc(%ebp)
80101fa1:	53                   	push   %ebx
80101fa2:	e8 79 fd ff ff       	call   80101d20 <dirlookup>
80101fa7:	83 c4 10             	add    $0x10,%esp
80101faa:	85 c0                	test   %eax,%eax
80101fac:	75 67                	jne    80102015 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fae:	8b 7b 18             	mov    0x18(%ebx),%edi
80101fb1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fb4:	85 ff                	test   %edi,%edi
80101fb6:	74 29                	je     80101fe1 <dirlink+0x51>
80101fb8:	31 ff                	xor    %edi,%edi
80101fba:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fbd:	eb 09                	jmp    80101fc8 <dirlink+0x38>
80101fbf:	90                   	nop
80101fc0:	83 c7 10             	add    $0x10,%edi
80101fc3:	3b 7b 18             	cmp    0x18(%ebx),%edi
80101fc6:	73 19                	jae    80101fe1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc8:	6a 10                	push   $0x10
80101fca:	57                   	push   %edi
80101fcb:	56                   	push   %esi
80101fcc:	53                   	push   %ebx
80101fcd:	e8 0e fb ff ff       	call   80101ae0 <readi>
80101fd2:	83 c4 10             	add    $0x10,%esp
80101fd5:	83 f8 10             	cmp    $0x10,%eax
80101fd8:	75 4e                	jne    80102028 <dirlink+0x98>
    if(de.inum == 0)
80101fda:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fdf:	75 df                	jne    80101fc0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101fe1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fe4:	83 ec 04             	sub    $0x4,%esp
80101fe7:	6a 0e                	push   $0xe
80101fe9:	ff 75 0c             	pushl  0xc(%ebp)
80101fec:	50                   	push   %eax
80101fed:	e8 8e 30 00 00       	call   80105080 <strncpy>
  de.inum = inum;
80101ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff5:	6a 10                	push   $0x10
80101ff7:	57                   	push   %edi
80101ff8:	56                   	push   %esi
80101ff9:	53                   	push   %ebx
  de.inum = inum;
80101ffa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ffe:	e8 cd fb ff ff       	call   80101bd0 <writei>
80102003:	83 c4 20             	add    $0x20,%esp
80102006:	83 f8 10             	cmp    $0x10,%eax
80102009:	75 2a                	jne    80102035 <dirlink+0xa5>
  return 0;
8010200b:	31 c0                	xor    %eax,%eax
}
8010200d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102010:	5b                   	pop    %ebx
80102011:	5e                   	pop    %esi
80102012:	5f                   	pop    %edi
80102013:	5d                   	pop    %ebp
80102014:	c3                   	ret    
    iput(ip);
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	50                   	push   %eax
80102019:	e8 02 f9 ff ff       	call   80101920 <iput>
    return -1;
8010201e:	83 c4 10             	add    $0x10,%esp
80102021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102026:	eb e5                	jmp    8010200d <dirlink+0x7d>
      panic("dirlink read");
80102028:	83 ec 0c             	sub    $0xc,%esp
8010202b:	68 a4 85 10 80       	push   $0x801085a4
80102030:	e8 4b e4 ff ff       	call   80100480 <panic>
    panic("dirlink");
80102035:	83 ec 0c             	sub    $0xc,%esp
80102038:	68 f2 8b 10 80       	push   $0x80108bf2
8010203d:	e8 3e e4 ff ff       	call   80100480 <panic>
80102042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102050 <namei>:

struct inode*
namei(char *path)
{
80102050:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102051:	31 d2                	xor    %edx,%edx
{
80102053:	89 e5                	mov    %esp,%ebp
80102055:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102058:	8b 45 08             	mov    0x8(%ebp),%eax
8010205b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010205e:	e8 6d fd ff ff       	call   80101dd0 <namex>
}
80102063:	c9                   	leave  
80102064:	c3                   	ret    
80102065:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102070 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102070:	55                   	push   %ebp
  return namex(path, 1, name);
80102071:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102076:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102078:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010207b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010207e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010207f:	e9 4c fd ff ff       	jmp    80101dd0 <namex>
80102084:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010208a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102090 <balloc8>:

uint balloc8(uint dev){
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 0c             	sub    $0xc,%esp
  uint b,bi;
  for(b=0;b<sb.size;b++){
80102099:	a1 a0 21 11 80       	mov    0x801121a0,%eax
8010209e:	85 c0                	test   %eax,%eax
801020a0:	74 5e                	je     80102100 <balloc8+0x70>
801020a2:	31 f6                	xor    %esi,%esi
    struct buf* bp=bread(dev,BBLOCK(b,sb));
801020a4:	89 f0                	mov    %esi,%eax
801020a6:	83 ec 08             	sub    $0x8,%esp
    for(bi=0;bi<512&&b+bi*8<sb.size;bi++){
801020a9:	89 f3                	mov    %esi,%ebx
    struct buf* bp=bread(dev,BBLOCK(b,sb));
801020ab:	c1 e8 0c             	shr    $0xc,%eax
801020ae:	03 05 b8 21 11 80    	add    0x801121b8,%eax
801020b4:	50                   	push   %eax
801020b5:	ff 75 08             	pushl  0x8(%ebp)
801020b8:	e8 d3 e0 ff ff       	call   80100190 <bread>
    for(bi=0;bi<512&&b+bi*8<sb.size;bi++){
801020bd:	83 c4 10             	add    $0x10,%esp
    struct buf* bp=bread(dev,BBLOCK(b,sb));
801020c0:	89 c7                	mov    %eax,%edi
    for(bi=0;bi<512&&b+bi*8<sb.size;bi++){
801020c2:	31 d2                	xor    %edx,%edx
801020c4:	a1 a0 21 11 80       	mov    0x801121a0,%eax
801020c9:	eb 1a                	jmp    801020e5 <balloc8+0x55>
801020cb:	90                   	nop
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(bp->data[bi]==0){
801020d0:	80 7c 17 18 00       	cmpb   $0x0,0x18(%edi,%edx,1)
801020d5:	74 39                	je     80102110 <balloc8+0x80>
    for(bi=0;bi<512&&b+bi*8<sb.size;bi++){
801020d7:	83 c2 01             	add    $0x1,%edx
801020da:	83 c3 08             	add    $0x8,%ebx
801020dd:	81 fa 00 02 00 00    	cmp    $0x200,%edx
801020e3:	74 04                	je     801020e9 <balloc8+0x59>
801020e5:	39 d8                	cmp    %ebx,%eax
801020e7:	77 e7                	ja     801020d0 <balloc8+0x40>
        log_write(bp);
        brelse(bp);
        return b+bi*8;
      }
    }
    brelse(bp);
801020e9:	83 ec 0c             	sub    $0xc,%esp
  for(b=0;b<sb.size;b++){
801020ec:	83 c6 01             	add    $0x1,%esi
    brelse(bp);
801020ef:	57                   	push   %edi
801020f0:	e8 0b e1 ff ff       	call   80100200 <brelse>
  for(b=0;b<sb.size;b++){
801020f5:	83 c4 10             	add    $0x10,%esp
801020f8:	39 35 a0 21 11 80    	cmp    %esi,0x801121a0
801020fe:	77 a4                	ja     801020a4 <balloc8+0x14>
  }
  panic("balloc:out ot blocks");
80102100:	83 ec 0c             	sub    $0xc,%esp
80102103:	68 b1 85 10 80       	push   $0x801085b1
80102108:	e8 73 e3 ff ff       	call   80100480 <panic>
8010210d:	8d 76 00             	lea    0x0(%esi),%esi
        log_write(bp);
80102110:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi]=~bp->data[bi];
80102113:	c6 44 17 18 ff       	movb   $0xff,0x18(%edi,%edx,1)
        log_write(bp);
80102118:	57                   	push   %edi
80102119:	e8 52 10 00 00       	call   80103170 <log_write>
        brelse(bp);
8010211e:	89 3c 24             	mov    %edi,(%esp)
80102121:	e8 da e0 ff ff       	call   80100200 <brelse>
}
80102126:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102129:	89 d8                	mov    %ebx,%eax
8010212b:	5b                   	pop    %ebx
8010212c:	5e                   	pop    %esi
8010212d:	5f                   	pop    %edi
8010212e:	5d                   	pop    %ebp
8010212f:	c3                   	ret    

80102130 <bfree8>:

void bfree8(int dev,uint b){
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	57                   	push   %edi
80102134:	56                   	push   %esi
80102135:	53                   	push   %ebx
80102136:	83 ec 0c             	sub    $0xc,%esp
80102139:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010213c:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint i;
  begin_op();
8010213f:	e8 5c 0e 00 00       	call   80102fa0 <begin_op>
80102144:	8d 73 08             	lea    0x8(%ebx),%esi
80102147:	89 f6                	mov    %esi,%esi
80102149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(i=0;i<8;i++){
    bfree(dev,b+i);
80102150:	89 da                	mov    %ebx,%edx
80102152:	89 f8                	mov    %edi,%eax
80102154:	83 c3 01             	add    $0x1,%ebx
80102157:	e8 f4 f3 ff ff       	call   80101550 <bfree>
  for(i=0;i<8;i++){
8010215c:	39 f3                	cmp    %esi,%ebx
8010215e:	75 f0                	jne    80102150 <bfree8+0x20>
  }
  end_op();
80102160:	83 c4 0c             	add    $0xc,%esp
80102163:	5b                   	pop    %ebx
80102164:	5e                   	pop    %esi
80102165:	5f                   	pop    %edi
80102166:	5d                   	pop    %ebp
  end_op();
80102167:	e9 a4 0e 00 00       	jmp    80103010 <end_op>
8010216c:	66 90                	xchg   %ax,%ax
8010216e:	66 90                	xchg   %ax,%ax

80102170 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102170:	55                   	push   %ebp
80102171:	89 e5                	mov    %esp,%ebp
80102173:	57                   	push   %edi
80102174:	56                   	push   %esi
80102175:	53                   	push   %ebx
80102176:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102179:	85 c0                	test   %eax,%eax
8010217b:	0f 84 b4 00 00 00    	je     80102235 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102181:	8b 58 08             	mov    0x8(%eax),%ebx
80102184:	89 c6                	mov    %eax,%esi
80102186:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010218c:	0f 87 96 00 00 00    	ja     80102228 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102192:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102197:	89 f6                	mov    %esi,%esi
80102199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801021a0:	89 ca                	mov    %ecx,%edx
801021a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021a3:	83 e0 c0             	and    $0xffffffc0,%eax
801021a6:	3c 40                	cmp    $0x40,%al
801021a8:	75 f6                	jne    801021a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021aa:	31 ff                	xor    %edi,%edi
801021ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021b1:	89 f8                	mov    %edi,%eax
801021b3:	ee                   	out    %al,(%dx)
801021b4:	b8 01 00 00 00       	mov    $0x1,%eax
801021b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021be:	ee                   	out    %al,(%dx)
801021bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021c4:	89 d8                	mov    %ebx,%eax
801021c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021c7:	89 d8                	mov    %ebx,%eax
801021c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021ce:	c1 f8 08             	sar    $0x8,%eax
801021d1:	ee                   	out    %al,(%dx)
801021d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021d7:	89 f8                	mov    %edi,%eax
801021d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021da:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801021de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021e3:	c1 e0 04             	shl    $0x4,%eax
801021e6:	83 e0 10             	and    $0x10,%eax
801021e9:	83 c8 e0             	or     $0xffffffe0,%eax
801021ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021ed:	f6 06 04             	testb  $0x4,(%esi)
801021f0:	75 16                	jne    80102208 <idestart+0x98>
801021f2:	b8 20 00 00 00       	mov    $0x20,%eax
801021f7:	89 ca                	mov    %ecx,%edx
801021f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021fd:	5b                   	pop    %ebx
801021fe:	5e                   	pop    %esi
801021ff:	5f                   	pop    %edi
80102200:	5d                   	pop    %ebp
80102201:	c3                   	ret    
80102202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102208:	b8 30 00 00 00       	mov    $0x30,%eax
8010220d:	89 ca                	mov    %ecx,%edx
8010220f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102210:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102215:	83 c6 18             	add    $0x18,%esi
80102218:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010221d:	fc                   	cld    
8010221e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102220:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102223:	5b                   	pop    %ebx
80102224:	5e                   	pop    %esi
80102225:	5f                   	pop    %edi
80102226:	5d                   	pop    %ebp
80102227:	c3                   	ret    
    panic("incorrect blockno");
80102228:	83 ec 0c             	sub    $0xc,%esp
8010222b:	68 2d 86 10 80       	push   $0x8010862d
80102230:	e8 4b e2 ff ff       	call   80100480 <panic>
    panic("idestart");
80102235:	83 ec 0c             	sub    $0xc,%esp
80102238:	68 24 86 10 80       	push   $0x80108624
8010223d:	e8 3e e2 ff ff       	call   80100480 <panic>
80102242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102250 <ideinit>:
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102256:	68 3f 86 10 80       	push   $0x8010863f
8010225b:	68 80 c5 10 80       	push   $0x8010c580
80102260:	e8 db 27 00 00       	call   80104a40 <initlock>
  picenable(IRQ_IDE);
80102265:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010226c:	e8 0f 14 00 00       	call   80103680 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102271:	58                   	pop    %eax
80102272:	a1 c0 48 11 80       	mov    0x801148c0,%eax
80102277:	5a                   	pop    %edx
80102278:	83 e8 01             	sub    $0x1,%eax
8010227b:	50                   	push   %eax
8010227c:	6a 0e                	push   $0xe
8010227e:	e8 bd 02 00 00       	call   80102540 <ioapicenable>
80102283:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102286:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010228b:	90                   	nop
8010228c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102290:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102291:	83 e0 c0             	and    $0xffffffc0,%eax
80102294:	3c 40                	cmp    $0x40,%al
80102296:	75 f8                	jne    80102290 <ideinit+0x40>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102298:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010229d:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022a2:	ee                   	out    %al,(%dx)
801022a3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022a8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022ad:	eb 06                	jmp    801022b5 <ideinit+0x65>
801022af:	90                   	nop
  for(i=0; i<1000; i++){
801022b0:	83 e9 01             	sub    $0x1,%ecx
801022b3:	74 0f                	je     801022c4 <ideinit+0x74>
801022b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022b6:	84 c0                	test   %al,%al
801022b8:	74 f6                	je     801022b0 <ideinit+0x60>
      havedisk1 = 1;
801022ba:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
801022c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022ce:	ee                   	out    %al,(%dx)
}
801022cf:	c9                   	leave  
801022d0:	c3                   	ret    
801022d1:	eb 0d                	jmp    801022e0 <ideintr>
801022d3:	90                   	nop
801022d4:	90                   	nop
801022d5:	90                   	nop
801022d6:	90                   	nop
801022d7:	90                   	nop
801022d8:	90                   	nop
801022d9:	90                   	nop
801022da:	90                   	nop
801022db:	90                   	nop
801022dc:	90                   	nop
801022dd:	90                   	nop
801022de:	90                   	nop
801022df:	90                   	nop

801022e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	57                   	push   %edi
801022e4:	56                   	push   %esi
801022e5:	53                   	push   %ebx
801022e6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022e9:	68 80 c5 10 80       	push   $0x8010c580
801022ee:	e8 6d 27 00 00       	call   80104a60 <acquire>
  if((b = idequeue) == 0){
801022f3:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
801022f9:	83 c4 10             	add    $0x10,%esp
801022fc:	85 db                	test   %ebx,%ebx
801022fe:	74 67                	je     80102367 <ideintr+0x87>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
80102300:	8b 43 14             	mov    0x14(%ebx),%eax
80102303:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102308:	8b 3b                	mov    (%ebx),%edi
8010230a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102310:	75 31                	jne    80102343 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102312:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102317:	89 f6                	mov    %esi,%esi
80102319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102320:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102321:	89 c6                	mov    %eax,%esi
80102323:	83 e6 c0             	and    $0xffffffc0,%esi
80102326:	89 f1                	mov    %esi,%ecx
80102328:	80 f9 40             	cmp    $0x40,%cl
8010232b:	75 f3                	jne    80102320 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010232d:	a8 21                	test   $0x21,%al
8010232f:	75 12                	jne    80102343 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102331:	8d 7b 18             	lea    0x18(%ebx),%edi
  asm volatile("cld; rep insl" :
80102334:	b9 80 00 00 00       	mov    $0x80,%ecx
80102339:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010233e:	fc                   	cld    
8010233f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102341:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102343:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102346:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102349:	89 f9                	mov    %edi,%ecx
8010234b:	83 c9 02             	or     $0x2,%ecx
8010234e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102350:	53                   	push   %ebx
80102351:	e8 0a 21 00 00       	call   80104460 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102356:	a1 64 c5 10 80       	mov    0x8010c564,%eax
8010235b:	83 c4 10             	add    $0x10,%esp
8010235e:	85 c0                	test   %eax,%eax
80102360:	74 05                	je     80102367 <ideintr+0x87>
    idestart(idequeue);
80102362:	e8 09 fe ff ff       	call   80102170 <idestart>
    release(&idelock);
80102367:	83 ec 0c             	sub    $0xc,%esp
8010236a:	68 80 c5 10 80       	push   $0x8010c580
8010236f:	e8 ac 28 00 00       	call   80104c20 <release>

  release(&idelock);
}
80102374:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102377:	5b                   	pop    %ebx
80102378:	5e                   	pop    %esi
80102379:	5f                   	pop    %edi
8010237a:	5d                   	pop    %ebp
8010237b:	c3                   	ret    
8010237c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102380 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	53                   	push   %ebx
80102384:	83 ec 04             	sub    $0x4,%esp
80102387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010238a:	8b 03                	mov    (%ebx),%eax
8010238c:	a8 01                	test   $0x1,%al
8010238e:	0f 84 c0 00 00 00    	je     80102454 <iderw+0xd4>
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102394:	83 e0 06             	and    $0x6,%eax
80102397:	83 f8 02             	cmp    $0x2,%eax
8010239a:	0f 84 a7 00 00 00    	je     80102447 <iderw+0xc7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023a0:	8b 53 04             	mov    0x4(%ebx),%edx
801023a3:	85 d2                	test   %edx,%edx
801023a5:	74 0d                	je     801023b4 <iderw+0x34>
801023a7:	a1 60 c5 10 80       	mov    0x8010c560,%eax
801023ac:	85 c0                	test   %eax,%eax
801023ae:	0f 84 ad 00 00 00    	je     80102461 <iderw+0xe1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 80 c5 10 80       	push   $0x8010c580
801023bc:	e8 9f 26 00 00       	call   80104a60 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c1:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
801023c7:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801023ca:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023d1:	85 d2                	test   %edx,%edx
801023d3:	75 0d                	jne    801023e2 <iderw+0x62>
801023d5:	eb 69                	jmp    80102440 <iderw+0xc0>
801023d7:	89 f6                	mov    %esi,%esi
801023d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801023e0:	89 c2                	mov    %eax,%edx
801023e2:	8b 42 14             	mov    0x14(%edx),%eax
801023e5:	85 c0                	test   %eax,%eax
801023e7:	75 f7                	jne    801023e0 <iderw+0x60>
801023e9:	83 c2 14             	add    $0x14,%edx
    ;
  *pp = b;
801023ec:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023ee:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
801023f4:	74 3a                	je     80102430 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023f6:	8b 03                	mov    (%ebx),%eax
801023f8:	83 e0 06             	and    $0x6,%eax
801023fb:	83 f8 02             	cmp    $0x2,%eax
801023fe:	74 1b                	je     8010241b <iderw+0x9b>
    sleep(b, &idelock);
80102400:	83 ec 08             	sub    $0x8,%esp
80102403:	68 80 c5 10 80       	push   $0x8010c580
80102408:	53                   	push   %ebx
80102409:	e8 a2 1e 00 00       	call   801042b0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010240e:	8b 03                	mov    (%ebx),%eax
80102410:	83 c4 10             	add    $0x10,%esp
80102413:	83 e0 06             	and    $0x6,%eax
80102416:	83 f8 02             	cmp    $0x2,%eax
80102419:	75 e5                	jne    80102400 <iderw+0x80>
  }

  release(&idelock);
8010241b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102422:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102425:	c9                   	leave  
  release(&idelock);
80102426:	e9 f5 27 00 00       	jmp    80104c20 <release>
8010242b:	90                   	nop
8010242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102430:	89 d8                	mov    %ebx,%eax
80102432:	e8 39 fd ff ff       	call   80102170 <idestart>
80102437:	eb bd                	jmp    801023f6 <iderw+0x76>
80102439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102440:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102445:	eb a5                	jmp    801023ec <iderw+0x6c>
    panic("iderw: nothing to do");
80102447:	83 ec 0c             	sub    $0xc,%esp
8010244a:	68 57 86 10 80       	push   $0x80108657
8010244f:	e8 2c e0 ff ff       	call   80100480 <panic>
    panic("iderw: buf not busy");
80102454:	83 ec 0c             	sub    $0xc,%esp
80102457:	68 43 86 10 80       	push   $0x80108643
8010245c:	e8 1f e0 ff ff       	call   80100480 <panic>
    panic("iderw: ide disk 1 not present");
80102461:	83 ec 0c             	sub    $0xc,%esp
80102464:	68 6c 86 10 80       	push   $0x8010866c
80102469:	e8 12 e0 ff ff       	call   80100480 <panic>
8010246e:	66 90                	xchg   %ax,%ax

80102470 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
80102470:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80102475:	85 c0                	test   %eax,%eax
80102477:	0f 84 b3 00 00 00    	je     80102530 <ioapicinit+0xc0>
{
8010247d:	55                   	push   %ebp
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
8010247e:	c7 05 94 31 11 80 00 	movl   $0xfec00000,0x80113194
80102485:	00 c0 fe 
{
80102488:	89 e5                	mov    %esp,%ebp
8010248a:	56                   	push   %esi
8010248b:	53                   	push   %ebx
  ioapic->reg = reg;
8010248c:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102493:	00 00 00 
  return ioapic->data;
80102496:	a1 94 31 11 80       	mov    0x80113194,%eax
8010249b:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
8010249e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801024a4:	8b 0d 94 31 11 80    	mov    0x80113194,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024aa:	0f b6 15 c0 42 11 80 	movzbl 0x801142c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024b1:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801024b4:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024b7:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801024ba:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024bd:	39 c2                	cmp    %eax,%edx
801024bf:	75 4f                	jne    80102510 <ioapicinit+0xa0>
801024c1:	83 c3 21             	add    $0x21,%ebx
{
801024c4:	ba 10 00 00 00       	mov    $0x10,%edx
801024c9:	b8 20 00 00 00       	mov    $0x20,%eax
801024ce:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801024d0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801024d2:	8b 0d 94 31 11 80    	mov    0x80113194,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024d8:	89 c6                	mov    %eax,%esi
801024da:	81 ce 00 00 01 00    	or     $0x10000,%esi
801024e0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024e3:	89 71 10             	mov    %esi,0x10(%ecx)
801024e6:	8d 72 01             	lea    0x1(%edx),%esi
801024e9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801024ec:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801024ee:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801024f0:	8b 0d 94 31 11 80    	mov    0x80113194,%ecx
801024f6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801024fd:	75 d1                	jne    801024d0 <ioapicinit+0x60>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102502:	5b                   	pop    %ebx
80102503:	5e                   	pop    %esi
80102504:	5d                   	pop    %ebp
80102505:	c3                   	ret    
80102506:	8d 76 00             	lea    0x0(%esi),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	68 8c 86 10 80       	push   $0x8010868c
80102518:	e8 33 e2 ff ff       	call   80100750 <cprintf>
8010251d:	8b 0d 94 31 11 80    	mov    0x80113194,%ecx
80102523:	83 c4 10             	add    $0x10,%esp
80102526:	eb 99                	jmp    801024c1 <ioapicinit+0x51>
80102528:	90                   	nop
80102529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102530:	f3 c3                	repz ret 
80102532:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102540 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
80102540:	8b 15 c4 42 11 80    	mov    0x801142c4,%edx
{
80102546:	55                   	push   %ebp
80102547:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102549:	85 d2                	test   %edx,%edx
{
8010254b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
8010254e:	74 2b                	je     8010257b <ioapicenable+0x3b>
  ioapic->reg = reg;
80102550:	8b 0d 94 31 11 80    	mov    0x80113194,%ecx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102556:	8d 50 20             	lea    0x20(%eax),%edx
80102559:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
8010255d:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010255f:	8b 0d 94 31 11 80    	mov    0x80113194,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102565:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102568:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010256b:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
8010256e:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102570:	a1 94 31 11 80       	mov    0x80113194,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102575:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102578:	89 50 10             	mov    %edx,0x10(%eax)
}
8010257b:	5d                   	pop    %ebp
8010257c:	c3                   	ret    
8010257d:	66 90                	xchg   %ax,%ax
8010257f:	90                   	nop

80102580 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	56                   	push   %esi
80102584:	53                   	push   %ebx
80102585:	8b 75 08             	mov    0x8(%ebp),%esi
  struct run *r;
  // cprintf("kmem.pageref[V2P(v)>> PGSHIFT]=%d",kmem.pageref[V2P(v)>> PGSHIFT]);
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102588:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
8010258e:	0f 85 b1 00 00 00    	jne    80102645 <kfree+0xc5>
80102594:	81 fe 00 9e 11 80    	cmp    $0x80119e00,%esi
8010259a:	0f 82 a5 00 00 00    	jb     80102645 <kfree+0xc5>
801025a0:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
801025a6:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
801025ac:	0f 87 93 00 00 00    	ja     80102645 <kfree+0xc5>
    panic("kfree");
  if(kmem.use_lock)
801025b2:	8b 15 d4 31 11 80    	mov    0x801131d4,%edx
801025b8:	85 d2                	test   %edx,%edx
801025ba:	75 74                	jne    80102630 <kfree+0xb0>
    acquire(&kmem.lock);
  if(kmem.pageref[V2P(v)/PGSIZE] >0)//若引用值大于0
801025bc:	c1 eb 0c             	shr    $0xc,%ebx
801025bf:	83 c3 0c             	add    $0xc,%ebx
801025c2:	8b 04 9d ac 31 11 80 	mov    -0x7feece54(,%ebx,4),%eax
801025c9:	85 c0                	test   %eax,%eax
801025cb:	75 33                	jne    80102600 <kfree+0x80>
    kmem.pageref[V2P(v)/PGSIZE]-=1;//单纯引用值-1即可
  // cprintf("kmem.pageref[V2P(v)>> PGSHIFT]=%d",kmem.pageref[V2P(v)>> PGSHIFT]);
  if(kmem.pageref[V2P(v)/PGSIZE]==0){//若引用值==0
    // Fill with junk to catch dangling refs.
    memset(v, 1, PGSIZE);//数字1填充该页
801025cd:	83 ec 04             	sub    $0x4,%esp
801025d0:	68 00 10 00 00       	push   $0x1000
801025d5:	6a 01                	push   $0x1
801025d7:	56                   	push   %esi
801025d8:	e8 23 29 00 00       	call   80104f00 <memset>
    r = (struct run*)v;//将页帧插入到链表头部
    r->next = kmem.freelist;
801025dd:	a1 d8 31 11 80       	mov    0x801131d8,%eax
    kmem.freelist = r;
801025e2:	83 c4 10             	add    $0x10,%esp
    r->next = kmem.freelist;
801025e5:	89 06                	mov    %eax,(%esi)
  }
  
  if(kmem.use_lock)
801025e7:	a1 d4 31 11 80       	mov    0x801131d4,%eax
    kmem.freelist = r;
801025ec:	89 35 d8 31 11 80    	mov    %esi,0x801131d8
  if(kmem.use_lock)
801025f2:	85 c0                	test   %eax,%eax
801025f4:	75 21                	jne    80102617 <kfree+0x97>
    release(&kmem.lock);
}
801025f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025f9:	5b                   	pop    %ebx
801025fa:	5e                   	pop    %esi
801025fb:	5d                   	pop    %ebp
801025fc:	c3                   	ret    
801025fd:	8d 76 00             	lea    0x0(%esi),%esi
    kmem.pageref[V2P(v)/PGSIZE]-=1;//单纯引用值-1即可
80102600:	83 e8 01             	sub    $0x1,%eax
  if(kmem.pageref[V2P(v)/PGSIZE]==0){//若引用值==0
80102603:	85 c0                	test   %eax,%eax
    kmem.pageref[V2P(v)/PGSIZE]-=1;//单纯引用值-1即可
80102605:	89 04 9d ac 31 11 80 	mov    %eax,-0x7feece54(,%ebx,4)
  if(kmem.pageref[V2P(v)/PGSIZE]==0){//若引用值==0
8010260c:	74 bf                	je     801025cd <kfree+0x4d>
  if(kmem.use_lock)
8010260e:	a1 d4 31 11 80       	mov    0x801131d4,%eax
80102613:	85 c0                	test   %eax,%eax
80102615:	74 df                	je     801025f6 <kfree+0x76>
    release(&kmem.lock);
80102617:	c7 45 08 a0 31 11 80 	movl   $0x801131a0,0x8(%ebp)
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
    release(&kmem.lock);
80102624:	e9 f7 25 00 00       	jmp    80104c20 <release>
80102629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	68 a0 31 11 80       	push   $0x801131a0
80102638:	e8 23 24 00 00       	call   80104a60 <acquire>
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	e9 77 ff ff ff       	jmp    801025bc <kfree+0x3c>
    panic("kfree");
80102645:	83 ec 0c             	sub    $0xc,%esp
80102648:	68 be 86 10 80       	push   $0x801086be
8010264d:	e8 2e de ff ff       	call   80100480 <panic>
80102652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <freerange>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
80102664:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102665:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102668:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010266b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102671:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102677:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010267d:	39 de                	cmp    %ebx,%esi
8010267f:	72 23                	jb     801026a4 <freerange+0x44>
80102681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102688:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010268e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102691:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102697:	50                   	push   %eax
80102698:	e8 e3 fe ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010269d:	83 c4 10             	add    $0x10,%esp
801026a0:	39 f3                	cmp    %esi,%ebx
801026a2:	76 e4                	jbe    80102688 <freerange+0x28>
}
801026a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026a7:	5b                   	pop    %ebx
801026a8:	5e                   	pop    %esi
801026a9:	5d                   	pop    %ebp
801026aa:	c3                   	ret    
801026ab:	90                   	nop
801026ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026b0 <kinit1>:
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	56                   	push   %esi
801026b4:	53                   	push   %ebx
801026b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801026b8:	83 ec 08             	sub    $0x8,%esp
801026bb:	68 c4 86 10 80       	push   $0x801086c4
801026c0:	68 a0 31 11 80       	push   $0x801131a0
801026c5:	e8 76 23 00 00       	call   80104a40 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026ca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026cd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026d0:	c7 05 d4 31 11 80 00 	movl   $0x0,0x801131d4
801026d7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026da:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ec:	39 de                	cmp    %ebx,%esi
801026ee:	72 1c                	jb     8010270c <kinit1+0x5c>
    kfree(p);
801026f0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026f6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026ff:	50                   	push   %eax
80102700:	e8 7b fe ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102705:	83 c4 10             	add    $0x10,%esp
80102708:	39 de                	cmp    %ebx,%esi
8010270a:	73 e4                	jae    801026f0 <kinit1+0x40>
}
8010270c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010270f:	5b                   	pop    %ebx
80102710:	5e                   	pop    %esi
80102711:	5d                   	pop    %ebp
80102712:	c3                   	ret    
80102713:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102720 <kinit2>:
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	56                   	push   %esi
80102724:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102725:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102728:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010272b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102731:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102737:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010273d:	39 de                	cmp    %ebx,%esi
8010273f:	72 23                	jb     80102764 <kinit2+0x44>
80102741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102748:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010274e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102751:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102757:	50                   	push   %eax
80102758:	e8 23 fe ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010275d:	83 c4 10             	add    $0x10,%esp
80102760:	39 de                	cmp    %ebx,%esi
80102762:	73 e4                	jae    80102748 <kinit2+0x28>
  kmem.use_lock = 1;
80102764:	c7 05 d4 31 11 80 01 	movl   $0x1,0x801131d4
8010276b:	00 00 00 
}
8010276e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102771:	5b                   	pop    %ebx
80102772:	5e                   	pop    %esi
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102780:	a1 d4 31 11 80       	mov    0x801131d4,%eax
80102785:	85 c0                	test   %eax,%eax
80102787:	75 2f                	jne    801027b8 <kalloc+0x38>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102789:	a1 d8 31 11 80       	mov    0x801131d8,%eax
  if(r){
8010278e:	85 c0                	test   %eax,%eax
80102790:	74 1e                	je     801027b0 <kalloc+0x30>
    kmem.freelist = r->next;
80102792:	8b 10                	mov    (%eax),%edx
80102794:	89 15 d8 31 11 80    	mov    %edx,0x801131d8
    //将r虚拟地址对应的物理地址上对应的pageref数组引用次数初始化为1
    kmem.pageref[V2P((char*)r) /PGSIZE]=1;
8010279a:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801027a0:	c1 ea 0c             	shr    $0xc,%edx
801027a3:	c7 04 95 dc 31 11 80 	movl   $0x1,-0x7feece24(,%edx,4)
801027aa:	01 00 00 00 
801027ae:	c3                   	ret    
801027af:	90                   	nop
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801027b0:	f3 c3                	repz ret 
801027b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801027b8:	55                   	push   %ebp
801027b9:	89 e5                	mov    %esp,%ebp
801027bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027be:	68 a0 31 11 80       	push   $0x801131a0
801027c3:	e8 98 22 00 00       	call   80104a60 <acquire>
  r = kmem.freelist;
801027c8:	a1 d8 31 11 80       	mov    0x801131d8,%eax
  if(r){
801027cd:	83 c4 10             	add    $0x10,%esp
801027d0:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
801027d6:	85 c0                	test   %eax,%eax
801027d8:	74 1c                	je     801027f6 <kalloc+0x76>
    kmem.freelist = r->next;
801027da:	8b 10                	mov    (%eax),%edx
801027dc:	89 15 d8 31 11 80    	mov    %edx,0x801131d8
    kmem.pageref[V2P((char*)r) /PGSIZE]=1;
801027e2:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801027e8:	c1 ea 0c             	shr    $0xc,%edx
801027eb:	c7 04 95 dc 31 11 80 	movl   $0x1,-0x7feece24(,%edx,4)
801027f2:	01 00 00 00 
  if(kmem.use_lock)
801027f6:	85 c9                	test   %ecx,%ecx
801027f8:	74 16                	je     80102810 <kalloc+0x90>
    release(&kmem.lock);
801027fa:	83 ec 0c             	sub    $0xc,%esp
801027fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102800:	68 a0 31 11 80       	push   $0x801131a0
80102805:	e8 16 24 00 00       	call   80104c20 <release>
  return (char*)r;
8010280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
8010280d:	83 c4 10             	add    $0x10,%esp
}
80102810:	c9                   	leave  
80102811:	c3                   	ret    
80102812:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <pageref_get>:

//获取对应物理地址的被引用次数函数
uint pageref_get(uint pa){
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	53                   	push   %ebx
80102824:	83 ec 10             	sub    $0x10,%esp
  //index是根据传入的物理地址计算页号
  uint index =pa >> PGSHIFT;
  //加上自旋锁
  acquire(&kmem.lock);
80102827:	68 a0 31 11 80       	push   $0x801131a0
8010282c:	e8 2f 22 00 00       	call   80104a60 <acquire>
  uint index =pa >> PGSHIFT;
80102831:	8b 45 08             	mov    0x8(%ebp),%eax
  //获取数组中引用次数
  uint count=kmem.pageref[index];
  //释放锁
  release(&kmem.lock);
80102834:	c7 04 24 a0 31 11 80 	movl   $0x801131a0,(%esp)
  uint index =pa >> PGSHIFT;
8010283b:	c1 e8 0c             	shr    $0xc,%eax
  uint count=kmem.pageref[index];
8010283e:	8b 1c 85 dc 31 11 80 	mov    -0x7feece24(,%eax,4),%ebx
  release(&kmem.lock);
80102845:	e8 d6 23 00 00       	call   80104c20 <release>
  return count;//返回引用次数
}
8010284a:	89 d8                	mov    %ebx,%eax
8010284c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010284f:	c9                   	leave  
80102850:	c3                   	ret    
80102851:	eb 0d                	jmp    80102860 <pageref_set>
80102853:	90                   	nop
80102854:	90                   	nop
80102855:	90                   	nop
80102856:	90                   	nop
80102857:	90                   	nop
80102858:	90                   	nop
80102859:	90                   	nop
8010285a:	90                   	nop
8010285b:	90                   	nop
8010285c:	90                   	nop
8010285d:	90                   	nop
8010285e:	90                   	nop
8010285f:	90                   	nop

80102860 <pageref_set>:

//增加对应physical address计数器计数delta函数
void pageref_set(uint pa,uint delta){
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	56                   	push   %esi
80102864:	53                   	push   %ebx
  //index是根据传入的物理地址计算页号
  uint index = pa >> PGSHIFT;
80102865:	8b 5d 08             	mov    0x8(%ebp),%ebx
void pageref_set(uint pa,uint delta){
80102868:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&kmem.lock);
8010286b:	83 ec 0c             	sub    $0xc,%esp
8010286e:	68 a0 31 11 80       	push   $0x801131a0
  uint index = pa >> PGSHIFT;
80102873:	c1 eb 0c             	shr    $0xc,%ebx
  acquire(&kmem.lock);
80102876:	e8 e5 21 00 00       	call   80104a60 <acquire>
  //增加pa物理地址所对应的引用的计数
  kmem.pageref[index] += delta;
8010287b:	01 34 9d dc 31 11 80 	add    %esi,-0x7feece24(,%ebx,4)
  release(&kmem.lock);
80102882:	c7 45 08 a0 31 11 80 	movl   $0x801131a0,0x8(%ebp)
80102889:	83 c4 10             	add    $0x10,%esp
8010288c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010288f:	5b                   	pop    %ebx
80102890:	5e                   	pop    %esi
80102891:	5d                   	pop    %ebp
  release(&kmem.lock);
80102892:	e9 89 23 00 00       	jmp    80104c20 <release>
80102897:	66 90                	xchg   %ax,%ax
80102899:	66 90                	xchg   %ax,%ax
8010289b:	66 90                	xchg   %ax,%ax
8010289d:	66 90                	xchg   %ax,%ax
8010289f:	90                   	nop

801028a0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a0:	ba 64 00 00 00       	mov    $0x64,%edx
801028a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028a6:	a8 01                	test   $0x1,%al
801028a8:	0f 84 c2 00 00 00    	je     80102970 <kbdgetc+0xd0>
801028ae:	ba 60 00 00 00       	mov    $0x60,%edx
801028b3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801028b4:	0f b6 d0             	movzbl %al,%edx
801028b7:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

  if(data == 0xE0){
801028bd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801028c3:	0f 84 7f 00 00 00    	je     80102948 <kbdgetc+0xa8>
{
801028c9:	55                   	push   %ebp
801028ca:	89 e5                	mov    %esp,%ebp
801028cc:	53                   	push   %ebx
801028cd:	89 cb                	mov    %ecx,%ebx
801028cf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028d2:	84 c0                	test   %al,%al
801028d4:	78 4a                	js     80102920 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028d6:	85 db                	test   %ebx,%ebx
801028d8:	74 09                	je     801028e3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028da:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028dd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801028e0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801028e3:	0f b6 82 00 88 10 80 	movzbl -0x7fef7800(%edx),%eax
801028ea:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801028ec:	0f b6 82 00 87 10 80 	movzbl -0x7fef7900(%edx),%eax
801028f3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801028f5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801028f7:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801028fd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102900:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102903:	8b 04 85 e0 86 10 80 	mov    -0x7fef7920(,%eax,4),%eax
8010290a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010290e:	74 31                	je     80102941 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102910:	8d 50 9f             	lea    -0x61(%eax),%edx
80102913:	83 fa 19             	cmp    $0x19,%edx
80102916:	77 40                	ja     80102958 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102918:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010291b:	5b                   	pop    %ebx
8010291c:	5d                   	pop    %ebp
8010291d:	c3                   	ret    
8010291e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102920:	83 e0 7f             	and    $0x7f,%eax
80102923:	85 db                	test   %ebx,%ebx
80102925:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102928:	0f b6 82 00 88 10 80 	movzbl -0x7fef7800(%edx),%eax
8010292f:	83 c8 40             	or     $0x40,%eax
80102932:	0f b6 c0             	movzbl %al,%eax
80102935:	f7 d0                	not    %eax
80102937:	21 c1                	and    %eax,%ecx
    return 0;
80102939:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010293b:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102941:	5b                   	pop    %ebx
80102942:	5d                   	pop    %ebp
80102943:	c3                   	ret    
80102944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102948:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010294b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010294d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    return 0;
80102953:	c3                   	ret    
80102954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102958:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010295b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010295e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010295f:	83 f9 1a             	cmp    $0x1a,%ecx
80102962:	0f 42 c2             	cmovb  %edx,%eax
}
80102965:	5d                   	pop    %ebp
80102966:	c3                   	ret    
80102967:	89 f6                	mov    %esi,%esi
80102969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102975:	c3                   	ret    
80102976:	8d 76 00             	lea    0x0(%esi),%esi
80102979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102980 <kbdintr>:

void
kbdintr(void)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102986:	68 a0 28 10 80       	push   $0x801028a0
8010298b:	e8 70 df ff ff       	call   80100900 <consoleintr>
}
80102990:	83 c4 10             	add    $0x10,%esp
80102993:	c9                   	leave  
80102994:	c3                   	ret    
80102995:	66 90                	xchg   %ax,%ax
80102997:	66 90                	xchg   %ax,%ax
80102999:	66 90                	xchg   %ax,%ax
8010299b:	66 90                	xchg   %ax,%ax
8010299d:	66 90                	xchg   %ax,%ax
8010299f:	90                   	nop

801029a0 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
801029a0:	a1 dc 41 11 80       	mov    0x801141dc,%eax
{
801029a5:	55                   	push   %ebp
801029a6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029a8:	85 c0                	test   %eax,%eax
801029aa:	0f 84 c8 00 00 00    	je     80102a78 <lapicinit+0xd8>
  lapic[index] = value;
801029b0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029b7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029bd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ca:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029d1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029de:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029eb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029fe:	8b 50 30             	mov    0x30(%eax),%edx
80102a01:	c1 ea 10             	shr    $0x10,%edx
80102a04:	80 fa 03             	cmp    $0x3,%dl
80102a07:	77 77                	ja     80102a80 <lapicinit+0xe0>
  lapic[index] = value;
80102a09:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a10:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a13:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a16:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a1d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a20:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a23:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a2a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a30:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a37:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a3d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a4a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a51:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a54:	8b 50 20             	mov    0x20(%eax),%edx
80102a57:	89 f6                	mov    %esi,%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a60:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a66:	80 e6 10             	and    $0x10,%dh
80102a69:	75 f5                	jne    80102a60 <lapicinit+0xc0>
  lapic[index] = value;
80102a6b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a72:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a75:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a78:	5d                   	pop    %ebp
80102a79:	c3                   	ret    
80102a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102a80:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a87:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8a:	8b 50 20             	mov    0x20(%eax),%edx
80102a8d:	e9 77 ff ff ff       	jmp    80102a09 <lapicinit+0x69>
80102a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102aa0 <cpunum>:

int
cpunum(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102aa5:	9c                   	pushf  
80102aa6:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102aa7:	f6 c4 02             	test   $0x2,%ah
80102aaa:	74 12                	je     80102abe <cpunum+0x1e>
    static int n;
    if(n++ == 0)
80102aac:	a1 b8 c5 10 80       	mov    0x8010c5b8,%eax
80102ab1:	8d 50 01             	lea    0x1(%eax),%edx
80102ab4:	85 c0                	test   %eax,%eax
80102ab6:	89 15 b8 c5 10 80    	mov    %edx,0x8010c5b8
80102abc:	74 62                	je     80102b20 <cpunum+0x80>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
80102abe:	a1 dc 41 11 80       	mov    0x801141dc,%eax
80102ac3:	85 c0                	test   %eax,%eax
80102ac5:	74 49                	je     80102b10 <cpunum+0x70>
    return 0;

  apicid = lapic[ID] >> 24;
80102ac7:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
80102aca:	8b 35 c0 48 11 80    	mov    0x801148c0,%esi
  apicid = lapic[ID] >> 24;
80102ad0:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102ad3:	85 f6                	test   %esi,%esi
80102ad5:	7e 5e                	jle    80102b35 <cpunum+0x95>
    if (cpus[i].apicid == apicid)
80102ad7:	0f b6 05 e0 42 11 80 	movzbl 0x801142e0,%eax
80102ade:	39 c3                	cmp    %eax,%ebx
80102ae0:	74 2e                	je     80102b10 <cpunum+0x70>
80102ae2:	ba 9c 43 11 80       	mov    $0x8011439c,%edx
  for (i = 0; i < ncpu; ++i) {
80102ae7:	31 c0                	xor    %eax,%eax
80102ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102af0:	83 c0 01             	add    $0x1,%eax
80102af3:	39 f0                	cmp    %esi,%eax
80102af5:	74 3e                	je     80102b35 <cpunum+0x95>
    if (cpus[i].apicid == apicid)
80102af7:	0f b6 0a             	movzbl (%edx),%ecx
80102afa:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102b00:	39 d9                	cmp    %ebx,%ecx
80102b02:	75 ec                	jne    80102af0 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102b04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b07:	5b                   	pop    %ebx
80102b08:	5e                   	pop    %esi
80102b09:	5d                   	pop    %ebp
80102b0a:	c3                   	ret    
80102b0b:	90                   	nop
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b10:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80102b13:	31 c0                	xor    %eax,%eax
}
80102b15:	5b                   	pop    %ebx
80102b16:	5e                   	pop    %esi
80102b17:	5d                   	pop    %ebp
80102b18:	c3                   	ret    
80102b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("cpu called from %x with interrupts enabled\n",
80102b20:	83 ec 08             	sub    $0x8,%esp
80102b23:	ff 75 04             	pushl  0x4(%ebp)
80102b26:	68 00 89 10 80       	push   $0x80108900
80102b2b:	e8 20 dc ff ff       	call   80100750 <cprintf>
80102b30:	83 c4 10             	add    $0x10,%esp
80102b33:	eb 89                	jmp    80102abe <cpunum+0x1e>
  panic("unknown apicid\n");
80102b35:	83 ec 0c             	sub    $0xc,%esp
80102b38:	68 2c 89 10 80       	push   $0x8010892c
80102b3d:	e8 3e d9 ff ff       	call   80100480 <panic>
80102b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b50 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b50:	a1 dc 41 11 80       	mov    0x801141dc,%eax
{
80102b55:	55                   	push   %ebp
80102b56:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b58:	85 c0                	test   %eax,%eax
80102b5a:	74 0d                	je     80102b69 <lapiceoi+0x19>
  lapic[index] = value;
80102b5c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b63:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b66:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b69:	5d                   	pop    %ebp
80102b6a:	c3                   	ret    
80102b6b:	90                   	nop
80102b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b70 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
}
80102b73:	5d                   	pop    %ebp
80102b74:	c3                   	ret    
80102b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b80:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b81:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b86:	ba 70 00 00 00       	mov    $0x70,%edx
80102b8b:	89 e5                	mov    %esp,%ebp
80102b8d:	53                   	push   %ebx
80102b8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b94:	ee                   	out    %al,(%dx)
80102b95:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b9a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b9f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ba0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ba2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ba5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102bab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102bb0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102bb3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bb5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102bb8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102bbe:	a1 dc 41 11 80       	mov    0x801141dc,%eax
80102bc3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bc9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bcc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102bd3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bd9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102be0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102be3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102be6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bf5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bf8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bfe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c01:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c07:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102c0a:	5b                   	pop    %ebx
80102c0b:	5d                   	pop    %ebp
80102c0c:	c3                   	ret    
80102c0d:	8d 76 00             	lea    0x0(%esi),%esi

80102c10 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102c10:	55                   	push   %ebp
80102c11:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c16:	ba 70 00 00 00       	mov    $0x70,%edx
80102c1b:	89 e5                	mov    %esp,%ebp
80102c1d:	57                   	push   %edi
80102c1e:	56                   	push   %esi
80102c1f:	53                   	push   %ebx
80102c20:	83 ec 4c             	sub    $0x4c,%esp
80102c23:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c24:	ba 71 00 00 00       	mov    $0x71,%edx
80102c29:	ec                   	in     (%dx),%al
80102c2a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c32:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c35:	8d 76 00             	lea    0x0(%esi),%esi
80102c38:	31 c0                	xor    %eax,%eax
80102c3a:	89 da                	mov    %ebx,%edx
80102c3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c42:	89 ca                	mov    %ecx,%edx
80102c44:	ec                   	in     (%dx),%al
80102c45:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c48:	89 da                	mov    %ebx,%edx
80102c4a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c50:	89 ca                	mov    %ecx,%edx
80102c52:	ec                   	in     (%dx),%al
80102c53:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c56:	89 da                	mov    %ebx,%edx
80102c58:	b8 04 00 00 00       	mov    $0x4,%eax
80102c5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5e:	89 ca                	mov    %ecx,%edx
80102c60:	ec                   	in     (%dx),%al
80102c61:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c64:	89 da                	mov    %ebx,%edx
80102c66:	b8 07 00 00 00       	mov    $0x7,%eax
80102c6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6c:	89 ca                	mov    %ecx,%edx
80102c6e:	ec                   	in     (%dx),%al
80102c6f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c72:	89 da                	mov    %ebx,%edx
80102c74:	b8 08 00 00 00       	mov    $0x8,%eax
80102c79:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7a:	89 ca                	mov    %ecx,%edx
80102c7c:	ec                   	in     (%dx),%al
80102c7d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c7f:	89 da                	mov    %ebx,%edx
80102c81:	b8 09 00 00 00       	mov    $0x9,%eax
80102c86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c87:	89 ca                	mov    %ecx,%edx
80102c89:	ec                   	in     (%dx),%al
80102c8a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c8c:	89 da                	mov    %ebx,%edx
80102c8e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c94:	89 ca                	mov    %ecx,%edx
80102c96:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c97:	84 c0                	test   %al,%al
80102c99:	78 9d                	js     80102c38 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c9b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c9f:	89 fa                	mov    %edi,%edx
80102ca1:	0f b6 fa             	movzbl %dl,%edi
80102ca4:	89 f2                	mov    %esi,%edx
80102ca6:	0f b6 f2             	movzbl %dl,%esi
80102ca9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cac:	89 da                	mov    %ebx,%edx
80102cae:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102cb1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102cb4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102cb8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102cbb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102cbf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102cc2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102cc6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102cc9:	31 c0                	xor    %eax,%eax
80102ccb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccc:	89 ca                	mov    %ecx,%edx
80102cce:	ec                   	in     (%dx),%al
80102ccf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd2:	89 da                	mov    %ebx,%edx
80102cd4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102cd7:	b8 02 00 00 00       	mov    $0x2,%eax
80102cdc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cdd:	89 ca                	mov    %ecx,%edx
80102cdf:	ec                   	in     (%dx),%al
80102ce0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce3:	89 da                	mov    %ebx,%edx
80102ce5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ce8:	b8 04 00 00 00       	mov    $0x4,%eax
80102ced:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cee:	89 ca                	mov    %ecx,%edx
80102cf0:	ec                   	in     (%dx),%al
80102cf1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf4:	89 da                	mov    %ebx,%edx
80102cf6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102cf9:	b8 07 00 00 00       	mov    $0x7,%eax
80102cfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cff:	89 ca                	mov    %ecx,%edx
80102d01:	ec                   	in     (%dx),%al
80102d02:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d05:	89 da                	mov    %ebx,%edx
80102d07:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d0a:	b8 08 00 00 00       	mov    $0x8,%eax
80102d0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d10:	89 ca                	mov    %ecx,%edx
80102d12:	ec                   	in     (%dx),%al
80102d13:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d16:	89 da                	mov    %ebx,%edx
80102d18:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d1b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d20:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d21:	89 ca                	mov    %ecx,%edx
80102d23:	ec                   	in     (%dx),%al
80102d24:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d27:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102d2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d2d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d30:	6a 18                	push   $0x18
80102d32:	50                   	push   %eax
80102d33:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d36:	50                   	push   %eax
80102d37:	e8 14 22 00 00       	call   80104f50 <memcmp>
80102d3c:	83 c4 10             	add    $0x10,%esp
80102d3f:	85 c0                	test   %eax,%eax
80102d41:	0f 85 f1 fe ff ff    	jne    80102c38 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d47:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102d4b:	75 78                	jne    80102dc5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d50:	89 c2                	mov    %eax,%edx
80102d52:	83 e0 0f             	and    $0xf,%eax
80102d55:	c1 ea 04             	shr    $0x4,%edx
80102d58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d5e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d61:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d64:	89 c2                	mov    %eax,%edx
80102d66:	83 e0 0f             	and    $0xf,%eax
80102d69:	c1 ea 04             	shr    $0x4,%edx
80102d6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d72:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d75:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d78:	89 c2                	mov    %eax,%edx
80102d7a:	83 e0 0f             	and    $0xf,%eax
80102d7d:	c1 ea 04             	shr    $0x4,%edx
80102d80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d86:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d8c:	89 c2                	mov    %eax,%edx
80102d8e:	83 e0 0f             	and    $0xf,%eax
80102d91:	c1 ea 04             	shr    $0x4,%edx
80102d94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102da0:	89 c2                	mov    %eax,%edx
80102da2:	83 e0 0f             	and    $0xf,%eax
80102da5:	c1 ea 04             	shr    $0x4,%edx
80102da8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102db1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102db4:	89 c2                	mov    %eax,%edx
80102db6:	83 e0 0f             	and    $0xf,%eax
80102db9:	c1 ea 04             	shr    $0x4,%edx
80102dbc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dbf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dc2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102dc5:	8b 75 08             	mov    0x8(%ebp),%esi
80102dc8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102dcb:	89 06                	mov    %eax,(%esi)
80102dcd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102dd0:	89 46 04             	mov    %eax,0x4(%esi)
80102dd3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102dd6:	89 46 08             	mov    %eax,0x8(%esi)
80102dd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ddc:	89 46 0c             	mov    %eax,0xc(%esi)
80102ddf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102de2:	89 46 10             	mov    %eax,0x10(%esi)
80102de5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102de8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102deb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102df2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102df5:	5b                   	pop    %ebx
80102df6:	5e                   	pop    %esi
80102df7:	5f                   	pop    %edi
80102df8:	5d                   	pop    %ebp
80102df9:	c3                   	ret    
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e00:	8b 0d 28 42 11 80    	mov    0x80114228,%ecx
80102e06:	85 c9                	test   %ecx,%ecx
80102e08:	0f 8e 8a 00 00 00    	jle    80102e98 <install_trans+0x98>
{
80102e0e:	55                   	push   %ebp
80102e0f:	89 e5                	mov    %esp,%ebp
80102e11:	57                   	push   %edi
80102e12:	56                   	push   %esi
80102e13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102e14:	31 db                	xor    %ebx,%ebx
{
80102e16:	83 ec 0c             	sub    $0xc,%esp
80102e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e20:	a1 14 42 11 80       	mov    0x80114214,%eax
80102e25:	83 ec 08             	sub    $0x8,%esp
80102e28:	01 d8                	add    %ebx,%eax
80102e2a:	83 c0 01             	add    $0x1,%eax
80102e2d:	50                   	push   %eax
80102e2e:	ff 35 24 42 11 80    	pushl  0x80114224
80102e34:	e8 57 d3 ff ff       	call   80100190 <bread>
80102e39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e3b:	58                   	pop    %eax
80102e3c:	5a                   	pop    %edx
80102e3d:	ff 34 9d 2c 42 11 80 	pushl  -0x7feebdd4(,%ebx,4)
80102e44:	ff 35 24 42 11 80    	pushl  0x80114224
  for (tail = 0; tail < log.lh.n; tail++) {
80102e4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e4d:	e8 3e d3 ff ff       	call   80100190 <bread>
80102e52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e54:	8d 47 18             	lea    0x18(%edi),%eax
80102e57:	83 c4 0c             	add    $0xc,%esp
80102e5a:	68 00 02 00 00       	push   $0x200
80102e5f:	50                   	push   %eax
80102e60:	8d 46 18             	lea    0x18(%esi),%eax
80102e63:	50                   	push   %eax
80102e64:	e8 47 21 00 00       	call   80104fb0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e69:	89 34 24             	mov    %esi,(%esp)
80102e6c:	e8 5f d3 ff ff       	call   801001d0 <bwrite>
    brelse(lbuf);
80102e71:	89 3c 24             	mov    %edi,(%esp)
80102e74:	e8 87 d3 ff ff       	call   80100200 <brelse>
    brelse(dbuf);
80102e79:	89 34 24             	mov    %esi,(%esp)
80102e7c:	e8 7f d3 ff ff       	call   80100200 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e81:	83 c4 10             	add    $0x10,%esp
80102e84:	39 1d 28 42 11 80    	cmp    %ebx,0x80114228
80102e8a:	7f 94                	jg     80102e20 <install_trans+0x20>
  }
}
80102e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e8f:	5b                   	pop    %ebx
80102e90:	5e                   	pop    %esi
80102e91:	5f                   	pop    %edi
80102e92:	5d                   	pop    %ebp
80102e93:	c3                   	ret    
80102e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e98:	f3 c3                	repz ret 
80102e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ea0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	53                   	push   %ebx
80102ea4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ea7:	ff 35 14 42 11 80    	pushl  0x80114214
80102ead:	ff 35 24 42 11 80    	pushl  0x80114224
80102eb3:	e8 d8 d2 ff ff       	call   80100190 <bread>
80102eb8:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102eba:	a1 28 42 11 80       	mov    0x80114228,%eax
  for (i = 0; i < log.lh.n; i++) {
80102ebf:	83 c4 10             	add    $0x10,%esp
  hb->n = log.lh.n;
80102ec2:	89 43 18             	mov    %eax,0x18(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ec5:	a1 28 42 11 80       	mov    0x80114228,%eax
80102eca:	85 c0                	test   %eax,%eax
80102ecc:	7e 18                	jle    80102ee6 <write_head+0x46>
80102ece:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ed0:	8b 0c 95 2c 42 11 80 	mov    -0x7feebdd4(,%edx,4),%ecx
80102ed7:	89 4c 93 1c          	mov    %ecx,0x1c(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102edb:	83 c2 01             	add    $0x1,%edx
80102ede:	39 15 28 42 11 80    	cmp    %edx,0x80114228
80102ee4:	7f ea                	jg     80102ed0 <write_head+0x30>
  }
  bwrite(buf);
80102ee6:	83 ec 0c             	sub    $0xc,%esp
80102ee9:	53                   	push   %ebx
80102eea:	e8 e1 d2 ff ff       	call   801001d0 <bwrite>
  brelse(buf);
80102eef:	89 1c 24             	mov    %ebx,(%esp)
80102ef2:	e8 09 d3 ff ff       	call   80100200 <brelse>
}
80102ef7:	83 c4 10             	add    $0x10,%esp
80102efa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102efd:	c9                   	leave  
80102efe:	c3                   	ret    
80102eff:	90                   	nop

80102f00 <initlog>:
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	53                   	push   %ebx
80102f04:	83 ec 2c             	sub    $0x2c,%esp
80102f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102f0a:	68 3c 89 10 80       	push   $0x8010893c
80102f0f:	68 e0 41 11 80       	push   $0x801141e0
80102f14:	e8 27 1b 00 00       	call   80104a40 <initlock>
  readsb(dev, &sb);
80102f19:	58                   	pop    %eax
80102f1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f1d:	5a                   	pop    %edx
80102f1e:	50                   	push   %eax
80102f1f:	53                   	push   %ebx
80102f20:	e8 eb e5 ff ff       	call   80101510 <readsb>
  log.size = sb.nlog;
80102f25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102f2b:	59                   	pop    %ecx
  log.dev = dev;
80102f2c:	89 1d 24 42 11 80    	mov    %ebx,0x80114224
  log.size = sb.nlog;
80102f32:	89 15 18 42 11 80    	mov    %edx,0x80114218
  log.start = sb.logstart;
80102f38:	a3 14 42 11 80       	mov    %eax,0x80114214
  struct buf *buf = bread(log.dev, log.start);
80102f3d:	5a                   	pop    %edx
80102f3e:	50                   	push   %eax
80102f3f:	53                   	push   %ebx
80102f40:	e8 4b d2 ff ff       	call   80100190 <bread>
  log.lh.n = lh->n;
80102f45:	8b 58 18             	mov    0x18(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f48:	83 c4 10             	add    $0x10,%esp
80102f4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102f4d:	89 1d 28 42 11 80    	mov    %ebx,0x80114228
  for (i = 0; i < log.lh.n; i++) {
80102f53:	7e 1c                	jle    80102f71 <initlog+0x71>
80102f55:	c1 e3 02             	shl    $0x2,%ebx
80102f58:	31 d2                	xor    %edx,%edx
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102f60:	8b 4c 10 1c          	mov    0x1c(%eax,%edx,1),%ecx
80102f64:	83 c2 04             	add    $0x4,%edx
80102f67:	89 8a 28 42 11 80    	mov    %ecx,-0x7feebdd8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102f6d:	39 d3                	cmp    %edx,%ebx
80102f6f:	75 ef                	jne    80102f60 <initlog+0x60>
  brelse(buf);
80102f71:	83 ec 0c             	sub    $0xc,%esp
80102f74:	50                   	push   %eax
80102f75:	e8 86 d2 ff ff       	call   80100200 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f7a:	e8 81 fe ff ff       	call   80102e00 <install_trans>
  log.lh.n = 0;
80102f7f:	c7 05 28 42 11 80 00 	movl   $0x0,0x80114228
80102f86:	00 00 00 
  write_head(); // clear the log
80102f89:	e8 12 ff ff ff       	call   80102ea0 <write_head>
}
80102f8e:	83 c4 10             	add    $0x10,%esp
80102f91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f94:	c9                   	leave  
80102f95:	c3                   	ret    
80102f96:	8d 76 00             	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102fa6:	68 e0 41 11 80       	push   $0x801141e0
80102fab:	e8 b0 1a 00 00       	call   80104a60 <acquire>
80102fb0:	83 c4 10             	add    $0x10,%esp
80102fb3:	eb 18                	jmp    80102fcd <begin_op+0x2d>
80102fb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102fb8:	83 ec 08             	sub    $0x8,%esp
80102fbb:	68 e0 41 11 80       	push   $0x801141e0
80102fc0:	68 e0 41 11 80       	push   $0x801141e0
80102fc5:	e8 e6 12 00 00       	call   801042b0 <sleep>
80102fca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102fcd:	a1 20 42 11 80       	mov    0x80114220,%eax
80102fd2:	85 c0                	test   %eax,%eax
80102fd4:	75 e2                	jne    80102fb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102fd6:	a1 1c 42 11 80       	mov    0x8011421c,%eax
80102fdb:	8b 15 28 42 11 80    	mov    0x80114228,%edx
80102fe1:	83 c0 01             	add    $0x1,%eax
80102fe4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102fe7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102fea:	83 fa 1e             	cmp    $0x1e,%edx
80102fed:	7f c9                	jg     80102fb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ff2:	a3 1c 42 11 80       	mov    %eax,0x8011421c
      release(&log.lock);
80102ff7:	68 e0 41 11 80       	push   $0x801141e0
80102ffc:	e8 1f 1c 00 00       	call   80104c20 <release>
      break;
    }
  }
}
80103001:	83 c4 10             	add    $0x10,%esp
80103004:	c9                   	leave  
80103005:	c3                   	ret    
80103006:	8d 76 00             	lea    0x0(%esi),%esi
80103009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103010 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	57                   	push   %edi
80103014:	56                   	push   %esi
80103015:	53                   	push   %ebx
80103016:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103019:	68 e0 41 11 80       	push   $0x801141e0
8010301e:	e8 3d 1a 00 00       	call   80104a60 <acquire>
  log.outstanding -= 1;
80103023:	a1 1c 42 11 80       	mov    0x8011421c,%eax
  if(log.committing)
80103028:	8b 35 20 42 11 80    	mov    0x80114220,%esi
8010302e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103031:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103034:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103036:	89 1d 1c 42 11 80    	mov    %ebx,0x8011421c
  if(log.committing)
8010303c:	0f 85 1a 01 00 00    	jne    8010315c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103042:	85 db                	test   %ebx,%ebx
80103044:	0f 85 ee 00 00 00    	jne    80103138 <end_op+0x128>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
8010304a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010304d:	c7 05 20 42 11 80 01 	movl   $0x1,0x80114220
80103054:	00 00 00 
  release(&log.lock);
80103057:	68 e0 41 11 80       	push   $0x801141e0
8010305c:	e8 bf 1b 00 00       	call   80104c20 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103061:	8b 0d 28 42 11 80    	mov    0x80114228,%ecx
80103067:	83 c4 10             	add    $0x10,%esp
8010306a:	85 c9                	test   %ecx,%ecx
8010306c:	0f 8e 85 00 00 00    	jle    801030f7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103072:	a1 14 42 11 80       	mov    0x80114214,%eax
80103077:	83 ec 08             	sub    $0x8,%esp
8010307a:	01 d8                	add    %ebx,%eax
8010307c:	83 c0 01             	add    $0x1,%eax
8010307f:	50                   	push   %eax
80103080:	ff 35 24 42 11 80    	pushl  0x80114224
80103086:	e8 05 d1 ff ff       	call   80100190 <bread>
8010308b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010308d:	58                   	pop    %eax
8010308e:	5a                   	pop    %edx
8010308f:	ff 34 9d 2c 42 11 80 	pushl  -0x7feebdd4(,%ebx,4)
80103096:	ff 35 24 42 11 80    	pushl  0x80114224
  for (tail = 0; tail < log.lh.n; tail++) {
8010309c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010309f:	e8 ec d0 ff ff       	call   80100190 <bread>
801030a4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030a6:	8d 40 18             	lea    0x18(%eax),%eax
801030a9:	83 c4 0c             	add    $0xc,%esp
801030ac:	68 00 02 00 00       	push   $0x200
801030b1:	50                   	push   %eax
801030b2:	8d 46 18             	lea    0x18(%esi),%eax
801030b5:	50                   	push   %eax
801030b6:	e8 f5 1e 00 00       	call   80104fb0 <memmove>
    bwrite(to);  // write the log
801030bb:	89 34 24             	mov    %esi,(%esp)
801030be:	e8 0d d1 ff ff       	call   801001d0 <bwrite>
    brelse(from);
801030c3:	89 3c 24             	mov    %edi,(%esp)
801030c6:	e8 35 d1 ff ff       	call   80100200 <brelse>
    brelse(to);
801030cb:	89 34 24             	mov    %esi,(%esp)
801030ce:	e8 2d d1 ff ff       	call   80100200 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030d3:	83 c4 10             	add    $0x10,%esp
801030d6:	3b 1d 28 42 11 80    	cmp    0x80114228,%ebx
801030dc:	7c 94                	jl     80103072 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030de:	e8 bd fd ff ff       	call   80102ea0 <write_head>
    install_trans(); // Now install writes to home locations
801030e3:	e8 18 fd ff ff       	call   80102e00 <install_trans>
    log.lh.n = 0;
801030e8:	c7 05 28 42 11 80 00 	movl   $0x0,0x80114228
801030ef:	00 00 00 
    write_head();    // Erase the transaction from the log
801030f2:	e8 a9 fd ff ff       	call   80102ea0 <write_head>
    acquire(&log.lock);
801030f7:	83 ec 0c             	sub    $0xc,%esp
801030fa:	68 e0 41 11 80       	push   $0x801141e0
801030ff:	e8 5c 19 00 00       	call   80104a60 <acquire>
    wakeup(&log);
80103104:	c7 04 24 e0 41 11 80 	movl   $0x801141e0,(%esp)
    log.committing = 0;
8010310b:	c7 05 20 42 11 80 00 	movl   $0x0,0x80114220
80103112:	00 00 00 
    wakeup(&log);
80103115:	e8 46 13 00 00       	call   80104460 <wakeup>
    release(&log.lock);
8010311a:	c7 04 24 e0 41 11 80 	movl   $0x801141e0,(%esp)
80103121:	e8 fa 1a 00 00       	call   80104c20 <release>
80103126:	83 c4 10             	add    $0x10,%esp
}
80103129:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010312c:	5b                   	pop    %ebx
8010312d:	5e                   	pop    %esi
8010312e:	5f                   	pop    %edi
8010312f:	5d                   	pop    %ebp
80103130:	c3                   	ret    
80103131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103138:	83 ec 0c             	sub    $0xc,%esp
8010313b:	68 e0 41 11 80       	push   $0x801141e0
80103140:	e8 1b 13 00 00       	call   80104460 <wakeup>
  release(&log.lock);
80103145:	c7 04 24 e0 41 11 80 	movl   $0x801141e0,(%esp)
8010314c:	e8 cf 1a 00 00       	call   80104c20 <release>
80103151:	83 c4 10             	add    $0x10,%esp
}
80103154:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103157:	5b                   	pop    %ebx
80103158:	5e                   	pop    %esi
80103159:	5f                   	pop    %edi
8010315a:	5d                   	pop    %ebp
8010315b:	c3                   	ret    
    panic("log.committing");
8010315c:	83 ec 0c             	sub    $0xc,%esp
8010315f:	68 40 89 10 80       	push   $0x80108940
80103164:	e8 17 d3 ff ff       	call   80100480 <panic>
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103170 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	53                   	push   %ebx
80103174:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103177:	8b 15 28 42 11 80    	mov    0x80114228,%edx
{
8010317d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103180:	83 fa 1d             	cmp    $0x1d,%edx
80103183:	0f 8f 9d 00 00 00    	jg     80103226 <log_write+0xb6>
80103189:	a1 18 42 11 80       	mov    0x80114218,%eax
8010318e:	83 e8 01             	sub    $0x1,%eax
80103191:	39 c2                	cmp    %eax,%edx
80103193:	0f 8d 8d 00 00 00    	jge    80103226 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103199:	a1 1c 42 11 80       	mov    0x8011421c,%eax
8010319e:	85 c0                	test   %eax,%eax
801031a0:	0f 8e 8d 00 00 00    	jle    80103233 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801031a6:	83 ec 0c             	sub    $0xc,%esp
801031a9:	68 e0 41 11 80       	push   $0x801141e0
801031ae:	e8 ad 18 00 00       	call   80104a60 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801031b3:	8b 0d 28 42 11 80    	mov    0x80114228,%ecx
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	83 f9 00             	cmp    $0x0,%ecx
801031bf:	7e 57                	jle    80103218 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031c1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801031c4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031c6:	3b 15 2c 42 11 80    	cmp    0x8011422c,%edx
801031cc:	75 0b                	jne    801031d9 <log_write+0x69>
801031ce:	eb 38                	jmp    80103208 <log_write+0x98>
801031d0:	39 14 85 2c 42 11 80 	cmp    %edx,-0x7feebdd4(,%eax,4)
801031d7:	74 2f                	je     80103208 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801031d9:	83 c0 01             	add    $0x1,%eax
801031dc:	39 c1                	cmp    %eax,%ecx
801031de:	75 f0                	jne    801031d0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801031e0:	89 14 85 2c 42 11 80 	mov    %edx,-0x7feebdd4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801031e7:	83 c0 01             	add    $0x1,%eax
801031ea:	a3 28 42 11 80       	mov    %eax,0x80114228
  b->flags |= B_DIRTY; // prevent eviction
801031ef:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801031f2:	c7 45 08 e0 41 11 80 	movl   $0x801141e0,0x8(%ebp)
}
801031f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031fc:	c9                   	leave  
  release(&log.lock);
801031fd:	e9 1e 1a 00 00       	jmp    80104c20 <release>
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103208:	89 14 85 2c 42 11 80 	mov    %edx,-0x7feebdd4(,%eax,4)
8010320f:	eb de                	jmp    801031ef <log_write+0x7f>
80103211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103218:	8b 43 08             	mov    0x8(%ebx),%eax
8010321b:	a3 2c 42 11 80       	mov    %eax,0x8011422c
  if (i == log.lh.n)
80103220:	75 cd                	jne    801031ef <log_write+0x7f>
80103222:	31 c0                	xor    %eax,%eax
80103224:	eb c1                	jmp    801031e7 <log_write+0x77>
    panic("too big a transaction");
80103226:	83 ec 0c             	sub    $0xc,%esp
80103229:	68 4f 89 10 80       	push   $0x8010894f
8010322e:	e8 4d d2 ff ff       	call   80100480 <panic>
    panic("log_write outside of trans");
80103233:	83 ec 0c             	sub    $0xc,%esp
80103236:	68 65 89 10 80       	push   $0x80108965
8010323b:	e8 40 d2 ff ff       	call   80100480 <panic>

80103240 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpunum());
80103246:	e8 55 f8 ff ff       	call   80102aa0 <cpunum>
8010324b:	83 ec 08             	sub    $0x8,%esp
8010324e:	50                   	push   %eax
8010324f:	68 80 89 10 80       	push   $0x80108980
80103254:	e8 f7 d4 ff ff       	call   80100750 <cprintf>
  idtinit();       // load idt register
80103259:	e8 52 34 00 00       	call   801066b0 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010325e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103265:	b8 01 00 00 00       	mov    $0x1,%eax
8010326a:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80103271:	e8 ba 0c 00 00       	call   80103f30 <scheduler>
80103276:	8d 76 00             	lea    0x0(%esi),%esi
80103279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103280 <mpenter>:
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103286:	e8 f5 45 00 00       	call   80107880 <switchkvm>
  seginit();
8010328b:	e8 80 44 00 00       	call   80107710 <seginit>
  lapicinit();
80103290:	e8 0b f7 ff ff       	call   801029a0 <lapicinit>
  mpmain();
80103295:	e8 a6 ff ff ff       	call   80103240 <mpmain>
8010329a:	66 90                	xchg   %ax,%ax
8010329c:	66 90                	xchg   %ax,%ax
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <main>:
{
801032a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801032a4:	83 e4 f0             	and    $0xfffffff0,%esp
801032a7:	ff 71 fc             	pushl  -0x4(%ecx)
801032aa:	55                   	push   %ebp
801032ab:	89 e5                	mov    %esp,%ebp
801032ad:	53                   	push   %ebx
801032ae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801032af:	83 ec 08             	sub    $0x8,%esp
801032b2:	68 00 00 40 80       	push   $0x80400000
801032b7:	68 00 9e 11 80       	push   $0x80119e00
801032bc:	e8 ef f3 ff ff       	call   801026b0 <kinit1>
  kvmalloc();      // kernel page table
801032c1:	e8 9a 45 00 00       	call   80107860 <kvmalloc>
  mpinit();        // detect other processors
801032c6:	e8 c5 01 00 00       	call   80103490 <mpinit>
  lapicinit();     // interrupt controller
801032cb:	e8 d0 f6 ff ff       	call   801029a0 <lapicinit>
  seginit();       // segment descriptors
801032d0:	e8 3b 44 00 00       	call   80107710 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
801032d5:	e8 c6 f7 ff ff       	call   80102aa0 <cpunum>
801032da:	5a                   	pop    %edx
801032db:	59                   	pop    %ecx
801032dc:	50                   	push   %eax
801032dd:	68 91 89 10 80       	push   $0x80108991
801032e2:	e8 69 d4 ff ff       	call   80100750 <cprintf>
  picinit();       // another interrupt controller
801032e7:	e8 c4 03 00 00       	call   801036b0 <picinit>
  ioapicinit();    // another interrupt controller
801032ec:	e8 7f f1 ff ff       	call   80102470 <ioapicinit>
  consoleinit();   // console hardware
801032f1:	e8 ba d7 ff ff       	call   80100ab0 <consoleinit>
  uartinit();      // serial port
801032f6:	e8 e5 36 00 00       	call   801069e0 <uartinit>
  pinit();         // process table
801032fb:	e8 60 09 00 00       	call   80103c60 <pinit>
  tvinit();        // trap vectors
80103300:	e8 2b 33 00 00       	call   80106630 <tvinit>
  binit();         // buffer cache
80103305:	e8 06 ce ff ff       	call   80100110 <binit>
  fileinit();      // file table
8010330a:	e8 31 db ff ff       	call   80100e40 <fileinit>
  ideinit();       // disk
8010330f:	e8 3c ef ff ff       	call   80102250 <ideinit>
  if(!ismp)
80103314:	8b 1d c4 42 11 80    	mov    0x801142c4,%ebx
8010331a:	83 c4 10             	add    $0x10,%esp
8010331d:	85 db                	test   %ebx,%ebx
8010331f:	0f 84 d4 00 00 00    	je     801033f9 <main+0x159>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103325:	83 ec 04             	sub    $0x4,%esp
80103328:	68 8a 00 00 00       	push   $0x8a
8010332d:	68 8c c4 10 80       	push   $0x8010c48c
80103332:	68 00 70 00 80       	push   $0x80007000
80103337:	e8 74 1c 00 00       	call   80104fb0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010333c:	69 05 c0 48 11 80 bc 	imul   $0xbc,0x801148c0,%eax
80103343:	00 00 00 
80103346:	83 c4 10             	add    $0x10,%esp
80103349:	05 e0 42 11 80       	add    $0x801142e0,%eax
8010334e:	3d e0 42 11 80       	cmp    $0x801142e0,%eax
80103353:	76 7e                	jbe    801033d3 <main+0x133>
80103355:	bb e0 42 11 80       	mov    $0x801142e0,%ebx
8010335a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(c == cpus+cpunum())  // We've started already.
80103360:	e8 3b f7 ff ff       	call   80102aa0 <cpunum>
80103365:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010336b:	05 e0 42 11 80       	add    $0x801142e0,%eax
80103370:	39 c3                	cmp    %eax,%ebx
80103372:	74 46                	je     801033ba <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103374:	e8 07 f4 ff ff       	call   80102780 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103379:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-4) = stack + KSTACKSIZE;
8010337c:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103381:	c7 05 f8 6f 00 80 80 	movl   $0x80103280,0x80006ff8
80103388:	32 10 80 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010338b:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103390:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103397:	b0 10 00 
    lapicstartap(c->apicid, V2P(code));
8010339a:	68 00 70 00 00       	push   $0x7000
8010339f:	0f b6 03             	movzbl (%ebx),%eax
801033a2:	50                   	push   %eax
801033a3:	e8 d8 f7 ff ff       	call   80102b80 <lapicstartap>
801033a8:	83 c4 10             	add    $0x10,%esp
801033ab:	90                   	nop
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801033b0:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
801033b6:	85 c0                	test   %eax,%eax
801033b8:	74 f6                	je     801033b0 <main+0x110>
  for(c = cpus; c < cpus+ncpu; c++){
801033ba:	69 05 c0 48 11 80 bc 	imul   $0xbc,0x801148c0,%eax
801033c1:	00 00 00 
801033c4:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
801033ca:	05 e0 42 11 80       	add    $0x801142e0,%eax
801033cf:	39 c3                	cmp    %eax,%ebx
801033d1:	72 8d                	jb     80103360 <main+0xc0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033d3:	83 ec 08             	sub    $0x8,%esp
801033d6:	68 00 00 40 80       	push   $0x80400000
801033db:	68 00 00 40 80       	push   $0x80400000
801033e0:	e8 3b f3 ff ff       	call   80102720 <kinit2>
  initsem();      //semaphor  ljn 在用户初始化之前 初始化信号量
801033e5:	e8 86 18 00 00       	call   80104c70 <initsem>
  slab_init();    //init slab ljn 初始化slab
801033ea:	e8 51 4a 00 00       	call   80107e40 <slab_init>
  userinit();      // first user process
801033ef:	e8 8c 08 00 00       	call   80103c80 <userinit>
  mpmain();        // finish this processor's setup
801033f4:	e8 47 fe ff ff       	call   80103240 <mpmain>
    timerinit();   // uniprocessor timer
801033f9:	e8 d2 31 00 00       	call   801065d0 <timerinit>
801033fe:	e9 22 ff ff ff       	jmp    80103325 <main+0x85>
80103403:	66 90                	xchg   %ax,%ax
80103405:	66 90                	xchg   %ax,%ax
80103407:	66 90                	xchg   %ax,%ax
80103409:	66 90                	xchg   %ax,%ax
8010340b:	66 90                	xchg   %ax,%ax
8010340d:	66 90                	xchg   %ax,%ax
8010340f:	90                   	nop

80103410 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103415:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010341b:	53                   	push   %ebx
  e = addr+len;
8010341c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010341f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103422:	39 de                	cmp    %ebx,%esi
80103424:	72 10                	jb     80103436 <mpsearch1+0x26>
80103426:	eb 50                	jmp    80103478 <mpsearch1+0x68>
80103428:	90                   	nop
80103429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103430:	39 fb                	cmp    %edi,%ebx
80103432:	89 fe                	mov    %edi,%esi
80103434:	76 42                	jbe    80103478 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103436:	83 ec 04             	sub    $0x4,%esp
80103439:	8d 7e 10             	lea    0x10(%esi),%edi
8010343c:	6a 04                	push   $0x4
8010343e:	68 a8 89 10 80       	push   $0x801089a8
80103443:	56                   	push   %esi
80103444:	e8 07 1b 00 00       	call   80104f50 <memcmp>
80103449:	83 c4 10             	add    $0x10,%esp
8010344c:	85 c0                	test   %eax,%eax
8010344e:	75 e0                	jne    80103430 <mpsearch1+0x20>
80103450:	89 f1                	mov    %esi,%ecx
80103452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103458:	0f b6 11             	movzbl (%ecx),%edx
8010345b:	83 c1 01             	add    $0x1,%ecx
8010345e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103460:	39 f9                	cmp    %edi,%ecx
80103462:	75 f4                	jne    80103458 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103464:	84 c0                	test   %al,%al
80103466:	75 c8                	jne    80103430 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103468:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010346b:	89 f0                	mov    %esi,%eax
8010346d:	5b                   	pop    %ebx
8010346e:	5e                   	pop    %esi
8010346f:	5f                   	pop    %edi
80103470:	5d                   	pop    %ebp
80103471:	c3                   	ret    
80103472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103478:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010347b:	31 f6                	xor    %esi,%esi
}
8010347d:	89 f0                	mov    %esi,%eax
8010347f:	5b                   	pop    %ebx
80103480:	5e                   	pop    %esi
80103481:	5f                   	pop    %edi
80103482:	5d                   	pop    %ebp
80103483:	c3                   	ret    
80103484:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010348a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103490 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103499:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801034a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801034a7:	c1 e0 08             	shl    $0x8,%eax
801034aa:	09 d0                	or     %edx,%eax
801034ac:	c1 e0 04             	shl    $0x4,%eax
801034af:	85 c0                	test   %eax,%eax
801034b1:	75 1b                	jne    801034ce <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801034b3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801034ba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801034c1:	c1 e0 08             	shl    $0x8,%eax
801034c4:	09 d0                	or     %edx,%eax
801034c6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801034c9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801034ce:	ba 00 04 00 00       	mov    $0x400,%edx
801034d3:	e8 38 ff ff ff       	call   80103410 <mpsearch1>
801034d8:	85 c0                	test   %eax,%eax
801034da:	89 c7                	mov    %eax,%edi
801034dc:	0f 84 76 01 00 00    	je     80103658 <mpinit+0x1c8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034e2:	8b 5f 04             	mov    0x4(%edi),%ebx
801034e5:	85 db                	test   %ebx,%ebx
801034e7:	0f 84 e6 00 00 00    	je     801035d3 <mpinit+0x143>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801034ed:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801034f3:	83 ec 04             	sub    $0x4,%esp
801034f6:	6a 04                	push   $0x4
801034f8:	68 ad 89 10 80       	push   $0x801089ad
801034fd:	56                   	push   %esi
801034fe:	e8 4d 1a 00 00       	call   80104f50 <memcmp>
80103503:	83 c4 10             	add    $0x10,%esp
80103506:	85 c0                	test   %eax,%eax
80103508:	0f 85 c5 00 00 00    	jne    801035d3 <mpinit+0x143>
  if(conf->version != 1 && conf->version != 4)
8010350e:	0f b6 93 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%edx
80103515:	80 fa 01             	cmp    $0x1,%dl
80103518:	0f 95 c1             	setne  %cl
8010351b:	80 fa 04             	cmp    $0x4,%dl
8010351e:	0f 95 c2             	setne  %dl
80103521:	20 ca                	and    %cl,%dl
80103523:	0f 85 aa 00 00 00    	jne    801035d3 <mpinit+0x143>
  if(sum((uchar*)conf, conf->length) != 0)
80103529:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
80103530:	66 85 c9             	test   %cx,%cx
80103533:	74 1f                	je     80103554 <mpinit+0xc4>
80103535:	01 f1                	add    %esi,%ecx
80103537:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010353a:	89 f2                	mov    %esi,%edx
8010353c:	89 cb                	mov    %ecx,%ebx
8010353e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103540:	0f b6 0a             	movzbl (%edx),%ecx
80103543:	83 c2 01             	add    $0x1,%edx
80103546:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103548:	39 da                	cmp    %ebx,%edx
8010354a:	75 f4                	jne    80103540 <mpinit+0xb0>
8010354c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010354f:	84 c0                	test   %al,%al
80103551:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103554:	85 f6                	test   %esi,%esi
80103556:	74 7b                	je     801035d3 <mpinit+0x143>
80103558:	84 d2                	test   %dl,%dl
8010355a:	75 77                	jne    801035d3 <mpinit+0x143>
    return;
  ismp = 1;
8010355c:	c7 05 c4 42 11 80 01 	movl   $0x1,0x801142c4
80103563:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103566:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010356c:	a3 dc 41 11 80       	mov    %eax,0x801141dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103571:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103578:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
8010357e:	01 d6                	add    %edx,%esi
80103580:	39 f0                	cmp    %esi,%eax
80103582:	0f 83 a8 00 00 00    	jae    80103630 <mpinit+0x1a0>
80103588:	90                   	nop
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103590:	80 38 04             	cmpb   $0x4,(%eax)
80103593:	0f 87 87 00 00 00    	ja     80103620 <mpinit+0x190>
80103599:	0f b6 10             	movzbl (%eax),%edx
8010359c:	ff 24 95 b4 89 10 80 	jmp    *-0x7fef764c(,%edx,4)
801035a3:	90                   	nop
801035a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801035a8:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035ab:	39 c6                	cmp    %eax,%esi
801035ad:	77 e1                	ja     80103590 <mpinit+0x100>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
801035af:	a1 c4 42 11 80       	mov    0x801142c4,%eax
801035b4:	85 c0                	test   %eax,%eax
801035b6:	75 78                	jne    80103630 <mpinit+0x1a0>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801035b8:	c7 05 c0 48 11 80 01 	movl   $0x1,0x801148c0
801035bf:	00 00 00 
    lapic = 0;
801035c2:	c7 05 dc 41 11 80 00 	movl   $0x0,0x801141dc
801035c9:	00 00 00 
    ioapicid = 0;
801035cc:	c6 05 c0 42 11 80 00 	movb   $0x0,0x801142c0
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801035d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035d6:	5b                   	pop    %ebx
801035d7:	5e                   	pop    %esi
801035d8:	5f                   	pop    %edi
801035d9:	5d                   	pop    %ebp
801035da:	c3                   	ret    
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
801035e0:	8b 15 c0 48 11 80    	mov    0x801148c0,%edx
801035e6:	83 fa 07             	cmp    $0x7,%edx
801035e9:	7f 19                	jg     80103604 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035eb:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801035ef:	69 da bc 00 00 00    	imul   $0xbc,%edx,%ebx
        ncpu++;
801035f5:	83 c2 01             	add    $0x1,%edx
801035f8:	89 15 c0 48 11 80    	mov    %edx,0x801148c0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035fe:	88 8b e0 42 11 80    	mov    %cl,-0x7feebd20(%ebx)
      p += sizeof(struct mpproc);
80103604:	83 c0 14             	add    $0x14,%eax
      continue;
80103607:	eb a2                	jmp    801035ab <mpinit+0x11b>
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103610:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103614:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103617:	88 15 c0 42 11 80    	mov    %dl,0x801142c0
      continue;
8010361d:	eb 8c                	jmp    801035ab <mpinit+0x11b>
8010361f:	90                   	nop
      ismp = 0;
80103620:	c7 05 c4 42 11 80 00 	movl   $0x0,0x801142c4
80103627:	00 00 00 
      break;
8010362a:	e9 7c ff ff ff       	jmp    801035ab <mpinit+0x11b>
8010362f:	90                   	nop
  if(mp->imcrp){
80103630:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
80103634:	74 9d                	je     801035d3 <mpinit+0x143>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103636:	b8 70 00 00 00       	mov    $0x70,%eax
8010363b:	ba 22 00 00 00       	mov    $0x22,%edx
80103640:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103641:	ba 23 00 00 00       	mov    $0x23,%edx
80103646:	ec                   	in     (%dx),%al
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103647:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010364a:	ee                   	out    %al,(%dx)
}
8010364b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010364e:	5b                   	pop    %ebx
8010364f:	5e                   	pop    %esi
80103650:	5f                   	pop    %edi
80103651:	5d                   	pop    %ebp
80103652:	c3                   	ret    
80103653:	90                   	nop
80103654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103658:	ba 00 00 01 00       	mov    $0x10000,%edx
8010365d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103662:	e8 a9 fd ff ff       	call   80103410 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103667:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103669:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010366b:	0f 85 71 fe ff ff    	jne    801034e2 <mpinit+0x52>
80103671:	e9 5d ff ff ff       	jmp    801035d3 <mpinit+0x143>
80103676:	66 90                	xchg   %ax,%ax
80103678:	66 90                	xchg   %ax,%ax
8010367a:	66 90                	xchg   %ax,%ax
8010367c:	66 90                	xchg   %ax,%ax
8010367e:	66 90                	xchg   %ax,%ax

80103680 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103680:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103681:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103686:	ba 21 00 00 00       	mov    $0x21,%edx
{
8010368b:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010368d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103690:	d3 c0                	rol    %cl,%eax
80103692:	66 23 05 00 c0 10 80 	and    0x8010c000,%ax
  irqmask = mask;
80103699:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
8010369f:	ee                   	out    %al,(%dx)
801036a0:	ba a1 00 00 00       	mov    $0xa1,%edx
  outb(IO_PIC2+1, mask >> 8);
801036a5:	66 c1 e8 08          	shr    $0x8,%ax
801036a9:	ee                   	out    %al,(%dx)
}
801036aa:	5d                   	pop    %ebp
801036ab:	c3                   	ret    
801036ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036b0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801036b0:	55                   	push   %ebp
801036b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036b6:	89 e5                	mov    %esp,%ebp
801036b8:	57                   	push   %edi
801036b9:	56                   	push   %esi
801036ba:	53                   	push   %ebx
801036bb:	bb 21 00 00 00       	mov    $0x21,%ebx
801036c0:	89 da                	mov    %ebx,%edx
801036c2:	ee                   	out    %al,(%dx)
801036c3:	b9 a1 00 00 00       	mov    $0xa1,%ecx
801036c8:	89 ca                	mov    %ecx,%edx
801036ca:	ee                   	out    %al,(%dx)
801036cb:	be 11 00 00 00       	mov    $0x11,%esi
801036d0:	ba 20 00 00 00       	mov    $0x20,%edx
801036d5:	89 f0                	mov    %esi,%eax
801036d7:	ee                   	out    %al,(%dx)
801036d8:	b8 20 00 00 00       	mov    $0x20,%eax
801036dd:	89 da                	mov    %ebx,%edx
801036df:	ee                   	out    %al,(%dx)
801036e0:	b8 04 00 00 00       	mov    $0x4,%eax
801036e5:	ee                   	out    %al,(%dx)
801036e6:	bf 03 00 00 00       	mov    $0x3,%edi
801036eb:	89 f8                	mov    %edi,%eax
801036ed:	ee                   	out    %al,(%dx)
801036ee:	ba a0 00 00 00       	mov    $0xa0,%edx
801036f3:	89 f0                	mov    %esi,%eax
801036f5:	ee                   	out    %al,(%dx)
801036f6:	b8 28 00 00 00       	mov    $0x28,%eax
801036fb:	89 ca                	mov    %ecx,%edx
801036fd:	ee                   	out    %al,(%dx)
801036fe:	b8 02 00 00 00       	mov    $0x2,%eax
80103703:	ee                   	out    %al,(%dx)
80103704:	89 f8                	mov    %edi,%eax
80103706:	ee                   	out    %al,(%dx)
80103707:	bf 68 00 00 00       	mov    $0x68,%edi
8010370c:	ba 20 00 00 00       	mov    $0x20,%edx
80103711:	89 f8                	mov    %edi,%eax
80103713:	ee                   	out    %al,(%dx)
80103714:	be 0a 00 00 00       	mov    $0xa,%esi
80103719:	89 f0                	mov    %esi,%eax
8010371b:	ee                   	out    %al,(%dx)
8010371c:	ba a0 00 00 00       	mov    $0xa0,%edx
80103721:	89 f8                	mov    %edi,%eax
80103723:	ee                   	out    %al,(%dx)
80103724:	89 f0                	mov    %esi,%eax
80103726:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103727:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
8010372e:	66 83 f8 ff          	cmp    $0xffff,%ax
80103732:	74 0a                	je     8010373e <picinit+0x8e>
80103734:	89 da                	mov    %ebx,%edx
80103736:	ee                   	out    %al,(%dx)
  outb(IO_PIC2+1, mask >> 8);
80103737:	66 c1 e8 08          	shr    $0x8,%ax
8010373b:	89 ca                	mov    %ecx,%edx
8010373d:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
8010373e:	5b                   	pop    %ebx
8010373f:	5e                   	pop    %esi
80103740:	5f                   	pop    %edi
80103741:	5d                   	pop    %ebp
80103742:	c3                   	ret    
80103743:	66 90                	xchg   %ax,%ax
80103745:	66 90                	xchg   %ax,%ax
80103747:	66 90                	xchg   %ax,%ax
80103749:	66 90                	xchg   %ax,%ax
8010374b:	66 90                	xchg   %ax,%ax
8010374d:	66 90                	xchg   %ax,%ax
8010374f:	90                   	nop

80103750 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	57                   	push   %edi
80103754:	56                   	push   %esi
80103755:	53                   	push   %ebx
80103756:	83 ec 0c             	sub    $0xc,%esp
80103759:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010375c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010375f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103765:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010376b:	e8 f0 d6 ff ff       	call   80100e60 <filealloc>
80103770:	85 c0                	test   %eax,%eax
80103772:	89 03                	mov    %eax,(%ebx)
80103774:	74 22                	je     80103798 <pipealloc+0x48>
80103776:	e8 e5 d6 ff ff       	call   80100e60 <filealloc>
8010377b:	85 c0                	test   %eax,%eax
8010377d:	89 06                	mov    %eax,(%esi)
8010377f:	74 3f                	je     801037c0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103781:	e8 fa ef ff ff       	call   80102780 <kalloc>
80103786:	85 c0                	test   %eax,%eax
80103788:	89 c7                	mov    %eax,%edi
8010378a:	75 54                	jne    801037e0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010378c:	8b 03                	mov    (%ebx),%eax
8010378e:	85 c0                	test   %eax,%eax
80103790:	75 34                	jne    801037c6 <pipealloc+0x76>
80103792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103798:	8b 06                	mov    (%esi),%eax
8010379a:	85 c0                	test   %eax,%eax
8010379c:	74 0c                	je     801037aa <pipealloc+0x5a>
    fileclose(*f1);
8010379e:	83 ec 0c             	sub    $0xc,%esp
801037a1:	50                   	push   %eax
801037a2:	e8 79 d7 ff ff       	call   80100f20 <fileclose>
801037a7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801037aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801037ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801037b2:	5b                   	pop    %ebx
801037b3:	5e                   	pop    %esi
801037b4:	5f                   	pop    %edi
801037b5:	5d                   	pop    %ebp
801037b6:	c3                   	ret    
801037b7:	89 f6                	mov    %esi,%esi
801037b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801037c0:	8b 03                	mov    (%ebx),%eax
801037c2:	85 c0                	test   %eax,%eax
801037c4:	74 e4                	je     801037aa <pipealloc+0x5a>
    fileclose(*f0);
801037c6:	83 ec 0c             	sub    $0xc,%esp
801037c9:	50                   	push   %eax
801037ca:	e8 51 d7 ff ff       	call   80100f20 <fileclose>
  if(*f1)
801037cf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801037d1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801037d4:	85 c0                	test   %eax,%eax
801037d6:	75 c6                	jne    8010379e <pipealloc+0x4e>
801037d8:	eb d0                	jmp    801037aa <pipealloc+0x5a>
801037da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801037e0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801037e3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801037ea:	00 00 00 
  p->writeopen = 1;
801037ed:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801037f4:	00 00 00 
  p->nwrite = 0;
801037f7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801037fe:	00 00 00 
  p->nread = 0;
80103801:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103808:	00 00 00 
  initlock(&p->lock, "pipe");
8010380b:	68 c8 89 10 80       	push   $0x801089c8
80103810:	50                   	push   %eax
80103811:	e8 2a 12 00 00       	call   80104a40 <initlock>
  (*f0)->type = FD_PIPE;
80103816:	8b 03                	mov    (%ebx),%eax
  return 0;
80103818:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010381b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103821:	8b 03                	mov    (%ebx),%eax
80103823:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103827:	8b 03                	mov    (%ebx),%eax
80103829:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010382d:	8b 03                	mov    (%ebx),%eax
8010382f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103832:	8b 06                	mov    (%esi),%eax
80103834:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010383a:	8b 06                	mov    (%esi),%eax
8010383c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103840:	8b 06                	mov    (%esi),%eax
80103842:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103846:	8b 06                	mov    (%esi),%eax
80103848:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010384b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010384e:	31 c0                	xor    %eax,%eax
}
80103850:	5b                   	pop    %ebx
80103851:	5e                   	pop    %esi
80103852:	5f                   	pop    %edi
80103853:	5d                   	pop    %ebp
80103854:	c3                   	ret    
80103855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103860 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	56                   	push   %esi
80103864:	53                   	push   %ebx
80103865:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103868:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010386b:	83 ec 0c             	sub    $0xc,%esp
8010386e:	53                   	push   %ebx
8010386f:	e8 ec 11 00 00       	call   80104a60 <acquire>
  if(writable){
80103874:	83 c4 10             	add    $0x10,%esp
80103877:	85 f6                	test   %esi,%esi
80103879:	74 45                	je     801038c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010387b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103881:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103884:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010388b:	00 00 00 
    wakeup(&p->nread);
8010388e:	50                   	push   %eax
8010388f:	e8 cc 0b 00 00       	call   80104460 <wakeup>
80103894:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103897:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010389d:	85 d2                	test   %edx,%edx
8010389f:	75 0a                	jne    801038ab <pipeclose+0x4b>
801038a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801038a7:	85 c0                	test   %eax,%eax
801038a9:	74 35                	je     801038e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801038ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801038ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038b1:	5b                   	pop    %ebx
801038b2:	5e                   	pop    %esi
801038b3:	5d                   	pop    %ebp
    release(&p->lock);
801038b4:	e9 67 13 00 00       	jmp    80104c20 <release>
801038b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801038c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801038c6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801038c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801038d0:	00 00 00 
    wakeup(&p->nwrite);
801038d3:	50                   	push   %eax
801038d4:	e8 87 0b 00 00       	call   80104460 <wakeup>
801038d9:	83 c4 10             	add    $0x10,%esp
801038dc:	eb b9                	jmp    80103897 <pipeclose+0x37>
801038de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801038e0:	83 ec 0c             	sub    $0xc,%esp
801038e3:	53                   	push   %ebx
801038e4:	e8 37 13 00 00       	call   80104c20 <release>
    kfree((char*)p);
801038e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801038ec:	83 c4 10             	add    $0x10,%esp
}
801038ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038f2:	5b                   	pop    %ebx
801038f3:	5e                   	pop    %esi
801038f4:	5d                   	pop    %ebp
    kfree((char*)p);
801038f5:	e9 86 ec ff ff       	jmp    80102580 <kfree>
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103900 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
80103905:	53                   	push   %ebx
80103906:	83 ec 28             	sub    $0x28,%esp
80103909:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010390c:	57                   	push   %edi
8010390d:	e8 4e 11 00 00       	call   80104a60 <acquire>
  for(i = 0; i < n; i++){
80103912:	8b 45 10             	mov    0x10(%ebp),%eax
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	85 c0                	test   %eax,%eax
8010391a:	0f 8e c6 00 00 00    	jle    801039e6 <pipewrite+0xe6>
80103920:	8b 45 0c             	mov    0xc(%ebp),%eax
80103923:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
80103929:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
8010392f:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103935:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103938:	03 45 10             	add    0x10(%ebp),%eax
8010393b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010393e:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103944:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010394a:	39 d1                	cmp    %edx,%ecx
8010394c:	0f 85 cf 00 00 00    	jne    80103a21 <pipewrite+0x121>
      if(p->readopen == 0 || proc->killed){
80103952:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
80103958:	85 d2                	test   %edx,%edx
8010395a:	0f 84 a8 00 00 00    	je     80103a08 <pipewrite+0x108>
80103960:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103967:	8b 42 24             	mov    0x24(%edx),%eax
8010396a:	85 c0                	test   %eax,%eax
8010396c:	74 25                	je     80103993 <pipewrite+0x93>
8010396e:	e9 95 00 00 00       	jmp    80103a08 <pipewrite+0x108>
80103973:	90                   	nop
80103974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103978:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010397e:	85 c0                	test   %eax,%eax
80103980:	0f 84 82 00 00 00    	je     80103a08 <pipewrite+0x108>
80103986:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010398c:	8b 40 24             	mov    0x24(%eax),%eax
8010398f:	85 c0                	test   %eax,%eax
80103991:	75 75                	jne    80103a08 <pipewrite+0x108>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103993:	83 ec 0c             	sub    $0xc,%esp
80103996:	56                   	push   %esi
80103997:	e8 c4 0a 00 00       	call   80104460 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010399c:	59                   	pop    %ecx
8010399d:	58                   	pop    %eax
8010399e:	57                   	push   %edi
8010399f:	53                   	push   %ebx
801039a0:	e8 0b 09 00 00       	call   801042b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039a5:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801039ab:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801039b1:	83 c4 10             	add    $0x10,%esp
801039b4:	05 00 02 00 00       	add    $0x200,%eax
801039b9:	39 c2                	cmp    %eax,%edx
801039bb:	74 bb                	je     80103978 <pipewrite+0x78>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039c0:	8d 4a 01             	lea    0x1(%edx),%ecx
801039c3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801039c7:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801039cd:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
801039d3:	0f b6 00             	movzbl (%eax),%eax
801039d6:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
801039da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(i = 0; i < n; i++){
801039dd:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801039e0:	0f 85 58 ff ff ff    	jne    8010393e <pipewrite+0x3e>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801039e6:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
801039ec:	83 ec 0c             	sub    $0xc,%esp
801039ef:	52                   	push   %edx
801039f0:	e8 6b 0a 00 00       	call   80104460 <wakeup>
  release(&p->lock);
801039f5:	89 3c 24             	mov    %edi,(%esp)
801039f8:	e8 23 12 00 00       	call   80104c20 <release>
  return n;
801039fd:	83 c4 10             	add    $0x10,%esp
80103a00:	8b 45 10             	mov    0x10(%ebp),%eax
80103a03:	eb 14                	jmp    80103a19 <pipewrite+0x119>
80103a05:	8d 76 00             	lea    0x0(%esi),%esi
        release(&p->lock);
80103a08:	83 ec 0c             	sub    $0xc,%esp
80103a0b:	57                   	push   %edi
80103a0c:	e8 0f 12 00 00       	call   80104c20 <release>
        return -1;
80103a11:	83 c4 10             	add    $0x10,%esp
80103a14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a1c:	5b                   	pop    %ebx
80103a1d:	5e                   	pop    %esi
80103a1e:	5f                   	pop    %edi
80103a1f:	5d                   	pop    %ebp
80103a20:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a21:	89 ca                	mov    %ecx,%edx
80103a23:	eb 98                	jmp    801039bd <pipewrite+0xbd>
80103a25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a30 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	57                   	push   %edi
80103a34:	56                   	push   %esi
80103a35:	53                   	push   %ebx
80103a36:	83 ec 18             	sub    $0x18,%esp
80103a39:	8b 75 08             	mov    0x8(%ebp),%esi
80103a3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a3f:	56                   	push   %esi
80103a40:	e8 1b 10 00 00       	call   80104a60 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a4e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a54:	75 64                	jne    80103aba <piperead+0x8a>
80103a56:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103a5c:	85 c0                	test   %eax,%eax
80103a5e:	0f 84 bc 00 00 00    	je     80103b20 <piperead+0xf0>
    if(proc->killed){
80103a64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a6a:	8b 58 24             	mov    0x24(%eax),%ebx
80103a6d:	85 db                	test   %ebx,%ebx
80103a6f:	0f 85 b3 00 00 00    	jne    80103b28 <piperead+0xf8>
80103a75:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a7b:	eb 22                	jmp    80103a9f <piperead+0x6f>
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a80:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103a86:	85 d2                	test   %edx,%edx
80103a88:	0f 84 92 00 00 00    	je     80103b20 <piperead+0xf0>
    if(proc->killed){
80103a8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a94:	8b 48 24             	mov    0x24(%eax),%ecx
80103a97:	85 c9                	test   %ecx,%ecx
80103a99:	0f 85 89 00 00 00    	jne    80103b28 <piperead+0xf8>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a9f:	83 ec 08             	sub    $0x8,%esp
80103aa2:	56                   	push   %esi
80103aa3:	53                   	push   %ebx
80103aa4:	e8 07 08 00 00       	call   801042b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103aa9:	83 c4 10             	add    $0x10,%esp
80103aac:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103ab2:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103ab8:	74 c6                	je     80103a80 <piperead+0x50>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103aba:	8b 45 10             	mov    0x10(%ebp),%eax
80103abd:	85 c0                	test   %eax,%eax
80103abf:	7e 5f                	jle    80103b20 <piperead+0xf0>
    if(p->nread == p->nwrite)
80103ac1:	31 db                	xor    %ebx,%ebx
80103ac3:	eb 11                	jmp    80103ad6 <piperead+0xa6>
80103ac5:	8d 76 00             	lea    0x0(%esi),%esi
80103ac8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103ace:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103ad4:	74 1f                	je     80103af5 <piperead+0xc5>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103ad6:	8d 41 01             	lea    0x1(%ecx),%eax
80103ad9:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103adf:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103ae5:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103aea:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103aed:	83 c3 01             	add    $0x1,%ebx
80103af0:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103af3:	75 d3                	jne    80103ac8 <piperead+0x98>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103af5:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103afb:	83 ec 0c             	sub    $0xc,%esp
80103afe:	50                   	push   %eax
80103aff:	e8 5c 09 00 00       	call   80104460 <wakeup>
  release(&p->lock);
80103b04:	89 34 24             	mov    %esi,(%esp)
80103b07:	e8 14 11 00 00       	call   80104c20 <release>
  return i;
80103b0c:	83 c4 10             	add    $0x10,%esp
}
80103b0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b12:	89 d8                	mov    %ebx,%eax
80103b14:	5b                   	pop    %ebx
80103b15:	5e                   	pop    %esi
80103b16:	5f                   	pop    %edi
80103b17:	5d                   	pop    %ebp
80103b18:	c3                   	ret    
80103b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
80103b20:	31 db                	xor    %ebx,%ebx
80103b22:	eb d1                	jmp    80103af5 <piperead+0xc5>
80103b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
80103b28:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103b2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103b30:	56                   	push   %esi
80103b31:	e8 ea 10 00 00       	call   80104c20 <release>
      return -1;
80103b36:	83 c4 10             	add    $0x10,%esp
}
80103b39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b3c:	89 d8                	mov    %ebx,%eax
80103b3e:	5b                   	pop    %ebx
80103b3f:	5e                   	pop    %esi
80103b40:	5f                   	pop    %edi
80103b41:	5d                   	pop    %ebp
80103b42:	c3                   	ret    
80103b43:	66 90                	xchg   %ax,%ax
80103b45:	66 90                	xchg   %ax,%ax
80103b47:	66 90                	xchg   %ax,%ax
80103b49:	66 90                	xchg   %ax,%ax
80103b4b:	66 90                	xchg   %ax,%ax
80103b4d:	66 90                	xchg   %ax,%ax
80103b4f:	90                   	nop

80103b50 <allocproc>:
// state required to run in the kernel.
// Otherwise return 0.
// Must hold ptable.lock.
static struct proc*
allocproc(void)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b54:	bb 14 49 11 80       	mov    $0x80114914,%ebx
{
80103b59:	83 ec 04             	sub    $0x4,%esp
80103b5c:	eb 10                	jmp    80103b6e <allocproc+0x1e>
80103b5e:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b60:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103b66:	81 fb 14 6d 11 80    	cmp    $0x80116d14,%ebx
80103b6c:	73 7c                	jae    80103bea <allocproc+0x9a>
    if(p->state == UNUSED)
80103b6e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b71:	85 c0                	test   %eax,%eax
80103b73:	75 eb                	jne    80103b60 <allocproc+0x10>
      goto found;
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b75:	a1 08 c0 10 80       	mov    0x8010c008,%eax
  p->state = EMBRYO;
80103b7a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->tickk=8;    //将时间片变成8
80103b81:	c7 43 7c 08 00 00 00 	movl   $0x8,0x7c(%ebx)
  p->priority=10; //优先级设置为10
80103b88:	c7 83 80 00 00 00 0a 	movl   $0xa,0x80(%ebx)
80103b8f:	00 00 00 
  p->pid = nextpid++;
80103b92:	8d 50 01             	lea    0x1(%eax),%edx
80103b95:	89 43 10             	mov    %eax,0x10(%ebx)
80103b98:	89 15 08 c0 10 80    	mov    %edx,0x8010c008

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103b9e:	e8 dd eb ff ff       	call   80102780 <kalloc>
80103ba3:	85 c0                	test   %eax,%eax
80103ba5:	89 43 08             	mov    %eax,0x8(%ebx)
80103ba8:	74 39                	je     80103be3 <allocproc+0x93>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103baa:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103bb0:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103bb3:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103bb8:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103bbb:	c7 40 14 1e 66 10 80 	movl   $0x8010661e,0x14(%eax)
  p->context = (struct context*)sp;
80103bc2:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103bc5:	6a 14                	push   $0x14
80103bc7:	6a 00                	push   $0x0
80103bc9:	50                   	push   %eax
80103bca:	e8 31 13 00 00       	call   80104f00 <memset>
  p->context->eip = (uint)forkret;
80103bcf:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103bd2:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103bd5:	c7 40 10 00 3c 10 80 	movl   $0x80103c00,0x10(%eax)
}
80103bdc:	89 d8                	mov    %ebx,%eax
80103bde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103be1:	c9                   	leave  
80103be2:	c3                   	ret    
    p->state = UNUSED;
80103be3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103bea:	31 db                	xor    %ebx,%ebx
}
80103bec:	89 d8                	mov    %ebx,%eax
80103bee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bf1:	c9                   	leave  
80103bf2:	c3                   	ret    
80103bf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c00 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103c06:	68 e0 48 11 80       	push   $0x801148e0
80103c0b:	e8 10 10 00 00       	call   80104c20 <release>

  if (first) {
80103c10:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80103c15:	83 c4 10             	add    $0x10,%esp
80103c18:	85 c0                	test   %eax,%eax
80103c1a:	75 04                	jne    80103c20 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103c1c:	c9                   	leave  
80103c1d:	c3                   	ret    
80103c1e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103c20:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103c23:	c7 05 04 c0 10 80 00 	movl   $0x0,0x8010c004
80103c2a:	00 00 00 
    iinit(ROOTDEV);
80103c2d:	6a 01                	push   $0x1
80103c2f:	e8 9c d9 ff ff       	call   801015d0 <iinit>
    initlog(ROOTDEV);
80103c34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c3b:	e8 c0 f2 ff ff       	call   80102f00 <initlog>
80103c40:	83 c4 10             	add    $0x10,%esp
}
80103c43:	c9                   	leave  
80103c44:	c3                   	ret    
80103c45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c50 <getcpuid>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
}
80103c53:	5d                   	pop    %ebp
return cpunum();
80103c54:	e9 47 ee ff ff       	jmp    80102aa0 <cpunum>
80103c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c60 <pinit>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103c66:	68 cd 89 10 80       	push   $0x801089cd
80103c6b:	68 e0 48 11 80       	push   $0x801148e0
80103c70:	e8 cb 0d 00 00       	call   80104a40 <initlock>
}
80103c75:	83 c4 10             	add    $0x10,%esp
80103c78:	c9                   	leave  
80103c79:	c3                   	ret    
80103c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c80 <userinit>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	53                   	push   %ebx
80103c84:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c87:	68 e0 48 11 80       	push   $0x801148e0
80103c8c:	e8 cf 0d 00 00       	call   80104a60 <acquire>
  p = allocproc();
80103c91:	e8 ba fe ff ff       	call   80103b50 <allocproc>
80103c96:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c98:	a3 bc c5 10 80       	mov    %eax,0x8010c5bc
  if((p->pgdir = setupkvm()) == 0)
80103c9d:	e8 4e 3b 00 00       	call   801077f0 <setupkvm>
80103ca2:	83 c4 10             	add    $0x10,%esp
80103ca5:	85 c0                	test   %eax,%eax
80103ca7:	89 43 04             	mov    %eax,0x4(%ebx)
80103caa:	0f 84 b1 00 00 00    	je     80103d61 <userinit+0xe1>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103cb0:	83 ec 04             	sub    $0x4,%esp
80103cb3:	68 2c 00 00 00       	push   $0x2c
80103cb8:	68 60 c4 10 80       	push   $0x8010c460
80103cbd:	50                   	push   %eax
80103cbe:	e8 7d 3c 00 00       	call   80107940 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103cc3:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103cc6:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ccc:	6a 4c                	push   $0x4c
80103cce:	6a 00                	push   $0x0
80103cd0:	ff 73 18             	pushl  0x18(%ebx)
80103cd3:	e8 28 12 00 00       	call   80104f00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cd8:	8b 43 18             	mov    0x18(%ebx),%eax
80103cdb:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ce0:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ce5:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ce8:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cec:	8b 43 18             	mov    0x18(%ebx),%eax
80103cef:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103cf3:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf6:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cfa:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103cfe:	8b 43 18             	mov    0x18(%ebx),%eax
80103d01:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d05:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d09:	8b 43 18             	mov    0x18(%ebx),%eax
80103d0c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d13:	8b 43 18             	mov    0x18(%ebx),%eax
80103d16:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d1d:	8b 43 18             	mov    0x18(%ebx),%eax
80103d20:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d27:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d2a:	6a 10                	push   $0x10
80103d2c:	68 ed 89 10 80       	push   $0x801089ed
80103d31:	50                   	push   %eax
80103d32:	e8 a9 13 00 00       	call   801050e0 <safestrcpy>
  p->cwd = namei("/");
80103d37:	c7 04 24 f6 89 10 80 	movl   $0x801089f6,(%esp)
80103d3e:	e8 0d e3 ff ff       	call   80102050 <namei>
  p->state = RUNNABLE;
80103d43:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->cwd = namei("/");
80103d4a:	89 43 68             	mov    %eax,0x68(%ebx)
  release(&ptable.lock);
80103d4d:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
80103d54:	e8 c7 0e 00 00       	call   80104c20 <release>
}
80103d59:	83 c4 10             	add    $0x10,%esp
80103d5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d5f:	c9                   	leave  
80103d60:	c3                   	ret    
    panic("userinit: out of memory?");
80103d61:	83 ec 0c             	sub    $0xc,%esp
80103d64:	68 d4 89 10 80       	push   $0x801089d4
80103d69:	e8 12 c7 ff ff       	call   80100480 <panic>
80103d6e:	66 90                	xchg   %ax,%ax

80103d70 <growproc>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	83 ec 08             	sub    $0x8,%esp
  sz = proc->sz;
80103d76:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
{
80103d7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  sz = proc->sz;
80103d80:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103d82:	83 f9 00             	cmp    $0x0,%ecx
80103d85:	7f 21                	jg     80103da8 <growproc+0x38>
  } else if(n < 0){
80103d87:	75 47                	jne    80103dd0 <growproc+0x60>
  proc->sz = sz;
80103d89:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
80103d8b:	83 ec 0c             	sub    $0xc,%esp
80103d8e:	65 ff 35 04 00 00 00 	pushl  %gs:0x4
80103d95:	e8 06 3b 00 00       	call   801078a0 <switchuvm>
  return 0;
80103d9a:	83 c4 10             	add    $0x10,%esp
80103d9d:	31 c0                	xor    %eax,%eax
}
80103d9f:	c9                   	leave  
80103da0:	c3                   	ret    
80103da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103da8:	83 ec 04             	sub    $0x4,%esp
80103dab:	01 c1                	add    %eax,%ecx
80103dad:	51                   	push   %ecx
80103dae:	50                   	push   %eax
80103daf:	ff 72 04             	pushl  0x4(%edx)
80103db2:	e8 c9 3c 00 00       	call   80107a80 <allocuvm>
80103db7:	83 c4 10             	add    $0x10,%esp
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	74 28                	je     80103de6 <growproc+0x76>
80103dbe:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103dc5:	eb c2                	jmp    80103d89 <growproc+0x19>
80103dc7:	89 f6                	mov    %esi,%esi
80103dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103dd0:	83 ec 04             	sub    $0x4,%esp
80103dd3:	01 c1                	add    %eax,%ecx
80103dd5:	51                   	push   %ecx
80103dd6:	50                   	push   %eax
80103dd7:	ff 72 04             	pushl  0x4(%edx)
80103dda:	e8 c1 3d 00 00       	call   80107ba0 <deallocuvm>
80103ddf:	83 c4 10             	add    $0x10,%esp
80103de2:	85 c0                	test   %eax,%eax
80103de4:	75 d8                	jne    80103dbe <growproc+0x4e>
      return -1;
80103de6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103deb:	c9                   	leave  
80103dec:	c3                   	ret    
80103ded:	8d 76 00             	lea    0x0(%esi),%esi

80103df0 <fork>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	57                   	push   %edi
80103df4:	56                   	push   %esi
80103df5:	53                   	push   %ebx
80103df6:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80103df9:	68 e0 48 11 80       	push   $0x801148e0
80103dfe:	e8 5d 0c 00 00       	call   80104a60 <acquire>
  if((np = allocproc()) == 0){
80103e03:	e8 48 fd ff ff       	call   80103b50 <allocproc>
80103e08:	83 c4 10             	add    $0x10,%esp
80103e0b:	85 c0                	test   %eax,%eax
80103e0d:	0f 84 d5 00 00 00    	je     80103ee8 <fork+0xf8>
80103e13:	89 c3                	mov    %eax,%ebx
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103e15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e1b:	83 ec 08             	sub    $0x8,%esp
80103e1e:	ff 30                	pushl  (%eax)
80103e20:	ff 70 04             	pushl  0x4(%eax)
80103e23:	e8 58 3e 00 00       	call   80107c80 <copyuvm>
80103e28:	83 c4 10             	add    $0x10,%esp
80103e2b:	85 c0                	test   %eax,%eax
80103e2d:	89 43 04             	mov    %eax,0x4(%ebx)
80103e30:	0f 84 c9 00 00 00    	je     80103eff <fork+0x10f>
  np->sz = proc->sz;
80103e36:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  *np->tf = *proc->tf;
80103e3c:	8b 7b 18             	mov    0x18(%ebx),%edi
80103e3f:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = proc->sz;
80103e44:	8b 00                	mov    (%eax),%eax
80103e46:	89 03                	mov    %eax,(%ebx)
  np->swap_start=proc->sz;
80103e48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e4e:	8b 10                	mov    (%eax),%edx
  np->parent = proc;
80103e50:	89 43 14             	mov    %eax,0x14(%ebx)
  np->swap_start=proc->sz;
80103e53:	89 93 8c 00 00 00    	mov    %edx,0x8c(%ebx)
  *np->tf = *proc->tf;
80103e59:	8b 70 18             	mov    0x18(%eax),%esi
80103e5c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e5e:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e60:	8b 43 18             	mov    0x18(%ebx),%eax
80103e63:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103e6a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->ofile[i])
80103e78:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103e7c:	85 c0                	test   %eax,%eax
80103e7e:	74 17                	je     80103e97 <fork+0xa7>
      np->ofile[i] = filedup(proc->ofile[i]);
80103e80:	83 ec 0c             	sub    $0xc,%esp
80103e83:	50                   	push   %eax
80103e84:	e8 47 d0 ff ff       	call   80100ed0 <filedup>
80103e89:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103e8d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103e94:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
80103e97:	83 c6 01             	add    $0x1,%esi
80103e9a:	83 fe 10             	cmp    $0x10,%esi
80103e9d:	75 d9                	jne    80103e78 <fork+0x88>
  np->cwd = idup(proc->cwd);
80103e9f:	83 ec 0c             	sub    $0xc,%esp
80103ea2:	ff 72 68             	pushl  0x68(%edx)
80103ea5:	e8 d6 d8 ff ff       	call   80101780 <idup>
80103eaa:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103ead:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103eb3:	83 c4 0c             	add    $0xc,%esp
80103eb6:	6a 10                	push   $0x10
80103eb8:	83 c0 6c             	add    $0x6c,%eax
80103ebb:	50                   	push   %eax
80103ebc:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ebf:	50                   	push   %eax
80103ec0:	e8 1b 12 00 00       	call   801050e0 <safestrcpy>
  np->state = RUNNABLE;
80103ec5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pid = np->pid;
80103ecc:	8b 73 10             	mov    0x10(%ebx),%esi
  release(&ptable.lock);
80103ecf:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
80103ed6:	e8 45 0d 00 00       	call   80104c20 <release>
  return pid;
80103edb:	83 c4 10             	add    $0x10,%esp
}
80103ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ee1:	89 f0                	mov    %esi,%eax
80103ee3:	5b                   	pop    %ebx
80103ee4:	5e                   	pop    %esi
80103ee5:	5f                   	pop    %edi
80103ee6:	5d                   	pop    %ebp
80103ee7:	c3                   	ret    
    release(&ptable.lock);
80103ee8:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103eeb:	be ff ff ff ff       	mov    $0xffffffff,%esi
    release(&ptable.lock);
80103ef0:	68 e0 48 11 80       	push   $0x801148e0
80103ef5:	e8 26 0d 00 00       	call   80104c20 <release>
    return -1;
80103efa:	83 c4 10             	add    $0x10,%esp
80103efd:	eb df                	jmp    80103ede <fork+0xee>
    kfree(np->kstack);
80103eff:	83 ec 0c             	sub    $0xc,%esp
80103f02:	ff 73 08             	pushl  0x8(%ebx)
    return -1;
80103f05:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103f0a:	e8 71 e6 ff ff       	call   80102580 <kfree>
    np->kstack = 0;
80103f0f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103f16:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    release(&ptable.lock);
80103f1d:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
80103f24:	e8 f7 0c 00 00       	call   80104c20 <release>
    return -1;
80103f29:	83 c4 10             	add    $0x10,%esp
80103f2c:	eb b0                	jmp    80103ede <fork+0xee>
80103f2e:	66 90                	xchg   %ax,%ax

80103f30 <scheduler>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	56                   	push   %esi
80103f34:	53                   	push   %ebx
80103f35:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f38:	fb                   	sti    
    acquire(&ptable.lock);
80103f39:	83 ec 0c             	sub    $0xc,%esp
80103f3c:	68 e0 48 11 80       	push   $0x801148e0
80103f41:	e8 1a 0b 00 00       	call   80104a60 <acquire>
80103f46:	83 c4 10             	add    $0x10,%esp
    priority = 19;  //设置pri为19
80103f49:	ba 13 00 00 00       	mov    $0x13,%edx
    for(temp  = ptable.proc; temp < &ptable.proc[NPROC]; temp++) //获取当前可运行的最高当前优先级
80103f4e:	b8 14 49 11 80       	mov    $0x80114914,%eax
80103f53:	90                   	nop
80103f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(temp->state == RUNNABLE&&temp->priority < priority)
80103f58:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103f5c:	75 0b                	jne    80103f69 <scheduler+0x39>
80103f5e:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80103f64:	39 ca                	cmp    %ecx,%edx
80103f66:	0f 4f d1             	cmovg  %ecx,%edx
    for(temp  = ptable.proc; temp < &ptable.proc[NPROC]; temp++) //获取当前可运行的最高当前优先级
80103f69:	05 90 00 00 00       	add    $0x90,%eax
80103f6e:	3d 14 6d 11 80       	cmp    $0x80116d14,%eax
80103f73:	72 e3                	jb     80103f58 <scheduler+0x28>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f75:	bb 14 49 11 80       	mov    $0x80114914,%ebx
80103f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103f80:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f84:	75 4a                	jne    80103fd0 <scheduler+0xa0>
      if(p->priority > priority)
80103f86:	8b b3 80 00 00 00    	mov    0x80(%ebx),%esi
80103f8c:	39 d6                	cmp    %edx,%esi
80103f8e:	7f 40                	jg     80103fd0 <scheduler+0xa0>
      switchuvm(p);
80103f90:	83 ec 0c             	sub    $0xc,%esp
      proc = p;
80103f93:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
80103f9a:	53                   	push   %ebx
80103f9b:	e8 00 39 00 00       	call   801078a0 <switchuvm>
      swtch(&cpu->scheduler, p->context);
80103fa0:	58                   	pop    %eax
80103fa1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
      p->state = RUNNING;
80103fa7:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&cpu->scheduler, p->context);
80103fae:	5a                   	pop    %edx
80103faf:	ff 73 1c             	pushl  0x1c(%ebx)
80103fb2:	83 c0 04             	add    $0x4,%eax
80103fb5:	50                   	push   %eax
80103fb6:	e8 80 11 00 00       	call   8010513b <swtch>
      switchkvm();
80103fbb:	e8 c0 38 00 00       	call   80107880 <switchkvm>
      proc = 0;
80103fc0:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103fc7:	00 00 00 00 
80103fcb:	83 c4 10             	add    $0x10,%esp
80103fce:	89 f2                	mov    %esi,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd0:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103fd6:	81 fb 14 6d 11 80    	cmp    $0x80116d14,%ebx
80103fdc:	72 a2                	jb     80103f80 <scheduler+0x50>
    release(&ptable.lock);
80103fde:	83 ec 0c             	sub    $0xc,%esp
80103fe1:	68 e0 48 11 80       	push   $0x801148e0
80103fe6:	e8 35 0c 00 00       	call   80104c20 <release>
    sti();
80103feb:	83 c4 10             	add    $0x10,%esp
80103fee:	e9 45 ff ff ff       	jmp    80103f38 <scheduler+0x8>
80103ff3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <sched>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
  if(!holding(&ptable.lock))
80104007:	68 e0 48 11 80       	push   $0x801148e0
8010400c:	e8 5f 0b 00 00       	call   80104b70 <holding>
80104011:	83 c4 10             	add    $0x10,%esp
80104014:	85 c0                	test   %eax,%eax
80104016:	74 4c                	je     80104064 <sched+0x64>
  if(cpu->ncli != 1)
80104018:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010401f:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
80104026:	75 63                	jne    8010408b <sched+0x8b>
  if(proc->state == RUNNING)
80104028:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010402e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80104032:	74 4a                	je     8010407e <sched+0x7e>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104034:	9c                   	pushf  
80104035:	59                   	pop    %ecx
  if(readeflags()&FL_IF)
80104036:	80 e5 02             	and    $0x2,%ch
80104039:	75 36                	jne    80104071 <sched+0x71>
  swtch(&proc->context, cpu->scheduler);
8010403b:	83 ec 08             	sub    $0x8,%esp
8010403e:	83 c0 1c             	add    $0x1c,%eax
  intena = cpu->intena;
80104041:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
  swtch(&proc->context, cpu->scheduler);
80104047:	ff 72 04             	pushl  0x4(%edx)
8010404a:	50                   	push   %eax
8010404b:	e8 eb 10 00 00       	call   8010513b <swtch>
  cpu->intena = intena;
80104050:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
}
80104056:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104059:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
8010405f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104062:	c9                   	leave  
80104063:	c3                   	ret    
    panic("sched ptable.lock");
80104064:	83 ec 0c             	sub    $0xc,%esp
80104067:	68 f8 89 10 80       	push   $0x801089f8
8010406c:	e8 0f c4 ff ff       	call   80100480 <panic>
    panic("sched interruptible");
80104071:	83 ec 0c             	sub    $0xc,%esp
80104074:	68 24 8a 10 80       	push   $0x80108a24
80104079:	e8 02 c4 ff ff       	call   80100480 <panic>
    panic("sched running");
8010407e:	83 ec 0c             	sub    $0xc,%esp
80104081:	68 16 8a 10 80       	push   $0x80108a16
80104086:	e8 f5 c3 ff ff       	call   80100480 <panic>
    panic("sched locks");
8010408b:	83 ec 0c             	sub    $0xc,%esp
8010408e:	68 0a 8a 10 80       	push   $0x80108a0a
80104093:	e8 e8 c3 ff ff       	call   80100480 <panic>
80104098:	90                   	nop
80104099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040a0 <exit>:
   struct proc *curproc = proc;
801040a0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  if(proc == initproc)
801040a7:	39 15 bc c5 10 80    	cmp    %edx,0x8010c5bc
{
801040ad:	55                   	push   %ebp
801040ae:	89 e5                	mov    %esp,%ebp
801040b0:	56                   	push   %esi
801040b1:	53                   	push   %ebx
  if(proc == initproc)
801040b2:	0f 84 a0 01 00 00    	je     80104258 <exit+0x1b8>
  if(curproc->parent==0 && curproc->pthread!=0)
801040b8:	8b 4a 14             	mov    0x14(%edx),%ecx
801040bb:	b8 14 49 11 80       	mov    $0x80114914,%eax
801040c0:	85 c9                	test   %ecx,%ecx
801040c2:	75 18                	jne    801040dc <exit+0x3c>
801040c4:	e9 58 01 00 00       	jmp    80104221 <exit+0x181>
801040c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040d0:	05 90 00 00 00       	add    $0x90,%eax
801040d5:	3d 14 6d 11 80       	cmp    $0x80116d14,%eax
801040da:	73 1e                	jae    801040fa <exit+0x5a>
    if(p->state == SLEEPING && p->chan == chan)
801040dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040e0:	75 ee                	jne    801040d0 <exit+0x30>
801040e2:	3b 48 20             	cmp    0x20(%eax),%ecx
801040e5:	75 e9                	jne    801040d0 <exit+0x30>
      p->state = RUNNABLE;
801040e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ee:	05 90 00 00 00       	add    $0x90,%eax
801040f3:	3d 14 6d 11 80       	cmp    $0x80116d14,%eax
801040f8:	72 e2                	jb     801040dc <exit+0x3c>
801040fa:	31 db                	xor    %ebx,%ebx
801040fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->ofile[fd]){
80104100:	8d 73 08             	lea    0x8(%ebx),%esi
80104103:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80104107:	85 c0                	test   %eax,%eax
80104109:	74 1b                	je     80104126 <exit+0x86>
      fileclose(proc->ofile[fd]);
8010410b:	83 ec 0c             	sub    $0xc,%esp
8010410e:	50                   	push   %eax
8010410f:	e8 0c ce ff ff       	call   80100f20 <fileclose>
      proc->ofile[fd] = 0;
80104114:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010411b:	83 c4 10             	add    $0x10,%esp
8010411e:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80104125:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104126:	83 c3 01             	add    $0x1,%ebx
80104129:	83 fb 10             	cmp    $0x10,%ebx
8010412c:	75 d2                	jne    80104100 <exit+0x60>
  begin_op();
8010412e:	e8 6d ee ff ff       	call   80102fa0 <begin_op>
  iput(proc->cwd);
80104133:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104139:	83 ec 0c             	sub    $0xc,%esp
8010413c:	ff 70 68             	pushl  0x68(%eax)
8010413f:	e8 dc d7 ff ff       	call   80101920 <iput>
  end_op();
80104144:	e8 c7 ee ff ff       	call   80103010 <end_op>
  proc->cwd = 0;
80104149:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010414f:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  acquire(&ptable.lock);
80104156:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
8010415d:	e8 fe 08 00 00       	call   80104a60 <acquire>
  wakeup1(proc->parent);
80104162:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
80104169:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010416c:	b8 14 49 11 80       	mov    $0x80114914,%eax
  wakeup1(proc->parent);
80104171:	8b 53 14             	mov    0x14(%ebx),%edx
80104174:	eb 16                	jmp    8010418c <exit+0xec>
80104176:	8d 76 00             	lea    0x0(%esi),%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104180:	05 90 00 00 00       	add    $0x90,%eax
80104185:	3d 14 6d 11 80       	cmp    $0x80116d14,%eax
8010418a:	73 1e                	jae    801041aa <exit+0x10a>
    if(p->state == SLEEPING && p->chan == chan)
8010418c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104190:	75 ee                	jne    80104180 <exit+0xe0>
80104192:	3b 50 20             	cmp    0x20(%eax),%edx
80104195:	75 e9                	jne    80104180 <exit+0xe0>
      p->state = RUNNABLE;
80104197:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010419e:	05 90 00 00 00       	add    $0x90,%eax
801041a3:	3d 14 6d 11 80       	cmp    $0x80116d14,%eax
801041a8:	72 e2                	jb     8010418c <exit+0xec>
      p->parent = initproc;
801041aa:	8b 0d bc c5 10 80    	mov    0x8010c5bc,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b0:	ba 14 49 11 80       	mov    $0x80114914,%edx
801041b5:	eb 17                	jmp    801041ce <exit+0x12e>
801041b7:	89 f6                	mov    %esi,%esi
801041b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801041c0:	81 c2 90 00 00 00    	add    $0x90,%edx
801041c6:	81 fa 14 6d 11 80    	cmp    $0x80116d14,%edx
801041cc:	73 3a                	jae    80104208 <exit+0x168>
    if(p->parent == proc){
801041ce:	3b 5a 14             	cmp    0x14(%edx),%ebx
801041d1:	75 ed                	jne    801041c0 <exit+0x120>
      if(p->state == ZOMBIE)
801041d3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801041d7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801041da:	75 e4                	jne    801041c0 <exit+0x120>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041dc:	b8 14 49 11 80       	mov    $0x80114914,%eax
801041e1:	eb 11                	jmp    801041f4 <exit+0x154>
801041e3:	90                   	nop
801041e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e8:	05 90 00 00 00       	add    $0x90,%eax
801041ed:	3d 14 6d 11 80       	cmp    $0x80116d14,%eax
801041f2:	73 cc                	jae    801041c0 <exit+0x120>
    if(p->state == SLEEPING && p->chan == chan)
801041f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041f8:	75 ee                	jne    801041e8 <exit+0x148>
801041fa:	3b 48 20             	cmp    0x20(%eax),%ecx
801041fd:	75 e9                	jne    801041e8 <exit+0x148>
      p->state = RUNNABLE;
801041ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104206:	eb e0                	jmp    801041e8 <exit+0x148>
  proc->state = ZOMBIE;
80104208:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010420f:	e8 ec fd ff ff       	call   80104000 <sched>
  panic("zombie exit");
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	68 45 8a 10 80       	push   $0x80108a45
8010421c:	e8 5f c2 ff ff       	call   80100480 <panic>
  if(curproc->parent==0 && curproc->pthread!=0)
80104221:	8b 9a 84 00 00 00    	mov    0x84(%edx),%ebx
80104227:	85 db                	test   %ebx,%ebx
80104229:	75 25                	jne    80104250 <exit+0x1b0>
8010422b:	e9 ac fe ff ff       	jmp    801040dc <exit+0x3c>
    if(p->state == SLEEPING && p->chan == chan)
80104230:	3b 58 20             	cmp    0x20(%eax),%ebx
80104233:	75 0b                	jne    80104240 <exit+0x1a0>
      p->state = RUNNABLE;
80104235:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010423c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104240:	05 90 00 00 00       	add    $0x90,%eax
80104245:	3d 14 6d 11 80       	cmp    $0x80116d14,%eax
8010424a:	0f 83 aa fe ff ff    	jae    801040fa <exit+0x5a>
    if(p->state == SLEEPING && p->chan == chan)
80104250:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104254:	75 ea                	jne    80104240 <exit+0x1a0>
80104256:	eb d8                	jmp    80104230 <exit+0x190>
    panic("init exiting");
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	68 38 8a 10 80       	push   $0x80108a38
80104260:	e8 1b c2 ff ff       	call   80100480 <panic>
80104265:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104270 <yield>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104276:	68 e0 48 11 80       	push   $0x801148e0
8010427b:	e8 e0 07 00 00       	call   80104a60 <acquire>
  proc->state = RUNNABLE;
80104280:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104286:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010428d:	e8 6e fd ff ff       	call   80104000 <sched>
  release(&ptable.lock);
80104292:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
80104299:	e8 82 09 00 00       	call   80104c20 <release>
}
8010429e:	83 c4 10             	add    $0x10,%esp
801042a1:	c9                   	leave  
801042a2:	c3                   	ret    
801042a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042b0 <sleep>:
  if(proc == 0)
801042b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
{
801042b6:	55                   	push   %ebp
801042b7:	89 e5                	mov    %esp,%ebp
801042b9:	56                   	push   %esi
801042ba:	53                   	push   %ebx
  if(proc == 0)
801042bb:	85 c0                	test   %eax,%eax
{
801042bd:	8b 75 08             	mov    0x8(%ebp),%esi
801042c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
801042c3:	0f 84 97 00 00 00    	je     80104360 <sleep+0xb0>
  if(lk == 0)
801042c9:	85 db                	test   %ebx,%ebx
801042cb:	0f 84 82 00 00 00    	je     80104353 <sleep+0xa3>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042d1:	81 fb e0 48 11 80    	cmp    $0x801148e0,%ebx
801042d7:	74 57                	je     80104330 <sleep+0x80>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042d9:	83 ec 0c             	sub    $0xc,%esp
801042dc:	68 e0 48 11 80       	push   $0x801148e0
801042e1:	e8 7a 07 00 00       	call   80104a60 <acquire>
    release(lk);
801042e6:	89 1c 24             	mov    %ebx,(%esp)
801042e9:	e8 32 09 00 00       	call   80104c20 <release>
  proc->chan = chan;
801042ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042f4:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
801042f7:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801042fe:	e8 fd fc ff ff       	call   80104000 <sched>
  proc->chan = 0;
80104303:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104309:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
    release(&ptable.lock);
80104310:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
80104317:	e8 04 09 00 00       	call   80104c20 <release>
    acquire(lk);
8010431c:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010431f:	83 c4 10             	add    $0x10,%esp
}
80104322:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104325:	5b                   	pop    %ebx
80104326:	5e                   	pop    %esi
80104327:	5d                   	pop    %ebp
    acquire(lk);
80104328:	e9 33 07 00 00       	jmp    80104a60 <acquire>
8010432d:	8d 76 00             	lea    0x0(%esi),%esi
  proc->chan = chan;
80104330:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80104333:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
8010433a:	e8 c1 fc ff ff       	call   80104000 <sched>
  proc->chan = 0;
8010433f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104345:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
}
8010434c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010434f:	5b                   	pop    %ebx
80104350:	5e                   	pop    %esi
80104351:	5d                   	pop    %ebp
80104352:	c3                   	ret    
    panic("sleep without lk");
80104353:	83 ec 0c             	sub    $0xc,%esp
80104356:	68 57 8a 10 80       	push   $0x80108a57
8010435b:	e8 20 c1 ff ff       	call   80100480 <panic>
    panic("sleep");
80104360:	83 ec 0c             	sub    $0xc,%esp
80104363:	68 51 8a 10 80       	push   $0x80108a51
80104368:	e8 13 c1 ff ff       	call   80100480 <panic>
8010436d:	8d 76 00             	lea    0x0(%esi),%esi

80104370 <wait>:
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
  acquire(&ptable.lock);
80104375:	83 ec 0c             	sub    $0xc,%esp
80104378:	68 e0 48 11 80       	push   $0x801148e0
8010437d:	e8 de 06 00 00       	call   80104a60 <acquire>
80104382:	83 c4 10             	add    $0x10,%esp
      if(p->parent != proc)
80104385:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    havekids = 0;
8010438b:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010438d:	bb 14 49 11 80       	mov    $0x80114914,%ebx
80104392:	eb 12                	jmp    801043a6 <wait+0x36>
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104398:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010439e:	81 fb 14 6d 11 80    	cmp    $0x80116d14,%ebx
801043a4:	73 1e                	jae    801043c4 <wait+0x54>
      if(p->parent != proc)
801043a6:	39 43 14             	cmp    %eax,0x14(%ebx)
801043a9:	75 ed                	jne    80104398 <wait+0x28>
      if(p->state == ZOMBIE){
801043ab:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043af:	74 37                	je     801043e8 <wait+0x78>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043b1:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
801043b7:	ba 01 00 00 00       	mov    $0x1,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043bc:	81 fb 14 6d 11 80    	cmp    $0x80116d14,%ebx
801043c2:	72 e2                	jb     801043a6 <wait+0x36>
    if(!havekids || proc->killed){
801043c4:	85 d2                	test   %edx,%edx
801043c6:	74 76                	je     8010443e <wait+0xce>
801043c8:	8b 50 24             	mov    0x24(%eax),%edx
801043cb:	85 d2                	test   %edx,%edx
801043cd:	75 6f                	jne    8010443e <wait+0xce>
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801043cf:	83 ec 08             	sub    $0x8,%esp
801043d2:	68 e0 48 11 80       	push   $0x801148e0
801043d7:	50                   	push   %eax
801043d8:	e8 d3 fe ff ff       	call   801042b0 <sleep>
    havekids = 0;
801043dd:	83 c4 10             	add    $0x10,%esp
801043e0:	eb a3                	jmp    80104385 <wait+0x15>
801043e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801043ee:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801043f1:	e8 8a e1 ff ff       	call   80102580 <kfree>
        freevm(p->pgdir);
801043f6:	59                   	pop    %ecx
801043f7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801043fa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104401:	e8 ca 37 00 00       	call   80107bd0 <freevm>
        release(&ptable.lock);
80104406:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
        p->pid = 0;
8010440d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104414:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010441b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010441f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104426:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010442d:	e8 ee 07 00 00       	call   80104c20 <release>
        return pid;
80104432:	83 c4 10             	add    $0x10,%esp
}
80104435:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104438:	89 f0                	mov    %esi,%eax
8010443a:	5b                   	pop    %ebx
8010443b:	5e                   	pop    %esi
8010443c:	5d                   	pop    %ebp
8010443d:	c3                   	ret    
      release(&ptable.lock);
8010443e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104441:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104446:	68 e0 48 11 80       	push   $0x801148e0
8010444b:	e8 d0 07 00 00       	call   80104c20 <release>
      return -1;
80104450:	83 c4 10             	add    $0x10,%esp
80104453:	eb e0                	jmp    80104435 <wait+0xc5>
80104455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104460 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 10             	sub    $0x10,%esp
80104467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010446a:	68 e0 48 11 80       	push   $0x801148e0
8010446f:	e8 ec 05 00 00       	call   80104a60 <acquire>
80104474:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104477:	b8 14 49 11 80       	mov    $0x80114914,%eax
8010447c:	eb 0e                	jmp    8010448c <wakeup+0x2c>
8010447e:	66 90                	xchg   %ax,%ax
80104480:	05 90 00 00 00       	add    $0x90,%eax
80104485:	3d 14 6d 11 80       	cmp    $0x80116d14,%eax
8010448a:	73 1e                	jae    801044aa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010448c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104490:	75 ee                	jne    80104480 <wakeup+0x20>
80104492:	3b 58 20             	cmp    0x20(%eax),%ebx
80104495:	75 e9                	jne    80104480 <wakeup+0x20>
      p->state = RUNNABLE;
80104497:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010449e:	05 90 00 00 00       	add    $0x90,%eax
801044a3:	3d 14 6d 11 80       	cmp    $0x80116d14,%eax
801044a8:	72 e2                	jb     8010448c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801044aa:	c7 45 08 e0 48 11 80 	movl   $0x801148e0,0x8(%ebp)
}
801044b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044b4:	c9                   	leave  
  release(&ptable.lock);
801044b5:	e9 66 07 00 00       	jmp    80104c20 <release>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 10             	sub    $0x10,%esp
801044c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044ca:	68 e0 48 11 80       	push   $0x801148e0
801044cf:	e8 8c 05 00 00       	call   80104a60 <acquire>
801044d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044d7:	b8 14 49 11 80       	mov    $0x80114914,%eax
801044dc:	eb 0e                	jmp    801044ec <kill+0x2c>
801044de:	66 90                	xchg   %ax,%ax
801044e0:	05 90 00 00 00       	add    $0x90,%eax
801044e5:	3d 14 6d 11 80       	cmp    $0x80116d14,%eax
801044ea:	73 34                	jae    80104520 <kill+0x60>
    if(p->pid == pid){
801044ec:	39 58 10             	cmp    %ebx,0x10(%eax)
801044ef:	75 ef                	jne    801044e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044f1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801044f5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801044fc:	75 07                	jne    80104505 <kill+0x45>
        p->state = RUNNABLE;
801044fe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104505:	83 ec 0c             	sub    $0xc,%esp
80104508:	68 e0 48 11 80       	push   $0x801148e0
8010450d:	e8 0e 07 00 00       	call   80104c20 <release>
      return 0;
80104512:	83 c4 10             	add    $0x10,%esp
80104515:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104517:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010451a:	c9                   	leave  
8010451b:	c3                   	ret    
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104520:	83 ec 0c             	sub    $0xc,%esp
80104523:	68 e0 48 11 80       	push   $0x801148e0
80104528:	e8 f3 06 00 00       	call   80104c20 <release>
  return -1;
8010452d:	83 c4 10             	add    $0x10,%esp
80104530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104535:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104538:	c9                   	leave  
80104539:	c3                   	ret    
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104540 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	56                   	push   %esi
80104545:	53                   	push   %ebx
80104546:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104549:	bb 14 49 11 80       	mov    $0x80114914,%ebx
{
8010454e:	83 ec 3c             	sub    $0x3c,%esp
80104551:	eb 27                	jmp    8010457a <procdump+0x3a>
80104553:	90                   	nop
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104558:	83 ec 0c             	sub    $0xc,%esp
8010455b:	68 a6 89 10 80       	push   $0x801089a6
80104560:	e8 eb c1 ff ff       	call   80100750 <cprintf>
80104565:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104568:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010456e:	81 fb 14 6d 11 80    	cmp    $0x80116d14,%ebx
80104574:	0f 83 96 00 00 00    	jae    80104610 <procdump+0xd0>
    if(p->state == UNUSED)
8010457a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010457d:	85 c0                	test   %eax,%eax
8010457f:	74 e7                	je     80104568 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104581:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104584:	ba 68 8a 10 80       	mov    $0x80108a68,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104589:	77 11                	ja     8010459c <procdump+0x5c>
8010458b:	8b 14 85 b8 8a 10 80 	mov    -0x7fef7548(,%eax,4),%edx
      state = "???";
80104592:	b8 68 8a 10 80       	mov    $0x80108a68,%eax
80104597:	85 d2                	test   %edx,%edx
80104599:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s,ticks left: %d,prio=%d", p->pid, state, p->name,p->tickk,p->priority);
8010459c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010459f:	83 ec 08             	sub    $0x8,%esp
801045a2:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
801045a8:	ff 73 7c             	pushl  0x7c(%ebx)
801045ab:	50                   	push   %eax
801045ac:	52                   	push   %edx
801045ad:	ff 73 10             	pushl  0x10(%ebx)
801045b0:	68 98 8a 10 80       	push   $0x80108a98
801045b5:	e8 96 c1 ff ff       	call   80100750 <cprintf>
    if(p->state == SLEEPING){
801045ba:	83 c4 20             	add    $0x20,%esp
801045bd:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801045c1:	75 95                	jne    80104558 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801045c3:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045c6:	83 ec 08             	sub    $0x8,%esp
801045c9:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045cc:	50                   	push   %eax
801045cd:	8b 43 1c             	mov    0x1c(%ebx),%eax
801045d0:	8b 40 0c             	mov    0xc(%eax),%eax
801045d3:	83 c0 08             	add    $0x8,%eax
801045d6:	50                   	push   %eax
801045d7:	e8 44 05 00 00       	call   80104b20 <getcallerpcs>
801045dc:	83 c4 10             	add    $0x10,%esp
801045df:	90                   	nop
      for(i=0; i<10 && pc[i] != 0; i++)
801045e0:	8b 17                	mov    (%edi),%edx
801045e2:	85 d2                	test   %edx,%edx
801045e4:	0f 84 6e ff ff ff    	je     80104558 <procdump+0x18>
        cprintf(" %p", pc[i]);
801045ea:	83 ec 08             	sub    $0x8,%esp
801045ed:	83 c7 04             	add    $0x4,%edi
801045f0:	52                   	push   %edx
801045f1:	68 62 84 10 80       	push   $0x80108462
801045f6:	e8 55 c1 ff ff       	call   80100750 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801045fb:	83 c4 10             	add    $0x10,%esp
801045fe:	39 fe                	cmp    %edi,%esi
80104600:	75 de                	jne    801045e0 <procdump+0xa0>
80104602:	e9 51 ff ff ff       	jmp    80104558 <procdump+0x18>
80104607:	89 f6                	mov    %esi,%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
}
80104610:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104613:	5b                   	pop    %ebx
80104614:	5e                   	pop    %esi
80104615:	5f                   	pop    %edi
80104616:	5d                   	pop    %ebp
80104617:	c3                   	ret    
80104618:	90                   	nop
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104620 <changepri>:

//修改进程优先级   
int changepri( int pid, int priority ) {
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 10             	sub    $0x10,%esp
80104627:	8b 5d 08             	mov    0x8(%ebp),%ebx

  struct proc *p;
  //获取锁
  acquire(&ptable.lock);
8010462a:	68 e0 48 11 80       	push   $0x801148e0
8010462f:	e8 2c 04 00 00       	call   80104a60 <acquire>
80104634:	83 c4 10             	add    $0x10,%esp
  //遍历当前所有进程，找到pid所属进程，并将其优先级改为priority
  for ( p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104637:	ba 14 49 11 80       	mov    $0x80114914,%edx
8010463c:	eb 10                	jmp    8010464e <changepri+0x2e>
8010463e:	66 90                	xchg   %ax,%ax
80104640:	81 c2 90 00 00 00    	add    $0x90,%edx
80104646:	81 fa 14 6d 11 80    	cmp    $0x80116d14,%edx
8010464c:	73 0e                	jae    8010465c <changepri+0x3c>
    if ( p->pid == pid ) {
8010464e:	39 5a 10             	cmp    %ebx,0x10(%edx)
80104651:	75 ed                	jne    80104640 <changepri+0x20>
    p->priority = priority;
80104653:	8b 45 0c             	mov    0xc(%ebp),%eax
80104656:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
    break;
    }
  }
  //释放锁
  release(&ptable.lock);
8010465c:	83 ec 0c             	sub    $0xc,%esp
8010465f:	68 e0 48 11 80       	push   $0x801148e0
80104664:	e8 b7 05 00 00       	call   80104c20 <release>
  return pid;
}
80104669:	89 d8                	mov    %ebx,%eax
8010466b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010466e:	c9                   	leave  
8010466f:	c3                   	ret    

80104670 <wakeup1p>:

//只唤醒特定信号量的进程的函数
void wakeup1p(void *chan) {
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	53                   	push   %ebx
80104674:	83 ec 10             	sub    $0x10,%esp
80104677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);//加锁
8010467a:	68 e0 48 11 80       	push   $0x801148e0
8010467f:	e8 dc 03 00 00       	call   80104a60 <acquire>
80104684:	83 c4 10             	add    $0x10,%esp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {//遍历进程
80104687:	b8 14 49 11 80       	mov    $0x80114914,%eax
8010468c:	eb 0e                	jmp    8010469c <wakeup1p+0x2c>
8010468e:	66 90                	xchg   %ax,%ax
80104690:	05 90 00 00 00       	add    $0x90,%eax
80104695:	3d 14 6d 11 80       	cmp    $0x80116d14,%eax
8010469a:	73 12                	jae    801046ae <wakeup1p+0x3e>
    if(p->state == SLEEPING && p->chan == chan) {//找到该信号量对应进程，若其属于睡眠或阻塞
8010469c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046a0:	75 ee                	jne    80104690 <wakeup1p+0x20>
801046a2:	39 58 20             	cmp    %ebx,0x20(%eax)
801046a5:	75 e9                	jne    80104690 <wakeup1p+0x20>
      p->state = RUNNABLE;//让该进程处于就绪状态
801046a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      break;
    }
  }
  release(&ptable.lock);//释放锁
801046ae:	c7 45 08 e0 48 11 80 	movl   $0x801148e0,0x8(%ebp)
}
801046b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b8:	c9                   	leave  
  release(&ptable.lock);//释放锁
801046b9:	e9 62 05 00 00       	jmp    80104c20 <release>
801046be:	66 90                	xchg   %ax,%ax

801046c0 <myMalloc>:

//进程页表分配
void* myMalloc(int size){
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	53                   	push   %ebx
801046c4:	83 ec 08             	sub    $0x8,%esp
  //获取分配slab后低12位物理页地址偏移
  int page_offset=slab_alloc(proc->pgdir,(char*)proc->sz,size);
801046c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046cd:	ff 75 08             	pushl  0x8(%ebp)
801046d0:	ff 30                	pushl  (%eax)
801046d2:	ff 70 04             	pushl  0x4(%eax)
801046d5:	e8 d6 37 00 00       	call   80107eb0 <slab_alloc>
  uint oldsize=proc->sz;//记录进程原本大小
801046da:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
801046e1:	8b 11                	mov    (%ecx),%edx
  proc->sz+=4096;//虚拟页之间增加间隔4kb也就是一页，让他们每个虚拟地址有个单独的页表项
801046e3:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
  return (void*)oldsize+page_offset;//返回分配后的物理地址末端
801046e9:	01 d0                	add    %edx,%eax
  proc->sz+=4096;//虚拟页之间增加间隔4kb也就是一页，让他们每个虚拟地址有个单独的页表项
801046eb:	89 19                	mov    %ebx,(%ecx)
}
801046ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f0:	c9                   	leave  
801046f1:	c3                   	ret    
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <myFree>:

int myFree(void* va){
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	83 ec 10             	sub    $0x10,%esp
  int res = slab_free(proc->pgdir,va);//释放slab
80104706:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010470c:	ff 75 08             	pushl  0x8(%ebp)
8010470f:	ff 70 04             	pushl  0x4(%eax)
80104712:	e8 69 38 00 00       	call   80107f80 <slab_free>
  return res;//返回结果
}
80104717:	c9                   	leave  
80104718:	c3                   	ret    
80104719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104720 <myFork>:

int myFork(void){
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	57                   	push   %edi
80104724:	56                   	push   %esi
80104725:	53                   	push   %ebx
80104726:	83 ec 18             	sub    $0x18,%esp
  int i,pid;
  struct proc *np;

  acquire(&ptable.lock);
80104729:	68 e0 48 11 80       	push   $0x801148e0
8010472e:	e8 2d 03 00 00       	call   80104a60 <acquire>
  if((np=allocproc())==0){
80104733:	e8 18 f4 ff ff       	call   80103b50 <allocproc>
80104738:	83 c4 10             	add    $0x10,%esp
8010473b:	85 c0                	test   %eax,%eax
8010473d:	0f 84 c5 00 00 00    	je     80104808 <myFork+0xe8>
80104743:	89 c3                	mov    %eax,%ebx
    release(&ptable.lock);
    return -1;
  }
  //复制页表变成copyuvm_onwrite
  np->pgdir = copyuvm_onwrite(proc->pgdir,proc->sz);
80104745:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010474b:	83 ec 08             	sub    $0x8,%esp
8010474e:	ff 30                	pushl  (%eax)
80104750:	ff 70 04             	pushl  0x4(%eax)
80104753:	e8 d8 38 00 00       	call   80108030 <copyuvm_onwrite>
80104758:	89 43 04             	mov    %eax,0x4(%ebx)

  np->sz = proc->sz;
8010475b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent=proc;
  *np->tf=*proc->tf;
80104761:	b9 13 00 00 00       	mov    $0x13,%ecx
80104766:	8b 7b 18             	mov    0x18(%ebx),%edi
80104769:	83 c4 10             	add    $0x10,%esp
  np->sz = proc->sz;
8010476c:	8b 00                	mov    (%eax),%eax
8010476e:	89 03                	mov    %eax,(%ebx)
  np->parent=proc;
80104770:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104776:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf=*proc->tf;
80104779:	8b 70 18             	mov    0x18(%eax),%esi
8010477c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax=0;
  for(i = 0; i < NOFILE; i++)
8010477e:	31 f6                	xor    %esi,%esi
  np->tf->eax=0;
80104780:	8b 43 18             	mov    0x18(%ebx),%eax
80104783:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010478a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80104791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->ofile[i])
80104798:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
8010479c:	85 c0                	test   %eax,%eax
8010479e:	74 17                	je     801047b7 <myFork+0x97>
      np->ofile[i] = filedup(proc->ofile[i]);
801047a0:	83 ec 0c             	sub    $0xc,%esp
801047a3:	50                   	push   %eax
801047a4:	e8 27 c7 ff ff       	call   80100ed0 <filedup>
801047a9:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
801047ad:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047b4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
801047b7:	83 c6 01             	add    $0x1,%esi
801047ba:	83 fe 10             	cmp    $0x10,%esi
801047bd:	75 d9                	jne    80104798 <myFork+0x78>
  np->cwd = idup(proc->cwd);
801047bf:	83 ec 0c             	sub    $0xc,%esp
801047c2:	ff 72 68             	pushl  0x68(%edx)
801047c5:	e8 b6 cf ff ff       	call   80101780 <idup>
801047ca:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801047cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047d3:	83 c4 0c             	add    $0xc,%esp
801047d6:	6a 10                	push   $0x10
801047d8:	83 c0 6c             	add    $0x6c,%eax
801047db:	50                   	push   %eax
801047dc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801047df:	50                   	push   %eax
801047e0:	e8 fb 08 00 00       	call   801050e0 <safestrcpy>

  pid = np->pid;

  np->state = RUNNABLE;
801047e5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pid = np->pid;
801047ec:	8b 73 10             	mov    0x10(%ebx),%esi

  release(&ptable.lock);
801047ef:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
801047f6:	e8 25 04 00 00       	call   80104c20 <release>

  return pid;
801047fb:	83 c4 10             	add    $0x10,%esp
}
801047fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104801:	89 f0                	mov    %esi,%eax
80104803:	5b                   	pop    %ebx
80104804:	5e                   	pop    %esi
80104805:	5f                   	pop    %edi
80104806:	5d                   	pop    %ebp
80104807:	c3                   	ret    
    release(&ptable.lock);
80104808:	83 ec 0c             	sub    $0xc,%esp
    return -1;
8010480b:	be ff ff ff ff       	mov    $0xffffffff,%esi
    release(&ptable.lock);
80104810:	68 e0 48 11 80       	push   $0x801148e0
80104815:	e8 06 04 00 00       	call   80104c20 <release>
    return -1;
8010481a:	83 c4 10             	add    $0x10,%esp
8010481d:	eb df                	jmp    801047fe <myFork+0xde>
8010481f:	90                   	nop

80104820 <clone>:


//用 clone()前需要分配好线程栈的内存空间，并通过 stack 参数传入
int clone(void(*fcn)(void*), void* arg, void* stack)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	53                   	push   %ebx
80104826:	83 ec 1c             	sub    $0x1c,%esp
  // cprintf("in clone, stack start addr = %p\n", stack); //打印本线程的堆栈
  struct proc *curproc = proc; // 记录发出 clone 的进程（ np->pthread 记录的父线程）
80104829:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104830:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct proc *np;
  if((np = allocproc()) == 0) //为新线程分配 PCB/TCB
80104833:	e8 18 f3 ff ff       	call   80103b50 <allocproc>
80104838:	85 c0                	test   %eax,%eax
8010483a:	0f 84 ed 00 00 00    	je     8010492d <clone+0x10d>
    return -1;
  //由于共享进程映像，只需使用同一个页表即可，无需拷贝内容
  np->pgdir = curproc->pgdir; // 线程间共用同一个页表
80104840:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104843:	89 c3                	mov    %eax,%ebx
  np->sz = curproc->sz;
  np->pthread = curproc; // exit 时用于找到父进程并唤醒
  np->ustack = stack; //设置自己的线程栈
  np->parent = 0;
  *np->tf = *curproc->tf; // 继承 trapframe
80104845:	b9 13 00 00 00       	mov    $0x13,%ecx
8010484a:	8b 7b 18             	mov    0x18(%ebx),%edi
  np->pgdir = curproc->pgdir; // 线程间共用同一个页表
8010484d:	8b 42 04             	mov    0x4(%edx),%eax
80104850:	89 43 04             	mov    %eax,0x4(%ebx)
  np->sz = curproc->sz;
80104853:	8b 02                	mov    (%edx),%eax
  np->pthread = curproc; // exit 时用于找到父进程并唤醒
80104855:	89 93 84 00 00 00    	mov    %edx,0x84(%ebx)
  np->parent = 0;
8010485b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  np->sz = curproc->sz;
80104862:	89 03                	mov    %eax,(%ebx)
  np->ustack = stack; //设置自己的线程栈
80104864:	8b 45 10             	mov    0x10(%ebp),%eax
80104867:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  *np->tf = *curproc->tf; // 继承 trapframe
8010486d:	8b 72 18             	mov    0x18(%edx),%esi
80104870:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  int* sp = stack + 4096 - 8; //下面将在线程栈填写 8 字节内容
  //在内核栈中“伪造”现场，假装成返回地址是 fcn、用户堆栈是线程栈
  np->tf->eip = (int)fcn;
80104872:	8b 4d 08             	mov    0x8(%ebp),%ecx
  np->tf->ebp = (int)sp; // 栈帧指针
  np->tf->eax = 0;
  // 在用户态栈“伪造”现场，将参数和返回地址（无用的）保存在里面
  *(sp + 1) = (int)arg; // *(np->tf->esp+4) = (int)arg
  *sp = 0xffffffff; // 返回地址（没有用到）
  for(int i = 0; i < NOFILE; i++) // 复制文件描述符
80104875:	31 f6                	xor    %esi,%esi
80104877:	89 d7                	mov    %edx,%edi
  np->tf->eip = (int)fcn;
80104879:	8b 43 18             	mov    0x18(%ebx),%eax
8010487c:	89 48 38             	mov    %ecx,0x38(%eax)
  int* sp = stack + 4096 - 8; //下面将在线程栈填写 8 字节内容
8010487f:	8b 45 10             	mov    0x10(%ebp),%eax
  np->tf->esp = (int)sp; // top of stack
80104882:	8b 4b 18             	mov    0x18(%ebx),%ecx
  int* sp = stack + 4096 - 8; //下面将在线程栈填写 8 字节内容
80104885:	05 f8 0f 00 00       	add    $0xff8,%eax
  np->tf->esp = (int)sp; // top of stack
8010488a:	89 41 44             	mov    %eax,0x44(%ecx)
  np->tf->ebp = (int)sp; // 栈帧指针
8010488d:	8b 4b 18             	mov    0x18(%ebx),%ecx
80104890:	89 41 08             	mov    %eax,0x8(%ecx)
  np->tf->eax = 0;
80104893:	8b 43 18             	mov    0x18(%ebx),%eax
  *(sp + 1) = (int)arg; // *(np->tf->esp+4) = (int)arg
80104896:	8b 4d 10             	mov    0x10(%ebp),%ecx
  np->tf->eax = 0;
80104899:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  *(sp + 1) = (int)arg; // *(np->tf->esp+4) = (int)arg
801048a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  *sp = 0xffffffff; // 返回地址（没有用到）
801048a3:	c7 81 f8 0f 00 00 ff 	movl   $0xffffffff,0xff8(%ecx)
801048aa:	ff ff ff 
  *(sp + 1) = (int)arg; // *(np->tf->esp+4) = (int)arg
801048ad:	89 81 fc 0f 00 00    	mov    %eax,0xffc(%ecx)
801048b3:	90                   	nop
801048b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801048b8:	8b 44 b7 28          	mov    0x28(%edi,%esi,4),%eax
801048bc:	85 c0                	test   %eax,%eax
801048be:	74 10                	je     801048d0 <clone+0xb0>
      np->ofile[i] = filedup(curproc->ofile[i]);
801048c0:	83 ec 0c             	sub    $0xc,%esp
801048c3:	50                   	push   %eax
801048c4:	e8 07 c6 ff ff       	call   80100ed0 <filedup>
801048c9:	83 c4 10             	add    $0x10,%esp
801048cc:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  for(int i = 0; i < NOFILE; i++) // 复制文件描述符
801048d0:	83 c6 01             	add    $0x1,%esi
801048d3:	83 fe 10             	cmp    $0x10,%esi
801048d6:	75 e0                	jne    801048b8 <clone+0x98>
  np->cwd = idup(curproc->cwd);
801048d8:	83 ec 0c             	sub    $0xc,%esp
801048db:	ff 77 68             	pushl  0x68(%edi)
801048de:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801048e1:	e8 9a ce ff ff       	call   80101780 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801048e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  np->cwd = idup(curproc->cwd);
801048e9:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801048ec:	8d 43 6c             	lea    0x6c(%ebx),%eax
801048ef:	83 c4 0c             	add    $0xc,%esp
801048f2:	6a 10                	push   $0x10
801048f4:	83 c2 6c             	add    $0x6c,%edx
801048f7:	52                   	push   %edx
801048f8:	50                   	push   %eax
801048f9:	e8 e2 07 00 00       	call   801050e0 <safestrcpy>
  int pid = np->pid;
801048fe:	8b 73 10             	mov    0x10(%ebx),%esi
  acquire(&ptable.lock);
80104901:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
80104908:	e8 53 01 00 00       	call   80104a60 <acquire>
  np->state = RUNNABLE;
8010490d:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104914:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
8010491b:	e8 00 03 00 00       	call   80104c20 <release>
  // 返回新线程的 pid
  return pid;
80104920:	83 c4 10             	add    $0x10,%esp
}
80104923:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104926:	89 f0                	mov    %esi,%eax
80104928:	5b                   	pop    %ebx
80104929:	5e                   	pop    %esi
8010492a:	5f                   	pop    %edi
8010492b:	5d                   	pop    %ebp
8010492c:	c3                   	ret    
    return -1;
8010492d:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104932:	eb ef                	jmp    80104923 <clone+0x103>
80104934:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010493a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104940 <join>:

int join(void** stack)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
  // cprintf("in join, stack pointer = %p\n", *stack);
  struct proc *curproc = proc;
80104945:	65 8b 35 04 00 00 00 	mov    %gs:0x4,%esi
  struct proc *p;
  int havekids;
  acquire(&ptable.lock);
8010494c:	83 ec 0c             	sub    $0xc,%esp
8010494f:	68 e0 48 11 80       	push   $0x801148e0
80104954:	e8 07 01 00 00       	call   80104a60 <acquire>
80104959:	83 c4 10             	add    $0x10,%esp
  for(;;) {
    // scan through table looking for zombie children
    havekids = 0;
8010495c:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010495e:	bb 14 49 11 80       	mov    $0x80114914,%ebx
80104963:	eb 11                	jmp    80104976 <join+0x36>
80104965:	8d 76 00             	lea    0x0(%esi),%esi
80104968:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010496e:	81 fb 14 6d 11 80    	cmp    $0x80116d14,%ebx
80104974:	73 21                	jae    80104997 <join+0x57>
      if(p->pthread != curproc) //判定是否自己的子线程
80104976:	39 b3 84 00 00 00    	cmp    %esi,0x84(%ebx)
8010497c:	75 ea                	jne    80104968 <join+0x28>
        continue;

      havekids = 1;
      if(p->state == ZOMBIE) {
8010497e:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104982:	74 34                	je     801049b8 <join+0x78>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104984:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
8010498a:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010498f:	81 fb 14 6d 11 80    	cmp    $0x80116d14,%ebx
80104995:	72 df                	jb     80104976 <join+0x36>
        return pid;
      }
    }

    // No point waiting if we don't have any children
    if(!havekids || curproc->killed) {
80104997:	85 c0                	test   %eax,%eax
80104999:	74 7f                	je     80104a1a <join+0xda>
8010499b:	8b 46 24             	mov    0x24(%esi),%eax
8010499e:	85 c0                	test   %eax,%eax
801049a0:	75 78                	jne    80104a1a <join+0xda>
    release(&ptable.lock);
      return -1;
    }
    // Wait for children to exit
    sleep(curproc, &ptable.lock);
801049a2:	83 ec 08             	sub    $0x8,%esp
801049a5:	68 e0 48 11 80       	push   $0x801148e0
801049aa:	56                   	push   %esi
801049ab:	e8 00 f9 ff ff       	call   801042b0 <sleep>
    havekids = 0;
801049b0:	83 c4 10             	add    $0x10,%esp
801049b3:	eb a7                	jmp    8010495c <join+0x1c>
801049b5:	8d 76 00             	lea    0x0(%esi),%esi
        *stack = p->ustack;
801049b8:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
801049be:	8b 45 08             	mov    0x8(%ebp),%eax
        kfree(p->kstack); //释放内核栈
801049c1:	83 ec 0c             	sub    $0xc,%esp
        *stack = p->ustack;
801049c4:	89 10                	mov    %edx,(%eax)
        kfree(p->kstack); //释放内核栈
801049c6:	ff 73 08             	pushl  0x8(%ebx)
        int pid = p->pid;
801049c9:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack); //释放内核栈
801049cc:	e8 af db ff ff       	call   80102580 <kfree>
        release(&ptable.lock);
801049d1:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
        p->kstack = 0;
801049d8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        p->state = UNUSED;
801049df:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
801049e6:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801049ed:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->pthread = 0; // 记录父线程的指针 p->ustack = 0; // 线程用户态栈
801049f4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801049fb:	00 00 00 
        p->name[0] = 0;
801049fe:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104a02:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        release(&ptable.lock);
80104a09:	e8 12 02 00 00       	call   80104c20 <release>
        return pid;
80104a0e:	83 c4 10             	add    $0x10,%esp
  }
 return 0;
80104a11:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a14:	89 f0                	mov    %esi,%eax
80104a16:	5b                   	pop    %ebx
80104a17:	5e                   	pop    %esi
80104a18:	5d                   	pop    %ebp
80104a19:	c3                   	ret    
    release(&ptable.lock);
80104a1a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a1d:	be ff ff ff ff       	mov    $0xffffffff,%esi
    release(&ptable.lock);
80104a22:	68 e0 48 11 80       	push   $0x801148e0
80104a27:	e8 f4 01 00 00       	call   80104c20 <release>
      return -1;
80104a2c:	83 c4 10             	add    $0x10,%esp
80104a2f:	eb e0                	jmp    80104a11 <join+0xd1>
80104a31:	66 90                	xchg   %ax,%ax
80104a33:	66 90                	xchg   %ax,%ax
80104a35:	66 90                	xchg   %ax,%ax
80104a37:	66 90                	xchg   %ax,%ax
80104a39:	66 90                	xchg   %ax,%ax
80104a3b:	66 90                	xchg   %ax,%ax
80104a3d:	66 90                	xchg   %ax,%ax
80104a3f:	90                   	nop

80104a40 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a4f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a59:	5d                   	pop    %ebp
80104a5a:	c3                   	ret    
80104a5b:	90                   	nop
80104a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a60 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 04             	sub    $0x4,%esp
80104a67:	9c                   	pushf  
80104a68:	5a                   	pop    %edx
  asm volatile("cli");
80104a69:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104a6a:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80104a71:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
80104a77:	85 c0                	test   %eax,%eax
80104a79:	75 0c                	jne    80104a87 <acquire+0x27>
    cpu->intena = eflags & FL_IF;
80104a7b:	81 e2 00 02 00 00    	and    $0x200,%edx
80104a81:	89 91 b0 00 00 00    	mov    %edx,0xb0(%ecx)
  if(holding(lk))
80104a87:	8b 55 08             	mov    0x8(%ebp),%edx
  cpu->ncli += 1;
80104a8a:	83 c0 01             	add    $0x1,%eax
80104a8d:	89 81 ac 00 00 00    	mov    %eax,0xac(%ecx)
  return lock->locked && lock->cpu == cpu;
80104a93:	8b 02                	mov    (%edx),%eax
80104a95:	85 c0                	test   %eax,%eax
80104a97:	74 05                	je     80104a9e <acquire+0x3e>
80104a99:	39 4a 08             	cmp    %ecx,0x8(%edx)
80104a9c:	74 74                	je     80104b12 <acquire+0xb2>
  asm volatile("lock; xchgl %0, %1" :
80104a9e:	b9 01 00 00 00       	mov    $0x1,%ecx
80104aa3:	90                   	nop
80104aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aa8:	89 c8                	mov    %ecx,%eax
80104aaa:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
80104aad:	85 c0                	test   %eax,%eax
80104aaf:	75 f7                	jne    80104aa8 <acquire+0x48>
  __sync_synchronize();
80104ab1:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = cpu;
80104ab6:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ab9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  for(i = 0; i < 10; i++){
80104abf:	31 d2                	xor    %edx,%edx
  lk->cpu = cpu;
80104ac1:	89 41 08             	mov    %eax,0x8(%ecx)
  getcallerpcs(&lk, lk->pcs);
80104ac4:	83 c1 0c             	add    $0xc,%ecx
  ebp = (uint*)v - 2;
80104ac7:	89 e8                	mov    %ebp,%eax
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ad0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ad6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104adc:	77 1a                	ja     80104af8 <acquire+0x98>
    pcs[i] = ebp[1];     // saved %eip
80104ade:	8b 58 04             	mov    0x4(%eax),%ebx
80104ae1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104ae4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104ae7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ae9:	83 fa 0a             	cmp    $0xa,%edx
80104aec:	75 e2                	jne    80104ad0 <acquire+0x70>
}
80104aee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af1:	c9                   	leave  
80104af2:	c3                   	ret    
80104af3:	90                   	nop
80104af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104af8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104afb:	83 c1 28             	add    $0x28,%ecx
80104afe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104b00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b06:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104b09:	39 c8                	cmp    %ecx,%eax
80104b0b:	75 f3                	jne    80104b00 <acquire+0xa0>
}
80104b0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b10:	c9                   	leave  
80104b11:	c3                   	ret    
    panic("acquire");
80104b12:	83 ec 0c             	sub    $0xc,%esp
80104b15:	68 d0 8a 10 80       	push   $0x80108ad0
80104b1a:	e8 61 b9 ff ff       	call   80100480 <panic>
80104b1f:	90                   	nop

80104b20 <getcallerpcs>:
{
80104b20:	55                   	push   %ebp
  for(i = 0; i < 10; i++){
80104b21:	31 d2                	xor    %edx,%edx
{
80104b23:	89 e5                	mov    %esp,%ebp
80104b25:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104b26:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104b29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104b2c:	83 e8 08             	sub    $0x8,%eax
80104b2f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b30:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b36:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b3c:	77 1a                	ja     80104b58 <getcallerpcs+0x38>
    pcs[i] = ebp[1];     // saved %eip
80104b3e:	8b 58 04             	mov    0x4(%eax),%ebx
80104b41:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b44:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b47:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b49:	83 fa 0a             	cmp    $0xa,%edx
80104b4c:	75 e2                	jne    80104b30 <getcallerpcs+0x10>
}
80104b4e:	5b                   	pop    %ebx
80104b4f:	5d                   	pop    %ebp
80104b50:	c3                   	ret    
80104b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b58:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b5b:	83 c1 28             	add    $0x28,%ecx
80104b5e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104b60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b66:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104b69:	39 c1                	cmp    %eax,%ecx
80104b6b:	75 f3                	jne    80104b60 <getcallerpcs+0x40>
}
80104b6d:	5b                   	pop    %ebx
80104b6e:	5d                   	pop    %ebp
80104b6f:	c3                   	ret    

80104b70 <holding>:
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104b76:	8b 02                	mov    (%edx),%eax
80104b78:	85 c0                	test   %eax,%eax
80104b7a:	74 14                	je     80104b90 <holding+0x20>
80104b7c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b82:	39 42 08             	cmp    %eax,0x8(%edx)
}
80104b85:	5d                   	pop    %ebp
  return lock->locked && lock->cpu == cpu;
80104b86:	0f 94 c0             	sete   %al
80104b89:	0f b6 c0             	movzbl %al,%eax
}
80104b8c:	c3                   	ret    
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
80104b90:	31 c0                	xor    %eax,%eax
80104b92:	5d                   	pop    %ebp
80104b93:	c3                   	ret    
80104b94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ba0 <pushcli>:
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ba3:	9c                   	pushf  
80104ba4:	59                   	pop    %ecx
  asm volatile("cli");
80104ba5:	fa                   	cli    
  if(cpu->ncli == 0)
80104ba6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104bad:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104bb3:	85 c0                	test   %eax,%eax
80104bb5:	75 0c                	jne    80104bc3 <pushcli+0x23>
    cpu->intena = eflags & FL_IF;
80104bb7:	81 e1 00 02 00 00    	and    $0x200,%ecx
80104bbd:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
  cpu->ncli += 1;
80104bc3:	83 c0 01             	add    $0x1,%eax
80104bc6:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
}
80104bcc:	5d                   	pop    %ebp
80104bcd:	c3                   	ret    
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <popcli>:

void
popcli(void)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bd6:	9c                   	pushf  
80104bd7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104bd8:	f6 c4 02             	test   $0x2,%ah
80104bdb:	75 2c                	jne    80104c09 <popcli+0x39>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
80104bdd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104be4:	83 aa ac 00 00 00 01 	subl   $0x1,0xac(%edx)
80104beb:	78 0f                	js     80104bfc <popcli+0x2c>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
80104bed:	75 0b                	jne    80104bfa <popcli+0x2a>
80104bef:	8b 82 b0 00 00 00    	mov    0xb0(%edx),%eax
80104bf5:	85 c0                	test   %eax,%eax
80104bf7:	74 01                	je     80104bfa <popcli+0x2a>
  asm volatile("sti");
80104bf9:	fb                   	sti    
    sti();
}
80104bfa:	c9                   	leave  
80104bfb:	c3                   	ret    
    panic("popcli");
80104bfc:	83 ec 0c             	sub    $0xc,%esp
80104bff:	68 ef 8a 10 80       	push   $0x80108aef
80104c04:	e8 77 b8 ff ff       	call   80100480 <panic>
    panic("popcli - interruptible");
80104c09:	83 ec 0c             	sub    $0xc,%esp
80104c0c:	68 d8 8a 10 80       	push   $0x80108ad8
80104c11:	e8 6a b8 ff ff       	call   80100480 <panic>
80104c16:	8d 76 00             	lea    0x0(%esi),%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c20 <release>:
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	83 ec 08             	sub    $0x8,%esp
80104c26:	8b 45 08             	mov    0x8(%ebp),%eax
  return lock->locked && lock->cpu == cpu;
80104c29:	8b 10                	mov    (%eax),%edx
80104c2b:	85 d2                	test   %edx,%edx
80104c2d:	74 2b                	je     80104c5a <release+0x3a>
80104c2f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c36:	39 50 08             	cmp    %edx,0x8(%eax)
80104c39:	75 1f                	jne    80104c5a <release+0x3a>
  lk->pcs[0] = 0;
80104c3b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104c42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  __sync_synchronize();
80104c49:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->locked = 0;
80104c4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80104c54:	c9                   	leave  
  popcli();
80104c55:	e9 76 ff ff ff       	jmp    80104bd0 <popcli>
    panic("release");
80104c5a:	83 ec 0c             	sub    $0xc,%esp
80104c5d:	68 f6 8a 10 80       	push   $0x80108af6
80104c62:	e8 19 b8 ff ff       	call   80100480 <panic>
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <initsem>:
//资源计数初值为0
int sem_used_count =0;
//定义sems数组
struct sem sems[SEM_MAX_NUM];
//初始化信号量
void initsem () {
80104c70:	55                   	push   %ebp
80104c71:	b8 20 6d 11 80       	mov    $0x80116d20,%eax
80104c76:	89 e5                	mov    %esp,%ebp
80104c78:	90                   	nop
80104c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lk->name = name;
80104c80:	c7 40 04 fe 8a 10 80 	movl   $0x80108afe,0x4(%eax)
  lk->locked = 0;
80104c87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104c8d:	83 c0 40             	add    $0x40,%eax
  lk->cpu = 0;
80104c90:	c7 40 c8 00 00 00 00 	movl   $0x0,-0x38(%eax)
int i;
//对每个信号量添加自旋锁
for(i=0;i<SEM_MAX_NUM;i++){
  initlock(&(sems[i].lock), "semaphore");
  sems[i].allocated=0;//每个信号量状态初始化为未分配
80104c97:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
for(i=0;i<SEM_MAX_NUM;i++){
80104c9e:	3d 20 8d 11 80       	cmp    $0x80118d20,%eax
80104ca3:	75 db                	jne    80104c80 <initsem+0x10>
}
return;
}
80104ca5:	5d                   	pop    %ebp
80104ca6:	c3                   	ret    
80104ca7:	89 f6                	mov    %esi,%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cb0 <sys_sem_create>:

//创建信号量
int sys_sem_create() {
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	53                   	push   %ebx
  int n_sem, i;
  if(argint(0, &n_sem) < 0 )//error检测
80104cb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sem_create() {
80104cb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(0, &n_sem) < 0 )//error检测
80104cbb:	50                   	push   %eax
80104cbc:	6a 00                	push   $0x0
80104cbe:	e8 1d 05 00 00       	call   801051e0 <argint>
80104cc3:	83 c4 10             	add    $0x10,%esp
80104cc6:	85 c0                	test   %eax,%eax
80104cc8:	78 76                	js     80104d40 <sys_sem_create+0x90>
80104cca:	bb 20 6d 11 80       	mov    $0x80116d20,%ebx
    return -1;
  for(i = 0; i < SEM_MAX_NUM; i++) {
80104ccf:	31 f6                	xor    %esi,%esi
80104cd1:	eb 1f                	jmp    80104cf2 <sys_sem_create+0x42>
80104cd3:	90                   	nop
80104cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sems[i].resource_count = n_sem;
      cprintf("create %d sem\n",i);
      release(&sems[i].lock);//解该信号量自旋锁
      return i;
    }
    release(&sems[i].lock);//解开信号量id自旋锁
80104cd8:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < SEM_MAX_NUM; i++) {
80104cdb:	83 c6 01             	add    $0x1,%esi
    release(&sems[i].lock);//解开信号量id自旋锁
80104cde:	53                   	push   %ebx
80104cdf:	83 c3 40             	add    $0x40,%ebx
80104ce2:	e8 39 ff ff ff       	call   80104c20 <release>
  for(i = 0; i < SEM_MAX_NUM; i++) {
80104ce7:	83 c4 10             	add    $0x10,%esp
80104cea:	81 fe 80 00 00 00    	cmp    $0x80,%esi
80104cf0:	74 4e                	je     80104d40 <sys_sem_create+0x90>
    acquire(&sems[i].lock);//加自旋锁
80104cf2:	83 ec 0c             	sub    $0xc,%esp
80104cf5:	53                   	push   %ebx
80104cf6:	e8 65 fd ff ff       	call   80104a60 <acquire>
    if(sems[i].allocated == 0) {//如果该信号量未被分配，那就将参数的信号量分配给他
80104cfb:	8b 43 3c             	mov    0x3c(%ebx),%eax
80104cfe:	83 c4 10             	add    $0x10,%esp
80104d01:	85 c0                	test   %eax,%eax
80104d03:	75 d3                	jne    80104cd8 <sys_sem_create+0x28>
      cprintf("create %d sem\n",i);
80104d05:	83 ec 08             	sub    $0x8,%esp
      sems[i].resource_count = n_sem;
80104d08:	8b 55 f4             	mov    -0xc(%ebp),%edx
      sems[i].allocated = 1;
80104d0b:	89 f0                	mov    %esi,%eax
      cprintf("create %d sem\n",i);
80104d0d:	56                   	push   %esi
80104d0e:	68 08 8b 10 80       	push   $0x80108b08
      sems[i].allocated = 1;
80104d13:	c1 e0 06             	shl    $0x6,%eax
80104d16:	c7 80 5c 6d 11 80 01 	movl   $0x1,-0x7fee92a4(%eax)
80104d1d:	00 00 00 
      sems[i].resource_count = n_sem;
80104d20:	89 90 54 6d 11 80    	mov    %edx,-0x7fee92ac(%eax)
      cprintf("create %d sem\n",i);
80104d26:	e8 25 ba ff ff       	call   80100750 <cprintf>
      release(&sems[i].lock);//解该信号量自旋锁
80104d2b:	89 1c 24             	mov    %ebx,(%esp)
80104d2e:	e8 ed fe ff ff       	call   80104c20 <release>
      return i;
80104d33:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
}
80104d36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d39:	89 f0                	mov    %esi,%eax
80104d3b:	5b                   	pop    %ebx
80104d3c:	5e                   	pop    %esi
80104d3d:	5d                   	pop    %ebp
80104d3e:	c3                   	ret    
80104d3f:	90                   	nop
80104d40:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d43:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
80104d48:	89 f0                	mov    %esi,%eax
80104d4a:	5b                   	pop    %ebx
80104d4b:	5e                   	pop    %esi
80104d4c:	5d                   	pop    %ebp
80104d4d:	c3                   	ret    
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <sys_sem_free>:
//释放信号量函数
int sys_sem_free(){
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	83 ec 20             	sub    $0x20,%esp
  int id;//传进来的参数 为信号量数组下标
  if(argint(0,&id)<0)
80104d56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d59:	50                   	push   %eax
80104d5a:	6a 00                	push   $0x0
80104d5c:	e8 7f 04 00 00       	call   801051e0 <argint>
80104d61:	83 c4 10             	add    $0x10,%esp
80104d64:	85 c0                	test   %eax,%eax
80104d66:	78 70                	js     80104dd8 <sys_sem_free+0x88>
    return -1;
  acquire(&sems[id].lock);//加锁
80104d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6b:	83 ec 0c             	sub    $0xc,%esp
80104d6e:	c1 e0 06             	shl    $0x6,%eax
80104d71:	05 20 6d 11 80       	add    $0x80116d20,%eax
80104d76:	50                   	push   %eax
80104d77:	e8 e4 fc ff ff       	call   80104a60 <acquire>
  if(sems[id].allocated == 1 && sems[id].resource_count > 0){//信号量被分配使用且信号量资源计数大于0
80104d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d7f:	83 c4 10             	add    $0x10,%esp
80104d82:	89 c2                	mov    %eax,%edx
80104d84:	c1 e2 06             	shl    $0x6,%edx
80104d87:	81 c2 20 6d 11 80    	add    $0x80116d20,%edx
80104d8d:	83 7a 3c 01          	cmpl   $0x1,0x3c(%edx)
80104d91:	74 1d                	je     80104db0 <sys_sem_free+0x60>
    sems[id].allocated = 0;//释放信号量
    cprintf("free %d sem\n", id);
  }
  release(&sems[id].lock);//解锁
80104d93:	c1 e0 06             	shl    $0x6,%eax
80104d96:	83 ec 0c             	sub    $0xc,%esp
80104d99:	05 20 6d 11 80       	add    $0x80116d20,%eax
80104d9e:	50                   	push   %eax
80104d9f:	e8 7c fe ff ff       	call   80104c20 <release>
  return 0;
80104da4:	83 c4 10             	add    $0x10,%esp
80104da7:	31 c0                	xor    %eax,%eax
}
80104da9:	c9                   	leave  
80104daa:	c3                   	ret    
80104dab:	90                   	nop
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(sems[id].allocated == 1 && sems[id].resource_count > 0){//信号量被分配使用且信号量资源计数大于0
80104db0:	8b 4a 34             	mov    0x34(%edx),%ecx
80104db3:	85 c9                	test   %ecx,%ecx
80104db5:	7e dc                	jle    80104d93 <sys_sem_free+0x43>
    cprintf("free %d sem\n", id);
80104db7:	83 ec 08             	sub    $0x8,%esp
    sems[id].allocated = 0;//释放信号量
80104dba:	c7 42 3c 00 00 00 00 	movl   $0x0,0x3c(%edx)
    cprintf("free %d sem\n", id);
80104dc1:	50                   	push   %eax
80104dc2:	68 17 8b 10 80       	push   $0x80108b17
80104dc7:	e8 84 b9 ff ff       	call   80100750 <cprintf>
80104dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dcf:	83 c4 10             	add    $0x10,%esp
80104dd2:	eb bf                	jmp    80104d93 <sys_sem_free+0x43>
80104dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104dd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ddd:	c9                   	leave  
80104dde:	c3                   	ret    
80104ddf:	90                   	nop

80104de0 <sys_sem_p>:
//信号量--函数
int sys_sem_p()
{ 
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	83 ec 20             	sub    $0x20,%esp
  int id;//穿的参数  为信号量下标
  if(argint(0, &id) < 0)
80104de6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104de9:	50                   	push   %eax
80104dea:	6a 00                	push   $0x0
80104dec:	e8 ef 03 00 00       	call   801051e0 <argint>
80104df1:	83 c4 10             	add    $0x10,%esp
80104df4:	85 c0                	test   %eax,%eax
80104df6:	78 68                	js     80104e60 <sys_sem_p+0x80>
    return -1;
  acquire(&sems[id].lock);//加锁
80104df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dfb:	83 ec 0c             	sub    $0xc,%esp
80104dfe:	c1 e0 06             	shl    $0x6,%eax
80104e01:	05 20 6d 11 80       	add    $0x80116d20,%eax
80104e06:	50                   	push   %eax
80104e07:	e8 54 fc ff ff       	call   80104a60 <acquire>
  sems[id]. resource_count--;//资源计数-1
80104e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  if(sems[id].resource_count<0) //首次进入、或被唤醒时，资源不足
80104e0f:	83 c4 10             	add    $0x10,%esp
  sems[id]. resource_count--;//资源计数-1
80104e12:	c1 e0 06             	shl    $0x6,%eax
80104e15:	05 20 6d 11 80       	add    $0x80116d20,%eax
80104e1a:	8b 48 34             	mov    0x34(%eax),%ecx
80104e1d:	8d 51 ff             	lea    -0x1(%ecx),%edx
  if(sems[id].resource_count<0) //首次进入、或被唤醒时，资源不足
80104e20:	85 d2                	test   %edx,%edx
  sems[id]. resource_count--;//资源计数-1
80104e22:	89 50 34             	mov    %edx,0x34(%eax)
  if(sems[id].resource_count<0) //首次进入、或被唤醒时，资源不足
80104e25:	78 19                	js     80104e40 <sys_sem_p+0x60>
    sleep(&sems[id],&sems[id].lock); //睡眠（会释放 sems[id].lock 才阻塞）
  release(&sems[id].lock); //解锁（唤醒到此处时，重新持有 sems[id].lock）
80104e27:	83 ec 0c             	sub    $0xc,%esp
80104e2a:	50                   	push   %eax
80104e2b:	e8 f0 fd ff ff       	call   80104c20 <release>
  return 0; //此时获得信号量资源
80104e30:	83 c4 10             	add    $0x10,%esp
80104e33:	31 c0                	xor    %eax,%eax
}
80104e35:	c9                   	leave  
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    sleep(&sems[id],&sems[id].lock); //睡眠（会释放 sems[id].lock 才阻塞）
80104e40:	83 ec 08             	sub    $0x8,%esp
80104e43:	50                   	push   %eax
80104e44:	50                   	push   %eax
80104e45:	e8 66 f4 ff ff       	call   801042b0 <sleep>
80104e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e4d:	83 c4 10             	add    $0x10,%esp
80104e50:	c1 e0 06             	shl    $0x6,%eax
80104e53:	05 20 6d 11 80       	add    $0x80116d20,%eax
80104e58:	eb cd                	jmp    80104e27 <sys_sem_p+0x47>
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <sys_sem_v>:

//信号量++函数
int sys_sem_v(int sem_id)
{ 
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	83 ec 20             	sub    $0x20,%esp
  int id;//传信号量下标参数
  if(argint(0,&id)<0)
80104e76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e79:	50                   	push   %eax
80104e7a:	6a 00                	push   $0x0
80104e7c:	e8 5f 03 00 00       	call   801051e0 <argint>
80104e81:	83 c4 10             	add    $0x10,%esp
80104e84:	85 c0                	test   %eax,%eax
80104e86:	78 68                	js     80104ef0 <sys_sem_v+0x80>
    return -1;
  acquire(&sems[id].lock);//加锁
80104e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8b:	83 ec 0c             	sub    $0xc,%esp
80104e8e:	c1 e0 06             	shl    $0x6,%eax
80104e91:	05 20 6d 11 80       	add    $0x80116d20,%eax
80104e96:	50                   	push   %eax
80104e97:	e8 c4 fb ff ff       	call   80104a60 <acquire>
  sems[id]. resource_count+=1; //由于释放了信号量，资源计数++
80104e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  if(sems[id].resource_count<1) //有阻塞等待该资源的进程
80104e9f:	83 c4 10             	add    $0x10,%esp
  sems[id]. resource_count+=1; //由于释放了信号量，资源计数++
80104ea2:	c1 e0 06             	shl    $0x6,%eax
80104ea5:	05 20 6d 11 80       	add    $0x80116d20,%eax
80104eaa:	8b 48 34             	mov    0x34(%eax),%ecx
80104ead:	8d 51 01             	lea    0x1(%ecx),%edx
  if(sems[id].resource_count<1) //有阻塞等待该资源的进程
80104eb0:	85 d2                	test   %edx,%edx
  sems[id]. resource_count+=1; //由于释放了信号量，资源计数++
80104eb2:	89 50 34             	mov    %edx,0x34(%eax)
  if(sems[id].resource_count<1) //有阻塞等待该资源的进程
80104eb5:	7e 19                	jle    80104ed0 <sys_sem_v+0x60>
    wakeup1p(&sems[id]); //唤醒等待该资源的 1 个进程
  release(&sems[id].lock); //释放锁
80104eb7:	83 ec 0c             	sub    $0xc,%esp
80104eba:	50                   	push   %eax
80104ebb:	e8 60 fd ff ff       	call   80104c20 <release>
  return 0;
80104ec0:	83 c4 10             	add    $0x10,%esp
80104ec3:	31 c0                	xor    %eax,%eax
}
80104ec5:	c9                   	leave  
80104ec6:	c3                   	ret    
80104ec7:	89 f6                	mov    %esi,%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    wakeup1p(&sems[id]); //唤醒等待该资源的 1 个进程
80104ed0:	83 ec 0c             	sub    $0xc,%esp
80104ed3:	50                   	push   %eax
80104ed4:	e8 97 f7 ff ff       	call   80104670 <wakeup1p>
80104ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104edc:	83 c4 10             	add    $0x10,%esp
80104edf:	c1 e0 06             	shl    $0x6,%eax
80104ee2:	05 20 6d 11 80       	add    $0x80116d20,%eax
80104ee7:	eb ce                	jmp    80104eb7 <sys_sem_v+0x47>
80104ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ef5:	c9                   	leave  
80104ef6:	c3                   	ret    
80104ef7:	66 90                	xchg   %ax,%ax
80104ef9:	66 90                	xchg   %ax,%ax
80104efb:	66 90                	xchg   %ax,%ax
80104efd:	66 90                	xchg   %ax,%ax
80104eff:	90                   	nop

80104f00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	57                   	push   %edi
80104f04:	53                   	push   %ebx
80104f05:	8b 55 08             	mov    0x8(%ebp),%edx
80104f08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104f0b:	f6 c2 03             	test   $0x3,%dl
80104f0e:	75 05                	jne    80104f15 <memset+0x15>
80104f10:	f6 c1 03             	test   $0x3,%cl
80104f13:	74 13                	je     80104f28 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104f15:	89 d7                	mov    %edx,%edi
80104f17:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f1a:	fc                   	cld    
80104f1b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104f1d:	5b                   	pop    %ebx
80104f1e:	89 d0                	mov    %edx,%eax
80104f20:	5f                   	pop    %edi
80104f21:	5d                   	pop    %ebp
80104f22:	c3                   	ret    
80104f23:	90                   	nop
80104f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104f28:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f2c:	c1 e9 02             	shr    $0x2,%ecx
80104f2f:	89 f8                	mov    %edi,%eax
80104f31:	89 fb                	mov    %edi,%ebx
80104f33:	c1 e0 18             	shl    $0x18,%eax
80104f36:	c1 e3 10             	shl    $0x10,%ebx
80104f39:	09 d8                	or     %ebx,%eax
80104f3b:	09 f8                	or     %edi,%eax
80104f3d:	c1 e7 08             	shl    $0x8,%edi
80104f40:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f42:	89 d7                	mov    %edx,%edi
80104f44:	fc                   	cld    
80104f45:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104f47:	5b                   	pop    %ebx
80104f48:	89 d0                	mov    %edx,%eax
80104f4a:	5f                   	pop    %edi
80104f4b:	5d                   	pop    %ebp
80104f4c:	c3                   	ret    
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi

80104f50 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	57                   	push   %edi
80104f54:	56                   	push   %esi
80104f55:	53                   	push   %ebx
80104f56:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104f59:	8b 75 08             	mov    0x8(%ebp),%esi
80104f5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f5f:	85 db                	test   %ebx,%ebx
80104f61:	74 29                	je     80104f8c <memcmp+0x3c>
    if(*s1 != *s2)
80104f63:	0f b6 16             	movzbl (%esi),%edx
80104f66:	0f b6 0f             	movzbl (%edi),%ecx
80104f69:	38 d1                	cmp    %dl,%cl
80104f6b:	75 2b                	jne    80104f98 <memcmp+0x48>
80104f6d:	b8 01 00 00 00       	mov    $0x1,%eax
80104f72:	eb 14                	jmp    80104f88 <memcmp+0x38>
80104f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f78:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104f7c:	83 c0 01             	add    $0x1,%eax
80104f7f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104f84:	38 ca                	cmp    %cl,%dl
80104f86:	75 10                	jne    80104f98 <memcmp+0x48>
  while(n-- > 0){
80104f88:	39 d8                	cmp    %ebx,%eax
80104f8a:	75 ec                	jne    80104f78 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104f8c:	5b                   	pop    %ebx
  return 0;
80104f8d:	31 c0                	xor    %eax,%eax
}
80104f8f:	5e                   	pop    %esi
80104f90:	5f                   	pop    %edi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	90                   	nop
80104f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104f98:	0f b6 c2             	movzbl %dl,%eax
}
80104f9b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104f9c:	29 c8                	sub    %ecx,%eax
}
80104f9e:	5e                   	pop    %esi
80104f9f:	5f                   	pop    %edi
80104fa0:	5d                   	pop    %ebp
80104fa1:	c3                   	ret    
80104fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fb0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	53                   	push   %ebx
80104fb5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104fbb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fbe:	39 c3                	cmp    %eax,%ebx
80104fc0:	73 26                	jae    80104fe8 <memmove+0x38>
80104fc2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104fc5:	39 c8                	cmp    %ecx,%eax
80104fc7:	73 1f                	jae    80104fe8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104fc9:	85 f6                	test   %esi,%esi
80104fcb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104fce:	74 0f                	je     80104fdf <memmove+0x2f>
      *--d = *--s;
80104fd0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104fd4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104fd7:	83 ea 01             	sub    $0x1,%edx
80104fda:	83 fa ff             	cmp    $0xffffffff,%edx
80104fdd:	75 f1                	jne    80104fd0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104fdf:	5b                   	pop    %ebx
80104fe0:	5e                   	pop    %esi
80104fe1:	5d                   	pop    %ebp
80104fe2:	c3                   	ret    
80104fe3:	90                   	nop
80104fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104fe8:	31 d2                	xor    %edx,%edx
80104fea:	85 f6                	test   %esi,%esi
80104fec:	74 f1                	je     80104fdf <memmove+0x2f>
80104fee:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104ff0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ff4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ff7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104ffa:	39 d6                	cmp    %edx,%esi
80104ffc:	75 f2                	jne    80104ff0 <memmove+0x40>
}
80104ffe:	5b                   	pop    %ebx
80104fff:	5e                   	pop    %esi
80105000:	5d                   	pop    %ebp
80105001:	c3                   	ret    
80105002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105013:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105014:	eb 9a                	jmp    80104fb0 <memmove>
80105016:	8d 76 00             	lea    0x0(%esi),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	57                   	push   %edi
80105024:	56                   	push   %esi
80105025:	8b 7d 10             	mov    0x10(%ebp),%edi
80105028:	53                   	push   %ebx
80105029:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010502c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010502f:	85 ff                	test   %edi,%edi
80105031:	74 2f                	je     80105062 <strncmp+0x42>
80105033:	0f b6 01             	movzbl (%ecx),%eax
80105036:	0f b6 1e             	movzbl (%esi),%ebx
80105039:	84 c0                	test   %al,%al
8010503b:	74 37                	je     80105074 <strncmp+0x54>
8010503d:	38 c3                	cmp    %al,%bl
8010503f:	75 33                	jne    80105074 <strncmp+0x54>
80105041:	01 f7                	add    %esi,%edi
80105043:	eb 13                	jmp    80105058 <strncmp+0x38>
80105045:	8d 76 00             	lea    0x0(%esi),%esi
80105048:	0f b6 01             	movzbl (%ecx),%eax
8010504b:	84 c0                	test   %al,%al
8010504d:	74 21                	je     80105070 <strncmp+0x50>
8010504f:	0f b6 1a             	movzbl (%edx),%ebx
80105052:	89 d6                	mov    %edx,%esi
80105054:	38 d8                	cmp    %bl,%al
80105056:	75 1c                	jne    80105074 <strncmp+0x54>
    n--, p++, q++;
80105058:	8d 56 01             	lea    0x1(%esi),%edx
8010505b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010505e:	39 fa                	cmp    %edi,%edx
80105060:	75 e6                	jne    80105048 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105062:	5b                   	pop    %ebx
    return 0;
80105063:	31 c0                	xor    %eax,%eax
}
80105065:	5e                   	pop    %esi
80105066:	5f                   	pop    %edi
80105067:	5d                   	pop    %ebp
80105068:	c3                   	ret    
80105069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105070:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105074:	29 d8                	sub    %ebx,%eax
}
80105076:	5b                   	pop    %ebx
80105077:	5e                   	pop    %esi
80105078:	5f                   	pop    %edi
80105079:	5d                   	pop    %ebp
8010507a:	c3                   	ret    
8010507b:	90                   	nop
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105080 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
80105085:	8b 45 08             	mov    0x8(%ebp),%eax
80105088:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010508b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010508e:	89 c2                	mov    %eax,%edx
80105090:	eb 19                	jmp    801050ab <strncpy+0x2b>
80105092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105098:	83 c3 01             	add    $0x1,%ebx
8010509b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010509f:	83 c2 01             	add    $0x1,%edx
801050a2:	84 c9                	test   %cl,%cl
801050a4:	88 4a ff             	mov    %cl,-0x1(%edx)
801050a7:	74 09                	je     801050b2 <strncpy+0x32>
801050a9:	89 f1                	mov    %esi,%ecx
801050ab:	85 c9                	test   %ecx,%ecx
801050ad:	8d 71 ff             	lea    -0x1(%ecx),%esi
801050b0:	7f e6                	jg     80105098 <strncpy+0x18>
    ;
  while(n-- > 0)
801050b2:	31 c9                	xor    %ecx,%ecx
801050b4:	85 f6                	test   %esi,%esi
801050b6:	7e 17                	jle    801050cf <strncpy+0x4f>
801050b8:	90                   	nop
801050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801050c0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801050c4:	89 f3                	mov    %esi,%ebx
801050c6:	83 c1 01             	add    $0x1,%ecx
801050c9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801050cb:	85 db                	test   %ebx,%ebx
801050cd:	7f f1                	jg     801050c0 <strncpy+0x40>
  return os;
}
801050cf:	5b                   	pop    %ebx
801050d0:	5e                   	pop    %esi
801050d1:	5d                   	pop    %ebp
801050d2:	c3                   	ret    
801050d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
801050e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801050e8:	8b 45 08             	mov    0x8(%ebp),%eax
801050eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801050ee:	85 c9                	test   %ecx,%ecx
801050f0:	7e 26                	jle    80105118 <safestrcpy+0x38>
801050f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801050f6:	89 c1                	mov    %eax,%ecx
801050f8:	eb 17                	jmp    80105111 <safestrcpy+0x31>
801050fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105100:	83 c2 01             	add    $0x1,%edx
80105103:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105107:	83 c1 01             	add    $0x1,%ecx
8010510a:	84 db                	test   %bl,%bl
8010510c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010510f:	74 04                	je     80105115 <safestrcpy+0x35>
80105111:	39 f2                	cmp    %esi,%edx
80105113:	75 eb                	jne    80105100 <safestrcpy+0x20>
    ;
  *s = 0;
80105115:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105118:	5b                   	pop    %ebx
80105119:	5e                   	pop    %esi
8010511a:	5d                   	pop    %ebp
8010511b:	c3                   	ret    
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105120 <strlen>:

int
strlen(const char *s)
{
80105120:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105121:	31 c0                	xor    %eax,%eax
{
80105123:	89 e5                	mov    %esp,%ebp
80105125:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105128:	80 3a 00             	cmpb   $0x0,(%edx)
8010512b:	74 0c                	je     80105139 <strlen+0x19>
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
80105130:	83 c0 01             	add    $0x1,%eax
80105133:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105137:	75 f7                	jne    80105130 <strlen+0x10>
    ;
  return n;
}
80105139:	5d                   	pop    %ebp
8010513a:	c3                   	ret    

8010513b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010513b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010513f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105143:	55                   	push   %ebp
  pushl %ebx
80105144:	53                   	push   %ebx
  pushl %esi
80105145:	56                   	push   %esi
  pushl %edi
80105146:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105147:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105149:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010514b:	5f                   	pop    %edi
  popl %esi
8010514c:	5e                   	pop    %esi
  popl %ebx
8010514d:	5b                   	pop    %ebx
  popl %ebp
8010514e:	5d                   	pop    %ebp
  ret
8010514f:	c3                   	ret    

80105150 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105150:	55                   	push   %ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105151:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
{
80105158:	89 e5                	mov    %esp,%ebp
8010515a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010515d:	8b 12                	mov    (%edx),%edx
8010515f:	39 c2                	cmp    %eax,%edx
80105161:	76 15                	jbe    80105178 <fetchint+0x28>
80105163:	8d 48 04             	lea    0x4(%eax),%ecx
80105166:	39 ca                	cmp    %ecx,%edx
80105168:	72 0e                	jb     80105178 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010516a:	8b 10                	mov    (%eax),%edx
8010516c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010516f:	89 10                	mov    %edx,(%eax)
  return 0;
80105171:	31 c0                	xor    %eax,%eax
}
80105173:	5d                   	pop    %ebp
80105174:	c3                   	ret    
80105175:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010517d:	5d                   	pop    %ebp
8010517e:	c3                   	ret    
8010517f:	90                   	nop

80105180 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105180:	55                   	push   %ebp
  char *s, *ep;

  if(addr >= proc->sz)
80105181:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
{
80105187:	89 e5                	mov    %esp,%ebp
80105189:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz)
8010518c:	39 08                	cmp    %ecx,(%eax)
8010518e:	76 2c                	jbe    801051bc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105190:	8b 55 0c             	mov    0xc(%ebp),%edx
80105193:	89 c8                	mov    %ecx,%eax
80105195:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80105197:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010519e:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801051a0:	39 d1                	cmp    %edx,%ecx
801051a2:	73 18                	jae    801051bc <fetchstr+0x3c>
    if(*s == 0)
801051a4:	80 39 00             	cmpb   $0x0,(%ecx)
801051a7:	75 0c                	jne    801051b5 <fetchstr+0x35>
801051a9:	eb 25                	jmp    801051d0 <fetchstr+0x50>
801051ab:	90                   	nop
801051ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051b0:	80 38 00             	cmpb   $0x0,(%eax)
801051b3:	74 13                	je     801051c8 <fetchstr+0x48>
  for(s = *pp; s < ep; s++)
801051b5:	83 c0 01             	add    $0x1,%eax
801051b8:	39 c2                	cmp    %eax,%edx
801051ba:	77 f4                	ja     801051b0 <fetchstr+0x30>
    return -1;
801051bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  return -1;
}
801051c1:	5d                   	pop    %ebp
801051c2:	c3                   	ret    
801051c3:	90                   	nop
801051c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051c8:	29 c8                	sub    %ecx,%eax
801051ca:	5d                   	pop    %ebp
801051cb:	c3                   	ret    
801051cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
801051d0:	31 c0                	xor    %eax,%eax
}
801051d2:	5d                   	pop    %ebp
801051d3:	c3                   	ret    
801051d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801051e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801051e0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
{
801051e7:	55                   	push   %ebp
801051e8:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801051ea:	8b 42 18             	mov    0x18(%edx),%eax
801051ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
801051f0:	8b 12                	mov    (%edx),%edx
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801051f2:	8b 40 44             	mov    0x44(%eax),%eax
801051f5:	8d 04 88             	lea    (%eax,%ecx,4),%eax
801051f8:	8d 48 04             	lea    0x4(%eax),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
801051fb:	39 d1                	cmp    %edx,%ecx
801051fd:	73 19                	jae    80105218 <argint+0x38>
801051ff:	8d 48 08             	lea    0x8(%eax),%ecx
80105202:	39 ca                	cmp    %ecx,%edx
80105204:	72 12                	jb     80105218 <argint+0x38>
  *ip = *(int*)(addr);
80105206:	8b 50 04             	mov    0x4(%eax),%edx
80105209:	8b 45 0c             	mov    0xc(%ebp),%eax
8010520c:	89 10                	mov    %edx,(%eax)
  return 0;
8010520e:	31 c0                	xor    %eax,%eax
}
80105210:	5d                   	pop    %ebp
80105211:	c3                   	ret    
80105212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010521d:	5d                   	pop    %ebp
8010521e:	c3                   	ret    
8010521f:	90                   	nop

80105220 <argptr>:
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105220:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105226:	55                   	push   %ebp
80105227:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105229:	8b 50 18             	mov    0x18(%eax),%edx
8010522c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
8010522f:	8b 00                	mov    (%eax),%eax
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105231:	8b 52 44             	mov    0x44(%edx),%edx
80105234:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80105237:	8d 4a 04             	lea    0x4(%edx),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
8010523a:	39 c1                	cmp    %eax,%ecx
8010523c:	73 22                	jae    80105260 <argptr+0x40>
8010523e:	8d 4a 08             	lea    0x8(%edx),%ecx
80105241:	39 c8                	cmp    %ecx,%eax
80105243:	72 1b                	jb     80105260 <argptr+0x40>
  *ip = *(int*)(addr);
80105245:	8b 52 04             	mov    0x4(%edx),%edx
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105248:	39 c2                	cmp    %eax,%edx
8010524a:	73 14                	jae    80105260 <argptr+0x40>
8010524c:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010524f:	01 d1                	add    %edx,%ecx
80105251:	39 c1                	cmp    %eax,%ecx
80105253:	77 0b                	ja     80105260 <argptr+0x40>
    return -1;
  *pp = (char*)i;
80105255:	8b 45 0c             	mov    0xc(%ebp),%eax
80105258:	89 10                	mov    %edx,(%eax)
  return 0;
8010525a:	31 c0                	xor    %eax,%eax
}
8010525c:	5d                   	pop    %ebp
8010525d:	c3                   	ret    
8010525e:	66 90                	xchg   %ax,%ax
    return -1;
80105260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105265:	5d                   	pop    %ebp
80105266:	c3                   	ret    
80105267:	89 f6                	mov    %esi,%esi
80105269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105270 <argstr>:
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105270:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105276:	55                   	push   %ebp
80105277:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105279:	8b 50 18             	mov    0x18(%eax),%edx
8010527c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
8010527f:	8b 00                	mov    (%eax),%eax
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105281:	8b 52 44             	mov    0x44(%edx),%edx
80105284:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80105287:	8d 4a 04             	lea    0x4(%edx),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
8010528a:	39 c1                	cmp    %eax,%ecx
8010528c:	73 3e                	jae    801052cc <argstr+0x5c>
8010528e:	8d 4a 08             	lea    0x8(%edx),%ecx
80105291:	39 c8                	cmp    %ecx,%eax
80105293:	72 37                	jb     801052cc <argstr+0x5c>
  *ip = *(int*)(addr);
80105295:	8b 4a 04             	mov    0x4(%edx),%ecx
  if(addr >= proc->sz)
80105298:	39 c1                	cmp    %eax,%ecx
8010529a:	73 30                	jae    801052cc <argstr+0x5c>
  *pp = (char*)addr;
8010529c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010529f:	89 c8                	mov    %ecx,%eax
801052a1:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801052a3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052aa:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801052ac:	39 d1                	cmp    %edx,%ecx
801052ae:	73 1c                	jae    801052cc <argstr+0x5c>
    if(*s == 0)
801052b0:	80 39 00             	cmpb   $0x0,(%ecx)
801052b3:	75 10                	jne    801052c5 <argstr+0x55>
801052b5:	eb 29                	jmp    801052e0 <argstr+0x70>
801052b7:	89 f6                	mov    %esi,%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801052c0:	80 38 00             	cmpb   $0x0,(%eax)
801052c3:	74 13                	je     801052d8 <argstr+0x68>
  for(s = *pp; s < ep; s++)
801052c5:	83 c0 01             	add    $0x1,%eax
801052c8:	39 c2                	cmp    %eax,%edx
801052ca:	77 f4                	ja     801052c0 <argstr+0x50>
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801052cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801052d1:	5d                   	pop    %ebp
801052d2:	c3                   	ret    
801052d3:	90                   	nop
801052d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052d8:	29 c8                	sub    %ecx,%eax
801052da:	5d                   	pop    %ebp
801052db:	c3                   	ret    
801052dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
801052e0:	31 c0                	xor    %eax,%eax
}
801052e2:	5d                   	pop    %ebp
801052e3:	c3                   	ret    
801052e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801052f0 <syscall>:
[SYS_open_fifo] sys_open_fifo,
};

void
syscall(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	83 ec 08             	sub    $0x8,%esp
  int num;

  num = proc->tf->eax;
801052f6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052fd:	8b 42 18             	mov    0x18(%edx),%eax
80105300:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105303:	8d 48 ff             	lea    -0x1(%eax),%ecx
80105306:	83 f9 21             	cmp    $0x21,%ecx
80105309:	77 25                	ja     80105330 <syscall+0x40>
8010530b:	8b 0c 85 40 8b 10 80 	mov    -0x7fef74c0(,%eax,4),%ecx
80105312:	85 c9                	test   %ecx,%ecx
80105314:	74 1a                	je     80105330 <syscall+0x40>
    proc->tf->eax = syscalls[num]();
80105316:	ff d1                	call   *%ecx
80105318:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010531f:	8b 52 18             	mov    0x18(%edx),%edx
80105322:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("%d %s: unknown sys call %d\n",
80105330:	50                   	push   %eax
            proc->pid, proc->name, num);
80105331:	8d 42 6c             	lea    0x6c(%edx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105334:	50                   	push   %eax
80105335:	ff 72 10             	pushl  0x10(%edx)
80105338:	68 24 8b 10 80       	push   $0x80108b24
8010533d:	e8 0e b4 ff ff       	call   80100750 <cprintf>
    proc->tf->eax = -1;
80105342:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105348:	83 c4 10             	add    $0x10,%esp
8010534b:	8b 40 18             	mov    0x18(%eax),%eax
8010534e:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105355:	c9                   	leave  
80105356:	c3                   	ret    
80105357:	66 90                	xchg   %ax,%ax
80105359:	66 90                	xchg   %ax,%ax
8010535b:	66 90                	xchg   %ax,%ax
8010535d:	66 90                	xchg   %ax,%ax
8010535f:	90                   	nop

80105360 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
80105365:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105366:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105369:	83 ec 44             	sub    $0x44,%esp
8010536c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010536f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105372:	56                   	push   %esi
80105373:	50                   	push   %eax
{
80105374:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105377:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010537a:	e8 f1 cc ff ff       	call   80102070 <nameiparent>
8010537f:	83 c4 10             	add    $0x10,%esp
80105382:	85 c0                	test   %eax,%eax
80105384:	0f 84 46 01 00 00    	je     801054d0 <create+0x170>
    return 0;
  ilock(dp);
8010538a:	83 ec 0c             	sub    $0xc,%esp
8010538d:	89 c3                	mov    %eax,%ebx
8010538f:	50                   	push   %eax
80105390:	e8 1b c4 ff ff       	call   801017b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105395:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105398:	83 c4 0c             	add    $0xc,%esp
8010539b:	50                   	push   %eax
8010539c:	56                   	push   %esi
8010539d:	53                   	push   %ebx
8010539e:	e8 7d c9 ff ff       	call   80101d20 <dirlookup>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	89 c7                	mov    %eax,%edi
801053aa:	74 34                	je     801053e0 <create+0x80>
    iunlockput(dp);
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	53                   	push   %ebx
801053b0:	e8 cb c6 ff ff       	call   80101a80 <iunlockput>
    ilock(ip);
801053b5:	89 3c 24             	mov    %edi,(%esp)
801053b8:	e8 f3 c3 ff ff       	call   801017b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801053bd:	83 c4 10             	add    $0x10,%esp
801053c0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801053c5:	0f 85 95 00 00 00    	jne    80105460 <create+0x100>
801053cb:	80 7f 10 02          	cmpb   $0x2,0x10(%edi)
801053cf:	0f 85 8b 00 00 00    	jne    80105460 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801053d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d8:	89 f8                	mov    %edi,%eax
801053da:	5b                   	pop    %ebx
801053db:	5e                   	pop    %esi
801053dc:	5f                   	pop    %edi
801053dd:	5d                   	pop    %ebp
801053de:	c3                   	ret    
801053df:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801053e0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801053e4:	83 ec 08             	sub    $0x8,%esp
801053e7:	50                   	push   %eax
801053e8:	ff 33                	pushl  (%ebx)
801053ea:	e8 41 c2 ff ff       	call   80101630 <ialloc>
801053ef:	83 c4 10             	add    $0x10,%esp
801053f2:	85 c0                	test   %eax,%eax
801053f4:	89 c7                	mov    %eax,%edi
801053f6:	0f 84 e8 00 00 00    	je     801054e4 <create+0x184>
  ilock(ip);
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	50                   	push   %eax
80105400:	e8 ab c3 ff ff       	call   801017b0 <ilock>
  ip->major = major;
80105405:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105409:	66 89 47 12          	mov    %ax,0x12(%edi)
  ip->minor = minor;
8010540d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105411:	66 89 47 14          	mov    %ax,0x14(%edi)
  ip->nlink = 1;
80105415:	b8 01 00 00 00       	mov    $0x1,%eax
8010541a:	66 89 47 16          	mov    %ax,0x16(%edi)
  iupdate(ip);
8010541e:	89 3c 24             	mov    %edi,(%esp)
80105421:	e8 ca c2 ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105426:	83 c4 10             	add    $0x10,%esp
80105429:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010542e:	74 50                	je     80105480 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105430:	83 ec 04             	sub    $0x4,%esp
80105433:	ff 77 04             	pushl  0x4(%edi)
80105436:	56                   	push   %esi
80105437:	53                   	push   %ebx
80105438:	e8 53 cb ff ff       	call   80101f90 <dirlink>
8010543d:	83 c4 10             	add    $0x10,%esp
80105440:	85 c0                	test   %eax,%eax
80105442:	0f 88 8f 00 00 00    	js     801054d7 <create+0x177>
  iunlockput(dp);
80105448:	83 ec 0c             	sub    $0xc,%esp
8010544b:	53                   	push   %ebx
8010544c:	e8 2f c6 ff ff       	call   80101a80 <iunlockput>
  return ip;
80105451:	83 c4 10             	add    $0x10,%esp
}
80105454:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105457:	89 f8                	mov    %edi,%eax
80105459:	5b                   	pop    %ebx
8010545a:	5e                   	pop    %esi
8010545b:	5f                   	pop    %edi
8010545c:	5d                   	pop    %ebp
8010545d:	c3                   	ret    
8010545e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	57                   	push   %edi
    return 0;
80105464:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105466:	e8 15 c6 ff ff       	call   80101a80 <iunlockput>
    return 0;
8010546b:	83 c4 10             	add    $0x10,%esp
}
8010546e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105471:	89 f8                	mov    %edi,%eax
80105473:	5b                   	pop    %ebx
80105474:	5e                   	pop    %esi
80105475:	5f                   	pop    %edi
80105476:	5d                   	pop    %ebp
80105477:	c3                   	ret    
80105478:	90                   	nop
80105479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105480:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
    iupdate(dp);
80105485:	83 ec 0c             	sub    $0xc,%esp
80105488:	53                   	push   %ebx
80105489:	e8 62 c2 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010548e:	83 c4 0c             	add    $0xc,%esp
80105491:	ff 77 04             	pushl  0x4(%edi)
80105494:	68 e8 8b 10 80       	push   $0x80108be8
80105499:	57                   	push   %edi
8010549a:	e8 f1 ca ff ff       	call   80101f90 <dirlink>
8010549f:	83 c4 10             	add    $0x10,%esp
801054a2:	85 c0                	test   %eax,%eax
801054a4:	78 1c                	js     801054c2 <create+0x162>
801054a6:	83 ec 04             	sub    $0x4,%esp
801054a9:	ff 73 04             	pushl  0x4(%ebx)
801054ac:	68 e7 8b 10 80       	push   $0x80108be7
801054b1:	57                   	push   %edi
801054b2:	e8 d9 ca ff ff       	call   80101f90 <dirlink>
801054b7:	83 c4 10             	add    $0x10,%esp
801054ba:	85 c0                	test   %eax,%eax
801054bc:	0f 89 6e ff ff ff    	jns    80105430 <create+0xd0>
      panic("create dots");
801054c2:	83 ec 0c             	sub    $0xc,%esp
801054c5:	68 db 8b 10 80       	push   $0x80108bdb
801054ca:	e8 b1 af ff ff       	call   80100480 <panic>
801054cf:	90                   	nop
    return 0;
801054d0:	31 ff                	xor    %edi,%edi
801054d2:	e9 fe fe ff ff       	jmp    801053d5 <create+0x75>
    panic("create: dirlink");
801054d7:	83 ec 0c             	sub    $0xc,%esp
801054da:	68 ea 8b 10 80       	push   $0x80108bea
801054df:	e8 9c af ff ff       	call   80100480 <panic>
    panic("create: ialloc");
801054e4:	83 ec 0c             	sub    $0xc,%esp
801054e7:	68 cc 8b 10 80       	push   $0x80108bcc
801054ec:	e8 8f af ff ff       	call   80100480 <panic>
801054f1:	eb 0d                	jmp    80105500 <argfd.constprop.0>
801054f3:	90                   	nop
801054f4:	90                   	nop
801054f5:	90                   	nop
801054f6:	90                   	nop
801054f7:	90                   	nop
801054f8:	90                   	nop
801054f9:	90                   	nop
801054fa:	90                   	nop
801054fb:	90                   	nop
801054fc:	90                   	nop
801054fd:	90                   	nop
801054fe:	90                   	nop
801054ff:	90                   	nop

80105500 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	56                   	push   %esi
80105504:	53                   	push   %ebx
80105505:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105507:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010550a:	89 d6                	mov    %edx,%esi
8010550c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010550f:	50                   	push   %eax
80105510:	6a 00                	push   $0x0
80105512:	e8 c9 fc ff ff       	call   801051e0 <argint>
80105517:	83 c4 10             	add    $0x10,%esp
8010551a:	85 c0                	test   %eax,%eax
8010551c:	78 32                	js     80105550 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010551e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105521:	83 f8 0f             	cmp    $0xf,%eax
80105524:	77 2a                	ja     80105550 <argfd.constprop.0+0x50>
80105526:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010552d:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
80105531:	85 c9                	test   %ecx,%ecx
80105533:	74 1b                	je     80105550 <argfd.constprop.0+0x50>
  if(pfd)
80105535:	85 db                	test   %ebx,%ebx
80105537:	74 02                	je     8010553b <argfd.constprop.0+0x3b>
    *pfd = fd;
80105539:	89 03                	mov    %eax,(%ebx)
    *pf = f;
8010553b:	89 0e                	mov    %ecx,(%esi)
  return 0;
8010553d:	31 c0                	xor    %eax,%eax
}
8010553f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105542:	5b                   	pop    %ebx
80105543:	5e                   	pop    %esi
80105544:	5d                   	pop    %ebp
80105545:	c3                   	ret    
80105546:	8d 76 00             	lea    0x0(%esi),%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105555:	eb e8                	jmp    8010553f <argfd.constprop.0+0x3f>
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105560 <sys_chmod>:
int sys_chmod(void){
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	53                   	push   %ebx
  if(argstr(0,&pathname)<0||argint(1,&mode)<0)
80105564:	8d 45 f0             	lea    -0x10(%ebp),%eax
int sys_chmod(void){
80105567:	83 ec 1c             	sub    $0x1c,%esp
  if(argstr(0,&pathname)<0||argint(1,&mode)<0)
8010556a:	50                   	push   %eax
8010556b:	6a 00                	push   $0x0
8010556d:	e8 fe fc ff ff       	call   80105270 <argstr>
80105572:	83 c4 10             	add    $0x10,%esp
80105575:	85 c0                	test   %eax,%eax
80105577:	78 67                	js     801055e0 <sys_chmod+0x80>
80105579:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010557c:	83 ec 08             	sub    $0x8,%esp
8010557f:	50                   	push   %eax
80105580:	6a 01                	push   $0x1
80105582:	e8 59 fc ff ff       	call   801051e0 <argint>
80105587:	83 c4 10             	add    $0x10,%esp
8010558a:	85 c0                	test   %eax,%eax
8010558c:	78 52                	js     801055e0 <sys_chmod+0x80>
  begin_op();//启动文件系统调用
8010558e:	e8 0d da ff ff       	call   80102fa0 <begin_op>
  if((ip=namei(pathname))==0){//如果路径名不对
80105593:	83 ec 0c             	sub    $0xc,%esp
80105596:	ff 75 f0             	pushl  -0x10(%ebp)
80105599:	e8 b2 ca ff ff       	call   80102050 <namei>
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	85 c0                	test   %eax,%eax
801055a3:	89 c3                	mov    %eax,%ebx
801055a5:	74 2e                	je     801055d5 <sys_chmod+0x75>
  ilock(ip);//加锁
801055a7:	83 ec 0c             	sub    $0xc,%esp
801055aa:	50                   	push   %eax
801055ab:	e8 00 c2 ff ff       	call   801017b0 <ilock>
  ip->mode=(char)mode;//更改权限
801055b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055b3:	88 43 11             	mov    %al,0x11(%ebx)
  iupdate(ip);//更新权限
801055b6:	89 1c 24             	mov    %ebx,(%esp)
801055b9:	e8 32 c1 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);//解锁
801055be:	89 1c 24             	mov    %ebx,(%esp)
801055c1:	e8 fa c2 ff ff       	call   801018c0 <iunlock>
  end_op();//结束系统调用
801055c6:	e8 45 da ff ff       	call   80103010 <end_op>
  return 0;
801055cb:	83 c4 10             	add    $0x10,%esp
801055ce:	31 c0                	xor    %eax,%eax
}
801055d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055d3:	c9                   	leave  
801055d4:	c3                   	ret    
    end_op();//结束调用
801055d5:	e8 36 da ff ff       	call   80103010 <end_op>
801055da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801055e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e5:	eb e9                	jmp    801055d0 <sys_chmod+0x70>
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <sys_dup>:
{
801055f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801055f1:	31 c0                	xor    %eax,%eax
{
801055f3:	89 e5                	mov    %esp,%ebp
801055f5:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801055f6:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801055f9:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
801055fc:	e8 ff fe ff ff       	call   80105500 <argfd.constprop.0>
80105601:	85 c0                	test   %eax,%eax
80105603:	78 3b                	js     80105640 <sys_dup+0x50>
  if((fd=fdalloc(f)) < 0)
80105605:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if(proc->ofile[fd] == 0){
80105608:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(fd = 0; fd < NOFILE; fd++){
8010560e:	31 db                	xor    %ebx,%ebx
80105610:	eb 0e                	jmp    80105620 <sys_dup+0x30>
80105612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105618:	83 c3 01             	add    $0x1,%ebx
8010561b:	83 fb 10             	cmp    $0x10,%ebx
8010561e:	74 20                	je     80105640 <sys_dup+0x50>
    if(proc->ofile[fd] == 0){
80105620:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80105624:	85 c9                	test   %ecx,%ecx
80105626:	75 f0                	jne    80105618 <sys_dup+0x28>
  filedup(f);
80105628:	83 ec 0c             	sub    $0xc,%esp
      proc->ofile[fd] = f;
8010562b:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)
  filedup(f);
8010562f:	52                   	push   %edx
80105630:	e8 9b b8 ff ff       	call   80100ed0 <filedup>
}
80105635:	89 d8                	mov    %ebx,%eax
  return fd;
80105637:	83 c4 10             	add    $0x10,%esp
}
8010563a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010563d:	c9                   	leave  
8010563e:	c3                   	ret    
8010563f:	90                   	nop
    return -1;
80105640:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105645:	89 d8                	mov    %ebx,%eax
80105647:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010564a:	c9                   	leave  
8010564b:	c3                   	ret    
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105650 <sys_read>:
{
80105650:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105651:	31 c0                	xor    %eax,%eax
{
80105653:	89 e5                	mov    %esp,%ebp
80105655:	57                   	push   %edi
80105656:	56                   	push   %esi
80105657:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105658:	8d 55 d8             	lea    -0x28(%ebp),%edx
{
8010565b:	83 ec 1c             	sub    $0x1c,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010565e:	e8 9d fe ff ff       	call   80105500 <argfd.constprop.0>
80105663:	85 c0                	test   %eax,%eax
80105665:	0f 88 e5 00 00 00    	js     80105750 <sys_read+0x100>
8010566b:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010566e:	83 ec 08             	sub    $0x8,%esp
80105671:	50                   	push   %eax
80105672:	6a 02                	push   $0x2
80105674:	e8 67 fb ff ff       	call   801051e0 <argint>
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	85 c0                	test   %eax,%eax
8010567e:	0f 88 cc 00 00 00    	js     80105750 <sys_read+0x100>
80105684:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105687:	83 ec 04             	sub    $0x4,%esp
8010568a:	ff 75 dc             	pushl  -0x24(%ebp)
8010568d:	50                   	push   %eax
8010568e:	6a 01                	push   $0x1
80105690:	e8 8b fb ff ff       	call   80105220 <argptr>
80105695:	83 c4 10             	add    $0x10,%esp
80105698:	85 c0                	test   %eax,%eax
8010569a:	0f 88 b0 00 00 00    	js     80105750 <sys_read+0x100>
  if(f->ip->mode!=111)  
801056a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801056a3:	8b 50 10             	mov    0x10(%eax),%edx
801056a6:	80 7a 11 6f          	cmpb   $0x6f,0x11(%edx)
801056aa:	74 24                	je     801056d0 <sys_read+0x80>
    return fileread(f, p, n);
801056ac:	83 ec 04             	sub    $0x4,%esp
801056af:	ff 75 dc             	pushl  -0x24(%ebp)
801056b2:	ff 75 e0             	pushl  -0x20(%ebp)
801056b5:	50                   	push   %eax
801056b6:	e8 85 b9 ff ff       	call   80101040 <fileread>
801056bb:	83 c4 10             	add    $0x10,%esp
}
801056be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056c1:	5b                   	pop    %ebx
801056c2:	5e                   	pop    %esi
801056c3:	5f                   	pop    %edi
801056c4:	5d                   	pop    %ebp
801056c5:	c3                   	ret    
801056c6:	8d 76 00             	lea    0x0(%esi),%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  fileread(f,&s[0],4);
801056d0:	8d 55 e4             	lea    -0x1c(%ebp),%edx
801056d3:	83 ec 04             	sub    $0x4,%esp
801056d6:	6a 04                	push   $0x4
801056d8:	52                   	push   %edx
801056d9:	50                   	push   %eax
801056da:	e8 61 b9 ff ff       	call   80101040 <fileread>
  pa+=(s[0]<<24)&0xFF000000;
801056df:	0f be 55 e4          	movsbl -0x1c(%ebp),%edx
  pa+=(s[3]<<0)&0x000000FF;
801056e3:	0f be 7d e7          	movsbl -0x19(%ebp),%edi
  cprintf("[fifo read] %p %p %p %p,fifo pa: %p\n",s[0],s[1],s[2],s[3],a);
801056e7:	83 c4 08             	add    $0x8,%esp
  pa+=(s[1]<<16)&0x00FF0000;
801056ea:	0f be 4d e5          	movsbl -0x1b(%ebp),%ecx
  pa+=(s[2]<<8)&0x0000FF00;
801056ee:	0f be 75 e6          	movsbl -0x1a(%ebp),%esi
  pa+=(s[0]<<24)&0xFF000000;
801056f2:	89 d3                	mov    %edx,%ebx
  pa+=(s[3]<<0)&0x000000FF;
801056f4:	89 f8                	mov    %edi,%eax
  pa+=(s[0]<<24)&0xFF000000;
801056f6:	c1 e3 18             	shl    $0x18,%ebx
  pa+=(s[3]<<0)&0x000000FF;
801056f9:	0f b6 c0             	movzbl %al,%eax
801056fc:	01 d8                	add    %ebx,%eax
  pa+=(s[1]<<16)&0x00FF0000;
801056fe:	89 cb                	mov    %ecx,%ebx
80105700:	c1 e3 10             	shl    $0x10,%ebx
80105703:	81 e3 00 00 ff 00    	and    $0xff0000,%ebx
  pa+=(s[3]<<0)&0x000000FF;
80105709:	01 c3                	add    %eax,%ebx
  pa+=(s[2]<<8)&0x0000FF00;
8010570b:	89 f0                	mov    %esi,%eax
8010570d:	c1 e0 08             	shl    $0x8,%eax
80105710:	0f b7 c0             	movzwl %ax,%eax
  pa+=(s[3]<<0)&0x000000FF;
80105713:	01 c3                	add    %eax,%ebx
  cprintf("[fifo read] %p %p %p %p,fifo pa: %p\n",s[0],s[1],s[2],s[3],a);
80105715:	53                   	push   %ebx
80105716:	57                   	push   %edi
80105717:	56                   	push   %esi
80105718:	51                   	push   %ecx
80105719:	52                   	push   %edx
8010571a:	68 44 8c 10 80       	push   $0x80108c44
8010571f:	e8 2c b0 ff ff       	call   80100750 <cprintf>
  for(int i=0;i<n;i++)
80105724:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105727:	83 c4 20             	add    $0x20,%esp
8010572a:	31 c0                	xor    %eax,%eax
8010572c:	85 d2                	test   %edx,%edx
8010572e:	7e 12                	jle    80105742 <sys_read+0xf2>
    p[i]=a[i];
80105730:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
80105734:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105737:	88 0c 02             	mov    %cl,(%edx,%eax,1)
  for(int i=0;i<n;i++)
8010573a:	83 c0 01             	add    $0x1,%eax
8010573d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
80105740:	7f ee                	jg     80105730 <sys_read+0xe0>
}
80105742:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80105745:	31 c0                	xor    %eax,%eax
}
80105747:	5b                   	pop    %ebx
80105748:	5e                   	pop    %esi
80105749:	5f                   	pop    %edi
8010574a:	5d                   	pop    %ebp
8010574b:	c3                   	ret    
8010574c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105755:	e9 64 ff ff ff       	jmp    801056be <sys_read+0x6e>
8010575a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105760 <sys_write>:
{
80105760:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105761:	31 c0                	xor    %eax,%eax
{
80105763:	89 e5                	mov    %esp,%ebp
80105765:	57                   	push   %edi
80105766:	56                   	push   %esi
80105767:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105768:	8d 55 d8             	lea    -0x28(%ebp),%edx
{
8010576b:	83 ec 1c             	sub    $0x1c,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010576e:	e8 8d fd ff ff       	call   80105500 <argfd.constprop.0>
80105773:	85 c0                	test   %eax,%eax
80105775:	0f 88 e5 00 00 00    	js     80105860 <sys_write+0x100>
8010577b:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010577e:	83 ec 08             	sub    $0x8,%esp
80105781:	50                   	push   %eax
80105782:	6a 02                	push   $0x2
80105784:	e8 57 fa ff ff       	call   801051e0 <argint>
80105789:	83 c4 10             	add    $0x10,%esp
8010578c:	85 c0                	test   %eax,%eax
8010578e:	0f 88 cc 00 00 00    	js     80105860 <sys_write+0x100>
80105794:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105797:	83 ec 04             	sub    $0x4,%esp
8010579a:	ff 75 dc             	pushl  -0x24(%ebp)
8010579d:	50                   	push   %eax
8010579e:	6a 01                	push   $0x1
801057a0:	e8 7b fa ff ff       	call   80105220 <argptr>
801057a5:	83 c4 10             	add    $0x10,%esp
801057a8:	85 c0                	test   %eax,%eax
801057aa:	0f 88 b0 00 00 00    	js     80105860 <sys_write+0x100>
  if(f->ip->mode!=111)  
801057b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801057b3:	8b 50 10             	mov    0x10(%eax),%edx
801057b6:	80 7a 11 6f          	cmpb   $0x6f,0x11(%edx)
801057ba:	74 24                	je     801057e0 <sys_write+0x80>
    return filewrite(f, p, n);
801057bc:	83 ec 04             	sub    $0x4,%esp
801057bf:	ff 75 dc             	pushl  -0x24(%ebp)
801057c2:	ff 75 e0             	pushl  -0x20(%ebp)
801057c5:	50                   	push   %eax
801057c6:	e8 55 b9 ff ff       	call   80101120 <filewrite>
801057cb:	83 c4 10             	add    $0x10,%esp
}
801057ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d1:	5b                   	pop    %ebx
801057d2:	5e                   	pop    %esi
801057d3:	5f                   	pop    %edi
801057d4:	5d                   	pop    %ebp
801057d5:	c3                   	ret    
801057d6:	8d 76 00             	lea    0x0(%esi),%esi
801057d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  fileread(f,&s[0],4);
801057e0:	8d 55 e4             	lea    -0x1c(%ebp),%edx
801057e3:	83 ec 04             	sub    $0x4,%esp
801057e6:	6a 04                	push   $0x4
801057e8:	52                   	push   %edx
801057e9:	50                   	push   %eax
801057ea:	e8 51 b8 ff ff       	call   80101040 <fileread>
  pa+=(s[0]<<24)&0xFF000000;
801057ef:	0f be 55 e4          	movsbl -0x1c(%ebp),%edx
  pa+=(s[3]<<0)&0x000000FF;
801057f3:	0f be 7d e7          	movsbl -0x19(%ebp),%edi
  cprintf("[fifo read] %p %p %p %p,fifo pa: %p\n",s[0],s[1],s[2],s[3],a);
801057f7:	83 c4 08             	add    $0x8,%esp
  pa+=(s[1]<<16)&0x00FF0000;
801057fa:	0f be 4d e5          	movsbl -0x1b(%ebp),%ecx
  pa+=(s[2]<<8)&0x0000FF00;
801057fe:	0f be 75 e6          	movsbl -0x1a(%ebp),%esi
  pa+=(s[0]<<24)&0xFF000000;
80105802:	89 d3                	mov    %edx,%ebx
  pa+=(s[3]<<0)&0x000000FF;
80105804:	89 f8                	mov    %edi,%eax
  pa+=(s[0]<<24)&0xFF000000;
80105806:	c1 e3 18             	shl    $0x18,%ebx
  pa+=(s[3]<<0)&0x000000FF;
80105809:	0f b6 c0             	movzbl %al,%eax
8010580c:	01 d8                	add    %ebx,%eax
  pa+=(s[1]<<16)&0x00FF0000;
8010580e:	89 cb                	mov    %ecx,%ebx
80105810:	c1 e3 10             	shl    $0x10,%ebx
80105813:	81 e3 00 00 ff 00    	and    $0xff0000,%ebx
  pa+=(s[3]<<0)&0x000000FF;
80105819:	01 c3                	add    %eax,%ebx
  pa+=(s[2]<<8)&0x0000FF00;
8010581b:	89 f0                	mov    %esi,%eax
8010581d:	c1 e0 08             	shl    $0x8,%eax
80105820:	0f b7 c0             	movzwl %ax,%eax
  pa+=(s[3]<<0)&0x000000FF;
80105823:	01 c3                	add    %eax,%ebx
  cprintf("[fifo read] %p %p %p %p,fifo pa: %p\n",s[0],s[1],s[2],s[3],a);
80105825:	53                   	push   %ebx
80105826:	57                   	push   %edi
80105827:	56                   	push   %esi
80105828:	51                   	push   %ecx
80105829:	52                   	push   %edx
8010582a:	68 44 8c 10 80       	push   $0x80108c44
8010582f:	e8 1c af ff ff       	call   80100750 <cprintf>
  for(int i=0;i<n;i++)
80105834:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105837:	83 c4 20             	add    $0x20,%esp
8010583a:	31 c0                	xor    %eax,%eax
8010583c:	85 d2                	test   %edx,%edx
8010583e:	7e 13                	jle    80105853 <sys_write+0xf3>
    a[i]=p[i];
80105840:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105843:	0f b6 14 02          	movzbl (%edx,%eax,1),%edx
  for(int i=0;i<n;i++)
80105847:	83 c0 01             	add    $0x1,%eax
    a[i]=p[i];
8010584a:	88 54 18 ff          	mov    %dl,-0x1(%eax,%ebx,1)
  for(int i=0;i<n;i++)
8010584e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
80105851:	7f ed                	jg     80105840 <sys_write+0xe0>
}
80105853:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80105856:	31 c0                	xor    %eax,%eax
}
80105858:	5b                   	pop    %ebx
80105859:	5e                   	pop    %esi
8010585a:	5f                   	pop    %edi
8010585b:	5d                   	pop    %ebp
8010585c:	c3                   	ret    
8010585d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105865:	e9 64 ff ff ff       	jmp    801057ce <sys_write+0x6e>
8010586a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105870 <sys_close>:
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105876:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105879:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010587c:	e8 7f fc ff ff       	call   80105500 <argfd.constprop.0>
80105881:	85 c0                	test   %eax,%eax
80105883:	78 2b                	js     801058b0 <sys_close+0x40>
  proc->ofile[fd] = 0;
80105885:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010588b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010588e:	83 ec 0c             	sub    $0xc,%esp
  proc->ofile[fd] = 0;
80105891:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105898:	00 
  fileclose(f);
80105899:	ff 75 f4             	pushl  -0xc(%ebp)
8010589c:	e8 7f b6 ff ff       	call   80100f20 <fileclose>
  return 0;
801058a1:	83 c4 10             	add    $0x10,%esp
801058a4:	31 c0                	xor    %eax,%eax
}
801058a6:	c9                   	leave  
801058a7:	c3                   	ret    
801058a8:	90                   	nop
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b5:	c9                   	leave  
801058b6:	c3                   	ret    
801058b7:	89 f6                	mov    %esi,%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058c0 <sys_fstat>:
{
801058c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801058c1:	31 c0                	xor    %eax,%eax
{
801058c3:	89 e5                	mov    %esp,%ebp
801058c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801058c8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801058cb:	e8 30 fc ff ff       	call   80105500 <argfd.constprop.0>
801058d0:	85 c0                	test   %eax,%eax
801058d2:	78 2c                	js     80105900 <sys_fstat+0x40>
801058d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d7:	83 ec 04             	sub    $0x4,%esp
801058da:	6a 14                	push   $0x14
801058dc:	50                   	push   %eax
801058dd:	6a 01                	push   $0x1
801058df:	e8 3c f9 ff ff       	call   80105220 <argptr>
801058e4:	83 c4 10             	add    $0x10,%esp
801058e7:	85 c0                	test   %eax,%eax
801058e9:	78 15                	js     80105900 <sys_fstat+0x40>
  return filestat(f, st);
801058eb:	83 ec 08             	sub    $0x8,%esp
801058ee:	ff 75 f4             	pushl  -0xc(%ebp)
801058f1:	ff 75 f0             	pushl  -0x10(%ebp)
801058f4:	e8 f7 b6 ff ff       	call   80100ff0 <filestat>
801058f9:	83 c4 10             	add    $0x10,%esp
}
801058fc:	c9                   	leave  
801058fd:	c3                   	ret    
801058fe:	66 90                	xchg   %ax,%ax
    return -1;
80105900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105905:	c9                   	leave  
80105906:	c3                   	ret    
80105907:	89 f6                	mov    %esi,%esi
80105909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105910 <sys_link>:
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
80105915:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105916:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105919:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010591c:	50                   	push   %eax
8010591d:	6a 00                	push   $0x0
8010591f:	e8 4c f9 ff ff       	call   80105270 <argstr>
80105924:	83 c4 10             	add    $0x10,%esp
80105927:	85 c0                	test   %eax,%eax
80105929:	0f 88 fb 00 00 00    	js     80105a2a <sys_link+0x11a>
8010592f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105932:	83 ec 08             	sub    $0x8,%esp
80105935:	50                   	push   %eax
80105936:	6a 01                	push   $0x1
80105938:	e8 33 f9 ff ff       	call   80105270 <argstr>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	0f 88 e2 00 00 00    	js     80105a2a <sys_link+0x11a>
  begin_op();
80105948:	e8 53 d6 ff ff       	call   80102fa0 <begin_op>
  if((ip = namei(old)) == 0){
8010594d:	83 ec 0c             	sub    $0xc,%esp
80105950:	ff 75 d4             	pushl  -0x2c(%ebp)
80105953:	e8 f8 c6 ff ff       	call   80102050 <namei>
80105958:	83 c4 10             	add    $0x10,%esp
8010595b:	85 c0                	test   %eax,%eax
8010595d:	89 c3                	mov    %eax,%ebx
8010595f:	0f 84 ea 00 00 00    	je     80105a4f <sys_link+0x13f>
  ilock(ip);
80105965:	83 ec 0c             	sub    $0xc,%esp
80105968:	50                   	push   %eax
80105969:	e8 42 be ff ff       	call   801017b0 <ilock>
  if(ip->type == T_DIR){
8010596e:	83 c4 10             	add    $0x10,%esp
80105971:	80 7b 10 01          	cmpb   $0x1,0x10(%ebx)
80105975:	0f 84 bc 00 00 00    	je     80105a37 <sys_link+0x127>
  ip->nlink++;
8010597b:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
80105980:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105983:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105986:	53                   	push   %ebx
80105987:	e8 64 bd ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
8010598c:	89 1c 24             	mov    %ebx,(%esp)
8010598f:	e8 2c bf ff ff       	call   801018c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105994:	58                   	pop    %eax
80105995:	5a                   	pop    %edx
80105996:	57                   	push   %edi
80105997:	ff 75 d0             	pushl  -0x30(%ebp)
8010599a:	e8 d1 c6 ff ff       	call   80102070 <nameiparent>
8010599f:	83 c4 10             	add    $0x10,%esp
801059a2:	85 c0                	test   %eax,%eax
801059a4:	89 c6                	mov    %eax,%esi
801059a6:	74 5c                	je     80105a04 <sys_link+0xf4>
  ilock(dp);
801059a8:	83 ec 0c             	sub    $0xc,%esp
801059ab:	50                   	push   %eax
801059ac:	e8 ff bd ff ff       	call   801017b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059b1:	83 c4 10             	add    $0x10,%esp
801059b4:	8b 03                	mov    (%ebx),%eax
801059b6:	39 06                	cmp    %eax,(%esi)
801059b8:	75 3e                	jne    801059f8 <sys_link+0xe8>
801059ba:	83 ec 04             	sub    $0x4,%esp
801059bd:	ff 73 04             	pushl  0x4(%ebx)
801059c0:	57                   	push   %edi
801059c1:	56                   	push   %esi
801059c2:	e8 c9 c5 ff ff       	call   80101f90 <dirlink>
801059c7:	83 c4 10             	add    $0x10,%esp
801059ca:	85 c0                	test   %eax,%eax
801059cc:	78 2a                	js     801059f8 <sys_link+0xe8>
  iunlockput(dp);
801059ce:	83 ec 0c             	sub    $0xc,%esp
801059d1:	56                   	push   %esi
801059d2:	e8 a9 c0 ff ff       	call   80101a80 <iunlockput>
  iput(ip);
801059d7:	89 1c 24             	mov    %ebx,(%esp)
801059da:	e8 41 bf ff ff       	call   80101920 <iput>
  end_op();
801059df:	e8 2c d6 ff ff       	call   80103010 <end_op>
  return 0;
801059e4:	83 c4 10             	add    $0x10,%esp
801059e7:	31 c0                	xor    %eax,%eax
}
801059e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059ec:	5b                   	pop    %ebx
801059ed:	5e                   	pop    %esi
801059ee:	5f                   	pop    %edi
801059ef:	5d                   	pop    %ebp
801059f0:	c3                   	ret    
801059f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(dp);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	56                   	push   %esi
801059fc:	e8 7f c0 ff ff       	call   80101a80 <iunlockput>
    goto bad;
80105a01:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a04:	83 ec 0c             	sub    $0xc,%esp
80105a07:	53                   	push   %ebx
80105a08:	e8 a3 bd ff ff       	call   801017b0 <ilock>
  ip->nlink--;
80105a0d:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80105a12:	89 1c 24             	mov    %ebx,(%esp)
80105a15:	e8 d6 bc ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80105a1a:	89 1c 24             	mov    %ebx,(%esp)
80105a1d:	e8 5e c0 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105a22:	e8 e9 d5 ff ff       	call   80103010 <end_op>
  return -1;
80105a27:	83 c4 10             	add    $0x10,%esp
}
80105a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105a2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a32:	5b                   	pop    %ebx
80105a33:	5e                   	pop    %esi
80105a34:	5f                   	pop    %edi
80105a35:	5d                   	pop    %ebp
80105a36:	c3                   	ret    
    iunlockput(ip);
80105a37:	83 ec 0c             	sub    $0xc,%esp
80105a3a:	53                   	push   %ebx
80105a3b:	e8 40 c0 ff ff       	call   80101a80 <iunlockput>
    end_op();
80105a40:	e8 cb d5 ff ff       	call   80103010 <end_op>
    return -1;
80105a45:	83 c4 10             	add    $0x10,%esp
80105a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a4d:	eb 9a                	jmp    801059e9 <sys_link+0xd9>
    end_op();
80105a4f:	e8 bc d5 ff ff       	call   80103010 <end_op>
    return -1;
80105a54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a59:	eb 8e                	jmp    801059e9 <sys_link+0xd9>
80105a5b:	90                   	nop
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a60 <sys_unlink>:
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	57                   	push   %edi
80105a64:	56                   	push   %esi
80105a65:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105a66:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105a69:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105a6c:	50                   	push   %eax
80105a6d:	6a 00                	push   $0x0
80105a6f:	e8 fc f7 ff ff       	call   80105270 <argstr>
80105a74:	83 c4 10             	add    $0x10,%esp
80105a77:	85 c0                	test   %eax,%eax
80105a79:	0f 88 77 01 00 00    	js     80105bf6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80105a7f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105a82:	e8 19 d5 ff ff       	call   80102fa0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105a87:	83 ec 08             	sub    $0x8,%esp
80105a8a:	53                   	push   %ebx
80105a8b:	ff 75 c0             	pushl  -0x40(%ebp)
80105a8e:	e8 dd c5 ff ff       	call   80102070 <nameiparent>
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	85 c0                	test   %eax,%eax
80105a98:	89 c6                	mov    %eax,%esi
80105a9a:	0f 84 60 01 00 00    	je     80105c00 <sys_unlink+0x1a0>
  ilock(dp);
80105aa0:	83 ec 0c             	sub    $0xc,%esp
80105aa3:	50                   	push   %eax
80105aa4:	e8 07 bd ff ff       	call   801017b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105aa9:	58                   	pop    %eax
80105aaa:	5a                   	pop    %edx
80105aab:	68 e8 8b 10 80       	push   $0x80108be8
80105ab0:	53                   	push   %ebx
80105ab1:	e8 4a c2 ff ff       	call   80101d00 <namecmp>
80105ab6:	83 c4 10             	add    $0x10,%esp
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	0f 84 03 01 00 00    	je     80105bc4 <sys_unlink+0x164>
80105ac1:	83 ec 08             	sub    $0x8,%esp
80105ac4:	68 e7 8b 10 80       	push   $0x80108be7
80105ac9:	53                   	push   %ebx
80105aca:	e8 31 c2 ff ff       	call   80101d00 <namecmp>
80105acf:	83 c4 10             	add    $0x10,%esp
80105ad2:	85 c0                	test   %eax,%eax
80105ad4:	0f 84 ea 00 00 00    	je     80105bc4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105ada:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105add:	83 ec 04             	sub    $0x4,%esp
80105ae0:	50                   	push   %eax
80105ae1:	53                   	push   %ebx
80105ae2:	56                   	push   %esi
80105ae3:	e8 38 c2 ff ff       	call   80101d20 <dirlookup>
80105ae8:	83 c4 10             	add    $0x10,%esp
80105aeb:	85 c0                	test   %eax,%eax
80105aed:	89 c3                	mov    %eax,%ebx
80105aef:	0f 84 cf 00 00 00    	je     80105bc4 <sys_unlink+0x164>
  ilock(ip);
80105af5:	83 ec 0c             	sub    $0xc,%esp
80105af8:	50                   	push   %eax
80105af9:	e8 b2 bc ff ff       	call   801017b0 <ilock>
  if(ip->nlink < 1)
80105afe:	83 c4 10             	add    $0x10,%esp
80105b01:	66 83 7b 16 00       	cmpw   $0x0,0x16(%ebx)
80105b06:	0f 8e 10 01 00 00    	jle    80105c1c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b0c:	80 7b 10 01          	cmpb   $0x1,0x10(%ebx)
80105b10:	74 6e                	je     80105b80 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105b12:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105b15:	83 ec 04             	sub    $0x4,%esp
80105b18:	6a 10                	push   $0x10
80105b1a:	6a 00                	push   $0x0
80105b1c:	50                   	push   %eax
80105b1d:	e8 de f3 ff ff       	call   80104f00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b22:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105b25:	6a 10                	push   $0x10
80105b27:	ff 75 c4             	pushl  -0x3c(%ebp)
80105b2a:	50                   	push   %eax
80105b2b:	56                   	push   %esi
80105b2c:	e8 9f c0 ff ff       	call   80101bd0 <writei>
80105b31:	83 c4 20             	add    $0x20,%esp
80105b34:	83 f8 10             	cmp    $0x10,%eax
80105b37:	0f 85 ec 00 00 00    	jne    80105c29 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80105b3d:	80 7b 10 01          	cmpb   $0x1,0x10(%ebx)
80105b41:	0f 84 99 00 00 00    	je     80105be0 <sys_unlink+0x180>
  iunlockput(dp);
80105b47:	83 ec 0c             	sub    $0xc,%esp
80105b4a:	56                   	push   %esi
80105b4b:	e8 30 bf ff ff       	call   80101a80 <iunlockput>
  ip->nlink--;
80105b50:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80105b55:	89 1c 24             	mov    %ebx,(%esp)
80105b58:	e8 93 bb ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80105b5d:	89 1c 24             	mov    %ebx,(%esp)
80105b60:	e8 1b bf ff ff       	call   80101a80 <iunlockput>
  end_op();
80105b65:	e8 a6 d4 ff ff       	call   80103010 <end_op>
  return 0;
80105b6a:	83 c4 10             	add    $0x10,%esp
80105b6d:	31 c0                	xor    %eax,%eax
}
80105b6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b72:	5b                   	pop    %ebx
80105b73:	5e                   	pop    %esi
80105b74:	5f                   	pop    %edi
80105b75:	5d                   	pop    %ebp
80105b76:	c3                   	ret    
80105b77:	89 f6                	mov    %esi,%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b80:	83 7b 18 20          	cmpl   $0x20,0x18(%ebx)
80105b84:	76 8c                	jbe    80105b12 <sys_unlink+0xb2>
80105b86:	bf 20 00 00 00       	mov    $0x20,%edi
80105b8b:	eb 0f                	jmp    80105b9c <sys_unlink+0x13c>
80105b8d:	8d 76 00             	lea    0x0(%esi),%esi
80105b90:	83 c7 10             	add    $0x10,%edi
80105b93:	3b 7b 18             	cmp    0x18(%ebx),%edi
80105b96:	0f 83 76 ff ff ff    	jae    80105b12 <sys_unlink+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b9c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105b9f:	6a 10                	push   $0x10
80105ba1:	57                   	push   %edi
80105ba2:	50                   	push   %eax
80105ba3:	53                   	push   %ebx
80105ba4:	e8 37 bf ff ff       	call   80101ae0 <readi>
80105ba9:	83 c4 10             	add    $0x10,%esp
80105bac:	83 f8 10             	cmp    $0x10,%eax
80105baf:	75 5e                	jne    80105c0f <sys_unlink+0x1af>
    if(de.inum != 0)
80105bb1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105bb6:	74 d8                	je     80105b90 <sys_unlink+0x130>
    iunlockput(ip);
80105bb8:	83 ec 0c             	sub    $0xc,%esp
80105bbb:	53                   	push   %ebx
80105bbc:	e8 bf be ff ff       	call   80101a80 <iunlockput>
    goto bad;
80105bc1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105bc4:	83 ec 0c             	sub    $0xc,%esp
80105bc7:	56                   	push   %esi
80105bc8:	e8 b3 be ff ff       	call   80101a80 <iunlockput>
  end_op();
80105bcd:	e8 3e d4 ff ff       	call   80103010 <end_op>
  return -1;
80105bd2:	83 c4 10             	add    $0x10,%esp
80105bd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bda:	eb 93                	jmp    80105b6f <sys_unlink+0x10f>
80105bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105be0:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
    iupdate(dp);
80105be5:	83 ec 0c             	sub    $0xc,%esp
80105be8:	56                   	push   %esi
80105be9:	e8 02 bb ff ff       	call   801016f0 <iupdate>
80105bee:	83 c4 10             	add    $0x10,%esp
80105bf1:	e9 51 ff ff ff       	jmp    80105b47 <sys_unlink+0xe7>
    return -1;
80105bf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bfb:	e9 6f ff ff ff       	jmp    80105b6f <sys_unlink+0x10f>
    end_op();
80105c00:	e8 0b d4 ff ff       	call   80103010 <end_op>
    return -1;
80105c05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c0a:	e9 60 ff ff ff       	jmp    80105b6f <sys_unlink+0x10f>
      panic("isdirempty: readi");
80105c0f:	83 ec 0c             	sub    $0xc,%esp
80105c12:	68 0c 8c 10 80       	push   $0x80108c0c
80105c17:	e8 64 a8 ff ff       	call   80100480 <panic>
    panic("unlink: nlink < 1");
80105c1c:	83 ec 0c             	sub    $0xc,%esp
80105c1f:	68 fa 8b 10 80       	push   $0x80108bfa
80105c24:	e8 57 a8 ff ff       	call   80100480 <panic>
    panic("unlink: writei");
80105c29:	83 ec 0c             	sub    $0xc,%esp
80105c2c:	68 1e 8c 10 80       	push   $0x80108c1e
80105c31:	e8 4a a8 ff ff       	call   80100480 <panic>
80105c36:	8d 76 00             	lea    0x0(%esi),%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c40 <sys_open>:

int
sys_open(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	57                   	push   %edi
80105c44:	56                   	push   %esi
80105c45:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c46:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105c49:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c4c:	50                   	push   %eax
80105c4d:	6a 00                	push   $0x0
80105c4f:	e8 1c f6 ff ff       	call   80105270 <argstr>
80105c54:	83 c4 10             	add    $0x10,%esp
80105c57:	85 c0                	test   %eax,%eax
80105c59:	0f 88 1d 01 00 00    	js     80105d7c <sys_open+0x13c>
80105c5f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c62:	83 ec 08             	sub    $0x8,%esp
80105c65:	50                   	push   %eax
80105c66:	6a 01                	push   $0x1
80105c68:	e8 73 f5 ff ff       	call   801051e0 <argint>
80105c6d:	83 c4 10             	add    $0x10,%esp
80105c70:	85 c0                	test   %eax,%eax
80105c72:	0f 88 04 01 00 00    	js     80105d7c <sys_open+0x13c>
    return -1;

  begin_op();
80105c78:	e8 23 d3 ff ff       	call   80102fa0 <begin_op>

  if(omode & O_CREATE){
80105c7d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105c81:	0f 85 a9 00 00 00    	jne    80105d30 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105c87:	83 ec 0c             	sub    $0xc,%esp
80105c8a:	ff 75 e0             	pushl  -0x20(%ebp)
80105c8d:	e8 be c3 ff ff       	call   80102050 <namei>
80105c92:	83 c4 10             	add    $0x10,%esp
80105c95:	85 c0                	test   %eax,%eax
80105c97:	89 c6                	mov    %eax,%esi
80105c99:	0f 84 b2 00 00 00    	je     80105d51 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105c9f:	83 ec 0c             	sub    $0xc,%esp
80105ca2:	50                   	push   %eax
80105ca3:	e8 08 bb ff ff       	call   801017b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ca8:	83 c4 10             	add    $0x10,%esp
80105cab:	80 7e 10 01          	cmpb   $0x1,0x10(%esi)
80105caf:	0f 84 ab 00 00 00    	je     80105d60 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105cb5:	e8 a6 b1 ff ff       	call   80100e60 <filealloc>
80105cba:	85 c0                	test   %eax,%eax
80105cbc:	89 c7                	mov    %eax,%edi
80105cbe:	0f 84 a7 00 00 00    	je     80105d6b <sys_open+0x12b>
    if(proc->ofile[fd] == 0){
80105cc4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  for(fd = 0; fd < NOFILE; fd++){
80105ccb:	31 db                	xor    %ebx,%ebx
80105ccd:	eb 0d                	jmp    80105cdc <sys_open+0x9c>
80105ccf:	90                   	nop
80105cd0:	83 c3 01             	add    $0x1,%ebx
80105cd3:	83 fb 10             	cmp    $0x10,%ebx
80105cd6:	0f 84 ac 00 00 00    	je     80105d88 <sys_open+0x148>
    if(proc->ofile[fd] == 0){
80105cdc:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
80105ce0:	85 c0                	test   %eax,%eax
80105ce2:	75 ec                	jne    80105cd0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ce4:	83 ec 0c             	sub    $0xc,%esp
      proc->ofile[fd] = f;
80105ce7:	89 7c 9a 28          	mov    %edi,0x28(%edx,%ebx,4)
  iunlock(ip);
80105ceb:	56                   	push   %esi
80105cec:	e8 cf bb ff ff       	call   801018c0 <iunlock>
  end_op();
80105cf1:	e8 1a d3 ff ff       	call   80103010 <end_op>

  f->type = FD_INODE;
80105cf6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105cfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105cff:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105d02:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105d05:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105d0c:	89 d0                	mov    %edx,%eax
80105d0e:	f7 d0                	not    %eax
80105d10:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d13:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105d16:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d19:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d20:	89 d8                	mov    %ebx,%eax
80105d22:	5b                   	pop    %ebx
80105d23:	5e                   	pop    %esi
80105d24:	5f                   	pop    %edi
80105d25:	5d                   	pop    %ebp
80105d26:	c3                   	ret    
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105d30:	83 ec 0c             	sub    $0xc,%esp
80105d33:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d36:	31 c9                	xor    %ecx,%ecx
80105d38:	6a 00                	push   $0x0
80105d3a:	ba 02 00 00 00       	mov    $0x2,%edx
80105d3f:	e8 1c f6 ff ff       	call   80105360 <create>
    if(ip == 0){
80105d44:	83 c4 10             	add    $0x10,%esp
80105d47:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105d49:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105d4b:	0f 85 64 ff ff ff    	jne    80105cb5 <sys_open+0x75>
      end_op();
80105d51:	e8 ba d2 ff ff       	call   80103010 <end_op>
      return -1;
80105d56:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d5b:	eb c0                	jmp    80105d1d <sys_open+0xdd>
80105d5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105d63:	85 d2                	test   %edx,%edx
80105d65:	0f 84 4a ff ff ff    	je     80105cb5 <sys_open+0x75>
    iunlockput(ip);
80105d6b:	83 ec 0c             	sub    $0xc,%esp
80105d6e:	56                   	push   %esi
80105d6f:	e8 0c bd ff ff       	call   80101a80 <iunlockput>
    end_op();
80105d74:	e8 97 d2 ff ff       	call   80103010 <end_op>
    return -1;
80105d79:	83 c4 10             	add    $0x10,%esp
80105d7c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d81:	eb 9a                	jmp    80105d1d <sys_open+0xdd>
80105d83:	90                   	nop
80105d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105d88:	83 ec 0c             	sub    $0xc,%esp
80105d8b:	57                   	push   %edi
80105d8c:	e8 8f b1 ff ff       	call   80100f20 <fileclose>
80105d91:	83 c4 10             	add    $0x10,%esp
80105d94:	eb d5                	jmp    80105d6b <sys_open+0x12b>
80105d96:	8d 76 00             	lea    0x0(%esi),%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105da0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105da6:	e8 f5 d1 ff ff       	call   80102fa0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105dab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dae:	83 ec 08             	sub    $0x8,%esp
80105db1:	50                   	push   %eax
80105db2:	6a 00                	push   $0x0
80105db4:	e8 b7 f4 ff ff       	call   80105270 <argstr>
80105db9:	83 c4 10             	add    $0x10,%esp
80105dbc:	85 c0                	test   %eax,%eax
80105dbe:	78 30                	js     80105df0 <sys_mkdir+0x50>
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc6:	31 c9                	xor    %ecx,%ecx
80105dc8:	6a 00                	push   $0x0
80105dca:	ba 01 00 00 00       	mov    $0x1,%edx
80105dcf:	e8 8c f5 ff ff       	call   80105360 <create>
80105dd4:	83 c4 10             	add    $0x10,%esp
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	74 15                	je     80105df0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105ddb:	83 ec 0c             	sub    $0xc,%esp
80105dde:	50                   	push   %eax
80105ddf:	e8 9c bc ff ff       	call   80101a80 <iunlockput>
  end_op();
80105de4:	e8 27 d2 ff ff       	call   80103010 <end_op>
  return 0;
80105de9:	83 c4 10             	add    $0x10,%esp
80105dec:	31 c0                	xor    %eax,%eax
}
80105dee:	c9                   	leave  
80105def:	c3                   	ret    
    end_op();
80105df0:	e8 1b d2 ff ff       	call   80103010 <end_op>
    return -1;
80105df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dfa:	c9                   	leave  
80105dfb:	c3                   	ret    
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_mknod>:

int
sys_mknod(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105e06:	e8 95 d1 ff ff       	call   80102fa0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105e0b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e0e:	83 ec 08             	sub    $0x8,%esp
80105e11:	50                   	push   %eax
80105e12:	6a 00                	push   $0x0
80105e14:	e8 57 f4 ff ff       	call   80105270 <argstr>
80105e19:	83 c4 10             	add    $0x10,%esp
80105e1c:	85 c0                	test   %eax,%eax
80105e1e:	78 60                	js     80105e80 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105e20:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e23:	83 ec 08             	sub    $0x8,%esp
80105e26:	50                   	push   %eax
80105e27:	6a 01                	push   $0x1
80105e29:	e8 b2 f3 ff ff       	call   801051e0 <argint>
  if((argstr(0, &path)) < 0 ||
80105e2e:	83 c4 10             	add    $0x10,%esp
80105e31:	85 c0                	test   %eax,%eax
80105e33:	78 4b                	js     80105e80 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105e35:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e38:	83 ec 08             	sub    $0x8,%esp
80105e3b:	50                   	push   %eax
80105e3c:	6a 02                	push   $0x2
80105e3e:	e8 9d f3 ff ff       	call   801051e0 <argint>
     argint(1, &major) < 0 ||
80105e43:	83 c4 10             	add    $0x10,%esp
80105e46:	85 c0                	test   %eax,%eax
80105e48:	78 36                	js     80105e80 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e4a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105e4e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e51:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105e55:	ba 03 00 00 00       	mov    $0x3,%edx
80105e5a:	50                   	push   %eax
80105e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e5e:	e8 fd f4 ff ff       	call   80105360 <create>
80105e63:	83 c4 10             	add    $0x10,%esp
80105e66:	85 c0                	test   %eax,%eax
80105e68:	74 16                	je     80105e80 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e6a:	83 ec 0c             	sub    $0xc,%esp
80105e6d:	50                   	push   %eax
80105e6e:	e8 0d bc ff ff       	call   80101a80 <iunlockput>
  end_op();
80105e73:	e8 98 d1 ff ff       	call   80103010 <end_op>
  return 0;
80105e78:	83 c4 10             	add    $0x10,%esp
80105e7b:	31 c0                	xor    %eax,%eax
}
80105e7d:	c9                   	leave  
80105e7e:	c3                   	ret    
80105e7f:	90                   	nop
    end_op();
80105e80:	e8 8b d1 ff ff       	call   80103010 <end_op>
    return -1;
80105e85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e8a:	c9                   	leave  
80105e8b:	c3                   	ret    
80105e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e90 <sys_chdir>:

int
sys_chdir(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	53                   	push   %ebx
80105e94:	83 ec 14             	sub    $0x14,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105e97:	e8 04 d1 ff ff       	call   80102fa0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105e9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e9f:	83 ec 08             	sub    $0x8,%esp
80105ea2:	50                   	push   %eax
80105ea3:	6a 00                	push   $0x0
80105ea5:	e8 c6 f3 ff ff       	call   80105270 <argstr>
80105eaa:	83 c4 10             	add    $0x10,%esp
80105ead:	85 c0                	test   %eax,%eax
80105eaf:	78 7f                	js     80105f30 <sys_chdir+0xa0>
80105eb1:	83 ec 0c             	sub    $0xc,%esp
80105eb4:	ff 75 f4             	pushl  -0xc(%ebp)
80105eb7:	e8 94 c1 ff ff       	call   80102050 <namei>
80105ebc:	83 c4 10             	add    $0x10,%esp
80105ebf:	85 c0                	test   %eax,%eax
80105ec1:	89 c3                	mov    %eax,%ebx
80105ec3:	74 6b                	je     80105f30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105ec5:	83 ec 0c             	sub    $0xc,%esp
80105ec8:	50                   	push   %eax
80105ec9:	e8 e2 b8 ff ff       	call   801017b0 <ilock>
  if(ip->type != T_DIR){
80105ece:	83 c4 10             	add    $0x10,%esp
80105ed1:	80 7b 10 01          	cmpb   $0x1,0x10(%ebx)
80105ed5:	75 39                	jne    80105f10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ed7:	83 ec 0c             	sub    $0xc,%esp
80105eda:	53                   	push   %ebx
80105edb:	e8 e0 b9 ff ff       	call   801018c0 <iunlock>
  iput(proc->cwd);
80105ee0:	58                   	pop    %eax
80105ee1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ee7:	ff 70 68             	pushl  0x68(%eax)
80105eea:	e8 31 ba ff ff       	call   80101920 <iput>
  end_op();
80105eef:	e8 1c d1 ff ff       	call   80103010 <end_op>
  proc->cwd = ip;
80105ef4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return 0;
80105efa:	83 c4 10             	add    $0x10,%esp
  proc->cwd = ip;
80105efd:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
80105f00:	31 c0                	xor    %eax,%eax
}
80105f02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f05:	c9                   	leave  
80105f06:	c3                   	ret    
80105f07:	89 f6                	mov    %esi,%esi
80105f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105f10:	83 ec 0c             	sub    $0xc,%esp
80105f13:	53                   	push   %ebx
80105f14:	e8 67 bb ff ff       	call   80101a80 <iunlockput>
    end_op();
80105f19:	e8 f2 d0 ff ff       	call   80103010 <end_op>
    return -1;
80105f1e:	83 c4 10             	add    $0x10,%esp
80105f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f26:	eb da                	jmp    80105f02 <sys_chdir+0x72>
80105f28:	90                   	nop
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105f30:	e8 db d0 ff ff       	call   80103010 <end_op>
    return -1;
80105f35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3a:	eb c6                	jmp    80105f02 <sys_chdir+0x72>
80105f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f40 <sys_exec>:

int
sys_exec(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	57                   	push   %edi
80105f44:	56                   	push   %esi
80105f45:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f46:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105f4c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f52:	50                   	push   %eax
80105f53:	6a 00                	push   $0x0
80105f55:	e8 16 f3 ff ff       	call   80105270 <argstr>
80105f5a:	83 c4 10             	add    $0x10,%esp
80105f5d:	85 c0                	test   %eax,%eax
80105f5f:	0f 88 87 00 00 00    	js     80105fec <sys_exec+0xac>
80105f65:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105f6b:	83 ec 08             	sub    $0x8,%esp
80105f6e:	50                   	push   %eax
80105f6f:	6a 01                	push   $0x1
80105f71:	e8 6a f2 ff ff       	call   801051e0 <argint>
80105f76:	83 c4 10             	add    $0x10,%esp
80105f79:	85 c0                	test   %eax,%eax
80105f7b:	78 6f                	js     80105fec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105f7d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105f83:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105f86:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105f88:	68 80 00 00 00       	push   $0x80
80105f8d:	6a 00                	push   $0x0
80105f8f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105f95:	50                   	push   %eax
80105f96:	e8 65 ef ff ff       	call   80104f00 <memset>
80105f9b:	83 c4 10             	add    $0x10,%esp
80105f9e:	eb 2c                	jmp    80105fcc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105fa0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105fa6:	85 c0                	test   %eax,%eax
80105fa8:	74 56                	je     80106000 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105faa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105fb0:	83 ec 08             	sub    $0x8,%esp
80105fb3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105fb6:	52                   	push   %edx
80105fb7:	50                   	push   %eax
80105fb8:	e8 c3 f1 ff ff       	call   80105180 <fetchstr>
80105fbd:	83 c4 10             	add    $0x10,%esp
80105fc0:	85 c0                	test   %eax,%eax
80105fc2:	78 28                	js     80105fec <sys_exec+0xac>
  for(i=0;; i++){
80105fc4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105fc7:	83 fb 20             	cmp    $0x20,%ebx
80105fca:	74 20                	je     80105fec <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105fcc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105fd2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105fd9:	83 ec 08             	sub    $0x8,%esp
80105fdc:	57                   	push   %edi
80105fdd:	01 f0                	add    %esi,%eax
80105fdf:	50                   	push   %eax
80105fe0:	e8 6b f1 ff ff       	call   80105150 <fetchint>
80105fe5:	83 c4 10             	add    $0x10,%esp
80105fe8:	85 c0                	test   %eax,%eax
80105fea:	79 b4                	jns    80105fa0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105fec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105fef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ff4:	5b                   	pop    %ebx
80105ff5:	5e                   	pop    %esi
80105ff6:	5f                   	pop    %edi
80105ff7:	5d                   	pop    %ebp
80105ff8:	c3                   	ret    
80105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106000:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106006:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106009:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106010:	00 00 00 00 
  return exec(path, argv);
80106014:	50                   	push   %eax
80106015:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010601b:	e8 e0 aa ff ff       	call   80100b00 <exec>
80106020:	83 c4 10             	add    $0x10,%esp
}
80106023:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106026:	5b                   	pop    %ebx
80106027:	5e                   	pop    %esi
80106028:	5f                   	pop    %edi
80106029:	5d                   	pop    %ebp
8010602a:	c3                   	ret    
8010602b:	90                   	nop
8010602c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106030 <sys_pipe>:

int
sys_pipe(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	57                   	push   %edi
80106034:	56                   	push   %esi
80106035:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106036:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106039:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010603c:	6a 08                	push   $0x8
8010603e:	50                   	push   %eax
8010603f:	6a 00                	push   $0x0
80106041:	e8 da f1 ff ff       	call   80105220 <argptr>
80106046:	83 c4 10             	add    $0x10,%esp
80106049:	85 c0                	test   %eax,%eax
8010604b:	0f 88 a4 00 00 00    	js     801060f5 <sys_pipe+0xc5>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106051:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106054:	83 ec 08             	sub    $0x8,%esp
80106057:	50                   	push   %eax
80106058:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010605b:	50                   	push   %eax
8010605c:	e8 ef d6 ff ff       	call   80103750 <pipealloc>
80106061:	83 c4 10             	add    $0x10,%esp
80106064:	85 c0                	test   %eax,%eax
80106066:	0f 88 89 00 00 00    	js     801060f5 <sys_pipe+0xc5>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010606c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
    if(proc->ofile[fd] == 0){
8010606f:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
  for(fd = 0; fd < NOFILE; fd++){
80106076:	31 c0                	xor    %eax,%eax
80106078:	eb 0e                	jmp    80106088 <sys_pipe+0x58>
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106080:	83 c0 01             	add    $0x1,%eax
80106083:	83 f8 10             	cmp    $0x10,%eax
80106086:	74 58                	je     801060e0 <sys_pipe+0xb0>
    if(proc->ofile[fd] == 0){
80106088:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
8010608c:	85 d2                	test   %edx,%edx
8010608e:	75 f0                	jne    80106080 <sys_pipe+0x50>
80106090:	8d 34 81             	lea    (%ecx,%eax,4),%esi
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106093:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106096:	31 d2                	xor    %edx,%edx
      proc->ofile[fd] = f;
80106098:	89 5e 28             	mov    %ebx,0x28(%esi)
8010609b:	eb 0b                	jmp    801060a8 <sys_pipe+0x78>
8010609d:	8d 76 00             	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801060a0:	83 c2 01             	add    $0x1,%edx
801060a3:	83 fa 10             	cmp    $0x10,%edx
801060a6:	74 28                	je     801060d0 <sys_pipe+0xa0>
    if(proc->ofile[fd] == 0){
801060a8:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
801060ad:	75 f1                	jne    801060a0 <sys_pipe+0x70>
      proc->ofile[fd] = f;
801060af:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801060b3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801060b6:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
801060b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801060bb:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801060be:	31 c0                	xor    %eax,%eax
}
801060c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060c3:	5b                   	pop    %ebx
801060c4:	5e                   	pop    %esi
801060c5:	5f                   	pop    %edi
801060c6:	5d                   	pop    %ebp
801060c7:	c3                   	ret    
801060c8:	90                   	nop
801060c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      proc->ofile[fd0] = 0;
801060d0:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
801060d7:	89 f6                	mov    %esi,%esi
801060d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    fileclose(rf);
801060e0:	83 ec 0c             	sub    $0xc,%esp
801060e3:	53                   	push   %ebx
801060e4:	e8 37 ae ff ff       	call   80100f20 <fileclose>
    fileclose(wf);
801060e9:	58                   	pop    %eax
801060ea:	ff 75 e4             	pushl  -0x1c(%ebp)
801060ed:	e8 2e ae ff ff       	call   80100f20 <fileclose>
    return -1;
801060f2:	83 c4 10             	add    $0x10,%esp
801060f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060fa:	eb c4                	jmp    801060c0 <sys_pipe+0x90>
801060fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106100 <sys_open_fifo>:

int
sys_open_fifo(void)
{
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	57                   	push   %edi
80106104:	56                   	push   %esi
80106105:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106106:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106109:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010610c:	50                   	push   %eax
8010610d:	6a 00                	push   $0x0
8010610f:	e8 5c f1 ff ff       	call   80105270 <argstr>
80106114:	83 c4 10             	add    $0x10,%esp
80106117:	85 c0                	test   %eax,%eax
80106119:	0f 88 65 01 00 00    	js     80106284 <sys_open_fifo+0x184>
8010611f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106122:	83 ec 08             	sub    $0x8,%esp
80106125:	50                   	push   %eax
80106126:	6a 01                	push   $0x1
80106128:	e8 b3 f0 ff ff       	call   801051e0 <argint>
8010612d:	83 c4 10             	add    $0x10,%esp
80106130:	85 c0                	test   %eax,%eax
80106132:	0f 88 4c 01 00 00    	js     80106284 <sys_open_fifo+0x184>
    return -1;

  begin_op();
80106138:	e8 63 ce ff ff       	call   80102fa0 <begin_op>

  if(omode & O_CREATE){
8010613d:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80106141:	0f 85 f1 00 00 00    	jne    80106238 <sys_open_fifo+0x138>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106147:	83 ec 0c             	sub    $0xc,%esp
8010614a:	ff 75 dc             	pushl  -0x24(%ebp)
8010614d:	e8 fe be ff ff       	call   80102050 <namei>
80106152:	83 c4 10             	add    $0x10,%esp
80106155:	85 c0                	test   %eax,%eax
80106157:	89 c6                	mov    %eax,%esi
80106159:	0f 84 fa 00 00 00    	je     80106259 <sys_open_fifo+0x159>
      end_op();
      return -1;
    }
    ilock(ip);
8010615f:	83 ec 0c             	sub    $0xc,%esp
80106162:	50                   	push   %eax
80106163:	e8 48 b6 ff ff       	call   801017b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106168:	83 c4 10             	add    $0x10,%esp
8010616b:	80 7e 10 01          	cmpb   $0x1,0x10(%esi)
8010616f:	0f 84 f3 00 00 00    	je     80106268 <sys_open_fifo+0x168>
      return -1;
    }
    
  }
  
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106175:	e8 e6 ac ff ff       	call   80100e60 <filealloc>
8010617a:	85 c0                	test   %eax,%eax
8010617c:	89 c7                	mov    %eax,%edi
8010617e:	0f 84 ef 00 00 00    	je     80106273 <sys_open_fifo+0x173>
    if(proc->ofile[fd] == 0){
80106184:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(fd = 0; fd < NOFILE; fd++){
8010618a:	31 db                	xor    %ebx,%ebx
8010618c:	eb 0e                	jmp    8010619c <sys_open_fifo+0x9c>
8010618e:	66 90                	xchg   %ax,%ax
80106190:	83 c3 01             	add    $0x1,%ebx
80106193:	83 fb 10             	cmp    $0x10,%ebx
80106196:	0f 84 f4 00 00 00    	je     80106290 <sys_open_fifo+0x190>
    if(proc->ofile[fd] == 0){
8010619c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801061a0:	85 d2                	test   %edx,%edx
801061a2:	75 ec                	jne    80106190 <sys_open_fifo+0x90>
    iunlockput(ip);
    end_op();
    return -1;
  }
  ip->mode=111;
  iupdate(ip);
801061a4:	83 ec 0c             	sub    $0xc,%esp
      proc->ofile[fd] = f;
801061a7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  ip->mode=111;
801061ab:	c6 46 11 6f          	movb   $0x6f,0x11(%esi)
  iupdate(ip);
801061af:	56                   	push   %esi
801061b0:	e8 3b b5 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
801061b5:	89 34 24             	mov    %esi,(%esp)
801061b8:	e8 03 b7 ff ff       	call   801018c0 <iunlock>
  end_op();
801061bd:	e8 4e ce ff ff       	call   80103010 <end_op>

  f->type = FD_INODE;
801061c2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801061c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801061cb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801061ce:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801061d1:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801061d8:	89 d0                	mov    %edx,%eax
801061da:	f7 d0                	not    %eax
801061dc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801061df:	83 e2 03             	and    $0x3,%edx
801061e2:	0f 95 47 09          	setne  0x9(%edi)
  f->readable = !(omode & O_WRONLY);
801061e6:	88 47 08             	mov    %al,0x8(%edi)

  uint pa=(uint)kalloc();
801061e9:	e8 92 c5 ff ff       	call   80102780 <kalloc>
  cprintf("open fifo in pa: %p\n",pa);
801061ee:	83 ec 08             	sub    $0x8,%esp
  uint pa=(uint)kalloc();
801061f1:	89 c6                	mov    %eax,%esi
  cprintf("open fifo in pa: %p\n",pa);
801061f3:	50                   	push   %eax
801061f4:	68 2d 8c 10 80       	push   $0x80108c2d
801061f9:	e8 52 a5 ff ff       	call   80100750 <cprintf>
  char s[4];
  s[0]=(pa&0xFF000000)>>24;
801061fe:	89 f0                	mov    %esi,%eax
  s[1]=(pa&0x00FF0000)>>16;
  s[2]=(pa&0x0000FF00)>>8;
  s[3]=(pa&0x000000FF)>>0;
  filewrite(f,s,4);
80106200:	83 c4 0c             	add    $0xc,%esp
  s[0]=(pa&0xFF000000)>>24;
80106203:	c1 e8 18             	shr    $0x18,%eax
  filewrite(f,s,4);
80106206:	6a 04                	push   $0x4
  s[0]=(pa&0xFF000000)>>24;
80106208:	88 45 e4             	mov    %al,-0x1c(%ebp)
  s[1]=(pa&0x00FF0000)>>16;
8010620b:	89 f0                	mov    %esi,%eax
8010620d:	c1 e8 10             	shr    $0x10,%eax
80106210:	88 45 e5             	mov    %al,-0x1b(%ebp)
  s[2]=(pa&0x0000FF00)>>8;
80106213:	89 f0                	mov    %esi,%eax
80106215:	88 65 e6             	mov    %ah,-0x1a(%ebp)
  s[3]=(pa&0x000000FF)>>0;
80106218:	88 45 e7             	mov    %al,-0x19(%ebp)
  filewrite(f,s,4);
8010621b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010621e:	50                   	push   %eax
8010621f:	57                   	push   %edi
80106220:	e8 fb ae ff ff       	call   80101120 <filewrite>
  return fd;
80106225:	83 c4 10             	add    $0x10,%esp
}
80106228:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010622b:	89 d8                	mov    %ebx,%eax
8010622d:	5b                   	pop    %ebx
8010622e:	5e                   	pop    %esi
8010622f:	5f                   	pop    %edi
80106230:	5d                   	pop    %ebp
80106231:	c3                   	ret    
80106232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ip = create(path, T_FILE, 0, 0);
80106238:	83 ec 0c             	sub    $0xc,%esp
8010623b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010623e:	31 c9                	xor    %ecx,%ecx
80106240:	6a 00                	push   $0x0
80106242:	ba 02 00 00 00       	mov    $0x2,%edx
80106247:	e8 14 f1 ff ff       	call   80105360 <create>
    if(ip == 0){
8010624c:	83 c4 10             	add    $0x10,%esp
8010624f:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80106251:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106253:	0f 85 1c ff ff ff    	jne    80106175 <sys_open_fifo+0x75>
      end_op();
80106259:	e8 b2 cd ff ff       	call   80103010 <end_op>
      return -1;
8010625e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106263:	eb c3                	jmp    80106228 <sys_open_fifo+0x128>
80106265:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80106268:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010626b:	85 c9                	test   %ecx,%ecx
8010626d:	0f 84 02 ff ff ff    	je     80106175 <sys_open_fifo+0x75>
    iunlockput(ip);
80106273:	83 ec 0c             	sub    $0xc,%esp
80106276:	56                   	push   %esi
80106277:	e8 04 b8 ff ff       	call   80101a80 <iunlockput>
    end_op();
8010627c:	e8 8f cd ff ff       	call   80103010 <end_op>
    return -1;
80106281:	83 c4 10             	add    $0x10,%esp
80106284:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106289:	eb 9d                	jmp    80106228 <sys_open_fifo+0x128>
8010628b:	90                   	nop
8010628c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80106290:	83 ec 0c             	sub    $0xc,%esp
80106293:	57                   	push   %edi
80106294:	e8 87 ac ff ff       	call   80100f20 <fileclose>
80106299:	83 c4 10             	add    $0x10,%esp
8010629c:	eb d5                	jmp    80106273 <sys_open_fifo+0x173>
8010629e:	66 90                	xchg   %ax,%ax

801062a0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801062a3:	5d                   	pop    %ebp
  return fork();
801062a4:	e9 47 db ff ff       	jmp    80103df0 <fork>
801062a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062b0 <sys_exit>:

int
sys_exit(void)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801062b6:	e8 e5 dd ff ff       	call   801040a0 <exit>
  return 0;  // not reached
}
801062bb:	31 c0                	xor    %eax,%eax
801062bd:	c9                   	leave  
801062be:	c3                   	ret    
801062bf:	90                   	nop

801062c0 <sys_wait>:

int
sys_wait(void)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801062c3:	5d                   	pop    %ebp
  return wait();
801062c4:	e9 a7 e0 ff ff       	jmp    80104370 <wait>
801062c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062d0 <sys_kill>:

int
sys_kill(void)
{
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801062d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062d9:	50                   	push   %eax
801062da:	6a 00                	push   $0x0
801062dc:	e8 ff ee ff ff       	call   801051e0 <argint>
801062e1:	83 c4 10             	add    $0x10,%esp
801062e4:	85 c0                	test   %eax,%eax
801062e6:	78 18                	js     80106300 <sys_kill+0x30>
    return -1;
  return kill(pid);
801062e8:	83 ec 0c             	sub    $0xc,%esp
801062eb:	ff 75 f4             	pushl  -0xc(%ebp)
801062ee:	e8 cd e1 ff ff       	call   801044c0 <kill>
801062f3:	83 c4 10             	add    $0x10,%esp
}
801062f6:	c9                   	leave  
801062f7:	c3                   	ret    
801062f8:	90                   	nop
801062f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106305:	c9                   	leave  
80106306:	c3                   	ret    
80106307:	89 f6                	mov    %esi,%esi
80106309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106310 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80106310:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
{
80106316:	55                   	push   %ebp
80106317:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106319:	8b 40 10             	mov    0x10(%eax),%eax
}
8010631c:	5d                   	pop    %ebp
8010631d:	c3                   	ret    
8010631e:	66 90                	xchg   %ax,%ax

80106320 <sys_sbrk>:

int
sys_sbrk(void)
{
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106324:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106327:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010632a:	50                   	push   %eax
8010632b:	6a 00                	push   $0x0
8010632d:	e8 ae ee ff ff       	call   801051e0 <argint>
80106332:	83 c4 10             	add    $0x10,%esp
80106335:	85 c0                	test   %eax,%eax
80106337:	78 27                	js     80106360 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
80106339:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
8010633f:	83 ec 0c             	sub    $0xc,%esp
  addr = proc->sz;
80106342:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106344:	ff 75 f4             	pushl  -0xc(%ebp)
80106347:	e8 24 da ff ff       	call   80103d70 <growproc>
8010634c:	83 c4 10             	add    $0x10,%esp
8010634f:	85 c0                	test   %eax,%eax
80106351:	78 0d                	js     80106360 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106353:	89 d8                	mov    %ebx,%eax
80106355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106358:	c9                   	leave  
80106359:	c3                   	ret    
8010635a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106360:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106365:	eb ec                	jmp    80106353 <sys_sbrk+0x33>
80106367:	89 f6                	mov    %esi,%esi
80106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106370 <sys_sleep>:

int
sys_sleep(void)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106374:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106377:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010637a:	50                   	push   %eax
8010637b:	6a 00                	push   $0x0
8010637d:	e8 5e ee ff ff       	call   801051e0 <argint>
80106382:	83 c4 10             	add    $0x10,%esp
80106385:	85 c0                	test   %eax,%eax
80106387:	0f 88 8a 00 00 00    	js     80106417 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010638d:	83 ec 0c             	sub    $0xc,%esp
80106390:	68 20 8d 11 80       	push   $0x80118d20
80106395:	e8 c6 e6 ff ff       	call   80104a60 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010639a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010639d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801063a0:	8b 1d 60 95 11 80    	mov    0x80119560,%ebx
  while(ticks - ticks0 < n){
801063a6:	85 d2                	test   %edx,%edx
801063a8:	75 27                	jne    801063d1 <sys_sleep+0x61>
801063aa:	eb 54                	jmp    80106400 <sys_sleep+0x90>
801063ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801063b0:	83 ec 08             	sub    $0x8,%esp
801063b3:	68 20 8d 11 80       	push   $0x80118d20
801063b8:	68 60 95 11 80       	push   $0x80119560
801063bd:	e8 ee de ff ff       	call   801042b0 <sleep>
  while(ticks - ticks0 < n){
801063c2:	a1 60 95 11 80       	mov    0x80119560,%eax
801063c7:	83 c4 10             	add    $0x10,%esp
801063ca:	29 d8                	sub    %ebx,%eax
801063cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801063cf:	73 2f                	jae    80106400 <sys_sleep+0x90>
    if(proc->killed){
801063d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063d7:	8b 40 24             	mov    0x24(%eax),%eax
801063da:	85 c0                	test   %eax,%eax
801063dc:	74 d2                	je     801063b0 <sys_sleep+0x40>
      release(&tickslock);
801063de:	83 ec 0c             	sub    $0xc,%esp
801063e1:	68 20 8d 11 80       	push   $0x80118d20
801063e6:	e8 35 e8 ff ff       	call   80104c20 <release>
      return -1;
801063eb:	83 c4 10             	add    $0x10,%esp
801063ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801063f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063f6:	c9                   	leave  
801063f7:	c3                   	ret    
801063f8:	90                   	nop
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80106400:	83 ec 0c             	sub    $0xc,%esp
80106403:	68 20 8d 11 80       	push   $0x80118d20
80106408:	e8 13 e8 ff ff       	call   80104c20 <release>
  return 0;
8010640d:	83 c4 10             	add    $0x10,%esp
80106410:	31 c0                	xor    %eax,%eax
}
80106412:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106415:	c9                   	leave  
80106416:	c3                   	ret    
    return -1;
80106417:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010641c:	eb f4                	jmp    80106412 <sys_sleep+0xa2>
8010641e:	66 90                	xchg   %ax,%ax

80106420 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	53                   	push   %ebx
80106424:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106427:	68 20 8d 11 80       	push   $0x80118d20
8010642c:	e8 2f e6 ff ff       	call   80104a60 <acquire>
  xticks = ticks;
80106431:	8b 1d 60 95 11 80    	mov    0x80119560,%ebx
  release(&tickslock);
80106437:	c7 04 24 20 8d 11 80 	movl   $0x80118d20,(%esp)
8010643e:	e8 dd e7 ff ff       	call   80104c20 <release>
  return xticks;
}
80106443:	89 d8                	mov    %ebx,%eax
80106445:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106448:	c9                   	leave  
80106449:	c3                   	ret    
8010644a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106450 <sys_getcpuid>:

//ljn
int sys_getcpuid()
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
return getcpuid ();
}
80106453:	5d                   	pop    %ebp
return getcpuid ();
80106454:	e9 f7 d7 ff ff       	jmp    80103c50 <getcpuid>
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106460 <sys_changepri>:
int sys_changepri (void)
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	83 ec 20             	sub    $0x20,%esp
  int pid, pr;
  if ( argint(0, &pid) < 0 )
80106466:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106469:	50                   	push   %eax
8010646a:	6a 00                	push   $0x0
8010646c:	e8 6f ed ff ff       	call   801051e0 <argint>
80106471:	83 c4 10             	add    $0x10,%esp
80106474:	85 c0                	test   %eax,%eax
80106476:	78 28                	js     801064a0 <sys_changepri+0x40>
        return -1;
  if ( argint(1, &pr) < 0 )
80106478:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010647b:	83 ec 08             	sub    $0x8,%esp
8010647e:	50                   	push   %eax
8010647f:	6a 01                	push   $0x1
80106481:	e8 5a ed ff ff       	call   801051e0 <argint>
80106486:	83 c4 10             	add    $0x10,%esp
80106489:	85 c0                	test   %eax,%eax
8010648b:	78 13                	js     801064a0 <sys_changepri+0x40>
        return -1;
  return changepri ( pid, pr );
8010648d:	83 ec 08             	sub    $0x8,%esp
80106490:	ff 75 f4             	pushl  -0xc(%ebp)
80106493:	ff 75 f0             	pushl  -0x10(%ebp)
80106496:	e8 85 e1 ff ff       	call   80104620 <changepri>
8010649b:	83 c4 10             	add    $0x10,%esp
}
8010649e:	c9                   	leave  
8010649f:	c3                   	ret    
        return -1;
801064a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064a5:	c9                   	leave  
801064a6:	c3                   	ret    
801064a7:	89 f6                	mov    %esi,%esi
801064a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064b0 <sys_sh_var_read>:
int sys_sh_var_read(){
801064b0:	55                   	push   %ebp
  return sh_var_for_sem_demo;//读取全局变量也就是临界资源
}
801064b1:	a1 fc 16 11 80       	mov    0x801116fc,%eax
int sys_sh_var_read(){
801064b6:	89 e5                	mov    %esp,%ebp
}
801064b8:	5d                   	pop    %ebp
801064b9:	c3                   	ret    
801064ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801064c0 <sys_sh_var_write>:
int sys_sh_var_write(){
801064c0:	55                   	push   %ebp
801064c1:	89 e5                	mov    %esp,%ebp
801064c3:	83 ec 20             	sub    $0x20,%esp
  int n;//参数
  if(argint(0,&n) < 0)//如果参数小于零就返回-1 error
801064c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064c9:	50                   	push   %eax
801064ca:	6a 00                	push   $0x0
801064cc:	e8 0f ed ff ff       	call   801051e0 <argint>
801064d1:	83 c4 10             	add    $0x10,%esp
801064d4:	85 c0                	test   %eax,%eax
801064d6:	78 10                	js     801064e8 <sys_sh_var_write+0x28>
    return -1;
  sh_var_for_sem_demo = n;//设置临界资源为参数n
801064d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064db:	a3 fc 16 11 80       	mov    %eax,0x801116fc
  return sh_var_for_sem_demo;//返回参数数值
}
801064e0:	c9                   	leave  
801064e1:	c3                   	ret    
801064e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801064e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064ed:	c9                   	leave  
801064ee:	c3                   	ret    
801064ef:	90                   	nop

801064f0 <sys_myMalloc>:

int sys_myMalloc(){
801064f0:	55                   	push   %ebp
801064f1:	89 e5                	mov    %esp,%ebp
801064f3:	83 ec 20             	sub    $0x20,%esp
  int size;
  if(argint(0,&size)<0) return 0;//接受传进来的size参数
801064f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064f9:	50                   	push   %eax
801064fa:	6a 00                	push   $0x0
801064fc:	e8 df ec ff ff       	call   801051e0 <argint>
80106501:	83 c4 10             	add    $0x10,%esp
80106504:	31 d2                	xor    %edx,%edx
80106506:	85 c0                	test   %eax,%eax
80106508:	78 10                	js     8010651a <sys_myMalloc+0x2a>
  void* res=myMalloc(size);//分配slab
8010650a:	83 ec 0c             	sub    $0xc,%esp
8010650d:	ff 75 f4             	pushl  -0xc(%ebp)
80106510:	e8 ab e1 ff ff       	call   801046c0 <myMalloc>
  return (int)res;//返回操作结果
80106515:	83 c4 10             	add    $0x10,%esp
  void* res=myMalloc(size);//分配slab
80106518:	89 c2                	mov    %eax,%edx
}
8010651a:	89 d0                	mov    %edx,%eax
8010651c:	c9                   	leave  
8010651d:	c3                   	ret    
8010651e:	66 90                	xchg   %ax,%ax

80106520 <sys_myFree>:
int sys_myFree(){
80106520:	55                   	push   %ebp
80106521:	89 e5                	mov    %esp,%ebp
80106523:	83 ec 20             	sub    $0x20,%esp
  int va;
  if(argint(0,&va)<0) return 0;//接受传进来的虚拟地址参数
80106526:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106529:	50                   	push   %eax
8010652a:	6a 00                	push   $0x0
8010652c:	e8 af ec ff ff       	call   801051e0 <argint>
80106531:	83 c4 10             	add    $0x10,%esp
80106534:	31 d2                	xor    %edx,%edx
80106536:	85 c0                	test   %eax,%eax
80106538:	78 10                	js     8010654a <sys_myFree+0x2a>
  int res=myFree((void*)va);//释放slab
8010653a:	83 ec 0c             	sub    $0xc,%esp
8010653d:	ff 75 f4             	pushl  -0xc(%ebp)
80106540:	e8 bb e1 ff ff       	call   80104700 <myFree>
  return res;//返回操作结果
80106545:	83 c4 10             	add    $0x10,%esp
  int res=myFree((void*)va);//释放slab
80106548:	89 c2                	mov    %eax,%edx
}
8010654a:	89 d0                	mov    %edx,%eax
8010654c:	c9                   	leave  
8010654d:	c3                   	ret    
8010654e:	66 90                	xchg   %ax,%ax

80106550 <sys_myFork>:

int sys_myFork(void){
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
  return myFork();
}
80106553:	5d                   	pop    %ebp
  return myFork();
80106554:	e9 c7 e1 ff ff       	jmp    80104720 <myFork>
80106559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106560 <sys_clone>:

int sys_clone(void){
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	83 ec 1c             	sub    $0x1c,%esp
  char* fnc;
  char* arg;
  char* stack;
  argptr(0,&fnc,0);
80106566:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106569:	6a 00                	push   $0x0
8010656b:	50                   	push   %eax
8010656c:	6a 00                	push   $0x0
8010656e:	e8 ad ec ff ff       	call   80105220 <argptr>
  argptr(1,&arg,0);
80106573:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106576:	83 c4 0c             	add    $0xc,%esp
80106579:	6a 00                	push   $0x0
8010657b:	50                   	push   %eax
8010657c:	6a 01                	push   $0x1
8010657e:	e8 9d ec ff ff       	call   80105220 <argptr>
  argptr(2,&stack,0);//读取三个参数
80106583:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106586:	83 c4 0c             	add    $0xc,%esp
80106589:	6a 00                	push   $0x0
8010658b:	50                   	push   %eax
8010658c:	6a 02                	push   $0x2
8010658e:	e8 8d ec ff ff       	call   80105220 <argptr>
  return clone((void (*)(void *))fnc,(void*)arg,(void*)stack);
80106593:	83 c4 0c             	add    $0xc,%esp
80106596:	ff 75 f4             	pushl  -0xc(%ebp)
80106599:	ff 75 f0             	pushl  -0x10(%ebp)
8010659c:	ff 75 ec             	pushl  -0x14(%ebp)
8010659f:	e8 7c e2 ff ff       	call   80104820 <clone>
}
801065a4:	c9                   	leave  
801065a5:	c3                   	ret    
801065a6:	8d 76 00             	lea    0x0(%esi),%esi
801065a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065b0 <sys_join>:

int sys_join(void){
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	83 ec 1c             	sub    $0x1c,%esp
 char* stack;
 argptr(0,& stack,0);
801065b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065b9:	6a 00                	push   $0x0
801065bb:	50                   	push   %eax
801065bc:	6a 00                	push   $0x0
801065be:	e8 5d ec ff ff       	call   80105220 <argptr>
 return join((void**)stack);
801065c3:	58                   	pop    %eax
801065c4:	ff 75 f4             	pushl  -0xc(%ebp)
801065c7:	e8 74 e3 ff ff       	call   80104940 <join>
801065cc:	c9                   	leave  
801065cd:	c3                   	ret    
801065ce:	66 90                	xchg   %ax,%ax

801065d0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801065d0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065d1:	b8 34 00 00 00       	mov    $0x34,%eax
801065d6:	ba 43 00 00 00       	mov    $0x43,%edx
801065db:	89 e5                	mov    %esp,%ebp
801065dd:	83 ec 14             	sub    $0x14,%esp
801065e0:	ee                   	out    %al,(%dx)
801065e1:	ba 40 00 00 00       	mov    $0x40,%edx
801065e6:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
801065eb:	ee                   	out    %al,(%dx)
801065ec:	b8 2e 00 00 00       	mov    $0x2e,%eax
801065f1:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
801065f2:	6a 00                	push   $0x0
801065f4:	e8 87 d0 ff ff       	call   80103680 <picenable>
}
801065f9:	83 c4 10             	add    $0x10,%esp
801065fc:	c9                   	leave  
801065fd:	c3                   	ret    

801065fe <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801065fe:	1e                   	push   %ds
  pushl %es
801065ff:	06                   	push   %es
  pushl %fs
80106600:	0f a0                	push   %fs
  pushl %gs
80106602:	0f a8                	push   %gs
  pushal
80106604:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106605:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106609:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010660b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010660d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106611:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106613:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106615:	54                   	push   %esp
  call trap
80106616:	e8 c5 00 00 00       	call   801066e0 <trap>
  addl $4, %esp
8010661b:	83 c4 04             	add    $0x4,%esp

8010661e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010661e:	61                   	popa   
  popl %gs
8010661f:	0f a9                	pop    %gs
  popl %fs
80106621:	0f a1                	pop    %fs
  popl %es
80106623:	07                   	pop    %es
  popl %ds
80106624:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106625:	83 c4 08             	add    $0x8,%esp
  iret
80106628:	cf                   	iret   
80106629:	66 90                	xchg   %ax,%ax
8010662b:	66 90                	xchg   %ax,%ax
8010662d:	66 90                	xchg   %ax,%ax
8010662f:	90                   	nop

80106630 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106630:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106631:	31 c0                	xor    %eax,%eax
{
80106633:	89 e5                	mov    %esp,%ebp
80106635:	83 ec 08             	sub    $0x8,%esp
80106638:	90                   	nop
80106639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106640:	8b 14 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%edx
80106647:	c7 04 c5 62 8d 11 80 	movl   $0x8e000008,-0x7fee729e(,%eax,8)
8010664e:	08 00 00 8e 
80106652:	66 89 14 c5 60 8d 11 	mov    %dx,-0x7fee72a0(,%eax,8)
80106659:	80 
8010665a:	c1 ea 10             	shr    $0x10,%edx
8010665d:	66 89 14 c5 66 8d 11 	mov    %dx,-0x7fee729a(,%eax,8)
80106664:	80 
  for(i = 0; i < 256; i++)
80106665:	83 c0 01             	add    $0x1,%eax
80106668:	3d 00 01 00 00       	cmp    $0x100,%eax
8010666d:	75 d1                	jne    80106640 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010666f:	a1 0c c1 10 80       	mov    0x8010c10c,%eax

  initlock(&tickslock, "time");
80106674:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106677:	c7 05 62 8f 11 80 08 	movl   $0xef000008,0x80118f62
8010667e:	00 00 ef 
  initlock(&tickslock, "time");
80106681:	68 69 8c 10 80       	push   $0x80108c69
80106686:	68 20 8d 11 80       	push   $0x80118d20
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010668b:	66 a3 60 8f 11 80    	mov    %ax,0x80118f60
80106691:	c1 e8 10             	shr    $0x10,%eax
80106694:	66 a3 66 8f 11 80    	mov    %ax,0x80118f66
  initlock(&tickslock, "time");
8010669a:	e8 a1 e3 ff ff       	call   80104a40 <initlock>
}
8010669f:	83 c4 10             	add    $0x10,%esp
801066a2:	c9                   	leave  
801066a3:	c3                   	ret    
801066a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801066aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801066b0 <idtinit>:

void
idtinit(void)
{
801066b0:	55                   	push   %ebp
  pd[0] = size-1;
801066b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801066b6:	89 e5                	mov    %esp,%ebp
801066b8:	83 ec 10             	sub    $0x10,%esp
801066bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801066bf:	b8 60 8d 11 80       	mov    $0x80118d60,%eax
801066c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801066c8:	c1 e8 10             	shr    $0x10,%eax
801066cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801066cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801066d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801066d5:	c9                   	leave  
801066d6:	c3                   	ret    
801066d7:	89 f6                	mov    %esi,%esi
801066d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	57                   	push   %edi
801066e4:	56                   	push   %esi
801066e5:	53                   	push   %ebx
801066e6:	83 ec 0c             	sub    $0xc,%esp
801066e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801066ec:	8b 43 30             	mov    0x30(%ebx),%eax
801066ef:	83 f8 40             	cmp    $0x40,%eax
801066f2:	74 6c                	je     80106760 <trap+0x80>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801066f4:	83 e8 0e             	sub    $0xe,%eax
801066f7:	83 f8 31             	cmp    $0x31,%eax
801066fa:	0f 87 98 00 00 00    	ja     80106798 <trap+0xb8>
80106700:	ff 24 85 10 8d 10 80 	jmp    *-0x7fef72f0(,%eax,4)
80106707:	89 f6                	mov    %esi,%esi
80106709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80106710:	e8 8b c3 ff ff       	call   80102aa0 <cpunum>
80106715:	85 c0                	test   %eax,%eax
80106717:	0f 84 e3 01 00 00    	je     80106900 <trap+0x220>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
8010671d:	e8 2e c4 ff ff       	call   80102b50 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106722:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106728:	85 c0                	test   %eax,%eax
8010672a:	74 29                	je     80106755 <trap+0x75>
8010672c:	8b 50 24             	mov    0x24(%eax),%edx
8010672f:	85 d2                	test   %edx,%edx
80106731:	0f 85 b6 00 00 00    	jne    801067ed <trap+0x10d>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106737:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010673b:	0f 84 67 01 00 00    	je     801068a8 <trap+0x1c8>
      yield(); 
    }
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106741:	8b 40 24             	mov    0x24(%eax),%eax
80106744:	85 c0                	test   %eax,%eax
80106746:	74 0d                	je     80106755 <trap+0x75>
80106748:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010674c:	83 e0 03             	and    $0x3,%eax
8010674f:	66 83 f8 03          	cmp    $0x3,%ax
80106753:	74 31                	je     80106786 <trap+0xa6>
    exit();
}
80106755:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106758:	5b                   	pop    %ebx
80106759:	5e                   	pop    %esi
8010675a:	5f                   	pop    %edi
8010675b:	5d                   	pop    %ebp
8010675c:	c3                   	ret    
8010675d:	8d 76 00             	lea    0x0(%esi),%esi
    if(proc->killed)
80106760:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106766:	8b 70 24             	mov    0x24(%eax),%esi
80106769:	85 f6                	test   %esi,%esi
8010676b:	0f 85 57 01 00 00    	jne    801068c8 <trap+0x1e8>
    proc->tf = tf;
80106771:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106774:	e8 77 eb ff ff       	call   801052f0 <syscall>
    if(proc->killed)
80106779:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010677f:	8b 58 24             	mov    0x24(%eax),%ebx
80106782:	85 db                	test   %ebx,%ebx
80106784:	74 cf                	je     80106755 <trap+0x75>
}
80106786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106789:	5b                   	pop    %ebx
8010678a:	5e                   	pop    %esi
8010678b:	5f                   	pop    %edi
8010678c:	5d                   	pop    %ebp
      exit();
8010678d:	e9 0e d9 ff ff       	jmp    801040a0 <exit>
80106792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(proc == 0 || (tf->cs&3) == 0){
80106798:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
8010679f:	8b 73 38             	mov    0x38(%ebx),%esi
801067a2:	85 c9                	test   %ecx,%ecx
801067a4:	0f 84 8a 01 00 00    	je     80106934 <trap+0x254>
801067aa:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801067ae:	0f 84 80 01 00 00    	je     80106934 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801067b4:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801067b7:	e8 e4 c2 ff ff       	call   80102aa0 <cpunum>
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
801067bc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801067c3:	57                   	push   %edi
801067c4:	56                   	push   %esi
801067c5:	50                   	push   %eax
801067c6:	ff 73 34             	pushl  0x34(%ebx)
801067c9:	ff 73 30             	pushl  0x30(%ebx)
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
801067cc:	8d 42 6c             	lea    0x6c(%edx),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801067cf:	50                   	push   %eax
801067d0:	ff 72 10             	pushl  0x10(%edx)
801067d3:	68 cc 8c 10 80       	push   $0x80108ccc
801067d8:	e8 73 9f ff ff       	call   80100750 <cprintf>
    proc->killed = 1;
801067dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067e3:	83 c4 20             	add    $0x20,%esp
801067e6:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801067ed:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
801067f1:	83 e2 03             	and    $0x3,%edx
801067f4:	66 83 fa 03          	cmp    $0x3,%dx
801067f8:	0f 85 39 ff ff ff    	jne    80106737 <trap+0x57>
    exit();
801067fe:	e8 9d d8 ff ff       	call   801040a0 <exit>
80106803:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106809:	85 c0                	test   %eax,%eax
8010680b:	0f 85 26 ff ff ff    	jne    80106737 <trap+0x57>
80106811:	e9 3f ff ff ff       	jmp    80106755 <trap+0x75>
80106816:	8d 76 00             	lea    0x0(%esi),%esi
80106819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106820:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106824:	8b 7b 38             	mov    0x38(%ebx),%edi
80106827:	e8 74 c2 ff ff       	call   80102aa0 <cpunum>
8010682c:	57                   	push   %edi
8010682d:	56                   	push   %esi
8010682e:	50                   	push   %eax
8010682f:	68 74 8c 10 80       	push   $0x80108c74
80106834:	e8 17 9f ff ff       	call   80100750 <cprintf>
    lapiceoi();
80106839:	e8 12 c3 ff ff       	call   80102b50 <lapiceoi>
    break;
8010683e:	83 c4 10             	add    $0x10,%esp
80106841:	e9 dc fe ff ff       	jmp    80106722 <trap+0x42>
80106846:	8d 76 00             	lea    0x0(%esi),%esi
80106849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    kbdintr();
80106850:	e8 2b c1 ff ff       	call   80102980 <kbdintr>
    lapiceoi();
80106855:	e8 f6 c2 ff ff       	call   80102b50 <lapiceoi>
    break;
8010685a:	e9 c3 fe ff ff       	jmp    80106722 <trap+0x42>
8010685f:	90                   	nop
    uartintr();
80106860:	e8 6b 02 00 00       	call   80106ad0 <uartintr>
    lapiceoi();
80106865:	e8 e6 c2 ff ff       	call   80102b50 <lapiceoi>
    break;
8010686a:	e9 b3 fe ff ff       	jmp    80106722 <trap+0x42>
8010686f:	90                   	nop
    pagefault(proc->pgdir,(char*)rcr2(),proc->swap_start,proc->sz);
80106870:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106876:	0f 20 d2             	mov    %cr2,%edx
80106879:	ff 30                	pushl  (%eax)
8010687b:	ff b0 8c 00 00 00    	pushl  0x8c(%eax)
80106881:	52                   	push   %edx
80106882:	ff 70 04             	pushl  0x4(%eax)
80106885:	e8 96 1a 00 00       	call   80108320 <pagefault>
    break;
8010688a:	83 c4 10             	add    $0x10,%esp
8010688d:	e9 90 fe ff ff       	jmp    80106722 <trap+0x42>
80106892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ideintr();
80106898:	e8 43 ba ff ff       	call   801022e0 <ideintr>
8010689d:	e9 7b fe ff ff       	jmp    8010671d <trap+0x3d>
801068a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
801068a8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801068ac:	0f 85 8f fe ff ff    	jne    80106741 <trap+0x61>
    if(!proc->tickk){
801068b2:	8b 50 7c             	mov    0x7c(%eax),%edx
801068b5:	83 ea 01             	sub    $0x1,%edx
801068b8:	74 26                	je     801068e0 <trap+0x200>
    proc->tickk--;
801068ba:	89 50 7c             	mov    %edx,0x7c(%eax)
801068bd:	e9 7f fe ff ff       	jmp    80106741 <trap+0x61>
801068c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801068c8:	e8 d3 d7 ff ff       	call   801040a0 <exit>
801068cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068d3:	e9 99 fe ff ff       	jmp    80106771 <trap+0x91>
801068d8:	90                   	nop
801068d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      proc->tickk=8;
801068e0:	c7 40 7c 08 00 00 00 	movl   $0x8,0x7c(%eax)
      yield(); 
801068e7:	e8 84 d9 ff ff       	call   80104270 <yield>
801068ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801068f2:	85 c0                	test   %eax,%eax
801068f4:	0f 85 47 fe ff ff    	jne    80106741 <trap+0x61>
801068fa:	e9 56 fe ff ff       	jmp    80106755 <trap+0x75>
801068ff:	90                   	nop
      acquire(&tickslock);
80106900:	83 ec 0c             	sub    $0xc,%esp
80106903:	68 20 8d 11 80       	push   $0x80118d20
80106908:	e8 53 e1 ff ff       	call   80104a60 <acquire>
      wakeup(&ticks);
8010690d:	c7 04 24 60 95 11 80 	movl   $0x80119560,(%esp)
      ticks++;
80106914:	83 05 60 95 11 80 01 	addl   $0x1,0x80119560
      wakeup(&ticks);
8010691b:	e8 40 db ff ff       	call   80104460 <wakeup>
      release(&tickslock);
80106920:	c7 04 24 20 8d 11 80 	movl   $0x80118d20,(%esp)
80106927:	e8 f4 e2 ff ff       	call   80104c20 <release>
8010692c:	83 c4 10             	add    $0x10,%esp
8010692f:	e9 e9 fd ff ff       	jmp    8010671d <trap+0x3d>
80106934:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106937:	e8 64 c1 ff ff       	call   80102aa0 <cpunum>
8010693c:	83 ec 0c             	sub    $0xc,%esp
8010693f:	57                   	push   %edi
80106940:	56                   	push   %esi
80106941:	50                   	push   %eax
80106942:	ff 73 30             	pushl  0x30(%ebx)
80106945:	68 98 8c 10 80       	push   $0x80108c98
8010694a:	e8 01 9e ff ff       	call   80100750 <cprintf>
      panic("trap");
8010694f:	83 c4 14             	add    $0x14,%esp
80106952:	68 6e 8c 10 80       	push   $0x80108c6e
80106957:	e8 24 9b ff ff       	call   80100480 <panic>
8010695c:	66 90                	xchg   %ax,%ax
8010695e:	66 90                	xchg   %ax,%ax

80106960 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106960:	a1 c4 c5 10 80       	mov    0x8010c5c4,%eax
{
80106965:	55                   	push   %ebp
80106966:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106968:	85 c0                	test   %eax,%eax
8010696a:	74 1c                	je     80106988 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010696c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106971:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106972:	a8 01                	test   $0x1,%al
80106974:	74 12                	je     80106988 <uartgetc+0x28>
80106976:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010697b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010697c:	0f b6 c0             	movzbl %al,%eax
}
8010697f:	5d                   	pop    %ebp
80106980:	c3                   	ret    
80106981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010698d:	5d                   	pop    %ebp
8010698e:	c3                   	ret    
8010698f:	90                   	nop

80106990 <uartputc.part.0>:
uartputc(int c)
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	57                   	push   %edi
80106994:	56                   	push   %esi
80106995:	53                   	push   %ebx
80106996:	89 c7                	mov    %eax,%edi
80106998:	bb 80 00 00 00       	mov    $0x80,%ebx
8010699d:	be fd 03 00 00       	mov    $0x3fd,%esi
801069a2:	83 ec 0c             	sub    $0xc,%esp
801069a5:	eb 1b                	jmp    801069c2 <uartputc.part.0+0x32>
801069a7:	89 f6                	mov    %esi,%esi
801069a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801069b0:	83 ec 0c             	sub    $0xc,%esp
801069b3:	6a 0a                	push   $0xa
801069b5:	e8 b6 c1 ff ff       	call   80102b70 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801069ba:	83 c4 10             	add    $0x10,%esp
801069bd:	83 eb 01             	sub    $0x1,%ebx
801069c0:	74 07                	je     801069c9 <uartputc.part.0+0x39>
801069c2:	89 f2                	mov    %esi,%edx
801069c4:	ec                   	in     (%dx),%al
801069c5:	a8 20                	test   $0x20,%al
801069c7:	74 e7                	je     801069b0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069c9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069ce:	89 f8                	mov    %edi,%eax
801069d0:	ee                   	out    %al,(%dx)
}
801069d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069d4:	5b                   	pop    %ebx
801069d5:	5e                   	pop    %esi
801069d6:	5f                   	pop    %edi
801069d7:	5d                   	pop    %ebp
801069d8:	c3                   	ret    
801069d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069e0 <uartinit>:
{
801069e0:	55                   	push   %ebp
801069e1:	31 c9                	xor    %ecx,%ecx
801069e3:	89 c8                	mov    %ecx,%eax
801069e5:	89 e5                	mov    %esp,%ebp
801069e7:	57                   	push   %edi
801069e8:	56                   	push   %esi
801069e9:	53                   	push   %ebx
801069ea:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801069ef:	89 da                	mov    %ebx,%edx
801069f1:	83 ec 0c             	sub    $0xc,%esp
801069f4:	ee                   	out    %al,(%dx)
801069f5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801069fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801069ff:	89 fa                	mov    %edi,%edx
80106a01:	ee                   	out    %al,(%dx)
80106a02:	b8 0c 00 00 00       	mov    $0xc,%eax
80106a07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a0c:	ee                   	out    %al,(%dx)
80106a0d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106a12:	89 c8                	mov    %ecx,%eax
80106a14:	89 f2                	mov    %esi,%edx
80106a16:	ee                   	out    %al,(%dx)
80106a17:	b8 03 00 00 00       	mov    $0x3,%eax
80106a1c:	89 fa                	mov    %edi,%edx
80106a1e:	ee                   	out    %al,(%dx)
80106a1f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106a24:	89 c8                	mov    %ecx,%eax
80106a26:	ee                   	out    %al,(%dx)
80106a27:	b8 01 00 00 00       	mov    $0x1,%eax
80106a2c:	89 f2                	mov    %esi,%edx
80106a2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a2f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106a34:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106a35:	3c ff                	cmp    $0xff,%al
80106a37:	74 5a                	je     80106a93 <uartinit+0xb3>
  uart = 1;
80106a39:	c7 05 c4 c5 10 80 01 	movl   $0x1,0x8010c5c4
80106a40:	00 00 00 
80106a43:	89 da                	mov    %ebx,%edx
80106a45:	ec                   	in     (%dx),%al
80106a46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a4b:	ec                   	in     (%dx),%al
  picenable(IRQ_COM1);
80106a4c:	83 ec 0c             	sub    $0xc,%esp
80106a4f:	6a 04                	push   $0x4
80106a51:	e8 2a cc ff ff       	call   80103680 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106a56:	59                   	pop    %ecx
80106a57:	5b                   	pop    %ebx
80106a58:	6a 00                	push   $0x0
80106a5a:	6a 04                	push   $0x4
  for(p="xv6...\n"; *p; p++)
80106a5c:	bb d8 8d 10 80       	mov    $0x80108dd8,%ebx
  ioapicenable(IRQ_COM1, 0);
80106a61:	e8 da ba ff ff       	call   80102540 <ioapicenable>
80106a66:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106a69:	b8 78 00 00 00       	mov    $0x78,%eax
80106a6e:	eb 0a                	jmp    80106a7a <uartinit+0x9a>
80106a70:	83 c3 01             	add    $0x1,%ebx
80106a73:	0f be 03             	movsbl (%ebx),%eax
80106a76:	84 c0                	test   %al,%al
80106a78:	74 19                	je     80106a93 <uartinit+0xb3>
  if(!uart)
80106a7a:	8b 15 c4 c5 10 80    	mov    0x8010c5c4,%edx
80106a80:	85 d2                	test   %edx,%edx
80106a82:	74 ec                	je     80106a70 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106a84:	83 c3 01             	add    $0x1,%ebx
80106a87:	e8 04 ff ff ff       	call   80106990 <uartputc.part.0>
80106a8c:	0f be 03             	movsbl (%ebx),%eax
80106a8f:	84 c0                	test   %al,%al
80106a91:	75 e7                	jne    80106a7a <uartinit+0x9a>
}
80106a93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a96:	5b                   	pop    %ebx
80106a97:	5e                   	pop    %esi
80106a98:	5f                   	pop    %edi
80106a99:	5d                   	pop    %ebp
80106a9a:	c3                   	ret    
80106a9b:	90                   	nop
80106a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <uartputc>:
  if(!uart)
80106aa0:	8b 15 c4 c5 10 80    	mov    0x8010c5c4,%edx
{
80106aa6:	55                   	push   %ebp
80106aa7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106aa9:	85 d2                	test   %edx,%edx
{
80106aab:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106aae:	74 10                	je     80106ac0 <uartputc+0x20>
}
80106ab0:	5d                   	pop    %ebp
80106ab1:	e9 da fe ff ff       	jmp    80106990 <uartputc.part.0>
80106ab6:	8d 76 00             	lea    0x0(%esi),%esi
80106ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106ac0:	5d                   	pop    %ebp
80106ac1:	c3                   	ret    
80106ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ad0 <uartintr>:

void
uartintr(void)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106ad6:	68 60 69 10 80       	push   $0x80106960
80106adb:	e8 20 9e ff ff       	call   80100900 <consoleintr>
}
80106ae0:	83 c4 10             	add    $0x10,%esp
80106ae3:	c9                   	leave  
80106ae4:	c3                   	ret    

80106ae5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106ae5:	6a 00                	push   $0x0
  pushl $0
80106ae7:	6a 00                	push   $0x0
  jmp alltraps
80106ae9:	e9 10 fb ff ff       	jmp    801065fe <alltraps>

80106aee <vector1>:
.globl vector1
vector1:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $1
80106af0:	6a 01                	push   $0x1
  jmp alltraps
80106af2:	e9 07 fb ff ff       	jmp    801065fe <alltraps>

80106af7 <vector2>:
.globl vector2
vector2:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $2
80106af9:	6a 02                	push   $0x2
  jmp alltraps
80106afb:	e9 fe fa ff ff       	jmp    801065fe <alltraps>

80106b00 <vector3>:
.globl vector3
vector3:
  pushl $0
80106b00:	6a 00                	push   $0x0
  pushl $3
80106b02:	6a 03                	push   $0x3
  jmp alltraps
80106b04:	e9 f5 fa ff ff       	jmp    801065fe <alltraps>

80106b09 <vector4>:
.globl vector4
vector4:
  pushl $0
80106b09:	6a 00                	push   $0x0
  pushl $4
80106b0b:	6a 04                	push   $0x4
  jmp alltraps
80106b0d:	e9 ec fa ff ff       	jmp    801065fe <alltraps>

80106b12 <vector5>:
.globl vector5
vector5:
  pushl $0
80106b12:	6a 00                	push   $0x0
  pushl $5
80106b14:	6a 05                	push   $0x5
  jmp alltraps
80106b16:	e9 e3 fa ff ff       	jmp    801065fe <alltraps>

80106b1b <vector6>:
.globl vector6
vector6:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $6
80106b1d:	6a 06                	push   $0x6
  jmp alltraps
80106b1f:	e9 da fa ff ff       	jmp    801065fe <alltraps>

80106b24 <vector7>:
.globl vector7
vector7:
  pushl $0
80106b24:	6a 00                	push   $0x0
  pushl $7
80106b26:	6a 07                	push   $0x7
  jmp alltraps
80106b28:	e9 d1 fa ff ff       	jmp    801065fe <alltraps>

80106b2d <vector8>:
.globl vector8
vector8:
  pushl $8
80106b2d:	6a 08                	push   $0x8
  jmp alltraps
80106b2f:	e9 ca fa ff ff       	jmp    801065fe <alltraps>

80106b34 <vector9>:
.globl vector9
vector9:
  pushl $0
80106b34:	6a 00                	push   $0x0
  pushl $9
80106b36:	6a 09                	push   $0x9
  jmp alltraps
80106b38:	e9 c1 fa ff ff       	jmp    801065fe <alltraps>

80106b3d <vector10>:
.globl vector10
vector10:
  pushl $10
80106b3d:	6a 0a                	push   $0xa
  jmp alltraps
80106b3f:	e9 ba fa ff ff       	jmp    801065fe <alltraps>

80106b44 <vector11>:
.globl vector11
vector11:
  pushl $11
80106b44:	6a 0b                	push   $0xb
  jmp alltraps
80106b46:	e9 b3 fa ff ff       	jmp    801065fe <alltraps>

80106b4b <vector12>:
.globl vector12
vector12:
  pushl $12
80106b4b:	6a 0c                	push   $0xc
  jmp alltraps
80106b4d:	e9 ac fa ff ff       	jmp    801065fe <alltraps>

80106b52 <vector13>:
.globl vector13
vector13:
  pushl $13
80106b52:	6a 0d                	push   $0xd
  jmp alltraps
80106b54:	e9 a5 fa ff ff       	jmp    801065fe <alltraps>

80106b59 <vector14>:
.globl vector14
vector14:
  pushl $14
80106b59:	6a 0e                	push   $0xe
  jmp alltraps
80106b5b:	e9 9e fa ff ff       	jmp    801065fe <alltraps>

80106b60 <vector15>:
.globl vector15
vector15:
  pushl $0
80106b60:	6a 00                	push   $0x0
  pushl $15
80106b62:	6a 0f                	push   $0xf
  jmp alltraps
80106b64:	e9 95 fa ff ff       	jmp    801065fe <alltraps>

80106b69 <vector16>:
.globl vector16
vector16:
  pushl $0
80106b69:	6a 00                	push   $0x0
  pushl $16
80106b6b:	6a 10                	push   $0x10
  jmp alltraps
80106b6d:	e9 8c fa ff ff       	jmp    801065fe <alltraps>

80106b72 <vector17>:
.globl vector17
vector17:
  pushl $17
80106b72:	6a 11                	push   $0x11
  jmp alltraps
80106b74:	e9 85 fa ff ff       	jmp    801065fe <alltraps>

80106b79 <vector18>:
.globl vector18
vector18:
  pushl $0
80106b79:	6a 00                	push   $0x0
  pushl $18
80106b7b:	6a 12                	push   $0x12
  jmp alltraps
80106b7d:	e9 7c fa ff ff       	jmp    801065fe <alltraps>

80106b82 <vector19>:
.globl vector19
vector19:
  pushl $0
80106b82:	6a 00                	push   $0x0
  pushl $19
80106b84:	6a 13                	push   $0x13
  jmp alltraps
80106b86:	e9 73 fa ff ff       	jmp    801065fe <alltraps>

80106b8b <vector20>:
.globl vector20
vector20:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $20
80106b8d:	6a 14                	push   $0x14
  jmp alltraps
80106b8f:	e9 6a fa ff ff       	jmp    801065fe <alltraps>

80106b94 <vector21>:
.globl vector21
vector21:
  pushl $0
80106b94:	6a 00                	push   $0x0
  pushl $21
80106b96:	6a 15                	push   $0x15
  jmp alltraps
80106b98:	e9 61 fa ff ff       	jmp    801065fe <alltraps>

80106b9d <vector22>:
.globl vector22
vector22:
  pushl $0
80106b9d:	6a 00                	push   $0x0
  pushl $22
80106b9f:	6a 16                	push   $0x16
  jmp alltraps
80106ba1:	e9 58 fa ff ff       	jmp    801065fe <alltraps>

80106ba6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106ba6:	6a 00                	push   $0x0
  pushl $23
80106ba8:	6a 17                	push   $0x17
  jmp alltraps
80106baa:	e9 4f fa ff ff       	jmp    801065fe <alltraps>

80106baf <vector24>:
.globl vector24
vector24:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $24
80106bb1:	6a 18                	push   $0x18
  jmp alltraps
80106bb3:	e9 46 fa ff ff       	jmp    801065fe <alltraps>

80106bb8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106bb8:	6a 00                	push   $0x0
  pushl $25
80106bba:	6a 19                	push   $0x19
  jmp alltraps
80106bbc:	e9 3d fa ff ff       	jmp    801065fe <alltraps>

80106bc1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106bc1:	6a 00                	push   $0x0
  pushl $26
80106bc3:	6a 1a                	push   $0x1a
  jmp alltraps
80106bc5:	e9 34 fa ff ff       	jmp    801065fe <alltraps>

80106bca <vector27>:
.globl vector27
vector27:
  pushl $0
80106bca:	6a 00                	push   $0x0
  pushl $27
80106bcc:	6a 1b                	push   $0x1b
  jmp alltraps
80106bce:	e9 2b fa ff ff       	jmp    801065fe <alltraps>

80106bd3 <vector28>:
.globl vector28
vector28:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $28
80106bd5:	6a 1c                	push   $0x1c
  jmp alltraps
80106bd7:	e9 22 fa ff ff       	jmp    801065fe <alltraps>

80106bdc <vector29>:
.globl vector29
vector29:
  pushl $0
80106bdc:	6a 00                	push   $0x0
  pushl $29
80106bde:	6a 1d                	push   $0x1d
  jmp alltraps
80106be0:	e9 19 fa ff ff       	jmp    801065fe <alltraps>

80106be5 <vector30>:
.globl vector30
vector30:
  pushl $0
80106be5:	6a 00                	push   $0x0
  pushl $30
80106be7:	6a 1e                	push   $0x1e
  jmp alltraps
80106be9:	e9 10 fa ff ff       	jmp    801065fe <alltraps>

80106bee <vector31>:
.globl vector31
vector31:
  pushl $0
80106bee:	6a 00                	push   $0x0
  pushl $31
80106bf0:	6a 1f                	push   $0x1f
  jmp alltraps
80106bf2:	e9 07 fa ff ff       	jmp    801065fe <alltraps>

80106bf7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $32
80106bf9:	6a 20                	push   $0x20
  jmp alltraps
80106bfb:	e9 fe f9 ff ff       	jmp    801065fe <alltraps>

80106c00 <vector33>:
.globl vector33
vector33:
  pushl $0
80106c00:	6a 00                	push   $0x0
  pushl $33
80106c02:	6a 21                	push   $0x21
  jmp alltraps
80106c04:	e9 f5 f9 ff ff       	jmp    801065fe <alltraps>

80106c09 <vector34>:
.globl vector34
vector34:
  pushl $0
80106c09:	6a 00                	push   $0x0
  pushl $34
80106c0b:	6a 22                	push   $0x22
  jmp alltraps
80106c0d:	e9 ec f9 ff ff       	jmp    801065fe <alltraps>

80106c12 <vector35>:
.globl vector35
vector35:
  pushl $0
80106c12:	6a 00                	push   $0x0
  pushl $35
80106c14:	6a 23                	push   $0x23
  jmp alltraps
80106c16:	e9 e3 f9 ff ff       	jmp    801065fe <alltraps>

80106c1b <vector36>:
.globl vector36
vector36:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $36
80106c1d:	6a 24                	push   $0x24
  jmp alltraps
80106c1f:	e9 da f9 ff ff       	jmp    801065fe <alltraps>

80106c24 <vector37>:
.globl vector37
vector37:
  pushl $0
80106c24:	6a 00                	push   $0x0
  pushl $37
80106c26:	6a 25                	push   $0x25
  jmp alltraps
80106c28:	e9 d1 f9 ff ff       	jmp    801065fe <alltraps>

80106c2d <vector38>:
.globl vector38
vector38:
  pushl $0
80106c2d:	6a 00                	push   $0x0
  pushl $38
80106c2f:	6a 26                	push   $0x26
  jmp alltraps
80106c31:	e9 c8 f9 ff ff       	jmp    801065fe <alltraps>

80106c36 <vector39>:
.globl vector39
vector39:
  pushl $0
80106c36:	6a 00                	push   $0x0
  pushl $39
80106c38:	6a 27                	push   $0x27
  jmp alltraps
80106c3a:	e9 bf f9 ff ff       	jmp    801065fe <alltraps>

80106c3f <vector40>:
.globl vector40
vector40:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $40
80106c41:	6a 28                	push   $0x28
  jmp alltraps
80106c43:	e9 b6 f9 ff ff       	jmp    801065fe <alltraps>

80106c48 <vector41>:
.globl vector41
vector41:
  pushl $0
80106c48:	6a 00                	push   $0x0
  pushl $41
80106c4a:	6a 29                	push   $0x29
  jmp alltraps
80106c4c:	e9 ad f9 ff ff       	jmp    801065fe <alltraps>

80106c51 <vector42>:
.globl vector42
vector42:
  pushl $0
80106c51:	6a 00                	push   $0x0
  pushl $42
80106c53:	6a 2a                	push   $0x2a
  jmp alltraps
80106c55:	e9 a4 f9 ff ff       	jmp    801065fe <alltraps>

80106c5a <vector43>:
.globl vector43
vector43:
  pushl $0
80106c5a:	6a 00                	push   $0x0
  pushl $43
80106c5c:	6a 2b                	push   $0x2b
  jmp alltraps
80106c5e:	e9 9b f9 ff ff       	jmp    801065fe <alltraps>

80106c63 <vector44>:
.globl vector44
vector44:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $44
80106c65:	6a 2c                	push   $0x2c
  jmp alltraps
80106c67:	e9 92 f9 ff ff       	jmp    801065fe <alltraps>

80106c6c <vector45>:
.globl vector45
vector45:
  pushl $0
80106c6c:	6a 00                	push   $0x0
  pushl $45
80106c6e:	6a 2d                	push   $0x2d
  jmp alltraps
80106c70:	e9 89 f9 ff ff       	jmp    801065fe <alltraps>

80106c75 <vector46>:
.globl vector46
vector46:
  pushl $0
80106c75:	6a 00                	push   $0x0
  pushl $46
80106c77:	6a 2e                	push   $0x2e
  jmp alltraps
80106c79:	e9 80 f9 ff ff       	jmp    801065fe <alltraps>

80106c7e <vector47>:
.globl vector47
vector47:
  pushl $0
80106c7e:	6a 00                	push   $0x0
  pushl $47
80106c80:	6a 2f                	push   $0x2f
  jmp alltraps
80106c82:	e9 77 f9 ff ff       	jmp    801065fe <alltraps>

80106c87 <vector48>:
.globl vector48
vector48:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $48
80106c89:	6a 30                	push   $0x30
  jmp alltraps
80106c8b:	e9 6e f9 ff ff       	jmp    801065fe <alltraps>

80106c90 <vector49>:
.globl vector49
vector49:
  pushl $0
80106c90:	6a 00                	push   $0x0
  pushl $49
80106c92:	6a 31                	push   $0x31
  jmp alltraps
80106c94:	e9 65 f9 ff ff       	jmp    801065fe <alltraps>

80106c99 <vector50>:
.globl vector50
vector50:
  pushl $0
80106c99:	6a 00                	push   $0x0
  pushl $50
80106c9b:	6a 32                	push   $0x32
  jmp alltraps
80106c9d:	e9 5c f9 ff ff       	jmp    801065fe <alltraps>

80106ca2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106ca2:	6a 00                	push   $0x0
  pushl $51
80106ca4:	6a 33                	push   $0x33
  jmp alltraps
80106ca6:	e9 53 f9 ff ff       	jmp    801065fe <alltraps>

80106cab <vector52>:
.globl vector52
vector52:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $52
80106cad:	6a 34                	push   $0x34
  jmp alltraps
80106caf:	e9 4a f9 ff ff       	jmp    801065fe <alltraps>

80106cb4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106cb4:	6a 00                	push   $0x0
  pushl $53
80106cb6:	6a 35                	push   $0x35
  jmp alltraps
80106cb8:	e9 41 f9 ff ff       	jmp    801065fe <alltraps>

80106cbd <vector54>:
.globl vector54
vector54:
  pushl $0
80106cbd:	6a 00                	push   $0x0
  pushl $54
80106cbf:	6a 36                	push   $0x36
  jmp alltraps
80106cc1:	e9 38 f9 ff ff       	jmp    801065fe <alltraps>

80106cc6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106cc6:	6a 00                	push   $0x0
  pushl $55
80106cc8:	6a 37                	push   $0x37
  jmp alltraps
80106cca:	e9 2f f9 ff ff       	jmp    801065fe <alltraps>

80106ccf <vector56>:
.globl vector56
vector56:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $56
80106cd1:	6a 38                	push   $0x38
  jmp alltraps
80106cd3:	e9 26 f9 ff ff       	jmp    801065fe <alltraps>

80106cd8 <vector57>:
.globl vector57
vector57:
  pushl $0
80106cd8:	6a 00                	push   $0x0
  pushl $57
80106cda:	6a 39                	push   $0x39
  jmp alltraps
80106cdc:	e9 1d f9 ff ff       	jmp    801065fe <alltraps>

80106ce1 <vector58>:
.globl vector58
vector58:
  pushl $0
80106ce1:	6a 00                	push   $0x0
  pushl $58
80106ce3:	6a 3a                	push   $0x3a
  jmp alltraps
80106ce5:	e9 14 f9 ff ff       	jmp    801065fe <alltraps>

80106cea <vector59>:
.globl vector59
vector59:
  pushl $0
80106cea:	6a 00                	push   $0x0
  pushl $59
80106cec:	6a 3b                	push   $0x3b
  jmp alltraps
80106cee:	e9 0b f9 ff ff       	jmp    801065fe <alltraps>

80106cf3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $60
80106cf5:	6a 3c                	push   $0x3c
  jmp alltraps
80106cf7:	e9 02 f9 ff ff       	jmp    801065fe <alltraps>

80106cfc <vector61>:
.globl vector61
vector61:
  pushl $0
80106cfc:	6a 00                	push   $0x0
  pushl $61
80106cfe:	6a 3d                	push   $0x3d
  jmp alltraps
80106d00:	e9 f9 f8 ff ff       	jmp    801065fe <alltraps>

80106d05 <vector62>:
.globl vector62
vector62:
  pushl $0
80106d05:	6a 00                	push   $0x0
  pushl $62
80106d07:	6a 3e                	push   $0x3e
  jmp alltraps
80106d09:	e9 f0 f8 ff ff       	jmp    801065fe <alltraps>

80106d0e <vector63>:
.globl vector63
vector63:
  pushl $0
80106d0e:	6a 00                	push   $0x0
  pushl $63
80106d10:	6a 3f                	push   $0x3f
  jmp alltraps
80106d12:	e9 e7 f8 ff ff       	jmp    801065fe <alltraps>

80106d17 <vector64>:
.globl vector64
vector64:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $64
80106d19:	6a 40                	push   $0x40
  jmp alltraps
80106d1b:	e9 de f8 ff ff       	jmp    801065fe <alltraps>

80106d20 <vector65>:
.globl vector65
vector65:
  pushl $0
80106d20:	6a 00                	push   $0x0
  pushl $65
80106d22:	6a 41                	push   $0x41
  jmp alltraps
80106d24:	e9 d5 f8 ff ff       	jmp    801065fe <alltraps>

80106d29 <vector66>:
.globl vector66
vector66:
  pushl $0
80106d29:	6a 00                	push   $0x0
  pushl $66
80106d2b:	6a 42                	push   $0x42
  jmp alltraps
80106d2d:	e9 cc f8 ff ff       	jmp    801065fe <alltraps>

80106d32 <vector67>:
.globl vector67
vector67:
  pushl $0
80106d32:	6a 00                	push   $0x0
  pushl $67
80106d34:	6a 43                	push   $0x43
  jmp alltraps
80106d36:	e9 c3 f8 ff ff       	jmp    801065fe <alltraps>

80106d3b <vector68>:
.globl vector68
vector68:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $68
80106d3d:	6a 44                	push   $0x44
  jmp alltraps
80106d3f:	e9 ba f8 ff ff       	jmp    801065fe <alltraps>

80106d44 <vector69>:
.globl vector69
vector69:
  pushl $0
80106d44:	6a 00                	push   $0x0
  pushl $69
80106d46:	6a 45                	push   $0x45
  jmp alltraps
80106d48:	e9 b1 f8 ff ff       	jmp    801065fe <alltraps>

80106d4d <vector70>:
.globl vector70
vector70:
  pushl $0
80106d4d:	6a 00                	push   $0x0
  pushl $70
80106d4f:	6a 46                	push   $0x46
  jmp alltraps
80106d51:	e9 a8 f8 ff ff       	jmp    801065fe <alltraps>

80106d56 <vector71>:
.globl vector71
vector71:
  pushl $0
80106d56:	6a 00                	push   $0x0
  pushl $71
80106d58:	6a 47                	push   $0x47
  jmp alltraps
80106d5a:	e9 9f f8 ff ff       	jmp    801065fe <alltraps>

80106d5f <vector72>:
.globl vector72
vector72:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $72
80106d61:	6a 48                	push   $0x48
  jmp alltraps
80106d63:	e9 96 f8 ff ff       	jmp    801065fe <alltraps>

80106d68 <vector73>:
.globl vector73
vector73:
  pushl $0
80106d68:	6a 00                	push   $0x0
  pushl $73
80106d6a:	6a 49                	push   $0x49
  jmp alltraps
80106d6c:	e9 8d f8 ff ff       	jmp    801065fe <alltraps>

80106d71 <vector74>:
.globl vector74
vector74:
  pushl $0
80106d71:	6a 00                	push   $0x0
  pushl $74
80106d73:	6a 4a                	push   $0x4a
  jmp alltraps
80106d75:	e9 84 f8 ff ff       	jmp    801065fe <alltraps>

80106d7a <vector75>:
.globl vector75
vector75:
  pushl $0
80106d7a:	6a 00                	push   $0x0
  pushl $75
80106d7c:	6a 4b                	push   $0x4b
  jmp alltraps
80106d7e:	e9 7b f8 ff ff       	jmp    801065fe <alltraps>

80106d83 <vector76>:
.globl vector76
vector76:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $76
80106d85:	6a 4c                	push   $0x4c
  jmp alltraps
80106d87:	e9 72 f8 ff ff       	jmp    801065fe <alltraps>

80106d8c <vector77>:
.globl vector77
vector77:
  pushl $0
80106d8c:	6a 00                	push   $0x0
  pushl $77
80106d8e:	6a 4d                	push   $0x4d
  jmp alltraps
80106d90:	e9 69 f8 ff ff       	jmp    801065fe <alltraps>

80106d95 <vector78>:
.globl vector78
vector78:
  pushl $0
80106d95:	6a 00                	push   $0x0
  pushl $78
80106d97:	6a 4e                	push   $0x4e
  jmp alltraps
80106d99:	e9 60 f8 ff ff       	jmp    801065fe <alltraps>

80106d9e <vector79>:
.globl vector79
vector79:
  pushl $0
80106d9e:	6a 00                	push   $0x0
  pushl $79
80106da0:	6a 4f                	push   $0x4f
  jmp alltraps
80106da2:	e9 57 f8 ff ff       	jmp    801065fe <alltraps>

80106da7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $80
80106da9:	6a 50                	push   $0x50
  jmp alltraps
80106dab:	e9 4e f8 ff ff       	jmp    801065fe <alltraps>

80106db0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106db0:	6a 00                	push   $0x0
  pushl $81
80106db2:	6a 51                	push   $0x51
  jmp alltraps
80106db4:	e9 45 f8 ff ff       	jmp    801065fe <alltraps>

80106db9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106db9:	6a 00                	push   $0x0
  pushl $82
80106dbb:	6a 52                	push   $0x52
  jmp alltraps
80106dbd:	e9 3c f8 ff ff       	jmp    801065fe <alltraps>

80106dc2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106dc2:	6a 00                	push   $0x0
  pushl $83
80106dc4:	6a 53                	push   $0x53
  jmp alltraps
80106dc6:	e9 33 f8 ff ff       	jmp    801065fe <alltraps>

80106dcb <vector84>:
.globl vector84
vector84:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $84
80106dcd:	6a 54                	push   $0x54
  jmp alltraps
80106dcf:	e9 2a f8 ff ff       	jmp    801065fe <alltraps>

80106dd4 <vector85>:
.globl vector85
vector85:
  pushl $0
80106dd4:	6a 00                	push   $0x0
  pushl $85
80106dd6:	6a 55                	push   $0x55
  jmp alltraps
80106dd8:	e9 21 f8 ff ff       	jmp    801065fe <alltraps>

80106ddd <vector86>:
.globl vector86
vector86:
  pushl $0
80106ddd:	6a 00                	push   $0x0
  pushl $86
80106ddf:	6a 56                	push   $0x56
  jmp alltraps
80106de1:	e9 18 f8 ff ff       	jmp    801065fe <alltraps>

80106de6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106de6:	6a 00                	push   $0x0
  pushl $87
80106de8:	6a 57                	push   $0x57
  jmp alltraps
80106dea:	e9 0f f8 ff ff       	jmp    801065fe <alltraps>

80106def <vector88>:
.globl vector88
vector88:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $88
80106df1:	6a 58                	push   $0x58
  jmp alltraps
80106df3:	e9 06 f8 ff ff       	jmp    801065fe <alltraps>

80106df8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106df8:	6a 00                	push   $0x0
  pushl $89
80106dfa:	6a 59                	push   $0x59
  jmp alltraps
80106dfc:	e9 fd f7 ff ff       	jmp    801065fe <alltraps>

80106e01 <vector90>:
.globl vector90
vector90:
  pushl $0
80106e01:	6a 00                	push   $0x0
  pushl $90
80106e03:	6a 5a                	push   $0x5a
  jmp alltraps
80106e05:	e9 f4 f7 ff ff       	jmp    801065fe <alltraps>

80106e0a <vector91>:
.globl vector91
vector91:
  pushl $0
80106e0a:	6a 00                	push   $0x0
  pushl $91
80106e0c:	6a 5b                	push   $0x5b
  jmp alltraps
80106e0e:	e9 eb f7 ff ff       	jmp    801065fe <alltraps>

80106e13 <vector92>:
.globl vector92
vector92:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $92
80106e15:	6a 5c                	push   $0x5c
  jmp alltraps
80106e17:	e9 e2 f7 ff ff       	jmp    801065fe <alltraps>

80106e1c <vector93>:
.globl vector93
vector93:
  pushl $0
80106e1c:	6a 00                	push   $0x0
  pushl $93
80106e1e:	6a 5d                	push   $0x5d
  jmp alltraps
80106e20:	e9 d9 f7 ff ff       	jmp    801065fe <alltraps>

80106e25 <vector94>:
.globl vector94
vector94:
  pushl $0
80106e25:	6a 00                	push   $0x0
  pushl $94
80106e27:	6a 5e                	push   $0x5e
  jmp alltraps
80106e29:	e9 d0 f7 ff ff       	jmp    801065fe <alltraps>

80106e2e <vector95>:
.globl vector95
vector95:
  pushl $0
80106e2e:	6a 00                	push   $0x0
  pushl $95
80106e30:	6a 5f                	push   $0x5f
  jmp alltraps
80106e32:	e9 c7 f7 ff ff       	jmp    801065fe <alltraps>

80106e37 <vector96>:
.globl vector96
vector96:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $96
80106e39:	6a 60                	push   $0x60
  jmp alltraps
80106e3b:	e9 be f7 ff ff       	jmp    801065fe <alltraps>

80106e40 <vector97>:
.globl vector97
vector97:
  pushl $0
80106e40:	6a 00                	push   $0x0
  pushl $97
80106e42:	6a 61                	push   $0x61
  jmp alltraps
80106e44:	e9 b5 f7 ff ff       	jmp    801065fe <alltraps>

80106e49 <vector98>:
.globl vector98
vector98:
  pushl $0
80106e49:	6a 00                	push   $0x0
  pushl $98
80106e4b:	6a 62                	push   $0x62
  jmp alltraps
80106e4d:	e9 ac f7 ff ff       	jmp    801065fe <alltraps>

80106e52 <vector99>:
.globl vector99
vector99:
  pushl $0
80106e52:	6a 00                	push   $0x0
  pushl $99
80106e54:	6a 63                	push   $0x63
  jmp alltraps
80106e56:	e9 a3 f7 ff ff       	jmp    801065fe <alltraps>

80106e5b <vector100>:
.globl vector100
vector100:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $100
80106e5d:	6a 64                	push   $0x64
  jmp alltraps
80106e5f:	e9 9a f7 ff ff       	jmp    801065fe <alltraps>

80106e64 <vector101>:
.globl vector101
vector101:
  pushl $0
80106e64:	6a 00                	push   $0x0
  pushl $101
80106e66:	6a 65                	push   $0x65
  jmp alltraps
80106e68:	e9 91 f7 ff ff       	jmp    801065fe <alltraps>

80106e6d <vector102>:
.globl vector102
vector102:
  pushl $0
80106e6d:	6a 00                	push   $0x0
  pushl $102
80106e6f:	6a 66                	push   $0x66
  jmp alltraps
80106e71:	e9 88 f7 ff ff       	jmp    801065fe <alltraps>

80106e76 <vector103>:
.globl vector103
vector103:
  pushl $0
80106e76:	6a 00                	push   $0x0
  pushl $103
80106e78:	6a 67                	push   $0x67
  jmp alltraps
80106e7a:	e9 7f f7 ff ff       	jmp    801065fe <alltraps>

80106e7f <vector104>:
.globl vector104
vector104:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $104
80106e81:	6a 68                	push   $0x68
  jmp alltraps
80106e83:	e9 76 f7 ff ff       	jmp    801065fe <alltraps>

80106e88 <vector105>:
.globl vector105
vector105:
  pushl $0
80106e88:	6a 00                	push   $0x0
  pushl $105
80106e8a:	6a 69                	push   $0x69
  jmp alltraps
80106e8c:	e9 6d f7 ff ff       	jmp    801065fe <alltraps>

80106e91 <vector106>:
.globl vector106
vector106:
  pushl $0
80106e91:	6a 00                	push   $0x0
  pushl $106
80106e93:	6a 6a                	push   $0x6a
  jmp alltraps
80106e95:	e9 64 f7 ff ff       	jmp    801065fe <alltraps>

80106e9a <vector107>:
.globl vector107
vector107:
  pushl $0
80106e9a:	6a 00                	push   $0x0
  pushl $107
80106e9c:	6a 6b                	push   $0x6b
  jmp alltraps
80106e9e:	e9 5b f7 ff ff       	jmp    801065fe <alltraps>

80106ea3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $108
80106ea5:	6a 6c                	push   $0x6c
  jmp alltraps
80106ea7:	e9 52 f7 ff ff       	jmp    801065fe <alltraps>

80106eac <vector109>:
.globl vector109
vector109:
  pushl $0
80106eac:	6a 00                	push   $0x0
  pushl $109
80106eae:	6a 6d                	push   $0x6d
  jmp alltraps
80106eb0:	e9 49 f7 ff ff       	jmp    801065fe <alltraps>

80106eb5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106eb5:	6a 00                	push   $0x0
  pushl $110
80106eb7:	6a 6e                	push   $0x6e
  jmp alltraps
80106eb9:	e9 40 f7 ff ff       	jmp    801065fe <alltraps>

80106ebe <vector111>:
.globl vector111
vector111:
  pushl $0
80106ebe:	6a 00                	push   $0x0
  pushl $111
80106ec0:	6a 6f                	push   $0x6f
  jmp alltraps
80106ec2:	e9 37 f7 ff ff       	jmp    801065fe <alltraps>

80106ec7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $112
80106ec9:	6a 70                	push   $0x70
  jmp alltraps
80106ecb:	e9 2e f7 ff ff       	jmp    801065fe <alltraps>

80106ed0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106ed0:	6a 00                	push   $0x0
  pushl $113
80106ed2:	6a 71                	push   $0x71
  jmp alltraps
80106ed4:	e9 25 f7 ff ff       	jmp    801065fe <alltraps>

80106ed9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106ed9:	6a 00                	push   $0x0
  pushl $114
80106edb:	6a 72                	push   $0x72
  jmp alltraps
80106edd:	e9 1c f7 ff ff       	jmp    801065fe <alltraps>

80106ee2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106ee2:	6a 00                	push   $0x0
  pushl $115
80106ee4:	6a 73                	push   $0x73
  jmp alltraps
80106ee6:	e9 13 f7 ff ff       	jmp    801065fe <alltraps>

80106eeb <vector116>:
.globl vector116
vector116:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $116
80106eed:	6a 74                	push   $0x74
  jmp alltraps
80106eef:	e9 0a f7 ff ff       	jmp    801065fe <alltraps>

80106ef4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ef4:	6a 00                	push   $0x0
  pushl $117
80106ef6:	6a 75                	push   $0x75
  jmp alltraps
80106ef8:	e9 01 f7 ff ff       	jmp    801065fe <alltraps>

80106efd <vector118>:
.globl vector118
vector118:
  pushl $0
80106efd:	6a 00                	push   $0x0
  pushl $118
80106eff:	6a 76                	push   $0x76
  jmp alltraps
80106f01:	e9 f8 f6 ff ff       	jmp    801065fe <alltraps>

80106f06 <vector119>:
.globl vector119
vector119:
  pushl $0
80106f06:	6a 00                	push   $0x0
  pushl $119
80106f08:	6a 77                	push   $0x77
  jmp alltraps
80106f0a:	e9 ef f6 ff ff       	jmp    801065fe <alltraps>

80106f0f <vector120>:
.globl vector120
vector120:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $120
80106f11:	6a 78                	push   $0x78
  jmp alltraps
80106f13:	e9 e6 f6 ff ff       	jmp    801065fe <alltraps>

80106f18 <vector121>:
.globl vector121
vector121:
  pushl $0
80106f18:	6a 00                	push   $0x0
  pushl $121
80106f1a:	6a 79                	push   $0x79
  jmp alltraps
80106f1c:	e9 dd f6 ff ff       	jmp    801065fe <alltraps>

80106f21 <vector122>:
.globl vector122
vector122:
  pushl $0
80106f21:	6a 00                	push   $0x0
  pushl $122
80106f23:	6a 7a                	push   $0x7a
  jmp alltraps
80106f25:	e9 d4 f6 ff ff       	jmp    801065fe <alltraps>

80106f2a <vector123>:
.globl vector123
vector123:
  pushl $0
80106f2a:	6a 00                	push   $0x0
  pushl $123
80106f2c:	6a 7b                	push   $0x7b
  jmp alltraps
80106f2e:	e9 cb f6 ff ff       	jmp    801065fe <alltraps>

80106f33 <vector124>:
.globl vector124
vector124:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $124
80106f35:	6a 7c                	push   $0x7c
  jmp alltraps
80106f37:	e9 c2 f6 ff ff       	jmp    801065fe <alltraps>

80106f3c <vector125>:
.globl vector125
vector125:
  pushl $0
80106f3c:	6a 00                	push   $0x0
  pushl $125
80106f3e:	6a 7d                	push   $0x7d
  jmp alltraps
80106f40:	e9 b9 f6 ff ff       	jmp    801065fe <alltraps>

80106f45 <vector126>:
.globl vector126
vector126:
  pushl $0
80106f45:	6a 00                	push   $0x0
  pushl $126
80106f47:	6a 7e                	push   $0x7e
  jmp alltraps
80106f49:	e9 b0 f6 ff ff       	jmp    801065fe <alltraps>

80106f4e <vector127>:
.globl vector127
vector127:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $127
80106f50:	6a 7f                	push   $0x7f
  jmp alltraps
80106f52:	e9 a7 f6 ff ff       	jmp    801065fe <alltraps>

80106f57 <vector128>:
.globl vector128
vector128:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $128
80106f59:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106f5e:	e9 9b f6 ff ff       	jmp    801065fe <alltraps>

80106f63 <vector129>:
.globl vector129
vector129:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $129
80106f65:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106f6a:	e9 8f f6 ff ff       	jmp    801065fe <alltraps>

80106f6f <vector130>:
.globl vector130
vector130:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $130
80106f71:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106f76:	e9 83 f6 ff ff       	jmp    801065fe <alltraps>

80106f7b <vector131>:
.globl vector131
vector131:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $131
80106f7d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106f82:	e9 77 f6 ff ff       	jmp    801065fe <alltraps>

80106f87 <vector132>:
.globl vector132
vector132:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $132
80106f89:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106f8e:	e9 6b f6 ff ff       	jmp    801065fe <alltraps>

80106f93 <vector133>:
.globl vector133
vector133:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $133
80106f95:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106f9a:	e9 5f f6 ff ff       	jmp    801065fe <alltraps>

80106f9f <vector134>:
.globl vector134
vector134:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $134
80106fa1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106fa6:	e9 53 f6 ff ff       	jmp    801065fe <alltraps>

80106fab <vector135>:
.globl vector135
vector135:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $135
80106fad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106fb2:	e9 47 f6 ff ff       	jmp    801065fe <alltraps>

80106fb7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $136
80106fb9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106fbe:	e9 3b f6 ff ff       	jmp    801065fe <alltraps>

80106fc3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $137
80106fc5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106fca:	e9 2f f6 ff ff       	jmp    801065fe <alltraps>

80106fcf <vector138>:
.globl vector138
vector138:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $138
80106fd1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106fd6:	e9 23 f6 ff ff       	jmp    801065fe <alltraps>

80106fdb <vector139>:
.globl vector139
vector139:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $139
80106fdd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106fe2:	e9 17 f6 ff ff       	jmp    801065fe <alltraps>

80106fe7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $140
80106fe9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106fee:	e9 0b f6 ff ff       	jmp    801065fe <alltraps>

80106ff3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $141
80106ff5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106ffa:	e9 ff f5 ff ff       	jmp    801065fe <alltraps>

80106fff <vector142>:
.globl vector142
vector142:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $142
80107001:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107006:	e9 f3 f5 ff ff       	jmp    801065fe <alltraps>

8010700b <vector143>:
.globl vector143
vector143:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $143
8010700d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107012:	e9 e7 f5 ff ff       	jmp    801065fe <alltraps>

80107017 <vector144>:
.globl vector144
vector144:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $144
80107019:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010701e:	e9 db f5 ff ff       	jmp    801065fe <alltraps>

80107023 <vector145>:
.globl vector145
vector145:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $145
80107025:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010702a:	e9 cf f5 ff ff       	jmp    801065fe <alltraps>

8010702f <vector146>:
.globl vector146
vector146:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $146
80107031:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107036:	e9 c3 f5 ff ff       	jmp    801065fe <alltraps>

8010703b <vector147>:
.globl vector147
vector147:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $147
8010703d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107042:	e9 b7 f5 ff ff       	jmp    801065fe <alltraps>

80107047 <vector148>:
.globl vector148
vector148:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $148
80107049:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010704e:	e9 ab f5 ff ff       	jmp    801065fe <alltraps>

80107053 <vector149>:
.globl vector149
vector149:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $149
80107055:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010705a:	e9 9f f5 ff ff       	jmp    801065fe <alltraps>

8010705f <vector150>:
.globl vector150
vector150:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $150
80107061:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107066:	e9 93 f5 ff ff       	jmp    801065fe <alltraps>

8010706b <vector151>:
.globl vector151
vector151:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $151
8010706d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107072:	e9 87 f5 ff ff       	jmp    801065fe <alltraps>

80107077 <vector152>:
.globl vector152
vector152:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $152
80107079:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010707e:	e9 7b f5 ff ff       	jmp    801065fe <alltraps>

80107083 <vector153>:
.globl vector153
vector153:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $153
80107085:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010708a:	e9 6f f5 ff ff       	jmp    801065fe <alltraps>

8010708f <vector154>:
.globl vector154
vector154:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $154
80107091:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107096:	e9 63 f5 ff ff       	jmp    801065fe <alltraps>

8010709b <vector155>:
.globl vector155
vector155:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $155
8010709d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801070a2:	e9 57 f5 ff ff       	jmp    801065fe <alltraps>

801070a7 <vector156>:
.globl vector156
vector156:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $156
801070a9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801070ae:	e9 4b f5 ff ff       	jmp    801065fe <alltraps>

801070b3 <vector157>:
.globl vector157
vector157:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $157
801070b5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801070ba:	e9 3f f5 ff ff       	jmp    801065fe <alltraps>

801070bf <vector158>:
.globl vector158
vector158:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $158
801070c1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801070c6:	e9 33 f5 ff ff       	jmp    801065fe <alltraps>

801070cb <vector159>:
.globl vector159
vector159:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $159
801070cd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801070d2:	e9 27 f5 ff ff       	jmp    801065fe <alltraps>

801070d7 <vector160>:
.globl vector160
vector160:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $160
801070d9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801070de:	e9 1b f5 ff ff       	jmp    801065fe <alltraps>

801070e3 <vector161>:
.globl vector161
vector161:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $161
801070e5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801070ea:	e9 0f f5 ff ff       	jmp    801065fe <alltraps>

801070ef <vector162>:
.globl vector162
vector162:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $162
801070f1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801070f6:	e9 03 f5 ff ff       	jmp    801065fe <alltraps>

801070fb <vector163>:
.globl vector163
vector163:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $163
801070fd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107102:	e9 f7 f4 ff ff       	jmp    801065fe <alltraps>

80107107 <vector164>:
.globl vector164
vector164:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $164
80107109:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010710e:	e9 eb f4 ff ff       	jmp    801065fe <alltraps>

80107113 <vector165>:
.globl vector165
vector165:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $165
80107115:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010711a:	e9 df f4 ff ff       	jmp    801065fe <alltraps>

8010711f <vector166>:
.globl vector166
vector166:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $166
80107121:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107126:	e9 d3 f4 ff ff       	jmp    801065fe <alltraps>

8010712b <vector167>:
.globl vector167
vector167:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $167
8010712d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107132:	e9 c7 f4 ff ff       	jmp    801065fe <alltraps>

80107137 <vector168>:
.globl vector168
vector168:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $168
80107139:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010713e:	e9 bb f4 ff ff       	jmp    801065fe <alltraps>

80107143 <vector169>:
.globl vector169
vector169:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $169
80107145:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010714a:	e9 af f4 ff ff       	jmp    801065fe <alltraps>

8010714f <vector170>:
.globl vector170
vector170:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $170
80107151:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107156:	e9 a3 f4 ff ff       	jmp    801065fe <alltraps>

8010715b <vector171>:
.globl vector171
vector171:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $171
8010715d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107162:	e9 97 f4 ff ff       	jmp    801065fe <alltraps>

80107167 <vector172>:
.globl vector172
vector172:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $172
80107169:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010716e:	e9 8b f4 ff ff       	jmp    801065fe <alltraps>

80107173 <vector173>:
.globl vector173
vector173:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $173
80107175:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010717a:	e9 7f f4 ff ff       	jmp    801065fe <alltraps>

8010717f <vector174>:
.globl vector174
vector174:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $174
80107181:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107186:	e9 73 f4 ff ff       	jmp    801065fe <alltraps>

8010718b <vector175>:
.globl vector175
vector175:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $175
8010718d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107192:	e9 67 f4 ff ff       	jmp    801065fe <alltraps>

80107197 <vector176>:
.globl vector176
vector176:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $176
80107199:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010719e:	e9 5b f4 ff ff       	jmp    801065fe <alltraps>

801071a3 <vector177>:
.globl vector177
vector177:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $177
801071a5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801071aa:	e9 4f f4 ff ff       	jmp    801065fe <alltraps>

801071af <vector178>:
.globl vector178
vector178:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $178
801071b1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801071b6:	e9 43 f4 ff ff       	jmp    801065fe <alltraps>

801071bb <vector179>:
.globl vector179
vector179:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $179
801071bd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801071c2:	e9 37 f4 ff ff       	jmp    801065fe <alltraps>

801071c7 <vector180>:
.globl vector180
vector180:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $180
801071c9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801071ce:	e9 2b f4 ff ff       	jmp    801065fe <alltraps>

801071d3 <vector181>:
.globl vector181
vector181:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $181
801071d5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801071da:	e9 1f f4 ff ff       	jmp    801065fe <alltraps>

801071df <vector182>:
.globl vector182
vector182:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $182
801071e1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801071e6:	e9 13 f4 ff ff       	jmp    801065fe <alltraps>

801071eb <vector183>:
.globl vector183
vector183:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $183
801071ed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801071f2:	e9 07 f4 ff ff       	jmp    801065fe <alltraps>

801071f7 <vector184>:
.globl vector184
vector184:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $184
801071f9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801071fe:	e9 fb f3 ff ff       	jmp    801065fe <alltraps>

80107203 <vector185>:
.globl vector185
vector185:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $185
80107205:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010720a:	e9 ef f3 ff ff       	jmp    801065fe <alltraps>

8010720f <vector186>:
.globl vector186
vector186:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $186
80107211:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107216:	e9 e3 f3 ff ff       	jmp    801065fe <alltraps>

8010721b <vector187>:
.globl vector187
vector187:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $187
8010721d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107222:	e9 d7 f3 ff ff       	jmp    801065fe <alltraps>

80107227 <vector188>:
.globl vector188
vector188:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $188
80107229:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010722e:	e9 cb f3 ff ff       	jmp    801065fe <alltraps>

80107233 <vector189>:
.globl vector189
vector189:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $189
80107235:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010723a:	e9 bf f3 ff ff       	jmp    801065fe <alltraps>

8010723f <vector190>:
.globl vector190
vector190:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $190
80107241:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107246:	e9 b3 f3 ff ff       	jmp    801065fe <alltraps>

8010724b <vector191>:
.globl vector191
vector191:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $191
8010724d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107252:	e9 a7 f3 ff ff       	jmp    801065fe <alltraps>

80107257 <vector192>:
.globl vector192
vector192:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $192
80107259:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010725e:	e9 9b f3 ff ff       	jmp    801065fe <alltraps>

80107263 <vector193>:
.globl vector193
vector193:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $193
80107265:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010726a:	e9 8f f3 ff ff       	jmp    801065fe <alltraps>

8010726f <vector194>:
.globl vector194
vector194:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $194
80107271:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107276:	e9 83 f3 ff ff       	jmp    801065fe <alltraps>

8010727b <vector195>:
.globl vector195
vector195:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $195
8010727d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107282:	e9 77 f3 ff ff       	jmp    801065fe <alltraps>

80107287 <vector196>:
.globl vector196
vector196:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $196
80107289:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010728e:	e9 6b f3 ff ff       	jmp    801065fe <alltraps>

80107293 <vector197>:
.globl vector197
vector197:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $197
80107295:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010729a:	e9 5f f3 ff ff       	jmp    801065fe <alltraps>

8010729f <vector198>:
.globl vector198
vector198:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $198
801072a1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801072a6:	e9 53 f3 ff ff       	jmp    801065fe <alltraps>

801072ab <vector199>:
.globl vector199
vector199:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $199
801072ad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801072b2:	e9 47 f3 ff ff       	jmp    801065fe <alltraps>

801072b7 <vector200>:
.globl vector200
vector200:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $200
801072b9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801072be:	e9 3b f3 ff ff       	jmp    801065fe <alltraps>

801072c3 <vector201>:
.globl vector201
vector201:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $201
801072c5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801072ca:	e9 2f f3 ff ff       	jmp    801065fe <alltraps>

801072cf <vector202>:
.globl vector202
vector202:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $202
801072d1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801072d6:	e9 23 f3 ff ff       	jmp    801065fe <alltraps>

801072db <vector203>:
.globl vector203
vector203:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $203
801072dd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801072e2:	e9 17 f3 ff ff       	jmp    801065fe <alltraps>

801072e7 <vector204>:
.globl vector204
vector204:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $204
801072e9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801072ee:	e9 0b f3 ff ff       	jmp    801065fe <alltraps>

801072f3 <vector205>:
.globl vector205
vector205:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $205
801072f5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801072fa:	e9 ff f2 ff ff       	jmp    801065fe <alltraps>

801072ff <vector206>:
.globl vector206
vector206:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $206
80107301:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107306:	e9 f3 f2 ff ff       	jmp    801065fe <alltraps>

8010730b <vector207>:
.globl vector207
vector207:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $207
8010730d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107312:	e9 e7 f2 ff ff       	jmp    801065fe <alltraps>

80107317 <vector208>:
.globl vector208
vector208:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $208
80107319:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010731e:	e9 db f2 ff ff       	jmp    801065fe <alltraps>

80107323 <vector209>:
.globl vector209
vector209:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $209
80107325:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010732a:	e9 cf f2 ff ff       	jmp    801065fe <alltraps>

8010732f <vector210>:
.globl vector210
vector210:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $210
80107331:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107336:	e9 c3 f2 ff ff       	jmp    801065fe <alltraps>

8010733b <vector211>:
.globl vector211
vector211:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $211
8010733d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107342:	e9 b7 f2 ff ff       	jmp    801065fe <alltraps>

80107347 <vector212>:
.globl vector212
vector212:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $212
80107349:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010734e:	e9 ab f2 ff ff       	jmp    801065fe <alltraps>

80107353 <vector213>:
.globl vector213
vector213:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $213
80107355:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010735a:	e9 9f f2 ff ff       	jmp    801065fe <alltraps>

8010735f <vector214>:
.globl vector214
vector214:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $214
80107361:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107366:	e9 93 f2 ff ff       	jmp    801065fe <alltraps>

8010736b <vector215>:
.globl vector215
vector215:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $215
8010736d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107372:	e9 87 f2 ff ff       	jmp    801065fe <alltraps>

80107377 <vector216>:
.globl vector216
vector216:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $216
80107379:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010737e:	e9 7b f2 ff ff       	jmp    801065fe <alltraps>

80107383 <vector217>:
.globl vector217
vector217:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $217
80107385:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010738a:	e9 6f f2 ff ff       	jmp    801065fe <alltraps>

8010738f <vector218>:
.globl vector218
vector218:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $218
80107391:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107396:	e9 63 f2 ff ff       	jmp    801065fe <alltraps>

8010739b <vector219>:
.globl vector219
vector219:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $219
8010739d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801073a2:	e9 57 f2 ff ff       	jmp    801065fe <alltraps>

801073a7 <vector220>:
.globl vector220
vector220:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $220
801073a9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801073ae:	e9 4b f2 ff ff       	jmp    801065fe <alltraps>

801073b3 <vector221>:
.globl vector221
vector221:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $221
801073b5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801073ba:	e9 3f f2 ff ff       	jmp    801065fe <alltraps>

801073bf <vector222>:
.globl vector222
vector222:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $222
801073c1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801073c6:	e9 33 f2 ff ff       	jmp    801065fe <alltraps>

801073cb <vector223>:
.globl vector223
vector223:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $223
801073cd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801073d2:	e9 27 f2 ff ff       	jmp    801065fe <alltraps>

801073d7 <vector224>:
.globl vector224
vector224:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $224
801073d9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801073de:	e9 1b f2 ff ff       	jmp    801065fe <alltraps>

801073e3 <vector225>:
.globl vector225
vector225:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $225
801073e5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801073ea:	e9 0f f2 ff ff       	jmp    801065fe <alltraps>

801073ef <vector226>:
.globl vector226
vector226:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $226
801073f1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801073f6:	e9 03 f2 ff ff       	jmp    801065fe <alltraps>

801073fb <vector227>:
.globl vector227
vector227:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $227
801073fd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107402:	e9 f7 f1 ff ff       	jmp    801065fe <alltraps>

80107407 <vector228>:
.globl vector228
vector228:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $228
80107409:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010740e:	e9 eb f1 ff ff       	jmp    801065fe <alltraps>

80107413 <vector229>:
.globl vector229
vector229:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $229
80107415:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010741a:	e9 df f1 ff ff       	jmp    801065fe <alltraps>

8010741f <vector230>:
.globl vector230
vector230:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $230
80107421:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107426:	e9 d3 f1 ff ff       	jmp    801065fe <alltraps>

8010742b <vector231>:
.globl vector231
vector231:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $231
8010742d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107432:	e9 c7 f1 ff ff       	jmp    801065fe <alltraps>

80107437 <vector232>:
.globl vector232
vector232:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $232
80107439:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010743e:	e9 bb f1 ff ff       	jmp    801065fe <alltraps>

80107443 <vector233>:
.globl vector233
vector233:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $233
80107445:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010744a:	e9 af f1 ff ff       	jmp    801065fe <alltraps>

8010744f <vector234>:
.globl vector234
vector234:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $234
80107451:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107456:	e9 a3 f1 ff ff       	jmp    801065fe <alltraps>

8010745b <vector235>:
.globl vector235
vector235:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $235
8010745d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107462:	e9 97 f1 ff ff       	jmp    801065fe <alltraps>

80107467 <vector236>:
.globl vector236
vector236:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $236
80107469:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010746e:	e9 8b f1 ff ff       	jmp    801065fe <alltraps>

80107473 <vector237>:
.globl vector237
vector237:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $237
80107475:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010747a:	e9 7f f1 ff ff       	jmp    801065fe <alltraps>

8010747f <vector238>:
.globl vector238
vector238:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $238
80107481:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107486:	e9 73 f1 ff ff       	jmp    801065fe <alltraps>

8010748b <vector239>:
.globl vector239
vector239:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $239
8010748d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107492:	e9 67 f1 ff ff       	jmp    801065fe <alltraps>

80107497 <vector240>:
.globl vector240
vector240:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $240
80107499:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010749e:	e9 5b f1 ff ff       	jmp    801065fe <alltraps>

801074a3 <vector241>:
.globl vector241
vector241:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $241
801074a5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801074aa:	e9 4f f1 ff ff       	jmp    801065fe <alltraps>

801074af <vector242>:
.globl vector242
vector242:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $242
801074b1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801074b6:	e9 43 f1 ff ff       	jmp    801065fe <alltraps>

801074bb <vector243>:
.globl vector243
vector243:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $243
801074bd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801074c2:	e9 37 f1 ff ff       	jmp    801065fe <alltraps>

801074c7 <vector244>:
.globl vector244
vector244:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $244
801074c9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801074ce:	e9 2b f1 ff ff       	jmp    801065fe <alltraps>

801074d3 <vector245>:
.globl vector245
vector245:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $245
801074d5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801074da:	e9 1f f1 ff ff       	jmp    801065fe <alltraps>

801074df <vector246>:
.globl vector246
vector246:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $246
801074e1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801074e6:	e9 13 f1 ff ff       	jmp    801065fe <alltraps>

801074eb <vector247>:
.globl vector247
vector247:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $247
801074ed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801074f2:	e9 07 f1 ff ff       	jmp    801065fe <alltraps>

801074f7 <vector248>:
.globl vector248
vector248:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $248
801074f9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801074fe:	e9 fb f0 ff ff       	jmp    801065fe <alltraps>

80107503 <vector249>:
.globl vector249
vector249:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $249
80107505:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010750a:	e9 ef f0 ff ff       	jmp    801065fe <alltraps>

8010750f <vector250>:
.globl vector250
vector250:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $250
80107511:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107516:	e9 e3 f0 ff ff       	jmp    801065fe <alltraps>

8010751b <vector251>:
.globl vector251
vector251:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $251
8010751d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107522:	e9 d7 f0 ff ff       	jmp    801065fe <alltraps>

80107527 <vector252>:
.globl vector252
vector252:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $252
80107529:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010752e:	e9 cb f0 ff ff       	jmp    801065fe <alltraps>

80107533 <vector253>:
.globl vector253
vector253:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $253
80107535:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010753a:	e9 bf f0 ff ff       	jmp    801065fe <alltraps>

8010753f <vector254>:
.globl vector254
vector254:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $254
80107541:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107546:	e9 b3 f0 ff ff       	jmp    801065fe <alltraps>

8010754b <vector255>:
.globl vector255
vector255:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $255
8010754d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107552:	e9 a7 f0 ff ff       	jmp    801065fe <alltraps>
80107557:	66 90                	xchg   %ax,%ax
80107559:	66 90                	xchg   %ax,%ax
8010755b:	66 90                	xchg   %ax,%ax
8010755d:	66 90                	xchg   %ax,%ax
8010755f:	90                   	nop

80107560 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107560:	55                   	push   %ebp
80107561:	89 e5                	mov    %esp,%ebp
80107563:	57                   	push   %edi
80107564:	56                   	push   %esi
80107565:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107566:	89 d3                	mov    %edx,%ebx
{
80107568:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010756a:	c1 eb 16             	shr    $0x16,%ebx
8010756d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107570:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107573:	8b 06                	mov    (%esi),%eax
80107575:	a8 01                	test   $0x1,%al
80107577:	74 27                	je     801075a0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107579:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010757e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107584:	c1 ef 0a             	shr    $0xa,%edi
}
80107587:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010758a:	89 fa                	mov    %edi,%edx
8010758c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107592:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107595:	5b                   	pop    %ebx
80107596:	5e                   	pop    %esi
80107597:	5f                   	pop    %edi
80107598:	5d                   	pop    %ebp
80107599:	c3                   	ret    
8010759a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801075a0:	85 c9                	test   %ecx,%ecx
801075a2:	74 2c                	je     801075d0 <walkpgdir+0x70>
801075a4:	e8 d7 b1 ff ff       	call   80102780 <kalloc>
801075a9:	85 c0                	test   %eax,%eax
801075ab:	89 c3                	mov    %eax,%ebx
801075ad:	74 21                	je     801075d0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801075af:	83 ec 04             	sub    $0x4,%esp
801075b2:	68 00 10 00 00       	push   $0x1000
801075b7:	6a 00                	push   $0x0
801075b9:	50                   	push   %eax
801075ba:	e8 41 d9 ff ff       	call   80104f00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801075bf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075c5:	83 c4 10             	add    $0x10,%esp
801075c8:	83 c8 07             	or     $0x7,%eax
801075cb:	89 06                	mov    %eax,(%esi)
801075cd:	eb b5                	jmp    80107584 <walkpgdir+0x24>
801075cf:	90                   	nop
}
801075d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801075d3:	31 c0                	xor    %eax,%eax
}
801075d5:	5b                   	pop    %ebx
801075d6:	5e                   	pop    %esi
801075d7:	5f                   	pop    %edi
801075d8:	5d                   	pop    %ebp
801075d9:	c3                   	ret    
801075da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	57                   	push   %edi
801075e4:	56                   	push   %esi
801075e5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801075e6:	89 d3                	mov    %edx,%ebx
801075e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801075ee:	83 ec 1c             	sub    $0x1c,%esp
801075f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801075f4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801075f8:	8b 7d 08             	mov    0x8(%ebp),%edi
801075fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107600:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    // if(*pte & PTE_P)
    //   panic("remap");
    *pte = pa | perm | PTE_P;
80107603:	8b 45 0c             	mov    0xc(%ebp),%eax
80107606:	29 df                	sub    %ebx,%edi
80107608:	83 c8 01             	or     $0x1,%eax
8010760b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010760e:	eb 10                	jmp    80107620 <mappages+0x40>
80107610:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107613:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80107616:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107618:	74 2e                	je     80107648 <mappages+0x68>
      break;
    a += PGSIZE;
8010761a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107623:	b9 01 00 00 00       	mov    $0x1,%ecx
80107628:	89 da                	mov    %ebx,%edx
8010762a:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
8010762d:	e8 2e ff ff ff       	call   80107560 <walkpgdir>
80107632:	85 c0                	test   %eax,%eax
80107634:	75 da                	jne    80107610 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107636:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80107639:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010763e:	5b                   	pop    %ebx
8010763f:	5e                   	pop    %esi
80107640:	5f                   	pop    %edi
80107641:	5d                   	pop    %ebp
80107642:	c3                   	ret    
80107643:	90                   	nop
80107644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107648:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010764b:	31 c0                	xor    %eax,%eax
}
8010764d:	5b                   	pop    %ebx
8010764e:	5e                   	pop    %esi
8010764f:	5f                   	pop    %edi
80107650:	5d                   	pop    %ebp
80107651:	c3                   	ret    
80107652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107660 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
  uint a, pa,flags;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107666:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010766c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010766e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107674:	83 ec 1c             	sub    $0x1c,%esp
80107677:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010767a:	39 d3                	cmp    %edx,%ebx
8010767c:	73 4f                	jae    801076cd <deallocuvm.part.0+0x6d>
8010767e:	89 d6                	mov    %edx,%esi
80107680:	eb 2c                	jmp    801076ae <deallocuvm.part.0+0x4e>
80107682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
80107688:	8b 10                	mov    (%eax),%edx
8010768a:	f6 c2 01             	test   $0x1,%dl
8010768d:	74 15                	je     801076a4 <deallocuvm.part.0+0x44>
      pa = PTE_ADDR(*pte);
      flags=PTE_FLAGS(*pte);
      if(pa == 0)
8010768f:	89 d1                	mov    %edx,%ecx
80107691:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80107697:	74 61                	je     801076fa <deallocuvm.part.0+0x9a>
        panic("kfree");
      char *v = P2V(pa);
      if((flags & PTE_SWAPPED)==0){
80107699:	80 e6 02             	and    $0x2,%dh
8010769c:	74 42                	je     801076e0 <deallocuvm.part.0+0x80>
        kfree(v);
      }
      // kfree(v);
      *pte = 0;
8010769e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801076a4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076aa:	39 f3                	cmp    %esi,%ebx
801076ac:	73 1f                	jae    801076cd <deallocuvm.part.0+0x6d>
    pte = walkpgdir(pgdir, (char*)a, 0);
801076ae:	31 c9                	xor    %ecx,%ecx
801076b0:	89 da                	mov    %ebx,%edx
801076b2:	89 f8                	mov    %edi,%eax
801076b4:	e8 a7 fe ff ff       	call   80107560 <walkpgdir>
    if(!pte)
801076b9:	85 c0                	test   %eax,%eax
801076bb:	75 cb                	jne    80107688 <deallocuvm.part.0+0x28>
      a += (NPTENTRIES - 1) * PGSIZE;
801076bd:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801076c3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076c9:	39 f3                	cmp    %esi,%ebx
801076cb:	72 e1                	jb     801076ae <deallocuvm.part.0+0x4e>
    }
  }
  return newsz;
}
801076cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d3:	5b                   	pop    %ebx
801076d4:	5e                   	pop    %esi
801076d5:	5f                   	pop    %edi
801076d6:	5d                   	pop    %ebp
801076d7:	c3                   	ret    
801076d8:	90                   	nop
801076d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(v);
801076e0:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801076e3:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
801076e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        kfree(v);
801076ec:	51                   	push   %ecx
801076ed:	e8 8e ae ff ff       	call   80102580 <kfree>
801076f2:	83 c4 10             	add    $0x10,%esp
801076f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076f8:	eb a4                	jmp    8010769e <deallocuvm.part.0+0x3e>
        panic("kfree");
801076fa:	83 ec 0c             	sub    $0xc,%esp
801076fd:	68 be 86 10 80       	push   $0x801086be
80107702:	e8 79 8d ff ff       	call   80100480 <panic>
80107707:	89 f6                	mov    %esi,%esi
80107709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107710 <seginit>:
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	53                   	push   %ebx
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107714:	31 db                	xor    %ebx,%ebx
{
80107716:	83 ec 14             	sub    $0x14,%esp
  c = &cpus[cpunum()];
80107719:	e8 82 b3 ff ff       	call   80102aa0 <cpunum>
8010771e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107724:	8d 90 e0 42 11 80    	lea    -0x7feebd20(%eax),%edx
8010772a:	8d 88 94 43 11 80    	lea    -0x7feebc6c(%eax),%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107730:	c7 80 58 43 11 80 ff 	movl   $0xffff,-0x7feebca8(%eax)
80107737:	ff 00 00 
8010773a:	c7 80 5c 43 11 80 00 	movl   $0xcf9a00,-0x7feebca4(%eax)
80107741:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107744:	c7 80 60 43 11 80 ff 	movl   $0xffff,-0x7feebca0(%eax)
8010774b:	ff 00 00 
8010774e:	c7 80 64 43 11 80 00 	movl   $0xcf9200,-0x7feebc9c(%eax)
80107755:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107758:	c7 80 70 43 11 80 ff 	movl   $0xffff,-0x7feebc90(%eax)
8010775f:	ff 00 00 
80107762:	c7 80 74 43 11 80 00 	movl   $0xcffa00,-0x7feebc8c(%eax)
80107769:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010776c:	c7 80 78 43 11 80 ff 	movl   $0xffff,-0x7feebc88(%eax)
80107773:	ff 00 00 
80107776:	c7 80 7c 43 11 80 00 	movl   $0xcff200,-0x7feebc84(%eax)
8010777d:	f2 cf 00 
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107780:	66 89 9a 88 00 00 00 	mov    %bx,0x88(%edx)
80107787:	89 cb                	mov    %ecx,%ebx
80107789:	c1 eb 10             	shr    $0x10,%ebx
8010778c:	66 89 8a 8a 00 00 00 	mov    %cx,0x8a(%edx)
80107793:	c1 e9 18             	shr    $0x18,%ecx
80107796:	88 9a 8c 00 00 00    	mov    %bl,0x8c(%edx)
8010779c:	bb 92 c0 ff ff       	mov    $0xffffc092,%ebx
801077a1:	66 89 98 6d 43 11 80 	mov    %bx,-0x7feebc93(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801077a8:	05 50 43 11 80       	add    $0x80114350,%eax
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801077ad:	88 8a 8f 00 00 00    	mov    %cl,0x8f(%edx)
  pd[0] = size-1;
801077b3:	b9 37 00 00 00       	mov    $0x37,%ecx
801077b8:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
801077bc:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801077c0:	c1 e8 10             	shr    $0x10,%eax
801077c3:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801077c7:	8d 45 f2             	lea    -0xe(%ebp),%eax
801077ca:	0f 01 10             	lgdtl  (%eax)
  asm volatile("movw %0, %%gs" : : "r" (v));
801077cd:	b8 18 00 00 00       	mov    $0x18,%eax
801077d2:	8e e8                	mov    %eax,%gs
  proc = 0;
801077d4:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801077db:	00 00 00 00 
  c = &cpus[cpunum()];
801077df:	65 89 15 00 00 00 00 	mov    %edx,%gs:0x0
}
801077e6:	83 c4 14             	add    $0x14,%esp
801077e9:	5b                   	pop    %ebx
801077ea:	5d                   	pop    %ebp
801077eb:	c3                   	ret    
801077ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801077f0 <setupkvm>:
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	56                   	push   %esi
801077f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801077f5:	e8 86 af ff ff       	call   80102780 <kalloc>
801077fa:	85 c0                	test   %eax,%eax
801077fc:	74 52                	je     80107850 <setupkvm+0x60>
  memset(pgdir, 0, PGSIZE);
801077fe:	83 ec 04             	sub    $0x4,%esp
80107801:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107803:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107808:	68 00 10 00 00       	push   $0x1000
8010780d:	6a 00                	push   $0x0
8010780f:	50                   	push   %eax
80107810:	e8 eb d6 ff ff       	call   80104f00 <memset>
80107815:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0)
80107818:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010781b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010781e:	83 ec 08             	sub    $0x8,%esp
80107821:	8b 13                	mov    (%ebx),%edx
80107823:	ff 73 0c             	pushl  0xc(%ebx)
80107826:	50                   	push   %eax
80107827:	29 c1                	sub    %eax,%ecx
80107829:	89 f0                	mov    %esi,%eax
8010782b:	e8 b0 fd ff ff       	call   801075e0 <mappages>
80107830:	83 c4 10             	add    $0x10,%esp
80107833:	85 c0                	test   %eax,%eax
80107835:	78 19                	js     80107850 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107837:	83 c3 10             	add    $0x10,%ebx
8010783a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107840:	75 d6                	jne    80107818 <setupkvm+0x28>
}
80107842:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107845:	89 f0                	mov    %esi,%eax
80107847:	5b                   	pop    %ebx
80107848:	5e                   	pop    %esi
80107849:	5d                   	pop    %ebp
8010784a:	c3                   	ret    
8010784b:	90                   	nop
8010784c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107850:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80107853:	31 f6                	xor    %esi,%esi
}
80107855:	89 f0                	mov    %esi,%eax
80107857:	5b                   	pop    %ebx
80107858:	5e                   	pop    %esi
80107859:	5d                   	pop    %ebp
8010785a:	c3                   	ret    
8010785b:	90                   	nop
8010785c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107860 <kvmalloc>:
{
80107860:	55                   	push   %ebp
80107861:	89 e5                	mov    %esp,%ebp
80107863:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107866:	e8 85 ff ff ff       	call   801077f0 <setupkvm>
8010786b:	a3 80 95 11 80       	mov    %eax,0x80119580
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107870:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107875:	0f 22 d8             	mov    %eax,%cr3
}
80107878:	c9                   	leave  
80107879:	c3                   	ret    
8010787a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107880 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107880:	a1 80 95 11 80       	mov    0x80119580,%eax
{
80107885:	55                   	push   %ebp
80107886:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107888:	05 00 00 00 80       	add    $0x80000000,%eax
8010788d:	0f 22 d8             	mov    %eax,%cr3
}
80107890:	5d                   	pop    %ebp
80107891:	c3                   	ret    
80107892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078a0 <switchuvm>:
{
801078a0:	55                   	push   %ebp
801078a1:	89 e5                	mov    %esp,%ebp
801078a3:	53                   	push   %ebx
801078a4:	83 ec 04             	sub    $0x4,%esp
801078a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801078aa:	e8 f1 d2 ff ff       	call   80104ba0 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801078af:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801078b5:	b9 67 00 00 00       	mov    $0x67,%ecx
801078ba:	8d 50 08             	lea    0x8(%eax),%edx
801078bd:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
801078c4:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
801078cb:	89 d1                	mov    %edx,%ecx
801078cd:	c1 ea 18             	shr    $0x18,%edx
801078d0:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
801078d6:	ba 89 40 00 00       	mov    $0x4089,%edx
801078db:	c1 e9 10             	shr    $0x10,%ecx
801078de:	66 89 90 a5 00 00 00 	mov    %dx,0xa5(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801078e5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801078ec:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801078f2:	b9 10 00 00 00       	mov    $0x10,%ecx
801078f7:	66 89 48 10          	mov    %cx,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801078fb:	8b 52 08             	mov    0x8(%edx),%edx
801078fe:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107904:	89 50 0c             	mov    %edx,0xc(%eax)
  cpu->ts.iomb = (ushort) 0xFFFF;
80107907:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010790c:	66 89 50 6e          	mov    %dx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107910:	b8 30 00 00 00       	mov    $0x30,%eax
80107915:	0f 00 d8             	ltr    %ax
  if(p->pgdir == 0)
80107918:	8b 43 04             	mov    0x4(%ebx),%eax
8010791b:	85 c0                	test   %eax,%eax
8010791d:	74 11                	je     80107930 <switchuvm+0x90>
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010791f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107924:	0f 22 d8             	mov    %eax,%cr3
}
80107927:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010792a:	c9                   	leave  
  popcli();
8010792b:	e9 a0 d2 ff ff       	jmp    80104bd0 <popcli>
    panic("switchuvm: no pgdir");
80107930:	83 ec 0c             	sub    $0xc,%esp
80107933:	68 e0 8d 10 80       	push   $0x80108de0
80107938:	e8 43 8b ff ff       	call   80100480 <panic>
8010793d:	8d 76 00             	lea    0x0(%esi),%esi

80107940 <inituvm>:
{
80107940:	55                   	push   %ebp
80107941:	89 e5                	mov    %esp,%ebp
80107943:	57                   	push   %edi
80107944:	56                   	push   %esi
80107945:	53                   	push   %ebx
80107946:	83 ec 1c             	sub    $0x1c,%esp
80107949:	8b 75 10             	mov    0x10(%ebp),%esi
8010794c:	8b 45 08             	mov    0x8(%ebp),%eax
8010794f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107952:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107958:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010795b:	77 49                	ja     801079a6 <inituvm+0x66>
  mem = kalloc();
8010795d:	e8 1e ae ff ff       	call   80102780 <kalloc>
  memset(mem, 0, PGSIZE);
80107962:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107965:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107967:	68 00 10 00 00       	push   $0x1000
8010796c:	6a 00                	push   $0x0
8010796e:	50                   	push   %eax
8010796f:	e8 8c d5 ff ff       	call   80104f00 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107974:	58                   	pop    %eax
80107975:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010797b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107980:	5a                   	pop    %edx
80107981:	6a 06                	push   $0x6
80107983:	50                   	push   %eax
80107984:	31 d2                	xor    %edx,%edx
80107986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107989:	e8 52 fc ff ff       	call   801075e0 <mappages>
  memmove(mem, init, sz);
8010798e:	89 75 10             	mov    %esi,0x10(%ebp)
80107991:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107994:	83 c4 10             	add    $0x10,%esp
80107997:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010799a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010799d:	5b                   	pop    %ebx
8010799e:	5e                   	pop    %esi
8010799f:	5f                   	pop    %edi
801079a0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801079a1:	e9 0a d6 ff ff       	jmp    80104fb0 <memmove>
    panic("inituvm: more than a page");
801079a6:	83 ec 0c             	sub    $0xc,%esp
801079a9:	68 f4 8d 10 80       	push   $0x80108df4
801079ae:	e8 cd 8a ff ff       	call   80100480 <panic>
801079b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079c0 <loaduvm>:
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	57                   	push   %edi
801079c4:	56                   	push   %esi
801079c5:	53                   	push   %ebx
801079c6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801079c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801079d0:	0f 85 91 00 00 00    	jne    80107a67 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801079d6:	8b 75 18             	mov    0x18(%ebp),%esi
801079d9:	31 db                	xor    %ebx,%ebx
801079db:	85 f6                	test   %esi,%esi
801079dd:	75 1a                	jne    801079f9 <loaduvm+0x39>
801079df:	eb 6f                	jmp    80107a50 <loaduvm+0x90>
801079e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801079ee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801079f4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801079f7:	76 57                	jbe    80107a50 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801079f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801079fc:	8b 45 08             	mov    0x8(%ebp),%eax
801079ff:	31 c9                	xor    %ecx,%ecx
80107a01:	01 da                	add    %ebx,%edx
80107a03:	e8 58 fb ff ff       	call   80107560 <walkpgdir>
80107a08:	85 c0                	test   %eax,%eax
80107a0a:	74 4e                	je     80107a5a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80107a0c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a0e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107a11:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107a16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107a1b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107a21:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a24:	01 d9                	add    %ebx,%ecx
80107a26:	05 00 00 00 80       	add    $0x80000000,%eax
80107a2b:	57                   	push   %edi
80107a2c:	51                   	push   %ecx
80107a2d:	50                   	push   %eax
80107a2e:	ff 75 10             	pushl  0x10(%ebp)
80107a31:	e8 aa a0 ff ff       	call   80101ae0 <readi>
80107a36:	83 c4 10             	add    $0x10,%esp
80107a39:	39 f8                	cmp    %edi,%eax
80107a3b:	74 ab                	je     801079e8 <loaduvm+0x28>
}
80107a3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a45:	5b                   	pop    %ebx
80107a46:	5e                   	pop    %esi
80107a47:	5f                   	pop    %edi
80107a48:	5d                   	pop    %ebp
80107a49:	c3                   	ret    
80107a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a53:	31 c0                	xor    %eax,%eax
}
80107a55:	5b                   	pop    %ebx
80107a56:	5e                   	pop    %esi
80107a57:	5f                   	pop    %edi
80107a58:	5d                   	pop    %ebp
80107a59:	c3                   	ret    
      panic("loaduvm: address should exist");
80107a5a:	83 ec 0c             	sub    $0xc,%esp
80107a5d:	68 0e 8e 10 80       	push   $0x80108e0e
80107a62:	e8 19 8a ff ff       	call   80100480 <panic>
    panic("loaduvm: addr must be page aligned");
80107a67:	83 ec 0c             	sub    $0xc,%esp
80107a6a:	68 18 8f 10 80       	push   $0x80108f18
80107a6f:	e8 0c 8a ff ff       	call   80100480 <panic>
80107a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a80 <allocuvm>:
{
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
80107a83:	57                   	push   %edi
80107a84:	56                   	push   %esi
80107a85:	53                   	push   %ebx
80107a86:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107a89:	8b 7d 10             	mov    0x10(%ebp),%edi
80107a8c:	85 ff                	test   %edi,%edi
80107a8e:	0f 88 ac 00 00 00    	js     80107b40 <allocuvm+0xc0>
  if(newsz < oldsz)
80107a94:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107a97:	0f 82 93 00 00 00    	jb     80107b30 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aa0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107aa6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107aac:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107aaf:	0f 86 7e 00 00 00    	jbe    80107b33 <allocuvm+0xb3>
80107ab5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107ab8:	8b 7d 08             	mov    0x8(%ebp),%edi
80107abb:	eb 42                	jmp    80107aff <allocuvm+0x7f>
80107abd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107ac0:	83 ec 04             	sub    $0x4,%esp
80107ac3:	68 00 10 00 00       	push   $0x1000
80107ac8:	6a 00                	push   $0x0
80107aca:	50                   	push   %eax
80107acb:	e8 30 d4 ff ff       	call   80104f00 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107ad0:	58                   	pop    %eax
80107ad1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107ad7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107adc:	5a                   	pop    %edx
80107add:	6a 06                	push   $0x6
80107adf:	50                   	push   %eax
80107ae0:	89 da                	mov    %ebx,%edx
80107ae2:	89 f8                	mov    %edi,%eax
80107ae4:	e8 f7 fa ff ff       	call   801075e0 <mappages>
80107ae9:	83 c4 10             	add    $0x10,%esp
80107aec:	85 c0                	test   %eax,%eax
80107aee:	78 60                	js     80107b50 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80107af0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107af6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107af9:	0f 86 91 00 00 00    	jbe    80107b90 <allocuvm+0x110>
    mem = kalloc();
80107aff:	e8 7c ac ff ff       	call   80102780 <kalloc>
    if(mem == 0){
80107b04:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107b06:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107b08:	75 b6                	jne    80107ac0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107b0a:	83 ec 0c             	sub    $0xc,%esp
80107b0d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107b10:	68 2c 8e 10 80       	push   $0x80108e2c
80107b15:	e8 36 8c ff ff       	call   80100750 <cprintf>
      break;
80107b1a:	83 c4 10             	add    $0x10,%esp
}
80107b1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b20:	89 f8                	mov    %edi,%eax
80107b22:	5b                   	pop    %ebx
80107b23:	5e                   	pop    %esi
80107b24:	5f                   	pop    %edi
80107b25:	5d                   	pop    %ebp
80107b26:	c3                   	ret    
80107b27:	89 f6                	mov    %esi,%esi
80107b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return oldsz;
80107b30:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107b33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b36:	89 f8                	mov    %edi,%eax
80107b38:	5b                   	pop    %ebx
80107b39:	5e                   	pop    %esi
80107b3a:	5f                   	pop    %edi
80107b3b:	5d                   	pop    %ebp
80107b3c:	c3                   	ret    
80107b3d:	8d 76 00             	lea    0x0(%esi),%esi
80107b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107b43:	31 ff                	xor    %edi,%edi
}
80107b45:	89 f8                	mov    %edi,%eax
80107b47:	5b                   	pop    %ebx
80107b48:	5e                   	pop    %esi
80107b49:	5f                   	pop    %edi
80107b4a:	5d                   	pop    %ebp
80107b4b:	c3                   	ret    
80107b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80107b50:	83 ec 0c             	sub    $0xc,%esp
80107b53:	68 44 8e 10 80       	push   $0x80108e44
80107b58:	e8 f3 8b ff ff       	call   80100750 <cprintf>
  if(newsz >= oldsz)
80107b5d:	83 c4 10             	add    $0x10,%esp
80107b60:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b63:	39 45 10             	cmp    %eax,0x10(%ebp)
80107b66:	76 0d                	jbe    80107b75 <allocuvm+0xf5>
80107b68:	89 c1                	mov    %eax,%ecx
80107b6a:	8b 55 10             	mov    0x10(%ebp),%edx
80107b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b70:	e8 eb fa ff ff       	call   80107660 <deallocuvm.part.0>
      kfree(mem);
80107b75:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107b78:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107b7a:	56                   	push   %esi
80107b7b:	e8 00 aa ff ff       	call   80102580 <kfree>
      return 0;
80107b80:	83 c4 10             	add    $0x10,%esp
}
80107b83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b86:	89 f8                	mov    %edi,%eax
80107b88:	5b                   	pop    %ebx
80107b89:	5e                   	pop    %esi
80107b8a:	5f                   	pop    %edi
80107b8b:	5d                   	pop    %ebp
80107b8c:	c3                   	ret    
80107b8d:	8d 76 00             	lea    0x0(%esi),%esi
80107b90:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107b93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b96:	5b                   	pop    %ebx
80107b97:	89 f8                	mov    %edi,%eax
80107b99:	5e                   	pop    %esi
80107b9a:	5f                   	pop    %edi
80107b9b:	5d                   	pop    %ebp
80107b9c:	c3                   	ret    
80107b9d:	8d 76 00             	lea    0x0(%esi),%esi

80107ba0 <deallocuvm>:
{
80107ba0:	55                   	push   %ebp
80107ba1:	89 e5                	mov    %esp,%ebp
80107ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ba6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107bac:	39 d1                	cmp    %edx,%ecx
80107bae:	73 10                	jae    80107bc0 <deallocuvm+0x20>
}
80107bb0:	5d                   	pop    %ebp
80107bb1:	e9 aa fa ff ff       	jmp    80107660 <deallocuvm.part.0>
80107bb6:	8d 76 00             	lea    0x0(%esi),%esi
80107bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107bc0:	89 d0                	mov    %edx,%eax
80107bc2:	5d                   	pop    %ebp
80107bc3:	c3                   	ret    
80107bc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107bca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107bd0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107bd0:	55                   	push   %ebp
80107bd1:	89 e5                	mov    %esp,%ebp
80107bd3:	57                   	push   %edi
80107bd4:	56                   	push   %esi
80107bd5:	53                   	push   %ebx
80107bd6:	83 ec 0c             	sub    $0xc,%esp
80107bd9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107bdc:	85 f6                	test   %esi,%esi
80107bde:	74 59                	je     80107c39 <freevm+0x69>
80107be0:	31 c9                	xor    %ecx,%ecx
80107be2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107be7:	89 f0                	mov    %esi,%eax
80107be9:	e8 72 fa ff ff       	call   80107660 <deallocuvm.part.0>
80107bee:	89 f3                	mov    %esi,%ebx
80107bf0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107bf6:	eb 0f                	jmp    80107c07 <freevm+0x37>
80107bf8:	90                   	nop
80107bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c00:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107c03:	39 fb                	cmp    %edi,%ebx
80107c05:	74 23                	je     80107c2a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107c07:	8b 03                	mov    (%ebx),%eax
80107c09:	a8 01                	test   $0x1,%al
80107c0b:	74 f3                	je     80107c00 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107c12:	83 ec 0c             	sub    $0xc,%esp
80107c15:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c18:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107c1d:	50                   	push   %eax
80107c1e:	e8 5d a9 ff ff       	call   80102580 <kfree>
80107c23:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107c26:	39 fb                	cmp    %edi,%ebx
80107c28:	75 dd                	jne    80107c07 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107c2a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c30:	5b                   	pop    %ebx
80107c31:	5e                   	pop    %esi
80107c32:	5f                   	pop    %edi
80107c33:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107c34:	e9 47 a9 ff ff       	jmp    80102580 <kfree>
    panic("freevm: no pgdir");
80107c39:	83 ec 0c             	sub    $0xc,%esp
80107c3c:	68 60 8e 10 80       	push   $0x80108e60
80107c41:	e8 3a 88 ff ff       	call   80100480 <panic>
80107c46:	8d 76 00             	lea    0x0(%esi),%esi
80107c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107c50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107c51:	31 c9                	xor    %ecx,%ecx
{
80107c53:	89 e5                	mov    %esp,%ebp
80107c55:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107c58:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c5e:	e8 fd f8 ff ff       	call   80107560 <walkpgdir>
  if(pte == 0)
80107c63:	85 c0                	test   %eax,%eax
80107c65:	74 05                	je     80107c6c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107c67:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107c6a:	c9                   	leave  
80107c6b:	c3                   	ret    
    panic("clearpteu");
80107c6c:	83 ec 0c             	sub    $0xc,%esp
80107c6f:	68 71 8e 10 80       	push   $0x80108e71
80107c74:	e8 07 88 ff ff       	call   80100480 <panic>
80107c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107c80 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107c80:	55                   	push   %ebp
80107c81:	89 e5                	mov    %esp,%ebp
80107c83:	57                   	push   %edi
80107c84:	56                   	push   %esi
80107c85:	53                   	push   %ebx
80107c86:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107c89:	e8 62 fb ff ff       	call   801077f0 <setupkvm>
80107c8e:	85 c0                	test   %eax,%eax
80107c90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107c93:	0f 84 a0 00 00 00    	je     80107d39 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107c99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107c9c:	85 c9                	test   %ecx,%ecx
80107c9e:	0f 84 95 00 00 00    	je     80107d39 <copyuvm+0xb9>
80107ca4:	31 f6                	xor    %esi,%esi
80107ca6:	eb 4e                	jmp    80107cf6 <copyuvm+0x76>
80107ca8:	90                   	nop
80107ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107cb0:	83 ec 04             	sub    $0x4,%esp
80107cb3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107cb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107cbc:	68 00 10 00 00       	push   $0x1000
80107cc1:	57                   	push   %edi
80107cc2:	50                   	push   %eax
80107cc3:	e8 e8 d2 ff ff       	call   80104fb0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107cc8:	58                   	pop    %eax
80107cc9:	5a                   	pop    %edx
80107cca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107ccd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107cd0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107cd5:	53                   	push   %ebx
80107cd6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107cdc:	52                   	push   %edx
80107cdd:	89 f2                	mov    %esi,%edx
80107cdf:	e8 fc f8 ff ff       	call   801075e0 <mappages>
80107ce4:	83 c4 10             	add    $0x10,%esp
80107ce7:	85 c0                	test   %eax,%eax
80107ce9:	78 39                	js     80107d24 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80107ceb:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107cf1:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107cf4:	76 43                	jbe    80107d39 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107cf6:	8b 45 08             	mov    0x8(%ebp),%eax
80107cf9:	31 c9                	xor    %ecx,%ecx
80107cfb:	89 f2                	mov    %esi,%edx
80107cfd:	e8 5e f8 ff ff       	call   80107560 <walkpgdir>
80107d02:	85 c0                	test   %eax,%eax
80107d04:	74 3e                	je     80107d44 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107d06:	8b 18                	mov    (%eax),%ebx
80107d08:	f6 c3 01             	test   $0x1,%bl
80107d0b:	74 44                	je     80107d51 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80107d0d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80107d0f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107d15:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107d1b:	e8 60 aa ff ff       	call   80102780 <kalloc>
80107d20:	85 c0                	test   %eax,%eax
80107d22:	75 8c                	jne    80107cb0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107d24:	83 ec 0c             	sub    $0xc,%esp
80107d27:	ff 75 e0             	pushl  -0x20(%ebp)
80107d2a:	e8 a1 fe ff ff       	call   80107bd0 <freevm>
  return 0;
80107d2f:	83 c4 10             	add    $0x10,%esp
80107d32:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107d39:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d3f:	5b                   	pop    %ebx
80107d40:	5e                   	pop    %esi
80107d41:	5f                   	pop    %edi
80107d42:	5d                   	pop    %ebp
80107d43:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107d44:	83 ec 0c             	sub    $0xc,%esp
80107d47:	68 7b 8e 10 80       	push   $0x80108e7b
80107d4c:	e8 2f 87 ff ff       	call   80100480 <panic>
      panic("copyuvm: page not present");
80107d51:	83 ec 0c             	sub    $0xc,%esp
80107d54:	68 95 8e 10 80       	push   $0x80108e95
80107d59:	e8 22 87 ff ff       	call   80100480 <panic>
80107d5e:	66 90                	xchg   %ax,%ax

80107d60 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107d60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d61:	31 c9                	xor    %ecx,%ecx
{
80107d63:	89 e5                	mov    %esp,%ebp
80107d65:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107d68:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80107d6e:	e8 ed f7 ff ff       	call   80107560 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107d73:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107d75:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107d76:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107d78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107d7d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107d80:	05 00 00 00 80       	add    $0x80000000,%eax
80107d85:	83 fa 05             	cmp    $0x5,%edx
80107d88:	ba 00 00 00 00       	mov    $0x0,%edx
80107d8d:	0f 45 c2             	cmovne %edx,%eax
}
80107d90:	c3                   	ret    
80107d91:	eb 0d                	jmp    80107da0 <copyout>
80107d93:	90                   	nop
80107d94:	90                   	nop
80107d95:	90                   	nop
80107d96:	90                   	nop
80107d97:	90                   	nop
80107d98:	90                   	nop
80107d99:	90                   	nop
80107d9a:	90                   	nop
80107d9b:	90                   	nop
80107d9c:	90                   	nop
80107d9d:	90                   	nop
80107d9e:	90                   	nop
80107d9f:	90                   	nop

80107da0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107da0:	55                   	push   %ebp
80107da1:	89 e5                	mov    %esp,%ebp
80107da3:	57                   	push   %edi
80107da4:	56                   	push   %esi
80107da5:	53                   	push   %ebx
80107da6:	83 ec 1c             	sub    $0x1c,%esp
80107da9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107dac:	8b 55 0c             	mov    0xc(%ebp),%edx
80107daf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107db2:	85 db                	test   %ebx,%ebx
80107db4:	75 40                	jne    80107df6 <copyout+0x56>
80107db6:	eb 70                	jmp    80107e28 <copyout+0x88>
80107db8:	90                   	nop
80107db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107dc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107dc3:	89 f1                	mov    %esi,%ecx
80107dc5:	29 d1                	sub    %edx,%ecx
80107dc7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107dcd:	39 d9                	cmp    %ebx,%ecx
80107dcf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107dd2:	29 f2                	sub    %esi,%edx
80107dd4:	83 ec 04             	sub    $0x4,%esp
80107dd7:	01 d0                	add    %edx,%eax
80107dd9:	51                   	push   %ecx
80107dda:	57                   	push   %edi
80107ddb:	50                   	push   %eax
80107ddc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107ddf:	e8 cc d1 ff ff       	call   80104fb0 <memmove>
    len -= n;
    buf += n;
80107de4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107de7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107dea:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107df0:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107df2:	29 cb                	sub    %ecx,%ebx
80107df4:	74 32                	je     80107e28 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107df6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107df8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107dfb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107dfe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107e04:	56                   	push   %esi
80107e05:	ff 75 08             	pushl  0x8(%ebp)
80107e08:	e8 53 ff ff ff       	call   80107d60 <uva2ka>
    if(pa0 == 0)
80107e0d:	83 c4 10             	add    $0x10,%esp
80107e10:	85 c0                	test   %eax,%eax
80107e12:	75 ac                	jne    80107dc0 <copyout+0x20>
  }
  return 0;
}
80107e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107e17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107e1c:	5b                   	pop    %ebx
80107e1d:	5e                   	pop    %esi
80107e1e:	5f                   	pop    %edi
80107e1f:	5d                   	pop    %ebp
80107e20:	c3                   	ret    
80107e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107e2b:	31 c0                	xor    %eax,%eax
}
80107e2d:	5b                   	pop    %ebx
80107e2e:	5e                   	pop    %esi
80107e2f:	5f                   	pop    %edi
80107e30:	5d                   	pop    %ebp
80107e31:	c3                   	ret    
80107e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e40 <slab_init>:
}slab;

slab slabs[8];//8个slab的object

//初始化slab
void slab_init(){
80107e40:	55                   	push   %ebp
80107e41:	89 e5                	mov    %esp,%ebp
80107e43:	57                   	push   %edi
80107e44:	56                   	push   %esi
80107e45:	53                   	push   %ebx
  int size,i;
  for(size=16,i=0;size<=2048;size*=2,i++){//size从16到2048依次分配
80107e46:	be 10 00 00 00       	mov    $0x10,%esi
80107e4b:	bb a8 95 11 80       	mov    $0x801195a8,%ebx
    slabs[i].size=size;//分配大小
    slabs[i].num=4096/size;//分配数量
80107e50:	bf 00 10 00 00       	mov    $0x1000,%edi
void slab_init(){
80107e55:	83 ec 0c             	sub    $0xc,%esp
80107e58:	90                   	nop
80107e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    slabs[i].num=4096/size;//分配数量
80107e60:	89 f8                	mov    %edi,%eax
    memset(slabs[i].used_mask,0,256);//状态位设置成0  未使用
80107e62:	83 ec 04             	sub    $0x4,%esp
    slabs[i].size=size;//分配大小
80107e65:	89 73 f8             	mov    %esi,-0x8(%ebx)
    slabs[i].num=4096/size;//分配数量
80107e68:	99                   	cltd   
    memset(slabs[i].used_mask,0,256);//状态位设置成0  未使用
80107e69:	68 00 01 00 00       	push   $0x100
80107e6e:	6a 00                	push   $0x0
    slabs[i].num=4096/size;//分配数量
80107e70:	f7 fe                	idiv   %esi
    memset(slabs[i].used_mask,0,256);//状态位设置成0  未使用
80107e72:	53                   	push   %ebx
80107e73:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
    slabs[i].num=4096/size;//分配数量
80107e79:	89 83 f0 fe ff ff    	mov    %eax,-0x110(%ebx)
    memset(slabs[i].used_mask,0,256);//状态位设置成0  未使用
80107e7f:	e8 7c d0 ff ff       	call   80104f00 <memset>
    slabs[i].phy_address=kalloc();//分配起始物理地址位置
80107e84:	e8 f7 a8 ff ff       	call   80102780 <kalloc>
    cprintf("slab %d was assigned! address: %p\n",size,slabs[i].phy_address);
80107e89:	83 c4 0c             	add    $0xc,%esp
    slabs[i].phy_address=kalloc();//分配起始物理地址位置
80107e8c:	89 43 f4             	mov    %eax,-0xc(%ebx)
    cprintf("slab %d was assigned! address: %p\n",size,slabs[i].phy_address);
80107e8f:	50                   	push   %eax
80107e90:	56                   	push   %esi
  for(size=16,i=0;size<=2048;size*=2,i++){//size从16到2048依次分配
80107e91:	01 f6                	add    %esi,%esi
    cprintf("slab %d was assigned! address: %p\n",size,slabs[i].phy_address);
80107e93:	68 3c 8f 10 80       	push   $0x80108f3c
80107e98:	e8 b3 88 ff ff       	call   80100750 <cprintf>
  for(size=16,i=0;size<=2048;size*=2,i++){//size从16到2048依次分配
80107e9d:	83 c4 10             	add    $0x10,%esp
80107ea0:	81 fb 08 9e 11 80    	cmp    $0x80119e08,%ebx
80107ea6:	75 b8                	jne    80107e60 <slab_init+0x20>
  }
}
80107ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107eab:	5b                   	pop    %ebx
80107eac:	5e                   	pop    %esi
80107ead:	5f                   	pop    %edi
80107eae:	5d                   	pop    %ebp
80107eaf:	c3                   	ret    

80107eb0 <slab_alloc>:

int slab_alloc(pde_t* pgdir,void* va,uint sz){//参数分别为：页表指针 内核区间起始地址 待装入大小
80107eb0:	55                   	push   %ebp
  if(sz>2048||sz<=0)return 0;//超出slab范围  error
80107eb1:	31 c0                	xor    %eax,%eax
int slab_alloc(pde_t* pgdir,void* va,uint sz){//参数分别为：页表指针 内核区间起始地址 待装入大小
80107eb3:	89 e5                	mov    %esp,%ebp
80107eb5:	57                   	push   %edi
80107eb6:	56                   	push   %esi
80107eb7:	53                   	push   %ebx
80107eb8:	83 ec 0c             	sub    $0xc,%esp
80107ebb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if(sz>2048||sz<=0)return 0;//超出slab范围  error
80107ebe:	8d 51 ff             	lea    -0x1(%ecx),%edx
80107ec1:	81 fa ff 07 00 00    	cmp    $0x7ff,%edx
80107ec7:	77 4a                	ja     80107f13 <slab_alloc+0x63>
  int size=16,i=0;//设置size初始值
80107ec9:	31 d2                	xor    %edx,%edx
  while(size<sz) size*=2,i++;//确定size最适合的值
80107ecb:	83 f9 10             	cmp    $0x10,%ecx
80107ece:	76 11                	jbe    80107ee1 <slab_alloc+0x31>
  int size=16,i=0;//设置size初始值
80107ed0:	b8 10 00 00 00       	mov    $0x10,%eax
80107ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(size<sz) size*=2,i++;//确定size最适合的值
80107ed8:	01 c0                	add    %eax,%eax
80107eda:	83 c2 01             	add    $0x1,%edx
80107edd:	39 c8                	cmp    %ecx,%eax
80107edf:	72 f7                	jb     80107ed8 <slab_alloc+0x28>
  int j;
  for(j=0;j<slabs[i].num;j++)//遍历slabs数组
80107ee1:	69 ca 0c 01 00 00    	imul   $0x10c,%edx,%ecx
80107ee7:	8b 81 a4 95 11 80    	mov    -0x7fee6a5c(%ecx),%eax
80107eed:	83 f8 00             	cmp    $0x0,%eax
80107ef0:	7e 2e                	jle    80107f20 <slab_alloc+0x70>
80107ef2:	31 db                	xor    %ebx,%ebx
    if(slabs[i].used_mask[j]==0)break;//找到第一个未被使用的slab object
80107ef4:	80 b9 a8 95 11 80 00 	cmpb   $0x0,-0x7fee6a58(%ecx)
80107efb:	75 0d                	jne    80107f0a <slab_alloc+0x5a>
80107efd:	eb 25                	jmp    80107f24 <slab_alloc+0x74>
80107eff:	90                   	nop
80107f00:	80 bc 19 a8 95 11 80 	cmpb   $0x0,-0x7fee6a58(%ecx,%ebx,1)
80107f07:	00 
80107f08:	74 1a                	je     80107f24 <slab_alloc+0x74>
  for(j=0;j<slabs[i].num;j++)//遍历slabs数组
80107f0a:	83 c3 01             	add    $0x1,%ebx
80107f0d:	39 d8                	cmp    %ebx,%eax
80107f0f:	75 ef                	jne    80107f00 <slab_alloc+0x50>
  if(sz>2048||sz<=0)return 0;//超出slab范围  error
80107f11:	31 c0                	xor    %eax,%eax
  uint pa=(uint) slabs[i].phy_address + j*slabs[i].size;//计算physical address
  cprintf("assign from physical address: %p \n",pa);//输出
  //按照用户页或者可改页将slab的起始地址及其大小的虚拟地址所在页映射到物理页中
  mappages(pgdir,va,4096,V2P(pa),PTE_W|PTE_U);
  return j*slabs[i].size;//返回在物理页上的地址偏移
}
80107f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f16:	5b                   	pop    %ebx
80107f17:	5e                   	pop    %esi
80107f18:	5f                   	pop    %edi
80107f19:	5d                   	pop    %ebp
80107f1a:	c3                   	ret    
80107f1b:	90                   	nop
80107f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(j==slabs[i].num) return 0;//未查找到未被使用的slab  error
80107f20:	74 f1                	je     80107f13 <slab_alloc+0x63>
80107f22:	31 db                	xor    %ebx,%ebx
  slabs[i].used_mask[j]=1;//对查找到的适合的object设置使用标志位为1
80107f24:	69 f2 0c 01 00 00    	imul   $0x10c,%edx,%esi
  cprintf("assign from physical address: %p \n",pa);//输出
80107f2a:	83 ec 08             	sub    $0x8,%esp
  uint pa=(uint) slabs[i].phy_address + j*slabs[i].size;//计算physical address
80107f2d:	8b be a0 95 11 80    	mov    -0x7fee6a60(%esi),%edi
  slabs[i].used_mask[j]=1;//对查找到的适合的object设置使用标志位为1
80107f33:	c6 84 33 a8 95 11 80 	movb   $0x1,-0x7fee6a58(%ebx,%esi,1)
80107f3a:	01 
  uint pa=(uint) slabs[i].phy_address + j*slabs[i].size;//计算physical address
80107f3b:	0f af fb             	imul   %ebx,%edi
80107f3e:	03 be a8 96 11 80    	add    -0x7fee6958(%esi),%edi
  cprintf("assign from physical address: %p \n",pa);//输出
80107f44:	57                   	push   %edi
80107f45:	68 60 8f 10 80       	push   $0x80108f60
  mappages(pgdir,va,4096,V2P(pa),PTE_W|PTE_U);
80107f4a:	81 c7 00 00 00 80    	add    $0x80000000,%edi
  cprintf("assign from physical address: %p \n",pa);//输出
80107f50:	e8 fb 87 ff ff       	call   80100750 <cprintf>
  mappages(pgdir,va,4096,V2P(pa),PTE_W|PTE_U);
80107f55:	58                   	pop    %eax
80107f56:	5a                   	pop    %edx
80107f57:	8b 45 08             	mov    0x8(%ebp),%eax
80107f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f5d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f62:	6a 06                	push   $0x6
80107f64:	57                   	push   %edi
80107f65:	e8 76 f6 ff ff       	call   801075e0 <mappages>
  return j*slabs[i].size;//返回在物理页上的地址偏移
80107f6a:	8b 86 a0 95 11 80    	mov    -0x7fee6a60(%esi),%eax
80107f70:	83 c4 10             	add    $0x10,%esp
}
80107f73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return j*slabs[i].size;//返回在物理页上的地址偏移
80107f76:	0f af c3             	imul   %ebx,%eax
}
80107f79:	5b                   	pop    %ebx
80107f7a:	5e                   	pop    %esi
80107f7b:	5f                   	pop    %edi
80107f7c:	5d                   	pop    %ebp
80107f7d:	c3                   	ret    
80107f7e:	66 90                	xchg   %ax,%ax

80107f80 <slab_free>:

int slab_free(pde_t* pgdir,void* va){//传入页表指针，内核区间起始地址
80107f80:	55                   	push   %ebp
80107f81:	89 e5                	mov    %esp,%ebp
80107f83:	57                   	push   %edi
80107f84:	56                   	push   %esi
80107f85:	53                   	push   %ebx
  uint page_addr=(uint)uva2ka(pgdir,va);//虚拟地址映射到内核地址
  uint page_offset=(uint)va&4095;//页内偏移
  uint pa = page_addr+page_offset;//计算内核物理页地址
  cprintf("free physical address: %p\n",pa);
  int i;
  for(i=0;i<8;i++){//遍历slabs数组
80107f86:	31 db                	xor    %ebx,%ebx
int slab_free(pde_t* pgdir,void* va){//传入页表指针，内核区间起始地址
80107f88:	83 ec 14             	sub    $0x14,%esp
  uint page_addr=(uint)uva2ka(pgdir,va);//虚拟地址映射到内核地址
80107f8b:	ff 75 0c             	pushl  0xc(%ebp)
80107f8e:	ff 75 08             	pushl  0x8(%ebp)
80107f91:	e8 ca fd ff ff       	call   80107d60 <uva2ka>
  uint page_offset=(uint)va&4095;//页内偏移
80107f96:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f99:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  uint pa = page_addr+page_offset;//计算内核物理页地址
80107f9f:	8d 34 10             	lea    (%eax,%edx,1),%esi
  cprintf("free physical address: %p\n",pa);
80107fa2:	58                   	pop    %eax
80107fa3:	5a                   	pop    %edx
80107fa4:	56                   	push   %esi
80107fa5:	68 af 8e 10 80       	push   $0x80108eaf
80107faa:	e8 a1 87 ff ff       	call   80100750 <cprintf>
80107faf:	b9 a0 95 11 80       	mov    $0x801195a0,%ecx
80107fb4:	83 c4 10             	add    $0x10,%esp
    uint start=(uint)slabs[i].phy_address;//slab object对应的物理页帧起始地址
    uint end =start+slabs[i].num*(uint)slabs[i].size;//slab object对应的物理页帧结束地址
80107fb7:	8b 39                	mov    (%ecx),%edi
80107fb9:	8b 51 04             	mov    0x4(%ecx),%edx
    uint start=(uint)slabs[i].phy_address;//slab object对应的物理页帧起始地址
80107fbc:	8b 81 08 01 00 00    	mov    0x108(%ecx),%eax
    uint end =start+slabs[i].num*(uint)slabs[i].size;//slab object对应的物理页帧结束地址
80107fc2:	0f af d7             	imul   %edi,%edx
80107fc5:	01 c2                	add    %eax,%edx
    if(start<=pa&&pa<end) break;//找到对应的slab  跳出循环
80107fc7:	39 d6                	cmp    %edx,%esi
80107fc9:	73 04                	jae    80107fcf <slab_free+0x4f>
80107fcb:	39 c6                	cmp    %eax,%esi
80107fcd:	73 21                	jae    80107ff0 <slab_free+0x70>
  for(i=0;i<8;i++){//遍历slabs数组
80107fcf:	83 c3 01             	add    $0x1,%ebx
80107fd2:	81 c1 0c 01 00 00    	add    $0x10c,%ecx
80107fd8:	83 fb 08             	cmp    $0x8,%ebx
80107fdb:	75 da                	jne    80107fb7 <slab_free+0x37>
  int j=offset/slabs[i].size;//找到slab[i]的索引值
  slabs[i].used_mask[j]=0;//将其状态位设置为0
  pte_t* pte=walkpgdir(pgdir,va,0);//获取页表
  *pte=(uint)0;//将页表设置为0  也就是清空解除映射
  return 1;//1表示返回成功free
}
80107fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(i==8) return 0;  //如果没找到则该虚拟地址无效
80107fe0:	31 c0                	xor    %eax,%eax
}
80107fe2:	5b                   	pop    %ebx
80107fe3:	5e                   	pop    %esi
80107fe4:	5f                   	pop    %edi
80107fe5:	5d                   	pop    %ebp
80107fe6:	c3                   	ret    
80107fe7:	89 f6                	mov    %esi,%esi
80107fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint offset =pa-(uint)slabs[i].phy_address;//计算slabs对应的物理页帧偏移
80107ff0:	29 c6                	sub    %eax,%esi
  int j=offset/slabs[i].size;//找到slab[i]的索引值
80107ff2:	31 d2                	xor    %edx,%edx
  pte_t* pte=walkpgdir(pgdir,va,0);//获取页表
80107ff4:	31 c9                	xor    %ecx,%ecx
  uint offset =pa-(uint)slabs[i].phy_address;//计算slabs对应的物理页帧偏移
80107ff6:	89 f0                	mov    %esi,%eax
  int j=offset/slabs[i].size;//找到slab[i]的索引值
80107ff8:	f7 f7                	div    %edi
  pte_t* pte=walkpgdir(pgdir,va,0);//获取页表
80107ffa:	8b 55 0c             	mov    0xc(%ebp),%edx
  slabs[i].used_mask[j]=0;//将其状态位设置为0
80107ffd:	69 db 0c 01 00 00    	imul   $0x10c,%ebx,%ebx
80108003:	c6 84 18 a8 95 11 80 	movb   $0x0,-0x7fee6a58(%eax,%ebx,1)
8010800a:	00 
  pte_t* pte=walkpgdir(pgdir,va,0);//获取页表
8010800b:	8b 45 08             	mov    0x8(%ebp),%eax
8010800e:	e8 4d f5 ff ff       	call   80107560 <walkpgdir>
  *pte=(uint)0;//将页表设置为0  也就是清空解除映射
80108013:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80108019:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;//1表示返回成功free
8010801c:	b8 01 00 00 00       	mov    $0x1,%eax
}
80108021:	5b                   	pop    %ebx
80108022:	5e                   	pop    %esi
80108023:	5f                   	pop    %edi
80108024:	5d                   	pop    %ebp
80108025:	c3                   	ret    
80108026:	8d 76 00             	lea    0x0(%esi),%esi
80108029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108030 <copyuvm_onwrite>:

pde_t*
copyuvm_onwrite(pde_t *pgdir, uint sz)
{
80108030:	55                   	push   %ebp
80108031:	89 e5                	mov    %esp,%ebp
80108033:	57                   	push   %edi
80108034:	56                   	push   %esi
80108035:	53                   	push   %ebx
80108036:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0) //建立页表项以建立内核空间映射
80108039:	e8 b2 f7 ff ff       	call   801077f0 <setupkvm>
8010803e:	85 c0                	test   %eax,%eax
80108040:	89 c7                	mov    %eax,%edi
80108042:	0f 84 8a 00 00 00    	je     801080d2 <copyuvm_onwrite+0xa2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){//在用户空间逐页处理
80108048:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010804b:	85 c9                	test   %ecx,%ecx
8010804d:	0f 84 7f 00 00 00    	je     801080d2 <copyuvm_onwrite+0xa2>
80108053:	31 db                	xor    %ebx,%ebx
80108055:	8d 76 00             	lea    0x0(%esi),%esi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)//获取该页的PTE
80108058:	8b 45 08             	mov    0x8(%ebp),%eax
8010805b:	31 c9                	xor    %ecx,%ecx
8010805d:	89 da                	mov    %ebx,%edx
8010805f:	e8 fc f4 ff ff       	call   80107560 <walkpgdir>
80108064:	85 c0                	test   %eax,%eax
80108066:	0f 84 f7 00 00 00    	je     80108163 <copyuvm_onwrite+0x133>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))//PTE未映射页帧
8010806c:	8b 10                	mov    (%eax),%edx
8010806e:	f6 c2 01             	test   $0x1,%dl
80108071:	0f 84 df 00 00 00    	je     80108156 <copyuvm_onwrite+0x126>
80108077:	89 d6                	mov    %edx,%esi
80108079:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
      panic("copyuvm: page not present");
    if(i>=3*PGSIZE){
8010807f:	81 fb ff 2f 00 00    	cmp    $0x2fff,%ebx
80108085:	76 59                	jbe    801080e0 <copyuvm_onwrite+0xb0>
        *pte=((*pte)&(~PTE_W));
80108087:	89 d1                	mov    %edx,%ecx
      if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)//将新页帧映射到i
        goto bad;
      cprintf("copy %p->%p\n",P2V(pa),mem);
    }
    else{
      mappages(d,(void*)i,PGSIZE,pa,flags);//将新页帧映射到i
80108089:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
8010808c:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
        *pte=((*pte)&(~PTE_W));
80108092:	83 e1 fd             	and    $0xfffffffd,%ecx
80108095:	89 08                	mov    %ecx,(%eax)
      mappages(d,(void*)i,PGSIZE,pa,flags);//将新页帧映射到i
80108097:	52                   	push   %edx
80108098:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010809d:	56                   	push   %esi
8010809e:	89 da                	mov    %ebx,%edx
801080a0:	89 f8                	mov    %edi,%eax
801080a2:	e8 39 f5 ff ff       	call   801075e0 <mappages>
      cprintf("lazy %p\n",P2V(pa));
801080a7:	59                   	pop    %ecx
801080a8:	58                   	pop    %eax
801080a9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801080af:	50                   	push   %eax
801080b0:	68 ca 8e 10 80       	push   $0x80108eca
801080b5:	e8 96 86 ff ff       	call   80100750 <cprintf>
      pageref_set(pa,1);//引用次数设置为1
801080ba:	58                   	pop    %eax
801080bb:	5a                   	pop    %edx
801080bc:	6a 01                	push   $0x1
801080be:	56                   	push   %esi
801080bf:	e8 9c a7 ff ff       	call   80102860 <pageref_set>
801080c4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE){//在用户空间逐页处理
801080c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801080cd:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
801080d0:	77 86                	ja     80108058 <copyuvm_onwrite+0x28>
  }
  return d;
bad:
  freevm(d);
  return 0;
}
801080d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080d5:	89 f8                	mov    %edi,%eax
801080d7:	5b                   	pop    %ebx
801080d8:	5e                   	pop    %esi
801080d9:	5f                   	pop    %edi
801080da:	5d                   	pop    %ebp
801080db:	c3                   	ret    
801080dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
801080e0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
801080e6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      if((mem = kalloc()) == 0)//分配一个新页帧
801080e9:	e8 92 a6 ff ff       	call   80102780 <kalloc>
801080ee:	85 c0                	test   %eax,%eax
801080f0:	74 51                	je     80108143 <copyuvm_onwrite+0x113>
      memmove(mem, (char*)P2V(pa), PGSIZE);//从父进程拷贝一个页
801080f2:	83 ec 04             	sub    $0x4,%esp
801080f5:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801080fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801080fe:	68 00 10 00 00       	push   $0x1000
80108103:	56                   	push   %esi
80108104:	50                   	push   %eax
80108105:	e8 a6 ce ff ff       	call   80104fb0 <memmove>
      if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)//将新页帧映射到i
8010810a:	58                   	pop    %eax
8010810b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010810e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108113:	5a                   	pop    %edx
80108114:	ff 75 e0             	pushl  -0x20(%ebp)
80108117:	89 da                	mov    %ebx,%edx
80108119:	05 00 00 00 80       	add    $0x80000000,%eax
8010811e:	50                   	push   %eax
8010811f:	89 f8                	mov    %edi,%eax
80108121:	e8 ba f4 ff ff       	call   801075e0 <mappages>
80108126:	83 c4 10             	add    $0x10,%esp
80108129:	85 c0                	test   %eax,%eax
8010812b:	78 16                	js     80108143 <copyuvm_onwrite+0x113>
      cprintf("copy %p->%p\n",P2V(pa),mem);
8010812d:	83 ec 04             	sub    $0x4,%esp
80108130:	ff 75 e4             	pushl  -0x1c(%ebp)
80108133:	56                   	push   %esi
80108134:	68 d3 8e 10 80       	push   $0x80108ed3
80108139:	e8 12 86 ff ff       	call   80100750 <cprintf>
8010813e:	83 c4 10             	add    $0x10,%esp
80108141:	eb 84                	jmp    801080c7 <copyuvm_onwrite+0x97>
  freevm(d);
80108143:	83 ec 0c             	sub    $0xc,%esp
80108146:	57                   	push   %edi
  return 0;
80108147:	31 ff                	xor    %edi,%edi
  freevm(d);
80108149:	e8 82 fa ff ff       	call   80107bd0 <freevm>
  return 0;
8010814e:	83 c4 10             	add    $0x10,%esp
80108151:	e9 7c ff ff ff       	jmp    801080d2 <copyuvm_onwrite+0xa2>
      panic("copyuvm: page not present");
80108156:	83 ec 0c             	sub    $0xc,%esp
80108159:	68 95 8e 10 80       	push   $0x80108e95
8010815e:	e8 1d 83 ff ff       	call   80100480 <panic>
      panic("copyuvm: pte should exist");
80108163:	83 ec 0c             	sub    $0xc,%esp
80108166:	68 7b 8e 10 80       	push   $0x80108e7b
8010816b:	e8 10 83 ff ff       	call   80100480 <panic>

80108170 <copy_on_write>:

//考虑引用次数为1时已经独享不用复制，减少物理页浪费
void copy_on_write(pde_t* pgdir,void* va){
80108170:	55                   	push   %ebp
  pte_t* pte=walkpgdir(pgdir,va,0);
80108171:	31 c9                	xor    %ecx,%ecx
void copy_on_write(pde_t* pgdir,void* va){
80108173:	89 e5                	mov    %esp,%ebp
80108175:	57                   	push   %edi
80108176:	56                   	push   %esi
80108177:	53                   	push   %ebx
80108178:	83 ec 1c             	sub    $0x1c,%esp
8010817b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010817e:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t* pte=walkpgdir(pgdir,va,0);
80108181:	89 f2                	mov    %esi,%edx
80108183:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108186:	e8 d5 f3 ff ff       	call   80107560 <walkpgdir>
  uint pa=PTE_ADDR(*pte);
8010818b:	8b 18                	mov    (%eax),%ebx
  uint ref=pageref_get(pa);
8010818d:	83 ec 0c             	sub    $0xc,%esp
  pte_t* pte=walkpgdir(pgdir,va,0);
80108190:	89 c7                	mov    %eax,%edi
  uint pa=PTE_ADDR(*pte);
80108192:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  uint ref=pageref_get(pa);
80108198:	53                   	push   %ebx
80108199:	e8 82 a6 ff ff       	call   80102820 <pageref_get>
  if(ref>1){//若引用次数大于1,则复制父进程页
8010819e:	83 c4 10             	add    $0x10,%esp
801081a1:	83 f8 01             	cmp    $0x1,%eax
801081a4:	76 62                	jbe    80108208 <copy_on_write+0x98>
    pageref_set(pa,-1);
801081a6:	83 ec 08             	sub    $0x8,%esp
801081a9:	6a ff                	push   $0xffffffff
801081ab:	53                   	push   %ebx
    char* mem=kalloc();
    memmove(mem,(char*)P2V(pa),PGSIZE);
801081ac:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    pageref_set(pa,-1);
801081b2:	e8 a9 a6 ff ff       	call   80102860 <pageref_set>
    char* mem=kalloc();
801081b7:	e8 c4 a5 ff ff       	call   80102780 <kalloc>
    memmove(mem,(char*)P2V(pa),PGSIZE);
801081bc:	83 c4 0c             	add    $0xc,%esp
    char* mem=kalloc();
801081bf:	89 c7                	mov    %eax,%edi
    memmove(mem,(char*)P2V(pa),PGSIZE);
801081c1:	68 00 10 00 00       	push   $0x1000
801081c6:	53                   	push   %ebx
801081c7:	50                   	push   %eax
801081c8:	e8 e3 cd ff ff       	call   80104fb0 <memmove>
    mappages(pgdir,va,PGSIZE,V2P(mem),PTE_W|PTE_U);
801081cd:	58                   	pop    %eax
801081ce:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801081d4:	b9 00 10 00 00       	mov    $0x1000,%ecx
801081d9:	5a                   	pop    %edx
801081da:	6a 06                	push   $0x6
801081dc:	50                   	push   %eax
801081dd:	89 f2                	mov    %esi,%edx
801081df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081e2:	e8 f9 f3 ff ff       	call   801075e0 <mappages>
    cprintf("copy on write! copy: %p ->%p\n",P2V(pa),mem);
801081e7:	83 c4 0c             	add    $0xc,%esp
801081ea:	57                   	push   %edi
801081eb:	53                   	push   %ebx
801081ec:	68 e0 8e 10 80       	push   $0x80108ee0
801081f1:	e8 5a 85 ff ff       	call   80100750 <cprintf>
801081f6:	83 c4 10             	add    $0x10,%esp
  }else{//否则不复制
    *pte=(*pte)|PTE_W;
    cprintf("page ref=1,remove write forbidden!\n");
  }
}
801081f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081fc:	5b                   	pop    %ebx
801081fd:	5e                   	pop    %esi
801081fe:	5f                   	pop    %edi
801081ff:	5d                   	pop    %ebp
80108200:	c3                   	ret    
80108201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *pte=(*pte)|PTE_W;
80108208:	83 0f 02             	orl    $0x2,(%edi)
    cprintf("page ref=1,remove write forbidden!\n");
8010820b:	c7 45 08 84 8f 10 80 	movl   $0x80108f84,0x8(%ebp)
}
80108212:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108215:	5b                   	pop    %ebx
80108216:	5e                   	pop    %esi
80108217:	5f                   	pop    %edi
80108218:	5d                   	pop    %ebp
    cprintf("page ref=1,remove write forbidden!\n");
80108219:	e9 32 85 ff ff       	jmp    80100750 <cprintf>
8010821e:	66 90                	xchg   %ax,%ax

80108220 <swapout>:

uint swapout(pde_t *pgdir,uint swap_start,uint sz){
80108220:	55                   	push   %ebp
80108221:	89 e5                	mov    %esp,%ebp
80108223:	57                   	push   %edi
80108224:	56                   	push   %esi
80108225:	53                   	push   %ebx
80108226:	83 ec 1c             	sub    $0x1c,%esp
  pte_t *pte;
  uint a=swap_start;
  a=PGROUNDDOWN(a);
80108229:	8b 5d 0c             	mov    0xc(%ebp),%ebx
uint swapout(pde_t *pgdir,uint swap_start,uint sz){
8010822c:	8b 75 10             	mov    0x10(%ebp),%esi
8010822f:	8b 7d 08             	mov    0x8(%ebp),%edi
  a=PGROUNDDOWN(a);
80108232:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

  for(;a<sz;a+=PGSIZE){
80108238:	39 f3                	cmp    %esi,%ebx
8010823a:	72 16                	jb     80108252 <swapout+0x32>
8010823c:	e9 8f 00 00 00       	jmp    801082d0 <swapout+0xb0>
80108241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108248:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010824e:	39 de                	cmp    %ebx,%esi
80108250:	76 7e                	jbe    801082d0 <swapout+0xb0>
    pte=walkpgdir(pgdir,(char*)a,0);
80108252:	31 c9                	xor    %ecx,%ecx
80108254:	89 da                	mov    %ebx,%edx
80108256:	89 f8                	mov    %edi,%eax
80108258:	e8 03 f3 ff ff       	call   80107560 <walkpgdir>
8010825d:	89 c2                	mov    %eax,%edx
    if((*pte & PTE_P)&&((*pte & PTE_SWAPPED)==0)){
8010825f:	8b 00                	mov    (%eax),%eax
80108261:	89 c1                	mov    %eax,%ecx
80108263:	81 e1 01 02 00 00    	and    $0x201,%ecx
80108269:	83 f9 01             	cmp    $0x1,%ecx
8010826c:	75 da                	jne    80108248 <swapout+0x28>
      uint pa=PTE_ADDR(*pte);
8010826e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108273:	89 55 e0             	mov    %edx,-0x20(%ebp)
80108276:	89 c6                	mov    %eax,%esi
      begin_op();
80108278:	e8 23 ad ff ff       	call   80102fa0 <begin_op>
      uint blockno=balloc8(1);
8010827d:	83 ec 0c             	sub    $0xc,%esp
80108280:	6a 01                	push   $0x1
80108282:	e8 09 9e ff ff       	call   80102090 <balloc8>
80108287:	89 c7                	mov    %eax,%edi
      end_op();
80108289:	e8 82 ad ff ff       	call   80103010 <end_op>
      write_page_to_disk(1,(char*)P2V(pa),blockno);
8010828e:	8d 8e 00 00 00 80    	lea    -0x80000000(%esi),%ecx
80108294:	83 c4 0c             	add    $0xc,%esp
80108297:	57                   	push   %edi
80108298:	51                   	push   %ecx
80108299:	6a 01                	push   $0x1
8010829b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010829e:	e8 4d 80 ff ff       	call   801002f0 <write_page_to_disk>
      *pte=(blockno<<12);
      *pte=(*pte)|PTE_SWAPPED|PTE_P;
801082a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("[swap out] va: %p --> block: %d, get free page pa: %p\n",
801082a6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      *pte=(blockno<<12);
801082a9:	89 f8                	mov    %edi,%eax
801082ab:	c1 e0 0c             	shl    $0xc,%eax
      *pte=(*pte)|PTE_SWAPPED|PTE_P;
801082ae:	0d 01 02 00 00       	or     $0x201,%eax
801082b3:	89 02                	mov    %eax,(%edx)
      cprintf("[swap out] va: %p --> block: %d, get free page pa: %p\n",
801082b5:	51                   	push   %ecx
801082b6:	57                   	push   %edi
801082b7:	53                   	push   %ebx
801082b8:	68 a8 8f 10 80       	push   $0x80108fa8
801082bd:	e8 8e 84 ff ff       	call   80100750 <cprintf>
        a,blockno,P2V(pa));
      return pa;
801082c2:	83 c4 20             	add    $0x20,%esp
    }
  }
  return 0;
}
801082c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082c8:	89 f0                	mov    %esi,%eax
801082ca:	5b                   	pop    %ebx
801082cb:	5e                   	pop    %esi
801082cc:	5f                   	pop    %edi
801082cd:	5d                   	pop    %ebp
801082ce:	c3                   	ret    
801082cf:	90                   	nop
801082d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801082d3:	31 f6                	xor    %esi,%esi
}
801082d5:	89 f0                	mov    %esi,%eax
801082d7:	5b                   	pop    %ebx
801082d8:	5e                   	pop    %esi
801082d9:	5f                   	pop    %edi
801082da:	5d                   	pop    %ebp
801082db:	c3                   	ret    
801082dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801082e0 <swapin>:

void swapin(char* pa,uint blockno){
801082e0:	55                   	push   %ebp
801082e1:	89 e5                	mov    %esp,%ebp
801082e3:	53                   	push   %ebx
801082e4:	83 ec 08             	sub    $0x8,%esp
  read_page_from_disk(1,P2V(pa),blockno);
801082e7:	8b 45 08             	mov    0x8(%ebp),%eax
void swapin(char* pa,uint blockno){
801082ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  read_page_from_disk(1,P2V(pa),blockno);
801082ed:	05 00 00 00 80       	add    $0x80000000,%eax
801082f2:	53                   	push   %ebx
801082f3:	50                   	push   %eax
801082f4:	6a 01                	push   $0x1
801082f6:	e8 85 7f ff ff       	call   80100280 <read_page_from_disk>
  bfree8(1,blockno);
801082fb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801082fe:	83 c4 10             	add    $0x10,%esp
80108301:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
80108308:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010830b:	c9                   	leave  
  bfree8(1,blockno);
8010830c:	e9 1f 9e ff ff       	jmp    80102130 <bfree8>
80108311:	eb 0d                	jmp    80108320 <pagefault>
80108313:	90                   	nop
80108314:	90                   	nop
80108315:	90                   	nop
80108316:	90                   	nop
80108317:	90                   	nop
80108318:	90                   	nop
80108319:	90                   	nop
8010831a:	90                   	nop
8010831b:	90                   	nop
8010831c:	90                   	nop
8010831d:	90                   	nop
8010831e:	90                   	nop
8010831f:	90                   	nop

80108320 <pagefault>:

void pagefault(pde_t *pgdir,void *va,uint swap_start,uint sz){
80108320:	55                   	push   %ebp
  va=(char*)PGROUNDDOWN((uint)va);
  pte_t* pte=walkpgdir(proc->pgdir,va,0);
80108321:	31 c9                	xor    %ecx,%ecx
void pagefault(pde_t *pgdir,void *va,uint swap_start,uint sz){
80108323:	89 e5                	mov    %esp,%ebp
80108325:	57                   	push   %edi
80108326:	56                   	push   %esi
80108327:	53                   	push   %ebx
80108328:	83 ec 1c             	sub    $0x1c,%esp
8010832b:	8b 45 08             	mov    0x8(%ebp),%eax
  va=(char*)PGROUNDDOWN((uint)va);
8010832e:	8b 75 0c             	mov    0xc(%ebp),%esi
void pagefault(pde_t *pgdir,void *va,uint swap_start,uint sz){
80108331:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108334:	8b 45 10             	mov    0x10(%ebp),%eax
  va=(char*)PGROUNDDOWN((uint)va);
80108337:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  pte_t* pte=walkpgdir(proc->pgdir,va,0);
8010833d:	89 f2                	mov    %esi,%edx
void pagefault(pde_t *pgdir,void *va,uint swap_start,uint sz){
8010833f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108342:	8b 45 14             	mov    0x14(%ebp),%eax
80108345:	89 45 d8             	mov    %eax,-0x28(%ebp)
  pte_t* pte=walkpgdir(proc->pgdir,va,0);
80108348:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010834e:	8b 40 04             	mov    0x4(%eax),%eax
80108351:	e8 0a f2 ff ff       	call   80107560 <walkpgdir>
  uint flags=PTE_FLAGS(*pte);
80108356:	8b 38                	mov    (%eax),%edi
80108358:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  char* mem=kalloc();
8010835b:	e8 20 a4 ff ff       	call   80102780 <kalloc>
  if(mem==0) mem=(char*)swapout(pgdir,swap_start,sz);
80108360:	85 c0                	test   %eax,%eax
80108362:	89 c3                	mov    %eax,%ebx
80108364:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108367:	74 77                	je     801083e0 <pagefault+0xc0>
  if(mem==0) panic("can not find swap page!\n");

  if(flags & PTE_SWAPPED){
80108369:	81 e7 00 02 00 00    	and    $0x200,%edi
8010836f:	74 2b                	je     8010839c <pagefault+0x7c>
    uint blockno=(*pte)>>12;
80108371:	8b 3a                	mov    (%edx),%edi
    swapin(mem,blockno);
80108373:	83 ec 08             	sub    $0x8,%esp
    uint blockno=(*pte)>>12;
80108376:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108379:	c1 ef 0c             	shr    $0xc,%edi
    swapin(mem,blockno);
8010837c:	57                   	push   %edi
8010837d:	53                   	push   %ebx
8010837e:	e8 5d ff ff ff       	call   801082e0 <swapin>
    *pte=(*pte)&(~PTE_SWAPPED);
80108383:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108386:	81 22 ff fd ff ff    	andl   $0xfffffdff,(%edx)
    cprintf("[swap in] block:%d --> va: %p,free block: %d\n",
8010838c:	57                   	push   %edi
8010838d:	56                   	push   %esi
8010838e:	57                   	push   %edi
8010838f:	68 e0 8f 10 80       	push   $0x80108fe0
80108394:	e8 b7 83 ff ff       	call   80100750 <cprintf>
80108399:	83 c4 20             	add    $0x20,%esp
      blockno,va,blockno);
  }
    mappages(proc->pgdir,va,PGSIZE,(uint)mem,PTE_W|PTE_U);
8010839c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083a2:	83 ec 08             	sub    $0x8,%esp
801083a5:	89 f2                	mov    %esi,%edx
801083a7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801083ac:	8b 40 04             	mov    0x4(%eax),%eax
801083af:	6a 06                	push   $0x6
801083b1:	53                   	push   %ebx
    cprintf("[pg fault] map va: %p to pa: %p\n",va,V2P(mem));
801083b2:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    mappages(proc->pgdir,va,PGSIZE,(uint)mem,PTE_W|PTE_U);
801083b8:	e8 23 f2 ff ff       	call   801075e0 <mappages>
    cprintf("[pg fault] map va: %p to pa: %p\n",va,V2P(mem));
801083bd:	89 5d 10             	mov    %ebx,0x10(%ebp)
801083c0:	89 75 0c             	mov    %esi,0xc(%ebp)
801083c3:	83 c4 10             	add    $0x10,%esp
801083c6:	c7 45 08 10 90 10 80 	movl   $0x80109010,0x8(%ebp)
801083cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083d0:	5b                   	pop    %ebx
801083d1:	5e                   	pop    %esi
801083d2:	5f                   	pop    %edi
801083d3:	5d                   	pop    %ebp
    cprintf("[pg fault] map va: %p to pa: %p\n",va,V2P(mem));
801083d4:	e9 77 83 ff ff       	jmp    80100750 <cprintf>
801083d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(mem==0) mem=(char*)swapout(pgdir,swap_start,sz);
801083e0:	83 ec 04             	sub    $0x4,%esp
801083e3:	ff 75 d8             	pushl  -0x28(%ebp)
801083e6:	ff 75 dc             	pushl  -0x24(%ebp)
801083e9:	ff 75 e0             	pushl  -0x20(%ebp)
801083ec:	e8 2f fe ff ff       	call   80108220 <swapout>
  if(mem==0) panic("can not find swap page!\n");
801083f1:	83 c4 10             	add    $0x10,%esp
801083f4:	85 c0                	test   %eax,%eax
  if(mem==0) mem=(char*)swapout(pgdir,swap_start,sz);
801083f6:	89 c3                	mov    %eax,%ebx
  if(mem==0) panic("can not find swap page!\n");
801083f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801083fb:	0f 85 68 ff ff ff    	jne    80108369 <pagefault+0x49>
80108401:	83 ec 0c             	sub    $0xc,%esp
80108404:	68 fe 8e 10 80       	push   $0x80108efe
80108409:	e8 72 80 ff ff       	call   80100480 <panic>
