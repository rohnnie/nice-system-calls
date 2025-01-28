
_test1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    num++;
  }
}


int main() {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 10             	sub    $0x10,%esp
  printf(1,"-------------- Test Case 1 with Custom Scheduler ---------\n");
   a:	c7 44 24 04 9c 08 00 	movl   $0x89c,0x4(%esp)
  11:	00 
  12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  19:	e8 b2 04 00 00       	call   4d0 <printf>
  printf(1,"Lowering the Parent's Priority Below the Child's Priority\n");
  1e:	c7 44 24 04 d8 08 00 	movl   $0x8d8,0x4(%esp)
  25:	00 
  26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  2d:	e8 9e 04 00 00       	call   4d0 <printf>
  int pid = fork();
  32:	e8 33 03 00 00       	call   36a <fork>
  sleep(200); // to process changing the pid
  37:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)


int main() {
  printf(1,"-------------- Test Case 1 with Custom Scheduler ---------\n");
  printf(1,"Lowering the Parent's Priority Below the Child's Priority\n");
  int pid = fork();
  3e:	89 c3                	mov    %eax,%ebx
  sleep(200); // to process changing the pid
  40:	e8 bd 03 00 00       	call   402 <sleep>
  if (pid < 0) {
  45:	85 db                	test   %ebx,%ebx
  47:	0f 88 8a 00 00 00    	js     d7 <main+0xd7>
      printf(2, "Fork fail in pid: %d\n", getpid());
      exit();
  }
  if (pid > 0) {
  4d:	74 5f                	je     ae <main+0xae>
  4f:	90                   	nop
    printf(1, "Change Parents priority to 1 with pid=%d\n", getpid());
  50:	e8 9d 03 00 00       	call   3f2 <getpid>
  55:	c7 44 24 04 14 09 00 	movl   $0x914,0x4(%esp)
  5c:	00 
  5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  64:	89 44 24 08          	mov    %eax,0x8(%esp)
  68:	e8 63 04 00 00       	call   4d0 <printf>
    nice(getpid(), 1);
  6d:	e8 80 03 00 00       	call   3f2 <getpid>
  72:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  79:	00 
  7a:	89 04 24             	mov    %eax,(%esp)
  7d:	e8 98 03 00 00       	call   41a <nice>
    printf(1, "Child process with pid=%d\n", getpid());
    // nice(getpid(),5);
    prime();
    exit();
  } else {
    printf(1, "Parent process with pid=%d\n", getpid());
  82:	e8 6b 03 00 00       	call   3f2 <getpid>
  87:	c7 44 24 04 62 08 00 	movl   $0x862,0x4(%esp)
  8e:	00 
  8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  96:	89 44 24 08          	mov    %eax,0x8(%esp)
  9a:	e8 31 04 00 00       	call   4d0 <printf>
    prime();
  9f:	e8 5c 00 00 00       	call   100 <prime>
    wait();
  a4:	e8 d1 02 00 00       	call   37a <wait>
    exit();
  a9:	e8 c4 02 00 00       	call   372 <exit>
  ae:	66 90                	xchg   %ax,%ax
  if (pid > 0) {
    printf(1, "Change Parents priority to 1 with pid=%d\n", getpid());
    nice(getpid(), 1);
  }
  if (pid == 0) {
    printf(1, "Child process with pid=%d\n", getpid());
  b0:	e8 3d 03 00 00       	call   3f2 <getpid>
  b5:	c7 44 24 04 7e 08 00 	movl   $0x87e,0x4(%esp)
  bc:	00 
  bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  c8:	e8 03 04 00 00       	call   4d0 <printf>
    // nice(getpid(),5);
    prime();
  cd:	e8 2e 00 00 00       	call   100 <prime>
    exit();
  d2:	e8 9b 02 00 00       	call   372 <exit>
  printf(1,"-------------- Test Case 1 with Custom Scheduler ---------\n");
  printf(1,"Lowering the Parent's Priority Below the Child's Priority\n");
  int pid = fork();
  sleep(200); // to process changing the pid
  if (pid < 0) {
      printf(2, "Fork fail in pid: %d\n", getpid());
  d7:	e8 16 03 00 00       	call   3f2 <getpid>
  dc:	c7 44 24 04 4c 08 00 	movl   $0x84c,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  ef:	e8 dc 03 00 00       	call   4d0 <printf>
      exit();
  f4:	e8 79 02 00 00       	call   372 <exit>
  f9:	66 90                	xchg   %ax,%ax
  fb:	66 90                	xchg   %ax,%ax
  fd:	66 90                	xchg   %ax,%ax
  ff:	90                   	nop

00000100 <prime>:
#include "types.h"
#include "stat.h"
#include "user.h"

void prime() {
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
  int num = 2;  // Start from 2, since 1 is not a prime number
 104:	bb 02 00 00 00       	mov    $0x2,%ebx
#include "types.h"
#include "stat.h"
#include "user.h"

void prime() {
 109:	83 ec 14             	sub    $0x14,%esp
  int num = 2;  // Start from 2, since 1 is not a prime number
  while (num < 7) {
    int prime = 1;
    int i;
    for (i = 2; i * i <= num; i++) {  // Corrected condition to i * i <= num
 10c:	83 fb 03             	cmp    $0x3,%ebx
 10f:	7e 05                	jle    116 <prime+0x16>
      if (num % i == 0) {
 111:	f6 c3 01             	test   $0x1,%bl
 114:	74 21                	je     137 <prime+0x37>
        prime = 0;
        break;
      }
    }
    if (prime) {
      printf(1, "Pid: %d, Prime: %d\n", getpid(), num);
 116:	e8 d7 02 00 00       	call   3f2 <getpid>
 11b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 11f:	c7 44 24 04 38 08 00 	movl   $0x838,0x4(%esp)
 126:	00 
 127:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 12e:	89 44 24 08          	mov    %eax,0x8(%esp)
 132:	e8 99 03 00 00       	call   4d0 <printf>
    }
    num++;
 137:	83 c3 01             	add    $0x1,%ebx
#include "stat.h"
#include "user.h"

void prime() {
  int num = 2;  // Start from 2, since 1 is not a prime number
  while (num < 7) {
 13a:	83 fb 07             	cmp    $0x7,%ebx
 13d:	75 cd                	jne    10c <prime+0xc>
    if (prime) {
      printf(1, "Pid: %d, Prime: %d\n", getpid(), num);
    }
    num++;
  }
}
 13f:	83 c4 14             	add    $0x14,%esp
 142:	5b                   	pop    %ebx
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    
 145:	66 90                	xchg   %ax,%ax
 147:	66 90                	xchg   %ax,%ax
 149:	66 90                	xchg   %ax,%ax
 14b:	66 90                	xchg   %ax,%ax
 14d:	66 90                	xchg   %ax,%ax
 14f:	90                   	nop

00000150 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 159:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 15a:	89 c2                	mov    %eax,%edx
 15c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 160:	83 c1 01             	add    $0x1,%ecx
 163:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 167:	83 c2 01             	add    $0x1,%edx
 16a:	84 db                	test   %bl,%bl
 16c:	88 5a ff             	mov    %bl,-0x1(%edx)
 16f:	75 ef                	jne    160 <strcpy+0x10>
    ;
  return os;
}
 171:	5b                   	pop    %ebx
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
 174:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 17a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000180 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 55 08             	mov    0x8(%ebp),%edx
 186:	53                   	push   %ebx
 187:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 18a:	0f b6 02             	movzbl (%edx),%eax
 18d:	84 c0                	test   %al,%al
 18f:	74 2d                	je     1be <strcmp+0x3e>
 191:	0f b6 19             	movzbl (%ecx),%ebx
 194:	38 d8                	cmp    %bl,%al
 196:	74 0e                	je     1a6 <strcmp+0x26>
 198:	eb 2b                	jmp    1c5 <strcmp+0x45>
 19a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1a0:	38 c8                	cmp    %cl,%al
 1a2:	75 15                	jne    1b9 <strcmp+0x39>
    p++, q++;
 1a4:	89 d9                	mov    %ebx,%ecx
 1a6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1a9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 1ac:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1af:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 1b3:	84 c0                	test   %al,%al
 1b5:	75 e9                	jne    1a0 <strcmp+0x20>
 1b7:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1b9:	29 c8                	sub    %ecx,%eax
}
 1bb:	5b                   	pop    %ebx
 1bc:	5d                   	pop    %ebp
 1bd:	c3                   	ret    
 1be:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1c1:	31 c0                	xor    %eax,%eax
 1c3:	eb f4                	jmp    1b9 <strcmp+0x39>
 1c5:	0f b6 cb             	movzbl %bl,%ecx
 1c8:	eb ef                	jmp    1b9 <strcmp+0x39>
 1ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001d0 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1d6:	80 39 00             	cmpb   $0x0,(%ecx)
 1d9:	74 12                	je     1ed <strlen+0x1d>
 1db:	31 d2                	xor    %edx,%edx
 1dd:	8d 76 00             	lea    0x0(%esi),%esi
 1e0:	83 c2 01             	add    $0x1,%edx
 1e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1e7:	89 d0                	mov    %edx,%eax
 1e9:	75 f5                	jne    1e0 <strlen+0x10>
    ;
  return n;
}
 1eb:	5d                   	pop    %ebp
 1ec:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 1ed:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    
 1f1:	eb 0d                	jmp    200 <memset>
 1f3:	90                   	nop
 1f4:	90                   	nop
 1f5:	90                   	nop
 1f6:	90                   	nop
 1f7:	90                   	nop
 1f8:	90                   	nop
 1f9:	90                   	nop
 1fa:	90                   	nop
 1fb:	90                   	nop
 1fc:	90                   	nop
 1fd:	90                   	nop
 1fe:	90                   	nop
 1ff:	90                   	nop

00000200 <memset>:

void*
memset(void *dst, int c, uint n)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 55 08             	mov    0x8(%ebp),%edx
 206:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 207:	8b 4d 10             	mov    0x10(%ebp),%ecx
 20a:	8b 45 0c             	mov    0xc(%ebp),%eax
 20d:	89 d7                	mov    %edx,%edi
 20f:	fc                   	cld    
 210:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 212:	89 d0                	mov    %edx,%eax
 214:	5f                   	pop    %edi
 215:	5d                   	pop    %ebp
 216:	c3                   	ret    
 217:	89 f6                	mov    %esi,%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	53                   	push   %ebx
 227:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 22a:	0f b6 18             	movzbl (%eax),%ebx
 22d:	84 db                	test   %bl,%bl
 22f:	74 1d                	je     24e <strchr+0x2e>
    if(*s == c)
 231:	38 d3                	cmp    %dl,%bl
 233:	89 d1                	mov    %edx,%ecx
 235:	75 0d                	jne    244 <strchr+0x24>
 237:	eb 17                	jmp    250 <strchr+0x30>
 239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 240:	38 ca                	cmp    %cl,%dl
 242:	74 0c                	je     250 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 244:	83 c0 01             	add    $0x1,%eax
 247:	0f b6 10             	movzbl (%eax),%edx
 24a:	84 d2                	test   %dl,%dl
 24c:	75 f2                	jne    240 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 24e:	31 c0                	xor    %eax,%eax
}
 250:	5b                   	pop    %ebx
 251:	5d                   	pop    %ebp
 252:	c3                   	ret    
 253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <gets>:

char*
gets(char *buf, int max)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 265:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 267:	53                   	push   %ebx
 268:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 26b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26e:	eb 31                	jmp    2a1 <gets+0x41>
    cc = read(0, &c, 1);
 270:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 277:	00 
 278:	89 7c 24 04          	mov    %edi,0x4(%esp)
 27c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 283:	e8 02 01 00 00       	call   38a <read>
    if(cc < 1)
 288:	85 c0                	test   %eax,%eax
 28a:	7e 1d                	jle    2a9 <gets+0x49>
      break;
    buf[i++] = c;
 28c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 290:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 292:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 295:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 297:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 29b:	74 0c                	je     2a9 <gets+0x49>
 29d:	3c 0a                	cmp    $0xa,%al
 29f:	74 08                	je     2a9 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a1:	8d 5e 01             	lea    0x1(%esi),%ebx
 2a4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2a7:	7c c7                	jl     270 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2b0:	83 c4 2c             	add    $0x2c,%esp
 2b3:	5b                   	pop    %ebx
 2b4:	5e                   	pop    %esi
 2b5:	5f                   	pop    %edi
 2b6:	5d                   	pop    %ebp
 2b7:	c3                   	ret    
 2b8:	90                   	nop
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002c0 <stat>:

int
stat(char *n, struct stat *st)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	56                   	push   %esi
 2c4:	53                   	push   %ebx
 2c5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2d2:	00 
 2d3:	89 04 24             	mov    %eax,(%esp)
 2d6:	e8 d7 00 00 00       	call   3b2 <open>
  if(fd < 0)
 2db:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2dd:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2df:	78 27                	js     308 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 2e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e4:	89 1c 24             	mov    %ebx,(%esp)
 2e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2eb:	e8 da 00 00 00       	call   3ca <fstat>
  close(fd);
 2f0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2f3:	89 c6                	mov    %eax,%esi
  close(fd);
 2f5:	e8 a0 00 00 00       	call   39a <close>
  return r;
 2fa:	89 f0                	mov    %esi,%eax
}
 2fc:	83 c4 10             	add    $0x10,%esp
 2ff:	5b                   	pop    %ebx
 300:	5e                   	pop    %esi
 301:	5d                   	pop    %ebp
 302:	c3                   	ret    
 303:	90                   	nop
 304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 30d:	eb ed                	jmp    2fc <stat+0x3c>
 30f:	90                   	nop

00000310 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	8b 4d 08             	mov    0x8(%ebp),%ecx
 316:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 317:	0f be 11             	movsbl (%ecx),%edx
 31a:	8d 42 d0             	lea    -0x30(%edx),%eax
 31d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 31f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 324:	77 17                	ja     33d <atoi+0x2d>
 326:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 328:	83 c1 01             	add    $0x1,%ecx
 32b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 32e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 332:	0f be 11             	movsbl (%ecx),%edx
 335:	8d 5a d0             	lea    -0x30(%edx),%ebx
 338:	80 fb 09             	cmp    $0x9,%bl
 33b:	76 eb                	jbe    328 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 33d:	5b                   	pop    %ebx
 33e:	5d                   	pop    %ebp
 33f:	c3                   	ret    

00000340 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 340:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 341:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 343:	89 e5                	mov    %esp,%ebp
 345:	56                   	push   %esi
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	53                   	push   %ebx
 34a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 34d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 350:	85 db                	test   %ebx,%ebx
 352:	7e 12                	jle    366 <memmove+0x26>
 354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 358:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 35c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 35f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 362:	39 da                	cmp    %ebx,%edx
 364:	75 f2                	jne    358 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 366:	5b                   	pop    %ebx
 367:	5e                   	pop    %esi
 368:	5d                   	pop    %ebp
 369:	c3                   	ret    

0000036a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 36a:	b8 01 00 00 00       	mov    $0x1,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <exit>:
SYSCALL(exit)
 372:	b8 02 00 00 00       	mov    $0x2,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <wait>:
SYSCALL(wait)
 37a:	b8 03 00 00 00       	mov    $0x3,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <pipe>:
SYSCALL(pipe)
 382:	b8 04 00 00 00       	mov    $0x4,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <read>:
SYSCALL(read)
 38a:	b8 05 00 00 00       	mov    $0x5,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <write>:
SYSCALL(write)
 392:	b8 10 00 00 00       	mov    $0x10,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <close>:
SYSCALL(close)
 39a:	b8 15 00 00 00       	mov    $0x15,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <kill>:
SYSCALL(kill)
 3a2:	b8 06 00 00 00       	mov    $0x6,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <exec>:
SYSCALL(exec)
 3aa:	b8 07 00 00 00       	mov    $0x7,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <open>:
SYSCALL(open)
 3b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <mknod>:
SYSCALL(mknod)
 3ba:	b8 11 00 00 00       	mov    $0x11,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <unlink>:
SYSCALL(unlink)
 3c2:	b8 12 00 00 00       	mov    $0x12,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <fstat>:
SYSCALL(fstat)
 3ca:	b8 08 00 00 00       	mov    $0x8,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <link>:
SYSCALL(link)
 3d2:	b8 13 00 00 00       	mov    $0x13,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <mkdir>:
SYSCALL(mkdir)
 3da:	b8 14 00 00 00       	mov    $0x14,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <chdir>:
SYSCALL(chdir)
 3e2:	b8 09 00 00 00       	mov    $0x9,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <dup>:
SYSCALL(dup)
 3ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <getpid>:
SYSCALL(getpid)
 3f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <sbrk>:
SYSCALL(sbrk)
 3fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <sleep>:
SYSCALL(sleep)
 402:	b8 0d 00 00 00       	mov    $0xd,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <uptime>:
SYSCALL(uptime)
 40a:	b8 0e 00 00 00       	mov    $0xe,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <cps>:
SYSCALL(cps)
 412:	b8 16 00 00 00       	mov    $0x16,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <nice>:
SYSCALL(nice)
 41a:	b8 17 00 00 00       	mov    $0x17,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    
 422:	66 90                	xchg   %ax,%ax
 424:	66 90                	xchg   %ax,%ax
 426:	66 90                	xchg   %ax,%ax
 428:	66 90                	xchg   %ax,%ax
 42a:	66 90                	xchg   %ax,%ax
 42c:	66 90                	xchg   %ax,%ax
 42e:	66 90                	xchg   %ax,%ax

00000430 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	89 c6                	mov    %eax,%esi
 437:	53                   	push   %ebx
 438:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 43e:	85 db                	test   %ebx,%ebx
 440:	74 09                	je     44b <printint+0x1b>
 442:	89 d0                	mov    %edx,%eax
 444:	c1 e8 1f             	shr    $0x1f,%eax
 447:	84 c0                	test   %al,%al
 449:	75 75                	jne    4c0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 44b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 44d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 454:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 457:	31 ff                	xor    %edi,%edi
 459:	89 ce                	mov    %ecx,%esi
 45b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 45e:	eb 02                	jmp    462 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 460:	89 cf                	mov    %ecx,%edi
 462:	31 d2                	xor    %edx,%edx
 464:	f7 f6                	div    %esi
 466:	8d 4f 01             	lea    0x1(%edi),%ecx
 469:	0f b6 92 47 09 00 00 	movzbl 0x947(%edx),%edx
  }while((x /= base) != 0);
 470:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 472:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 475:	75 e9                	jne    460 <printint+0x30>
  if(neg)
 477:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 47a:	89 c8                	mov    %ecx,%eax
 47c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 47f:	85 d2                	test   %edx,%edx
 481:	74 08                	je     48b <printint+0x5b>
    buf[i++] = '-';
 483:	8d 4f 02             	lea    0x2(%edi),%ecx
 486:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 48b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 48e:	66 90                	xchg   %ax,%ax
 490:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 495:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 498:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 49f:	00 
 4a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 4a4:	89 34 24             	mov    %esi,(%esp)
 4a7:	88 45 d7             	mov    %al,-0x29(%ebp)
 4aa:	e8 e3 fe ff ff       	call   392 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4af:	83 ff ff             	cmp    $0xffffffff,%edi
 4b2:	75 dc                	jne    490 <printint+0x60>
    putc(fd, buf[i]);
}
 4b4:	83 c4 4c             	add    $0x4c,%esp
 4b7:	5b                   	pop    %ebx
 4b8:	5e                   	pop    %esi
 4b9:	5f                   	pop    %edi
 4ba:	5d                   	pop    %ebp
 4bb:	c3                   	ret    
 4bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4c0:	89 d0                	mov    %edx,%eax
 4c2:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 4c4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 4cb:	eb 87                	jmp    454 <printint+0x24>
 4cd:	8d 76 00             	lea    0x0(%esi),%esi

