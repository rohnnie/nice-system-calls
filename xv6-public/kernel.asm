
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc e0 b5 10 80       	mov    $0x8010b5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 2e 10 80       	mov    $0x80102e70,%eax
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
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 60 71 10 	movl   $0x80107160,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010005b:	e8 f0 44 00 00       	call   80104550 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 67 71 10 	movl   $0x80107167,0x4(%esp)
8010009b:	80 
8010009c:	e8 9f 43 00 00       	call   80104440 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 e5 44 00 00       	call   801045d0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000f1:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100161:	e8 9a 45 00 00       	call   80104700 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 0f 43 00 00       	call   80104480 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 92 1f 00 00       	call   80102110 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 6e 71 10 80 	movl   $0x8010716e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 6b 43 00 00       	call   80104520 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 47 1f 00 00       	jmp    80102110 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 7f 71 10 80 	movl   $0x8010717f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 2a 43 00 00       	call   80104520 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 de 42 00 00       	call   801044e0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100209:	e8 c2 43 00 00       	call   801045d0 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 ab 44 00 00       	jmp    80104700 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 86 71 10 80 	movl   $0x80107186,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 f9 14 00 00       	call   80101780 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 3d 43 00 00       	call   801045d0 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 26                	jmp    801002c9 <consoleread+0x59>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(proc->killed){
801002a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002ae:	8b 40 24             	mov    0x24(%eax),%eax
801002b1:	85 c0                	test   %eax,%eax
801002b3:	75 73                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b5:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bc:	80 
801002bd:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
801002c4:	e8 17 3c 00 00       	call   80103ee0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c9:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002ce:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d4:	74 d2                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d6:	8d 50 01             	lea    0x1(%eax),%edx
801002d9:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
801002df:	89 c2                	mov    %eax,%edx
801002e1:	83 e2 7f             	and    $0x7f,%edx
801002e4:	0f b6 8a 40 ff 10 80 	movzbl -0x7fef00c0(%edx),%ecx
801002eb:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ee:	83 fa 04             	cmp    $0x4,%edx
801002f1:	74 56                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f3:	83 c6 01             	add    $0x1,%esi
    --n;
801002f6:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f9:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fc:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002ff:	74 52                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100301:	85 db                	test   %ebx,%ebx
80100303:	75 c4                	jne    801002c9 <consoleread+0x59>
80100305:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100308:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100312:	e8 e9 43 00 00       	call   80104700 <release>
  ilock(ip);
80100317:	89 3c 24             	mov    %edi,(%esp)
8010031a:	e8 91 13 00 00       	call   801016b0 <ilock>
8010031f:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100322:	eb 1d                	jmp    80100341 <consoleread+0xd1>
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 cc 43 00 00       	call   80104700 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 74 13 00 00       	call   801016b0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ae                	jmp    80100308 <consoleread+0x98>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb aa                	jmp    80100308 <consoleread+0x98>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100369:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
8010036f:	8d 5d d0             	lea    -0x30(%ebp),%ebx
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100372:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100379:	00 00 00 
8010037c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010037f:	0f b6 00             	movzbl (%eax),%eax
80100382:	c7 04 24 8d 71 10 80 	movl   $0x8010718d,(%esp)
80100389:	89 44 24 04          	mov    %eax,0x4(%esp)
8010038d:	e8 be 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
80100392:	8b 45 08             	mov    0x8(%ebp),%eax
80100395:	89 04 24             	mov    %eax,(%esp)
80100398:	e8 b3 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
8010039d:	c7 04 24 86 76 10 80 	movl   $0x80107686,(%esp)
801003a4:	e8 a7 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a9:	8d 45 08             	lea    0x8(%ebp),%eax
801003ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003b0:	89 04 24             	mov    %eax,(%esp)
801003b3:	e8 b8 41 00 00       	call   80104570 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 a9 71 10 80 	movl   $0x801071a9,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 a2 58 00 00       	call   80105cb0 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 f2 57 00 00       	call   80105cb0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 e6 57 00 00       	call   80105cb0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 da 57 00 00       	call   80105cb0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 ef 42 00 00       	call   801047f0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 32 42 00 00       	call   80104750 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 ad 71 10 80 	movl   $0x801071ad,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 d8 71 10 80 	movzbl -0x7fef8e28(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 79 11 00 00       	call   80101780 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 bd 3f 00 00       	call   801045d0 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 c5 40 00 00       	call   80104700 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 6a 10 00 00       	call   801016b0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 08 40 00 00       	call   80104700 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 c0 71 10 80       	mov    $0x801071c0,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 34 3e 00 00       	call   801045d0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 c7 71 10 80 	movl   $0x801071c7,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 06 3e 00 00       	call   801045d0 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801007f7:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 d4 3e 00 00       	call   80104700 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d c0 ff 10 80    	mov    0x8010ffc0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801008b2:	e8 c9 37 00 00       	call   80104080 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008c5:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008ec:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 34 38 00 00       	jmp    80104160 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 d0 71 10 	movl   $0x801071d0,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 e6 3b 00 00       	call   80104550 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
8010096a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100971:	c7 05 8c 09 11 80 f0 	movl   $0x801005f0,0x8011098c
80100978:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010097b:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
80100982:	02 10 80 
  cons.locking = 1;
80100985:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
8010098c:	00 00 00 

  picenable(IRQ_KBD);
8010098f:	e8 7c 28 00 00       	call   80103210 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100994:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010099b:	00 
8010099c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801009a3:	e8 f8 18 00 00       	call   801022a0 <ioapicenable>
}
801009a8:	c9                   	leave  
801009a9:	c3                   	ret    
801009aa:	66 90                	xchg   %ax,%ax
801009ac:	66 90                	xchg   %ax,%ax
801009ae:	66 90                	xchg   %ax,%ax

801009b0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009b0:	55                   	push   %ebp
801009b1:	89 e5                	mov    %esp,%ebp
801009b3:	57                   	push   %edi
801009b4:	56                   	push   %esi
801009b5:	53                   	push   %ebx
801009b6:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009bc:	e8 df 21 00 00       	call   80102ba0 <begin_op>

  if((ip = namei(path)) == 0){
801009c1:	8b 45 08             	mov    0x8(%ebp),%eax
801009c4:	89 04 24             	mov    %eax,(%esp)
801009c7:	e8 14 15 00 00       	call   80101ee0 <namei>
801009cc:	85 c0                	test   %eax,%eax
801009ce:	89 c3                	mov    %eax,%ebx
801009d0:	74 37                	je     80100a09 <exec+0x59>
    end_op();
    return -1;
  }
  ilock(ip);
801009d2:	89 04 24             	mov    %eax,(%esp)
801009d5:	e8 d6 0c 00 00       	call   801016b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
801009da:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009e0:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e7:	00 
801009e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ef:	00 
801009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f4:	89 1c 24             	mov    %ebx,(%esp)
801009f7:	e8 44 0f 00 00       	call   80101940 <readi>
801009fc:	83 f8 33             	cmp    $0x33,%eax
801009ff:	77 1f                	ja     80100a20 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a01:	89 1c 24             	mov    %ebx,(%esp)
80100a04:	e8 e7 0e 00 00       	call   801018f0 <iunlockput>
    end_op();
80100a09:	e8 02 22 00 00       	call   80102c10 <end_op>
  }
  return -1;
80100a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a13:	81 c4 1c 01 00 00    	add    $0x11c,%esp
80100a19:	5b                   	pop    %ebx
80100a1a:	5e                   	pop    %esi
80100a1b:	5f                   	pop    %edi
80100a1c:	5d                   	pop    %ebp
80100a1d:	c3                   	ret    
80100a1e:	66 90                	xchg   %ax,%ax
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d5                	jne    80100a01 <exec+0x51>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 ff 60 00 00       	call   80106b30 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a39:	74 c6                	je     80100a01 <exec+0x51>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a49:	0f 84 cc 02 00 00    	je     80100d1b <exec+0x36b>

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a4f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a56:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xc5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x183>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 ad 0e 00 00       	call   80101940 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x170>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x170>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x170>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 f9 62 00 00       	call   80106dd0 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x170>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x170>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 f8 61 00 00       	call   80106d10 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xb0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 b2 63 00 00       	call   80106ee0 <freevm>
80100b2e:	e9 ce fe ff ff       	jmp    80100a01 <exec+0x51>
80100b33:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100b39:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100b3f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80100b45:	8d be 00 20 00 00    	lea    0x2000(%esi),%edi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b4b:	89 1c 24             	mov    %ebx,(%esp)
80100b4e:	e8 9d 0d 00 00       	call   801018f0 <iunlockput>
  end_op();
80100b53:	e8 b8 20 00 00       	call   80102c10 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b58:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b5e:	89 7c 24 08          	mov    %edi,0x8(%esp)
80100b62:	89 74 24 04          	mov    %esi,0x4(%esp)
80100b66:	89 04 24             	mov    %eax,(%esp)
80100b69:	e8 62 62 00 00       	call   80106dd0 <allocuvm>
80100b6e:	85 c0                	test   %eax,%eax
80100b70:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b76:	75 18                	jne    80100b90 <exec+0x1e0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b78:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b7e:	89 04 24             	mov    %eax,(%esp)
80100b81:	e8 5a 63 00 00       	call   80106ee0 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8b:	e9 83 fe ff ff       	jmp    80100a13 <exec+0x63>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b90:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100b96:	89 d8                	mov    %ebx,%eax
80100b98:	2d 00 20 00 00       	sub    $0x2000,%eax
80100b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ba1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100ba7:	89 04 24             	mov    %eax,(%esp)
80100baa:	e8 b1 63 00 00       	call   80106f60 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100baf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb2:	8b 00                	mov    (%eax),%eax
80100bb4:	85 c0                	test   %eax,%eax
80100bb6:	0f 84 6b 01 00 00    	je     80100d27 <exec+0x377>
80100bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bbf:	31 f6                	xor    %esi,%esi
80100bc1:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100bc4:	83 c1 04             	add    $0x4,%ecx
80100bc7:	eb 0f                	jmp    80100bd8 <exec+0x228>
80100bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bd0:	83 c1 04             	add    $0x4,%ecx
    if(argc >= MAXARG)
80100bd3:	83 fe 20             	cmp    $0x20,%esi
80100bd6:	74 a0                	je     80100b78 <exec+0x1c8>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bd8:	89 04 24             	mov    %eax,(%esp)
80100bdb:	89 8d f0 fe ff ff    	mov    %ecx,-0x110(%ebp)
80100be1:	e8 8a 3d 00 00       	call   80104970 <strlen>
80100be6:	f7 d0                	not    %eax
80100be8:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bea:	8b 07                	mov    (%edi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bec:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bef:	89 04 24             	mov    %eax,(%esp)
80100bf2:	e8 79 3d 00 00       	call   80104970 <strlen>
80100bf7:	83 c0 01             	add    $0x1,%eax
80100bfa:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bfe:	8b 07                	mov    (%edi),%eax
80100c00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c04:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c08:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c0e:	89 04 24             	mov    %eax,(%esp)
80100c11:	e8 aa 64 00 00       	call   801070c0 <copyout>
80100c16:	85 c0                	test   %eax,%eax
80100c18:	0f 88 5a ff ff ff    	js     80100b78 <exec+0x1c8>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c1e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c24:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c2a:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c31:	83 c6 01             	add    $0x1,%esi
80100c34:	8b 01                	mov    (%ecx),%eax
80100c36:	89 cf                	mov    %ecx,%edi
80100c38:	85 c0                	test   %eax,%eax
80100c3a:	75 94                	jne    80100bd0 <exec+0x220>
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c3c:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c43:	89 d9                	mov    %ebx,%ecx
80100c45:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c47:	83 c0 0c             	add    $0xc,%eax
80100c4a:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c4c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c50:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c56:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c5e:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c65:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c69:	89 04 24             	mov    %eax,(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c6c:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c73:	ff ff ff 
  ustack[1] = argc;
80100c76:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c7c:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c82:	e8 39 64 00 00       	call   801070c0 <copyout>
80100c87:	85 c0                	test   %eax,%eax
80100c89:	0f 88 e9 fe ff ff    	js     80100b78 <exec+0x1c8>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c8f:	8b 45 08             	mov    0x8(%ebp),%eax
80100c92:	0f b6 10             	movzbl (%eax),%edx
80100c95:	84 d2                	test   %dl,%dl
80100c97:	74 19                	je     80100cb2 <exec+0x302>
80100c99:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c9c:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100c9f:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ca2:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ca5:	0f 44 c8             	cmove  %eax,%ecx
80100ca8:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cab:	84 d2                	test   %dl,%dl
80100cad:	75 f0                	jne    80100c9f <exec+0x2ef>
80100caf:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cb2:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cbc:	00 
80100cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cc7:	83 c0 6c             	add    $0x6c,%eax
80100cca:	89 04 24             	mov    %eax,(%esp)
80100ccd:	e8 5e 3c 00 00       	call   80104930 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cd2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100cd8:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cde:	8b 70 04             	mov    0x4(%eax),%esi
  proc->pgdir = pgdir;
80100ce1:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
80100ce4:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100cea:	89 08                	mov    %ecx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100cec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cf2:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100cf8:	8b 50 18             	mov    0x18(%eax),%edx
80100cfb:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100cfe:	8b 50 18             	mov    0x18(%eax),%edx
80100d01:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d04:	89 04 24             	mov    %eax,(%esp)
80100d07:	e8 e4 5e 00 00       	call   80106bf0 <switchuvm>
  freevm(oldpgdir);
80100d0c:	89 34 24             	mov    %esi,(%esp)
80100d0f:	e8 cc 61 00 00       	call   80106ee0 <freevm>
  return 0;
80100d14:	31 c0                	xor    %eax,%eax
80100d16:	e9 f8 fc ff ff       	jmp    80100a13 <exec+0x63>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d1b:	bf 00 20 00 00       	mov    $0x2000,%edi
80100d20:	31 f6                	xor    %esi,%esi
80100d22:	e9 24 fe ff ff       	jmp    80100b4b <exec+0x19b>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d27:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100d2d:	31 f6                	xor    %esi,%esi
80100d2f:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d35:	e9 02 ff ff ff       	jmp    80100c3c <exec+0x28c>
80100d3a:	66 90                	xchg   %ax,%ax
80100d3c:	66 90                	xchg   %ax,%ax
80100d3e:	66 90                	xchg   %ax,%ax

80100d40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d46:	c7 44 24 04 e9 71 10 	movl   $0x801071e9,0x4(%esp)
80100d4d:	80 
80100d4e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100d55:	e8 f6 37 00 00       	call   80104550 <initlock>
}
80100d5a:	c9                   	leave  
80100d5b:	c3                   	ret    
80100d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d64:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d69:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d6c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100d73:	e8 58 38 00 00       	call   801045d0 <acquire>
80100d78:	eb 11                	jmp    80100d8b <filealloc+0x2b>
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d80:	83 c3 18             	add    $0x18,%ebx
80100d83:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100d89:	74 25                	je     80100db0 <filealloc+0x50>
    if(f->ref == 0){
80100d8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d8e:	85 c0                	test   %eax,%eax
80100d90:	75 ee                	jne    80100d80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d92:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d99:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100da0:	e8 5b 39 00 00       	call   80104700 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100da5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100da8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100daa:	5b                   	pop    %ebx
80100dab:	5d                   	pop    %ebp
80100dac:	c3                   	ret    
80100dad:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100db0:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100db7:	e8 44 39 00 00       	call   80104700 <release>
  return 0;
}
80100dbc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100dbf:	31 c0                	xor    %eax,%eax
}
80100dc1:	5b                   	pop    %ebx
80100dc2:	5d                   	pop    %ebp
80100dc3:	c3                   	ret    
80100dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100dd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	53                   	push   %ebx
80100dd4:	83 ec 14             	sub    $0x14,%esp
80100dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dda:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100de1:	e8 ea 37 00 00       	call   801045d0 <acquire>
  if(f->ref < 1)
80100de6:	8b 43 04             	mov    0x4(%ebx),%eax
80100de9:	85 c0                	test   %eax,%eax
80100deb:	7e 1a                	jle    80100e07 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100ded:	83 c0 01             	add    $0x1,%eax
80100df0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100df3:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100dfa:	e8 01 39 00 00       	call   80104700 <release>
  return f;
}
80100dff:	83 c4 14             	add    $0x14,%esp
80100e02:	89 d8                	mov    %ebx,%eax
80100e04:	5b                   	pop    %ebx
80100e05:	5d                   	pop    %ebp
80100e06:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e07:	c7 04 24 f0 71 10 80 	movl   $0x801071f0,(%esp)
80100e0e:	e8 4d f5 ff ff       	call   80100360 <panic>
80100e13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e20 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	57                   	push   %edi
80100e24:	56                   	push   %esi
80100e25:	53                   	push   %ebx
80100e26:	83 ec 1c             	sub    $0x1c,%esp
80100e29:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e2c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e33:	e8 98 37 00 00       	call   801045d0 <acquire>
  if(f->ref < 1)
80100e38:	8b 57 04             	mov    0x4(%edi),%edx
80100e3b:	85 d2                	test   %edx,%edx
80100e3d:	0f 8e 89 00 00 00    	jle    80100ecc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e43:	83 ea 01             	sub    $0x1,%edx
80100e46:	85 d2                	test   %edx,%edx
80100e48:	89 57 04             	mov    %edx,0x4(%edi)
80100e4b:	74 13                	je     80100e60 <fileclose+0x40>
    release(&ftable.lock);
80100e4d:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e54:	83 c4 1c             	add    $0x1c,%esp
80100e57:	5b                   	pop    %ebx
80100e58:	5e                   	pop    %esi
80100e59:	5f                   	pop    %edi
80100e5a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e5b:	e9 a0 38 00 00       	jmp    80104700 <release>
    return;
  }
  ff = *f;
80100e60:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e64:	8b 37                	mov    (%edi),%esi
80100e66:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e69:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e6f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e72:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e75:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7f:	e8 7c 38 00 00       	call   80104700 <release>

  if(ff.type == FD_PIPE)
80100e84:	83 fe 01             	cmp    $0x1,%esi
80100e87:	74 0f                	je     80100e98 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e89:	83 fe 02             	cmp    $0x2,%esi
80100e8c:	74 22                	je     80100eb0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e8e:	83 c4 1c             	add    $0x1c,%esp
80100e91:	5b                   	pop    %ebx
80100e92:	5e                   	pop    %esi
80100e93:	5f                   	pop    %edi
80100e94:	5d                   	pop    %ebp
80100e95:	c3                   	ret    
80100e96:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e98:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e9c:	89 1c 24             	mov    %ebx,(%esp)
80100e9f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ea3:	e8 18 25 00 00       	call   801033c0 <pipeclose>
80100ea8:	eb e4                	jmp    80100e8e <fileclose+0x6e>
80100eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100eb0:	e8 eb 1c 00 00       	call   80102ba0 <begin_op>
    iput(ff.ip);
80100eb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100eb8:	89 04 24             	mov    %eax,(%esp)
80100ebb:	e8 00 09 00 00       	call   801017c0 <iput>
    end_op();
  }
}
80100ec0:	83 c4 1c             	add    $0x1c,%esp
80100ec3:	5b                   	pop    %ebx
80100ec4:	5e                   	pop    %esi
80100ec5:	5f                   	pop    %edi
80100ec6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ec7:	e9 44 1d 00 00       	jmp    80102c10 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ecc:	c7 04 24 f8 71 10 80 	movl   $0x801071f8,(%esp)
80100ed3:	e8 88 f4 ff ff       	call   80100360 <panic>
80100ed8:	90                   	nop
80100ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	53                   	push   %ebx
80100ee4:	83 ec 14             	sub    $0x14,%esp
80100ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100eed:	75 31                	jne    80100f20 <filestat+0x40>
    ilock(f->ip);
80100eef:	8b 43 10             	mov    0x10(%ebx),%eax
80100ef2:	89 04 24             	mov    %eax,(%esp)
80100ef5:	e8 b6 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100efa:	8b 45 0c             	mov    0xc(%ebp),%eax
80100efd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f01:	8b 43 10             	mov    0x10(%ebx),%eax
80100f04:	89 04 24             	mov    %eax,(%esp)
80100f07:	e8 04 0a 00 00       	call   80101910 <stati>
    iunlock(f->ip);
80100f0c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f0f:	89 04 24             	mov    %eax,(%esp)
80100f12:	e8 69 08 00 00       	call   80101780 <iunlock>
    return 0;
  }
  return -1;
}
80100f17:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f1a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f1c:	5b                   	pop    %ebx
80100f1d:	5d                   	pop    %ebp
80100f1e:	c3                   	ret    
80100f1f:	90                   	nop
80100f20:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f28:	5b                   	pop    %ebx
80100f29:	5d                   	pop    %ebp
80100f2a:	c3                   	ret    
80100f2b:	90                   	nop
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
80100f36:	83 ec 1c             	sub    $0x1c,%esp
80100f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f42:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f46:	74 68                	je     80100fb0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f48:	8b 03                	mov    (%ebx),%eax
80100f4a:	83 f8 01             	cmp    $0x1,%eax
80100f4d:	74 49                	je     80100f98 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f4f:	83 f8 02             	cmp    $0x2,%eax
80100f52:	75 63                	jne    80100fb7 <fileread+0x87>
    ilock(f->ip);
80100f54:	8b 43 10             	mov    0x10(%ebx),%eax
80100f57:	89 04 24             	mov    %eax,(%esp)
80100f5a:	e8 51 07 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f5f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f63:	8b 43 14             	mov    0x14(%ebx),%eax
80100f66:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f6a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f6e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f71:	89 04 24             	mov    %eax,(%esp)
80100f74:	e8 c7 09 00 00       	call   80101940 <readi>
80100f79:	85 c0                	test   %eax,%eax
80100f7b:	89 c6                	mov    %eax,%esi
80100f7d:	7e 03                	jle    80100f82 <fileread+0x52>
      f->off += r;
80100f7f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f82:	8b 43 10             	mov    0x10(%ebx),%eax
80100f85:	89 04 24             	mov    %eax,(%esp)
80100f88:	e8 f3 07 00 00       	call   80101780 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f8f:	83 c4 1c             	add    $0x1c,%esp
80100f92:	5b                   	pop    %ebx
80100f93:	5e                   	pop    %esi
80100f94:	5f                   	pop    %edi
80100f95:	5d                   	pop    %ebp
80100f96:	c3                   	ret    
80100f97:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f98:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f9b:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f9e:	83 c4 1c             	add    $0x1c,%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa5:	e9 c6 25 00 00       	jmp    80103570 <piperead>
80100faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fb5:	eb d8                	jmp    80100f8f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fb7:	c7 04 24 02 72 10 80 	movl   $0x80107202,(%esp)
80100fbe:	e8 9d f3 ff ff       	call   80100360 <panic>
80100fc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fd0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 2c             	sub    $0x2c,%esp
80100fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fdc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fdf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fe2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fe5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fec:	0f 84 ae 00 00 00    	je     801010a0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100ff2:	8b 07                	mov    (%edi),%eax
80100ff4:	83 f8 01             	cmp    $0x1,%eax
80100ff7:	0f 84 c2 00 00 00    	je     801010bf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ffd:	83 f8 02             	cmp    $0x2,%eax
80101000:	0f 85 d7 00 00 00    	jne    801010dd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101009:	31 db                	xor    %ebx,%ebx
8010100b:	85 c0                	test   %eax,%eax
8010100d:	7f 31                	jg     80101040 <filewrite+0x70>
8010100f:	e9 9c 00 00 00       	jmp    801010b0 <filewrite+0xe0>
80101014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101018:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010101b:	01 47 14             	add    %eax,0x14(%edi)
8010101e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101021:	89 0c 24             	mov    %ecx,(%esp)
80101024:	e8 57 07 00 00       	call   80101780 <iunlock>
      end_op();
80101029:	e8 e2 1b 00 00       	call   80102c10 <end_op>
8010102e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101031:	39 f0                	cmp    %esi,%eax
80101033:	0f 85 98 00 00 00    	jne    801010d1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101039:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010103b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010103e:	7e 70                	jle    801010b0 <filewrite+0xe0>
      int n1 = n - i;
80101040:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101043:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101048:	29 de                	sub    %ebx,%esi
8010104a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101050:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101053:	e8 48 1b 00 00       	call   80102ba0 <begin_op>
      ilock(f->ip);
80101058:	8b 47 10             	mov    0x10(%edi),%eax
8010105b:	89 04 24             	mov    %eax,(%esp)
8010105e:	e8 4d 06 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101063:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101067:	8b 47 14             	mov    0x14(%edi),%eax
8010106a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010106e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101071:	01 d8                	add    %ebx,%eax
80101073:	89 44 24 04          	mov    %eax,0x4(%esp)
80101077:	8b 47 10             	mov    0x10(%edi),%eax
8010107a:	89 04 24             	mov    %eax,(%esp)
8010107d:	e8 be 09 00 00       	call   80101a40 <writei>
80101082:	85 c0                	test   %eax,%eax
80101084:	7f 92                	jg     80101018 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101086:	8b 4f 10             	mov    0x10(%edi),%ecx
80101089:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010108c:	89 0c 24             	mov    %ecx,(%esp)
8010108f:	e8 ec 06 00 00       	call   80101780 <iunlock>
      end_op();
80101094:	e8 77 1b 00 00       	call   80102c10 <end_op>

      if(r < 0)
80101099:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010109c:	85 c0                	test   %eax,%eax
8010109e:	74 91                	je     80101031 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010a0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010a8:	5b                   	pop    %ebx
801010a9:	5e                   	pop    %esi
801010aa:	5f                   	pop    %edi
801010ab:	5d                   	pop    %ebp
801010ac:	c3                   	ret    
801010ad:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010b0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010b3:	89 d8                	mov    %ebx,%eax
801010b5:	75 e9                	jne    801010a0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010b7:	83 c4 2c             	add    $0x2c,%esp
801010ba:	5b                   	pop    %ebx
801010bb:	5e                   	pop    %esi
801010bc:	5f                   	pop    %edi
801010bd:	5d                   	pop    %ebp
801010be:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bf:	8b 47 0c             	mov    0xc(%edi),%eax
801010c2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c5:	83 c4 2c             	add    $0x2c,%esp
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cc:	e9 7f 23 00 00       	jmp    80103450 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010d1:	c7 04 24 0b 72 10 80 	movl   $0x8010720b,(%esp)
801010d8:	e8 83 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010dd:	c7 04 24 11 72 10 80 	movl   $0x80107211,(%esp)
801010e4:	e8 77 f2 ff ff       	call   80100360 <panic>
801010e9:	66 90                	xchg   %ax,%ax
801010eb:	66 90                	xchg   %ax,%ax
801010ed:	66 90                	xchg   %ax,%ax
801010ef:	90                   	nop

801010f0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	57                   	push   %edi
801010f4:	56                   	push   %esi
801010f5:	53                   	push   %ebx
801010f6:	83 ec 2c             	sub    $0x2c,%esp
801010f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010fc:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101101:	85 c0                	test   %eax,%eax
80101103:	0f 84 8c 00 00 00    	je     80101195 <balloc+0xa5>
80101109:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101110:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101113:	89 f0                	mov    %esi,%eax
80101115:	c1 f8 0c             	sar    $0xc,%eax
80101118:	03 05 f8 09 11 80    	add    0x801109f8,%eax
8010111e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101122:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101125:	89 04 24             	mov    %eax,(%esp)
80101128:	e8 a3 ef ff ff       	call   801000d0 <bread>
8010112d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101130:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101135:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101138:	31 c0                	xor    %eax,%eax
8010113a:	eb 33                	jmp    8010116f <balloc+0x7f>
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101140:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101143:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101145:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101147:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010114a:	83 e1 07             	and    $0x7,%ecx
8010114d:	bf 01 00 00 00       	mov    $0x1,%edi
80101152:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101154:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101159:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115b:	0f b6 fb             	movzbl %bl,%edi
8010115e:	85 cf                	test   %ecx,%edi
80101160:	74 46                	je     801011a8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101162:	83 c0 01             	add    $0x1,%eax
80101165:	83 c6 01             	add    $0x1,%esi
80101168:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010116d:	74 05                	je     80101174 <balloc+0x84>
8010116f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101172:	72 cc                	jb     80101140 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101177:	89 04 24             	mov    %eax,(%esp)
8010117a:	e8 61 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010117f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101186:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101189:	3b 05 e0 09 11 80    	cmp    0x801109e0,%eax
8010118f:	0f 82 7b ff ff ff    	jb     80101110 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101195:	c7 04 24 1b 72 10 80 	movl   $0x8010721b,(%esp)
8010119c:	e8 bf f1 ff ff       	call   80100360 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011a8:	09 d9                	or     %ebx,%ecx
801011aa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011ad:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011b1:	89 1c 24             	mov    %ebx,(%esp)
801011b4:	e8 87 1b 00 00       	call   80102d40 <log_write>
        brelse(bp);
801011b9:	89 1c 24             	mov    %ebx,(%esp)
801011bc:	e8 1f f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011c4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011c8:	89 04 24             	mov    %eax,(%esp)
801011cb:	e8 00 ef ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011d0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011d7:	00 
801011d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011df:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011e0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011e5:	89 04 24             	mov    %eax,(%esp)
801011e8:	e8 63 35 00 00       	call   80104750 <memset>
  log_write(bp);
801011ed:	89 1c 24             	mov    %ebx,(%esp)
801011f0:	e8 4b 1b 00 00       	call   80102d40 <log_write>
  brelse(bp);
801011f5:	89 1c 24             	mov    %ebx,(%esp)
801011f8:	e8 e3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fd:	83 c4 2c             	add    $0x2c,%esp
80101200:	89 f0                	mov    %esi,%eax
80101202:	5b                   	pop    %ebx
80101203:	5e                   	pop    %esi
80101204:	5f                   	pop    %edi
80101205:	5d                   	pop    %ebp
80101206:	c3                   	ret    
80101207:	89 f6                	mov    %esi,%esi
80101209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	89 c7                	mov    %eax,%edi
80101216:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101217:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101219:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101222:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101229:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010122c:	e8 9f 33 00 00       	call   801045d0 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101231:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101234:	eb 14                	jmp    8010124a <iget+0x3a>
80101236:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101238:	85 f6                	test   %esi,%esi
8010123a:	74 3c                	je     80101278 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101242:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101248:	74 46                	je     80101290 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010124a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010124d:	85 c9                	test   %ecx,%ecx
8010124f:	7e e7                	jle    80101238 <iget+0x28>
80101251:	39 3b                	cmp    %edi,(%ebx)
80101253:	75 e3                	jne    80101238 <iget+0x28>
80101255:	39 53 04             	cmp    %edx,0x4(%ebx)
80101258:	75 de                	jne    80101238 <iget+0x28>
      ip->ref++;
8010125a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010125d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010125f:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101266:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101269:	e8 92 34 00 00       	call   80104700 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010126e:	83 c4 1c             	add    $0x1c,%esp
80101271:	89 f0                	mov    %esi,%eax
80101273:	5b                   	pop    %ebx
80101274:	5e                   	pop    %esi
80101275:	5f                   	pop    %edi
80101276:	5d                   	pop    %ebp
80101277:	c3                   	ret    
80101278:	85 c9                	test   %ecx,%ecx
8010127a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010127d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101283:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101289:	75 bf                	jne    8010124a <iget+0x3a>
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101290:	85 f6                	test   %esi,%esi
80101292:	74 29                	je     801012bd <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101294:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101296:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101299:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801012a0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012a7:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801012ae:	e8 4d 34 00 00       	call   80104700 <release>

  return ip;
}
801012b3:	83 c4 1c             	add    $0x1c,%esp
801012b6:	89 f0                	mov    %esi,%eax
801012b8:	5b                   	pop    %ebx
801012b9:	5e                   	pop    %esi
801012ba:	5f                   	pop    %edi
801012bb:	5d                   	pop    %ebp
801012bc:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012bd:	c7 04 24 31 72 10 80 	movl   $0x80107231,(%esp)
801012c4:	e8 97 f0 ff ff       	call   80100360 <panic>
801012c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012d0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	89 c3                	mov    %eax,%ebx
801012d8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012db:	83 fa 0b             	cmp    $0xb,%edx
801012de:	77 18                	ja     801012f8 <bmap+0x28>
801012e0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012e3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012e6:	85 c0                	test   %eax,%eax
801012e8:	74 66                	je     80101350 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012ea:	83 c4 1c             	add    $0x1c,%esp
801012ed:	5b                   	pop    %ebx
801012ee:	5e                   	pop    %esi
801012ef:	5f                   	pop    %edi
801012f0:	5d                   	pop    %ebp
801012f1:	c3                   	ret    
801012f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012f8:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
801012fb:	83 fe 7f             	cmp    $0x7f,%esi
801012fe:	77 77                	ja     80101377 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101300:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101306:	85 c0                	test   %eax,%eax
80101308:	74 5e                	je     80101368 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010130a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010130e:	8b 03                	mov    (%ebx),%eax
80101310:	89 04 24             	mov    %eax,(%esp)
80101313:	e8 b8 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101318:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010131e:	8b 32                	mov    (%edx),%esi
80101320:	85 f6                	test   %esi,%esi
80101322:	75 19                	jne    8010133d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101324:	8b 03                	mov    (%ebx),%eax
80101326:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101329:	e8 c2 fd ff ff       	call   801010f0 <balloc>
8010132e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101331:	89 02                	mov    %eax,(%edx)
80101333:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101335:	89 3c 24             	mov    %edi,(%esp)
80101338:	e8 03 1a 00 00       	call   80102d40 <log_write>
    }
    brelse(bp);
8010133d:	89 3c 24             	mov    %edi,(%esp)
80101340:	e8 9b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101345:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101348:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
8010134f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101350:	8b 03                	mov    (%ebx),%eax
80101352:	e8 99 fd ff ff       	call   801010f0 <balloc>
80101357:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	83 c4 1c             	add    $0x1c,%esp
8010135d:	5b                   	pop    %ebx
8010135e:	5e                   	pop    %esi
8010135f:	5f                   	pop    %edi
80101360:	5d                   	pop    %ebp
80101361:	c3                   	ret    
80101362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101368:	8b 03                	mov    (%ebx),%eax
8010136a:	e8 81 fd ff ff       	call   801010f0 <balloc>
8010136f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101375:	eb 93                	jmp    8010130a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101377:	c7 04 24 41 72 10 80 	movl   $0x80107241,(%esp)
8010137e:	e8 dd ef ff ff       	call   80100360 <panic>
80101383:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101390 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	56                   	push   %esi
80101394:	53                   	push   %ebx
80101395:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101398:	8b 45 08             	mov    0x8(%ebp),%eax
8010139b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013a2:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013a6:	89 04 24             	mov    %eax,(%esp)
801013a9:	e8 22 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013ae:	89 34 24             	mov    %esi,(%esp)
801013b1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013b8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013b9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013bb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013be:	89 44 24 04          	mov    %eax,0x4(%esp)
801013c2:	e8 29 34 00 00       	call   801047f0 <memmove>
  brelse(bp);
801013c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013ca:	83 c4 10             	add    $0x10,%esp
801013cd:	5b                   	pop    %ebx
801013ce:	5e                   	pop    %esi
801013cf:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013d0:	e9 0b ee ff ff       	jmp    801001e0 <brelse>
801013d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	57                   	push   %edi
801013e4:	89 d7                	mov    %edx,%edi
801013e6:	56                   	push   %esi
801013e7:	53                   	push   %ebx
801013e8:	89 c3                	mov    %eax,%ebx
801013ea:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013ed:	89 04 24             	mov    %eax,(%esp)
801013f0:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
801013f7:	80 
801013f8:	e8 93 ff ff ff       	call   80101390 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013fd:	89 fa                	mov    %edi,%edx
801013ff:	c1 ea 0c             	shr    $0xc,%edx
80101402:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101408:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010140b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101410:	89 54 24 04          	mov    %edx,0x4(%esp)
80101414:	e8 b7 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101419:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010141b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101421:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101423:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101426:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101429:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010142b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010142d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101432:	0f b6 c8             	movzbl %al,%ecx
80101435:	85 d9                	test   %ebx,%ecx
80101437:	74 20                	je     80101459 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101439:	f7 d3                	not    %ebx
8010143b:	21 c3                	and    %eax,%ebx
8010143d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101441:	89 34 24             	mov    %esi,(%esp)
80101444:	e8 f7 18 00 00       	call   80102d40 <log_write>
  brelse(bp);
80101449:	89 34 24             	mov    %esi,(%esp)
8010144c:	e8 8f ed ff ff       	call   801001e0 <brelse>
}
80101451:	83 c4 1c             	add    $0x1c,%esp
80101454:	5b                   	pop    %ebx
80101455:	5e                   	pop    %esi
80101456:	5f                   	pop    %edi
80101457:	5d                   	pop    %ebp
80101458:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101459:	c7 04 24 54 72 10 80 	movl   $0x80107254,(%esp)
80101460:	e8 fb ee ff ff       	call   80100360 <panic>
80101465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101479:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	c7 44 24 04 67 72 10 	movl   $0x80107267,0x4(%esp)
80101483:	80 
80101484:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010148b:	e8 c0 30 00 00       	call   80104550 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	89 1c 24             	mov    %ebx,(%esp)
80101493:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101499:	c7 44 24 04 6e 72 10 	movl   $0x8010726e,0x4(%esp)
801014a0:	80 
801014a1:	e8 9a 2f 00 00       	call   80104440 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a6:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014ac:	75 e2                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
801014ae:	8b 45 08             	mov    0x8(%ebp),%eax
801014b1:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
801014b8:	80 
801014b9:	89 04 24             	mov    %eax,(%esp)
801014bc:	e8 cf fe ff ff       	call   80101390 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014c1:	a1 f8 09 11 80       	mov    0x801109f8,%eax
801014c6:	c7 04 24 c4 72 10 80 	movl   $0x801072c4,(%esp)
801014cd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014d1:	a1 f4 09 11 80       	mov    0x801109f4,%eax
801014d6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014da:	a1 f0 09 11 80       	mov    0x801109f0,%eax
801014df:	89 44 24 14          	mov    %eax,0x14(%esp)
801014e3:	a1 ec 09 11 80       	mov    0x801109ec,%eax
801014e8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014ec:	a1 e8 09 11 80       	mov    0x801109e8,%eax
801014f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014f5:	a1 e4 09 11 80       	mov    0x801109e4,%eax
801014fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801014fe:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101503:	89 44 24 04          	mov    %eax,0x4(%esp)
80101507:	e8 44 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010150c:	83 c4 24             	add    $0x24,%esp
8010150f:	5b                   	pop    %ebx
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
80101512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101520 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 2c             	sub    $0x2c,%esp
80101529:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101533:	8b 7d 08             	mov    0x8(%ebp),%edi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 a2 00 00 00    	jbe    801015e1 <ialloc+0xc1>
8010153f:	be 01 00 00 00       	mov    $0x1,%esi
80101544:	bb 01 00 00 00       	mov    $0x1,%ebx
80101549:	eb 1a                	jmp    80101565 <ialloc+0x45>
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101550:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101556:	e8 85 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010155b:	89 de                	mov    %ebx,%esi
8010155d:	3b 1d e8 09 11 80    	cmp    0x801109e8,%ebx
80101563:	73 7c                	jae    801015e1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101565:	89 f0                	mov    %esi,%eax
80101567:	c1 e8 03             	shr    $0x3,%eax
8010156a:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101570:	89 3c 24             	mov    %edi,(%esp)
80101573:	89 44 24 04          	mov    %eax,0x4(%esp)
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 f0                	mov    %esi,%eax
80101580:	83 e0 07             	and    $0x7,%eax
80101583:	c1 e0 06             	shl    $0x6,%eax
80101586:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010158e:	75 c0                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101590:	89 0c 24             	mov    %ecx,(%esp)
80101593:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010159a:	00 
8010159b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015a2:	00 
801015a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	e8 a2 31 00 00       	call   80104750 <memset>
      dip->type = type;
801015ae:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015bb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015be:	89 14 24             	mov    %edx,(%esp)
801015c1:	e8 7a 17 00 00       	call   80102d40 <log_write>
      brelse(bp);
801015c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015c9:	89 14 24             	mov    %edx,(%esp)
801015cc:	e8 0f ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d9:	5e                   	pop    %esi
801015da:	5f                   	pop    %edi
801015db:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015dc:	e9 2f fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015e1:	c7 04 24 74 72 10 80 	movl   $0x80107274,(%esp)
801015e8:	e8 73 ed ff ff       	call   80100360 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	83 ec 10             	sub    $0x10,%esp
801015f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010160a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101611:	89 04 24             	mov    %eax,(%esp)
80101614:	e8 b7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101619:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010161c:	83 e2 07             	and    $0x7,%edx
8010161f:	c1 e2 06             	shl    $0x6,%edx
80101622:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101626:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101628:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010162f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101633:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101637:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010163b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010163f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101643:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101647:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010164b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010164e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101651:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101655:	89 14 24             	mov    %edx,(%esp)
80101658:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010165f:	00 
80101660:	e8 8b 31 00 00       	call   801047f0 <memmove>
  log_write(bp);
80101665:	89 34 24             	mov    %esi,(%esp)
80101668:	e8 d3 16 00 00       	call   80102d40 <log_write>
  brelse(bp);
8010166d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101670:	83 c4 10             	add    $0x10,%esp
80101673:	5b                   	pop    %ebx
80101674:	5e                   	pop    %esi
80101675:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101676:	e9 65 eb ff ff       	jmp    801001e0 <brelse>
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 14             	sub    $0x14,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101691:	e8 3a 2f 00 00       	call   801045d0 <acquire>
  ip->ref++;
80101696:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010169a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801016a1:	e8 5a 30 00 00       	call   80104700 <release>
  return ip;
}
801016a6:	83 c4 14             	add    $0x14,%esp
801016a9:	89 d8                	mov    %ebx,%eax
801016ab:	5b                   	pop    %ebx
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
801016ae:	66 90                	xchg   %ax,%ax

801016b0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	83 ec 10             	sub    $0x10,%esp
801016b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016bb:	85 db                	test   %ebx,%ebx
801016bd:	0f 84 b0 00 00 00    	je     80101773 <ilock+0xc3>
801016c3:	8b 43 08             	mov    0x8(%ebx),%eax
801016c6:	85 c0                	test   %eax,%eax
801016c8:	0f 8e a5 00 00 00    	jle    80101773 <ilock+0xc3>
    panic("ilock");

  acquiresleep(&ip->lock);
801016ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 a7 2d 00 00       	call   80104480 <acquiresleep>

  if(!(ip->flags & I_VALID)){
801016d9:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
801016dd:	74 09                	je     801016e8 <ilock+0x38>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016df:	83 c4 10             	add    $0x10,%esp
801016e2:	5b                   	pop    %ebx
801016e3:	5e                   	pop    %esi
801016e4:	5d                   	pop    %ebp
801016e5:	c3                   	ret    
801016e6:	66 90                	xchg   %ax,%ax
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
801016eb:	c1 e8 03             	shr    $0x3,%eax
801016ee:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016f8:	8b 03                	mov    (%ebx),%eax
801016fa:	89 04 24             	mov    %eax,(%esp)
801016fd:	e8 ce e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101702:	8b 53 04             	mov    0x4(%ebx),%edx
80101705:	83 e2 07             	and    $0x7,%edx
80101708:	c1 e2 06             	shl    $0x6,%edx
8010170b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101711:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101714:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101717:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010171b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010171f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101723:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101727:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010172b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010172f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101733:	8b 42 fc             	mov    -0x4(%edx),%eax
80101736:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101739:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010173c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101740:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101747:	00 
80101748:	89 04 24             	mov    %eax,(%esp)
8010174b:	e8 a0 30 00 00       	call   801047f0 <memmove>
    brelse(bp);
80101750:	89 34 24             	mov    %esi,(%esp)
80101753:	e8 88 ea ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
80101758:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
8010175c:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101761:	0f 85 78 ff ff ff    	jne    801016df <ilock+0x2f>
      panic("ilock: no type");
80101767:	c7 04 24 8c 72 10 80 	movl   $0x8010728c,(%esp)
8010176e:	e8 ed eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101773:	c7 04 24 86 72 10 80 	movl   $0x80107286,(%esp)
8010177a:	e8 e1 eb ff ff       	call   80100360 <panic>
8010177f:	90                   	nop

80101780 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	83 ec 10             	sub    $0x10,%esp
80101788:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010178b:	85 db                	test   %ebx,%ebx
8010178d:	74 24                	je     801017b3 <iunlock+0x33>
8010178f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101792:	89 34 24             	mov    %esi,(%esp)
80101795:	e8 86 2d 00 00       	call   80104520 <holdingsleep>
8010179a:	85 c0                	test   %eax,%eax
8010179c:	74 15                	je     801017b3 <iunlock+0x33>
8010179e:	8b 43 08             	mov    0x8(%ebx),%eax
801017a1:	85 c0                	test   %eax,%eax
801017a3:	7e 0e                	jle    801017b3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017a5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	5b                   	pop    %ebx
801017ac:	5e                   	pop    %esi
801017ad:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ae:	e9 2d 2d 00 00       	jmp    801044e0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017b3:	c7 04 24 9b 72 10 80 	movl   $0x8010729b,(%esp)
801017ba:	e8 a1 eb ff ff       	call   80100360 <panic>
801017bf:	90                   	nop

801017c0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 1c             	sub    $0x1c,%esp
801017c9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
801017cc:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801017d3:	e8 f8 2d 00 00       	call   801045d0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017d8:	8b 46 08             	mov    0x8(%esi),%eax
801017db:	83 f8 01             	cmp    $0x1,%eax
801017de:	74 20                	je     80101800 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
801017e0:	83 e8 01             	sub    $0x1,%eax
801017e3:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
801017e6:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
801017ed:	83 c4 1c             	add    $0x1c,%esp
801017f0:	5b                   	pop    %ebx
801017f1:	5e                   	pop    %esi
801017f2:	5f                   	pop    %edi
801017f3:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
801017f4:	e9 07 2f 00 00       	jmp    80104700 <release>
801017f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101800:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
80101804:	74 da                	je     801017e0 <iput+0x20>
80101806:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
8010180b:	75 d3                	jne    801017e0 <iput+0x20>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
8010180d:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101814:	89 f3                	mov    %esi,%ebx
80101816:	e8 e5 2e 00 00       	call   80104700 <release>
8010181b:	8d 7e 30             	lea    0x30(%esi),%edi
8010181e:	eb 07                	jmp    80101827 <iput+0x67>
80101820:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101823:	39 fb                	cmp    %edi,%ebx
80101825:	74 19                	je     80101840 <iput+0x80>
    if(ip->addrs[i]){
80101827:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010182a:	85 d2                	test   %edx,%edx
8010182c:	74 f2                	je     80101820 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
8010182e:	8b 06                	mov    (%esi),%eax
80101830:	e8 ab fb ff ff       	call   801013e0 <bfree>
      ip->addrs[i] = 0;
80101835:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010183c:	eb e2                	jmp    80101820 <iput+0x60>
8010183e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101840:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101846:	85 c0                	test   %eax,%eax
80101848:	75 3e                	jne    80101888 <iput+0xc8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010184a:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101851:	89 34 24             	mov    %esi,(%esp)
80101854:	e8 97 fd ff ff       	call   801015f0 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
80101859:	31 c0                	xor    %eax,%eax
8010185b:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
8010185f:	89 34 24             	mov    %esi,(%esp)
80101862:	e8 89 fd ff ff       	call   801015f0 <iupdate>
    acquire(&icache.lock);
80101867:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010186e:	e8 5d 2d 00 00       	call   801045d0 <acquire>
80101873:	8b 46 08             	mov    0x8(%esi),%eax
    ip->flags = 0;
80101876:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
8010187d:	e9 5e ff ff ff       	jmp    801017e0 <iput+0x20>
80101882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101888:	89 44 24 04          	mov    %eax,0x4(%esp)
8010188c:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010188e:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	89 04 24             	mov    %eax,(%esp)
80101893:	e8 38 e8 ff ff       	call   801000d0 <bread>
80101898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010189b:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010189e:	31 c0                	xor    %eax,%eax
801018a0:	eb 13                	jmp    801018b5 <iput+0xf5>
801018a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018a8:	83 c3 01             	add    $0x1,%ebx
801018ab:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018b1:	89 d8                	mov    %ebx,%eax
801018b3:	74 10                	je     801018c5 <iput+0x105>
      if(a[j])
801018b5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018b8:	85 d2                	test   %edx,%edx
801018ba:	74 ec                	je     801018a8 <iput+0xe8>
        bfree(ip->dev, a[j]);
801018bc:	8b 06                	mov    (%esi),%eax
801018be:	e8 1d fb ff ff       	call   801013e0 <bfree>
801018c3:	eb e3                	jmp    801018a8 <iput+0xe8>
    }
    brelse(bp);
801018c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018c8:	89 04 24             	mov    %eax,(%esp)
801018cb:	e8 10 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018d0:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018d6:	8b 06                	mov    (%esi),%eax
801018d8:	e8 03 fb ff ff       	call   801013e0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018dd:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018e4:	00 00 00 
801018e7:	e9 5e ff ff ff       	jmp    8010184a <iput+0x8a>
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 14             	sub    $0x14,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018fa:	89 1c 24             	mov    %ebx,(%esp)
801018fd:	e8 7e fe ff ff       	call   80101780 <iunlock>
  iput(ip);
80101902:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101905:	83 c4 14             	add    $0x14,%esp
80101908:	5b                   	pop    %ebx
80101909:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010190a:	e9 b1 fe ff ff       	jmp    801017c0 <iput>
8010190f:	90                   	nop

80101910 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	8b 55 08             	mov    0x8(%ebp),%edx
80101916:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101919:	8b 0a                	mov    (%edx),%ecx
8010191b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010191e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101921:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101924:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101928:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010192b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010192f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101933:	8b 52 58             	mov    0x58(%edx),%edx
80101936:	89 50 10             	mov    %edx,0x10(%eax)
}
80101939:	5d                   	pop    %ebp
8010193a:	c3                   	ret    
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 2c             	sub    $0x2c,%esp
80101949:	8b 45 0c             	mov    0xc(%ebp),%eax
8010194c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010194f:	8b 75 10             	mov    0x10(%ebp),%esi
80101952:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101955:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101958:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010195d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101960:	0f 84 aa 00 00 00    	je     80101a10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101966:	8b 47 58             	mov    0x58(%edi),%eax
80101969:	39 f0                	cmp    %esi,%eax
8010196b:	0f 82 c7 00 00 00    	jb     80101a38 <readi+0xf8>
80101971:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101974:	89 da                	mov    %ebx,%edx
80101976:	01 f2                	add    %esi,%edx
80101978:	0f 82 ba 00 00 00    	jb     80101a38 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010197e:	89 c1                	mov    %eax,%ecx
80101980:	29 f1                	sub    %esi,%ecx
80101982:	39 d0                	cmp    %edx,%eax
80101984:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101987:	31 c0                	xor    %eax,%eax
80101989:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010198b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010198e:	74 70                	je     80101a00 <readi+0xc0>
80101990:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101993:	89 c7                	mov    %eax,%edi
80101995:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101998:	8b 5d d8             	mov    -0x28(%ebp),%ebx
8010199b:	89 f2                	mov    %esi,%edx
8010199d:	c1 ea 09             	shr    $0x9,%edx
801019a0:	89 d8                	mov    %ebx,%eax
801019a2:	e8 29 f9 ff ff       	call   801012d0 <bmap>
801019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019ab:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019ad:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b2:	89 04 24             	mov    %eax,(%esp)
801019b5:	e8 16 e7 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019bd:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019bf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019c1:	89 f0                	mov    %esi,%eax
801019c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019c8:	29 c3                	sub    %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019ca:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019ce:	39 cb                	cmp    %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019d7:	0f 47 d9             	cmova  %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019da:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019de:	01 df                	add    %ebx,%edi
801019e0:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019e5:	89 04 24             	mov    %eax,(%esp)
801019e8:	e8 03 2e 00 00       	call   801047f0 <memmove>
    brelse(bp);
801019ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019f0:	89 14 24             	mov    %edx,(%esp)
801019f3:	e8 e8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019fb:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019fe:	77 98                	ja     80101998 <readi+0x58>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a03:	83 c4 2c             	add    $0x2c,%esp
80101a06:	5b                   	pop    %ebx
80101a07:	5e                   	pop    %esi
80101a08:	5f                   	pop    %edi
80101a09:	5d                   	pop    %ebp
80101a0a:	c3                   	ret    
80101a0b:	90                   	nop
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a10:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a14:	66 83 f8 09          	cmp    $0x9,%ax
80101a18:	77 1e                	ja     80101a38 <readi+0xf8>
80101a1a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a21:	85 c0                	test   %eax,%eax
80101a23:	74 13                	je     80101a38 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a25:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a28:	89 75 10             	mov    %esi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a2b:	83 c4 2c             	add    $0x2c,%esp
80101a2e:	5b                   	pop    %ebx
80101a2f:	5e                   	pop    %esi
80101a30:	5f                   	pop    %edi
80101a31:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a32:	ff e0                	jmp    *%eax
80101a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a3d:	eb c4                	jmp    80101a03 <readi+0xc3>
80101a3f:	90                   	nop

80101a40 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	57                   	push   %edi
80101a44:	56                   	push   %esi
80101a45:	53                   	push   %ebx
80101a46:	83 ec 2c             	sub    $0x2c,%esp
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a4f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a5a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a60:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a63:	0f 84 b7 00 00 00    	je     80101b20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a6f:	0f 82 e3 00 00 00    	jb     80101b58 <writei+0x118>
80101a75:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a78:	89 c8                	mov    %ecx,%eax
80101a7a:	01 f0                	add    %esi,%eax
80101a7c:	0f 82 d6 00 00 00    	jb     80101b58 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a82:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a87:	0f 87 cb 00 00 00    	ja     80101b58 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a8d:	85 c9                	test   %ecx,%ecx
80101a8f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a96:	74 77                	je     80101b0f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a98:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a9b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a9d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa2:	c1 ea 09             	shr    $0x9,%edx
80101aa5:	89 f8                	mov    %edi,%eax
80101aa7:	e8 24 f8 ff ff       	call   801012d0 <bmap>
80101aac:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ab0:	8b 07                	mov    (%edi),%eax
80101ab2:	89 04 24             	mov    %eax,(%esp)
80101ab5:	e8 16 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aba:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101abd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ac0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac5:	89 f0                	mov    %esi,%eax
80101ac7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101acc:	29 c3                	sub    %eax,%ebx
80101ace:	39 cb                	cmp    %ecx,%ebx
80101ad0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ad3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad7:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ad9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101add:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101ae1:	89 04 24             	mov    %eax,(%esp)
80101ae4:	e8 07 2d 00 00       	call   801047f0 <memmove>
    log_write(bp);
80101ae9:	89 3c 24             	mov    %edi,(%esp)
80101aec:	e8 4f 12 00 00       	call   80102d40 <log_write>
    brelse(bp);
80101af1:	89 3c 24             	mov    %edi,(%esp)
80101af4:	e8 e7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101aff:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b02:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b05:	77 91                	ja     80101a98 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b07:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b0d:	72 39                	jb     80101b48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b12:	83 c4 2c             	add    $0x2c,%esp
80101b15:	5b                   	pop    %ebx
80101b16:	5e                   	pop    %esi
80101b17:	5f                   	pop    %edi
80101b18:	5d                   	pop    %ebp
80101b19:	c3                   	ret    
80101b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b24:	66 83 f8 09          	cmp    $0x9,%ax
80101b28:	77 2e                	ja     80101b58 <writei+0x118>
80101b2a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b31:	85 c0                	test   %eax,%eax
80101b33:	74 23                	je     80101b58 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b35:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b38:	83 c4 2c             	add    $0x2c,%esp
80101b3b:	5b                   	pop    %ebx
80101b3c:	5e                   	pop    %esi
80101b3d:	5f                   	pop    %edi
80101b3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b3f:	ff e0                	jmp    *%eax
80101b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b4e:	89 04 24             	mov    %eax,(%esp)
80101b51:	e8 9a fa ff ff       	call   801015f0 <iupdate>
80101b56:	eb b7                	jmp    80101b0f <writei+0xcf>
  }
  return n;
}
80101b58:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b60:	5b                   	pop    %ebx
80101b61:	5e                   	pop    %esi
80101b62:	5f                   	pop    %edi
80101b63:	5d                   	pop    %ebp
80101b64:	c3                   	ret    
80101b65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b76:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b79:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b80:	00 
80101b81:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b85:	8b 45 08             	mov    0x8(%ebp),%eax
80101b88:	89 04 24             	mov    %eax,(%esp)
80101b8b:	e8 e0 2c 00 00       	call   80104870 <strncmp>
}
80101b90:	c9                   	leave  
80101b91:	c3                   	ret    
80101b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 2c             	sub    $0x2c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bb1:	0f 85 97 00 00 00    	jne    80101c4e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 73                	jmp    80101c38 <dirlookup+0x98>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bce:	76 68                	jbe    80101c38 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bd7:	00 
80101bd8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bdc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101be0:	89 1c 24             	mov    %ebx,(%esp)
80101be3:	e8 58 fd ff ff       	call   80101940 <readi>
80101be8:	83 f8 10             	cmp    $0x10,%eax
80101beb:	75 55                	jne    80101c42 <dirlookup+0xa2>
      panic("dirlink read");
    if(de.inum == 0)
80101bed:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bf2:	74 d4                	je     80101bc8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bf4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bfe:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c05:	00 
80101c06:	89 04 24             	mov    %eax,(%esp)
80101c09:	e8 62 2c 00 00       	call   80104870 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c0e:	85 c0                	test   %eax,%eax
80101c10:	75 b6                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c12:	8b 45 10             	mov    0x10(%ebp),%eax
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 05                	je     80101c1e <dirlookup+0x7e>
        *poff = off;
80101c19:	8b 45 10             	mov    0x10(%ebp),%eax
80101c1c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c1e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c22:	8b 03                	mov    (%ebx),%eax
80101c24:	e8 e7 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c29:	83 c4 2c             	add    $0x2c,%esp
80101c2c:	5b                   	pop    %ebx
80101c2d:	5e                   	pop    %esi
80101c2e:	5f                   	pop    %edi
80101c2f:	5d                   	pop    %ebp
80101c30:	c3                   	ret    
80101c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c38:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c3b:	31 c0                	xor    %eax,%eax
}
80101c3d:	5b                   	pop    %ebx
80101c3e:	5e                   	pop    %esi
80101c3f:	5f                   	pop    %edi
80101c40:	5d                   	pop    %ebp
80101c41:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101c42:	c7 04 24 b5 72 10 80 	movl   $0x801072b5,(%esp)
80101c49:	e8 12 e7 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c4e:	c7 04 24 a3 72 10 80 	movl   $0x801072a3,(%esp)
80101c55:	e8 06 e7 ff ff       	call   80100360 <panic>
80101c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	89 cf                	mov    %ecx,%edi
80101c66:	56                   	push   %esi
80101c67:	53                   	push   %ebx
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c73:	0f 84 51 01 00 00    	je     80101dca <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101c7f:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c82:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101c89:	e8 42 29 00 00       	call   801045d0 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101c99:	e8 62 2a 00 00       	call   80104700 <release>
80101c9e:	eb 03                	jmp    80101ca3 <namex+0x43>
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101ca0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101ca3:	0f b6 03             	movzbl (%ebx),%eax
80101ca6:	3c 2f                	cmp    $0x2f,%al
80101ca8:	74 f6                	je     80101ca0 <namex+0x40>
    path++;
  if(*path == 0)
80101caa:	84 c0                	test   %al,%al
80101cac:	0f 84 ed 00 00 00    	je     80101d9f <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cb2:	0f b6 03             	movzbl (%ebx),%eax
80101cb5:	89 da                	mov    %ebx,%edx
80101cb7:	84 c0                	test   %al,%al
80101cb9:	0f 84 b1 00 00 00    	je     80101d70 <namex+0x110>
80101cbf:	3c 2f                	cmp    $0x2f,%al
80101cc1:	75 0f                	jne    80101cd2 <namex+0x72>
80101cc3:	e9 a8 00 00 00       	jmp    80101d70 <namex+0x110>
80101cc8:	3c 2f                	cmp    $0x2f,%al
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cd0:	74 0a                	je     80101cdc <namex+0x7c>
    path++;
80101cd2:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cd5:	0f b6 02             	movzbl (%edx),%eax
80101cd8:	84 c0                	test   %al,%al
80101cda:	75 ec                	jne    80101cc8 <namex+0x68>
80101cdc:	89 d1                	mov    %edx,%ecx
80101cde:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101ce0:	83 f9 0d             	cmp    $0xd,%ecx
80101ce3:	0f 8e 8f 00 00 00    	jle    80101d78 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101ce9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101ced:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101cf4:	00 
80101cf5:	89 3c 24             	mov    %edi,(%esp)
80101cf8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cfb:	e8 f0 2a 00 00       	call   801047f0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d03:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d05:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d08:	75 0e                	jne    80101d18 <namex+0xb8>
80101d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	89 34 24             	mov    %esi,(%esp)
80101d1b:	e8 90 f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d20:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d25:	0f 85 85 00 00 00    	jne    80101db0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d2e:	85 d2                	test   %edx,%edx
80101d30:	74 09                	je     80101d3b <namex+0xdb>
80101d32:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d35:	0f 84 a5 00 00 00    	je     80101de0 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d42:	00 
80101d43:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d47:	89 34 24             	mov    %esi,(%esp)
80101d4a:	e8 51 fe ff ff       	call   80101ba0 <dirlookup>
80101d4f:	85 c0                	test   %eax,%eax
80101d51:	74 5d                	je     80101db0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d53:	89 34 24             	mov    %esi,(%esp)
80101d56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d59:	e8 22 fa ff ff       	call   80101780 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 5a fa ff ff       	call   801017c0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	89 c6                	mov    %eax,%esi
80101d6b:	e9 33 ff ff ff       	jmp    80101ca3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d70:	31 c9                	xor    %ecx,%ecx
80101d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d78:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d7c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d80:	89 3c 24             	mov    %edi,(%esp)
80101d83:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d86:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d89:	e8 62 2a 00 00       	call   801047f0 <memmove>
    name[len] = 0;
80101d8e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d91:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d94:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d98:	89 d3                	mov    %edx,%ebx
80101d9a:	e9 66 ff ff ff       	jmp    80101d05 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101da2:	85 c0                	test   %eax,%eax
80101da4:	75 4c                	jne    80101df2 <namex+0x192>
80101da6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101da8:	83 c4 2c             	add    $0x2c,%esp
80101dab:	5b                   	pop    %ebx
80101dac:	5e                   	pop    %esi
80101dad:	5f                   	pop    %edi
80101dae:	5d                   	pop    %ebp
80101daf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101db0:	89 34 24             	mov    %esi,(%esp)
80101db3:	e8 c8 f9 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101db8:	89 34 24             	mov    %esi,(%esp)
80101dbb:	e8 00 fa ff ff       	call   801017c0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101dc3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc5:	5b                   	pop    %ebx
80101dc6:	5e                   	pop    %esi
80101dc7:	5f                   	pop    %edi
80101dc8:	5d                   	pop    %ebp
80101dc9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dca:	ba 01 00 00 00       	mov    $0x1,%edx
80101dcf:	b8 01 00 00 00       	mov    $0x1,%eax
80101dd4:	e8 37 f4 ff ff       	call   80101210 <iget>
80101dd9:	89 c6                	mov    %eax,%esi
80101ddb:	e9 c3 fe ff ff       	jmp    80101ca3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101de0:	89 34 24             	mov    %esi,(%esp)
80101de3:	e8 98 f9 ff ff       	call   80101780 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de8:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101deb:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ded:	5b                   	pop    %ebx
80101dee:	5e                   	pop    %esi
80101def:	5f                   	pop    %edi
80101df0:	5d                   	pop    %ebp
80101df1:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101df2:	89 34 24             	mov    %esi,(%esp)
80101df5:	e8 c6 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101dfa:	31 c0                	xor    %eax,%eax
80101dfc:	eb aa                	jmp    80101da8 <namex+0x148>
80101dfe:	66 90                	xchg   %ax,%ax

80101e00 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 2c             	sub    $0x2c,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e16:	00 
80101e17:	89 1c 24             	mov    %ebx,(%esp)
80101e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e1e:	e8 7d fd ff ff       	call   80101ba0 <dirlookup>
80101e23:	85 c0                	test   %eax,%eax
80101e25:	0f 85 8b 00 00 00    	jne    80101eb6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e2b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e2e:	31 ff                	xor    %edi,%edi
80101e30:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e33:	85 c0                	test   %eax,%eax
80101e35:	75 13                	jne    80101e4a <dirlink+0x4a>
80101e37:	eb 35                	jmp    80101e6e <dirlink+0x6e>
80101e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e40:	8d 57 10             	lea    0x10(%edi),%edx
80101e43:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e46:	89 d7                	mov    %edx,%edi
80101e48:	76 24                	jbe    80101e6e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e4a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e51:	00 
80101e52:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e56:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e5a:	89 1c 24             	mov    %ebx,(%esp)
80101e5d:	e8 de fa ff ff       	call   80101940 <readi>
80101e62:	83 f8 10             	cmp    $0x10,%eax
80101e65:	75 5e                	jne    80101ec5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101e67:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6c:	75 d2                	jne    80101e40 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e71:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e78:	00 
80101e79:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e7d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e80:	89 04 24             	mov    %eax,(%esp)
80101e83:	e8 58 2a 00 00       	call   801048e0 <strncpy>
  de.inum = inum;
80101e88:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e92:	00 
80101e93:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e97:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e9b:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e9e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ea2:	e8 99 fb ff ff       	call   80101a40 <writei>
80101ea7:	83 f8 10             	cmp    $0x10,%eax
80101eaa:	75 25                	jne    80101ed1 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101eac:	31 c0                	xor    %eax,%eax
}
80101eae:	83 c4 2c             	add    $0x2c,%esp
80101eb1:	5b                   	pop    %ebx
80101eb2:	5e                   	pop    %esi
80101eb3:	5f                   	pop    %edi
80101eb4:	5d                   	pop    %ebp
80101eb5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101eb6:	89 04 24             	mov    %eax,(%esp)
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec3:	eb e9                	jmp    80101eae <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ec5:	c7 04 24 b5 72 10 80 	movl   $0x801072b5,(%esp)
80101ecc:	e8 8f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ed1:	c7 04 24 66 79 10 80 	movl   $0x80107966,(%esp)
80101ed8:	e8 83 e4 ff ff       	call   80100360 <panic>
80101edd:	8d 76 00             	lea    0x0(%esi),%esi

80101ee0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	56                   	push   %esi
80101f24:	89 c6                	mov    %eax,%esi
80101f26:	53                   	push   %ebx
80101f27:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f2a:	85 c0                	test   %eax,%eax
80101f2c:	0f 84 99 00 00 00    	je     80101fcb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f32:	8b 48 08             	mov    0x8(%eax),%ecx
80101f35:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f3b:	0f 87 7e 00 00 00    	ja     80101fbf <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f41:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f49:	83 e0 c0             	and    $0xffffffc0,%eax
80101f4c:	3c 40                	cmp    $0x40,%al
80101f4e:	75 f8                	jne    80101f48 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f50:	31 db                	xor    %ebx,%ebx
80101f52:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f57:	89 d8                	mov    %ebx,%eax
80101f59:	ee                   	out    %al,(%dx)
80101f5a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f5f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f64:	ee                   	out    %al,(%dx)
80101f65:	0f b6 c1             	movzbl %cl,%eax
80101f68:	b2 f3                	mov    $0xf3,%dl
80101f6a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f6b:	89 c8                	mov    %ecx,%eax
80101f6d:	b2 f4                	mov    $0xf4,%dl
80101f6f:	c1 f8 08             	sar    $0x8,%eax
80101f72:	ee                   	out    %al,(%dx)
80101f73:	b2 f5                	mov    $0xf5,%dl
80101f75:	89 d8                	mov    %ebx,%eax
80101f77:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f78:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f7c:	b2 f6                	mov    $0xf6,%dl
80101f7e:	83 e0 01             	and    $0x1,%eax
80101f81:	c1 e0 04             	shl    $0x4,%eax
80101f84:	83 c8 e0             	or     $0xffffffe0,%eax
80101f87:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f88:	f6 06 04             	testb  $0x4,(%esi)
80101f8b:	75 13                	jne    80101fa0 <idestart+0x80>
80101f8d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f92:	b8 20 00 00 00       	mov    $0x20,%eax
80101f97:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f98:	83 c4 10             	add    $0x10,%esp
80101f9b:	5b                   	pop    %ebx
80101f9c:	5e                   	pop    %esi
80101f9d:	5d                   	pop    %ebp
80101f9e:	c3                   	ret    
80101f9f:	90                   	nop
80101fa0:	b2 f7                	mov    $0xf7,%dl
80101fa2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fa7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fa8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fad:	83 c6 5c             	add    $0x5c,%esi
80101fb0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fb5:	fc                   	cld    
80101fb6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5d                   	pop    %ebp
80101fbe:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fbf:	c7 04 24 20 73 10 80 	movl   $0x80107320,(%esp)
80101fc6:	e8 95 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fcb:	c7 04 24 17 73 10 80 	movl   $0x80107317,(%esp)
80101fd2:	e8 89 e3 ff ff       	call   80100360 <panic>
80101fd7:	89 f6                	mov    %esi,%esi
80101fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fe0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80101fe6:	c7 44 24 04 32 73 10 	movl   $0x80107332,0x4(%esp)
80101fed:	80 
80101fee:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80101ff5:	e8 56 25 00 00       	call   80104550 <initlock>
  picenable(IRQ_IDE);
80101ffa:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102001:	e8 0a 12 00 00       	call   80103210 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102006:	a1 80 2d 11 80       	mov    0x80112d80,%eax
8010200b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102012:	83 e8 01             	sub    $0x1,%eax
80102015:	89 44 24 04          	mov    %eax,0x4(%esp)
80102019:	e8 82 02 00 00       	call   801022a0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010201e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102023:	90                   	nop
80102024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102028:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102029:	83 e0 c0             	and    $0xffffffc0,%eax
8010202c:	3c 40                	cmp    $0x40,%al
8010202e:	75 f8                	jne    80102028 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102030:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102035:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203a:	ee                   	out    %al,(%dx)
8010203b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102040:	b2 f7                	mov    $0xf7,%dl
80102042:	eb 09                	jmp    8010204d <ideinit+0x6d>
80102044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102048:	83 e9 01             	sub    $0x1,%ecx
8010204b:	74 0f                	je     8010205c <ideinit+0x7c>
8010204d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010204e:	84 c0                	test   %al,%al
80102050:	74 f6                	je     80102048 <ideinit+0x68>
      havedisk1 = 1;
80102052:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102059:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010205c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102061:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102066:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102079:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102080:	e8 4b 25 00 00       	call   801045d0 <acquire>
  if((b = idequeue) == 0){
80102085:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010208b:	85 db                	test   %ebx,%ebx
8010208d:	74 30                	je     801020bf <ideintr+0x4f>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
8010208f:	8b 43 58             	mov    0x58(%ebx),%eax
80102092:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102097:	8b 33                	mov    (%ebx),%esi
80102099:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010209f:	74 37                	je     801020d8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020a1:	83 e6 fb             	and    $0xfffffffb,%esi
801020a4:	83 ce 02             	or     $0x2,%esi
801020a7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020a9:	89 1c 24             	mov    %ebx,(%esp)
801020ac:	e8 cf 1f 00 00       	call   80104080 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020b1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020b6:	85 c0                	test   %eax,%eax
801020b8:	74 05                	je     801020bf <ideintr+0x4f>
    idestart(idequeue);
801020ba:	e8 61 fe ff ff       	call   80101f20 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
801020bf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020c6:	e8 35 26 00 00       	call   80104700 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020cb:	83 c4 1c             	add    $0x1c,%esp
801020ce:	5b                   	pop    %ebx
801020cf:	5e                   	pop    %esi
801020d0:	5f                   	pop    %edi
801020d1:	5d                   	pop    %ebp
801020d2:	c3                   	ret    
801020d3:	90                   	nop
801020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020dd:	8d 76 00             	lea    0x0(%esi),%esi
801020e0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	89 c1                	mov    %eax,%ecx
801020e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020e6:	80 f9 40             	cmp    $0x40,%cl
801020e9:	75 f5                	jne    801020e0 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020eb:	a8 21                	test   $0x21,%al
801020ed:	75 b2                	jne    801020a1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801020f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020fc:	fc                   	cld    
801020fd:	f3 6d                	rep insl (%dx),%es:(%edi)
801020ff:	8b 33                	mov    (%ebx),%esi
80102101:	eb 9e                	jmp    801020a1 <ideintr+0x31>
80102103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102110 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	53                   	push   %ebx
80102114:	83 ec 14             	sub    $0x14,%esp
80102117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010211a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010211d:	89 04 24             	mov    %eax,(%esp)
80102120:	e8 fb 23 00 00       	call   80104520 <holdingsleep>
80102125:	85 c0                	test   %eax,%eax
80102127:	0f 84 9e 00 00 00    	je     801021cb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010212d:	8b 03                	mov    (%ebx),%eax
8010212f:	83 e0 06             	and    $0x6,%eax
80102132:	83 f8 02             	cmp    $0x2,%eax
80102135:	0f 84 a8 00 00 00    	je     801021e3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010213b:	8b 53 04             	mov    0x4(%ebx),%edx
8010213e:	85 d2                	test   %edx,%edx
80102140:	74 0d                	je     8010214f <iderw+0x3f>
80102142:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102147:	85 c0                	test   %eax,%eax
80102149:	0f 84 88 00 00 00    	je     801021d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010214f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102156:	e8 75 24 00 00       	call   801045d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010215b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102160:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102167:	85 c0                	test   %eax,%eax
80102169:	75 07                	jne    80102172 <iderw+0x62>
8010216b:	eb 4e                	jmp    801021bb <iderw+0xab>
8010216d:	8d 76 00             	lea    0x0(%esi),%esi
80102170:	89 d0                	mov    %edx,%eax
80102172:	8b 50 58             	mov    0x58(%eax),%edx
80102175:	85 d2                	test   %edx,%edx
80102177:	75 f7                	jne    80102170 <iderw+0x60>
80102179:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010217c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010217e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102184:	74 3c                	je     801021c2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102186:	8b 03                	mov    (%ebx),%eax
80102188:	83 e0 06             	and    $0x6,%eax
8010218b:	83 f8 02             	cmp    $0x2,%eax
8010218e:	74 1a                	je     801021aa <iderw+0x9a>
    sleep(b, &idelock);
80102190:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80102197:	80 
80102198:	89 1c 24             	mov    %ebx,(%esp)
8010219b:	e8 40 1d 00 00       	call   80103ee0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a0:	8b 13                	mov    (%ebx),%edx
801021a2:	83 e2 06             	and    $0x6,%edx
801021a5:	83 fa 02             	cmp    $0x2,%edx
801021a8:	75 e6                	jne    80102190 <iderw+0x80>
    sleep(b, &idelock);
  }

  release(&idelock);
801021aa:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021b1:	83 c4 14             	add    $0x14,%esp
801021b4:	5b                   	pop    %ebx
801021b5:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
801021b6:	e9 45 25 00 00       	jmp    80104700 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021bb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021c0:	eb ba                	jmp    8010217c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021c2:	89 d8                	mov    %ebx,%eax
801021c4:	e8 57 fd ff ff       	call   80101f20 <idestart>
801021c9:	eb bb                	jmp    80102186 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021cb:	c7 04 24 36 73 10 80 	movl   $0x80107336,(%esp)
801021d2:	e8 89 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021d7:	c7 04 24 61 73 10 80 	movl   $0x80107361,(%esp)
801021de:	e8 7d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021e3:	c7 04 24 4c 73 10 80 	movl   $0x8010734c,(%esp)
801021ea:	e8 71 e1 ff ff       	call   80100360 <panic>
801021ef:	90                   	nop

801021f0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801021f0:	a1 84 27 11 80       	mov    0x80112784,%eax
801021f5:	85 c0                	test   %eax,%eax
801021f7:	0f 84 9b 00 00 00    	je     80102298 <ioapicinit+0xa8>
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021fd:	55                   	push   %ebp
801021fe:	89 e5                	mov    %esp,%ebp
80102200:	56                   	push   %esi
80102201:	53                   	push   %ebx
80102202:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102205:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
8010220c:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010220f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102216:	00 00 00 
  return ioapic->data;
80102219:	8b 15 54 26 11 80    	mov    0x80112654,%edx
8010221f:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102222:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102228:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010222e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102235:	c1 e8 10             	shr    $0x10,%eax
80102238:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010223b:	8b 43 10             	mov    0x10(%ebx),%eax
  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
8010223e:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102241:	39 c2                	cmp    %eax,%edx
80102243:	74 12                	je     80102257 <ioapicinit+0x67>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102245:	c7 04 24 80 73 10 80 	movl   $0x80107380,(%esp)
8010224c:	e8 ff e3 ff ff       	call   80100650 <cprintf>
80102251:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
80102257:	ba 10 00 00 00       	mov    $0x10,%edx
8010225c:	31 c0                	xor    %eax,%eax
8010225e:	eb 02                	jmp    80102262 <ioapicinit+0x72>
80102260:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102262:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
80102264:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
8010226a:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010226d:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102273:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102276:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102279:	8d 4a 01             	lea    0x1(%edx),%ecx
8010227c:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227f:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102281:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102287:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102289:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102290:	7d ce                	jge    80102260 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102292:	83 c4 10             	add    $0x10,%esp
80102295:	5b                   	pop    %ebx
80102296:	5e                   	pop    %esi
80102297:	5d                   	pop    %ebp
80102298:	f3 c3                	repz ret 
8010229a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
801022a0:	8b 15 84 27 11 80    	mov    0x80112784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022a6:	55                   	push   %ebp
801022a7:	89 e5                	mov    %esp,%ebp
801022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801022ac:	85 d2                	test   %edx,%edx
801022ae:	74 29                	je     801022d9 <ioapicenable+0x39>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022b0:	8d 48 20             	lea    0x20(%eax),%ecx
801022b3:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b7:	a1 54 26 11 80       	mov    0x80112654,%eax
801022bc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801022be:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c3:	83 c2 01             	add    $0x1,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022c6:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022cc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801022ce:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d3:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022d6:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022d9:	5d                   	pop    %ebp
801022da:	c3                   	ret    
801022db:	66 90                	xchg   %ax,%ax
801022dd:	66 90                	xchg   %ax,%ax
801022df:	90                   	nop

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 14             	sub    $0x14,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 7c                	jne    8010236e <kfree+0x8e>
801022f2:	81 fb 28 65 11 80    	cmp    $0x80116528,%ebx
801022f8:	72 74                	jb     8010236e <kfree+0x8e>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 67                	ja     8010236e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010230e:	00 
8010230f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102316:	00 
80102317:	89 1c 24             	mov    %ebx,(%esp)
8010231a:	e8 31 24 00 00       	call   80104750 <memset>

  if(kmem.use_lock)
8010231f:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102325:	85 d2                	test   %edx,%edx
80102327:	75 37                	jne    80102360 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102329:	a1 98 26 11 80       	mov    0x80112698,%eax
8010232e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102330:	a1 94 26 11 80       	mov    0x80112694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102335:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
8010233b:	85 c0                	test   %eax,%eax
8010233d:	75 09                	jne    80102348 <kfree+0x68>
    release(&kmem.lock);
}
8010233f:	83 c4 14             	add    $0x14,%esp
80102342:	5b                   	pop    %ebx
80102343:	5d                   	pop    %ebp
80102344:	c3                   	ret    
80102345:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102348:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102354:	e9 a7 23 00 00       	jmp    80104700 <release>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102360:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102367:	e8 64 22 00 00       	call   801045d0 <acquire>
8010236c:	eb bb                	jmp    80102329 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010236e:	c7 04 24 b2 73 10 80 	movl   $0x801073b2,(%esp)
80102375:	e8 e6 df ff ff       	call   80100360 <panic>
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102380 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
80102385:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102388:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010238b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010238e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102394:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023a0:	39 de                	cmp    %ebx,%esi
801023a2:	73 08                	jae    801023ac <freerange+0x2c>
801023a4:	eb 18                	jmp    801023be <freerange+0x3e>
801023a6:	66 90                	xchg   %ax,%ax
801023a8:	89 da                	mov    %ebx,%edx
801023aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ac:	89 14 24             	mov    %edx,(%esp)
801023af:	e8 2c ff ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ba:	39 f0                	cmp    %esi,%eax
801023bc:	76 ea                	jbe    801023a8 <freerange+0x28>
    kfree(p);
}
801023be:	83 c4 10             	add    $0x10,%esp
801023c1:	5b                   	pop    %ebx
801023c2:	5e                   	pop    %esi
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
801023c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	83 ec 10             	sub    $0x10,%esp
801023d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023db:	c7 44 24 04 b8 73 10 	movl   $0x801073b8,0x4(%esp)
801023e2:	80 
801023e3:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801023ea:	e8 61 21 00 00       	call   80104550 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ef:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023f2:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
801023f9:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102402:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102408:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010240e:	39 de                	cmp    %ebx,%esi
80102410:	73 0a                	jae    8010241c <kinit1+0x4c>
80102412:	eb 1a                	jmp    8010242e <kinit1+0x5e>
80102414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102418:	89 da                	mov    %ebx,%edx
8010241a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010241c:	89 14 24             	mov    %edx,(%esp)
8010241f:	e8 bc fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102424:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010242a:	39 c6                	cmp    %eax,%esi
8010242c:	73 ea                	jae    80102418 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010242e:	83 c4 10             	add    $0x10,%esp
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5d                   	pop    %ebp
80102434:	c3                   	ret    
80102435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
80102445:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010244b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102454:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 08                	jae    8010246c <kinit2+0x2c>
80102464:	eb 18                	jmp    8010247e <kinit2+0x3e>
80102466:	66 90                	xchg   %ax,%ax
80102468:	89 da                	mov    %ebx,%edx
8010246a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010246c:	89 14 24             	mov    %edx,(%esp)
8010246f:	e8 6c fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102474:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010247a:	39 c6                	cmp    %eax,%esi
8010247c:	73 ea                	jae    80102468 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010247e:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
80102485:	00 00 00 
}
80102488:	83 c4 10             	add    $0x10,%esp
8010248b:	5b                   	pop    %ebx
8010248c:	5e                   	pop    %esi
8010248d:	5d                   	pop    %ebp
8010248e:	c3                   	ret    
8010248f:	90                   	nop

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 94 26 11 80       	mov    0x80112694,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 08                	je     801024b2 <kalloc+0x22>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 0c                	je     801024c2 <kalloc+0x32>
    release(&kmem.lock);
801024b6:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801024bd:	e8 3e 22 00 00       	call   80104700 <release>
  return (char*)r;
}
801024c2:	83 c4 14             	add    $0x14,%esp
801024c5:	89 d8                	mov    %ebx,%eax
801024c7:	5b                   	pop    %ebx
801024c8:	5d                   	pop    %ebp
801024c9:	c3                   	ret    
801024ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024d0:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801024d7:	e8 f4 20 00 00       	call   801045d0 <acquire>
801024dc:	a1 94 26 11 80       	mov    0x80112694,%eax
801024e1:	eb bd                	jmp    801024a0 <kalloc+0x10>
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f0:	ba 64 00 00 00       	mov    $0x64,%edx
801024f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f6:	a8 01                	test   $0x1,%al
801024f8:	0f 84 ba 00 00 00    	je     801025b8 <kbdgetc+0xc8>
801024fe:	b2 60                	mov    $0x60,%dl
80102500:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102501:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102504:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010250a:	0f 84 88 00 00 00    	je     80102598 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102510:	84 c0                	test   %al,%al
80102512:	79 2c                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010251a:	f6 c2 40             	test   $0x40,%dl
8010251d:	75 05                	jne    80102524 <kbdgetc+0x34>
8010251f:	89 c1                	mov    %eax,%ecx
80102521:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102524:	0f b6 81 e0 74 10 80 	movzbl -0x7fef8b20(%ecx),%eax
8010252b:	83 c8 40             	or     $0x40,%eax
8010252e:	0f b6 c0             	movzbl %al,%eax
80102531:	f7 d0                	not    %eax
80102533:	21 d0                	and    %edx,%eax
80102535:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010253a:	31 c0                	xor    %eax,%eax
8010253c:	c3                   	ret    
8010253d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010254a:	f6 c3 40             	test   $0x40,%bl
8010254d:	74 09                	je     80102558 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102552:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102555:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102558:	0f b6 91 e0 74 10 80 	movzbl -0x7fef8b20(%ecx),%edx
  shift ^= togglecode[data];
8010255f:	0f b6 81 e0 73 10 80 	movzbl -0x7fef8c20(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102566:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102568:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010256a:	89 d0                	mov    %edx,%eax
8010256c:	83 e0 03             	and    $0x3,%eax
8010256f:	8b 04 85 c0 73 10 80 	mov    -0x7fef8c40(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102576:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010257c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010257f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102583:	74 0b                	je     80102590 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102585:	8d 50 9f             	lea    -0x61(%eax),%edx
80102588:	83 fa 19             	cmp    $0x19,%edx
8010258b:	77 1b                	ja     801025a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010258d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102590:	5b                   	pop    %ebx
80102591:	5d                   	pop    %ebp
80102592:	c3                   	ret    
80102593:	90                   	nop
80102594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102598:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010259f:	31 c0                	xor    %eax,%eax
801025a1:	c3                   	ret    
801025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025ab:	8d 50 20             	lea    0x20(%eax),%edx
801025ae:	83 f9 19             	cmp    $0x19,%ecx
801025b1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025b4:	eb da                	jmp    80102590 <kbdgetc+0xa0>
801025b6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax

801025c0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025c6:	c7 04 24 f0 24 10 80 	movl   $0x801024f0,(%esp)
801025cd:	e8 de e1 ff ff       	call   801007b0 <consoleintr>
}
801025d2:	c9                   	leave  
801025d3:	c3                   	ret    
801025d4:	66 90                	xchg   %ax,%ax
801025d6:	66 90                	xchg   %ax,%ax
801025d8:	66 90                	xchg   %ax,%ax
801025da:	66 90                	xchg   %ax,%ax
801025dc:	66 90                	xchg   %ax,%ax
801025de:	66 90                	xchg   %ax,%ax

801025e0 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801025e0:	55                   	push   %ebp
801025e1:	89 c1                	mov    %eax,%ecx
801025e3:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e5:	ba 70 00 00 00       	mov    $0x70,%edx
801025ea:	53                   	push   %ebx
801025eb:	31 c0                	xor    %eax,%eax
801025ed:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ee:	bb 71 00 00 00       	mov    $0x71,%ebx
801025f3:	89 da                	mov    %ebx,%edx
801025f5:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801025f6:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f9:	b2 70                	mov    $0x70,%dl
801025fb:	89 01                	mov    %eax,(%ecx)
801025fd:	b8 02 00 00 00       	mov    $0x2,%eax
80102602:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
80102606:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 41 04             	mov    %eax,0x4(%ecx)
8010260e:	b8 04 00 00 00       	mov    $0x4,%eax
80102613:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102614:	89 da                	mov    %ebx,%edx
80102616:	ec                   	in     (%dx),%al
80102617:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010261a:	b2 70                	mov    $0x70,%dl
8010261c:	89 41 08             	mov    %eax,0x8(%ecx)
8010261f:	b8 07 00 00 00       	mov    $0x7,%eax
80102624:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102625:	89 da                	mov    %ebx,%edx
80102627:	ec                   	in     (%dx),%al
80102628:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262b:	b2 70                	mov    $0x70,%dl
8010262d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102630:	b8 08 00 00 00       	mov    $0x8,%eax
80102635:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102636:	89 da                	mov    %ebx,%edx
80102638:	ec                   	in     (%dx),%al
80102639:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263c:	b2 70                	mov    $0x70,%dl
8010263e:	89 41 10             	mov    %eax,0x10(%ecx)
80102641:	b8 09 00 00 00       	mov    $0x9,%eax
80102646:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102647:	89 da                	mov    %ebx,%edx
80102649:	ec                   	in     (%dx),%al
8010264a:	0f b6 d8             	movzbl %al,%ebx
8010264d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102650:	5b                   	pop    %ebx
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret    
80102653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <lapicid>:
//PAGEBREAK!

int
lapicid(void)
{
  if (!lapic)
80102660:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}
//PAGEBREAK!

int
lapicid(void)
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102668:	85 c0                	test   %eax,%eax
8010266a:	74 0c                	je     80102678 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010266c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010266f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102670:	c1 e8 18             	shr    $0x18,%eax
}
80102673:	c3                   	ret    
80102674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102678:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010267a:	5d                   	pop    %ebp
8010267b:	c3                   	ret    
8010267c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102680 <lapicinit>:

void
lapicinit(void)
{
  if(!lapic)
80102680:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  return lapic[ID] >> 24;
}

void
lapicinit(void)
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102688:	85 c0                	test   %eax,%eax
8010268a:	0f 84 c0 00 00 00    	je     80102750 <lapicinit+0xd0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102690:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102697:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026aa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026b1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026be:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026c1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026cb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ce:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026d8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026db:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026de:	8b 50 30             	mov    0x30(%eax),%edx
801026e1:	c1 ea 10             	shr    $0x10,%edx
801026e4:	80 fa 03             	cmp    $0x3,%dl
801026e7:	77 6f                	ja     80102758 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f3:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102700:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102703:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010270a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102710:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102717:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102724:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102727:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010272a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102731:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102734:	8b 50 20             	mov    0x20(%eax),%edx
80102737:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102738:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010273e:	80 e6 10             	and    $0x10,%dh
80102741:	75 f5                	jne    80102738 <lapicinit+0xb8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102743:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010274a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102750:	5d                   	pop    %ebp
80102751:	c3                   	ret    
80102752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102758:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010275f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102762:	8b 50 20             	mov    0x20(%eax),%edx
80102765:	eb 82                	jmp    801026e9 <lapicinit+0x69>
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	56                   	push   %esi
80102774:	53                   	push   %ebx
80102775:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102778:	9c                   	pushf  
80102779:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010277a:	f6 c4 02             	test   $0x2,%ah
8010277d:	74 12                	je     80102791 <cpunum+0x21>
    static int n;
    if(n++ == 0)
8010277f:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80102784:	8d 50 01             	lea    0x1(%eax),%edx
80102787:	85 c0                	test   %eax,%eax
80102789:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
8010278f:	74 4a                	je     801027db <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
80102791:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102796:	85 c0                	test   %eax,%eax
80102798:	74 5d                	je     801027f7 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
8010279a:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010279d:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
801027a3:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
801027a6:	85 f6                	test   %esi,%esi
801027a8:	7e 56                	jle    80102800 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027aa:	0f b6 05 a0 27 11 80 	movzbl 0x801127a0,%eax
801027b1:	39 d8                	cmp    %ebx,%eax
801027b3:	74 42                	je     801027f7 <cpunum+0x87>
801027b5:	ba 5c 28 11 80       	mov    $0x8011285c,%edx

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
801027ba:	31 c0                	xor    %eax,%eax
801027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027c0:	83 c0 01             	add    $0x1,%eax
801027c3:	39 f0                	cmp    %esi,%eax
801027c5:	74 39                	je     80102800 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027c7:	0f b6 0a             	movzbl (%edx),%ecx
801027ca:	81 c2 bc 00 00 00    	add    $0xbc,%edx
801027d0:	39 d9                	cmp    %ebx,%ecx
801027d2:	75 ec                	jne    801027c0 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
801027d4:	83 c4 10             	add    $0x10,%esp
801027d7:	5b                   	pop    %ebx
801027d8:	5e                   	pop    %esi
801027d9:	5d                   	pop    %ebp
801027da:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
801027db:	8b 45 04             	mov    0x4(%ebp),%eax
801027de:	c7 04 24 e0 75 10 80 	movl   $0x801075e0,(%esp)
801027e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801027e9:	e8 62 de ff ff       	call   80100650 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
801027ee:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027f3:	85 c0                	test   %eax,%eax
801027f5:	75 a3                	jne    8010279a <cpunum+0x2a>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
801027f7:	83 c4 10             	add    $0x10,%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
801027fa:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
801027fc:	5b                   	pop    %ebx
801027fd:	5e                   	pop    %esi
801027fe:	5d                   	pop    %ebp
801027ff:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102800:	c7 04 24 0c 76 10 80 	movl   $0x8010760c,(%esp)
80102807:	e8 54 db ff ff       	call   80100360 <panic>
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102810 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102810:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102815:	55                   	push   %ebp
80102816:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102818:	85 c0                	test   %eax,%eax
8010281a:	74 0d                	je     80102829 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102823:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102826:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102829:	5d                   	pop    %ebp
8010282a:	c3                   	ret    
8010282b:	90                   	nop
8010282c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102830 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
}
80102833:	5d                   	pop    %ebp
80102834:	c3                   	ret    
80102835:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102840 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102840:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102841:	ba 70 00 00 00       	mov    $0x70,%edx
80102846:	89 e5                	mov    %esp,%ebp
80102848:	b8 0f 00 00 00       	mov    $0xf,%eax
8010284d:	53                   	push   %ebx
8010284e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102851:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102854:	ee                   	out    %al,(%dx)
80102855:	b8 0a 00 00 00       	mov    $0xa,%eax
8010285a:	b2 71                	mov    $0x71,%dl
8010285c:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010285d:	31 c0                	xor    %eax,%eax
8010285f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102865:	89 d8                	mov    %ebx,%eax
80102867:	c1 e8 04             	shr    $0x4,%eax
8010286a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102870:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102875:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102878:	c1 eb 0c             	shr    $0xc,%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010287b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102881:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102884:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010288b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102891:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102898:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010289e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028a7:	89 da                	mov    %ebx,%edx
801028a9:	80 ce 06             	or     $0x6,%dh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028ac:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028b2:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028b5:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028bb:	8b 48 20             	mov    0x20(%eax),%ecx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028be:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028c4:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801028c7:	5b                   	pop    %ebx
801028c8:	5d                   	pop    %ebp
801028c9:	c3                   	ret    
801028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028d0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028d0:	55                   	push   %ebp
801028d1:	ba 70 00 00 00       	mov    $0x70,%edx
801028d6:	89 e5                	mov    %esp,%ebp
801028d8:	b8 0b 00 00 00       	mov    $0xb,%eax
801028dd:	57                   	push   %edi
801028de:	56                   	push   %esi
801028df:	53                   	push   %ebx
801028e0:	83 ec 4c             	sub    $0x4c,%esp
801028e3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028e4:	b2 71                	mov    $0x71,%dl
801028e6:	ec                   	in     (%dx),%al
801028e7:	88 45 b7             	mov    %al,-0x49(%ebp)
801028ea:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801028ed:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
801028f1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801028f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f8:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801028fd:	89 d8                	mov    %ebx,%eax
801028ff:	e8 dc fc ff ff       	call   801025e0 <fill_rtcdate>
80102904:	b8 0a 00 00 00       	mov    $0xa,%eax
80102909:	89 f2                	mov    %esi,%edx
8010290b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290c:	ba 71 00 00 00       	mov    $0x71,%edx
80102911:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102912:	84 c0                	test   %al,%al
80102914:	78 e7                	js     801028fd <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102916:	89 f8                	mov    %edi,%eax
80102918:	e8 c3 fc ff ff       	call   801025e0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010291d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102924:	00 
80102925:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102929:	89 1c 24             	mov    %ebx,(%esp)
8010292c:	e8 6f 1e 00 00       	call   801047a0 <memcmp>
80102931:	85 c0                	test   %eax,%eax
80102933:	75 c3                	jne    801028f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102935:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102939:	75 78                	jne    801029b3 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010293b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010293e:	89 c2                	mov    %eax,%edx
80102940:	83 e0 0f             	and    $0xf,%eax
80102943:	c1 ea 04             	shr    $0x4,%edx
80102946:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102949:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010294c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010294f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102952:	89 c2                	mov    %eax,%edx
80102954:	83 e0 0f             	and    $0xf,%eax
80102957:	c1 ea 04             	shr    $0x4,%edx
8010295a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102960:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102963:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102966:	89 c2                	mov    %eax,%edx
80102968:	83 e0 0f             	and    $0xf,%eax
8010296b:	c1 ea 04             	shr    $0x4,%edx
8010296e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102971:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102974:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102977:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010297a:	89 c2                	mov    %eax,%edx
8010297c:	83 e0 0f             	and    $0xf,%eax
8010297f:	c1 ea 04             	shr    $0x4,%edx
80102982:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102985:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102988:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010298b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010298e:	89 c2                	mov    %eax,%edx
80102990:	83 e0 0f             	and    $0xf,%eax
80102993:	c1 ea 04             	shr    $0x4,%edx
80102996:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102999:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010299f:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029a2:	89 c2                	mov    %eax,%edx
801029a4:	83 e0 0f             	and    $0xf,%eax
801029a7:	c1 ea 04             	shr    $0x4,%edx
801029aa:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ad:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b0:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801029b6:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029b9:	89 01                	mov    %eax,(%ecx)
801029bb:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029be:	89 41 04             	mov    %eax,0x4(%ecx)
801029c1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029c4:	89 41 08             	mov    %eax,0x8(%ecx)
801029c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ca:	89 41 0c             	mov    %eax,0xc(%ecx)
801029cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029d0:	89 41 10             	mov    %eax,0x10(%ecx)
801029d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029d6:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
801029d9:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
801029e0:	83 c4 4c             	add    $0x4c,%esp
801029e3:	5b                   	pop    %ebx
801029e4:	5e                   	pop    %esi
801029e5:	5f                   	pop    %edi
801029e6:	5d                   	pop    %ebp
801029e7:	c3                   	ret    
801029e8:	66 90                	xchg   %ax,%ax
801029ea:	66 90                	xchg   %ax,%ax
801029ec:	66 90                	xchg   %ax,%ax
801029ee:	66 90                	xchg   %ax,%ax

801029f0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029f0:	55                   	push   %ebp
801029f1:	89 e5                	mov    %esp,%ebp
801029f3:	57                   	push   %edi
801029f4:	56                   	push   %esi
801029f5:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029f6:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029f8:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029fb:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102a00:	85 c0                	test   %eax,%eax
80102a02:	7e 78                	jle    80102a7c <install_trans+0x8c>
80102a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a08:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a0d:	01 d8                	add    %ebx,%eax
80102a0f:	83 c0 01             	add    $0x1,%eax
80102a12:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a16:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a1b:	89 04 24             	mov    %eax,(%esp)
80102a1e:	e8 ad d6 ff ff       	call   801000d0 <bread>
80102a23:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a25:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a2c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a33:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a38:	89 04 24             	mov    %eax,(%esp)
80102a3b:	e8 90 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a47:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a48:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a4a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a51:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a54:	89 04 24             	mov    %eax,(%esp)
80102a57:	e8 94 1d 00 00       	call   801047f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a5c:	89 34 24             	mov    %esi,(%esp)
80102a5f:	e8 3c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a64:	89 3c 24             	mov    %edi,(%esp)
80102a67:	e8 74 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a6c:	89 34 24             	mov    %esi,(%esp)
80102a6f:	e8 6c d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a74:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102a7a:	7f 8c                	jg     80102a08 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a7c:	83 c4 1c             	add    $0x1c,%esp
80102a7f:	5b                   	pop    %ebx
80102a80:	5e                   	pop    %esi
80102a81:	5f                   	pop    %edi
80102a82:	5d                   	pop    %ebp
80102a83:	c3                   	ret    
80102a84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	57                   	push   %edi
80102a94:	56                   	push   %esi
80102a95:	53                   	push   %ebx
80102a96:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a99:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aa2:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102aa7:	89 04 24             	mov    %eax,(%esp)
80102aaa:	e8 21 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102aaf:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ab5:	31 d2                	xor    %edx,%edx
80102ab7:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ab9:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102abb:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102abe:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac1:	7e 17                	jle    80102ada <write_head+0x4a>
80102ac3:	90                   	nop
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ac8:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102acf:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ad3:	83 c2 01             	add    $0x1,%edx
80102ad6:	39 da                	cmp    %ebx,%edx
80102ad8:	75 ee                	jne    80102ac8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102ada:	89 3c 24             	mov    %edi,(%esp)
80102add:	e8 be d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ae2:	89 3c 24             	mov    %edi,(%esp)
80102ae5:	e8 f6 d6 ff ff       	call   801001e0 <brelse>
}
80102aea:	83 c4 1c             	add    $0x1c,%esp
80102aed:	5b                   	pop    %ebx
80102aee:	5e                   	pop    %esi
80102aef:	5f                   	pop    %edi
80102af0:	5d                   	pop    %ebp
80102af1:	c3                   	ret    
80102af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b00 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	56                   	push   %esi
80102b04:	53                   	push   %ebx
80102b05:	83 ec 30             	sub    $0x30,%esp
80102b08:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b0b:	c7 44 24 04 1c 76 10 	movl   $0x8010761c,0x4(%esp)
80102b12:	80 
80102b13:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102b1a:	e8 31 1a 00 00       	call   80104550 <initlock>
  readsb(dev, &sb);
80102b1f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b22:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b26:	89 1c 24             	mov    %ebx,(%esp)
80102b29:	e8 62 e8 ff ff       	call   80101390 <readsb>
  log.start = sb.logstart;
80102b2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b31:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b34:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b37:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b41:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b47:	a3 d4 26 11 80       	mov    %eax,0x801126d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b4c:	e8 7f d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b51:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b53:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b56:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b59:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b5b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102b61:	7e 17                	jle    80102b7a <initlog+0x7a>
80102b63:	90                   	nop
80102b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b68:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b6c:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b73:	83 c2 01             	add    $0x1,%edx
80102b76:	39 da                	cmp    %ebx,%edx
80102b78:	75 ee                	jne    80102b68 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b7a:	89 04 24             	mov    %eax,(%esp)
80102b7d:	e8 5e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b82:	e8 69 fe ff ff       	call   801029f0 <install_trans>
  log.lh.n = 0;
80102b87:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102b8e:	00 00 00 
  write_head(); // clear the log
80102b91:	e8 fa fe ff ff       	call   80102a90 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b96:	83 c4 30             	add    $0x30,%esp
80102b99:	5b                   	pop    %ebx
80102b9a:	5e                   	pop    %esi
80102b9b:	5d                   	pop    %ebp
80102b9c:	c3                   	ret    
80102b9d:	8d 76 00             	lea    0x0(%esi),%esi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102ba6:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102bad:	e8 1e 1a 00 00       	call   801045d0 <acquire>
80102bb2:	eb 18                	jmp    80102bcc <begin_op+0x2c>
80102bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	c7 44 24 04 a0 26 11 	movl   $0x801126a0,0x4(%esp)
80102bbf:	80 
80102bc0:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102bc7:	e8 14 13 00 00       	call   80103ee0 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bcc:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102bd1:	85 c0                	test   %eax,%eax
80102bd3:	75 e3                	jne    80102bb8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd5:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102bda:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102be0:	83 c0 01             	add    $0x1,%eax
80102be3:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be6:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102be9:	83 fa 1e             	cmp    $0x1e,%edx
80102bec:	7f ca                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bee:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102bf5:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102bfa:	e8 01 1b 00 00       	call   80104700 <release>
      break;
    }
  }
}
80102bff:	c9                   	leave  
80102c00:	c3                   	ret    
80102c01:	eb 0d                	jmp    80102c10 <end_op>
80102c03:	90                   	nop
80102c04:	90                   	nop
80102c05:	90                   	nop
80102c06:	90                   	nop
80102c07:	90                   	nop
80102c08:	90                   	nop
80102c09:	90                   	nop
80102c0a:	90                   	nop
80102c0b:	90                   	nop
80102c0c:	90                   	nop
80102c0d:	90                   	nop
80102c0e:	90                   	nop
80102c0f:	90                   	nop

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c20:	e8 ab 19 00 00       	call   801045d0 <acquire>
  log.outstanding -= 1;
80102c25:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c2a:	8b 15 e0 26 11 80    	mov    0x801126e0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c30:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c33:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c35:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102c3a:	0f 85 f3 00 00 00    	jne    80102d33 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c40:	85 c0                	test   %eax,%eax
80102c42:	0f 85 cb 00 00 00    	jne    80102d13 <end_op+0x103>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c48:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c4f:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c51:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c58:	00 00 00 
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c5b:	e8 a0 1a 00 00       	call   80104700 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c60:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c65:	85 c0                	test   %eax,%eax
80102c67:	0f 8e 90 00 00 00    	jle    80102cfd <end_op+0xed>
80102c6d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c70:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c75:	01 d8                	add    %ebx,%eax
80102c77:	83 c0 01             	add    $0x1,%eax
80102c7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c7e:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102c83:	89 04 24             	mov    %eax,(%esp)
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c94:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c97:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c9b:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102ca0:	89 04 24             	mov    %eax,(%esp)
80102ca3:	e8 28 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ca8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102caf:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cb0:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cb2:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cb9:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cbc:	89 04 24             	mov    %eax,(%esp)
80102cbf:	e8 2c 1b 00 00       	call   801047f0 <memmove>
    bwrite(to);  // write the log
80102cc4:	89 34 24             	mov    %esi,(%esp)
80102cc7:	e8 d4 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102ccc:	89 3c 24             	mov    %edi,(%esp)
80102ccf:	e8 0c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cd4:	89 34 24             	mov    %esi,(%esp)
80102cd7:	e8 04 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cdc:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102ce2:	7c 8c                	jl     80102c70 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ce4:	e8 a7 fd ff ff       	call   80102a90 <write_head>
    install_trans(); // Now install writes to home locations
80102ce9:	e8 02 fd ff ff       	call   801029f0 <install_trans>
    log.lh.n = 0;
80102cee:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102cf5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf8:	e8 93 fd ff ff       	call   80102a90 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cfd:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d04:	e8 c7 18 00 00       	call   801045d0 <acquire>
    log.committing = 0;
80102d09:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102d10:	00 00 00 
    wakeup(&log);
80102d13:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d1a:	e8 61 13 00 00       	call   80104080 <wakeup>
    release(&log.lock);
80102d1f:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d26:	e8 d5 19 00 00       	call   80104700 <release>
  }
}
80102d2b:	83 c4 1c             	add    $0x1c,%esp
80102d2e:	5b                   	pop    %ebx
80102d2f:	5e                   	pop    %esi
80102d30:	5f                   	pop    %edi
80102d31:	5d                   	pop    %ebp
80102d32:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d33:	c7 04 24 20 76 10 80 	movl   $0x80107620,(%esp)
80102d3a:	e8 21 d6 ff ff       	call   80100360 <panic>
80102d3f:	90                   	nop

80102d40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	53                   	push   %ebx
80102d44:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d47:	a1 e8 26 11 80       	mov    0x801126e8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d4f:	83 f8 1d             	cmp    $0x1d,%eax
80102d52:	0f 8f 98 00 00 00    	jg     80102df0 <log_write+0xb0>
80102d58:	8b 0d d8 26 11 80    	mov    0x801126d8,%ecx
80102d5e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d61:	39 d0                	cmp    %edx,%eax
80102d63:	0f 8d 87 00 00 00    	jge    80102df0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d69:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d6e:	85 c0                	test   %eax,%eax
80102d70:	0f 8e 86 00 00 00    	jle    80102dfc <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d76:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d7d:	e8 4e 18 00 00       	call   801045d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d82:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102d88:	83 fa 00             	cmp    $0x0,%edx
80102d8b:	7e 54                	jle    80102de1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d8d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d90:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d92:	39 0d ec 26 11 80    	cmp    %ecx,0x801126ec
80102d98:	75 0f                	jne    80102da9 <log_write+0x69>
80102d9a:	eb 3c                	jmp    80102dd8 <log_write+0x98>
80102d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102da0:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102da7:	74 2f                	je     80102dd8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102da9:	83 c0 01             	add    $0x1,%eax
80102dac:	39 d0                	cmp    %edx,%eax
80102dae:	75 f0                	jne    80102da0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102db0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102db7:	83 c2 01             	add    $0x1,%edx
80102dba:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102dc0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102dc3:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102dca:	83 c4 14             	add    $0x14,%esp
80102dcd:	5b                   	pop    %ebx
80102dce:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dcf:	e9 2c 19 00 00       	jmp    80104700 <release>
80102dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102dd8:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102ddf:	eb df                	jmp    80102dc0 <log_write+0x80>
80102de1:	8b 43 08             	mov    0x8(%ebx),%eax
80102de4:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102de9:	75 d5                	jne    80102dc0 <log_write+0x80>
80102deb:	eb ca                	jmp    80102db7 <log_write+0x77>
80102ded:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102df0:	c7 04 24 2f 76 10 80 	movl   $0x8010762f,(%esp)
80102df7:	e8 64 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102dfc:	c7 04 24 45 76 10 80 	movl   $0x80107645,(%esp)
80102e03:	e8 58 d5 ff ff       	call   80100360 <panic>
80102e08:	66 90                	xchg   %ax,%ax
80102e0a:	66 90                	xchg   %ax,%ax
80102e0c:	66 90                	xchg   %ax,%ax
80102e0e:	66 90                	xchg   %ax,%ax

80102e10 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102e16:	e8 55 f9 ff ff       	call   80102770 <cpunum>
80102e1b:	c7 04 24 60 76 10 80 	movl   $0x80107660,(%esp)
80102e22:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e26:	e8 25 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102e2b:	e8 b0 2b 00 00       	call   801059e0 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102e30:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e37:	b8 01 00 00 00       	mov    $0x1,%eax
80102e3c:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102e43:	e8 e8 0d 00 00       	call   80103c30 <scheduler>
80102e48:	90                   	nop
80102e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e50 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e56:	e8 75 3d 00 00       	call   80106bd0 <switchkvm>
  seginit();
80102e5b:	e8 90 3b 00 00       	call   801069f0 <seginit>
  lapicinit();
80102e60:	e8 1b f8 ff ff       	call   80102680 <lapicinit>
  mpmain();
80102e65:	e8 a6 ff ff ff       	call   80102e10 <mpmain>
80102e6a:	66 90                	xchg   %ax,%ax
80102e6c:	66 90                	xchg   %ax,%ax
80102e6e:	66 90                	xchg   %ax,%ax

80102e70 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 e4 f0             	and    $0xfffffff0,%esp
80102e77:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e7a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e81:	80 
80102e82:	c7 04 24 28 65 11 80 	movl   $0x80116528,(%esp)
80102e89:	e8 42 f5 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102e8e:	e8 1d 3d 00 00       	call   80106bb0 <kvmalloc>
  mpinit();        // detect other processors
80102e93:	e8 a8 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102e98:	e8 e3 f7 ff ff       	call   80102680 <lapicinit>
80102e9d:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80102ea0:	e8 4b 3b 00 00       	call   801069f0 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102ea5:	e8 c6 f8 ff ff       	call   80102770 <cpunum>
80102eaa:	c7 04 24 71 76 10 80 	movl   $0x80107671,(%esp)
80102eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80102eb5:	e8 96 d7 ff ff       	call   80100650 <cprintf>
  picinit();       // another interrupt controller
80102eba:	e8 81 03 00 00       	call   80103240 <picinit>
  ioapicinit();    // another interrupt controller
80102ebf:	e8 2c f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102ec4:	e8 87 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102ec9:	e8 32 2e 00 00       	call   80105d00 <uartinit>
80102ece:	66 90                	xchg   %ax,%ax
  pinit();         // process table
80102ed0:	e8 db 09 00 00       	call   801038b0 <pinit>
  tvinit();        // trap vectors
80102ed5:	e8 66 2a 00 00       	call   80105940 <tvinit>
  binit();         // buffer cache
80102eda:	e8 61 d1 ff ff       	call   80100040 <binit>
80102edf:	90                   	nop
  fileinit();      // file table
80102ee0:	e8 5b de ff ff       	call   80100d40 <fileinit>
  ideinit();       // disk
80102ee5:	e8 f6 f0 ff ff       	call   80101fe0 <ideinit>
  if(!ismp)
80102eea:	a1 84 27 11 80       	mov    0x80112784,%eax
80102eef:	85 c0                	test   %eax,%eax
80102ef1:	0f 84 ca 00 00 00    	je     80102fc1 <main+0x151>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ef7:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102efe:	00 

  for(c = cpus; c < cpus+ncpu; c++){
80102eff:	bb a0 27 11 80       	mov    $0x801127a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f04:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102f0b:	80 
80102f0c:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102f13:	e8 d8 18 00 00       	call   801047f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f18:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f1f:	00 00 00 
80102f22:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f27:	39 d8                	cmp    %ebx,%eax
80102f29:	76 78                	jbe    80102fa3 <main+0x133>
80102f2b:	90                   	nop
80102f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
80102f30:	e8 3b f8 ff ff       	call   80102770 <cpunum>
80102f35:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102f3b:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f40:	39 c3                	cmp    %eax,%ebx
80102f42:	74 46                	je     80102f8a <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f44:	e8 47 f5 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f49:	c7 05 f8 6f 00 80 50 	movl   $0x80102e50,0x80006ff8
80102f50:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f53:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f5a:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f5d:	05 00 10 00 00       	add    $0x1000,%eax
80102f62:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f67:	0f b6 03             	movzbl (%ebx),%eax
80102f6a:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f71:	00 
80102f72:	89 04 24             	mov    %eax,(%esp)
80102f75:	e8 c6 f8 ff ff       	call   80102840 <lapicstartap>
80102f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f80:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f8a:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f91:	00 00 00 
80102f94:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102f9a:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 8d                	jb     80102f30 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fa3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102faa:	8e 
80102fab:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102fb2:	e8 89 f4 ff ff       	call   80102440 <kinit2>
  userinit();      // first user process
80102fb7:	e8 14 09 00 00       	call   801038d0 <userinit>
  mpmain();        // finish this processor's setup
80102fbc:	e8 4f fe ff ff       	call   80102e10 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80102fc1:	e8 1a 29 00 00       	call   801058e0 <timerinit>
80102fc6:	e9 2c ff ff ff       	jmp    80102ef7 <main+0x87>
80102fcb:	66 90                	xchg   %ax,%ax
80102fcd:	66 90                	xchg   %ax,%ax
80102fcf:	90                   	nop

80102fd0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fd4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fda:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102fdb:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fde:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fe1:	39 de                	cmp    %ebx,%esi
80102fe3:	73 3c                	jae    80103021 <mpsearch1+0x51>
80102fe5:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fef:	00 
80102ff0:	c7 44 24 04 88 76 10 	movl   $0x80107688,0x4(%esp)
80102ff7:	80 
80102ff8:	89 34 24             	mov    %esi,(%esp)
80102ffb:	e8 a0 17 00 00       	call   801047a0 <memcmp>
80103000:	85 c0                	test   %eax,%eax
80103002:	75 16                	jne    8010301a <mpsearch1+0x4a>
80103004:	31 c9                	xor    %ecx,%ecx
80103006:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103008:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010300c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010300f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103011:	83 fa 10             	cmp    $0x10,%edx
80103014:	75 f2                	jne    80103008 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103016:	84 c9                	test   %cl,%cl
80103018:	74 10                	je     8010302a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
8010301a:	83 c6 10             	add    $0x10,%esi
8010301d:	39 f3                	cmp    %esi,%ebx
8010301f:	77 c7                	ja     80102fe8 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80103021:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103024:	31 c0                	xor    %eax,%eax
}
80103026:	5b                   	pop    %ebx
80103027:	5e                   	pop    %esi
80103028:	5d                   	pop    %ebp
80103029:	c3                   	ret    
8010302a:	83 c4 10             	add    $0x10,%esp
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5d                   	pop    %ebp
80103032:	c3                   	ret    
80103033:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103040 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 48 ff ff ff       	call   80102fd0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 c7                	mov    %eax,%edi
8010308c:	0f 84 4e 01 00 00    	je     801031e0 <mpinit+0x1a0>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103092:	8b 77 04             	mov    0x4(%edi),%esi
80103095:	85 f6                	test   %esi,%esi
80103097:	0f 84 ce 00 00 00    	je     8010316b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010309d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801030a3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801030aa:	00 
801030ab:	c7 44 24 04 8d 76 10 	movl   $0x8010768d,0x4(%esp)
801030b2:	80 
801030b3:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801030b9:	e8 e2 16 00 00       	call   801047a0 <memcmp>
801030be:	85 c0                	test   %eax,%eax
801030c0:	0f 85 a5 00 00 00    	jne    8010316b <mpinit+0x12b>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801030c6:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801030cd:	3c 04                	cmp    $0x4,%al
801030cf:	0f 85 29 01 00 00    	jne    801031fe <mpinit+0x1be>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030d5:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030dc:	85 c0                	test   %eax,%eax
801030de:	74 1d                	je     801030fd <mpinit+0xbd>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
801030e0:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
801030e2:	31 d2                	xor    %edx,%edx
801030e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030e8:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
801030ef:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030f0:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801030f3:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030f5:	39 d0                	cmp    %edx,%eax
801030f7:	7f ef                	jg     801030e8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030f9:	84 c9                	test   %cl,%cl
801030fb:	75 6e                	jne    8010316b <mpinit+0x12b>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030fd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103100:	85 db                	test   %ebx,%ebx
80103102:	74 67                	je     8010316b <mpinit+0x12b>
    return;
  ismp = 1;
80103104:	c7 05 84 27 11 80 01 	movl   $0x1,0x80112784
8010310b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010310e:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103114:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103119:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
80103120:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103126:	01 d9                	add    %ebx,%ecx
80103128:	39 c8                	cmp    %ecx,%eax
8010312a:	0f 83 90 00 00 00    	jae    801031c0 <mpinit+0x180>
    switch(*p){
80103130:	80 38 04             	cmpb   $0x4,(%eax)
80103133:	77 7b                	ja     801031b0 <mpinit+0x170>
80103135:	0f b6 10             	movzbl (%eax),%edx
80103138:	ff 24 95 94 76 10 80 	jmp    *-0x7fef896c(,%edx,4)
8010313f:	90                   	nop
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103140:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103143:	39 c1                	cmp    %eax,%ecx
80103145:	77 e9                	ja     80103130 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103147:	a1 84 27 11 80       	mov    0x80112784,%eax
8010314c:	85 c0                	test   %eax,%eax
8010314e:	75 70                	jne    801031c0 <mpinit+0x180>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103150:	c7 05 80 2d 11 80 01 	movl   $0x1,0x80112d80
80103157:	00 00 00 
    lapic = 0;
8010315a:	c7 05 9c 26 11 80 00 	movl   $0x0,0x8011269c
80103161:	00 00 00 
    ioapicid = 0;
80103164:	c6 05 80 27 11 80 00 	movb   $0x0,0x80112780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010316b:	83 c4 1c             	add    $0x1c,%esp
8010316e:	5b                   	pop    %ebx
8010316f:	5e                   	pop    %esi
80103170:	5f                   	pop    %edi
80103171:	5d                   	pop    %ebp
80103172:	c3                   	ret    
80103173:	90                   	nop
80103174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103178:	8b 15 80 2d 11 80    	mov    0x80112d80,%edx
8010317e:	83 fa 07             	cmp    $0x7,%edx
80103181:	7f 17                	jg     8010319a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103183:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
80103187:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
        ncpu++;
8010318d:	83 05 80 2d 11 80 01 	addl   $0x1,0x80112d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103194:	88 9a a0 27 11 80    	mov    %bl,-0x7feed860(%edx)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010319a:	83 c0 14             	add    $0x14,%eax
      continue;
8010319d:	eb a4                	jmp    80103143 <mpinit+0x103>
8010319f:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031a0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031a4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031a7:	88 15 80 27 11 80    	mov    %dl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
801031ad:	eb 94                	jmp    80103143 <mpinit+0x103>
801031af:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031b0:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
801031b7:	00 00 00 
      break;
801031ba:	eb 87                	jmp    80103143 <mpinit+0x103>
801031bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
801031c0:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801031c4:	74 a5                	je     8010316b <mpinit+0x12b>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031c6:	ba 22 00 00 00       	mov    $0x22,%edx
801031cb:	b8 70 00 00 00       	mov    $0x70,%eax
801031d0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031d1:	b2 23                	mov    $0x23,%dl
801031d3:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031d4:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031d7:	ee                   	out    %al,(%dx)
  }
}
801031d8:	83 c4 1c             	add    $0x1c,%esp
801031db:	5b                   	pop    %ebx
801031dc:	5e                   	pop    %esi
801031dd:	5f                   	pop    %edi
801031de:	5d                   	pop    %ebp
801031df:	c3                   	ret    
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031ea:	e8 e1 fd ff ff       	call   80102fd0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031ef:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031f1:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031f3:	0f 85 99 fe ff ff    	jne    80103092 <mpinit+0x52>
801031f9:	e9 6d ff ff ff       	jmp    8010316b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
801031fe:	3c 01                	cmp    $0x1,%al
80103200:	0f 84 cf fe ff ff    	je     801030d5 <mpinit+0x95>
80103206:	e9 60 ff ff ff       	jmp    8010316b <mpinit+0x12b>
8010320b:	66 90                	xchg   %ax,%ax
8010320d:	66 90                	xchg   %ax,%ax
8010320f:	90                   	nop

80103210 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103210:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103211:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103216:	89 e5                	mov    %esp,%ebp
80103218:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
8010321d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103220:	d3 c0                	rol    %cl,%eax
80103222:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80103229:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
8010322f:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
80103230:	66 c1 e8 08          	shr    $0x8,%ax
80103234:	b2 a1                	mov    $0xa1,%dl
80103236:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
80103237:	5d                   	pop    %ebp
80103238:	c3                   	ret    
80103239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103240 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103240:	55                   	push   %ebp
80103241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103246:	89 e5                	mov    %esp,%ebp
80103248:	57                   	push   %edi
80103249:	56                   	push   %esi
8010324a:	53                   	push   %ebx
8010324b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103250:	89 da                	mov    %ebx,%edx
80103252:	ee                   	out    %al,(%dx)
80103253:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103258:	89 ca                	mov    %ecx,%edx
8010325a:	ee                   	out    %al,(%dx)
8010325b:	bf 11 00 00 00       	mov    $0x11,%edi
80103260:	be 20 00 00 00       	mov    $0x20,%esi
80103265:	89 f8                	mov    %edi,%eax
80103267:	89 f2                	mov    %esi,%edx
80103269:	ee                   	out    %al,(%dx)
8010326a:	b8 20 00 00 00       	mov    $0x20,%eax
8010326f:	89 da                	mov    %ebx,%edx
80103271:	ee                   	out    %al,(%dx)
80103272:	b8 04 00 00 00       	mov    $0x4,%eax
80103277:	ee                   	out    %al,(%dx)
80103278:	b8 03 00 00 00       	mov    $0x3,%eax
8010327d:	ee                   	out    %al,(%dx)
8010327e:	b3 a0                	mov    $0xa0,%bl
80103280:	89 f8                	mov    %edi,%eax
80103282:	89 da                	mov    %ebx,%edx
80103284:	ee                   	out    %al,(%dx)
80103285:	b8 28 00 00 00       	mov    $0x28,%eax
8010328a:	89 ca                	mov    %ecx,%edx
8010328c:	ee                   	out    %al,(%dx)
8010328d:	b8 02 00 00 00       	mov    $0x2,%eax
80103292:	ee                   	out    %al,(%dx)
80103293:	b8 03 00 00 00       	mov    $0x3,%eax
80103298:	ee                   	out    %al,(%dx)
80103299:	bf 68 00 00 00       	mov    $0x68,%edi
8010329e:	89 f2                	mov    %esi,%edx
801032a0:	89 f8                	mov    %edi,%eax
801032a2:	ee                   	out    %al,(%dx)
801032a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
801032a8:	89 c8                	mov    %ecx,%eax
801032aa:	ee                   	out    %al,(%dx)
801032ab:	89 f8                	mov    %edi,%eax
801032ad:	89 da                	mov    %ebx,%edx
801032af:	ee                   	out    %al,(%dx)
801032b0:	89 c8                	mov    %ecx,%eax
801032b2:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
801032b3:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
801032ba:	66 83 f8 ff          	cmp    $0xffff,%ax
801032be:	74 0a                	je     801032ca <picinit+0x8a>
801032c0:	b2 21                	mov    $0x21,%dl
801032c2:	ee                   	out    %al,(%dx)
static void
picsetmask(ushort mask)
{
  irqmask = mask;
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
801032c3:	66 c1 e8 08          	shr    $0x8,%ax
801032c7:	b2 a1                	mov    $0xa1,%dl
801032c9:	ee                   	out    %al,(%dx)
  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    picsetmask(irqmask);
}
801032ca:	5b                   	pop    %ebx
801032cb:	5e                   	pop    %esi
801032cc:	5f                   	pop    %edi
801032cd:	5d                   	pop    %ebp
801032ce:	c3                   	ret    
801032cf:	90                   	nop

801032d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	57                   	push   %edi
801032d4:	56                   	push   %esi
801032d5:	53                   	push   %ebx
801032d6:	83 ec 1c             	sub    $0x1c,%esp
801032d9:	8b 75 08             	mov    0x8(%ebp),%esi
801032dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801032e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032eb:	e8 70 da ff ff       	call   80100d60 <filealloc>
801032f0:	85 c0                	test   %eax,%eax
801032f2:	89 06                	mov    %eax,(%esi)
801032f4:	0f 84 a4 00 00 00    	je     8010339e <pipealloc+0xce>
801032fa:	e8 61 da ff ff       	call   80100d60 <filealloc>
801032ff:	85 c0                	test   %eax,%eax
80103301:	89 03                	mov    %eax,(%ebx)
80103303:	0f 84 87 00 00 00    	je     80103390 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103309:	e8 82 f1 ff ff       	call   80102490 <kalloc>
8010330e:	85 c0                	test   %eax,%eax
80103310:	89 c7                	mov    %eax,%edi
80103312:	74 7c                	je     80103390 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103314:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010331b:	00 00 00 
  p->writeopen = 1;
8010331e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103325:	00 00 00 
  p->nwrite = 0;
80103328:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010332f:	00 00 00 
  p->nread = 0;
80103332:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103339:	00 00 00 
  initlock(&p->lock, "pipe");
8010333c:	89 04 24             	mov    %eax,(%esp)
8010333f:	c7 44 24 04 a8 76 10 	movl   $0x801076a8,0x4(%esp)
80103346:	80 
80103347:	e8 04 12 00 00       	call   80104550 <initlock>
  (*f0)->type = FD_PIPE;
8010334c:	8b 06                	mov    (%esi),%eax
8010334e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103354:	8b 06                	mov    (%esi),%eax
80103356:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010335a:	8b 06                	mov    (%esi),%eax
8010335c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103360:	8b 06                	mov    (%esi),%eax
80103362:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103365:	8b 03                	mov    (%ebx),%eax
80103367:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010336d:	8b 03                	mov    (%ebx),%eax
8010336f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103373:	8b 03                	mov    (%ebx),%eax
80103375:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103379:	8b 03                	mov    (%ebx),%eax
  return 0;
8010337b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010337d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103380:	83 c4 1c             	add    $0x1c,%esp
80103383:	89 d8                	mov    %ebx,%eax
80103385:	5b                   	pop    %ebx
80103386:	5e                   	pop    %esi
80103387:	5f                   	pop    %edi
80103388:	5d                   	pop    %ebp
80103389:	c3                   	ret    
8010338a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103390:	8b 06                	mov    (%esi),%eax
80103392:	85 c0                	test   %eax,%eax
80103394:	74 08                	je     8010339e <pipealloc+0xce>
    fileclose(*f0);
80103396:	89 04 24             	mov    %eax,(%esp)
80103399:	e8 82 da ff ff       	call   80100e20 <fileclose>
  if(*f1)
8010339e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
801033a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
801033a5:	85 c0                	test   %eax,%eax
801033a7:	74 d7                	je     80103380 <pipealloc+0xb0>
    fileclose(*f1);
801033a9:	89 04 24             	mov    %eax,(%esp)
801033ac:	e8 6f da ff ff       	call   80100e20 <fileclose>
  return -1;
}
801033b1:	83 c4 1c             	add    $0x1c,%esp
801033b4:	89 d8                	mov    %ebx,%eax
801033b6:	5b                   	pop    %ebx
801033b7:	5e                   	pop    %esi
801033b8:	5f                   	pop    %edi
801033b9:	5d                   	pop    %ebp
801033ba:	c3                   	ret    
801033bb:	90                   	nop
801033bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033c0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	56                   	push   %esi
801033c4:	53                   	push   %ebx
801033c5:	83 ec 10             	sub    $0x10,%esp
801033c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033ce:	89 1c 24             	mov    %ebx,(%esp)
801033d1:	e8 fa 11 00 00       	call   801045d0 <acquire>
  if(writable){
801033d6:	85 f6                	test   %esi,%esi
801033d8:	74 3e                	je     80103418 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801033da:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801033e0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033e7:	00 00 00 
    wakeup(&p->nread);
801033ea:	89 04 24             	mov    %eax,(%esp)
801033ed:	e8 8e 0c 00 00       	call   80104080 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033f2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033f8:	85 d2                	test   %edx,%edx
801033fa:	75 0a                	jne    80103406 <pipeclose+0x46>
801033fc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103402:	85 c0                	test   %eax,%eax
80103404:	74 32                	je     80103438 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103406:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	5b                   	pop    %ebx
8010340d:	5e                   	pop    %esi
8010340e:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010340f:	e9 ec 12 00 00       	jmp    80104700 <release>
80103414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103418:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
8010341e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103425:	00 00 00 
    wakeup(&p->nwrite);
80103428:	89 04 24             	mov    %eax,(%esp)
8010342b:	e8 50 0c 00 00       	call   80104080 <wakeup>
80103430:	eb c0                	jmp    801033f2 <pipeclose+0x32>
80103432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103438:	89 1c 24             	mov    %ebx,(%esp)
8010343b:	e8 c0 12 00 00       	call   80104700 <release>
    kfree((char*)p);
80103440:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103443:	83 c4 10             	add    $0x10,%esp
80103446:	5b                   	pop    %ebx
80103447:	5e                   	pop    %esi
80103448:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103449:	e9 92 ee ff ff       	jmp    801022e0 <kfree>
8010344e:	66 90                	xchg   %ax,%ax

80103450 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	57                   	push   %edi
80103454:	56                   	push   %esi
80103455:	53                   	push   %ebx
80103456:	83 ec 1c             	sub    $0x1c,%esp
80103459:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010345c:	89 3c 24             	mov    %edi,(%esp)
8010345f:	e8 6c 11 00 00       	call   801045d0 <acquire>
  for(i = 0; i < n; i++){
80103464:	8b 45 10             	mov    0x10(%ebp),%eax
80103467:	85 c0                	test   %eax,%eax
80103469:	0f 8e c2 00 00 00    	jle    80103531 <pipewrite+0xe1>
8010346f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103472:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
80103478:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
8010347e:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103484:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103487:	03 45 10             	add    0x10(%ebp),%eax
8010348a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010348d:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103493:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80103499:	39 d1                	cmp    %edx,%ecx
8010349b:	0f 85 c4 00 00 00    	jne    80103565 <pipewrite+0x115>
      if(p->readopen == 0 || proc->killed){
801034a1:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
801034a7:	85 d2                	test   %edx,%edx
801034a9:	0f 84 a1 00 00 00    	je     80103550 <pipewrite+0x100>
801034af:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801034b6:	8b 42 24             	mov    0x24(%edx),%eax
801034b9:	85 c0                	test   %eax,%eax
801034bb:	74 22                	je     801034df <pipewrite+0x8f>
801034bd:	e9 8e 00 00 00       	jmp    80103550 <pipewrite+0x100>
801034c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034c8:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
801034ce:	85 c0                	test   %eax,%eax
801034d0:	74 7e                	je     80103550 <pipewrite+0x100>
801034d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801034d8:	8b 48 24             	mov    0x24(%eax),%ecx
801034db:	85 c9                	test   %ecx,%ecx
801034dd:	75 71                	jne    80103550 <pipewrite+0x100>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034df:	89 34 24             	mov    %esi,(%esp)
801034e2:	e8 99 0b 00 00       	call   80104080 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
801034eb:	89 1c 24             	mov    %ebx,(%esp)
801034ee:	e8 ed 09 00 00       	call   80103ee0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034f3:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801034f9:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801034ff:	05 00 02 00 00       	add    $0x200,%eax
80103504:	39 c2                	cmp    %eax,%edx
80103506:	74 c0                	je     801034c8 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010350b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010350e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103514:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
8010351a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010351e:	0f b6 00             	movzbl (%eax),%eax
80103521:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103528:	3b 45 e0             	cmp    -0x20(%ebp),%eax
8010352b:	0f 85 5c ff ff ff    	jne    8010348d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103531:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
80103537:	89 14 24             	mov    %edx,(%esp)
8010353a:	e8 41 0b 00 00       	call   80104080 <wakeup>
  release(&p->lock);
8010353f:	89 3c 24             	mov    %edi,(%esp)
80103542:	e8 b9 11 00 00       	call   80104700 <release>
  return n;
80103547:	8b 45 10             	mov    0x10(%ebp),%eax
8010354a:	eb 11                	jmp    8010355d <pipewrite+0x10d>
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103550:	89 3c 24             	mov    %edi,(%esp)
80103553:	e8 a8 11 00 00       	call   80104700 <release>
        return -1;
80103558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010355d:	83 c4 1c             	add    $0x1c,%esp
80103560:	5b                   	pop    %ebx
80103561:	5e                   	pop    %esi
80103562:	5f                   	pop    %edi
80103563:	5d                   	pop    %ebp
80103564:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103565:	89 ca                	mov    %ecx,%edx
80103567:	eb 9f                	jmp    80103508 <pipewrite+0xb8>
80103569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103570 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	57                   	push   %edi
80103574:	56                   	push   %esi
80103575:	53                   	push   %ebx
80103576:	83 ec 1c             	sub    $0x1c,%esp
80103579:	8b 75 08             	mov    0x8(%ebp),%esi
8010357c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010357f:	89 34 24             	mov    %esi,(%esp)
80103582:	e8 49 10 00 00       	call   801045d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103587:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010358d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103593:	75 5b                	jne    801035f0 <piperead+0x80>
80103595:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010359b:	85 db                	test   %ebx,%ebx
8010359d:	74 51                	je     801035f0 <piperead+0x80>
8010359f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801035a5:	eb 25                	jmp    801035cc <piperead+0x5c>
801035a7:	90                   	nop
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035a8:	89 74 24 04          	mov    %esi,0x4(%esp)
801035ac:	89 1c 24             	mov    %ebx,(%esp)
801035af:	e8 2c 09 00 00       	call   80103ee0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035b4:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801035ba:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801035c0:	75 2e                	jne    801035f0 <piperead+0x80>
801035c2:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035c8:	85 d2                	test   %edx,%edx
801035ca:	74 24                	je     801035f0 <piperead+0x80>
    if(proc->killed){
801035cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801035d2:	8b 48 24             	mov    0x24(%eax),%ecx
801035d5:	85 c9                	test   %ecx,%ecx
801035d7:	74 cf                	je     801035a8 <piperead+0x38>
      release(&p->lock);
801035d9:	89 34 24             	mov    %esi,(%esp)
801035dc:	e8 1f 11 00 00       	call   80104700 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035e1:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
801035e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035e9:	5b                   	pop    %ebx
801035ea:	5e                   	pop    %esi
801035eb:	5f                   	pop    %edi
801035ec:	5d                   	pop    %ebp
801035ed:	c3                   	ret    
801035ee:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035f0:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
801035f3:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035f5:	85 d2                	test   %edx,%edx
801035f7:	7f 2b                	jg     80103624 <piperead+0xb4>
801035f9:	eb 31                	jmp    8010362c <piperead+0xbc>
801035fb:	90                   	nop
801035fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103600:	8d 48 01             	lea    0x1(%eax),%ecx
80103603:	25 ff 01 00 00       	and    $0x1ff,%eax
80103608:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010360e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103613:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103616:	83 c3 01             	add    $0x1,%ebx
80103619:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010361c:	74 0e                	je     8010362c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010361e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103624:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010362a:	75 d4                	jne    80103600 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010362c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103632:	89 04 24             	mov    %eax,(%esp)
80103635:	e8 46 0a 00 00       	call   80104080 <wakeup>
  release(&p->lock);
8010363a:	89 34 24             	mov    %esi,(%esp)
8010363d:	e8 be 10 00 00       	call   80104700 <release>
  return i;
}
80103642:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
80103645:	89 d8                	mov    %ebx,%eax
}
80103647:	5b                   	pop    %ebx
80103648:	5e                   	pop    %esi
80103649:	5f                   	pop    %edi
8010364a:	5d                   	pop    %ebp
8010364b:	c3                   	ret    
8010364c:	66 90                	xchg   %ax,%ax
8010364e:	66 90                	xchg   %ax,%ax

80103650 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103654:	bb d4 3c 11 80       	mov    $0x80113cd4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103659:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010365c:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80103663:	e8 68 0f 00 00       	call   801045d0 <acquire>
80103668:	eb 15                	jmp    8010367f <allocproc+0x2f>
8010366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103670:	83 eb 80             	sub    $0xffffff80,%ebx
80103673:	81 fb d4 5c 11 80    	cmp    $0x80115cd4,%ebx
80103679:	0f 84 81 00 00 00    	je     80103700 <allocproc+0xb0>
    if(p->state == UNUSED)
8010367f:	8b 43 0c             	mov    0xc(%ebx),%eax
80103682:	85 c0                	test   %eax,%eax
80103684:	75 ea                	jne    80103670 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103686:	a1 08 a0 10 80       	mov    0x8010a008,%eax
  p->priority = 3;

  release(&ptable.lock);
8010368b:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103692:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
  p->priority = 3;
80103699:	c7 43 7c 03 00 00 00 	movl   $0x3,0x7c(%ebx)
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036a0:	8d 50 01             	lea    0x1(%eax),%edx
801036a3:	89 15 08 a0 10 80    	mov    %edx,0x8010a008
801036a9:	89 43 10             	mov    %eax,0x10(%ebx)
  p->priority = 3;

  release(&ptable.lock);
801036ac:	e8 4f 10 00 00       	call   80104700 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036b1:	e8 da ed ff ff       	call   80102490 <kalloc>
801036b6:	85 c0                	test   %eax,%eax
801036b8:	89 43 08             	mov    %eax,0x8(%ebx)
801036bb:	74 57                	je     80103714 <allocproc+0xc4>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036bd:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801036c3:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036c8:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801036cb:	c7 40 14 2d 59 10 80 	movl   $0x8010592d,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036d2:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801036d9:	00 
801036da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801036e1:	00 
801036e2:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801036e5:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036e8:	e8 63 10 00 00       	call   80104750 <memset>
  p->context->eip = (uint)forkret;
801036ed:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036f0:	c7 40 10 20 37 10 80 	movl   $0x80103720,0x10(%eax)

  return p;
801036f7:	89 d8                	mov    %ebx,%eax
}
801036f9:	83 c4 14             	add    $0x14,%esp
801036fc:	5b                   	pop    %ebx
801036fd:	5d                   	pop    %ebp
801036fe:	c3                   	ret    
801036ff:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103700:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80103707:	e8 f4 0f 00 00       	call   80104700 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
8010370c:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
8010370f:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103711:	5b                   	pop    %ebx
80103712:	5d                   	pop    %ebp
80103713:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103714:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010371b:	eb dc                	jmp    801036f9 <allocproc+0xa9>
8010371d:	8d 76 00             	lea    0x0(%esi),%esi

80103720 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103726:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
8010372d:	e8 ce 0f 00 00       	call   80104700 <release>

  if (first) {
80103732:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103737:	85 c0                	test   %eax,%eax
80103739:	75 05                	jne    80103740 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010373b:	c9                   	leave  
8010373c:	c3                   	ret    
8010373d:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103740:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103747:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010374e:	00 00 00 
    iinit(ROOTDEV);
80103751:	e8 1a dd ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
80103756:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010375d:	e8 9e f3 ff ff       	call   80102b00 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103762:	c9                   	leave  
80103763:	c3                   	ret    
80103764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010376a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103770 <add_process_to_queue>:

struct node priority_q[PLEVELS][NPROC]; // A two dimensional array with 5 priority rows and 64 process columns
int marker[PLEVELS] = {0,0,0,0,0};           // 0 because initially no process inside the priority queue

int add_process_to_queue(struct proc *p, int pr)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	57                   	push   %edi
80103774:	8b 7d 0c             	mov    0xc(%ebp),%edi
80103777:	56                   	push   %esi
80103778:	53                   	push   %ebx
    int i;
    for(i=0;i<marker[pr];i++){
80103779:	8b 1c bd bc a5 10 80 	mov    -0x7fef5a44(,%edi,4),%ebx
80103780:	85 db                	test   %ebx,%ebx
80103782:	7e 35                	jle    801037b9 <add_process_to_queue+0x49>
      if(p->pid == priority_q[pr][i].p->pid){
80103784:	8b 45 08             	mov    0x8(%ebp),%eax
80103787:	8d 14 7f             	lea    (%edi,%edi,2),%edx
8010378a:	c1 e2 08             	shl    $0x8,%edx
8010378d:	8b 70 10             	mov    0x10(%eax),%esi
80103790:	8b 82 a0 2d 11 80    	mov    -0x7feed260(%edx),%eax
80103796:	3b 70 10             	cmp    0x10(%eax),%esi
80103799:	74 45                	je     801037e0 <add_process_to_queue+0x70>
8010379b:	81 c2 ac 2d 11 80    	add    $0x80112dac,%edx
int marker[PLEVELS] = {0,0,0,0,0};           // 0 because initially no process inside the priority queue

int add_process_to_queue(struct proc *p, int pr)
{
    int i;
    for(i=0;i<marker[pr];i++){
801037a1:	31 c0                	xor    %eax,%eax
801037a3:	eb 0d                	jmp    801037b2 <add_process_to_queue+0x42>
801037a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->pid == priority_q[pr][i].p->pid){
801037a8:	8b 0a                	mov    (%edx),%ecx
801037aa:	83 c2 0c             	add    $0xc,%edx
801037ad:	39 71 10             	cmp    %esi,0x10(%ecx)
801037b0:	74 2e                	je     801037e0 <add_process_to_queue+0x70>
int marker[PLEVELS] = {0,0,0,0,0};           // 0 because initially no process inside the priority queue

int add_process_to_queue(struct proc *p, int pr)
{
    int i;
    for(i=0;i<marker[pr];i++){
801037b2:	83 c0 01             	add    $0x1,%eax
801037b5:	39 d8                	cmp    %ebx,%eax
801037b7:	75 ef                	jne    801037a8 <add_process_to_queue+0x38>
      if(p->pid == priority_q[pr][i].p->pid){
        return -1;
      }
    }

    priority_q[pr][marker[pr]].p=p;
801037b9:	8b 75 08             	mov    0x8(%ebp),%esi
801037bc:	8d 04 7f             	lea    (%edi,%edi,2),%eax
801037bf:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
    marker[pr]++;
801037c2:	83 c3 01             	add    $0x1,%ebx
      if(p->pid == priority_q[pr][i].p->pid){
        return -1;
      }
    }

    priority_q[pr][marker[pr]].p=p;
801037c5:	c1 e0 08             	shl    $0x8,%eax
    marker[pr]++;
801037c8:	89 1c bd bc a5 10 80 	mov    %ebx,-0x7fef5a44(,%edi,4)
      if(p->pid == priority_q[pr][i].p->pid){
        return -1;
      }
    }

    priority_q[pr][marker[pr]].p=p;
801037cf:	89 b4 90 a0 2d 11 80 	mov    %esi,-0x7feed260(%eax,%edx,4)
    marker[pr]++;
    return 1;
801037d6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801037db:	5b                   	pop    %ebx
801037dc:	5e                   	pop    %esi
801037dd:	5f                   	pop    %edi
801037de:	5d                   	pop    %ebp
801037df:	c3                   	ret    
801037e0:	5b                   	pop    %ebx
int add_process_to_queue(struct proc *p, int pr)
{
    int i;
    for(i=0;i<marker[pr];i++){
      if(p->pid == priority_q[pr][i].p->pid){
        return -1;
801037e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    priority_q[pr][marker[pr]].p=p;
    marker[pr]++;
    return 1;
}
801037e6:	5e                   	pop    %esi
801037e7:	5f                   	pop    %edi
801037e8:	5d                   	pop    %ebp
801037e9:	c3                   	ret    
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037f0 <remove_process_from_queue>:

int remove_process_from_queue(struct proc *p, int pr)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	57                   	push   %edi
801037f4:	56                   	push   %esi
801037f5:	8b 75 0c             	mov    0xc(%ebp),%esi
801037f8:	53                   	push   %ebx
	int found = -1, i;
	for(i=0; i < marker[pr]; i++)
801037f9:	8b 1c b5 bc a5 10 80 	mov    -0x7fef5a44(,%esi,4),%ebx
80103800:	85 db                	test   %ebx,%ebx
80103802:	7e 35                	jle    80103839 <remove_process_from_queue+0x49>
	{
    //if process is found
		if(priority_q[pr][i].p->pid == p->pid)
80103804:	8b 45 08             	mov    0x8(%ebp),%eax
80103807:	8d 14 76             	lea    (%esi,%esi,2),%edx
8010380a:	c1 e2 08             	shl    $0x8,%edx
8010380d:	8b 78 10             	mov    0x10(%eax),%edi
80103810:	8b 82 a0 2d 11 80    	mov    -0x7feed260(%edx),%eax
80103816:	39 78 10             	cmp    %edi,0x10(%eax)
80103819:	74 28                	je     80103843 <remove_process_from_queue+0x53>
8010381b:	81 c2 ac 2d 11 80    	add    $0x80112dac,%edx
}

int remove_process_from_queue(struct proc *p, int pr)
{
	int found = -1, i;
	for(i=0; i < marker[pr]; i++)
80103821:	31 c0                	xor    %eax,%eax
80103823:	eb 0d                	jmp    80103832 <remove_process_from_queue+0x42>
80103825:	8d 76 00             	lea    0x0(%esi),%esi
	{
    //if process is found
		if(priority_q[pr][i].p->pid == p->pid)
80103828:	8b 0a                	mov    (%edx),%ecx
8010382a:	83 c2 0c             	add    $0xc,%edx
8010382d:	39 79 10             	cmp    %edi,0x10(%ecx)
80103830:	74 13                	je     80103845 <remove_process_from_queue+0x55>
}

int remove_process_from_queue(struct proc *p, int pr)
{
	int found = -1, i;
	for(i=0; i < marker[pr]; i++)
80103832:	83 c0 01             	add    $0x1,%eax
80103835:	39 d8                	cmp    %ebx,%eax
80103837:	75 ef                	jne    80103828 <remove_process_from_queue+0x38>
    priority_q[pr][j] = priority_q[pr][j+1]; 
  }

  marker[pr]-=1;
	return found;
}
80103839:	5b                   	pop    %ebx
    return 1;
}

int remove_process_from_queue(struct proc *p, int pr)
{
	int found = -1, i;
8010383a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    priority_q[pr][j] = priority_q[pr][j+1]; 
  }

  marker[pr]-=1;
	return found;
}
8010383f:	5e                   	pop    %esi
80103840:	5f                   	pop    %edi
80103841:	5d                   	pop    %ebp
80103842:	c3                   	ret    
}

int remove_process_from_queue(struct proc *p, int pr)
{
	int found = -1, i;
	for(i=0; i < marker[pr]; i++)
80103843:	31 c0                	xor    %eax,%eax
	{
		return found;
	}
  int j;
  //shift process after removing
	for(j = i; j<marker[pr]-1; j++)
80103845:	8d 7b ff             	lea    -0x1(%ebx),%edi
80103848:	39 c7                	cmp    %eax,%edi
8010384a:	7e 4d                	jle    80103899 <remove_process_from_queue+0xa9>
8010384c:	29 c3                	sub    %eax,%ebx
8010384e:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
80103851:	8d 1c 95 f4 ff ff ff 	lea    -0xc(,%edx,4),%ebx
80103858:	8d 14 40             	lea    (%eax,%eax,2),%edx
8010385b:	8d 04 76             	lea    (%esi,%esi,2),%eax
8010385e:	c1 e0 08             	shl    $0x8,%eax
80103861:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103864:	31 c0                	xor    %eax,%eax
80103866:	66 90                	xchg   %ax,%ax
  {
    priority_q[pr][j] = priority_q[pr][j+1]; 
80103868:	8b 8c 02 ac 2d 11 80 	mov    -0x7feed254(%edx,%eax,1),%ecx
8010386f:	89 8c 02 a0 2d 11 80 	mov    %ecx,-0x7feed260(%edx,%eax,1)
80103876:	8b 8c 02 b0 2d 11 80 	mov    -0x7feed250(%edx,%eax,1),%ecx
8010387d:	89 8c 02 a4 2d 11 80 	mov    %ecx,-0x7feed25c(%edx,%eax,1)
80103884:	8b 8c 02 b4 2d 11 80 	mov    -0x7feed24c(%edx,%eax,1),%ecx
8010388b:	89 8c 02 a8 2d 11 80 	mov    %ecx,-0x7feed258(%edx,%eax,1)
80103892:	83 c0 0c             	add    $0xc,%eax
	{
		return found;
	}
  int j;
  //shift process after removing
	for(j = i; j<marker[pr]-1; j++)
80103895:	39 d8                	cmp    %ebx,%eax
80103897:	75 cf                	jne    80103868 <remove_process_from_queue+0x78>
    priority_q[pr][j] = priority_q[pr][j+1]; 
  }

  marker[pr]-=1;
	return found;
}
80103899:	5b                   	pop    %ebx
	for(i=0; i < marker[pr]; i++)
	{
    //if process is found
		if(priority_q[pr][i].p->pid == p->pid)
		{
			found = 1;
8010389a:	b8 01 00 00 00       	mov    $0x1,%eax
	for(j = i; j<marker[pr]-1; j++)
  {
    priority_q[pr][j] = priority_q[pr][j+1]; 
  }

  marker[pr]-=1;
8010389f:	89 3c b5 bc a5 10 80 	mov    %edi,-0x7fef5a44(,%esi,4)
	return found;
}
801038a6:	5e                   	pop    %esi
801038a7:	5f                   	pop    %edi
801038a8:	5d                   	pop    %ebp
801038a9:	c3                   	ret    
801038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038b0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801038b6:	c7 44 24 04 ad 76 10 	movl   $0x801076ad,0x4(%esp)
801038bd:	80 
801038be:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
801038c5:	e8 86 0c 00 00       	call   80104550 <initlock>
}
801038ca:	c9                   	leave  
801038cb:	c3                   	ret    
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038d0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
801038d4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801038d7:	e8 74 fd ff ff       	call   80103650 <allocproc>
801038dc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801038de:	a3 d0 a5 10 80       	mov    %eax,0x8010a5d0
  if((p->pgdir = setupkvm()) == 0)
801038e3:	e8 48 32 00 00       	call   80106b30 <setupkvm>
801038e8:	85 c0                	test   %eax,%eax
801038ea:	89 43 04             	mov    %eax,0x4(%ebx)
801038ed:	0f 84 d4 00 00 00    	je     801039c7 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038f3:	89 04 24             	mov    %eax,(%esp)
801038f6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801038fd:	00 
801038fe:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103905:	80 
80103906:	e8 85 33 00 00       	call   80106c90 <inituvm>
  p->sz = PGSIZE;
8010390b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103911:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103918:	00 
80103919:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103920:	00 
80103921:	8b 43 18             	mov    0x18(%ebx),%eax
80103924:	89 04 24             	mov    %eax,(%esp)
80103927:	e8 24 0e 00 00       	call   80104750 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010392c:	8b 43 18             	mov    0x18(%ebx),%eax
8010392f:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103934:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103939:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010393d:	8b 43 18             	mov    0x18(%ebx),%eax
80103940:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103944:	8b 43 18             	mov    0x18(%ebx),%eax
80103947:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010394b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010394f:	8b 43 18             	mov    0x18(%ebx),%eax
80103952:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103956:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010395a:	8b 43 18             	mov    0x18(%ebx),%eax
8010395d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103964:	8b 43 18             	mov    0x18(%ebx),%eax
80103967:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010396e:	8b 43 18             	mov    0x18(%ebx),%eax
80103971:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103978:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010397b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103982:	00 
80103983:	c7 44 24 04 cd 76 10 	movl   $0x801076cd,0x4(%esp)
8010398a:	80 
8010398b:	89 04 24             	mov    %eax,(%esp)
8010398e:	e8 9d 0f 00 00       	call   80104930 <safestrcpy>
  p->cwd = namei("/");
80103993:	c7 04 24 d6 76 10 80 	movl   $0x801076d6,(%esp)
8010399a:	e8 41 e5 ff ff       	call   80101ee0 <namei>
8010399f:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801039a2:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
801039a9:	e8 22 0c 00 00       	call   801045d0 <acquire>

  p->state = RUNNABLE;
801039ae:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      cprintf("Unable to create process with pid=%d\n",p->pid);
      release(&ptable.lock);
      exit();
    }
  #endif
  release(&ptable.lock);
801039b5:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
801039bc:	e8 3f 0d 00 00       	call   80104700 <release>
}
801039c1:	83 c4 14             	add    $0x14,%esp
801039c4:	5b                   	pop    %ebx
801039c5:	5d                   	pop    %ebp
801039c6:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801039c7:	c7 04 24 b4 76 10 80 	movl   $0x801076b4,(%esp)
801039ce:	e8 8d c9 ff ff       	call   80100360 <panic>
801039d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039e0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
801039e6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801039ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
801039f0:	8b 02                	mov    (%edx),%eax
  if(n > 0){
801039f2:	83 f9 00             	cmp    $0x0,%ecx
801039f5:	7e 39                	jle    80103a30 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801039f7:	01 c1                	add    %eax,%ecx
801039f9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801039fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a01:	8b 42 04             	mov    0x4(%edx),%eax
80103a04:	89 04 24             	mov    %eax,(%esp)
80103a07:	e8 c4 33 00 00       	call   80106dd0 <allocuvm>
80103a0c:	85 c0                	test   %eax,%eax
80103a0e:	74 40                	je     80103a50 <growproc+0x70>
80103a10:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
80103a17:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
80103a19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a1f:	89 04 24             	mov    %eax,(%esp)
80103a22:	e8 c9 31 00 00       	call   80106bf0 <switchuvm>
  return 0;
80103a27:	31 c0                	xor    %eax,%eax
}
80103a29:	c9                   	leave  
80103a2a:	c3                   	ret    
80103a2b:	90                   	nop
80103a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103a30:	74 e5                	je     80103a17 <growproc+0x37>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103a32:	01 c1                	add    %eax,%ecx
80103a34:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80103a38:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a3c:	8b 42 04             	mov    0x4(%edx),%eax
80103a3f:	89 04 24             	mov    %eax,(%esp)
80103a42:	e8 79 34 00 00       	call   80106ec0 <deallocuvm>
80103a47:	85 c0                	test   %eax,%eax
80103a49:	75 c5                	jne    80103a10 <growproc+0x30>
80103a4b:	90                   	nop
80103a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
80103a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
80103a55:	c9                   	leave  
80103a56:	c3                   	ret    
80103a57:	89 f6                	mov    %esi,%esi
80103a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a60 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	57                   	push   %edi
80103a64:	56                   	push   %esi
80103a65:	53                   	push   %ebx
80103a66:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80103a69:	e8 e2 fb ff ff       	call   80103650 <allocproc>
80103a6e:	85 c0                	test   %eax,%eax
80103a70:	89 c3                	mov    %eax,%ebx
80103a72:	0f 84 d5 00 00 00    	je     80103b4d <fork+0xed>
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103a78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a7e:	8b 10                	mov    (%eax),%edx
80103a80:	89 54 24 04          	mov    %edx,0x4(%esp)
80103a84:	8b 40 04             	mov    0x4(%eax),%eax
80103a87:	89 04 24             	mov    %eax,(%esp)
80103a8a:	e8 01 35 00 00       	call   80106f90 <copyuvm>
80103a8f:	85 c0                	test   %eax,%eax
80103a91:	89 43 04             	mov    %eax,0x4(%ebx)
80103a94:	0f 84 ba 00 00 00    	je     80103b54 <fork+0xf4>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103a9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103aa0:	b9 13 00 00 00       	mov    $0x13,%ecx
80103aa5:	8b 7b 18             	mov    0x18(%ebx),%edi
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103aa8:	8b 00                	mov    (%eax),%eax
80103aaa:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103aac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ab2:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103ab5:	8b 70 18             	mov    0x18(%eax),%esi
80103ab8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103aba:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103abc:	8b 43 18             	mov    0x18(%ebx),%eax
80103abf:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103ac6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103acd:	8d 76 00             	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103ad0:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103ad4:	85 c0                	test   %eax,%eax
80103ad6:	74 13                	je     80103aeb <fork+0x8b>
      np->ofile[i] = filedup(proc->ofile[i]);
80103ad8:	89 04 24             	mov    %eax,(%esp)
80103adb:	e8 f0 d2 ff ff       	call   80100dd0 <filedup>
80103ae0:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103ae4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103aeb:	83 c6 01             	add    $0x1,%esi
80103aee:	83 fe 10             	cmp    $0x10,%esi
80103af1:	75 dd                	jne    80103ad0 <fork+0x70>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103af3:	8b 42 68             	mov    0x68(%edx),%eax
80103af6:	89 04 24             	mov    %eax,(%esp)
80103af9:	e8 82 db ff ff       	call   80101680 <idup>
80103afe:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103b01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b07:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103b0e:	00 
80103b0f:	83 c0 6c             	add    $0x6c,%eax
80103b12:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b16:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b19:	89 04 24             	mov    %eax,(%esp)
80103b1c:	e8 0f 0e 00 00       	call   80104930 <safestrcpy>

  pid = np->pid;
80103b21:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80103b24:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80103b2b:	e8 a0 0a 00 00       	call   801045d0 <acquire>

  np->state = RUNNABLE;
80103b30:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      cprintf("Unable to create process with pid=%d\n",np->pid);
      release(&ptable.lock);
      exit();
    }
  #endif
  release(&ptable.lock);
80103b37:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80103b3e:	e8 bd 0b 00 00       	call   80104700 <release>
  return pid;
80103b43:	89 f0                	mov    %esi,%eax
}
80103b45:	83 c4 1c             	add    $0x1c,%esp
80103b48:	5b                   	pop    %ebx
80103b49:	5e                   	pop    %esi
80103b4a:	5f                   	pop    %edi
80103b4b:	5d                   	pop    %ebp
80103b4c:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103b4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b52:	eb f1                	jmp    80103b45 <fork+0xe5>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103b54:	8b 43 08             	mov    0x8(%ebx),%eax
80103b57:	89 04 24             	mov    %eax,(%esp)
80103b5a:	e8 81 e7 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103b5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103b64:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103b6b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b72:	eb d1                	jmp    80103b45 <fork+0xe5>
80103b74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b80 <mycpu>:
  }
}

struct cpu*
mycpu(void)
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	56                   	push   %esi
80103b84:	53                   	push   %ebx
80103b85:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b88:	9c                   	pushf  
80103b89:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103b8a:	f6 c4 02             	test   $0x2,%ah
80103b8d:	75 57                	jne    80103be6 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
80103b8f:	e8 cc ea ff ff       	call   80102660 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b94:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
80103b9a:	85 f6                	test   %esi,%esi
80103b9c:	7e 3c                	jle    80103bda <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103b9e:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
80103ba5:	39 c2                	cmp    %eax,%edx
80103ba7:	74 2d                	je     80103bd6 <mycpu+0x56>
80103ba9:	b9 5c 28 11 80       	mov    $0x8011285c,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103bae:	31 d2                	xor    %edx,%edx
80103bb0:	83 c2 01             	add    $0x1,%edx
80103bb3:	39 f2                	cmp    %esi,%edx
80103bb5:	74 23                	je     80103bda <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103bb7:	0f b6 19             	movzbl (%ecx),%ebx
80103bba:	81 c1 bc 00 00 00    	add    $0xbc,%ecx
80103bc0:	39 c3                	cmp    %eax,%ebx
80103bc2:	75 ec                	jne    80103bb0 <mycpu+0x30>
      return &cpus[i];
80103bc4:	69 c2 bc 00 00 00    	imul   $0xbc,%edx,%eax
  }
  panic("unknown apicid\n");
}
80103bca:	83 c4 10             	add    $0x10,%esp
80103bcd:	5b                   	pop    %ebx
80103bce:	5e                   	pop    %esi
80103bcf:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103bd0:	05 a0 27 11 80       	add    $0x801127a0,%eax
  }
  panic("unknown apicid\n");
}
80103bd5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103bd6:	31 d2                	xor    %edx,%edx
80103bd8:	eb ea                	jmp    80103bc4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80103bda:	c7 04 24 0c 76 10 80 	movl   $0x8010760c,(%esp)
80103be1:	e8 7a c7 ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103be6:	c7 04 24 e8 77 10 80 	movl   $0x801077e8,(%esp)
80103bed:	e8 6e c7 ff ff       	call   80100360 <panic>
80103bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c00 <myproc>:
  }
  panic("unknown apicid\n");
}

struct proc*
myproc(void) {
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	53                   	push   %ebx
80103c04:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c07:	e8 74 0a 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103c0c:	e8 6f ff ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80103c11:	8b 98 b8 00 00 00    	mov    0xb8(%eax),%ebx
  popcli();
80103c17:	e8 94 0a 00 00       	call   801046b0 <popcli>
  return p;
}
80103c1c:	83 c4 04             	add    $0x4,%esp
80103c1f:	89 d8                	mov    %ebx,%eax
80103c21:	5b                   	pop    %ebx
80103c22:	5d                   	pop    %ebp
80103c23:	c3                   	ret    
80103c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c30 <scheduler>:
  }
}
#else
void
scheduler(void)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103c39:	e8 42 ff ff ff       	call   80103b80 <mycpu>
80103c3e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c40:	c7 80 b8 00 00 00 00 	movl   $0x0,0xb8(%eax)
80103c47:	00 00 00 
80103c4a:	8d 78 04             	lea    0x4(%eax),%edi
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103c50:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103c51:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c58:	bb d4 3c 11 80       	mov    $0x80113cd4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103c5d:	e8 6e 09 00 00       	call   801045d0 <acquire>
80103c62:	eb 0f                	jmp    80103c73 <scheduler+0x43>
80103c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c68:	83 eb 80             	sub    $0xffffff80,%ebx
80103c6b:	81 fb d4 5c 11 80    	cmp    $0x80115cd4,%ebx
80103c71:	74 45                	je     80103cb8 <scheduler+0x88>
      if(p->state != RUNNABLE)
80103c73:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c77:	75 ef                	jne    80103c68 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103c79:	89 9e b8 00 00 00    	mov    %ebx,0xb8(%esi)
      switchuvm(p);
80103c7f:	89 1c 24             	mov    %ebx,(%esp)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c82:	83 eb 80             	sub    $0xffffff80,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103c85:	e8 66 2f 00 00       	call   80106bf0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103c8a:	8b 43 9c             	mov    -0x64(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103c8d:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)

      swtch(&(c->scheduler), p->context);
80103c94:	89 3c 24             	mov    %edi,(%esp)
80103c97:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c9b:	e8 eb 0c 00 00       	call   8010498b <swtch>
      switchkvm();
80103ca0:	e8 2b 2f 00 00       	call   80106bd0 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca5:	81 fb d4 5c 11 80    	cmp    $0x80115cd4,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103cab:	c7 86 b8 00 00 00 00 	movl   $0x0,0xb8(%esi)
80103cb2:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb5:	75 bc                	jne    80103c73 <scheduler+0x43>
80103cb7:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103cb8:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80103cbf:	e8 3c 0a 00 00       	call   80104700 <release>
  }
80103cc4:	eb 8a                	jmp    80103c50 <scheduler+0x20>
80103cc6:	8d 76 00             	lea    0x0(%esi),%esi
80103cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cd0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	53                   	push   %ebx
80103cd4:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80103cd7:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80103cde:	e8 7d 09 00 00       	call   80104660 <holding>
80103ce3:	85 c0                	test   %eax,%eax
80103ce5:	74 4d                	je     80103d34 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103ce7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ced:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
80103cf4:	75 62                	jne    80103d58 <sched+0x88>
    panic("sched locks");
  if(proc->state == RUNNING)
80103cf6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103cfd:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
80103d01:	74 49                	je     80103d4c <sched+0x7c>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d03:	9c                   	pushf  
80103d04:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103d05:	80 e5 02             	and    $0x2,%ch
80103d08:	75 36                	jne    80103d40 <sched+0x70>
    panic("sched interruptible");
  intena = cpu->intena;
80103d0a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  swtch(&proc->context, cpu->scheduler);
80103d10:	83 c2 1c             	add    $0x1c,%edx
80103d13:	8b 40 04             	mov    0x4(%eax),%eax
80103d16:	89 14 24             	mov    %edx,(%esp)
80103d19:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d1d:	e8 69 0c 00 00       	call   8010498b <swtch>
  cpu->intena = intena;
80103d22:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103d28:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103d2e:	83 c4 14             	add    $0x14,%esp
80103d31:	5b                   	pop    %ebx
80103d32:	5d                   	pop    %ebp
80103d33:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103d34:	c7 04 24 d8 76 10 80 	movl   $0x801076d8,(%esp)
80103d3b:	e8 20 c6 ff ff       	call   80100360 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103d40:	c7 04 24 04 77 10 80 	movl   $0x80107704,(%esp)
80103d47:	e8 14 c6 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103d4c:	c7 04 24 f6 76 10 80 	movl   $0x801076f6,(%esp)
80103d53:	e8 08 c6 ff ff       	call   80100360 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103d58:	c7 04 24 ea 76 10 80 	movl   $0x801076ea,(%esp)
80103d5f:	e8 fc c5 ff ff       	call   80100360 <panic>
80103d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d70 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	56                   	push   %esi
80103d74:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103d75:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103d77:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80103d7a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103d81:	3b 15 d0 a5 10 80    	cmp    0x8010a5d0,%edx
80103d87:	0f 84 01 01 00 00    	je     80103e8e <exit+0x11e>
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103d90:	8d 73 08             	lea    0x8(%ebx),%esi
80103d93:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103d97:	85 c0                	test   %eax,%eax
80103d99:	74 17                	je     80103db2 <exit+0x42>
      fileclose(proc->ofile[fd]);
80103d9b:	89 04 24             	mov    %eax,(%esp)
80103d9e:	e8 7d d0 ff ff       	call   80100e20 <fileclose>
      proc->ofile[fd] = 0;
80103da3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103daa:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103db1:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103db2:	83 c3 01             	add    $0x1,%ebx
80103db5:	83 fb 10             	cmp    $0x10,%ebx
80103db8:	75 d6                	jne    80103d90 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103dba:	e8 e1 ed ff ff       	call   80102ba0 <begin_op>
  iput(proc->cwd);
80103dbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103dc5:	8b 40 68             	mov    0x68(%eax),%eax
80103dc8:	89 04 24             	mov    %eax,(%esp)
80103dcb:	e8 f0 d9 ff ff       	call   801017c0 <iput>
  end_op();
80103dd0:	e8 3b ee ff ff       	call   80102c10 <end_op>
  proc->cwd = 0;
80103dd5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ddb:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103de2:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80103de9:	e8 e2 07 00 00       	call   801045d0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103dee:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df5:	b8 d4 3c 11 80       	mov    $0x80113cd4,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103dfa:	8b 51 14             	mov    0x14(%ecx),%edx
80103dfd:	eb 0b                	jmp    80103e0a <exit+0x9a>
80103dff:	90                   	nop
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e00:	83 e8 80             	sub    $0xffffff80,%eax
80103e03:	3d d4 5c 11 80       	cmp    $0x80115cd4,%eax
80103e08:	74 1c                	je     80103e26 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan){
80103e0a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e0e:	75 f0                	jne    80103e00 <exit+0x90>
80103e10:	3b 50 20             	cmp    0x20(%eax),%edx
80103e13:	75 eb                	jne    80103e00 <exit+0x90>
      p->state = RUNNABLE;
80103e15:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e1c:	83 e8 80             	sub    $0xffffff80,%eax
80103e1f:	3d d4 5c 11 80       	cmp    $0x80115cd4,%eax
80103e24:	75 e4                	jne    80103e0a <exit+0x9a>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103e26:	8b 1d d0 a5 10 80    	mov    0x8010a5d0,%ebx
80103e2c:	ba d4 3c 11 80       	mov    $0x80113cd4,%edx
80103e31:	eb 10                	jmp    80103e43 <exit+0xd3>
80103e33:	90                   	nop
80103e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e38:	83 ea 80             	sub    $0xffffff80,%edx
80103e3b:	81 fa d4 5c 11 80    	cmp    $0x80115cd4,%edx
80103e41:	74 33                	je     80103e76 <exit+0x106>
    if(p->parent == proc){
80103e43:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103e46:	75 f0                	jne    80103e38 <exit+0xc8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103e48:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103e4c:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e4f:	75 e7                	jne    80103e38 <exit+0xc8>
80103e51:	b8 d4 3c 11 80       	mov    $0x80113cd4,%eax
80103e56:	eb 0a                	jmp    80103e62 <exit+0xf2>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e58:	83 e8 80             	sub    $0xffffff80,%eax
80103e5b:	3d d4 5c 11 80       	cmp    $0x80115cd4,%eax
80103e60:	74 d6                	je     80103e38 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan){
80103e62:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e66:	75 f0                	jne    80103e58 <exit+0xe8>
80103e68:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e6b:	75 eb                	jne    80103e58 <exit+0xe8>
      p->state = RUNNABLE;
80103e6d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e74:	eb e2                	jmp    80103e58 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103e76:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  sched();
80103e7d:	e8 4e fe ff ff       	call   80103cd0 <sched>
  panic("zombie exit");
80103e82:	c7 04 24 25 77 10 80 	movl   $0x80107725,(%esp)
80103e89:	e8 d2 c4 ff ff       	call   80100360 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103e8e:	c7 04 24 18 77 10 80 	movl   $0x80107718,(%esp)
80103e95:	e8 c6 c4 ff ff       	call   80100360 <panic>
80103e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ea0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ea6:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80103ead:	e8 1e 07 00 00       	call   801045d0 <acquire>
  proc->state = RUNNABLE;
80103eb2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103eb8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    int res=add_process_to_queue(myproc(),myproc()->priority-1);
    if(res==-1){
      cprintf("Unable to create process with pid=%d\n",myproc()->pid);
    }
  #endif
  sched();
80103ebf:	e8 0c fe ff ff       	call   80103cd0 <sched>
  release(&ptable.lock);
80103ec4:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80103ecb:	e8 30 08 00 00       	call   80104700 <release>
}
80103ed0:	c9                   	leave  
80103ed1:	c3                   	ret    
80103ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ee0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
80103ee5:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
80103ee8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103eee:	8b 75 08             	mov    0x8(%ebp),%esi
80103ef1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103ef4:	85 c0                	test   %eax,%eax
80103ef6:	0f 84 8b 00 00 00    	je     80103f87 <sleep+0xa7>
    panic("sleep");

  if(lk == 0)
80103efc:	85 db                	test   %ebx,%ebx
80103efe:	74 7b                	je     80103f7b <sleep+0x9b>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f00:	81 fb a0 3c 11 80    	cmp    $0x80113ca0,%ebx
80103f06:	74 50                	je     80103f58 <sleep+0x78>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f08:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80103f0f:	e8 bc 06 00 00       	call   801045d0 <acquire>
    release(lk);
80103f14:	89 1c 24             	mov    %ebx,(%esp)
80103f17:	e8 e4 07 00 00       	call   80104700 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103f1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f22:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103f25:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103f2c:	e8 9f fd ff ff       	call   80103cd0 <sched>

  // Tidy up.
  proc->chan = 0;
80103f31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f37:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103f3e:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80103f45:	e8 b6 07 00 00       	call   80104700 <release>
    acquire(lk);
80103f4a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
80103f4d:	83 c4 10             	add    $0x10,%esp
80103f50:	5b                   	pop    %ebx
80103f51:	5e                   	pop    %esi
80103f52:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103f53:	e9 78 06 00 00       	jmp    801045d0 <acquire>
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103f58:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103f5b:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103f62:	e8 69 fd ff ff       	call   80103cd0 <sched>

  // Tidy up.
  proc->chan = 0;
80103f67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f6d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103f74:	83 c4 10             	add    $0x10,%esp
80103f77:	5b                   	pop    %ebx
80103f78:	5e                   	pop    %esi
80103f79:	5d                   	pop    %ebp
80103f7a:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103f7b:	c7 04 24 37 77 10 80 	movl   $0x80107737,(%esp)
80103f82:	e8 d9 c3 ff ff       	call   80100360 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103f87:	c7 04 24 31 77 10 80 	movl   $0x80107731,(%esp)
80103f8e:	e8 cd c3 ff ff       	call   80100360 <panic>
80103f93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
80103fa5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103fa8:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80103faf:	e8 1c 06 00 00       	call   801045d0 <acquire>
80103fb4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103fba:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fbc:	bb d4 3c 11 80       	mov    $0x80113cd4,%ebx
80103fc1:	eb 10                	jmp    80103fd3 <wait+0x33>
80103fc3:	90                   	nop
80103fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fc8:	83 eb 80             	sub    $0xffffff80,%ebx
80103fcb:	81 fb d4 5c 11 80    	cmp    $0x80115cd4,%ebx
80103fd1:	74 1d                	je     80103ff0 <wait+0x50>
      if(p->parent != proc)
80103fd3:	39 43 14             	cmp    %eax,0x14(%ebx)
80103fd6:	75 f0                	jne    80103fc8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103fd8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fdc:	74 2f                	je     8010400d <wait+0x6d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fde:	83 eb 80             	sub    $0xffffff80,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103fe1:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe6:	81 fb d4 5c 11 80    	cmp    $0x80115cd4,%ebx
80103fec:	75 e5                	jne    80103fd3 <wait+0x33>
80103fee:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103ff0:	85 d2                	test   %edx,%edx
80103ff2:	74 6e                	je     80104062 <wait+0xc2>
80103ff4:	8b 50 24             	mov    0x24(%eax),%edx
80103ff7:	85 d2                	test   %edx,%edx
80103ff9:	75 67                	jne    80104062 <wait+0xc2>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103ffb:	c7 44 24 04 a0 3c 11 	movl   $0x80113ca0,0x4(%esp)
80104002:	80 
80104003:	89 04 24             	mov    %eax,(%esp)
80104006:	e8 d5 fe ff ff       	call   80103ee0 <sleep>
  }
8010400b:	eb a7                	jmp    80103fb4 <wait+0x14>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
8010400d:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80104010:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104013:	89 04 24             	mov    %eax,(%esp)
80104016:	e8 c5 e2 ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
8010401b:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
8010401e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104025:	89 04 24             	mov    %eax,(%esp)
80104028:	e8 b3 2e 00 00       	call   80106ee0 <freevm>
        p->killed = 0;
        p->state = UNUSED;
        #ifndef CUSTOM_SCHEDULER
          remove_process_from_queue(p, p->priority-1);
        #endif
        release(&ptable.lock);
8010402d:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80104034:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010403b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104042:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104046:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010404d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        #ifndef CUSTOM_SCHEDULER
          remove_process_from_queue(p, p->priority-1);
        #endif
        release(&ptable.lock);
80104054:	e8 a7 06 00 00       	call   80104700 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104059:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
        #ifndef CUSTOM_SCHEDULER
          remove_process_from_queue(p, p->priority-1);
        #endif
        release(&ptable.lock);
        return pid;
8010405c:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010405e:	5b                   	pop    %ebx
8010405f:	5e                   	pop    %esi
80104060:	5d                   	pop    %ebp
80104061:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80104062:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80104069:	e8 92 06 00 00       	call   80104700 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010406e:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80104071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104076:	5b                   	pop    %ebx
80104077:	5e                   	pop    %esi
80104078:	5d                   	pop    %ebp
80104079:	c3                   	ret    
8010407a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104080 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	53                   	push   %ebx
80104084:	83 ec 14             	sub    $0x14,%esp
80104087:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010408a:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80104091:	e8 3a 05 00 00       	call   801045d0 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104096:	b8 d4 3c 11 80       	mov    $0x80113cd4,%eax
8010409b:	eb 0d                	jmp    801040aa <wakeup+0x2a>
8010409d:	8d 76 00             	lea    0x0(%esi),%esi
801040a0:	83 e8 80             	sub    $0xffffff80,%eax
801040a3:	3d d4 5c 11 80       	cmp    $0x80115cd4,%eax
801040a8:	74 1e                	je     801040c8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan){
801040aa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040ae:	75 f0                	jne    801040a0 <wakeup+0x20>
801040b0:	3b 58 20             	cmp    0x20(%eax),%ebx
801040b3:	75 eb                	jne    801040a0 <wakeup+0x20>
      p->state = RUNNABLE;
801040b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040bc:	83 e8 80             	sub    $0xffffff80,%eax
801040bf:	3d d4 5c 11 80       	cmp    $0x80115cd4,%eax
801040c4:	75 e4                	jne    801040aa <wakeup+0x2a>
801040c6:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801040c8:	c7 45 08 a0 3c 11 80 	movl   $0x80113ca0,0x8(%ebp)
}
801040cf:	83 c4 14             	add    $0x14,%esp
801040d2:	5b                   	pop    %ebx
801040d3:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801040d4:	e9 27 06 00 00       	jmp    80104700 <release>
801040d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	53                   	push   %ebx
801040e4:	83 ec 14             	sub    $0x14,%esp
801040e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801040ea:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
801040f1:	e8 da 04 00 00       	call   801045d0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f6:	b8 d4 3c 11 80       	mov    $0x80113cd4,%eax
801040fb:	eb 0d                	jmp    8010410a <kill+0x2a>
801040fd:	8d 76 00             	lea    0x0(%esi),%esi
80104100:	83 e8 80             	sub    $0xffffff80,%eax
80104103:	3d d4 5c 11 80       	cmp    $0x80115cd4,%eax
80104108:	74 36                	je     80104140 <kill+0x60>
    if(p->pid == pid){
8010410a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010410d:	75 f1                	jne    80104100 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010410f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104113:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010411a:	74 14                	je     80104130 <kill+0x50>
            cprintf("Unable to create process with pid=%d\n",p->pid);
            release(&ptable.lock);
            exit();
          }
        #endif
      release(&ptable.lock);
8010411c:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80104123:	e8 d8 05 00 00       	call   80104700 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104128:	83 c4 14             	add    $0x14,%esp
            release(&ptable.lock);
            exit();
          }
        #endif
      release(&ptable.lock);
      return 0;
8010412b:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010412d:	5b                   	pop    %ebx
8010412e:	5d                   	pop    %ebp
8010412f:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104130:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104137:	eb e3                	jmp    8010411c <kill+0x3c>
80104139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        #endif
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104140:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80104147:	e8 b4 05 00 00       	call   80104700 <release>
  return -1;
}
8010414c:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
8010414f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104154:	5b                   	pop    %ebx
80104155:	5d                   	pop    %ebp
80104156:	c3                   	ret    
80104157:	89 f6                	mov    %esi,%esi
80104159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104160 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	57                   	push   %edi
80104164:	56                   	push   %esi
80104165:	53                   	push   %ebx
80104166:	bb 40 3d 11 80       	mov    $0x80113d40,%ebx
8010416b:	83 ec 4c             	sub    $0x4c,%esp
8010416e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104171:	eb 20                	jmp    80104193 <procdump+0x33>
80104173:	90                   	nop
80104174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104178:	c7 04 24 86 76 10 80 	movl   $0x80107686,(%esp)
8010417f:	e8 cc c4 ff ff       	call   80100650 <cprintf>
80104184:	83 eb 80             	sub    $0xffffff80,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104187:	81 fb 40 5d 11 80    	cmp    $0x80115d40,%ebx
8010418d:	0f 84 8d 00 00 00    	je     80104220 <procdump+0xc0>
    if(p->state == UNUSED)
80104193:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104196:	85 c0                	test   %eax,%eax
80104198:	74 ea                	je     80104184 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010419a:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
8010419d:	ba 48 77 10 80       	mov    $0x80107748,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041a2:	77 11                	ja     801041b5 <procdump+0x55>
801041a4:	8b 14 85 58 78 10 80 	mov    -0x7fef87a8(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801041ab:	b8 48 77 10 80       	mov    $0x80107748,%eax
801041b0:	85 d2                	test   %edx,%edx
801041b2:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801041b5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801041b8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801041bc:	89 54 24 08          	mov    %edx,0x8(%esp)
801041c0:	c7 04 24 4c 77 10 80 	movl   $0x8010774c,(%esp)
801041c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801041cb:	e8 80 c4 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
801041d0:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801041d4:	75 a2                	jne    80104178 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801041d6:	8d 45 c0             	lea    -0x40(%ebp),%eax
801041d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801041dd:	8b 43 b0             	mov    -0x50(%ebx),%eax
801041e0:	8d 7d c0             	lea    -0x40(%ebp),%edi
801041e3:	8b 40 0c             	mov    0xc(%eax),%eax
801041e6:	83 c0 08             	add    $0x8,%eax
801041e9:	89 04 24             	mov    %eax,(%esp)
801041ec:	e8 7f 03 00 00       	call   80104570 <getcallerpcs>
801041f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801041f8:	8b 17                	mov    (%edi),%edx
801041fa:	85 d2                	test   %edx,%edx
801041fc:	0f 84 76 ff ff ff    	je     80104178 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104202:	89 54 24 04          	mov    %edx,0x4(%esp)
80104206:	83 c7 04             	add    $0x4,%edi
80104209:	c7 04 24 a9 71 10 80 	movl   $0x801071a9,(%esp)
80104210:	e8 3b c4 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104215:	39 f7                	cmp    %esi,%edi
80104217:	75 df                	jne    801041f8 <procdump+0x98>
80104219:	e9 5a ff ff ff       	jmp    80104178 <procdump+0x18>
8010421e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104220:	83 c4 4c             	add    $0x4c,%esp
80104223:	5b                   	pop    %ebx
80104224:	5e                   	pop    %esi
80104225:	5f                   	pop    %edi
80104226:	5d                   	pop    %ebp
80104227:	c3                   	ret    
80104228:	90                   	nop
80104229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104230 <cps>:

int cps()
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
80104234:	83 ec 14             	sub    $0x14,%esp
}

static inline void
sti(void)
{
  asm volatile("sti");
80104237:	fb                   	sti    
  struct proc *p;
  //Enables interrupts on this processor.
  sti();

  //Loop over process table looking for process with pid.
  acquire(&ptable.lock);
80104238:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
8010423f:	bb 40 3d 11 80       	mov    $0x80113d40,%ebx
80104244:	e8 87 03 00 00       	call   801045d0 <acquire>
  cprintf("name \t pid \t state \t priority \n");
80104249:	c7 04 24 10 78 10 80 	movl   $0x80107810,(%esp)
80104250:	e8 fb c3 ff ff       	call   80100650 <cprintf>
80104255:	eb 16                	jmp    8010426d <cps+0x3d>
80104257:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == SLEEPING)
      cprintf("%s \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->priority);
    else if(p->state == RUNNING)
80104258:	83 f8 04             	cmp    $0x4,%eax
8010425b:	74 63                	je     801042c0 <cps+0x90>
      cprintf("%s \t %d \t RUNNING \t %d \n ", p->name,p->pid,p->priority);
    else if(p->state == RUNNABLE)
8010425d:	83 f8 03             	cmp    $0x3,%eax
80104260:	74 7e                	je     801042e0 <cps+0xb0>
80104262:	83 eb 80             	sub    $0xffffff80,%ebx
  sti();

  //Loop over process table looking for process with pid.
  acquire(&ptable.lock);
  cprintf("name \t pid \t state \t priority \n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104265:	81 fb 40 5d 11 80    	cmp    $0x80115d40,%ebx
8010426b:	74 3b                	je     801042a8 <cps+0x78>
    if(p->state == SLEEPING)
8010426d:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104270:	83 f8 02             	cmp    $0x2,%eax
80104273:	75 e3                	jne    80104258 <cps+0x28>
      cprintf("%s \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->priority);
80104275:	8b 43 10             	mov    0x10(%ebx),%eax
80104278:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010427c:	83 eb 80             	sub    $0xffffff80,%ebx
8010427f:	c7 04 24 55 77 10 80 	movl   $0x80107755,(%esp)
80104286:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010428a:	8b 83 24 ff ff ff    	mov    -0xdc(%ebx),%eax
80104290:	89 44 24 08          	mov    %eax,0x8(%esp)
80104294:	e8 b7 c3 ff ff       	call   80100650 <cprintf>
  sti();

  //Loop over process table looking for process with pid.
  acquire(&ptable.lock);
  cprintf("name \t pid \t state \t priority \n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104299:	81 fb 40 5d 11 80    	cmp    $0x80115d40,%ebx
8010429f:	75 cc                	jne    8010426d <cps+0x3d>
801042a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else if(p->state == RUNNING)
      cprintf("%s \t %d \t RUNNING \t %d \n ", p->name,p->pid,p->priority);
    else if(p->state == RUNNABLE)
      cprintf("%s \t %d \t RUNNABLE \t %d \n ", p->name,p->pid,p->priority);
  }
  release(&ptable.lock);
801042a8:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
801042af:	e8 4c 04 00 00       	call   80104700 <release>
  return 22;
}
801042b4:	83 c4 14             	add    $0x14,%esp
801042b7:	b8 16 00 00 00       	mov    $0x16,%eax
801042bc:	5b                   	pop    %ebx
801042bd:	5d                   	pop    %ebp
801042be:	c3                   	ret    
801042bf:	90                   	nop
  cprintf("name \t pid \t state \t priority \n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == SLEEPING)
      cprintf("%s \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->priority);
    else if(p->state == RUNNING)
      cprintf("%s \t %d \t RUNNING \t %d \n ", p->name,p->pid,p->priority);
801042c0:	8b 43 10             	mov    0x10(%ebx),%eax
801042c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801042c7:	c7 04 24 70 77 10 80 	movl   $0x80107770,(%esp)
801042ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
801042d2:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801042d5:	89 44 24 08          	mov    %eax,0x8(%esp)
801042d9:	e8 72 c3 ff ff       	call   80100650 <cprintf>
801042de:	eb 82                	jmp    80104262 <cps+0x32>
    else if(p->state == RUNNABLE)
      cprintf("%s \t %d \t RUNNABLE \t %d \n ", p->name,p->pid,p->priority);
801042e0:	8b 43 10             	mov    0x10(%ebx),%eax
801042e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801042e7:	c7 04 24 8a 77 10 80 	movl   $0x8010778a,(%esp)
801042ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
801042f2:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801042f5:	89 44 24 08          	mov    %eax,0x8(%esp)
801042f9:	e8 52 c3 ff ff       	call   80100650 <cprintf>
801042fe:	e9 5f ff ff ff       	jmp    80104262 <cps+0x32>
80104303:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104310 <nice>:
  return 22;
}

int 
nice(int pid, int priority)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	56                   	push   %esi
80104315:	53                   	push   %ebx
80104316:	83 ec 2c             	sub    $0x2c,%esp
  if(priority <1 || priority>5){
80104319:	8b 45 0c             	mov    0xc(%ebp),%eax
  return 22;
}

int 
nice(int pid, int priority)
{
8010431c:	8b 75 08             	mov    0x8(%ebp),%esi
  if(priority <1 || priority>5){
8010431f:	83 e8 01             	sub    $0x1,%eax
80104322:	83 f8 04             	cmp    $0x4,%eax
80104325:	0f 87 f6 00 00 00    	ja     80104421 <nice+0x111>
    cprintf("Error: Priority not within range(1-5)\n");
    exit();
  }
	struct proc *p;
  int found=0;
	acquire(&ptable.lock);
8010432b:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104332:	bb d4 3c 11 80       	mov    $0x80113cd4,%ebx
    cprintf("Error: Priority not within range(1-5)\n");
    exit();
  }
	struct proc *p;
  int found=0;
	acquire(&ptable.lock);
80104337:	e8 94 02 00 00       	call   801045d0 <acquire>
8010433c:	eb 11                	jmp    8010434f <nice+0x3f>
8010433e:	66 90                	xchg   %ax,%ax
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104340:	83 eb 80             	sub    $0xffffff80,%ebx
80104343:	81 fb d4 5c 11 80    	cmp    $0x80115cd4,%ebx
80104349:	0f 84 b1 00 00 00    	je     80104400 <nice+0xf0>
	  if(p->pid == pid){
8010434f:	39 73 10             	cmp    %esi,0x10(%ebx)
80104352:	75 ec                	jne    80104340 <nice+0x30>
  if(!found){
      release(&ptable.lock);
      cprintf("No process with Pid=%d\n",pid);
      exit();
  }
  release(&ptable.lock);
80104354:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
8010435b:	e8 a0 03 00 00       	call   80104700 <release>
  int old_priority = p->priority;
80104360:	8b 43 7c             	mov    0x7c(%ebx),%eax
  p->priority=priority;
80104363:	8b 7d 0c             	mov    0xc(%ebp),%edi
      release(&ptable.lock);
      cprintf("No process with Pid=%d\n",pid);
      exit();
  }
  release(&ptable.lock);
  int old_priority = p->priority;
80104366:	89 45 e0             	mov    %eax,-0x20(%ebp)
  p->priority=priority;
80104369:	89 7b 7c             	mov    %edi,0x7c(%ebx)

  remove_process_from_queue(p,old_priority);
8010436c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104370:	89 1c 24             	mov    %ebx,(%esp)
80104373:	e8 78 f4 ff ff       	call   801037f0 <remove_process_from_queue>
int marker[PLEVELS] = {0,0,0,0,0};           // 0 because initially no process inside the priority queue

int add_process_to_queue(struct proc *p, int pr)
{
    int i;
    for(i=0;i<marker[pr];i++){
80104378:	8b 45 0c             	mov    0xc(%ebp),%eax
8010437b:	8b 04 85 bc a5 10 80 	mov    -0x7fef5a44(,%eax,4),%eax
80104382:	85 c0                	test   %eax,%eax
80104384:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104387:	7e 3b                	jle    801043c4 <nice+0xb4>
      if(p->pid == priority_q[pr][i].p->pid){
80104389:	8b 55 0c             	mov    0xc(%ebp),%edx
8010438c:	8b 7b 10             	mov    0x10(%ebx),%edi
8010438f:	8d 0c 52             	lea    (%edx,%edx,2),%ecx
80104392:	c1 e1 08             	shl    $0x8,%ecx
80104395:	8b 81 a0 2d 11 80    	mov    -0x7feed260(%ecx),%eax
8010439b:	3b 78 10             	cmp    0x10(%eax),%edi
8010439e:	74 49                	je     801043e9 <nice+0xd9>
801043a0:	89 5d dc             	mov    %ebx,-0x24(%ebp)
801043a3:	81 c1 ac 2d 11 80    	add    $0x80112dac,%ecx
int marker[PLEVELS] = {0,0,0,0,0};           // 0 because initially no process inside the priority queue

int add_process_to_queue(struct proc *p, int pr)
{
    int i;
    for(i=0;i<marker[pr];i++){
801043a9:	31 d2                	xor    %edx,%edx
801043ab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801043ae:	eb 0a                	jmp    801043ba <nice+0xaa>
      if(p->pid == priority_q[pr][i].p->pid){
801043b0:	8b 01                	mov    (%ecx),%eax
801043b2:	83 c1 0c             	add    $0xc,%ecx
801043b5:	39 78 10             	cmp    %edi,0x10(%eax)
801043b8:	74 2f                	je     801043e9 <nice+0xd9>
int marker[PLEVELS] = {0,0,0,0,0};           // 0 because initially no process inside the priority queue

int add_process_to_queue(struct proc *p, int pr)
{
    int i;
    for(i=0;i<marker[pr];i++){
801043ba:	83 c2 01             	add    $0x1,%edx
801043bd:	39 da                	cmp    %ebx,%edx
801043bf:	75 ef                	jne    801043b0 <nice+0xa0>
801043c1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
      if(p->pid == priority_q[pr][i].p->pid){
        return -1;
      }
    }

    priority_q[pr][marker[pr]].p=p;
801043c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801043c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801043ca:	8d 04 40             	lea    (%eax,%eax,2),%eax
801043cd:	8d 14 7f             	lea    (%edi,%edi,2),%edx
801043d0:	c1 e0 08             	shl    $0x8,%eax
801043d3:	89 9c 90 a0 2d 11 80 	mov    %ebx,-0x7feed260(%eax,%edx,4)
    marker[pr]++;
801043da:	89 f8                	mov    %edi,%eax
801043dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801043df:	83 c0 01             	add    $0x1,%eax
801043e2:	89 04 bd bc a5 10 80 	mov    %eax,-0x7fef5a44(,%edi,4)
  int old_priority = p->priority;
  p->priority=priority;

  remove_process_from_queue(p,old_priority);
  add_process_to_queue(p,priority);
	return (pid*MOD+old_priority);
801043e9:	89 f0                	mov    %esi,%eax
801043eb:	c1 e0 06             	shl    $0x6,%eax
801043ee:	01 f0                	add    %esi,%eax
801043f0:	03 45 e0             	add    -0x20(%ebp),%eax
801043f3:	83 c4 2c             	add    $0x2c,%esp
801043f6:	5b                   	pop    %ebx
801043f7:	5e                   	pop    %esi
801043f8:	5f                   	pop    %edi
801043f9:	5d                   	pop    %ebp
801043fa:	c3                   	ret    
801043fb:	90                   	nop
801043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      found=1;
			break;
		}
	}
  if(!found){
      release(&ptable.lock);
80104400:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80104407:	e8 f4 02 00 00       	call   80104700 <release>
      cprintf("No process with Pid=%d\n",pid);
8010440c:	89 74 24 04          	mov    %esi,0x4(%esp)
80104410:	c7 04 24 a5 77 10 80 	movl   $0x801077a5,(%esp)
80104417:	e8 34 c2 ff ff       	call   80100650 <cprintf>
      exit();
8010441c:	e8 4f f9 ff ff       	call   80103d70 <exit>

int 
nice(int pid, int priority)
{
  if(priority <1 || priority>5){
    cprintf("Error: Priority not within range(1-5)\n");
80104421:	c7 04 24 30 78 10 80 	movl   $0x80107830,(%esp)
80104428:	e8 23 c2 ff ff       	call   80100650 <cprintf>
    exit();
8010442d:	e8 3e f9 ff ff       	call   80103d70 <exit>
80104432:	66 90                	xchg   %ax,%ax
80104434:	66 90                	xchg   %ax,%ax
80104436:	66 90                	xchg   %ax,%ax
80104438:	66 90                	xchg   %ax,%ax
8010443a:	66 90                	xchg   %ax,%ax
8010443c:	66 90                	xchg   %ax,%ax
8010443e:	66 90                	xchg   %ax,%ax

80104440 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	53                   	push   %ebx
80104444:	83 ec 14             	sub    $0x14,%esp
80104447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010444a:	c7 44 24 04 70 78 10 	movl   $0x80107870,0x4(%esp)
80104451:	80 
80104452:	8d 43 04             	lea    0x4(%ebx),%eax
80104455:	89 04 24             	mov    %eax,(%esp)
80104458:	e8 f3 00 00 00       	call   80104550 <initlock>
  lk->name = name;
8010445d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104460:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104466:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010446d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104470:	83 c4 14             	add    $0x14,%esp
80104473:	5b                   	pop    %ebx
80104474:	5d                   	pop    %ebp
80104475:	c3                   	ret    
80104476:	8d 76 00             	lea    0x0(%esi),%esi
80104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104480 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	83 ec 10             	sub    $0x10,%esp
80104488:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010448b:	8d 73 04             	lea    0x4(%ebx),%esi
8010448e:	89 34 24             	mov    %esi,(%esp)
80104491:	e8 3a 01 00 00       	call   801045d0 <acquire>
  while (lk->locked) {
80104496:	8b 13                	mov    (%ebx),%edx
80104498:	85 d2                	test   %edx,%edx
8010449a:	74 16                	je     801044b2 <acquiresleep+0x32>
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801044a0:	89 74 24 04          	mov    %esi,0x4(%esp)
801044a4:	89 1c 24             	mov    %ebx,(%esp)
801044a7:	e8 34 fa ff ff       	call   80103ee0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801044ac:	8b 03                	mov    (%ebx),%eax
801044ae:	85 c0                	test   %eax,%eax
801044b0:	75 ee                	jne    801044a0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801044b2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
801044b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044be:	8b 40 10             	mov    0x10(%eax),%eax
801044c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044c7:	83 c4 10             	add    $0x10,%esp
801044ca:	5b                   	pop    %ebx
801044cb:	5e                   	pop    %esi
801044cc:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
801044cd:	e9 2e 02 00 00       	jmp    80104700 <release>
801044d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044e0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	56                   	push   %esi
801044e4:	53                   	push   %ebx
801044e5:	83 ec 10             	sub    $0x10,%esp
801044e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044eb:	8d 73 04             	lea    0x4(%ebx),%esi
801044ee:	89 34 24             	mov    %esi,(%esp)
801044f1:	e8 da 00 00 00       	call   801045d0 <acquire>
  lk->locked = 0;
801044f6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044fc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104503:	89 1c 24             	mov    %ebx,(%esp)
80104506:	e8 75 fb ff ff       	call   80104080 <wakeup>
  release(&lk->lk);
8010450b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010450e:	83 c4 10             	add    $0x10,%esp
80104511:	5b                   	pop    %ebx
80104512:	5e                   	pop    %esi
80104513:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104514:	e9 e7 01 00 00       	jmp    80104700 <release>
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
80104525:	83 ec 10             	sub    $0x10,%esp
80104528:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010452b:	8d 73 04             	lea    0x4(%ebx),%esi
8010452e:	89 34 24             	mov    %esi,(%esp)
80104531:	e8 9a 00 00 00       	call   801045d0 <acquire>
  r = lk->locked;
80104536:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104538:	89 34 24             	mov    %esi,(%esp)
8010453b:	e8 c0 01 00 00       	call   80104700 <release>
  return r;
}
80104540:	83 c4 10             	add    $0x10,%esp
80104543:	89 d8                	mov    %ebx,%eax
80104545:	5b                   	pop    %ebx
80104546:	5e                   	pop    %esi
80104547:	5d                   	pop    %ebp
80104548:	c3                   	ret    
80104549:	66 90                	xchg   %ax,%ax
8010454b:	66 90                	xchg   %ax,%ax
8010454d:	66 90                	xchg   %ax,%ax
8010454f:	90                   	nop

80104550 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104556:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104559:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010455f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104562:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104569:	5d                   	pop    %ebp
8010456a:	c3                   	ret    
8010456b:	90                   	nop
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104570 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104573:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104576:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104579:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010457a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010457d:	31 c0                	xor    %eax,%eax
8010457f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104580:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104586:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010458c:	77 1a                	ja     801045a8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010458e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104591:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104594:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104597:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104599:	83 f8 0a             	cmp    $0xa,%eax
8010459c:	75 e2                	jne    80104580 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010459e:	5b                   	pop    %ebx
8010459f:	5d                   	pop    %ebp
801045a0:	c3                   	ret    
801045a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801045a8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801045af:	83 c0 01             	add    $0x1,%eax
801045b2:	83 f8 0a             	cmp    $0xa,%eax
801045b5:	74 e7                	je     8010459e <getcallerpcs+0x2e>
    pcs[i] = 0;
801045b7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801045be:	83 c0 01             	add    $0x1,%eax
801045c1:	83 f8 0a             	cmp    $0xa,%eax
801045c4:	75 e2                	jne    801045a8 <getcallerpcs+0x38>
801045c6:	eb d6                	jmp    8010459e <getcallerpcs+0x2e>
801045c8:	90                   	nop
801045c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045d0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045d6:	9c                   	pushf  
801045d7:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801045d8:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801045d9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801045df:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801045e5:	85 d2                	test   %edx,%edx
801045e7:	75 0c                	jne    801045f5 <acquire+0x25>
    cpu->intena = eflags & FL_IF;
801045e9:	81 e1 00 02 00 00    	and    $0x200,%ecx
801045ef:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
801045f5:	83 c2 01             	add    $0x1,%edx
801045f8:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801045fe:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104601:	8b 0a                	mov    (%edx),%ecx
80104603:	85 c9                	test   %ecx,%ecx
80104605:	74 05                	je     8010460c <acquire+0x3c>
80104607:	3b 42 08             	cmp    0x8(%edx),%eax
8010460a:	74 3e                	je     8010464a <acquire+0x7a>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010460c:	b9 01 00 00 00       	mov    $0x1,%ecx
80104611:	eb 08                	jmp    8010461b <acquire+0x4b>
80104613:	90                   	nop
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104618:	8b 55 08             	mov    0x8(%ebp),%edx
8010461b:	89 c8                	mov    %ecx,%eax
8010461d:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104620:	85 c0                	test   %eax,%eax
80104622:	75 f4                	jne    80104618 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104624:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104629:	8b 45 08             	mov    0x8(%ebp),%eax
8010462c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  getcallerpcs(&lk, lk->pcs);
80104633:	83 c0 0c             	add    $0xc,%eax
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104636:	89 50 fc             	mov    %edx,-0x4(%eax)
  getcallerpcs(&lk, lk->pcs);
80104639:	89 44 24 04          	mov    %eax,0x4(%esp)
8010463d:	8d 45 08             	lea    0x8(%ebp),%eax
80104640:	89 04 24             	mov    %eax,(%esp)
80104643:	e8 28 ff ff ff       	call   80104570 <getcallerpcs>
}
80104648:	c9                   	leave  
80104649:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
8010464a:	c7 04 24 7b 78 10 80 	movl   $0x8010787b,(%esp)
80104651:	e8 0a bd ff ff       	call   80100360 <panic>
80104656:	8d 76 00             	lea    0x0(%esi),%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104660 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104660:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
80104661:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104663:	89 e5                	mov    %esp,%ebp
80104665:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104668:	8b 0a                	mov    (%edx),%ecx
8010466a:	85 c9                	test   %ecx,%ecx
8010466c:	74 0f                	je     8010467d <holding+0x1d>
8010466e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104674:	39 42 08             	cmp    %eax,0x8(%edx)
80104677:	0f 94 c0             	sete   %al
8010467a:	0f b6 c0             	movzbl %al,%eax
}
8010467d:	5d                   	pop    %ebp
8010467e:	c3                   	ret    
8010467f:	90                   	nop

80104680 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104683:	9c                   	pushf  
80104684:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104685:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104686:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010468c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104692:	85 d2                	test   %edx,%edx
80104694:	75 0c                	jne    801046a2 <pushcli+0x22>
    cpu->intena = eflags & FL_IF;
80104696:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010469c:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
801046a2:	83 c2 01             	add    $0x1,%edx
801046a5:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
801046ab:	5d                   	pop    %ebp
801046ac:	c3                   	ret    
801046ad:	8d 76 00             	lea    0x0(%esi),%esi

801046b0 <popcli>:

void
popcli(void)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046b6:	9c                   	pushf  
801046b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046b8:	f6 c4 02             	test   $0x2,%ah
801046bb:	75 34                	jne    801046f1 <popcli+0x41>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
801046bd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801046c3:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
801046c9:	8d 51 ff             	lea    -0x1(%ecx),%edx
801046cc:	85 d2                	test   %edx,%edx
801046ce:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801046d4:	78 0f                	js     801046e5 <popcli+0x35>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
801046d6:	75 0b                	jne    801046e3 <popcli+0x33>
801046d8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801046de:	85 c0                	test   %eax,%eax
801046e0:	74 01                	je     801046e3 <popcli+0x33>
}

static inline void
sti(void)
{
  asm volatile("sti");
801046e2:	fb                   	sti    
    sti();
}
801046e3:	c9                   	leave  
801046e4:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
801046e5:	c7 04 24 9a 78 10 80 	movl   $0x8010789a,(%esp)
801046ec:	e8 6f bc ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801046f1:	c7 04 24 83 78 10 80 	movl   $0x80107883,(%esp)
801046f8:	e8 63 bc ff ff       	call   80100360 <panic>
801046fd:	8d 76 00             	lea    0x0(%esi),%esi

80104700 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	83 ec 18             	sub    $0x18,%esp
80104706:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104709:	8b 10                	mov    (%eax),%edx
8010470b:	85 d2                	test   %edx,%edx
8010470d:	74 0c                	je     8010471b <release+0x1b>
8010470f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104716:	39 50 08             	cmp    %edx,0x8(%eax)
80104719:	74 0d                	je     80104728 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010471b:	c7 04 24 a1 78 10 80 	movl   $0x801078a1,(%esp)
80104722:	e8 39 bc ff ff       	call   80100360 <panic>
80104727:	90                   	nop

  lk->pcs[0] = 0;
80104728:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010472f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104736:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010473b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
80104741:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104742:	e9 69 ff ff ff       	jmp    801046b0 <popcli>
80104747:	66 90                	xchg   %ax,%ax
80104749:	66 90                	xchg   %ax,%ax
8010474b:	66 90                	xchg   %ax,%ax
8010474d:	66 90                	xchg   %ax,%ax
8010474f:	90                   	nop

80104750 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	8b 55 08             	mov    0x8(%ebp),%edx
80104756:	57                   	push   %edi
80104757:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010475a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010475b:	f6 c2 03             	test   $0x3,%dl
8010475e:	75 05                	jne    80104765 <memset+0x15>
80104760:	f6 c1 03             	test   $0x3,%cl
80104763:	74 13                	je     80104778 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104765:	89 d7                	mov    %edx,%edi
80104767:	8b 45 0c             	mov    0xc(%ebp),%eax
8010476a:	fc                   	cld    
8010476b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010476d:	5b                   	pop    %ebx
8010476e:	89 d0                	mov    %edx,%eax
80104770:	5f                   	pop    %edi
80104771:	5d                   	pop    %ebp
80104772:	c3                   	ret    
80104773:	90                   	nop
80104774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104778:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010477c:	c1 e9 02             	shr    $0x2,%ecx
8010477f:	89 f8                	mov    %edi,%eax
80104781:	89 fb                	mov    %edi,%ebx
80104783:	c1 e0 18             	shl    $0x18,%eax
80104786:	c1 e3 10             	shl    $0x10,%ebx
80104789:	09 d8                	or     %ebx,%eax
8010478b:	09 f8                	or     %edi,%eax
8010478d:	c1 e7 08             	shl    $0x8,%edi
80104790:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104792:	89 d7                	mov    %edx,%edi
80104794:	fc                   	cld    
80104795:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104797:	5b                   	pop    %ebx
80104798:	89 d0                	mov    %edx,%eax
8010479a:	5f                   	pop    %edi
8010479b:	5d                   	pop    %ebp
8010479c:	c3                   	ret    
8010479d:	8d 76 00             	lea    0x0(%esi),%esi

801047a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	8b 45 10             	mov    0x10(%ebp),%eax
801047a6:	57                   	push   %edi
801047a7:	56                   	push   %esi
801047a8:	8b 75 0c             	mov    0xc(%ebp),%esi
801047ab:	53                   	push   %ebx
801047ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047af:	85 c0                	test   %eax,%eax
801047b1:	8d 78 ff             	lea    -0x1(%eax),%edi
801047b4:	74 26                	je     801047dc <memcmp+0x3c>
    if(*s1 != *s2)
801047b6:	0f b6 03             	movzbl (%ebx),%eax
801047b9:	31 d2                	xor    %edx,%edx
801047bb:	0f b6 0e             	movzbl (%esi),%ecx
801047be:	38 c8                	cmp    %cl,%al
801047c0:	74 16                	je     801047d8 <memcmp+0x38>
801047c2:	eb 24                	jmp    801047e8 <memcmp+0x48>
801047c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047c8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801047cd:	83 c2 01             	add    $0x1,%edx
801047d0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801047d4:	38 c8                	cmp    %cl,%al
801047d6:	75 10                	jne    801047e8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047d8:	39 fa                	cmp    %edi,%edx
801047da:	75 ec                	jne    801047c8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801047dc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801047dd:	31 c0                	xor    %eax,%eax
}
801047df:	5e                   	pop    %esi
801047e0:	5f                   	pop    %edi
801047e1:	5d                   	pop    %ebp
801047e2:	c3                   	ret    
801047e3:	90                   	nop
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047e8:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801047e9:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801047eb:	5e                   	pop    %esi
801047ec:	5f                   	pop    %edi
801047ed:	5d                   	pop    %ebp
801047ee:	c3                   	ret    
801047ef:	90                   	nop

801047f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	57                   	push   %edi
801047f4:	8b 45 08             	mov    0x8(%ebp),%eax
801047f7:	56                   	push   %esi
801047f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801047fb:	53                   	push   %ebx
801047fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047ff:	39 c6                	cmp    %eax,%esi
80104801:	73 35                	jae    80104838 <memmove+0x48>
80104803:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104806:	39 c8                	cmp    %ecx,%eax
80104808:	73 2e                	jae    80104838 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010480a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010480c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010480f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104812:	74 1b                	je     8010482f <memmove+0x3f>
80104814:	f7 db                	neg    %ebx
80104816:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104819:	01 fb                	add    %edi,%ebx
8010481b:	90                   	nop
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104820:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104824:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104827:	83 ea 01             	sub    $0x1,%edx
8010482a:	83 fa ff             	cmp    $0xffffffff,%edx
8010482d:	75 f1                	jne    80104820 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010482f:	5b                   	pop    %ebx
80104830:	5e                   	pop    %esi
80104831:	5f                   	pop    %edi
80104832:	5d                   	pop    %ebp
80104833:	c3                   	ret    
80104834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104838:	31 d2                	xor    %edx,%edx
8010483a:	85 db                	test   %ebx,%ebx
8010483c:	74 f1                	je     8010482f <memmove+0x3f>
8010483e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104840:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104844:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104847:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010484a:	39 da                	cmp    %ebx,%edx
8010484c:	75 f2                	jne    80104840 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010484e:	5b                   	pop    %ebx
8010484f:	5e                   	pop    %esi
80104850:	5f                   	pop    %edi
80104851:	5d                   	pop    %ebp
80104852:	c3                   	ret    
80104853:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104863:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104864:	e9 87 ff ff ff       	jmp    801047f0 <memmove>
80104869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104870 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	8b 75 10             	mov    0x10(%ebp),%esi
80104877:	53                   	push   %ebx
80104878:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010487b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010487e:	85 f6                	test   %esi,%esi
80104880:	74 30                	je     801048b2 <strncmp+0x42>
80104882:	0f b6 01             	movzbl (%ecx),%eax
80104885:	84 c0                	test   %al,%al
80104887:	74 2f                	je     801048b8 <strncmp+0x48>
80104889:	0f b6 13             	movzbl (%ebx),%edx
8010488c:	38 d0                	cmp    %dl,%al
8010488e:	75 46                	jne    801048d6 <strncmp+0x66>
80104890:	8d 51 01             	lea    0x1(%ecx),%edx
80104893:	01 ce                	add    %ecx,%esi
80104895:	eb 14                	jmp    801048ab <strncmp+0x3b>
80104897:	90                   	nop
80104898:	0f b6 02             	movzbl (%edx),%eax
8010489b:	84 c0                	test   %al,%al
8010489d:	74 31                	je     801048d0 <strncmp+0x60>
8010489f:	0f b6 19             	movzbl (%ecx),%ebx
801048a2:	83 c2 01             	add    $0x1,%edx
801048a5:	38 d8                	cmp    %bl,%al
801048a7:	75 17                	jne    801048c0 <strncmp+0x50>
    n--, p++, q++;
801048a9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801048ab:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801048ad:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801048b0:	75 e6                	jne    80104898 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801048b2:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801048b3:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801048b5:	5e                   	pop    %esi
801048b6:	5d                   	pop    %ebp
801048b7:	c3                   	ret    
801048b8:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801048bb:	31 c0                	xor    %eax,%eax
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801048c0:	0f b6 d3             	movzbl %bl,%edx
801048c3:	29 d0                	sub    %edx,%eax
}
801048c5:	5b                   	pop    %ebx
801048c6:	5e                   	pop    %esi
801048c7:	5d                   	pop    %ebp
801048c8:	c3                   	ret    
801048c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048d0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801048d4:	eb ea                	jmp    801048c0 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801048d6:	89 d3                	mov    %edx,%ebx
801048d8:	eb e6                	jmp    801048c0 <strncmp+0x50>
801048da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048e0 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	8b 45 08             	mov    0x8(%ebp),%eax
801048e6:	56                   	push   %esi
801048e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048ea:	53                   	push   %ebx
801048eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801048ee:	89 c2                	mov    %eax,%edx
801048f0:	eb 19                	jmp    8010490b <strncpy+0x2b>
801048f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048f8:	83 c3 01             	add    $0x1,%ebx
801048fb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801048ff:	83 c2 01             	add    $0x1,%edx
80104902:	84 c9                	test   %cl,%cl
80104904:	88 4a ff             	mov    %cl,-0x1(%edx)
80104907:	74 09                	je     80104912 <strncpy+0x32>
80104909:	89 f1                	mov    %esi,%ecx
8010490b:	85 c9                	test   %ecx,%ecx
8010490d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104910:	7f e6                	jg     801048f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104912:	31 c9                	xor    %ecx,%ecx
80104914:	85 f6                	test   %esi,%esi
80104916:	7e 0f                	jle    80104927 <strncpy+0x47>
    *s++ = 0;
80104918:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010491c:	89 f3                	mov    %esi,%ebx
8010491e:	83 c1 01             	add    $0x1,%ecx
80104921:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104923:	85 db                	test   %ebx,%ebx
80104925:	7f f1                	jg     80104918 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104927:	5b                   	pop    %ebx
80104928:	5e                   	pop    %esi
80104929:	5d                   	pop    %ebp
8010492a:	c3                   	ret    
8010492b:	90                   	nop
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104930 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104936:	56                   	push   %esi
80104937:	8b 45 08             	mov    0x8(%ebp),%eax
8010493a:	53                   	push   %ebx
8010493b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010493e:	85 c9                	test   %ecx,%ecx
80104940:	7e 26                	jle    80104968 <safestrcpy+0x38>
80104942:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104946:	89 c1                	mov    %eax,%ecx
80104948:	eb 17                	jmp    80104961 <safestrcpy+0x31>
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104950:	83 c2 01             	add    $0x1,%edx
80104953:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104957:	83 c1 01             	add    $0x1,%ecx
8010495a:	84 db                	test   %bl,%bl
8010495c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010495f:	74 04                	je     80104965 <safestrcpy+0x35>
80104961:	39 f2                	cmp    %esi,%edx
80104963:	75 eb                	jne    80104950 <safestrcpy+0x20>
    ;
  *s = 0;
80104965:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104968:	5b                   	pop    %ebx
80104969:	5e                   	pop    %esi
8010496a:	5d                   	pop    %ebp
8010496b:	c3                   	ret    
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104970 <strlen>:

int
strlen(const char *s)
{
80104970:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104971:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104973:	89 e5                	mov    %esp,%ebp
80104975:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104978:	80 3a 00             	cmpb   $0x0,(%edx)
8010497b:	74 0c                	je     80104989 <strlen+0x19>
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
80104980:	83 c0 01             	add    $0x1,%eax
80104983:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104987:	75 f7                	jne    80104980 <strlen+0x10>
    ;
  return n;
}
80104989:	5d                   	pop    %ebp
8010498a:	c3                   	ret    

8010498b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010498b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010498f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104993:	55                   	push   %ebp
  pushl %ebx
80104994:	53                   	push   %ebx
  pushl %esi
80104995:	56                   	push   %esi
  pushl %edi
80104996:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104997:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104999:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010499b:	5f                   	pop    %edi
  popl %esi
8010499c:	5e                   	pop    %esi
  popl %ebx
8010499d:	5b                   	pop    %ebx
  popl %ebp
8010499e:	5d                   	pop    %ebp
  ret
8010499f:	c3                   	ret    

801049a0 <fetchint>:

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801049a0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049a7:	55                   	push   %ebp
801049a8:	89 e5                	mov    %esp,%ebp
801049aa:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
801049ad:	8b 12                	mov    (%edx),%edx
801049af:	39 c2                	cmp    %eax,%edx
801049b1:	76 15                	jbe    801049c8 <fetchint+0x28>
801049b3:	8d 48 04             	lea    0x4(%eax),%ecx
801049b6:	39 ca                	cmp    %ecx,%edx
801049b8:	72 0e                	jb     801049c8 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
801049ba:	8b 10                	mov    (%eax),%edx
801049bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049bf:	89 10                	mov    %edx,(%eax)
  return 0;
801049c1:	31 c0                	xor    %eax,%eax
}
801049c3:	5d                   	pop    %ebp
801049c4:	c3                   	ret    
801049c5:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
801049c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
801049cd:	5d                   	pop    %ebp
801049ce:	c3                   	ret    
801049cf:	90                   	nop

801049d0 <fetchstr>:
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801049d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801049d6:	55                   	push   %ebp
801049d7:	89 e5                	mov    %esp,%ebp
801049d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
801049dc:	39 08                	cmp    %ecx,(%eax)
801049de:	76 2c                	jbe    80104a0c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801049e0:	8b 55 0c             	mov    0xc(%ebp),%edx
801049e3:	89 c8                	mov    %ecx,%eax
801049e5:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801049e7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049ee:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801049f0:	39 d1                	cmp    %edx,%ecx
801049f2:	73 18                	jae    80104a0c <fetchstr+0x3c>
    if(*s == 0)
801049f4:	80 39 00             	cmpb   $0x0,(%ecx)
801049f7:	75 0c                	jne    80104a05 <fetchstr+0x35>
801049f9:	eb 1d                	jmp    80104a18 <fetchstr+0x48>
801049fb:	90                   	nop
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a00:	80 38 00             	cmpb   $0x0,(%eax)
80104a03:	74 13                	je     80104a18 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104a05:	83 c0 01             	add    $0x1,%eax
80104a08:	39 c2                	cmp    %eax,%edx
80104a0a:	77 f4                	ja     80104a00 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
80104a0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104a11:	5d                   	pop    %ebp
80104a12:	c3                   	ret    
80104a13:	90                   	nop
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
80104a18:	29 c8                	sub    %ecx,%eax
  return -1;
}
80104a1a:	5d                   	pop    %ebp
80104a1b:	c3                   	ret    
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104a20:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a27:	55                   	push   %ebp
80104a28:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104a2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a2d:	8b 42 18             	mov    0x18(%edx),%eax

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104a30:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104a32:	8b 40 44             	mov    0x44(%eax),%eax
80104a35:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104a38:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104a3b:	39 d1                	cmp    %edx,%ecx
80104a3d:	73 19                	jae    80104a58 <argint+0x38>
80104a3f:	8d 48 08             	lea    0x8(%eax),%ecx
80104a42:	39 ca                	cmp    %ecx,%edx
80104a44:	72 12                	jb     80104a58 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80104a46:	8b 50 04             	mov    0x4(%eax),%edx
80104a49:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a4c:	89 10                	mov    %edx,(%eax)
  return 0;
80104a4e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104a50:	5d                   	pop    %ebp
80104a51:	c3                   	ret    
80104a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104a5d:	5d                   	pop    %ebp
80104a5e:	c3                   	ret    
80104a5f:	90                   	nop

80104a60 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104a60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a66:	55                   	push   %ebp
80104a67:	89 e5                	mov    %esp,%ebp
80104a69:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104a6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a6d:	8b 50 18             	mov    0x18(%eax),%edx
80104a70:	8b 52 44             	mov    0x44(%edx),%edx
80104a73:	8d 0c 8a             	lea    (%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104a76:	8b 10                	mov    (%eax),%edx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
80104a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104a7d:	8d 59 04             	lea    0x4(%ecx),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104a80:	39 d3                	cmp    %edx,%ebx
80104a82:	73 25                	jae    80104aa9 <argptr+0x49>
80104a84:	8d 59 08             	lea    0x8(%ecx),%ebx
80104a87:	39 da                	cmp    %ebx,%edx
80104a89:	72 1e                	jb     80104aa9 <argptr+0x49>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104a8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104a8e:	8b 49 04             	mov    0x4(%ecx),%ecx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104a91:	85 db                	test   %ebx,%ebx
80104a93:	78 14                	js     80104aa9 <argptr+0x49>
80104a95:	39 d1                	cmp    %edx,%ecx
80104a97:	73 10                	jae    80104aa9 <argptr+0x49>
80104a99:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a9c:	01 cb                	add    %ecx,%ebx
80104a9e:	39 d3                	cmp    %edx,%ebx
80104aa0:	77 07                	ja     80104aa9 <argptr+0x49>
    return -1;
  *pp = (char*)i;
80104aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aa5:	89 08                	mov    %ecx,(%eax)
  return 0;
80104aa7:	31 c0                	xor    %eax,%eax
}
80104aa9:	5b                   	pop    %ebx
80104aaa:	5d                   	pop    %ebp
80104aab:	c3                   	ret    
80104aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ab0 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104ab0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ab6:	55                   	push   %ebp
80104ab7:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104ab9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104abc:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104abf:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104ac1:	8b 52 44             	mov    0x44(%edx),%edx
80104ac4:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104ac7:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104aca:	39 c1                	cmp    %eax,%ecx
80104acc:	73 07                	jae    80104ad5 <argstr+0x25>
80104ace:	8d 4a 08             	lea    0x8(%edx),%ecx
80104ad1:	39 c8                	cmp    %ecx,%eax
80104ad3:	73 0b                	jae    80104ae0 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104ad5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104ada:	5d                   	pop    %ebp
80104adb:	c3                   	ret    
80104adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104ae0:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104ae3:	39 c1                	cmp    %eax,%ecx
80104ae5:	73 ee                	jae    80104ad5 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
80104ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104aea:	89 c8                	mov    %ecx,%eax
80104aec:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104aee:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104af5:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104af7:	39 d1                	cmp    %edx,%ecx
80104af9:	73 da                	jae    80104ad5 <argstr+0x25>
    if(*s == 0)
80104afb:	80 39 00             	cmpb   $0x0,(%ecx)
80104afe:	75 12                	jne    80104b12 <argstr+0x62>
80104b00:	eb 1e                	jmp    80104b20 <argstr+0x70>
80104b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b08:	80 38 00             	cmpb   $0x0,(%eax)
80104b0b:	90                   	nop
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b10:	74 0e                	je     80104b20 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104b12:	83 c0 01             	add    $0x1,%eax
80104b15:	39 c2                	cmp    %eax,%edx
80104b17:	77 ef                	ja     80104b08 <argstr+0x58>
80104b19:	eb ba                	jmp    80104ad5 <argstr+0x25>
80104b1b:	90                   	nop
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
80104b20:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104b22:	5d                   	pop    %ebp
80104b23:	c3                   	ret    
80104b24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104b30 <syscall>:
[SYS_nice]    sys_nice,
};

void
syscall(void)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80104b37:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b3e:	8b 5a 18             	mov    0x18(%edx),%ebx
80104b41:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b44:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104b47:	83 f9 16             	cmp    $0x16,%ecx
80104b4a:	77 1c                	ja     80104b68 <syscall+0x38>
80104b4c:	8b 0c 85 e0 78 10 80 	mov    -0x7fef8720(,%eax,4),%ecx
80104b53:	85 c9                	test   %ecx,%ecx
80104b55:	74 11                	je     80104b68 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104b57:	ff d1                	call   *%ecx
80104b59:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
80104b5c:	83 c4 14             	add    $0x14,%esp
80104b5f:	5b                   	pop    %ebx
80104b60:	5d                   	pop    %ebp
80104b61:	c3                   	ret    
80104b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104b68:	89 44 24 0c          	mov    %eax,0xc(%esp)
            proc->pid, proc->name, num);
80104b6c:	8d 42 6c             	lea    0x6c(%edx),%eax
80104b6f:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104b73:	8b 42 10             	mov    0x10(%edx),%eax
80104b76:	c7 04 24 a9 78 10 80 	movl   $0x801078a9,(%esp)
80104b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b81:	e8 ca ba ff ff       	call   80100650 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80104b86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b8c:	8b 40 18             	mov    0x18(%eax),%eax
80104b8f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104b96:	83 c4 14             	add    $0x14,%esp
80104b99:	5b                   	pop    %ebx
80104b9a:	5d                   	pop    %ebp
80104b9b:	c3                   	ret    
80104b9c:	66 90                	xchg   %ax,%ax
80104b9e:	66 90                	xchg   %ax,%ax

80104ba0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	56                   	push   %esi
80104ba5:	53                   	push   %ebx
80104ba6:	83 ec 4c             	sub    $0x4c,%esp
80104ba9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104bac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104baf:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104bb2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104bb6:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104bb9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104bbc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104bbf:	e8 3c d3 ff ff       	call   80101f00 <nameiparent>
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	89 c7                	mov    %eax,%edi
80104bc8:	0f 84 da 00 00 00    	je     80104ca8 <create+0x108>
    return 0;
  ilock(dp);
80104bce:	89 04 24             	mov    %eax,(%esp)
80104bd1:	e8 da ca ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104bd6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104bd9:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bdd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104be1:	89 3c 24             	mov    %edi,(%esp)
80104be4:	e8 b7 cf ff ff       	call   80101ba0 <dirlookup>
80104be9:	85 c0                	test   %eax,%eax
80104beb:	89 c6                	mov    %eax,%esi
80104bed:	74 41                	je     80104c30 <create+0x90>
    iunlockput(dp);
80104bef:	89 3c 24             	mov    %edi,(%esp)
80104bf2:	e8 f9 cc ff ff       	call   801018f0 <iunlockput>
    ilock(ip);
80104bf7:	89 34 24             	mov    %esi,(%esp)
80104bfa:	e8 b1 ca ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104bff:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104c04:	75 12                	jne    80104c18 <create+0x78>
80104c06:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c0b:	89 f0                	mov    %esi,%eax
80104c0d:	75 09                	jne    80104c18 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c0f:	83 c4 4c             	add    $0x4c,%esp
80104c12:	5b                   	pop    %ebx
80104c13:	5e                   	pop    %esi
80104c14:	5f                   	pop    %edi
80104c15:	5d                   	pop    %ebp
80104c16:	c3                   	ret    
80104c17:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104c18:	89 34 24             	mov    %esi,(%esp)
80104c1b:	e8 d0 cc ff ff       	call   801018f0 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c20:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104c23:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c25:	5b                   	pop    %ebx
80104c26:	5e                   	pop    %esi
80104c27:	5f                   	pop    %edi
80104c28:	5d                   	pop    %ebp
80104c29:	c3                   	ret    
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104c30:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104c34:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c38:	8b 07                	mov    (%edi),%eax
80104c3a:	89 04 24             	mov    %eax,(%esp)
80104c3d:	e8 de c8 ff ff       	call   80101520 <ialloc>
80104c42:	85 c0                	test   %eax,%eax
80104c44:	89 c6                	mov    %eax,%esi
80104c46:	0f 84 bf 00 00 00    	je     80104d0b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
80104c4c:	89 04 24             	mov    %eax,(%esp)
80104c4f:	e8 5c ca ff ff       	call   801016b0 <ilock>
  ip->major = major;
80104c54:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104c58:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104c5c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104c60:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104c64:	b8 01 00 00 00       	mov    $0x1,%eax
80104c69:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104c6d:	89 34 24             	mov    %esi,(%esp)
80104c70:	e8 7b c9 ff ff       	call   801015f0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104c75:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104c7a:	74 34                	je     80104cb0 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104c7c:	8b 46 04             	mov    0x4(%esi),%eax
80104c7f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c83:	89 3c 24             	mov    %edi,(%esp)
80104c86:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c8a:	e8 71 d1 ff ff       	call   80101e00 <dirlink>
80104c8f:	85 c0                	test   %eax,%eax
80104c91:	78 6c                	js     80104cff <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80104c93:	89 3c 24             	mov    %edi,(%esp)
80104c96:	e8 55 cc ff ff       	call   801018f0 <iunlockput>

  return ip;
}
80104c9b:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104c9e:	89 f0                	mov    %esi,%eax
}
80104ca0:	5b                   	pop    %ebx
80104ca1:	5e                   	pop    %esi
80104ca2:	5f                   	pop    %edi
80104ca3:	5d                   	pop    %ebp
80104ca4:	c3                   	ret    
80104ca5:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104ca8:	31 c0                	xor    %eax,%eax
80104caa:	e9 60 ff ff ff       	jmp    80104c0f <create+0x6f>
80104caf:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104cb0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104cb5:	89 3c 24             	mov    %edi,(%esp)
80104cb8:	e8 33 c9 ff ff       	call   801015f0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104cbd:	8b 46 04             	mov    0x4(%esi),%eax
80104cc0:	c7 44 24 04 5c 79 10 	movl   $0x8010795c,0x4(%esp)
80104cc7:	80 
80104cc8:	89 34 24             	mov    %esi,(%esp)
80104ccb:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ccf:	e8 2c d1 ff ff       	call   80101e00 <dirlink>
80104cd4:	85 c0                	test   %eax,%eax
80104cd6:	78 1b                	js     80104cf3 <create+0x153>
80104cd8:	8b 47 04             	mov    0x4(%edi),%eax
80104cdb:	c7 44 24 04 5b 79 10 	movl   $0x8010795b,0x4(%esp)
80104ce2:	80 
80104ce3:	89 34 24             	mov    %esi,(%esp)
80104ce6:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cea:	e8 11 d1 ff ff       	call   80101e00 <dirlink>
80104cef:	85 c0                	test   %eax,%eax
80104cf1:	79 89                	jns    80104c7c <create+0xdc>
      panic("create dots");
80104cf3:	c7 04 24 4f 79 10 80 	movl   $0x8010794f,(%esp)
80104cfa:	e8 61 b6 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104cff:	c7 04 24 5e 79 10 80 	movl   $0x8010795e,(%esp)
80104d06:	e8 55 b6 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104d0b:	c7 04 24 40 79 10 80 	movl   $0x80107940,(%esp)
80104d12:	e8 49 b6 ff ff       	call   80100360 <panic>
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	89 c6                	mov    %eax,%esi
80104d26:	53                   	push   %ebx
80104d27:	89 d3                	mov    %edx,%ebx
80104d29:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104d2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d3a:	e8 e1 fc ff ff       	call   80104a20 <argint>
80104d3f:	85 c0                	test   %eax,%eax
80104d41:	78 35                	js     80104d78 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104d43:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104d46:	83 f9 0f             	cmp    $0xf,%ecx
80104d49:	77 2d                	ja     80104d78 <argfd.constprop.0+0x58>
80104d4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d51:	8b 44 88 28          	mov    0x28(%eax,%ecx,4),%eax
80104d55:	85 c0                	test   %eax,%eax
80104d57:	74 1f                	je     80104d78 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104d59:	85 f6                	test   %esi,%esi
80104d5b:	74 02                	je     80104d5f <argfd.constprop.0+0x3f>
    *pfd = fd;
80104d5d:	89 0e                	mov    %ecx,(%esi)
  if(pf)
80104d5f:	85 db                	test   %ebx,%ebx
80104d61:	74 0d                	je     80104d70 <argfd.constprop.0+0x50>
    *pf = f;
80104d63:	89 03                	mov    %eax,(%ebx)
  return 0;
80104d65:	31 c0                	xor    %eax,%eax
}
80104d67:	83 c4 20             	add    $0x20,%esp
80104d6a:	5b                   	pop    %ebx
80104d6b:	5e                   	pop    %esi
80104d6c:	5d                   	pop    %ebp
80104d6d:	c3                   	ret    
80104d6e:	66 90                	xchg   %ax,%ax
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104d70:	31 c0                	xor    %eax,%eax
80104d72:	eb f3                	jmp    80104d67 <argfd.constprop.0+0x47>
80104d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104d78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d7d:	eb e8                	jmp    80104d67 <argfd.constprop.0+0x47>
80104d7f:	90                   	nop

80104d80 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104d80:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104d81:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104d83:	89 e5                	mov    %esp,%ebp
80104d85:	53                   	push   %ebx
80104d86:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104d89:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d8c:	e8 8f ff ff ff       	call   80104d20 <argfd.constprop.0>
80104d91:	85 c0                	test   %eax,%eax
80104d93:	78 1b                	js     80104db0 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104d95:	8b 55 f4             	mov    -0xc(%ebp),%edx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104d98:	31 db                	xor    %ebx,%ebx
80104d9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    if(proc->ofile[fd] == 0){
80104da0:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104da4:	85 c9                	test   %ecx,%ecx
80104da6:	74 18                	je     80104dc0 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104da8:	83 c3 01             	add    $0x1,%ebx
80104dab:	83 fb 10             	cmp    $0x10,%ebx
80104dae:	75 f0                	jne    80104da0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104db0:	83 c4 24             	add    $0x24,%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104db3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104db8:	5b                   	pop    %ebx
80104db9:	5d                   	pop    %ebp
80104dba:	c3                   	ret    
80104dbb:	90                   	nop
80104dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104dc0:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104dc4:	89 14 24             	mov    %edx,(%esp)
80104dc7:	e8 04 c0 ff ff       	call   80100dd0 <filedup>
  return fd;
}
80104dcc:	83 c4 24             	add    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104dcf:	89 d8                	mov    %ebx,%eax
}
80104dd1:	5b                   	pop    %ebx
80104dd2:	5d                   	pop    %ebp
80104dd3:	c3                   	ret    
80104dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104de0 <sys_read>:

int
sys_read(void)
{
80104de0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104de1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104de3:	89 e5                	mov    %esp,%ebp
80104de5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104de8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104deb:	e8 30 ff ff ff       	call   80104d20 <argfd.constprop.0>
80104df0:	85 c0                	test   %eax,%eax
80104df2:	78 54                	js     80104e48 <sys_read+0x68>
80104df4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104df7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dfb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104e02:	e8 19 fc ff ff       	call   80104a20 <argint>
80104e07:	85 c0                	test   %eax,%eax
80104e09:	78 3d                	js     80104e48 <sys_read+0x68>
80104e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e15:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e20:	e8 3b fc ff ff       	call   80104a60 <argptr>
80104e25:	85 c0                	test   %eax,%eax
80104e27:	78 1f                	js     80104e48 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e2c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e33:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e3a:	89 04 24             	mov    %eax,(%esp)
80104e3d:	e8 ee c0 ff ff       	call   80100f30 <fileread>
}
80104e42:	c9                   	leave  
80104e43:	c3                   	ret    
80104e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104e4d:	c9                   	leave  
80104e4e:	c3                   	ret    
80104e4f:	90                   	nop

80104e50 <sys_write>:

int
sys_write(void)
{
80104e50:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e51:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104e53:	89 e5                	mov    %esp,%ebp
80104e55:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e5b:	e8 c0 fe ff ff       	call   80104d20 <argfd.constprop.0>
80104e60:	85 c0                	test   %eax,%eax
80104e62:	78 54                	js     80104eb8 <sys_write+0x68>
80104e64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e67:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e6b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104e72:	e8 a9 fb ff ff       	call   80104a20 <argint>
80104e77:	85 c0                	test   %eax,%eax
80104e79:	78 3d                	js     80104eb8 <sys_write+0x68>
80104e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e85:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e90:	e8 cb fb ff ff       	call   80104a60 <argptr>
80104e95:	85 c0                	test   %eax,%eax
80104e97:	78 1f                	js     80104eb8 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e9c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104eaa:	89 04 24             	mov    %eax,(%esp)
80104ead:	e8 1e c1 ff ff       	call   80100fd0 <filewrite>
}
80104eb2:	c9                   	leave  
80104eb3:	c3                   	ret    
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104ebd:	c9                   	leave  
80104ebe:	c3                   	ret    
80104ebf:	90                   	nop

80104ec0 <sys_close>:

int
sys_close(void)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104ec6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ec9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ecc:	e8 4f fe ff ff       	call   80104d20 <argfd.constprop.0>
80104ed1:	85 c0                	test   %eax,%eax
80104ed3:	78 23                	js     80104ef8 <sys_close+0x38>
    return -1;
  proc->ofile[fd] = 0;
80104ed5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ed8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ede:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ee5:	00 
  fileclose(f);
80104ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee9:	89 04 24             	mov    %eax,(%esp)
80104eec:	e8 2f bf ff ff       	call   80100e20 <fileclose>
  return 0;
80104ef1:	31 c0                	xor    %eax,%eax
}
80104ef3:	c9                   	leave  
80104ef4:	c3                   	ret    
80104ef5:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104efd:	c9                   	leave  
80104efe:	c3                   	ret    
80104eff:	90                   	nop

80104f00 <sys_fstat>:

int
sys_fstat(void)
{
80104f00:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f01:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104f03:	89 e5                	mov    %esp,%ebp
80104f05:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f08:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f0b:	e8 10 fe ff ff       	call   80104d20 <argfd.constprop.0>
80104f10:	85 c0                	test   %eax,%eax
80104f12:	78 34                	js     80104f48 <sys_fstat+0x48>
80104f14:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f17:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104f1e:	00 
80104f1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f2a:	e8 31 fb ff ff       	call   80104a60 <argptr>
80104f2f:	85 c0                	test   %eax,%eax
80104f31:	78 15                	js     80104f48 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f36:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f3d:	89 04 24             	mov    %eax,(%esp)
80104f40:	e8 9b bf ff ff       	call   80100ee0 <filestat>
}
80104f45:	c9                   	leave  
80104f46:	c3                   	ret    
80104f47:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104f4d:	c9                   	leave  
80104f4e:	c3                   	ret    
80104f4f:	90                   	nop

80104f50 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	57                   	push   %edi
80104f54:	56                   	push   %esi
80104f55:	53                   	push   %ebx
80104f56:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f59:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f67:	e8 44 fb ff ff       	call   80104ab0 <argstr>
80104f6c:	85 c0                	test   %eax,%eax
80104f6e:	0f 88 e6 00 00 00    	js     8010505a <sys_link+0x10a>
80104f74:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f77:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f82:	e8 29 fb ff ff       	call   80104ab0 <argstr>
80104f87:	85 c0                	test   %eax,%eax
80104f89:	0f 88 cb 00 00 00    	js     8010505a <sys_link+0x10a>
    return -1;

  begin_op();
80104f8f:	e8 0c dc ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
80104f94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104f97:	89 04 24             	mov    %eax,(%esp)
80104f9a:	e8 41 cf ff ff       	call   80101ee0 <namei>
80104f9f:	85 c0                	test   %eax,%eax
80104fa1:	89 c3                	mov    %eax,%ebx
80104fa3:	0f 84 ac 00 00 00    	je     80105055 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104fa9:	89 04 24             	mov    %eax,(%esp)
80104fac:	e8 ff c6 ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
80104fb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fb6:	0f 84 91 00 00 00    	je     8010504d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104fbc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104fc1:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104fc4:	89 1c 24             	mov    %ebx,(%esp)
80104fc7:	e8 24 c6 ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
80104fcc:	89 1c 24             	mov    %ebx,(%esp)
80104fcf:	e8 ac c7 ff ff       	call   80101780 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104fd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104fd7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104fdb:	89 04 24             	mov    %eax,(%esp)
80104fde:	e8 1d cf ff ff       	call   80101f00 <nameiparent>
80104fe3:	85 c0                	test   %eax,%eax
80104fe5:	89 c6                	mov    %eax,%esi
80104fe7:	74 4f                	je     80105038 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104fe9:	89 04 24             	mov    %eax,(%esp)
80104fec:	e8 bf c6 ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ff1:	8b 03                	mov    (%ebx),%eax
80104ff3:	39 06                	cmp    %eax,(%esi)
80104ff5:	75 39                	jne    80105030 <sys_link+0xe0>
80104ff7:	8b 43 04             	mov    0x4(%ebx),%eax
80104ffa:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104ffe:	89 34 24             	mov    %esi,(%esp)
80105001:	89 44 24 08          	mov    %eax,0x8(%esp)
80105005:	e8 f6 cd ff ff       	call   80101e00 <dirlink>
8010500a:	85 c0                	test   %eax,%eax
8010500c:	78 22                	js     80105030 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010500e:	89 34 24             	mov    %esi,(%esp)
80105011:	e8 da c8 ff ff       	call   801018f0 <iunlockput>
  iput(ip);
80105016:	89 1c 24             	mov    %ebx,(%esp)
80105019:	e8 a2 c7 ff ff       	call   801017c0 <iput>

  end_op();
8010501e:	e8 ed db ff ff       	call   80102c10 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105023:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80105026:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105028:	5b                   	pop    %ebx
80105029:	5e                   	pop    %esi
8010502a:	5f                   	pop    %edi
8010502b:	5d                   	pop    %ebp
8010502c:	c3                   	ret    
8010502d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105030:	89 34 24             	mov    %esi,(%esp)
80105033:	e8 b8 c8 ff ff       	call   801018f0 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80105038:	89 1c 24             	mov    %ebx,(%esp)
8010503b:	e8 70 c6 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
80105040:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105045:	89 1c 24             	mov    %ebx,(%esp)
80105048:	e8 a3 c5 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
8010504d:	89 1c 24             	mov    %ebx,(%esp)
80105050:	e8 9b c8 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105055:	e8 b6 db ff ff       	call   80102c10 <end_op>
  return -1;
}
8010505a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010505d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105062:	5b                   	pop    %ebx
80105063:	5e                   	pop    %esi
80105064:	5f                   	pop    %edi
80105065:	5d                   	pop    %ebp
80105066:	c3                   	ret    
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
80105075:	53                   	push   %ebx
80105076:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105079:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010507c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105080:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105087:	e8 24 fa ff ff       	call   80104ab0 <argstr>
8010508c:	85 c0                	test   %eax,%eax
8010508e:	0f 88 76 01 00 00    	js     8010520a <sys_unlink+0x19a>
    return -1;

  begin_op();
80105094:	e8 07 db ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105099:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010509c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010509f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801050a3:	89 04 24             	mov    %eax,(%esp)
801050a6:	e8 55 ce ff ff       	call   80101f00 <nameiparent>
801050ab:	85 c0                	test   %eax,%eax
801050ad:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801050b0:	0f 84 4f 01 00 00    	je     80105205 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
801050b6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
801050b9:	89 34 24             	mov    %esi,(%esp)
801050bc:	e8 ef c5 ff ff       	call   801016b0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050c1:	c7 44 24 04 5c 79 10 	movl   $0x8010795c,0x4(%esp)
801050c8:	80 
801050c9:	89 1c 24             	mov    %ebx,(%esp)
801050cc:	e8 9f ca ff ff       	call   80101b70 <namecmp>
801050d1:	85 c0                	test   %eax,%eax
801050d3:	0f 84 21 01 00 00    	je     801051fa <sys_unlink+0x18a>
801050d9:	c7 44 24 04 5b 79 10 	movl   $0x8010795b,0x4(%esp)
801050e0:	80 
801050e1:	89 1c 24             	mov    %ebx,(%esp)
801050e4:	e8 87 ca ff ff       	call   80101b70 <namecmp>
801050e9:	85 c0                	test   %eax,%eax
801050eb:	0f 84 09 01 00 00    	je     801051fa <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801050f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801050f8:	89 44 24 08          	mov    %eax,0x8(%esp)
801050fc:	89 34 24             	mov    %esi,(%esp)
801050ff:	e8 9c ca ff ff       	call   80101ba0 <dirlookup>
80105104:	85 c0                	test   %eax,%eax
80105106:	89 c3                	mov    %eax,%ebx
80105108:	0f 84 ec 00 00 00    	je     801051fa <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
8010510e:	89 04 24             	mov    %eax,(%esp)
80105111:	e8 9a c5 ff ff       	call   801016b0 <ilock>

  if(ip->nlink < 1)
80105116:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010511b:	0f 8e 24 01 00 00    	jle    80105245 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105121:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105126:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105129:	74 7d                	je     801051a8 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010512b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105132:	00 
80105133:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010513a:	00 
8010513b:	89 34 24             	mov    %esi,(%esp)
8010513e:	e8 0d f6 ff ff       	call   80104750 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105143:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105146:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010514d:	00 
8010514e:	89 74 24 04          	mov    %esi,0x4(%esp)
80105152:	89 44 24 08          	mov    %eax,0x8(%esp)
80105156:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105159:	89 04 24             	mov    %eax,(%esp)
8010515c:	e8 df c8 ff ff       	call   80101a40 <writei>
80105161:	83 f8 10             	cmp    $0x10,%eax
80105164:	0f 85 cf 00 00 00    	jne    80105239 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010516a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010516f:	0f 84 a3 00 00 00    	je     80105218 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105175:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105178:	89 04 24             	mov    %eax,(%esp)
8010517b:	e8 70 c7 ff ff       	call   801018f0 <iunlockput>

  ip->nlink--;
80105180:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105185:	89 1c 24             	mov    %ebx,(%esp)
80105188:	e8 63 c4 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
8010518d:	89 1c 24             	mov    %ebx,(%esp)
80105190:	e8 5b c7 ff ff       	call   801018f0 <iunlockput>

  end_op();
80105195:	e8 76 da ff ff       	call   80102c10 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010519a:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
8010519d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010519f:	5b                   	pop    %ebx
801051a0:	5e                   	pop    %esi
801051a1:	5f                   	pop    %edi
801051a2:	5d                   	pop    %ebp
801051a3:	c3                   	ret    
801051a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051a8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051ac:	0f 86 79 ff ff ff    	jbe    8010512b <sys_unlink+0xbb>
801051b2:	bf 20 00 00 00       	mov    $0x20,%edi
801051b7:	eb 15                	jmp    801051ce <sys_unlink+0x15e>
801051b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051c0:	8d 57 10             	lea    0x10(%edi),%edx
801051c3:	3b 53 58             	cmp    0x58(%ebx),%edx
801051c6:	0f 83 5f ff ff ff    	jae    8010512b <sys_unlink+0xbb>
801051cc:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051ce:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801051d5:	00 
801051d6:	89 7c 24 08          	mov    %edi,0x8(%esp)
801051da:	89 74 24 04          	mov    %esi,0x4(%esp)
801051de:	89 1c 24             	mov    %ebx,(%esp)
801051e1:	e8 5a c7 ff ff       	call   80101940 <readi>
801051e6:	83 f8 10             	cmp    $0x10,%eax
801051e9:	75 42                	jne    8010522d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
801051eb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051f0:	74 ce                	je     801051c0 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
801051f2:	89 1c 24             	mov    %ebx,(%esp)
801051f5:	e8 f6 c6 ff ff       	call   801018f0 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
801051fa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801051fd:	89 04 24             	mov    %eax,(%esp)
80105200:	e8 eb c6 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105205:	e8 06 da ff ff       	call   80102c10 <end_op>
  return -1;
}
8010520a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
8010520d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105212:	5b                   	pop    %ebx
80105213:	5e                   	pop    %esi
80105214:	5f                   	pop    %edi
80105215:	5d                   	pop    %ebp
80105216:	c3                   	ret    
80105217:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105218:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010521b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105220:	89 04 24             	mov    %eax,(%esp)
80105223:	e8 c8 c3 ff ff       	call   801015f0 <iupdate>
80105228:	e9 48 ff ff ff       	jmp    80105175 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010522d:	c7 04 24 80 79 10 80 	movl   $0x80107980,(%esp)
80105234:	e8 27 b1 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105239:	c7 04 24 92 79 10 80 	movl   $0x80107992,(%esp)
80105240:	e8 1b b1 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105245:	c7 04 24 6e 79 10 80 	movl   $0x8010796e,(%esp)
8010524c:	e8 0f b1 ff ff       	call   80100360 <panic>
80105251:	eb 0d                	jmp    80105260 <sys_open>
80105253:	90                   	nop
80105254:	90                   	nop
80105255:	90                   	nop
80105256:	90                   	nop
80105257:	90                   	nop
80105258:	90                   	nop
80105259:	90                   	nop
8010525a:	90                   	nop
8010525b:	90                   	nop
8010525c:	90                   	nop
8010525d:	90                   	nop
8010525e:	90                   	nop
8010525f:	90                   	nop

80105260 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
80105265:	53                   	push   %ebx
80105266:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105269:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010526c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105270:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105277:	e8 34 f8 ff ff       	call   80104ab0 <argstr>
8010527c:	85 c0                	test   %eax,%eax
8010527e:	0f 88 81 00 00 00    	js     80105305 <sys_open+0xa5>
80105284:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105287:	89 44 24 04          	mov    %eax,0x4(%esp)
8010528b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105292:	e8 89 f7 ff ff       	call   80104a20 <argint>
80105297:	85 c0                	test   %eax,%eax
80105299:	78 6a                	js     80105305 <sys_open+0xa5>
    return -1;

  begin_op();
8010529b:	e8 00 d9 ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
801052a0:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801052a4:	75 72                	jne    80105318 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801052a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052a9:	89 04 24             	mov    %eax,(%esp)
801052ac:	e8 2f cc ff ff       	call   80101ee0 <namei>
801052b1:	85 c0                	test   %eax,%eax
801052b3:	89 c7                	mov    %eax,%edi
801052b5:	74 49                	je     80105300 <sys_open+0xa0>
      end_op();
      return -1;
    }
    ilock(ip);
801052b7:	89 04 24             	mov    %eax,(%esp)
801052ba:	e8 f1 c3 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052bf:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
801052c4:	0f 84 ae 00 00 00    	je     80105378 <sys_open+0x118>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052ca:	e8 91 ba ff ff       	call   80100d60 <filealloc>
801052cf:	85 c0                	test   %eax,%eax
801052d1:	89 c6                	mov    %eax,%esi
801052d3:	74 23                	je     801052f8 <sys_open+0x98>
801052d5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052dc:	31 db                	xor    %ebx,%ebx
801052de:	66 90                	xchg   %ax,%ax
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801052e0:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
801052e4:	85 c0                	test   %eax,%eax
801052e6:	74 50                	je     80105338 <sys_open+0xd8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052e8:	83 c3 01             	add    $0x1,%ebx
801052eb:	83 fb 10             	cmp    $0x10,%ebx
801052ee:	75 f0                	jne    801052e0 <sys_open+0x80>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801052f0:	89 34 24             	mov    %esi,(%esp)
801052f3:	e8 28 bb ff ff       	call   80100e20 <fileclose>
    iunlockput(ip);
801052f8:	89 3c 24             	mov    %edi,(%esp)
801052fb:	e8 f0 c5 ff ff       	call   801018f0 <iunlockput>
    end_op();
80105300:	e8 0b d9 ff ff       	call   80102c10 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105305:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010530d:	5b                   	pop    %ebx
8010530e:	5e                   	pop    %esi
8010530f:	5f                   	pop    %edi
80105310:	5d                   	pop    %ebp
80105311:	c3                   	ret    
80105312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105318:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010531b:	31 c9                	xor    %ecx,%ecx
8010531d:	ba 02 00 00 00       	mov    $0x2,%edx
80105322:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105329:	e8 72 f8 ff ff       	call   80104ba0 <create>
    if(ip == 0){
8010532e:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105330:	89 c7                	mov    %eax,%edi
    if(ip == 0){
80105332:	75 96                	jne    801052ca <sys_open+0x6a>
80105334:	eb ca                	jmp    80105300 <sys_open+0xa0>
80105336:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105338:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010533c:	89 3c 24             	mov    %edi,(%esp)
8010533f:	e8 3c c4 ff ff       	call   80101780 <iunlock>
  end_op();
80105344:	e8 c7 d8 ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80105349:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010534f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105352:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80105355:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
8010535c:	89 d0                	mov    %edx,%eax
8010535e:	83 e0 01             	and    $0x1,%eax
80105361:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105364:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105367:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
8010536a:	89 d8                	mov    %ebx,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010536c:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
}
80105370:	83 c4 2c             	add    $0x2c,%esp
80105373:	5b                   	pop    %ebx
80105374:	5e                   	pop    %esi
80105375:	5f                   	pop    %edi
80105376:	5d                   	pop    %ebp
80105377:	c3                   	ret    
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105378:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010537b:	85 d2                	test   %edx,%edx
8010537d:	0f 84 47 ff ff ff    	je     801052ca <sys_open+0x6a>
80105383:	e9 70 ff ff ff       	jmp    801052f8 <sys_open+0x98>
80105388:	90                   	nop
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105390 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105396:	e8 05 d8 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010539b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010539e:	89 44 24 04          	mov    %eax,0x4(%esp)
801053a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053a9:	e8 02 f7 ff ff       	call   80104ab0 <argstr>
801053ae:	85 c0                	test   %eax,%eax
801053b0:	78 2e                	js     801053e0 <sys_mkdir+0x50>
801053b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b5:	31 c9                	xor    %ecx,%ecx
801053b7:	ba 01 00 00 00       	mov    $0x1,%edx
801053bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053c3:	e8 d8 f7 ff ff       	call   80104ba0 <create>
801053c8:	85 c0                	test   %eax,%eax
801053ca:	74 14                	je     801053e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053cc:	89 04 24             	mov    %eax,(%esp)
801053cf:	e8 1c c5 ff ff       	call   801018f0 <iunlockput>
  end_op();
801053d4:	e8 37 d8 ff ff       	call   80102c10 <end_op>
  return 0;
801053d9:	31 c0                	xor    %eax,%eax
}
801053db:	c9                   	leave  
801053dc:	c3                   	ret    
801053dd:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801053e0:	e8 2b d8 ff ff       	call   80102c10 <end_op>
    return -1;
801053e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801053ea:	c9                   	leave  
801053eb:	c3                   	ret    
801053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_mknod>:

int
sys_mknod(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053f6:	e8 a5 d7 ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105402:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105409:	e8 a2 f6 ff ff       	call   80104ab0 <argstr>
8010540e:	85 c0                	test   %eax,%eax
80105410:	78 5e                	js     80105470 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105412:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105415:	89 44 24 04          	mov    %eax,0x4(%esp)
80105419:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105420:	e8 fb f5 ff ff       	call   80104a20 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105425:	85 c0                	test   %eax,%eax
80105427:	78 47                	js     80105470 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105429:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010542c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105430:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105437:	e8 e4 f5 ff ff       	call   80104a20 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010543c:	85 c0                	test   %eax,%eax
8010543e:	78 30                	js     80105470 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105440:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105444:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105449:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010544d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105450:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105453:	e8 48 f7 ff ff       	call   80104ba0 <create>
80105458:	85 c0                	test   %eax,%eax
8010545a:	74 14                	je     80105470 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010545c:	89 04 24             	mov    %eax,(%esp)
8010545f:	e8 8c c4 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105464:	e8 a7 d7 ff ff       	call   80102c10 <end_op>
  return 0;
80105469:	31 c0                	xor    %eax,%eax
}
8010546b:	c9                   	leave  
8010546c:	c3                   	ret    
8010546d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105470:	e8 9b d7 ff ff       	call   80102c10 <end_op>
    return -1;
80105475:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010547a:	c9                   	leave  
8010547b:	c3                   	ret    
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105480 <sys_chdir>:

int
sys_chdir(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	53                   	push   %ebx
80105484:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105487:	e8 14 d7 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010548c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010548f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105493:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010549a:	e8 11 f6 ff ff       	call   80104ab0 <argstr>
8010549f:	85 c0                	test   %eax,%eax
801054a1:	78 5a                	js     801054fd <sys_chdir+0x7d>
801054a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a6:	89 04 24             	mov    %eax,(%esp)
801054a9:	e8 32 ca ff ff       	call   80101ee0 <namei>
801054ae:	85 c0                	test   %eax,%eax
801054b0:	89 c3                	mov    %eax,%ebx
801054b2:	74 49                	je     801054fd <sys_chdir+0x7d>
    end_op();
    return -1;
  }
  ilock(ip);
801054b4:	89 04 24             	mov    %eax,(%esp)
801054b7:	e8 f4 c1 ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
801054bc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
801054c1:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
801054c4:	75 32                	jne    801054f8 <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054c6:	e8 b5 c2 ff ff       	call   80101780 <iunlock>
  iput(proc->cwd);
801054cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054d1:	8b 40 68             	mov    0x68(%eax),%eax
801054d4:	89 04 24             	mov    %eax,(%esp)
801054d7:	e8 e4 c2 ff ff       	call   801017c0 <iput>
  end_op();
801054dc:	e8 2f d7 ff ff       	call   80102c10 <end_op>
  proc->cwd = ip;
801054e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054e7:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
}
801054ea:	83 c4 24             	add    $0x24,%esp
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
801054ed:	31 c0                	xor    %eax,%eax
}
801054ef:	5b                   	pop    %ebx
801054f0:	5d                   	pop    %ebp
801054f1:	c3                   	ret    
801054f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801054f8:	e8 f3 c3 ff ff       	call   801018f0 <iunlockput>
    end_op();
801054fd:	e8 0e d7 ff ff       	call   80102c10 <end_op>
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
80105502:	83 c4 24             	add    $0x24,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
80105505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
8010550a:	5b                   	pop    %ebx
8010550b:	5d                   	pop    %ebp
8010550c:	c3                   	ret    
8010550d:	8d 76 00             	lea    0x0(%esi),%esi

80105510 <sys_exec>:

int
sys_exec(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
80105515:	53                   	push   %ebx
80105516:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010551c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105522:	89 44 24 04          	mov    %eax,0x4(%esp)
80105526:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010552d:	e8 7e f5 ff ff       	call   80104ab0 <argstr>
80105532:	85 c0                	test   %eax,%eax
80105534:	0f 88 84 00 00 00    	js     801055be <sys_exec+0xae>
8010553a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105540:	89 44 24 04          	mov    %eax,0x4(%esp)
80105544:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010554b:	e8 d0 f4 ff ff       	call   80104a20 <argint>
80105550:	85 c0                	test   %eax,%eax
80105552:	78 6a                	js     801055be <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105554:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010555a:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010555c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105563:	00 
80105564:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010556a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105571:	00 
80105572:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105578:	89 04 24             	mov    %eax,(%esp)
8010557b:	e8 d0 f1 ff ff       	call   80104750 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105580:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105586:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010558a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010558d:	89 04 24             	mov    %eax,(%esp)
80105590:	e8 0b f4 ff ff       	call   801049a0 <fetchint>
80105595:	85 c0                	test   %eax,%eax
80105597:	78 25                	js     801055be <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105599:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010559f:	85 c0                	test   %eax,%eax
801055a1:	74 2d                	je     801055d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055a3:	89 74 24 04          	mov    %esi,0x4(%esp)
801055a7:	89 04 24             	mov    %eax,(%esp)
801055aa:	e8 21 f4 ff ff       	call   801049d0 <fetchstr>
801055af:	85 c0                	test   %eax,%eax
801055b1:	78 0b                	js     801055be <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801055b3:	83 c3 01             	add    $0x1,%ebx
801055b6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801055b9:	83 fb 20             	cmp    $0x20,%ebx
801055bc:	75 c2                	jne    80105580 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801055be:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801055c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801055c9:	5b                   	pop    %ebx
801055ca:	5e                   	pop    %esi
801055cb:	5f                   	pop    %edi
801055cc:	5d                   	pop    %ebp
801055cd:	c3                   	ret    
801055ce:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801055d0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801055d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801055da:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801055e0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055e7:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801055eb:	89 04 24             	mov    %eax,(%esp)
801055ee:	e8 bd b3 ff ff       	call   801009b0 <exec>
}
801055f3:	81 c4 ac 00 00 00    	add    $0xac,%esp
801055f9:	5b                   	pop    %ebx
801055fa:	5e                   	pop    %esi
801055fb:	5f                   	pop    %edi
801055fc:	5d                   	pop    %ebp
801055fd:	c3                   	ret    
801055fe:	66 90                	xchg   %ax,%ax

80105600 <sys_pipe>:

int
sys_pipe(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	57                   	push   %edi
80105604:	56                   	push   %esi
80105605:	53                   	push   %ebx
80105606:	83 ec 2c             	sub    $0x2c,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105609:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010560c:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105613:	00 
80105614:	89 44 24 04          	mov    %eax,0x4(%esp)
80105618:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010561f:	e8 3c f4 ff ff       	call   80104a60 <argptr>
80105624:	85 c0                	test   %eax,%eax
80105626:	78 7a                	js     801056a2 <sys_pipe+0xa2>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105628:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010562b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010562f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105632:	89 04 24             	mov    %eax,(%esp)
80105635:	e8 96 dc ff ff       	call   801032d0 <pipealloc>
8010563a:	85 c0                	test   %eax,%eax
8010563c:	78 64                	js     801056a2 <sys_pipe+0xa2>
8010563e:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105645:	31 c0                	xor    %eax,%eax
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105647:	8b 5d e0             	mov    -0x20(%ebp),%ebx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
8010564a:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
8010564e:	85 d2                	test   %edx,%edx
80105650:	74 16                	je     80105668 <sys_pipe+0x68>
80105652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105658:	83 c0 01             	add    $0x1,%eax
8010565b:	83 f8 10             	cmp    $0x10,%eax
8010565e:	74 2f                	je     8010568f <sys_pipe+0x8f>
    if(proc->ofile[fd] == 0){
80105660:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105664:	85 d2                	test   %edx,%edx
80105666:	75 f0                	jne    80105658 <sys_pipe+0x58>
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105668:	8b 7d e4             	mov    -0x1c(%ebp),%edi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
8010566b:	8d 70 08             	lea    0x8(%eax),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010566e:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105670:	89 5c b1 08          	mov    %ebx,0x8(%ecx,%esi,4)
80105674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105678:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
8010567d:	74 31                	je     801056b0 <sys_pipe+0xb0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010567f:	83 c2 01             	add    $0x1,%edx
80105682:	83 fa 10             	cmp    $0x10,%edx
80105685:	75 f1                	jne    80105678 <sys_pipe+0x78>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
80105687:	c7 44 b1 08 00 00 00 	movl   $0x0,0x8(%ecx,%esi,4)
8010568e:	00 
    fileclose(rf);
8010568f:	89 1c 24             	mov    %ebx,(%esp)
80105692:	e8 89 b7 ff ff       	call   80100e20 <fileclose>
    fileclose(wf);
80105697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010569a:	89 04 24             	mov    %eax,(%esp)
8010569d:	e8 7e b7 ff ff       	call   80100e20 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801056a2:	83 c4 2c             	add    $0x2c,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801056a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801056aa:	5b                   	pop    %ebx
801056ab:	5e                   	pop    %esi
801056ac:	5f                   	pop    %edi
801056ad:	5d                   	pop    %ebp
801056ae:	c3                   	ret    
801056af:	90                   	nop
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801056b0:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801056b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801056b7:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
801056b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801056bf:	83 c4 2c             	add    $0x2c,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801056c2:	31 c0                	xor    %eax,%eax
}
801056c4:	5b                   	pop    %ebx
801056c5:	5e                   	pop    %esi
801056c6:	5f                   	pop    %edi
801056c7:	5d                   	pop    %ebp
801056c8:	c3                   	ret    
801056c9:	66 90                	xchg   %ax,%ax
801056cb:	66 90                	xchg   %ax,%ax
801056cd:	66 90                	xchg   %ax,%ax
801056cf:	90                   	nop

801056d0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801056d3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801056d4:	e9 87 e3 ff ff       	jmp    80103a60 <fork>
801056d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_exit>:
}

int
sys_exit(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801056e6:	e8 85 e6 ff ff       	call   80103d70 <exit>
  return 0;  // not reached
}
801056eb:	31 c0                	xor    %eax,%eax
801056ed:	c9                   	leave  
801056ee:	c3                   	ret    
801056ef:	90                   	nop

801056f0 <sys_wait>:

int
sys_wait(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801056f3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801056f4:	e9 a7 e8 ff ff       	jmp    80103fa0 <wait>
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_kill>:
}

int
sys_kill(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105706:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105709:	89 44 24 04          	mov    %eax,0x4(%esp)
8010570d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105714:	e8 07 f3 ff ff       	call   80104a20 <argint>
80105719:	85 c0                	test   %eax,%eax
8010571b:	78 13                	js     80105730 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010571d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105720:	89 04 24             	mov    %eax,(%esp)
80105723:	e8 b8 e9 ff ff       	call   801040e0 <kill>
}
80105728:	c9                   	leave  
80105729:	c3                   	ret    
8010572a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105735:	c9                   	leave  
80105736:	c3                   	ret    
80105737:	89 f6                	mov    %esi,%esi
80105739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105740 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105740:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80105746:	55                   	push   %ebp
80105747:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
80105749:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
8010574a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010574d:	c3                   	ret    
8010574e:	66 90                	xchg   %ax,%ax

80105750 <sys_sbrk>:

int
sys_sbrk(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	53                   	push   %ebx
80105754:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105757:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010575a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010575e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105765:	e8 b6 f2 ff ff       	call   80104a20 <argint>
8010576a:	85 c0                	test   %eax,%eax
8010576c:	78 22                	js     80105790 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
8010576e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
80105774:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
80105777:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105779:	89 14 24             	mov    %edx,(%esp)
8010577c:	e8 5f e2 ff ff       	call   801039e0 <growproc>
80105781:	85 c0                	test   %eax,%eax
80105783:	78 0b                	js     80105790 <sys_sbrk+0x40>
    return -1;
  return addr;
80105785:	89 d8                	mov    %ebx,%eax
}
80105787:	83 c4 24             	add    $0x24,%esp
8010578a:	5b                   	pop    %ebx
8010578b:	5d                   	pop    %ebp
8010578c:	c3                   	ret    
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105790:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105795:	eb f0                	jmp    80105787 <sys_sbrk+0x37>
80105797:	89 f6                	mov    %esi,%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057a0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	53                   	push   %ebx
801057a4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057b5:	e8 66 f2 ff ff       	call   80104a20 <argint>
801057ba:	85 c0                	test   %eax,%eax
801057bc:	78 7e                	js     8010583c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801057be:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
801057c5:	e8 06 ee ff ff       	call   801045d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801057ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801057cd:	8b 1d 20 65 11 80    	mov    0x80116520,%ebx
  while(ticks - ticks0 < n){
801057d3:	85 d2                	test   %edx,%edx
801057d5:	75 29                	jne    80105800 <sys_sleep+0x60>
801057d7:	eb 4f                	jmp    80105828 <sys_sleep+0x88>
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801057e0:	c7 44 24 04 e0 5c 11 	movl   $0x80115ce0,0x4(%esp)
801057e7:	80 
801057e8:	c7 04 24 20 65 11 80 	movl   $0x80116520,(%esp)
801057ef:	e8 ec e6 ff ff       	call   80103ee0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801057f4:	a1 20 65 11 80       	mov    0x80116520,%eax
801057f9:	29 d8                	sub    %ebx,%eax
801057fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801057fe:	73 28                	jae    80105828 <sys_sleep+0x88>
    if(proc->killed){
80105800:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105806:	8b 40 24             	mov    0x24(%eax),%eax
80105809:	85 c0                	test   %eax,%eax
8010580b:	74 d3                	je     801057e0 <sys_sleep+0x40>
      release(&tickslock);
8010580d:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
80105814:	e8 e7 ee ff ff       	call   80104700 <release>
      return -1;
80105819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010581e:	83 c4 24             	add    $0x24,%esp
80105821:	5b                   	pop    %ebx
80105822:	5d                   	pop    %ebp
80105823:	c3                   	ret    
80105824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105828:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
8010582f:	e8 cc ee ff ff       	call   80104700 <release>
  return 0;
}
80105834:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105837:	31 c0                	xor    %eax,%eax
}
80105839:	5b                   	pop    %ebx
8010583a:	5d                   	pop    %ebp
8010583b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
8010583c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105841:	eb db                	jmp    8010581e <sys_sleep+0x7e>
80105843:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105850 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	53                   	push   %ebx
80105854:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105857:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
8010585e:	e8 6d ed ff ff       	call   801045d0 <acquire>
  xticks = ticks;
80105863:	8b 1d 20 65 11 80    	mov    0x80116520,%ebx
  release(&tickslock);
80105869:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
80105870:	e8 8b ee ff ff       	call   80104700 <release>
  return xticks;
}
80105875:	83 c4 14             	add    $0x14,%esp
80105878:	89 d8                	mov    %ebx,%eax
8010587a:	5b                   	pop    %ebx
8010587b:	5d                   	pop    %ebp
8010587c:	c3                   	ret    
8010587d:	8d 76 00             	lea    0x0(%esi),%esi

80105880 <sys_cps>:

int 
sys_cps(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
  return cps();
}
80105883:	5d                   	pop    %ebp
}

int 
sys_cps(void)
{
  return cps();
80105884:	e9 a7 e9 ff ff       	jmp    80104230 <cps>
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_nice>:
}

int 
sys_nice(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	83 ec 28             	sub    $0x28,%esp
  int pid, pr;
  if(argint(0, &pid) < 0)
80105896:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105899:	89 44 24 04          	mov    %eax,0x4(%esp)
8010589d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058a4:	e8 77 f1 ff ff       	call   80104a20 <argint>
801058a9:	85 c0                	test   %eax,%eax
801058ab:	78 2b                	js     801058d8 <sys_nice+0x48>
    return -1;
  if(argint(1, &pr) < 0)
801058ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801058b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058bb:	e8 60 f1 ff ff       	call   80104a20 <argint>
801058c0:	85 c0                	test   %eax,%eax
801058c2:	78 14                	js     801058d8 <sys_nice+0x48>
    return -1;

  return nice(pid, pr);
801058c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801058cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058ce:	89 04 24             	mov    %eax,(%esp)
801058d1:	e8 3a ea ff ff       	call   80104310 <nice>
801058d6:	c9                   	leave  
801058d7:	c3                   	ret    
int 
sys_nice(void)
{
  int pid, pr;
  if(argint(0, &pid) < 0)
    return -1;
801058d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(argint(1, &pr) < 0)
    return -1;

  return nice(pid, pr);
801058dd:	c9                   	leave  
801058de:	c3                   	ret    
801058df:	90                   	nop

801058e0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801058e0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801058e1:	ba 43 00 00 00       	mov    $0x43,%edx
801058e6:	89 e5                	mov    %esp,%ebp
801058e8:	b8 34 00 00 00       	mov    $0x34,%eax
801058ed:	83 ec 18             	sub    $0x18,%esp
801058f0:	ee                   	out    %al,(%dx)
801058f1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
801058f6:	b2 40                	mov    $0x40,%dl
801058f8:	ee                   	out    %al,(%dx)
801058f9:	b8 2e 00 00 00       	mov    $0x2e,%eax
801058fe:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
801058ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105906:	e8 05 d9 ff ff       	call   80103210 <picenable>
}
8010590b:	c9                   	leave  
8010590c:	c3                   	ret    

8010590d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010590d:	1e                   	push   %ds
  pushl %es
8010590e:	06                   	push   %es
  pushl %fs
8010590f:	0f a0                	push   %fs
  pushl %gs
80105911:	0f a8                	push   %gs
  pushal
80105913:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105914:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105918:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010591a:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010591c:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105920:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105922:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105924:	54                   	push   %esp
  call trap
80105925:	e8 e6 00 00 00       	call   80105a10 <trap>
  addl $4, %esp
8010592a:	83 c4 04             	add    $0x4,%esp

8010592d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010592d:	61                   	popa   
  popl %gs
8010592e:	0f a9                	pop    %gs
  popl %fs
80105930:	0f a1                	pop    %fs
  popl %es
80105932:	07                   	pop    %es
  popl %ds
80105933:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105934:	83 c4 08             	add    $0x8,%esp
  iret
80105937:	cf                   	iret   
80105938:	66 90                	xchg   %ax,%ax
8010593a:	66 90                	xchg   %ax,%ax
8010593c:	66 90                	xchg   %ax,%ax
8010593e:	66 90                	xchg   %ax,%ax

80105940 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105940:	31 c0                	xor    %eax,%eax
80105942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105948:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
8010594f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105954:	66 89 0c c5 22 5d 11 	mov    %cx,-0x7feea2de(,%eax,8)
8010595b:	80 
8010595c:	c6 04 c5 24 5d 11 80 	movb   $0x0,-0x7feea2dc(,%eax,8)
80105963:	00 
80105964:	c6 04 c5 25 5d 11 80 	movb   $0x8e,-0x7feea2db(,%eax,8)
8010596b:	8e 
8010596c:	66 89 14 c5 20 5d 11 	mov    %dx,-0x7feea2e0(,%eax,8)
80105973:	80 
80105974:	c1 ea 10             	shr    $0x10,%edx
80105977:	66 89 14 c5 26 5d 11 	mov    %dx,-0x7feea2da(,%eax,8)
8010597e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010597f:	83 c0 01             	add    $0x1,%eax
80105982:	3d 00 01 00 00       	cmp    $0x100,%eax
80105987:	75 bf                	jne    80105948 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105989:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010598a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010598f:	89 e5                	mov    %esp,%ebp
80105991:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105994:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
80105999:	c7 44 24 04 a1 79 10 	movl   $0x801079a1,0x4(%esp)
801059a0:	80 
801059a1:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059a8:	66 89 15 22 5f 11 80 	mov    %dx,0x80115f22
801059af:	66 a3 20 5f 11 80    	mov    %ax,0x80115f20
801059b5:	c1 e8 10             	shr    $0x10,%eax
801059b8:	c6 05 24 5f 11 80 00 	movb   $0x0,0x80115f24
801059bf:	c6 05 25 5f 11 80 ef 	movb   $0xef,0x80115f25
801059c6:	66 a3 26 5f 11 80    	mov    %ax,0x80115f26

  initlock(&tickslock, "time");
801059cc:	e8 7f eb ff ff       	call   80104550 <initlock>
}
801059d1:	c9                   	leave  
801059d2:	c3                   	ret    
801059d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059e0 <idtinit>:

void
idtinit(void)
{
801059e0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801059e1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059e6:	89 e5                	mov    %esp,%ebp
801059e8:	83 ec 10             	sub    $0x10,%esp
801059eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801059ef:	b8 20 5d 11 80       	mov    $0x80115d20,%eax
801059f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059f8:	c1 e8 10             	shr    $0x10,%eax
801059fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801059ff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a02:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105a05:	c9                   	leave  
80105a06:	c3                   	ret    
80105a07:	89 f6                	mov    %esi,%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a10 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	57                   	push   %edi
80105a14:	56                   	push   %esi
80105a15:	53                   	push   %ebx
80105a16:	83 ec 2c             	sub    $0x2c,%esp
80105a19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105a1c:	8b 43 30             	mov    0x30(%ebx),%eax
80105a1f:	83 f8 40             	cmp    $0x40,%eax
80105a22:	0f 84 00 01 00 00    	je     80105b28 <trap+0x118>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a28:	83 e8 20             	sub    $0x20,%eax
80105a2b:	83 f8 1f             	cmp    $0x1f,%eax
80105a2e:	77 60                	ja     80105a90 <trap+0x80>
80105a30:	ff 24 85 48 7a 10 80 	jmp    *-0x7fef85b8(,%eax,4)
80105a37:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105a38:	e8 33 cd ff ff       	call   80102770 <cpunum>
80105a3d:	85 c0                	test   %eax,%eax
80105a3f:	90                   	nop
80105a40:	0f 84 d2 01 00 00    	je     80105c18 <trap+0x208>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105a46:	e8 c5 cd ff ff       	call   80102810 <lapiceoi>
80105a4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105a51:	85 c0                	test   %eax,%eax
80105a53:	74 2d                	je     80105a82 <trap+0x72>
80105a55:	8b 50 24             	mov    0x24(%eax),%edx
80105a58:	85 d2                	test   %edx,%edx
80105a5a:	0f 85 9c 00 00 00    	jne    80105afc <trap+0xec>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105a60:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a64:	0f 84 86 01 00 00    	je     80105bf0 <trap+0x1e0>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105a6a:	8b 40 24             	mov    0x24(%eax),%eax
80105a6d:	85 c0                	test   %eax,%eax
80105a6f:	74 11                	je     80105a82 <trap+0x72>
80105a71:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a75:	83 e0 03             	and    $0x3,%eax
80105a78:	66 83 f8 03          	cmp    $0x3,%ax
80105a7c:	0f 84 d0 00 00 00    	je     80105b52 <trap+0x142>
    exit();
}
80105a82:	83 c4 2c             	add    $0x2c,%esp
80105a85:	5b                   	pop    %ebx
80105a86:	5e                   	pop    %esi
80105a87:	5f                   	pop    %edi
80105a88:	5d                   	pop    %ebp
80105a89:	c3                   	ret    
80105a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80105a90:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80105a97:	85 c9                	test   %ecx,%ecx
80105a99:	0f 84 a9 01 00 00    	je     80105c48 <trap+0x238>
80105a9f:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105aa3:	0f 84 9f 01 00 00    	je     80105c48 <trap+0x238>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105aa9:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105aac:	8b 73 38             	mov    0x38(%ebx),%esi
80105aaf:	e8 bc cc ff ff       	call   80102770 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105ab4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105abb:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
80105abf:	89 74 24 18          	mov    %esi,0x18(%esp)
80105ac3:	89 44 24 14          	mov    %eax,0x14(%esp)
80105ac7:	8b 43 34             	mov    0x34(%ebx),%eax
80105aca:	89 44 24 10          	mov    %eax,0x10(%esp)
80105ace:	8b 43 30             	mov    0x30(%ebx),%eax
80105ad1:	89 44 24 0c          	mov    %eax,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105ad5:	8d 42 6c             	lea    0x6c(%edx),%eax
80105ad8:	89 44 24 08          	mov    %eax,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105adc:	8b 42 10             	mov    0x10(%edx),%eax
80105adf:	c7 04 24 04 7a 10 80 	movl   $0x80107a04,(%esp)
80105ae6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aea:	e8 61 ab ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
80105aef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105af5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105afc:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105b00:	83 e2 03             	and    $0x3,%edx
80105b03:	66 83 fa 03          	cmp    $0x3,%dx
80105b07:	0f 85 53 ff ff ff    	jne    80105a60 <trap+0x50>
    exit();
80105b0d:	e8 5e e2 ff ff       	call   80103d70 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105b12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b18:	85 c0                	test   %eax,%eax
80105b1a:	0f 85 40 ff ff ff    	jne    80105a60 <trap+0x50>
80105b20:	e9 5d ff ff ff       	jmp    80105a82 <trap+0x72>
80105b25:	8d 76 00             	lea    0x0(%esi),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105b28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b2e:	8b 70 24             	mov    0x24(%eax),%esi
80105b31:	85 f6                	test   %esi,%esi
80105b33:	0f 85 a7 00 00 00    	jne    80105be0 <trap+0x1d0>
      exit();
    proc->tf = tf;
80105b39:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105b3c:	e8 ef ef ff ff       	call   80104b30 <syscall>
    if(proc->killed)
80105b41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b47:	8b 58 24             	mov    0x24(%eax),%ebx
80105b4a:	85 db                	test   %ebx,%ebx
80105b4c:	0f 84 30 ff ff ff    	je     80105a82 <trap+0x72>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105b52:	83 c4 2c             	add    $0x2c,%esp
80105b55:	5b                   	pop    %ebx
80105b56:	5e                   	pop    %esi
80105b57:	5f                   	pop    %edi
80105b58:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105b59:	e9 12 e2 ff ff       	jmp    80103d70 <exit>
80105b5e:	66 90                	xchg   %ax,%ax
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105b60:	e8 5b ca ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
80105b65:	e8 a6 cc ff ff       	call   80102810 <lapiceoi>
80105b6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105b70:	e9 dc fe ff ff       	jmp    80105a51 <trap+0x41>
80105b75:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105b78:	e8 f3 c4 ff ff       	call   80102070 <ideintr>
    lapiceoi();
80105b7d:	e8 8e cc ff ff       	call   80102810 <lapiceoi>
80105b82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105b88:	e9 c4 fe ff ff       	jmp    80105a51 <trap+0x41>
80105b8d:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105b90:	e8 1b 02 00 00       	call   80105db0 <uartintr>
    lapiceoi();
80105b95:	e8 76 cc ff ff       	call   80102810 <lapiceoi>
80105b9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105ba0:	e9 ac fe ff ff       	jmp    80105a51 <trap+0x41>
80105ba5:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ba8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bab:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105baf:	e8 bc cb ff ff       	call   80102770 <cpunum>
80105bb4:	c7 04 24 ac 79 10 80 	movl   $0x801079ac,(%esp)
80105bbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105bbf:	89 74 24 08          	mov    %esi,0x8(%esp)
80105bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bc7:	e8 84 aa ff ff       	call   80100650 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80105bcc:	e8 3f cc ff ff       	call   80102810 <lapiceoi>
80105bd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105bd7:	e9 75 fe ff ff       	jmp    80105a51 <trap+0x41>
80105bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105be0:	e8 8b e1 ff ff       	call   80103d70 <exit>
80105be5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105beb:	e9 49 ff ff ff       	jmp    80105b39 <trap+0x129>
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105bf0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105bf4:	0f 85 70 fe ff ff    	jne    80105a6a <trap+0x5a>
    yield();
80105bfa:	e8 a1 e2 ff ff       	call   80103ea0 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105bff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c05:	85 c0                	test   %eax,%eax
80105c07:	0f 85 5d fe ff ff    	jne    80105a6a <trap+0x5a>
80105c0d:	e9 70 fe ff ff       	jmp    80105a82 <trap+0x72>
80105c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105c18:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
80105c1f:	e8 ac e9 ff ff       	call   801045d0 <acquire>
      ticks++;
      wakeup(&ticks);
80105c24:	c7 04 24 20 65 11 80 	movl   $0x80116520,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
80105c2b:	83 05 20 65 11 80 01 	addl   $0x1,0x80116520
      wakeup(&ticks);
80105c32:	e8 49 e4 ff ff       	call   80104080 <wakeup>
      release(&tickslock);
80105c37:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
80105c3e:	e8 bd ea ff ff       	call   80104700 <release>
80105c43:	e9 fe fd ff ff       	jmp    80105a46 <trap+0x36>
80105c48:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c4b:	8b 73 38             	mov    0x38(%ebx),%esi
80105c4e:	e8 1d cb ff ff       	call   80102770 <cpunum>
80105c53:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105c57:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105c5b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c5f:	8b 43 30             	mov    0x30(%ebx),%eax
80105c62:	c7 04 24 d0 79 10 80 	movl   $0x801079d0,(%esp)
80105c69:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c6d:	e8 de a9 ff ff       	call   80100650 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105c72:	c7 04 24 a6 79 10 80 	movl   $0x801079a6,(%esp)
80105c79:	e8 e2 a6 ff ff       	call   80100360 <panic>
80105c7e:	66 90                	xchg   %ax,%ax

80105c80 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c80:	a1 d4 a5 10 80       	mov    0x8010a5d4,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105c85:	55                   	push   %ebp
80105c86:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105c88:	85 c0                	test   %eax,%eax
80105c8a:	74 14                	je     80105ca0 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c8c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c91:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c92:	a8 01                	test   $0x1,%al
80105c94:	74 0a                	je     80105ca0 <uartgetc+0x20>
80105c96:	b2 f8                	mov    $0xf8,%dl
80105c98:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c99:	0f b6 c0             	movzbl %al,%eax
}
80105c9c:	5d                   	pop    %ebp
80105c9d:	c3                   	ret    
80105c9e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105ca5:	5d                   	pop    %ebp
80105ca6:	c3                   	ret    
80105ca7:	89 f6                	mov    %esi,%esi
80105ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cb0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105cb0:	a1 d4 a5 10 80       	mov    0x8010a5d4,%eax
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	74 3f                	je     80105cf8 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105cb9:	55                   	push   %ebp
80105cba:	89 e5                	mov    %esp,%ebp
80105cbc:	56                   	push   %esi
80105cbd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105cc2:	53                   	push   %ebx
  int i;

  if(!uart)
80105cc3:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105cc8:	83 ec 10             	sub    $0x10,%esp
80105ccb:	eb 14                	jmp    80105ce1 <uartputc+0x31>
80105ccd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105cd0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105cd7:	e8 54 cb ff ff       	call   80102830 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cdc:	83 eb 01             	sub    $0x1,%ebx
80105cdf:	74 07                	je     80105ce8 <uartputc+0x38>
80105ce1:	89 f2                	mov    %esi,%edx
80105ce3:	ec                   	in     (%dx),%al
80105ce4:	a8 20                	test   $0x20,%al
80105ce6:	74 e8                	je     80105cd0 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105ce8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cec:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cf1:	ee                   	out    %al,(%dx)
}
80105cf2:	83 c4 10             	add    $0x10,%esp
80105cf5:	5b                   	pop    %ebx
80105cf6:	5e                   	pop    %esi
80105cf7:	5d                   	pop    %ebp
80105cf8:	f3 c3                	repz ret 
80105cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d00 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105d00:	55                   	push   %ebp
80105d01:	31 c9                	xor    %ecx,%ecx
80105d03:	89 e5                	mov    %esp,%ebp
80105d05:	89 c8                	mov    %ecx,%eax
80105d07:	57                   	push   %edi
80105d08:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105d0d:	56                   	push   %esi
80105d0e:	89 fa                	mov    %edi,%edx
80105d10:	53                   	push   %ebx
80105d11:	83 ec 1c             	sub    $0x1c,%esp
80105d14:	ee                   	out    %al,(%dx)
80105d15:	be fb 03 00 00       	mov    $0x3fb,%esi
80105d1a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d1f:	89 f2                	mov    %esi,%edx
80105d21:	ee                   	out    %al,(%dx)
80105d22:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d27:	b2 f8                	mov    $0xf8,%dl
80105d29:	ee                   	out    %al,(%dx)
80105d2a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105d2f:	89 c8                	mov    %ecx,%eax
80105d31:	89 da                	mov    %ebx,%edx
80105d33:	ee                   	out    %al,(%dx)
80105d34:	b8 03 00 00 00       	mov    $0x3,%eax
80105d39:	89 f2                	mov    %esi,%edx
80105d3b:	ee                   	out    %al,(%dx)
80105d3c:	b2 fc                	mov    $0xfc,%dl
80105d3e:	89 c8                	mov    %ecx,%eax
80105d40:	ee                   	out    %al,(%dx)
80105d41:	b8 01 00 00 00       	mov    $0x1,%eax
80105d46:	89 da                	mov    %ebx,%edx
80105d48:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d49:	b2 fd                	mov    $0xfd,%dl
80105d4b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105d4c:	3c ff                	cmp    $0xff,%al
80105d4e:	74 52                	je     80105da2 <uartinit+0xa2>
    return;
  uart = 1;
80105d50:	c7 05 d4 a5 10 80 01 	movl   $0x1,0x8010a5d4
80105d57:	00 00 00 
80105d5a:	89 fa                	mov    %edi,%edx
80105d5c:	ec                   	in     (%dx),%al
80105d5d:	b2 f8                	mov    $0xf8,%dl
80105d5f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105d60:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105d67:	bb c8 7a 10 80       	mov    $0x80107ac8,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105d6c:	e8 9f d4 ff ff       	call   80103210 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105d71:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d78:	00 
80105d79:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105d80:	e8 1b c5 ff ff       	call   801022a0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105d85:	b8 78 00 00 00       	mov    $0x78,%eax
80105d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc(*p);
80105d90:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105d93:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105d96:	e8 15 ff ff ff       	call   80105cb0 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105d9b:	0f be 03             	movsbl (%ebx),%eax
80105d9e:	84 c0                	test   %al,%al
80105da0:	75 ee                	jne    80105d90 <uartinit+0x90>
    uartputc(*p);
}
80105da2:	83 c4 1c             	add    $0x1c,%esp
80105da5:	5b                   	pop    %ebx
80105da6:	5e                   	pop    %esi
80105da7:	5f                   	pop    %edi
80105da8:	5d                   	pop    %ebp
80105da9:	c3                   	ret    
80105daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105db0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105db6:	c7 04 24 80 5c 10 80 	movl   $0x80105c80,(%esp)
80105dbd:	e8 ee a9 ff ff       	call   801007b0 <consoleintr>
}
80105dc2:	c9                   	leave  
80105dc3:	c3                   	ret    

80105dc4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105dc4:	6a 00                	push   $0x0
  pushl $0
80105dc6:	6a 00                	push   $0x0
  jmp alltraps
80105dc8:	e9 40 fb ff ff       	jmp    8010590d <alltraps>

80105dcd <vector1>:
.globl vector1
vector1:
  pushl $0
80105dcd:	6a 00                	push   $0x0
  pushl $1
80105dcf:	6a 01                	push   $0x1
  jmp alltraps
80105dd1:	e9 37 fb ff ff       	jmp    8010590d <alltraps>

80105dd6 <vector2>:
.globl vector2
vector2:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $2
80105dd8:	6a 02                	push   $0x2
  jmp alltraps
80105dda:	e9 2e fb ff ff       	jmp    8010590d <alltraps>

80105ddf <vector3>:
.globl vector3
vector3:
  pushl $0
80105ddf:	6a 00                	push   $0x0
  pushl $3
80105de1:	6a 03                	push   $0x3
  jmp alltraps
80105de3:	e9 25 fb ff ff       	jmp    8010590d <alltraps>

80105de8 <vector4>:
.globl vector4
vector4:
  pushl $0
80105de8:	6a 00                	push   $0x0
  pushl $4
80105dea:	6a 04                	push   $0x4
  jmp alltraps
80105dec:	e9 1c fb ff ff       	jmp    8010590d <alltraps>

80105df1 <vector5>:
.globl vector5
vector5:
  pushl $0
80105df1:	6a 00                	push   $0x0
  pushl $5
80105df3:	6a 05                	push   $0x5
  jmp alltraps
80105df5:	e9 13 fb ff ff       	jmp    8010590d <alltraps>

80105dfa <vector6>:
.globl vector6
vector6:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $6
80105dfc:	6a 06                	push   $0x6
  jmp alltraps
80105dfe:	e9 0a fb ff ff       	jmp    8010590d <alltraps>

80105e03 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e03:	6a 00                	push   $0x0
  pushl $7
80105e05:	6a 07                	push   $0x7
  jmp alltraps
80105e07:	e9 01 fb ff ff       	jmp    8010590d <alltraps>

80105e0c <vector8>:
.globl vector8
vector8:
  pushl $8
80105e0c:	6a 08                	push   $0x8
  jmp alltraps
80105e0e:	e9 fa fa ff ff       	jmp    8010590d <alltraps>

80105e13 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $9
80105e15:	6a 09                	push   $0x9
  jmp alltraps
80105e17:	e9 f1 fa ff ff       	jmp    8010590d <alltraps>

80105e1c <vector10>:
.globl vector10
vector10:
  pushl $10
80105e1c:	6a 0a                	push   $0xa
  jmp alltraps
80105e1e:	e9 ea fa ff ff       	jmp    8010590d <alltraps>

80105e23 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e23:	6a 0b                	push   $0xb
  jmp alltraps
80105e25:	e9 e3 fa ff ff       	jmp    8010590d <alltraps>

80105e2a <vector12>:
.globl vector12
vector12:
  pushl $12
80105e2a:	6a 0c                	push   $0xc
  jmp alltraps
80105e2c:	e9 dc fa ff ff       	jmp    8010590d <alltraps>

80105e31 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e31:	6a 0d                	push   $0xd
  jmp alltraps
80105e33:	e9 d5 fa ff ff       	jmp    8010590d <alltraps>

80105e38 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e38:	6a 0e                	push   $0xe
  jmp alltraps
80105e3a:	e9 ce fa ff ff       	jmp    8010590d <alltraps>

80105e3f <vector15>:
.globl vector15
vector15:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $15
80105e41:	6a 0f                	push   $0xf
  jmp alltraps
80105e43:	e9 c5 fa ff ff       	jmp    8010590d <alltraps>

80105e48 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e48:	6a 00                	push   $0x0
  pushl $16
80105e4a:	6a 10                	push   $0x10
  jmp alltraps
80105e4c:	e9 bc fa ff ff       	jmp    8010590d <alltraps>

80105e51 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e51:	6a 11                	push   $0x11
  jmp alltraps
80105e53:	e9 b5 fa ff ff       	jmp    8010590d <alltraps>

80105e58 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e58:	6a 00                	push   $0x0
  pushl $18
80105e5a:	6a 12                	push   $0x12
  jmp alltraps
80105e5c:	e9 ac fa ff ff       	jmp    8010590d <alltraps>

80105e61 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e61:	6a 00                	push   $0x0
  pushl $19
80105e63:	6a 13                	push   $0x13
  jmp alltraps
80105e65:	e9 a3 fa ff ff       	jmp    8010590d <alltraps>

80105e6a <vector20>:
.globl vector20
vector20:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $20
80105e6c:	6a 14                	push   $0x14
  jmp alltraps
80105e6e:	e9 9a fa ff ff       	jmp    8010590d <alltraps>

80105e73 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $21
80105e75:	6a 15                	push   $0x15
  jmp alltraps
80105e77:	e9 91 fa ff ff       	jmp    8010590d <alltraps>

80105e7c <vector22>:
.globl vector22
vector22:
  pushl $0
80105e7c:	6a 00                	push   $0x0
  pushl $22
80105e7e:	6a 16                	push   $0x16
  jmp alltraps
80105e80:	e9 88 fa ff ff       	jmp    8010590d <alltraps>

80105e85 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e85:	6a 00                	push   $0x0
  pushl $23
80105e87:	6a 17                	push   $0x17
  jmp alltraps
80105e89:	e9 7f fa ff ff       	jmp    8010590d <alltraps>

80105e8e <vector24>:
.globl vector24
vector24:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $24
80105e90:	6a 18                	push   $0x18
  jmp alltraps
80105e92:	e9 76 fa ff ff       	jmp    8010590d <alltraps>

80105e97 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $25
80105e99:	6a 19                	push   $0x19
  jmp alltraps
80105e9b:	e9 6d fa ff ff       	jmp    8010590d <alltraps>

80105ea0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ea0:	6a 00                	push   $0x0
  pushl $26
80105ea2:	6a 1a                	push   $0x1a
  jmp alltraps
80105ea4:	e9 64 fa ff ff       	jmp    8010590d <alltraps>

80105ea9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $27
80105eab:	6a 1b                	push   $0x1b
  jmp alltraps
80105ead:	e9 5b fa ff ff       	jmp    8010590d <alltraps>

80105eb2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $28
80105eb4:	6a 1c                	push   $0x1c
  jmp alltraps
80105eb6:	e9 52 fa ff ff       	jmp    8010590d <alltraps>

80105ebb <vector29>:
.globl vector29
vector29:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $29
80105ebd:	6a 1d                	push   $0x1d
  jmp alltraps
80105ebf:	e9 49 fa ff ff       	jmp    8010590d <alltraps>

80105ec4 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $30
80105ec6:	6a 1e                	push   $0x1e
  jmp alltraps
80105ec8:	e9 40 fa ff ff       	jmp    8010590d <alltraps>

80105ecd <vector31>:
.globl vector31
vector31:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $31
80105ecf:	6a 1f                	push   $0x1f
  jmp alltraps
80105ed1:	e9 37 fa ff ff       	jmp    8010590d <alltraps>

80105ed6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $32
80105ed8:	6a 20                	push   $0x20
  jmp alltraps
80105eda:	e9 2e fa ff ff       	jmp    8010590d <alltraps>

80105edf <vector33>:
.globl vector33
vector33:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $33
80105ee1:	6a 21                	push   $0x21
  jmp alltraps
80105ee3:	e9 25 fa ff ff       	jmp    8010590d <alltraps>

80105ee8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $34
80105eea:	6a 22                	push   $0x22
  jmp alltraps
80105eec:	e9 1c fa ff ff       	jmp    8010590d <alltraps>

80105ef1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $35
80105ef3:	6a 23                	push   $0x23
  jmp alltraps
80105ef5:	e9 13 fa ff ff       	jmp    8010590d <alltraps>

80105efa <vector36>:
.globl vector36
vector36:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $36
80105efc:	6a 24                	push   $0x24
  jmp alltraps
80105efe:	e9 0a fa ff ff       	jmp    8010590d <alltraps>

80105f03 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $37
80105f05:	6a 25                	push   $0x25
  jmp alltraps
80105f07:	e9 01 fa ff ff       	jmp    8010590d <alltraps>

80105f0c <vector38>:
.globl vector38
vector38:
  pushl $0
80105f0c:	6a 00                	push   $0x0
  pushl $38
80105f0e:	6a 26                	push   $0x26
  jmp alltraps
80105f10:	e9 f8 f9 ff ff       	jmp    8010590d <alltraps>

80105f15 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f15:	6a 00                	push   $0x0
  pushl $39
80105f17:	6a 27                	push   $0x27
  jmp alltraps
80105f19:	e9 ef f9 ff ff       	jmp    8010590d <alltraps>

80105f1e <vector40>:
.globl vector40
vector40:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $40
80105f20:	6a 28                	push   $0x28
  jmp alltraps
80105f22:	e9 e6 f9 ff ff       	jmp    8010590d <alltraps>

80105f27 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $41
80105f29:	6a 29                	push   $0x29
  jmp alltraps
80105f2b:	e9 dd f9 ff ff       	jmp    8010590d <alltraps>

80105f30 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $42
80105f32:	6a 2a                	push   $0x2a
  jmp alltraps
80105f34:	e9 d4 f9 ff ff       	jmp    8010590d <alltraps>

80105f39 <vector43>:
.globl vector43
vector43:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $43
80105f3b:	6a 2b                	push   $0x2b
  jmp alltraps
80105f3d:	e9 cb f9 ff ff       	jmp    8010590d <alltraps>

80105f42 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $44
80105f44:	6a 2c                	push   $0x2c
  jmp alltraps
80105f46:	e9 c2 f9 ff ff       	jmp    8010590d <alltraps>

80105f4b <vector45>:
.globl vector45
vector45:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $45
80105f4d:	6a 2d                	push   $0x2d
  jmp alltraps
80105f4f:	e9 b9 f9 ff ff       	jmp    8010590d <alltraps>

80105f54 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $46
80105f56:	6a 2e                	push   $0x2e
  jmp alltraps
80105f58:	e9 b0 f9 ff ff       	jmp    8010590d <alltraps>

80105f5d <vector47>:
.globl vector47
vector47:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $47
80105f5f:	6a 2f                	push   $0x2f
  jmp alltraps
80105f61:	e9 a7 f9 ff ff       	jmp    8010590d <alltraps>

80105f66 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $48
80105f68:	6a 30                	push   $0x30
  jmp alltraps
80105f6a:	e9 9e f9 ff ff       	jmp    8010590d <alltraps>

80105f6f <vector49>:
.globl vector49
vector49:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $49
80105f71:	6a 31                	push   $0x31
  jmp alltraps
80105f73:	e9 95 f9 ff ff       	jmp    8010590d <alltraps>

80105f78 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $50
80105f7a:	6a 32                	push   $0x32
  jmp alltraps
80105f7c:	e9 8c f9 ff ff       	jmp    8010590d <alltraps>

80105f81 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $51
80105f83:	6a 33                	push   $0x33
  jmp alltraps
80105f85:	e9 83 f9 ff ff       	jmp    8010590d <alltraps>

80105f8a <vector52>:
.globl vector52
vector52:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $52
80105f8c:	6a 34                	push   $0x34
  jmp alltraps
80105f8e:	e9 7a f9 ff ff       	jmp    8010590d <alltraps>

80105f93 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $53
80105f95:	6a 35                	push   $0x35
  jmp alltraps
80105f97:	e9 71 f9 ff ff       	jmp    8010590d <alltraps>

80105f9c <vector54>:
.globl vector54
vector54:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $54
80105f9e:	6a 36                	push   $0x36
  jmp alltraps
80105fa0:	e9 68 f9 ff ff       	jmp    8010590d <alltraps>

80105fa5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $55
80105fa7:	6a 37                	push   $0x37
  jmp alltraps
80105fa9:	e9 5f f9 ff ff       	jmp    8010590d <alltraps>

80105fae <vector56>:
.globl vector56
vector56:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $56
80105fb0:	6a 38                	push   $0x38
  jmp alltraps
80105fb2:	e9 56 f9 ff ff       	jmp    8010590d <alltraps>

80105fb7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $57
80105fb9:	6a 39                	push   $0x39
  jmp alltraps
80105fbb:	e9 4d f9 ff ff       	jmp    8010590d <alltraps>

80105fc0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $58
80105fc2:	6a 3a                	push   $0x3a
  jmp alltraps
80105fc4:	e9 44 f9 ff ff       	jmp    8010590d <alltraps>

80105fc9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $59
80105fcb:	6a 3b                	push   $0x3b
  jmp alltraps
80105fcd:	e9 3b f9 ff ff       	jmp    8010590d <alltraps>

80105fd2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $60
80105fd4:	6a 3c                	push   $0x3c
  jmp alltraps
80105fd6:	e9 32 f9 ff ff       	jmp    8010590d <alltraps>

80105fdb <vector61>:
.globl vector61
vector61:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $61
80105fdd:	6a 3d                	push   $0x3d
  jmp alltraps
80105fdf:	e9 29 f9 ff ff       	jmp    8010590d <alltraps>

80105fe4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $62
80105fe6:	6a 3e                	push   $0x3e
  jmp alltraps
80105fe8:	e9 20 f9 ff ff       	jmp    8010590d <alltraps>

80105fed <vector63>:
.globl vector63
vector63:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $63
80105fef:	6a 3f                	push   $0x3f
  jmp alltraps
80105ff1:	e9 17 f9 ff ff       	jmp    8010590d <alltraps>

80105ff6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $64
80105ff8:	6a 40                	push   $0x40
  jmp alltraps
80105ffa:	e9 0e f9 ff ff       	jmp    8010590d <alltraps>

80105fff <vector65>:
.globl vector65
vector65:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $65
80106001:	6a 41                	push   $0x41
  jmp alltraps
80106003:	e9 05 f9 ff ff       	jmp    8010590d <alltraps>

80106008 <vector66>:
.globl vector66
vector66:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $66
8010600a:	6a 42                	push   $0x42
  jmp alltraps
8010600c:	e9 fc f8 ff ff       	jmp    8010590d <alltraps>

80106011 <vector67>:
.globl vector67
vector67:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $67
80106013:	6a 43                	push   $0x43
  jmp alltraps
80106015:	e9 f3 f8 ff ff       	jmp    8010590d <alltraps>

8010601a <vector68>:
.globl vector68
vector68:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $68
8010601c:	6a 44                	push   $0x44
  jmp alltraps
8010601e:	e9 ea f8 ff ff       	jmp    8010590d <alltraps>

80106023 <vector69>:
.globl vector69
vector69:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $69
80106025:	6a 45                	push   $0x45
  jmp alltraps
80106027:	e9 e1 f8 ff ff       	jmp    8010590d <alltraps>

8010602c <vector70>:
.globl vector70
vector70:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $70
8010602e:	6a 46                	push   $0x46
  jmp alltraps
80106030:	e9 d8 f8 ff ff       	jmp    8010590d <alltraps>

80106035 <vector71>:
.globl vector71
vector71:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $71
80106037:	6a 47                	push   $0x47
  jmp alltraps
80106039:	e9 cf f8 ff ff       	jmp    8010590d <alltraps>

8010603e <vector72>:
.globl vector72
vector72:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $72
80106040:	6a 48                	push   $0x48
  jmp alltraps
80106042:	e9 c6 f8 ff ff       	jmp    8010590d <alltraps>

80106047 <vector73>:
.globl vector73
vector73:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $73
80106049:	6a 49                	push   $0x49
  jmp alltraps
8010604b:	e9 bd f8 ff ff       	jmp    8010590d <alltraps>

80106050 <vector74>:
.globl vector74
vector74:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $74
80106052:	6a 4a                	push   $0x4a
  jmp alltraps
80106054:	e9 b4 f8 ff ff       	jmp    8010590d <alltraps>

80106059 <vector75>:
.globl vector75
vector75:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $75
8010605b:	6a 4b                	push   $0x4b
  jmp alltraps
8010605d:	e9 ab f8 ff ff       	jmp    8010590d <alltraps>

80106062 <vector76>:
.globl vector76
vector76:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $76
80106064:	6a 4c                	push   $0x4c
  jmp alltraps
80106066:	e9 a2 f8 ff ff       	jmp    8010590d <alltraps>

8010606b <vector77>:
.globl vector77
vector77:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $77
8010606d:	6a 4d                	push   $0x4d
  jmp alltraps
8010606f:	e9 99 f8 ff ff       	jmp    8010590d <alltraps>

80106074 <vector78>:
.globl vector78
vector78:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $78
80106076:	6a 4e                	push   $0x4e
  jmp alltraps
80106078:	e9 90 f8 ff ff       	jmp    8010590d <alltraps>

8010607d <vector79>:
.globl vector79
vector79:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $79
8010607f:	6a 4f                	push   $0x4f
  jmp alltraps
80106081:	e9 87 f8 ff ff       	jmp    8010590d <alltraps>

80106086 <vector80>:
.globl vector80
vector80:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $80
80106088:	6a 50                	push   $0x50
  jmp alltraps
8010608a:	e9 7e f8 ff ff       	jmp    8010590d <alltraps>

8010608f <vector81>:
.globl vector81
vector81:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $81
80106091:	6a 51                	push   $0x51
  jmp alltraps
80106093:	e9 75 f8 ff ff       	jmp    8010590d <alltraps>

80106098 <vector82>:
.globl vector82
vector82:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $82
8010609a:	6a 52                	push   $0x52
  jmp alltraps
8010609c:	e9 6c f8 ff ff       	jmp    8010590d <alltraps>

801060a1 <vector83>:
.globl vector83
vector83:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $83
801060a3:	6a 53                	push   $0x53
  jmp alltraps
801060a5:	e9 63 f8 ff ff       	jmp    8010590d <alltraps>

801060aa <vector84>:
.globl vector84
vector84:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $84
801060ac:	6a 54                	push   $0x54
  jmp alltraps
801060ae:	e9 5a f8 ff ff       	jmp    8010590d <alltraps>

801060b3 <vector85>:
.globl vector85
vector85:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $85
801060b5:	6a 55                	push   $0x55
  jmp alltraps
801060b7:	e9 51 f8 ff ff       	jmp    8010590d <alltraps>

801060bc <vector86>:
.globl vector86
vector86:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $86
801060be:	6a 56                	push   $0x56
  jmp alltraps
801060c0:	e9 48 f8 ff ff       	jmp    8010590d <alltraps>

801060c5 <vector87>:
.globl vector87
vector87:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $87
801060c7:	6a 57                	push   $0x57
  jmp alltraps
801060c9:	e9 3f f8 ff ff       	jmp    8010590d <alltraps>

801060ce <vector88>:
.globl vector88
vector88:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $88
801060d0:	6a 58                	push   $0x58
  jmp alltraps
801060d2:	e9 36 f8 ff ff       	jmp    8010590d <alltraps>

801060d7 <vector89>:
.globl vector89
vector89:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $89
801060d9:	6a 59                	push   $0x59
  jmp alltraps
801060db:	e9 2d f8 ff ff       	jmp    8010590d <alltraps>

801060e0 <vector90>:
.globl vector90
vector90:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $90
801060e2:	6a 5a                	push   $0x5a
  jmp alltraps
801060e4:	e9 24 f8 ff ff       	jmp    8010590d <alltraps>

801060e9 <vector91>:
.globl vector91
vector91:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $91
801060eb:	6a 5b                	push   $0x5b
  jmp alltraps
801060ed:	e9 1b f8 ff ff       	jmp    8010590d <alltraps>

801060f2 <vector92>:
.globl vector92
vector92:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $92
801060f4:	6a 5c                	push   $0x5c
  jmp alltraps
801060f6:	e9 12 f8 ff ff       	jmp    8010590d <alltraps>

801060fb <vector93>:
.globl vector93
vector93:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $93
801060fd:	6a 5d                	push   $0x5d
  jmp alltraps
801060ff:	e9 09 f8 ff ff       	jmp    8010590d <alltraps>

80106104 <vector94>:
.globl vector94
vector94:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $94
80106106:	6a 5e                	push   $0x5e
  jmp alltraps
80106108:	e9 00 f8 ff ff       	jmp    8010590d <alltraps>

8010610d <vector95>:
.globl vector95
vector95:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $95
8010610f:	6a 5f                	push   $0x5f
  jmp alltraps
80106111:	e9 f7 f7 ff ff       	jmp    8010590d <alltraps>

80106116 <vector96>:
.globl vector96
vector96:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $96
80106118:	6a 60                	push   $0x60
  jmp alltraps
8010611a:	e9 ee f7 ff ff       	jmp    8010590d <alltraps>

8010611f <vector97>:
.globl vector97
vector97:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $97
80106121:	6a 61                	push   $0x61
  jmp alltraps
80106123:	e9 e5 f7 ff ff       	jmp    8010590d <alltraps>

80106128 <vector98>:
.globl vector98
vector98:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $98
8010612a:	6a 62                	push   $0x62
  jmp alltraps
8010612c:	e9 dc f7 ff ff       	jmp    8010590d <alltraps>

80106131 <vector99>:
.globl vector99
vector99:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $99
80106133:	6a 63                	push   $0x63
  jmp alltraps
80106135:	e9 d3 f7 ff ff       	jmp    8010590d <alltraps>

8010613a <vector100>:
.globl vector100
vector100:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $100
8010613c:	6a 64                	push   $0x64
  jmp alltraps
8010613e:	e9 ca f7 ff ff       	jmp    8010590d <alltraps>

80106143 <vector101>:
.globl vector101
vector101:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $101
80106145:	6a 65                	push   $0x65
  jmp alltraps
80106147:	e9 c1 f7 ff ff       	jmp    8010590d <alltraps>

8010614c <vector102>:
.globl vector102
vector102:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $102
8010614e:	6a 66                	push   $0x66
  jmp alltraps
80106150:	e9 b8 f7 ff ff       	jmp    8010590d <alltraps>

80106155 <vector103>:
.globl vector103
vector103:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $103
80106157:	6a 67                	push   $0x67
  jmp alltraps
80106159:	e9 af f7 ff ff       	jmp    8010590d <alltraps>

8010615e <vector104>:
.globl vector104
vector104:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $104
80106160:	6a 68                	push   $0x68
  jmp alltraps
80106162:	e9 a6 f7 ff ff       	jmp    8010590d <alltraps>

80106167 <vector105>:
.globl vector105
vector105:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $105
80106169:	6a 69                	push   $0x69
  jmp alltraps
8010616b:	e9 9d f7 ff ff       	jmp    8010590d <alltraps>

80106170 <vector106>:
.globl vector106
vector106:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $106
80106172:	6a 6a                	push   $0x6a
  jmp alltraps
80106174:	e9 94 f7 ff ff       	jmp    8010590d <alltraps>

80106179 <vector107>:
.globl vector107
vector107:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $107
8010617b:	6a 6b                	push   $0x6b
  jmp alltraps
8010617d:	e9 8b f7 ff ff       	jmp    8010590d <alltraps>

80106182 <vector108>:
.globl vector108
vector108:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $108
80106184:	6a 6c                	push   $0x6c
  jmp alltraps
80106186:	e9 82 f7 ff ff       	jmp    8010590d <alltraps>

8010618b <vector109>:
.globl vector109
vector109:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $109
8010618d:	6a 6d                	push   $0x6d
  jmp alltraps
8010618f:	e9 79 f7 ff ff       	jmp    8010590d <alltraps>

80106194 <vector110>:
.globl vector110
vector110:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $110
80106196:	6a 6e                	push   $0x6e
  jmp alltraps
80106198:	e9 70 f7 ff ff       	jmp    8010590d <alltraps>

8010619d <vector111>:
.globl vector111
vector111:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $111
8010619f:	6a 6f                	push   $0x6f
  jmp alltraps
801061a1:	e9 67 f7 ff ff       	jmp    8010590d <alltraps>

801061a6 <vector112>:
.globl vector112
vector112:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $112
801061a8:	6a 70                	push   $0x70
  jmp alltraps
801061aa:	e9 5e f7 ff ff       	jmp    8010590d <alltraps>

801061af <vector113>:
.globl vector113
vector113:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $113
801061b1:	6a 71                	push   $0x71
  jmp alltraps
801061b3:	e9 55 f7 ff ff       	jmp    8010590d <alltraps>

801061b8 <vector114>:
.globl vector114
vector114:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $114
801061ba:	6a 72                	push   $0x72
  jmp alltraps
801061bc:	e9 4c f7 ff ff       	jmp    8010590d <alltraps>

801061c1 <vector115>:
.globl vector115
vector115:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $115
801061c3:	6a 73                	push   $0x73
  jmp alltraps
801061c5:	e9 43 f7 ff ff       	jmp    8010590d <alltraps>

801061ca <vector116>:
.globl vector116
vector116:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $116
801061cc:	6a 74                	push   $0x74
  jmp alltraps
801061ce:	e9 3a f7 ff ff       	jmp    8010590d <alltraps>

801061d3 <vector117>:
.globl vector117
vector117:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $117
801061d5:	6a 75                	push   $0x75
  jmp alltraps
801061d7:	e9 31 f7 ff ff       	jmp    8010590d <alltraps>

801061dc <vector118>:
.globl vector118
vector118:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $118
801061de:	6a 76                	push   $0x76
  jmp alltraps
801061e0:	e9 28 f7 ff ff       	jmp    8010590d <alltraps>

801061e5 <vector119>:
.globl vector119
vector119:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $119
801061e7:	6a 77                	push   $0x77
  jmp alltraps
801061e9:	e9 1f f7 ff ff       	jmp    8010590d <alltraps>

801061ee <vector120>:
.globl vector120
vector120:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $120
801061f0:	6a 78                	push   $0x78
  jmp alltraps
801061f2:	e9 16 f7 ff ff       	jmp    8010590d <alltraps>

801061f7 <vector121>:
.globl vector121
vector121:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $121
801061f9:	6a 79                	push   $0x79
  jmp alltraps
801061fb:	e9 0d f7 ff ff       	jmp    8010590d <alltraps>

80106200 <vector122>:
.globl vector122
vector122:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $122
80106202:	6a 7a                	push   $0x7a
  jmp alltraps
80106204:	e9 04 f7 ff ff       	jmp    8010590d <alltraps>

80106209 <vector123>:
.globl vector123
vector123:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $123
8010620b:	6a 7b                	push   $0x7b
  jmp alltraps
8010620d:	e9 fb f6 ff ff       	jmp    8010590d <alltraps>

80106212 <vector124>:
.globl vector124
vector124:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $124
80106214:	6a 7c                	push   $0x7c
  jmp alltraps
80106216:	e9 f2 f6 ff ff       	jmp    8010590d <alltraps>

8010621b <vector125>:
.globl vector125
vector125:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $125
8010621d:	6a 7d                	push   $0x7d
  jmp alltraps
8010621f:	e9 e9 f6 ff ff       	jmp    8010590d <alltraps>

80106224 <vector126>:
.globl vector126
vector126:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $126
80106226:	6a 7e                	push   $0x7e
  jmp alltraps
80106228:	e9 e0 f6 ff ff       	jmp    8010590d <alltraps>

8010622d <vector127>:
.globl vector127
vector127:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $127
8010622f:	6a 7f                	push   $0x7f
  jmp alltraps
80106231:	e9 d7 f6 ff ff       	jmp    8010590d <alltraps>

80106236 <vector128>:
.globl vector128
vector128:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $128
80106238:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010623d:	e9 cb f6 ff ff       	jmp    8010590d <alltraps>

80106242 <vector129>:
.globl vector129
vector129:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $129
80106244:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106249:	e9 bf f6 ff ff       	jmp    8010590d <alltraps>

8010624e <vector130>:
.globl vector130
vector130:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $130
80106250:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106255:	e9 b3 f6 ff ff       	jmp    8010590d <alltraps>

8010625a <vector131>:
.globl vector131
vector131:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $131
8010625c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106261:	e9 a7 f6 ff ff       	jmp    8010590d <alltraps>

80106266 <vector132>:
.globl vector132
vector132:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $132
80106268:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010626d:	e9 9b f6 ff ff       	jmp    8010590d <alltraps>

80106272 <vector133>:
.globl vector133
vector133:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $133
80106274:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106279:	e9 8f f6 ff ff       	jmp    8010590d <alltraps>

8010627e <vector134>:
.globl vector134
vector134:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $134
80106280:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106285:	e9 83 f6 ff ff       	jmp    8010590d <alltraps>

8010628a <vector135>:
.globl vector135
vector135:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $135
8010628c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106291:	e9 77 f6 ff ff       	jmp    8010590d <alltraps>

80106296 <vector136>:
.globl vector136
vector136:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $136
80106298:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010629d:	e9 6b f6 ff ff       	jmp    8010590d <alltraps>

801062a2 <vector137>:
.globl vector137
vector137:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $137
801062a4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801062a9:	e9 5f f6 ff ff       	jmp    8010590d <alltraps>

801062ae <vector138>:
.globl vector138
vector138:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $138
801062b0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801062b5:	e9 53 f6 ff ff       	jmp    8010590d <alltraps>

801062ba <vector139>:
.globl vector139
vector139:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $139
801062bc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801062c1:	e9 47 f6 ff ff       	jmp    8010590d <alltraps>

801062c6 <vector140>:
.globl vector140
vector140:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $140
801062c8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801062cd:	e9 3b f6 ff ff       	jmp    8010590d <alltraps>

801062d2 <vector141>:
.globl vector141
vector141:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $141
801062d4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801062d9:	e9 2f f6 ff ff       	jmp    8010590d <alltraps>

801062de <vector142>:
.globl vector142
vector142:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $142
801062e0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062e5:	e9 23 f6 ff ff       	jmp    8010590d <alltraps>

801062ea <vector143>:
.globl vector143
vector143:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $143
801062ec:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062f1:	e9 17 f6 ff ff       	jmp    8010590d <alltraps>

801062f6 <vector144>:
.globl vector144
vector144:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $144
801062f8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062fd:	e9 0b f6 ff ff       	jmp    8010590d <alltraps>

80106302 <vector145>:
.globl vector145
vector145:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $145
80106304:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106309:	e9 ff f5 ff ff       	jmp    8010590d <alltraps>

8010630e <vector146>:
.globl vector146
vector146:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $146
80106310:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106315:	e9 f3 f5 ff ff       	jmp    8010590d <alltraps>

8010631a <vector147>:
.globl vector147
vector147:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $147
8010631c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106321:	e9 e7 f5 ff ff       	jmp    8010590d <alltraps>

80106326 <vector148>:
.globl vector148
vector148:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $148
80106328:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010632d:	e9 db f5 ff ff       	jmp    8010590d <alltraps>

80106332 <vector149>:
.globl vector149
vector149:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $149
80106334:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106339:	e9 cf f5 ff ff       	jmp    8010590d <alltraps>

8010633e <vector150>:
.globl vector150
vector150:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $150
80106340:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106345:	e9 c3 f5 ff ff       	jmp    8010590d <alltraps>

8010634a <vector151>:
.globl vector151
vector151:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $151
8010634c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106351:	e9 b7 f5 ff ff       	jmp    8010590d <alltraps>

80106356 <vector152>:
.globl vector152
vector152:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $152
80106358:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010635d:	e9 ab f5 ff ff       	jmp    8010590d <alltraps>

80106362 <vector153>:
.globl vector153
vector153:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $153
80106364:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106369:	e9 9f f5 ff ff       	jmp    8010590d <alltraps>

8010636e <vector154>:
.globl vector154
vector154:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $154
80106370:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106375:	e9 93 f5 ff ff       	jmp    8010590d <alltraps>

8010637a <vector155>:
.globl vector155
vector155:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $155
8010637c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106381:	e9 87 f5 ff ff       	jmp    8010590d <alltraps>

80106386 <vector156>:
.globl vector156
vector156:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $156
80106388:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010638d:	e9 7b f5 ff ff       	jmp    8010590d <alltraps>

80106392 <vector157>:
.globl vector157
vector157:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $157
80106394:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106399:	e9 6f f5 ff ff       	jmp    8010590d <alltraps>

8010639e <vector158>:
.globl vector158
vector158:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $158
801063a0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801063a5:	e9 63 f5 ff ff       	jmp    8010590d <alltraps>

801063aa <vector159>:
.globl vector159
vector159:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $159
801063ac:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801063b1:	e9 57 f5 ff ff       	jmp    8010590d <alltraps>

801063b6 <vector160>:
.globl vector160
vector160:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $160
801063b8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801063bd:	e9 4b f5 ff ff       	jmp    8010590d <alltraps>

801063c2 <vector161>:
.globl vector161
vector161:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $161
801063c4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801063c9:	e9 3f f5 ff ff       	jmp    8010590d <alltraps>

801063ce <vector162>:
.globl vector162
vector162:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $162
801063d0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801063d5:	e9 33 f5 ff ff       	jmp    8010590d <alltraps>

801063da <vector163>:
.globl vector163
vector163:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $163
801063dc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063e1:	e9 27 f5 ff ff       	jmp    8010590d <alltraps>

801063e6 <vector164>:
.globl vector164
vector164:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $164
801063e8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063ed:	e9 1b f5 ff ff       	jmp    8010590d <alltraps>

801063f2 <vector165>:
.globl vector165
vector165:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $165
801063f4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063f9:	e9 0f f5 ff ff       	jmp    8010590d <alltraps>

801063fe <vector166>:
.globl vector166
vector166:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $166
80106400:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106405:	e9 03 f5 ff ff       	jmp    8010590d <alltraps>

8010640a <vector167>:
.globl vector167
vector167:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $167
8010640c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106411:	e9 f7 f4 ff ff       	jmp    8010590d <alltraps>

80106416 <vector168>:
.globl vector168
vector168:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $168
80106418:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010641d:	e9 eb f4 ff ff       	jmp    8010590d <alltraps>

80106422 <vector169>:
.globl vector169
vector169:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $169
80106424:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106429:	e9 df f4 ff ff       	jmp    8010590d <alltraps>

8010642e <vector170>:
.globl vector170
vector170:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $170
80106430:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106435:	e9 d3 f4 ff ff       	jmp    8010590d <alltraps>

8010643a <vector171>:
.globl vector171
vector171:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $171
8010643c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106441:	e9 c7 f4 ff ff       	jmp    8010590d <alltraps>

80106446 <vector172>:
.globl vector172
vector172:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $172
80106448:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010644d:	e9 bb f4 ff ff       	jmp    8010590d <alltraps>

80106452 <vector173>:
.globl vector173
vector173:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $173
80106454:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106459:	e9 af f4 ff ff       	jmp    8010590d <alltraps>

8010645e <vector174>:
.globl vector174
vector174:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $174
80106460:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106465:	e9 a3 f4 ff ff       	jmp    8010590d <alltraps>

8010646a <vector175>:
.globl vector175
vector175:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $175
8010646c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106471:	e9 97 f4 ff ff       	jmp    8010590d <alltraps>

80106476 <vector176>:
.globl vector176
vector176:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $176
80106478:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010647d:	e9 8b f4 ff ff       	jmp    8010590d <alltraps>

80106482 <vector177>:
.globl vector177
vector177:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $177
80106484:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106489:	e9 7f f4 ff ff       	jmp    8010590d <alltraps>

8010648e <vector178>:
.globl vector178
vector178:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $178
80106490:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106495:	e9 73 f4 ff ff       	jmp    8010590d <alltraps>

8010649a <vector179>:
.globl vector179
vector179:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $179
8010649c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801064a1:	e9 67 f4 ff ff       	jmp    8010590d <alltraps>

801064a6 <vector180>:
.globl vector180
vector180:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $180
801064a8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801064ad:	e9 5b f4 ff ff       	jmp    8010590d <alltraps>

801064b2 <vector181>:
.globl vector181
vector181:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $181
801064b4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801064b9:	e9 4f f4 ff ff       	jmp    8010590d <alltraps>

801064be <vector182>:
.globl vector182
vector182:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $182
801064c0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801064c5:	e9 43 f4 ff ff       	jmp    8010590d <alltraps>

801064ca <vector183>:
.globl vector183
vector183:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $183
801064cc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801064d1:	e9 37 f4 ff ff       	jmp    8010590d <alltraps>

801064d6 <vector184>:
.globl vector184
vector184:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $184
801064d8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801064dd:	e9 2b f4 ff ff       	jmp    8010590d <alltraps>

801064e2 <vector185>:
.globl vector185
vector185:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $185
801064e4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064e9:	e9 1f f4 ff ff       	jmp    8010590d <alltraps>

801064ee <vector186>:
.globl vector186
vector186:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $186
801064f0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064f5:	e9 13 f4 ff ff       	jmp    8010590d <alltraps>

801064fa <vector187>:
.globl vector187
vector187:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $187
801064fc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106501:	e9 07 f4 ff ff       	jmp    8010590d <alltraps>

80106506 <vector188>:
.globl vector188
vector188:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $188
80106508:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010650d:	e9 fb f3 ff ff       	jmp    8010590d <alltraps>

80106512 <vector189>:
.globl vector189
vector189:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $189
80106514:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106519:	e9 ef f3 ff ff       	jmp    8010590d <alltraps>

8010651e <vector190>:
.globl vector190
vector190:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $190
80106520:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106525:	e9 e3 f3 ff ff       	jmp    8010590d <alltraps>

8010652a <vector191>:
.globl vector191
vector191:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $191
8010652c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106531:	e9 d7 f3 ff ff       	jmp    8010590d <alltraps>

80106536 <vector192>:
.globl vector192
vector192:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $192
80106538:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010653d:	e9 cb f3 ff ff       	jmp    8010590d <alltraps>

80106542 <vector193>:
.globl vector193
vector193:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $193
80106544:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106549:	e9 bf f3 ff ff       	jmp    8010590d <alltraps>

8010654e <vector194>:
.globl vector194
vector194:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $194
80106550:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106555:	e9 b3 f3 ff ff       	jmp    8010590d <alltraps>

8010655a <vector195>:
.globl vector195
vector195:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $195
8010655c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106561:	e9 a7 f3 ff ff       	jmp    8010590d <alltraps>

80106566 <vector196>:
.globl vector196
vector196:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $196
80106568:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010656d:	e9 9b f3 ff ff       	jmp    8010590d <alltraps>

80106572 <vector197>:
.globl vector197
vector197:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $197
80106574:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106579:	e9 8f f3 ff ff       	jmp    8010590d <alltraps>

8010657e <vector198>:
.globl vector198
vector198:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $198
80106580:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106585:	e9 83 f3 ff ff       	jmp    8010590d <alltraps>

8010658a <vector199>:
.globl vector199
vector199:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $199
8010658c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106591:	e9 77 f3 ff ff       	jmp    8010590d <alltraps>

80106596 <vector200>:
.globl vector200
vector200:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $200
80106598:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010659d:	e9 6b f3 ff ff       	jmp    8010590d <alltraps>

801065a2 <vector201>:
.globl vector201
vector201:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $201
801065a4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801065a9:	e9 5f f3 ff ff       	jmp    8010590d <alltraps>

801065ae <vector202>:
.globl vector202
vector202:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $202
801065b0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801065b5:	e9 53 f3 ff ff       	jmp    8010590d <alltraps>

801065ba <vector203>:
.globl vector203
vector203:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $203
801065bc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801065c1:	e9 47 f3 ff ff       	jmp    8010590d <alltraps>

801065c6 <vector204>:
.globl vector204
vector204:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $204
801065c8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801065cd:	e9 3b f3 ff ff       	jmp    8010590d <alltraps>

801065d2 <vector205>:
.globl vector205
vector205:
  pushl $0
801065d2:	6a 00                	push   $0x0
  pushl $205
801065d4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801065d9:	e9 2f f3 ff ff       	jmp    8010590d <alltraps>

801065de <vector206>:
.globl vector206
vector206:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $206
801065e0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065e5:	e9 23 f3 ff ff       	jmp    8010590d <alltraps>

801065ea <vector207>:
.globl vector207
vector207:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $207
801065ec:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065f1:	e9 17 f3 ff ff       	jmp    8010590d <alltraps>

801065f6 <vector208>:
.globl vector208
vector208:
  pushl $0
801065f6:	6a 00                	push   $0x0
  pushl $208
801065f8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065fd:	e9 0b f3 ff ff       	jmp    8010590d <alltraps>

80106602 <vector209>:
.globl vector209
vector209:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $209
80106604:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106609:	e9 ff f2 ff ff       	jmp    8010590d <alltraps>

8010660e <vector210>:
.globl vector210
vector210:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $210
80106610:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106615:	e9 f3 f2 ff ff       	jmp    8010590d <alltraps>

8010661a <vector211>:
.globl vector211
vector211:
  pushl $0
8010661a:	6a 00                	push   $0x0
  pushl $211
8010661c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106621:	e9 e7 f2 ff ff       	jmp    8010590d <alltraps>

80106626 <vector212>:
.globl vector212
vector212:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $212
80106628:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010662d:	e9 db f2 ff ff       	jmp    8010590d <alltraps>

80106632 <vector213>:
.globl vector213
vector213:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $213
80106634:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106639:	e9 cf f2 ff ff       	jmp    8010590d <alltraps>

8010663e <vector214>:
.globl vector214
vector214:
  pushl $0
8010663e:	6a 00                	push   $0x0
  pushl $214
80106640:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106645:	e9 c3 f2 ff ff       	jmp    8010590d <alltraps>

8010664a <vector215>:
.globl vector215
vector215:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $215
8010664c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106651:	e9 b7 f2 ff ff       	jmp    8010590d <alltraps>

80106656 <vector216>:
.globl vector216
vector216:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $216
80106658:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010665d:	e9 ab f2 ff ff       	jmp    8010590d <alltraps>

80106662 <vector217>:
.globl vector217
vector217:
  pushl $0
80106662:	6a 00                	push   $0x0
  pushl $217
80106664:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106669:	e9 9f f2 ff ff       	jmp    8010590d <alltraps>

8010666e <vector218>:
.globl vector218
vector218:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $218
80106670:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106675:	e9 93 f2 ff ff       	jmp    8010590d <alltraps>

8010667a <vector219>:
.globl vector219
vector219:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $219
8010667c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106681:	e9 87 f2 ff ff       	jmp    8010590d <alltraps>

80106686 <vector220>:
.globl vector220
vector220:
  pushl $0
80106686:	6a 00                	push   $0x0
  pushl $220
80106688:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010668d:	e9 7b f2 ff ff       	jmp    8010590d <alltraps>

80106692 <vector221>:
.globl vector221
vector221:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $221
80106694:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106699:	e9 6f f2 ff ff       	jmp    8010590d <alltraps>

8010669e <vector222>:
.globl vector222
vector222:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $222
801066a0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801066a5:	e9 63 f2 ff ff       	jmp    8010590d <alltraps>

801066aa <vector223>:
.globl vector223
vector223:
  pushl $0
801066aa:	6a 00                	push   $0x0
  pushl $223
801066ac:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801066b1:	e9 57 f2 ff ff       	jmp    8010590d <alltraps>

801066b6 <vector224>:
.globl vector224
vector224:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $224
801066b8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801066bd:	e9 4b f2 ff ff       	jmp    8010590d <alltraps>

801066c2 <vector225>:
.globl vector225
vector225:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $225
801066c4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801066c9:	e9 3f f2 ff ff       	jmp    8010590d <alltraps>

801066ce <vector226>:
.globl vector226
vector226:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $226
801066d0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801066d5:	e9 33 f2 ff ff       	jmp    8010590d <alltraps>

801066da <vector227>:
.globl vector227
vector227:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $227
801066dc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066e1:	e9 27 f2 ff ff       	jmp    8010590d <alltraps>

801066e6 <vector228>:
.globl vector228
vector228:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $228
801066e8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066ed:	e9 1b f2 ff ff       	jmp    8010590d <alltraps>

801066f2 <vector229>:
.globl vector229
vector229:
  pushl $0
801066f2:	6a 00                	push   $0x0
  pushl $229
801066f4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066f9:	e9 0f f2 ff ff       	jmp    8010590d <alltraps>

801066fe <vector230>:
.globl vector230
vector230:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $230
80106700:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106705:	e9 03 f2 ff ff       	jmp    8010590d <alltraps>

8010670a <vector231>:
.globl vector231
vector231:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $231
8010670c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106711:	e9 f7 f1 ff ff       	jmp    8010590d <alltraps>

80106716 <vector232>:
.globl vector232
vector232:
  pushl $0
80106716:	6a 00                	push   $0x0
  pushl $232
80106718:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010671d:	e9 eb f1 ff ff       	jmp    8010590d <alltraps>

80106722 <vector233>:
.globl vector233
vector233:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $233
80106724:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106729:	e9 df f1 ff ff       	jmp    8010590d <alltraps>

8010672e <vector234>:
.globl vector234
vector234:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $234
80106730:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106735:	e9 d3 f1 ff ff       	jmp    8010590d <alltraps>

8010673a <vector235>:
.globl vector235
vector235:
  pushl $0
8010673a:	6a 00                	push   $0x0
  pushl $235
8010673c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106741:	e9 c7 f1 ff ff       	jmp    8010590d <alltraps>

80106746 <vector236>:
.globl vector236
vector236:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $236
80106748:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010674d:	e9 bb f1 ff ff       	jmp    8010590d <alltraps>

80106752 <vector237>:
.globl vector237
vector237:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $237
80106754:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106759:	e9 af f1 ff ff       	jmp    8010590d <alltraps>

8010675e <vector238>:
.globl vector238
vector238:
  pushl $0
8010675e:	6a 00                	push   $0x0
  pushl $238
80106760:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106765:	e9 a3 f1 ff ff       	jmp    8010590d <alltraps>

8010676a <vector239>:
.globl vector239
vector239:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $239
8010676c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106771:	e9 97 f1 ff ff       	jmp    8010590d <alltraps>

80106776 <vector240>:
.globl vector240
vector240:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $240
80106778:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010677d:	e9 8b f1 ff ff       	jmp    8010590d <alltraps>

80106782 <vector241>:
.globl vector241
vector241:
  pushl $0
80106782:	6a 00                	push   $0x0
  pushl $241
80106784:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106789:	e9 7f f1 ff ff       	jmp    8010590d <alltraps>

8010678e <vector242>:
.globl vector242
vector242:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $242
80106790:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106795:	e9 73 f1 ff ff       	jmp    8010590d <alltraps>

8010679a <vector243>:
.globl vector243
vector243:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $243
8010679c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801067a1:	e9 67 f1 ff ff       	jmp    8010590d <alltraps>

801067a6 <vector244>:
.globl vector244
vector244:
  pushl $0
801067a6:	6a 00                	push   $0x0
  pushl $244
801067a8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801067ad:	e9 5b f1 ff ff       	jmp    8010590d <alltraps>

801067b2 <vector245>:
.globl vector245
vector245:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $245
801067b4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801067b9:	e9 4f f1 ff ff       	jmp    8010590d <alltraps>

801067be <vector246>:
.globl vector246
vector246:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $246
801067c0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801067c5:	e9 43 f1 ff ff       	jmp    8010590d <alltraps>

801067ca <vector247>:
.globl vector247
vector247:
  pushl $0
801067ca:	6a 00                	push   $0x0
  pushl $247
801067cc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801067d1:	e9 37 f1 ff ff       	jmp    8010590d <alltraps>

801067d6 <vector248>:
.globl vector248
vector248:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $248
801067d8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801067dd:	e9 2b f1 ff ff       	jmp    8010590d <alltraps>

801067e2 <vector249>:
.globl vector249
vector249:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $249
801067e4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067e9:	e9 1f f1 ff ff       	jmp    8010590d <alltraps>

801067ee <vector250>:
.globl vector250
vector250:
  pushl $0
801067ee:	6a 00                	push   $0x0
  pushl $250
801067f0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067f5:	e9 13 f1 ff ff       	jmp    8010590d <alltraps>

801067fa <vector251>:
.globl vector251
vector251:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $251
801067fc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106801:	e9 07 f1 ff ff       	jmp    8010590d <alltraps>

80106806 <vector252>:
.globl vector252
vector252:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $252
80106808:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010680d:	e9 fb f0 ff ff       	jmp    8010590d <alltraps>

80106812 <vector253>:
.globl vector253
vector253:
  pushl $0
80106812:	6a 00                	push   $0x0
  pushl $253
80106814:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106819:	e9 ef f0 ff ff       	jmp    8010590d <alltraps>

8010681e <vector254>:
.globl vector254
vector254:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $254
80106820:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106825:	e9 e3 f0 ff ff       	jmp    8010590d <alltraps>

8010682a <vector255>:
.globl vector255
vector255:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $255
8010682c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106831:	e9 d7 f0 ff ff       	jmp    8010590d <alltraps>
80106836:	66 90                	xchg   %ax,%ax
80106838:	66 90                	xchg   %ax,%ax
8010683a:	66 90                	xchg   %ax,%ax
8010683c:	66 90                	xchg   %ax,%ax
8010683e:	66 90                	xchg   %ax,%ax

80106840 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	57                   	push   %edi
80106844:	56                   	push   %esi
80106845:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106847:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010684a:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010684b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010684e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106851:	8b 1f                	mov    (%edi),%ebx
80106853:	f6 c3 01             	test   $0x1,%bl
80106856:	74 28                	je     80106880 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106858:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010685e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106864:	c1 ee 0a             	shr    $0xa,%esi
}
80106867:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010686a:	89 f2                	mov    %esi,%edx
8010686c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106872:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106875:	5b                   	pop    %ebx
80106876:	5e                   	pop    %esi
80106877:	5f                   	pop    %edi
80106878:	5d                   	pop    %ebp
80106879:	c3                   	ret    
8010687a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106880:	85 c9                	test   %ecx,%ecx
80106882:	74 34                	je     801068b8 <walkpgdir+0x78>
80106884:	e8 07 bc ff ff       	call   80102490 <kalloc>
80106889:	85 c0                	test   %eax,%eax
8010688b:	89 c3                	mov    %eax,%ebx
8010688d:	74 29                	je     801068b8 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010688f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106896:	00 
80106897:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010689e:	00 
8010689f:	89 04 24             	mov    %eax,(%esp)
801068a2:	e8 a9 de ff ff       	call   80104750 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801068a7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801068ad:	83 c8 07             	or     $0x7,%eax
801068b0:	89 07                	mov    %eax,(%edi)
801068b2:	eb b0                	jmp    80106864 <walkpgdir+0x24>
801068b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
801068b8:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801068bb:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801068bd:	5b                   	pop    %ebx
801068be:	5e                   	pop    %esi
801068bf:	5f                   	pop    %edi
801068c0:	5d                   	pop    %ebp
801068c1:	c3                   	ret    
801068c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	57                   	push   %edi
801068d4:	56                   	push   %esi
801068d5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801068d6:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801068d8:	83 ec 1c             	sub    $0x1c,%esp
801068db:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801068de:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801068e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068e7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801068eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801068ee:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068f2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801068f9:	29 df                	sub    %ebx,%edi
801068fb:	eb 18                	jmp    80106915 <mappages+0x45>
801068fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106900:	f6 00 01             	testb  $0x1,(%eax)
80106903:	75 3d                	jne    80106942 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106905:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106908:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010690b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010690d:	74 29                	je     80106938 <mappages+0x68>
      break;
    a += PGSIZE;
8010690f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106915:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106918:	b9 01 00 00 00       	mov    $0x1,%ecx
8010691d:	89 da                	mov    %ebx,%edx
8010691f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106922:	e8 19 ff ff ff       	call   80106840 <walkpgdir>
80106927:	85 c0                	test   %eax,%eax
80106929:	75 d5                	jne    80106900 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010692b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010692e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106933:	5b                   	pop    %ebx
80106934:	5e                   	pop    %esi
80106935:	5f                   	pop    %edi
80106936:	5d                   	pop    %ebp
80106937:	c3                   	ret    
80106938:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010693b:	31 c0                	xor    %eax,%eax
}
8010693d:	5b                   	pop    %ebx
8010693e:	5e                   	pop    %esi
8010693f:	5f                   	pop    %edi
80106940:	5d                   	pop    %ebp
80106941:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106942:	c7 04 24 d0 7a 10 80 	movl   $0x80107ad0,(%esp)
80106949:	e8 12 9a ff ff       	call   80100360 <panic>
8010694e:	66 90                	xchg   %ax,%ax

80106950 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	57                   	push   %edi
80106954:	89 c7                	mov    %eax,%edi
80106956:	56                   	push   %esi
80106957:	89 d6                	mov    %edx,%esi
80106959:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010695a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106960:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106963:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106969:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010696b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010696e:	72 3b                	jb     801069ab <deallocuvm.part.0+0x5b>
80106970:	eb 5e                	jmp    801069d0 <deallocuvm.part.0+0x80>
80106972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
80106978:	8b 10                	mov    (%eax),%edx
8010697a:	f6 c2 01             	test   $0x1,%dl
8010697d:	74 22                	je     801069a1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010697f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106985:	74 54                	je     801069db <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106987:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010698d:	89 14 24             	mov    %edx,(%esp)
80106990:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106993:	e8 48 b9 ff ff       	call   801022e0 <kfree>
      *pte = 0;
80106998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010699b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801069a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069a7:	39 f3                	cmp    %esi,%ebx
801069a9:	73 25                	jae    801069d0 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
801069ab:	31 c9                	xor    %ecx,%ecx
801069ad:	89 da                	mov    %ebx,%edx
801069af:	89 f8                	mov    %edi,%eax
801069b1:	e8 8a fe ff ff       	call   80106840 <walkpgdir>
    if(!pte)
801069b6:	85 c0                	test   %eax,%eax
801069b8:	75 be                	jne    80106978 <deallocuvm.part.0+0x28>
      a += (NPTENTRIES - 1) * PGSIZE;
801069ba:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801069c0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069c6:	39 f3                	cmp    %esi,%ebx
801069c8:	72 e1                	jb     801069ab <deallocuvm.part.0+0x5b>
801069ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801069d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801069d3:	83 c4 1c             	add    $0x1c,%esp
801069d6:	5b                   	pop    %ebx
801069d7:	5e                   	pop    %esi
801069d8:	5f                   	pop    %edi
801069d9:	5d                   	pop    %ebp
801069da:	c3                   	ret    
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801069db:	c7 04 24 b2 73 10 80 	movl   $0x801073b2,(%esp)
801069e2:	e8 79 99 ff ff       	call   80100360 <panic>
801069e7:	89 f6                	mov    %esi,%esi
801069e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069f0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801069f6:	e8 75 bd ff ff       	call   80102770 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069fb:	31 c9                	xor    %ecx,%ecx
801069fd:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106a02:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106a08:	05 a0 27 11 80       	add    $0x801127a0,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a0d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a11:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a16:	66 89 48 7a          	mov    %cx,0x7a(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a1a:	31 c9                	xor    %ecx,%ecx
80106a1c:	66 89 90 80 00 00 00 	mov    %dx,0x80(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a23:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a28:	66 89 88 82 00 00 00 	mov    %cx,0x82(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a2f:	31 c9                	xor    %ecx,%ecx
80106a31:	66 89 90 90 00 00 00 	mov    %dx,0x90(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a38:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a3d:	66 89 88 92 00 00 00 	mov    %cx,0x92(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a44:	31 c9                	xor    %ecx,%ecx
80106a46:	66 89 90 98 00 00 00 	mov    %dx,0x98(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106a4d:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a53:	66 89 88 9a 00 00 00 	mov    %cx,0x9a(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106a5a:	31 c9                	xor    %ecx,%ecx
80106a5c:	66 89 88 88 00 00 00 	mov    %cx,0x88(%eax)
80106a63:	89 d1                	mov    %edx,%ecx
80106a65:	c1 e9 10             	shr    $0x10,%ecx
80106a68:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
80106a6f:	c1 ea 18             	shr    $0x18,%edx
80106a72:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106a78:	b9 37 00 00 00       	mov    $0x37,%ecx
80106a7d:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80106a83:	8d 50 70             	lea    0x70(%eax),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a86:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
80106a8a:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a8e:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
80106a95:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a9c:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
80106aa3:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106aaa:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
80106ab1:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106ab8:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
80106abf:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
80106ac6:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
80106aca:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ace:	c1 ea 10             	shr    $0x10,%edx
80106ad1:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106ad5:	8d 55 f2             	lea    -0xe(%ebp),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ad8:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80106adc:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ae0:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80106ae7:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106aee:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80106af5:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106afc:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80106b03:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
80106b0a:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80106b0d:	ba 18 00 00 00       	mov    $0x18,%edx
80106b12:	8e ea                	mov    %edx,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
80106b14:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106b1b:	00 00 00 00 

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
80106b1f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
}
80106b25:	c9                   	leave  
80106b26:	c3                   	ret    
80106b27:	89 f6                	mov    %esi,%esi
80106b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b30 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	56                   	push   %esi
80106b34:	53                   	push   %ebx
80106b35:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106b38:	e8 53 b9 ff ff       	call   80102490 <kalloc>
80106b3d:	85 c0                	test   %eax,%eax
80106b3f:	89 c6                	mov    %eax,%esi
80106b41:	74 55                	je     80106b98 <setupkvm+0x68>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106b43:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b4a:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b4b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106b50:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b57:	00 
80106b58:	89 04 24             	mov    %eax,(%esp)
80106b5b:	e8 f0 db ff ff       	call   80104750 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106b60:	8b 53 0c             	mov    0xc(%ebx),%edx
80106b63:	8b 43 04             	mov    0x4(%ebx),%eax
80106b66:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106b69:	89 54 24 04          	mov    %edx,0x4(%esp)
80106b6d:	8b 13                	mov    (%ebx),%edx
80106b6f:	89 04 24             	mov    %eax,(%esp)
80106b72:	29 c1                	sub    %eax,%ecx
80106b74:	89 f0                	mov    %esi,%eax
80106b76:	e8 55 fd ff ff       	call   801068d0 <mappages>
80106b7b:	85 c0                	test   %eax,%eax
80106b7d:	78 19                	js     80106b98 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b7f:	83 c3 10             	add    $0x10,%ebx
80106b82:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106b88:	72 d6                	jb     80106b60 <setupkvm+0x30>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106b8a:	83 c4 10             	add    $0x10,%esp
80106b8d:	89 f0                	mov    %esi,%eax
80106b8f:	5b                   	pop    %ebx
80106b90:	5e                   	pop    %esi
80106b91:	5d                   	pop    %ebp
80106b92:	c3                   	ret    
80106b93:	90                   	nop
80106b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b98:	83 c4 10             	add    $0x10,%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106b9b:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106b9d:	5b                   	pop    %ebx
80106b9e:	5e                   	pop    %esi
80106b9f:	5d                   	pop    %ebp
80106ba0:	c3                   	ret    
80106ba1:	eb 0d                	jmp    80106bb0 <kvmalloc>
80106ba3:	90                   	nop
80106ba4:	90                   	nop
80106ba5:	90                   	nop
80106ba6:	90                   	nop
80106ba7:	90                   	nop
80106ba8:	90                   	nop
80106ba9:	90                   	nop
80106baa:	90                   	nop
80106bab:	90                   	nop
80106bac:	90                   	nop
80106bad:	90                   	nop
80106bae:	90                   	nop
80106baf:	90                   	nop

80106bb0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106bb6:	e8 75 ff ff ff       	call   80106b30 <setupkvm>
80106bbb:	a3 24 65 11 80       	mov    %eax,0x80116524
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bc0:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bc5:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106bc8:	c9                   	leave  
80106bc9:	c3                   	ret    
80106bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106bd0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bd0:	a1 24 65 11 80       	mov    0x80116524,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106bd5:	55                   	push   %ebp
80106bd6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bd8:	05 00 00 00 80       	add    $0x80000000,%eax
80106bdd:	0f 22 d8             	mov    %eax,%cr3
}
80106be0:	5d                   	pop    %ebp
80106be1:	c3                   	ret    
80106be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bf0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	53                   	push   %ebx
80106bf4:	83 ec 14             	sub    $0x14,%esp
80106bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106bfa:	e8 81 da ff ff       	call   80104680 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106bff:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106c05:	b9 67 00 00 00       	mov    $0x67,%ecx
80106c0a:	8d 50 08             	lea    0x8(%eax),%edx
80106c0d:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106c14:	89 d1                	mov    %edx,%ecx
80106c16:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106c1d:	c1 ea 18             	shr    $0x18,%edx
80106c20:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106c26:	ba 10 00 00 00       	mov    $0x10,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106c2b:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
80106c32:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
80106c35:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80106c3c:	66 89 50 10          	mov    %dx,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106c40:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106c47:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106c4d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106c52:	8b 52 08             	mov    0x8(%edx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106c55:	66 89 48 6e          	mov    %cx,0x6e(%eax)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106c59:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106c5f:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106c62:	b8 30 00 00 00       	mov    $0x30,%eax
80106c67:	0f 00 d8             	ltr    %ax
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
80106c6a:	8b 43 04             	mov    0x4(%ebx),%eax
80106c6d:	85 c0                	test   %eax,%eax
80106c6f:	74 12                	je     80106c83 <switchuvm+0x93>
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106c71:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c76:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106c79:	83 c4 14             	add    $0x14,%esp
80106c7c:	5b                   	pop    %ebx
80106c7d:	5d                   	pop    %ebp
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106c7e:	e9 2d da ff ff       	jmp    801046b0 <popcli>
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106c83:	c7 04 24 d6 7a 10 80 	movl   $0x80107ad6,(%esp)
80106c8a:	e8 d1 96 ff ff       	call   80100360 <panic>
80106c8f:	90                   	nop

80106c90 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
80106c96:	83 ec 1c             	sub    $0x1c,%esp
80106c99:	8b 75 10             	mov    0x10(%ebp),%esi
80106c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c9f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106ca2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ca8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106cab:	77 54                	ja     80106d01 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
80106cad:	e8 de b7 ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
80106cb2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106cb9:	00 
80106cba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106cc1:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106cc2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106cc4:	89 04 24             	mov    %eax,(%esp)
80106cc7:	e8 84 da ff ff       	call   80104750 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ccc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cd2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106cd7:	89 04 24             	mov    %eax,(%esp)
80106cda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cdd:	31 d2                	xor    %edx,%edx
80106cdf:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106ce6:	00 
80106ce7:	e8 e4 fb ff ff       	call   801068d0 <mappages>
  memmove(mem, init, sz);
80106cec:	89 75 10             	mov    %esi,0x10(%ebp)
80106cef:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106cf2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106cf5:	83 c4 1c             	add    $0x1c,%esp
80106cf8:	5b                   	pop    %ebx
80106cf9:	5e                   	pop    %esi
80106cfa:	5f                   	pop    %edi
80106cfb:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106cfc:	e9 ef da ff ff       	jmp    801047f0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106d01:	c7 04 24 ea 7a 10 80 	movl   $0x80107aea,(%esp)
80106d08:	e8 53 96 ff ff       	call   80100360 <panic>
80106d0d:	8d 76 00             	lea    0x0(%esi),%esi

80106d10 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106d19:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106d20:	0f 85 98 00 00 00    	jne    80106dbe <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106d26:	8b 75 18             	mov    0x18(%ebp),%esi
80106d29:	31 db                	xor    %ebx,%ebx
80106d2b:	85 f6                	test   %esi,%esi
80106d2d:	75 1a                	jne    80106d49 <loaduvm+0x39>
80106d2f:	eb 77                	jmp    80106da8 <loaduvm+0x98>
80106d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d38:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d3e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106d44:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106d47:	76 5f                	jbe    80106da8 <loaduvm+0x98>
80106d49:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d4c:	31 c9                	xor    %ecx,%ecx
80106d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80106d51:	01 da                	add    %ebx,%edx
80106d53:	e8 e8 fa ff ff       	call   80106840 <walkpgdir>
80106d58:	85 c0                	test   %eax,%eax
80106d5a:	74 56                	je     80106db2 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106d5c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106d5e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106d63:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106d66:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106d6b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106d71:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d74:	05 00 00 00 80       	add    $0x80000000,%eax
80106d79:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d7d:	8b 45 10             	mov    0x10(%ebp),%eax
80106d80:	01 d9                	add    %ebx,%ecx
80106d82:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106d86:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106d8a:	89 04 24             	mov    %eax,(%esp)
80106d8d:	e8 ae ab ff ff       	call   80101940 <readi>
80106d92:	39 f8                	cmp    %edi,%eax
80106d94:	74 a2                	je     80106d38 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106d96:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106d99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106d9e:	5b                   	pop    %ebx
80106d9f:	5e                   	pop    %esi
80106da0:	5f                   	pop    %edi
80106da1:	5d                   	pop    %ebp
80106da2:	c3                   	ret    
80106da3:	90                   	nop
80106da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106da8:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106dab:	31 c0                	xor    %eax,%eax
}
80106dad:	5b                   	pop    %ebx
80106dae:	5e                   	pop    %esi
80106daf:	5f                   	pop    %edi
80106db0:	5d                   	pop    %ebp
80106db1:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106db2:	c7 04 24 04 7b 10 80 	movl   $0x80107b04,(%esp)
80106db9:	e8 a2 95 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106dbe:	c7 04 24 a8 7b 10 80 	movl   $0x80107ba8,(%esp)
80106dc5:	e8 96 95 ff ff       	call   80100360 <panic>
80106dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106dd0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
80106dd9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106ddc:	85 ff                	test   %edi,%edi
80106dde:	0f 88 7e 00 00 00    	js     80106e62 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
80106de4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106dea:	72 78                	jb     80106e64 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106dec:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106df2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106df8:	39 df                	cmp    %ebx,%edi
80106dfa:	77 4a                	ja     80106e46 <allocuvm+0x76>
80106dfc:	eb 72                	jmp    80106e70 <allocuvm+0xa0>
80106dfe:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106e00:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106e07:	00 
80106e08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e0f:	00 
80106e10:	89 04 24             	mov    %eax,(%esp)
80106e13:	e8 38 d9 ff ff       	call   80104750 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e18:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e1e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e23:	89 04 24             	mov    %eax,(%esp)
80106e26:	8b 45 08             	mov    0x8(%ebp),%eax
80106e29:	89 da                	mov    %ebx,%edx
80106e2b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106e32:	00 
80106e33:	e8 98 fa ff ff       	call   801068d0 <mappages>
80106e38:	85 c0                	test   %eax,%eax
80106e3a:	78 44                	js     80106e80 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106e3c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e42:	39 df                	cmp    %ebx,%edi
80106e44:	76 2a                	jbe    80106e70 <allocuvm+0xa0>
    mem = kalloc();
80106e46:	e8 45 b6 ff ff       	call   80102490 <kalloc>
    if(mem == 0){
80106e4b:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106e4d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106e4f:	75 af                	jne    80106e00 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106e51:	c7 04 24 22 7b 10 80 	movl   $0x80107b22,(%esp)
80106e58:	e8 f3 97 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106e5d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106e60:	77 48                	ja     80106eaa <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106e62:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106e64:	83 c4 1c             	add    $0x1c,%esp
80106e67:	5b                   	pop    %ebx
80106e68:	5e                   	pop    %esi
80106e69:	5f                   	pop    %edi
80106e6a:	5d                   	pop    %ebp
80106e6b:	c3                   	ret    
80106e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e70:	83 c4 1c             	add    $0x1c,%esp
80106e73:	89 f8                	mov    %edi,%eax
80106e75:	5b                   	pop    %ebx
80106e76:	5e                   	pop    %esi
80106e77:	5f                   	pop    %edi
80106e78:	5d                   	pop    %ebp
80106e79:	c3                   	ret    
80106e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106e80:	c7 04 24 3a 7b 10 80 	movl   $0x80107b3a,(%esp)
80106e87:	e8 c4 97 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106e8c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106e8f:	76 0d                	jbe    80106e9e <allocuvm+0xce>
80106e91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e94:	89 fa                	mov    %edi,%edx
80106e96:	8b 45 08             	mov    0x8(%ebp),%eax
80106e99:	e8 b2 fa ff ff       	call   80106950 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106e9e:	89 34 24             	mov    %esi,(%esp)
80106ea1:	e8 3a b4 ff ff       	call   801022e0 <kfree>
      return 0;
80106ea6:	31 c0                	xor    %eax,%eax
80106ea8:	eb ba                	jmp    80106e64 <allocuvm+0x94>
80106eaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ead:	89 fa                	mov    %edi,%edx
80106eaf:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb2:	e8 99 fa ff ff       	call   80106950 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106eb7:	31 c0                	xor    %eax,%eax
80106eb9:	eb a9                	jmp    80106e64 <allocuvm+0x94>
80106ebb:	90                   	nop
80106ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ec0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ec6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106ecc:	39 d1                	cmp    %edx,%ecx
80106ece:	73 08                	jae    80106ed8 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ed0:	5d                   	pop    %ebp
80106ed1:	e9 7a fa ff ff       	jmp    80106950 <deallocuvm.part.0>
80106ed6:	66 90                	xchg   %ax,%ax
80106ed8:	89 d0                	mov    %edx,%eax
80106eda:	5d                   	pop    %ebp
80106edb:	c3                   	ret    
80106edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ee0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	56                   	push   %esi
80106ee4:	53                   	push   %ebx
80106ee5:	83 ec 10             	sub    $0x10,%esp
80106ee8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106eeb:	85 f6                	test   %esi,%esi
80106eed:	74 59                	je     80106f48 <freevm+0x68>
80106eef:	31 c9                	xor    %ecx,%ecx
80106ef1:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ef6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ef8:	31 db                	xor    %ebx,%ebx
80106efa:	e8 51 fa ff ff       	call   80106950 <deallocuvm.part.0>
80106eff:	eb 12                	jmp    80106f13 <freevm+0x33>
80106f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f08:	83 c3 01             	add    $0x1,%ebx
80106f0b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106f11:	74 27                	je     80106f3a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106f13:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106f16:	f6 c2 01             	test   $0x1,%dl
80106f19:	74 ed                	je     80106f08 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f1b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f21:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f24:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106f2a:	89 14 24             	mov    %edx,(%esp)
80106f2d:	e8 ae b3 ff ff       	call   801022e0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f32:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106f38:	75 d9                	jne    80106f13 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106f3a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f3d:	83 c4 10             	add    $0x10,%esp
80106f40:	5b                   	pop    %ebx
80106f41:	5e                   	pop    %esi
80106f42:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106f43:	e9 98 b3 ff ff       	jmp    801022e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106f48:	c7 04 24 56 7b 10 80 	movl   $0x80107b56,(%esp)
80106f4f:	e8 0c 94 ff ff       	call   80100360 <panic>
80106f54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f61:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f63:	89 e5                	mov    %esp,%ebp
80106f65:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f6e:	e8 cd f8 ff ff       	call   80106840 <walkpgdir>
  if(pte == 0)
80106f73:	85 c0                	test   %eax,%eax
80106f75:	74 05                	je     80106f7c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106f77:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106f7a:	c9                   	leave  
80106f7b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106f7c:	c7 04 24 67 7b 10 80 	movl   $0x80107b67,(%esp)
80106f83:	e8 d8 93 ff ff       	call   80100360 <panic>
80106f88:	90                   	nop
80106f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f90 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f99:	e8 92 fb ff ff       	call   80106b30 <setupkvm>
80106f9e:	85 c0                	test   %eax,%eax
80106fa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106fa3:	0f 84 b2 00 00 00    	je     8010705b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fac:	85 c0                	test   %eax,%eax
80106fae:	0f 84 9c 00 00 00    	je     80107050 <copyuvm+0xc0>
80106fb4:	31 db                	xor    %ebx,%ebx
80106fb6:	eb 48                	jmp    80107000 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106fb8:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106fbe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106fc5:	00 
80106fc6:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106fca:	89 04 24             	mov    %eax,(%esp)
80106fcd:	e8 1e d8 ff ff       	call   801047f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fd5:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106fdb:	89 14 24             	mov    %edx,(%esp)
80106fde:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fe3:	89 da                	mov    %ebx,%edx
80106fe5:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fe9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fec:	e8 df f8 ff ff       	call   801068d0 <mappages>
80106ff1:	85 c0                	test   %eax,%eax
80106ff3:	78 41                	js     80107036 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ff5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ffb:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106ffe:	76 50                	jbe    80107050 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107000:	8b 45 08             	mov    0x8(%ebp),%eax
80107003:	31 c9                	xor    %ecx,%ecx
80107005:	89 da                	mov    %ebx,%edx
80107007:	e8 34 f8 ff ff       	call   80106840 <walkpgdir>
8010700c:	85 c0                	test   %eax,%eax
8010700e:	74 5b                	je     8010706b <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107010:	8b 30                	mov    (%eax),%esi
80107012:	f7 c6 01 00 00 00    	test   $0x1,%esi
80107018:	74 45                	je     8010705f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010701a:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
8010701c:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107022:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107025:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
8010702b:	e8 60 b4 ff ff       	call   80102490 <kalloc>
80107030:	85 c0                	test   %eax,%eax
80107032:	89 c6                	mov    %eax,%esi
80107034:	75 82                	jne    80106fb8 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107036:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107039:	89 04 24             	mov    %eax,(%esp)
8010703c:	e8 9f fe ff ff       	call   80106ee0 <freevm>
  return 0;
80107041:	31 c0                	xor    %eax,%eax
}
80107043:	83 c4 2c             	add    $0x2c,%esp
80107046:	5b                   	pop    %ebx
80107047:	5e                   	pop    %esi
80107048:	5f                   	pop    %edi
80107049:	5d                   	pop    %ebp
8010704a:	c3                   	ret    
8010704b:	90                   	nop
8010704c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107050:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107053:	83 c4 2c             	add    $0x2c,%esp
80107056:	5b                   	pop    %ebx
80107057:	5e                   	pop    %esi
80107058:	5f                   	pop    %edi
80107059:	5d                   	pop    %ebp
8010705a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010705b:	31 c0                	xor    %eax,%eax
8010705d:	eb e4                	jmp    80107043 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
8010705f:	c7 04 24 8b 7b 10 80 	movl   $0x80107b8b,(%esp)
80107066:	e8 f5 92 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010706b:	c7 04 24 71 7b 10 80 	movl   $0x80107b71,(%esp)
80107072:	e8 e9 92 ff ff       	call   80100360 <panic>
80107077:	89 f6                	mov    %esi,%esi
80107079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107080 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107080:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107081:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107083:	89 e5                	mov    %esp,%ebp
80107085:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107088:	8b 55 0c             	mov    0xc(%ebp),%edx
8010708b:	8b 45 08             	mov    0x8(%ebp),%eax
8010708e:	e8 ad f7 ff ff       	call   80106840 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107093:	8b 00                	mov    (%eax),%eax
80107095:	89 c2                	mov    %eax,%edx
80107097:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
8010709a:	83 fa 05             	cmp    $0x5,%edx
8010709d:	75 11                	jne    801070b0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010709f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070a4:	05 00 00 00 80       	add    $0x80000000,%eax
}
801070a9:	c9                   	leave  
801070aa:	c3                   	ret    
801070ab:	90                   	nop
801070ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801070b0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801070b2:	c9                   	leave  
801070b3:	c3                   	ret    
801070b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 1c             	sub    $0x1c,%esp
801070c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801070cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801070cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070d2:	85 db                	test   %ebx,%ebx
801070d4:	75 3a                	jne    80107110 <copyout+0x50>
801070d6:	eb 68                	jmp    80107140 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801070d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070db:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801070dd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801070e1:	29 ca                	sub    %ecx,%edx
801070e3:	81 c2 00 10 00 00    	add    $0x1000,%edx
801070e9:	39 da                	cmp    %ebx,%edx
801070eb:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801070ee:	29 f1                	sub    %esi,%ecx
801070f0:	01 c8                	add    %ecx,%eax
801070f2:	89 54 24 08          	mov    %edx,0x8(%esp)
801070f6:	89 04 24             	mov    %eax,(%esp)
801070f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801070fc:	e8 ef d6 ff ff       	call   801047f0 <memmove>
    len -= n;
    buf += n;
80107101:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80107104:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
8010710a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010710c:	29 d3                	sub    %edx,%ebx
8010710e:	74 30                	je     80107140 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80107110:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107113:	89 ce                	mov    %ecx,%esi
80107115:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010711b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010711f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107122:	89 04 24             	mov    %eax,(%esp)
80107125:	e8 56 ff ff ff       	call   80107080 <uva2ka>
    if(pa0 == 0)
8010712a:	85 c0                	test   %eax,%eax
8010712c:	75 aa                	jne    801070d8 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010712e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107136:	5b                   	pop    %ebx
80107137:	5e                   	pop    %esi
80107138:	5f                   	pop    %edi
80107139:	5d                   	pop    %ebp
8010713a:	c3                   	ret    
8010713b:	90                   	nop
8010713c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107140:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107143:	31 c0                	xor    %eax,%eax
}
80107145:	5b                   	pop    %ebx
80107146:	5e                   	pop    %esi
80107147:	5f                   	pop    %edi
80107148:	5d                   	pop    %ebp
80107149:	c3                   	ret    