000004d0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4d4:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d6:	56                   	push   %esi
 4d7:	53                   	push   %ebx
 4d8:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4de:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e1:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 4e7:	0f b6 13             	movzbl (%ebx),%edx
 4ea:	83 c3 01             	add    $0x1,%ebx
 4ed:	84 d2                	test   %dl,%dl
 4ef:	75 39                	jne    52a <printf+0x5a>
 4f1:	e9 c2 00 00 00       	jmp    5b8 <printf+0xe8>
 4f6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4f8:	83 fa 25             	cmp    $0x25,%edx
 4fb:	0f 84 bf 00 00 00    	je     5c0 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 501:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 504:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 50b:	00 
 50c:	89 44 24 04          	mov    %eax,0x4(%esp)
 510:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 513:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 516:	e8 77 fe ff ff       	call   392 <write>
 51b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 51e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 522:	84 d2                	test   %dl,%dl
 524:	0f 84 8e 00 00 00    	je     5b8 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 52a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 52c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 52f:	74 c7                	je     4f8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 531:	83 ff 25             	cmp    $0x25,%edi
 534:	75 e5                	jne    51b <printf+0x4b>
      if(c == 'd'){
 536:	83 fa 64             	cmp    $0x64,%edx
 539:	0f 84 31 01 00 00    	je     670 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 53f:	25 f7 00 00 00       	and    $0xf7,%eax
 544:	83 f8 70             	cmp    $0x70,%eax
 547:	0f 84 83 00 00 00    	je     5d0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 54d:	83 fa 73             	cmp    $0x73,%edx
 550:	0f 84 a2 00 00 00    	je     5f8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 556:	83 fa 63             	cmp    $0x63,%edx
 559:	0f 84 35 01 00 00    	je     694 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 55f:	83 fa 25             	cmp    $0x25,%edx
 562:	0f 84 e0 00 00 00    	je     648 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 568:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 56b:	83 c3 01             	add    $0x1,%ebx
 56e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 575:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 576:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 578:	89 44 24 04          	mov    %eax,0x4(%esp)
 57c:	89 34 24             	mov    %esi,(%esp)
 57f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 582:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 586:	e8 07 fe ff ff       	call   392 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 58b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 58e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 591:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 598:	00 
 599:	89 44 24 04          	mov    %eax,0x4(%esp)
 59d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5a0:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a3:	e8 ea fd ff ff       	call   392 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 5ac:	84 d2                	test   %dl,%dl
 5ae:	0f 85 76 ff ff ff    	jne    52a <printf+0x5a>
 5b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5b8:	83 c4 3c             	add    $0x3c,%esp
 5bb:	5b                   	pop    %ebx
 5bc:	5e                   	pop    %esi
 5bd:	5f                   	pop    %edi
 5be:	5d                   	pop    %ebp
 5bf:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5c0:	bf 25 00 00 00       	mov    $0x25,%edi
 5c5:	e9 51 ff ff ff       	jmp    51b <printf+0x4b>
 5ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5d3:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5d8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5e1:	8b 10                	mov    (%eax),%edx
 5e3:	89 f0                	mov    %esi,%eax
 5e5:	e8 46 fe ff ff       	call   430 <printint>
        ap++;
 5ea:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5ee:	e9 28 ff ff ff       	jmp    51b <printf+0x4b>
 5f3:	90                   	nop
 5f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 5f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 5fb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 5ff:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 601:	b8 40 09 00 00       	mov    $0x940,%eax
 606:	85 ff                	test   %edi,%edi
 608:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 60b:	0f b6 07             	movzbl (%edi),%eax
 60e:	84 c0                	test   %al,%al
 610:	74 2a                	je     63c <printf+0x16c>
 612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 618:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 61b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 61e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 621:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 628:	00 
 629:	89 44 24 04          	mov    %eax,0x4(%esp)
 62d:	89 34 24             	mov    %esi,(%esp)
 630:	e8 5d fd ff ff       	call   392 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 635:	0f b6 07             	movzbl (%edi),%eax
 638:	84 c0                	test   %al,%al
 63a:	75 dc                	jne    618 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 63c:	31 ff                	xor    %edi,%edi
 63e:	e9 d8 fe ff ff       	jmp    51b <printf+0x4b>
 643:	90                   	nop
 644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 648:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 64b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 64d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 654:	00 
 655:	89 44 24 04          	mov    %eax,0x4(%esp)
 659:	89 34 24             	mov    %esi,(%esp)
 65c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 660:	e8 2d fd ff ff       	call   392 <write>
 665:	e9 b1 fe ff ff       	jmp    51b <printf+0x4b>
 66a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 670:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 673:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 678:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 67b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 682:	8b 10                	mov    (%eax),%edx
 684:	89 f0                	mov    %esi,%eax
 686:	e8 a5 fd ff ff       	call   430 <printint>
        ap++;
 68b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 68f:	e9 87 fe ff ff       	jmp    51b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 694:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 697:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 699:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 69b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6a2:	00 
 6a3:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6a6:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b0:	e8 dd fc ff ff       	call   392 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 6b5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6b9:	e9 5d fe ff ff       	jmp    51b <printf+0x4b>
 6be:	66 90                	xchg   %ax,%ax

000006c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c1:	a1 e0 0b 00 00       	mov    0xbe0,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c6:	89 e5                	mov    %esp,%ebp
 6c8:	57                   	push   %edi
 6c9:	56                   	push   %esi
 6ca:	53                   	push   %ebx
 6cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ce:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d3:	39 d0                	cmp    %edx,%eax
 6d5:	72 11                	jb     6e8 <free+0x28>
 6d7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d8:	39 c8                	cmp    %ecx,%eax
 6da:	72 04                	jb     6e0 <free+0x20>
 6dc:	39 ca                	cmp    %ecx,%edx
 6de:	72 10                	jb     6f0 <free+0x30>
 6e0:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e4:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e6:	73 f0                	jae    6d8 <free+0x18>
 6e8:	39 ca                	cmp    %ecx,%edx
 6ea:	72 04                	jb     6f0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ec:	39 c8                	cmp    %ecx,%eax
 6ee:	72 f0                	jb     6e0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6f3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 6f6:	39 cf                	cmp    %ecx,%edi
 6f8:	74 1e                	je     718 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6fa:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6fd:	8b 48 04             	mov    0x4(%eax),%ecx
 700:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 703:	39 f2                	cmp    %esi,%edx
 705:	74 28                	je     72f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 707:	89 10                	mov    %edx,(%eax)
  freep = p;
 709:	a3 e0 0b 00 00       	mov    %eax,0xbe0
}
 70e:	5b                   	pop    %ebx
 70f:	5e                   	pop    %esi
 710:	5f                   	pop    %edi
 711:	5d                   	pop    %ebp
 712:	c3                   	ret    
 713:	90                   	nop
 714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 718:	03 71 04             	add    0x4(%ecx),%esi
 71b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 71e:	8b 08                	mov    (%eax),%ecx
 720:	8b 09                	mov    (%ecx),%ecx
 722:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 725:	8b 48 04             	mov    0x4(%eax),%ecx
 728:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 72b:	39 f2                	cmp    %esi,%edx
 72d:	75 d8                	jne    707 <free+0x47>
    p->s.size += bp->s.size;
 72f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 732:	a3 e0 0b 00 00       	mov    %eax,0xbe0
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 737:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 73a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 73d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 73f:	5b                   	pop    %ebx
 740:	5e                   	pop    %esi
 741:	5f                   	pop    %edi
 742:	5d                   	pop    %ebp
 743:	c3                   	ret    
 744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 74a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000750 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	57                   	push   %edi
 754:	56                   	push   %esi
 755:	53                   	push   %ebx
 756:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 759:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 75c:	8b 1d e0 0b 00 00    	mov    0xbe0,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 762:	8d 48 07             	lea    0x7(%eax),%ecx
 765:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 768:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 76d:	0f 84 9b 00 00 00    	je     80e <malloc+0xbe>
 773:	8b 13                	mov    (%ebx),%edx
 775:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 778:	39 fe                	cmp    %edi,%esi
 77a:	76 64                	jbe    7e0 <malloc+0x90>
 77c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 783:	bb 00 80 00 00       	mov    $0x8000,%ebx
 788:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 78b:	eb 0e                	jmp    79b <malloc+0x4b>
 78d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 790:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 792:	8b 78 04             	mov    0x4(%eax),%edi
 795:	39 fe                	cmp    %edi,%esi
 797:	76 4f                	jbe    7e8 <malloc+0x98>
 799:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 79b:	3b 15 e0 0b 00 00    	cmp    0xbe0,%edx
 7a1:	75 ed                	jne    790 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 7a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7ac:	bf 00 10 00 00       	mov    $0x1000,%edi
 7b1:	0f 43 fe             	cmovae %esi,%edi
 7b4:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 7b7:	89 04 24             	mov    %eax,(%esp)
 7ba:	e8 3b fc ff ff       	call   3fa <sbrk>
  if(p == (char*)-1)
 7bf:	83 f8 ff             	cmp    $0xffffffff,%eax
 7c2:	74 18                	je     7dc <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7c4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 7c7:	83 c0 08             	add    $0x8,%eax
 7ca:	89 04 24             	mov    %eax,(%esp)
 7cd:	e8 ee fe ff ff       	call   6c0 <free>
  return freep;
 7d2:	8b 15 e0 0b 00 00    	mov    0xbe0,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 7d8:	85 d2                	test   %edx,%edx
 7da:	75 b4                	jne    790 <malloc+0x40>
        return 0;
 7dc:	31 c0                	xor    %eax,%eax
 7de:	eb 20                	jmp    800 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7e0:	89 d0                	mov    %edx,%eax
 7e2:	89 da                	mov    %ebx,%edx
 7e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 7e8:	39 fe                	cmp    %edi,%esi
 7ea:	74 1c                	je     808 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7ec:	29 f7                	sub    %esi,%edi
 7ee:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 7f1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 7f4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 7f7:	89 15 e0 0b 00 00    	mov    %edx,0xbe0
      return (void*)(p + 1);
 7fd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 800:	83 c4 1c             	add    $0x1c,%esp
 803:	5b                   	pop    %ebx
 804:	5e                   	pop    %esi
 805:	5f                   	pop    %edi
 806:	5d                   	pop    %ebp
 807:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 808:	8b 08                	mov    (%eax),%ecx
 80a:	89 0a                	mov    %ecx,(%edx)
 80c:	eb e9                	jmp    7f7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 80e:	c7 05 e0 0b 00 00 e4 	movl   $0xbe4,0xbe0
 815:	0b 00 00 
    base.s.size = 0;
 818:	ba e4 0b 00 00       	mov    $0xbe4,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 81d:	c7 05 e4 0b 00 00 e4 	movl   $0xbe4,0xbe4
 824:	0b 00 00 
    base.s.size = 0;
 827:	c7 05 e8 0b 00 00 00 	movl   $0x0,0xbe8
 82e:	00 00 00 
 831:	e9 46 ff ff ff       	jmp    77c <malloc+0x2c>
