
_test1_nice:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "param.h"

int main() {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
      int value = i;
      int res = nice(getpid(),value);
      if (res < 0) {
          printf(1, "Failed: Unable to Change Value\n");
      } else {
          printf(1, "Current PID: %d, Old_Value: %d, New Value: %d\n", res/MOD, res%MOD, value);
   4:	be 7f e0 07 7e       	mov    $0x7e07e07f,%esi
#include "types.h"
#include "user.h"
#include "param.h"

int main() {
   9:	53                   	push   %ebx
    printf(1, "Test 1: Nice Value\n");
    int i;
    for(i=4;i>1;i=i-2){
   a:	bb 04 00 00 00       	mov    $0x4,%ebx
#include "types.h"
#include "user.h"
#include "param.h"

int main() {
   f:	83 e4 f0             	and    $0xfffffff0,%esp
  12:	83 ec 20             	sub    $0x20,%esp
    printf(1, "Test 1: Nice Value\n");
  15:	c7 44 24 04 88 07 00 	movl   $0x788,0x4(%esp)
  1c:	00 
  1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  24:	e8 f7 03 00 00       	call   420 <printf>
    int i;
    for(i=4;i>1;i=i-2){
      int value = i;
      int res = nice(getpid(),value);
  29:	e8 14 03 00 00       	call   342 <getpid>
  2e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  32:	89 04 24             	mov    %eax,(%esp)
  35:	e8 30 03 00 00       	call   36a <nice>
      if (res < 0) {
  3a:	85 c0                	test   %eax,%eax
int main() {
    printf(1, "Test 1: Nice Value\n");
    int i;
    for(i=4;i>1;i=i-2){
      int value = i;
      int res = nice(getpid(),value);
  3c:	89 c1                	mov    %eax,%ecx
      if (res < 0) {
  3e:	78 3f                	js     7f <main+0x7f>
          printf(1, "Failed: Unable to Change Value\n");
      } else {
          printf(1, "Current PID: %d, Old_Value: %d, New Value: %d\n", res/MOD, res%MOD, value);
  40:	f7 ee                	imul   %esi
  42:	89 c8                	mov    %ecx,%eax
  44:	c1 f8 1f             	sar    $0x1f,%eax
  47:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  4b:	c7 44 24 04 bc 07 00 	movl   $0x7bc,0x4(%esp)
  52:	00 
  53:	c1 fa 05             	sar    $0x5,%edx
  56:	29 c2                	sub    %eax,%edx
  58:	89 d0                	mov    %edx,%eax
  5a:	c1 e0 06             	shl    $0x6,%eax
  5d:	01 d0                	add    %edx,%eax
  5f:	29 c1                	sub    %eax,%ecx
  61:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  65:	89 54 24 08          	mov    %edx,0x8(%esp)
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 ab 03 00 00       	call   420 <printf>
#include "param.h"

int main() {
    printf(1, "Test 1: Nice Value\n");
    int i;
    for(i=4;i>1;i=i-2){
  75:	83 eb 02             	sub    $0x2,%ebx
  78:	75 af                	jne    29 <main+0x29>
          printf(1, "Failed: Unable to Change Value\n");
      } else {
          printf(1, "Current PID: %d, Old_Value: %d, New Value: %d\n", res/MOD, res%MOD, value);
      }
    }
    exit();
  7a:	e8 43 02 00 00       	call   2c2 <exit>
    int i;
    for(i=4;i>1;i=i-2){
      int value = i;
      int res = nice(getpid(),value);
      if (res < 0) {
          printf(1, "Failed: Unable to Change Value\n");
  7f:	c7 44 24 04 9c 07 00 	movl   $0x79c,0x4(%esp)
  86:	00 
  87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8e:	e8 8d 03 00 00       	call   420 <printf>
  93:	eb e0                	jmp    75 <main+0x75>
  95:	66 90                	xchg   %ax,%ax
  97:	66 90                	xchg   %ax,%ax
  99:	66 90                	xchg   %ax,%ax
  9b:	66 90                	xchg   %ax,%ax
  9d:	66 90                	xchg   %ax,%ax
  9f:	90                   	nop

000000a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  a9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  aa:	89 c2                	mov    %eax,%edx
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  b0:	83 c1 01             	add    $0x1,%ecx
  b3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  b7:	83 c2 01             	add    $0x1,%edx
  ba:	84 db                	test   %bl,%bl
  bc:	88 5a ff             	mov    %bl,-0x1(%edx)
  bf:	75 ef                	jne    b0 <strcpy+0x10>
    ;
  return os;
}
  c1:	5b                   	pop    %ebx
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    
  c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 55 08             	mov    0x8(%ebp),%edx
  d6:	53                   	push   %ebx
  d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  da:	0f b6 02             	movzbl (%edx),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 2d                	je     10e <strcmp+0x3e>
  e1:	0f b6 19             	movzbl (%ecx),%ebx
  e4:	38 d8                	cmp    %bl,%al
  e6:	74 0e                	je     f6 <strcmp+0x26>
  e8:	eb 2b                	jmp    115 <strcmp+0x45>
  ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f0:	38 c8                	cmp    %cl,%al
  f2:	75 15                	jne    109 <strcmp+0x39>
    p++, q++;
  f4:	89 d9                	mov    %ebx,%ecx
  f6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  fc:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ff:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 103:	84 c0                	test   %al,%al
 105:	75 e9                	jne    f0 <strcmp+0x20>
 107:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 109:	29 c8                	sub    %ecx,%eax
}
 10b:	5b                   	pop    %ebx
 10c:	5d                   	pop    %ebp
 10d:	c3                   	ret    
 10e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 111:	31 c0                	xor    %eax,%eax
 113:	eb f4                	jmp    109 <strcmp+0x39>
 115:	0f b6 cb             	movzbl %bl,%ecx
 118:	eb ef                	jmp    109 <strcmp+0x39>
 11a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000120 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 126:	80 39 00             	cmpb   $0x0,(%ecx)
 129:	74 12                	je     13d <strlen+0x1d>
 12b:	31 d2                	xor    %edx,%edx
 12d:	8d 76 00             	lea    0x0(%esi),%esi
 130:	83 c2 01             	add    $0x1,%edx
 133:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 137:	89 d0                	mov    %edx,%eax
 139:	75 f5                	jne    130 <strlen+0x10>
    ;
  return n;
}
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 13d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    
 141:	eb 0d                	jmp    150 <memset>
 143:	90                   	nop
 144:	90                   	nop
 145:	90                   	nop
 146:	90                   	nop
 147:	90                   	nop
 148:	90                   	nop
 149:	90                   	nop
 14a:	90                   	nop
 14b:	90                   	nop
 14c:	90                   	nop
 14d:	90                   	nop
 14e:	90                   	nop
 14f:	90                   	nop

00000150 <memset>:

void*
memset(void *dst, int c, uint n)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 55 08             	mov    0x8(%ebp),%edx
 156:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 157:	8b 4d 10             	mov    0x10(%ebp),%ecx
 15a:	8b 45 0c             	mov    0xc(%ebp),%eax
 15d:	89 d7                	mov    %edx,%edi
 15f:	fc                   	cld    
 160:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 162:	89 d0                	mov    %edx,%eax
 164:	5f                   	pop    %edi
 165:	5d                   	pop    %ebp
 166:	c3                   	ret    
 167:	89 f6                	mov    %esi,%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000170 <strchr>:

char*
strchr(const char *s, char c)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	53                   	push   %ebx
 177:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 17a:	0f b6 18             	movzbl (%eax),%ebx
 17d:	84 db                	test   %bl,%bl
 17f:	74 1d                	je     19e <strchr+0x2e>
    if(*s == c)
 181:	38 d3                	cmp    %dl,%bl
 183:	89 d1                	mov    %edx,%ecx
 185:	75 0d                	jne    194 <strchr+0x24>
 187:	eb 17                	jmp    1a0 <strchr+0x30>
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 190:	38 ca                	cmp    %cl,%dl
 192:	74 0c                	je     1a0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 194:	83 c0 01             	add    $0x1,%eax
 197:	0f b6 10             	movzbl (%eax),%edx
 19a:	84 d2                	test   %dl,%dl
 19c:	75 f2                	jne    190 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 19e:	31 c0                	xor    %eax,%eax
}
 1a0:	5b                   	pop    %ebx
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    
 1a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 1b7:	53                   	push   %ebx
 1b8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1bb:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1be:	eb 31                	jmp    1f1 <gets+0x41>
    cc = read(0, &c, 1);
 1c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1c7:	00 
 1c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1d3:	e8 02 01 00 00       	call   2da <read>
    if(cc < 1)
 1d8:	85 c0                	test   %eax,%eax
 1da:	7e 1d                	jle    1f9 <gets+0x49>
      break;
    buf[i++] = c;
 1dc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e0:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 1e2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 1e5:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 1e7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1eb:	74 0c                	je     1f9 <gets+0x49>
 1ed:	3c 0a                	cmp    $0xa,%al
 1ef:	74 08                	je     1f9 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f1:	8d 5e 01             	lea    0x1(%esi),%ebx
 1f4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1f7:	7c c7                	jl     1c0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 200:	83 c4 2c             	add    $0x2c,%esp
 203:	5b                   	pop    %ebx
 204:	5e                   	pop    %esi
 205:	5f                   	pop    %edi
 206:	5d                   	pop    %ebp
 207:	c3                   	ret    
 208:	90                   	nop
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000210 <stat>:

int
stat(char *n, struct stat *st)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	56                   	push   %esi
 214:	53                   	push   %ebx
 215:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 222:	00 
 223:	89 04 24             	mov    %eax,(%esp)
 226:	e8 d7 00 00 00       	call   302 <open>
  if(fd < 0)
 22b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 22f:	78 27                	js     258 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 231:	8b 45 0c             	mov    0xc(%ebp),%eax
 234:	89 1c 24             	mov    %ebx,(%esp)
 237:	89 44 24 04          	mov    %eax,0x4(%esp)
 23b:	e8 da 00 00 00       	call   31a <fstat>
  close(fd);
 240:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 243:	89 c6                	mov    %eax,%esi
  close(fd);
 245:	e8 a0 00 00 00       	call   2ea <close>
  return r;
 24a:	89 f0                	mov    %esi,%eax
}
 24c:	83 c4 10             	add    $0x10,%esp
 24f:	5b                   	pop    %ebx
 250:	5e                   	pop    %esi
 251:	5d                   	pop    %ebp
 252:	c3                   	ret    
 253:	90                   	nop
 254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 25d:	eb ed                	jmp    24c <stat+0x3c>
 25f:	90                   	nop

00000260 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	8b 4d 08             	mov    0x8(%ebp),%ecx
 266:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 267:	0f be 11             	movsbl (%ecx),%edx
 26a:	8d 42 d0             	lea    -0x30(%edx),%eax
 26d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 26f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 274:	77 17                	ja     28d <atoi+0x2d>
 276:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 278:	83 c1 01             	add    $0x1,%ecx
 27b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 27e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 282:	0f be 11             	movsbl (%ecx),%edx
 285:	8d 5a d0             	lea    -0x30(%edx),%ebx
 288:	80 fb 09             	cmp    $0x9,%bl
 28b:	76 eb                	jbe    278 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 28d:	5b                   	pop    %ebx
 28e:	5d                   	pop    %ebp
 28f:	c3                   	ret    

00000290 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 290:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 291:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 293:	89 e5                	mov    %esp,%ebp
 295:	56                   	push   %esi
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	53                   	push   %ebx
 29a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 29d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a0:	85 db                	test   %ebx,%ebx
 2a2:	7e 12                	jle    2b6 <memmove+0x26>
 2a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2af:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b2:	39 da                	cmp    %ebx,%edx
 2b4:	75 f2                	jne    2a8 <memmove+0x18>
    *dst++ = *src++;
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

00000362 <cps>:
SYSCALL(cps)
 362:	b8 16 00 00 00       	mov    $0x16,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <nice>:
SYSCALL(nice)
 36a:	b8 17 00 00 00       	mov    $0x17,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    
 372:	66 90                	xchg   %ax,%ax
 374:	66 90                	xchg   %ax,%ax
 376:	66 90                	xchg   %ax,%ax
 378:	66 90                	xchg   %ax,%ax
 37a:	66 90                	xchg   %ax,%ax
 37c:	66 90                	xchg   %ax,%ax
 37e:	66 90                	xchg   %ax,%ax

00000380 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	89 c6                	mov    %eax,%esi
 387:	53                   	push   %ebx
 388:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 38e:	85 db                	test   %ebx,%ebx
 390:	74 09                	je     39b <printint+0x1b>
 392:	89 d0                	mov    %edx,%eax
 394:	c1 e8 1f             	shr    $0x1f,%eax
 397:	84 c0                	test   %al,%al
 399:	75 75                	jne    410 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 39b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 39d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3a4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3a7:	31 ff                	xor    %edi,%edi
 3a9:	89 ce                	mov    %ecx,%esi
 3ab:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3ae:	eb 02                	jmp    3b2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 3b0:	89 cf                	mov    %ecx,%edi
 3b2:	31 d2                	xor    %edx,%edx
 3b4:	f7 f6                	div    %esi
 3b6:	8d 4f 01             	lea    0x1(%edi),%ecx
 3b9:	0f b6 92 f3 07 00 00 	movzbl 0x7f3(%edx),%edx
  }while((x /= base) != 0);
 3c0:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3c2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 3c5:	75 e9                	jne    3b0 <printint+0x30>
  if(neg)
 3c7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3ca:	89 c8                	mov    %ecx,%eax
 3cc:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 3cf:	85 d2                	test   %edx,%edx
 3d1:	74 08                	je     3db <printint+0x5b>
    buf[i++] = '-';
 3d3:	8d 4f 02             	lea    0x2(%edi),%ecx
 3d6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 3db:	8d 79 ff             	lea    -0x1(%ecx),%edi
 3de:	66 90                	xchg   %ax,%ax
 3e0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 3e5:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ef:	00 
 3f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 3f4:	89 34 24             	mov    %esi,(%esp)
 3f7:	88 45 d7             	mov    %al,-0x29(%ebp)
 3fa:	e8 e3 fe ff ff       	call   2e2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3ff:	83 ff ff             	cmp    $0xffffffff,%edi
 402:	75 dc                	jne    3e0 <printint+0x60>
    putc(fd, buf[i]);
}
 404:	83 c4 4c             	add    $0x4c,%esp
 407:	5b                   	pop    %ebx
 408:	5e                   	pop    %esi
 409:	5f                   	pop    %edi
 40a:	5d                   	pop    %ebp
 40b:	c3                   	ret    
 40c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 410:	89 d0                	mov    %edx,%eax
 412:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 414:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 41b:	eb 87                	jmp    3a4 <printint+0x24>
 41d:	8d 76 00             	lea    0x0(%esi),%esi

00000420 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 424:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 426:	56                   	push   %esi
 427:	53                   	push   %ebx
 428:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 42b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 42e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 431:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 434:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 437:	0f b6 13             	movzbl (%ebx),%edx
 43a:	83 c3 01             	add    $0x1,%ebx
 43d:	84 d2                	test   %dl,%dl
 43f:	75 39                	jne    47a <printf+0x5a>
 441:	e9 c2 00 00 00       	jmp    508 <printf+0xe8>
 446:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 448:	83 fa 25             	cmp    $0x25,%edx
 44b:	0f 84 bf 00 00 00    	je     510 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 451:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 454:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 45b:	00 
 45c:	89 44 24 04          	mov    %eax,0x4(%esp)
 460:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 463:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 466:	e8 77 fe ff ff       	call   2e2 <write>
 46b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 46e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 472:	84 d2                	test   %dl,%dl
 474:	0f 84 8e 00 00 00    	je     508 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 47a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 47c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 47f:	74 c7                	je     448 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 481:	83 ff 25             	cmp    $0x25,%edi
 484:	75 e5                	jne    46b <printf+0x4b>
      if(c == 'd'){
 486:	83 fa 64             	cmp    $0x64,%edx
 489:	0f 84 31 01 00 00    	je     5c0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 48f:	25 f7 00 00 00       	and    $0xf7,%eax
 494:	83 f8 70             	cmp    $0x70,%eax
 497:	0f 84 83 00 00 00    	je     520 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 49d:	83 fa 73             	cmp    $0x73,%edx
 4a0:	0f 84 a2 00 00 00    	je     548 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4a6:	83 fa 63             	cmp    $0x63,%edx
 4a9:	0f 84 35 01 00 00    	je     5e4 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4af:	83 fa 25             	cmp    $0x25,%edx
 4b2:	0f 84 e0 00 00 00    	je     598 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4b8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4bb:	83 c3 01             	add    $0x1,%ebx
 4be:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4c5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c6:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cc:	89 34 24             	mov    %esi,(%esp)
 4cf:	89 55 d0             	mov    %edx,-0x30(%ebp)
 4d2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 4d6:	e8 07 fe ff ff       	call   2e2 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4db:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4de:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e8:	00 
 4e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ed:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4f0:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f3:	e8 ea fd ff ff       	call   2e2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4f8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 4fc:	84 d2                	test   %dl,%dl
 4fe:	0f 85 76 ff ff ff    	jne    47a <printf+0x5a>
 504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 508:	83 c4 3c             	add    $0x3c,%esp
 50b:	5b                   	pop    %ebx
 50c:	5e                   	pop    %esi
 50d:	5f                   	pop    %edi
 50e:	5d                   	pop    %ebp
 50f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 510:	bf 25 00 00 00       	mov    $0x25,%edi
 515:	e9 51 ff ff ff       	jmp    46b <printf+0x4b>
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 520:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 523:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 528:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 52a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 531:	8b 10                	mov    (%eax),%edx
 533:	89 f0                	mov    %esi,%eax
 535:	e8 46 fe ff ff       	call   380 <printint>
        ap++;
 53a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 53e:	e9 28 ff ff ff       	jmp    46b <printf+0x4b>
 543:	90                   	nop
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 548:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 54b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 54f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 551:	b8 ec 07 00 00       	mov    $0x7ec,%eax
 556:	85 ff                	test   %edi,%edi
 558:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 55b:	0f b6 07             	movzbl (%edi),%eax
 55e:	84 c0                	test   %al,%al
 560:	74 2a                	je     58c <printf+0x16c>
 562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 568:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 56b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 56e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 571:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 578:	00 
 579:	89 44 24 04          	mov    %eax,0x4(%esp)
 57d:	89 34 24             	mov    %esi,(%esp)
 580:	e8 5d fd ff ff       	call   2e2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 585:	0f b6 07             	movzbl (%edi),%eax
 588:	84 c0                	test   %al,%al
 58a:	75 dc                	jne    568 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 58c:	31 ff                	xor    %edi,%edi
 58e:	e9 d8 fe ff ff       	jmp    46b <printf+0x4b>
 593:	90                   	nop
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 598:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 59b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 59d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5a4:	00 
 5a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a9:	89 34 24             	mov    %esi,(%esp)
 5ac:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 5b0:	e8 2d fd ff ff       	call   2e2 <write>
 5b5:	e9 b1 fe ff ff       	jmp    46b <printf+0x4b>
 5ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5d2:	8b 10                	mov    (%eax),%edx
 5d4:	89 f0                	mov    %esi,%eax
 5d6:	e8 a5 fd ff ff       	call   380 <printint>
        ap++;
 5db:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5df:	e9 87 fe ff ff       	jmp    46b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5e7:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5e9:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5f2:	00 
 5f3:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5f6:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5f9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 600:	e8 dd fc ff ff       	call   2e2 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 605:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 609:	e9 5d fe ff ff       	jmp    46b <printf+0x4b>
 60e:	66 90                	xchg   %ax,%ax

00000610 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 610:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	a1 6c 0a 00 00       	mov    0xa6c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 616:	89 e5                	mov    %esp,%ebp
 618:	57                   	push   %edi
 619:	56                   	push   %esi
 61a:	53                   	push   %ebx
 61b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 620:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 623:	39 d0                	cmp    %edx,%eax
 625:	72 11                	jb     638 <free+0x28>
 627:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 628:	39 c8                	cmp    %ecx,%eax
 62a:	72 04                	jb     630 <free+0x20>
 62c:	39 ca                	cmp    %ecx,%edx
 62e:	72 10                	jb     640 <free+0x30>
 630:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 632:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 634:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 636:	73 f0                	jae    628 <free+0x18>
 638:	39 ca                	cmp    %ecx,%edx
 63a:	72 04                	jb     640 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63c:	39 c8                	cmp    %ecx,%eax
 63e:	72 f0                	jb     630 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 640:	8b 73 fc             	mov    -0x4(%ebx),%esi
 643:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 646:	39 cf                	cmp    %ecx,%edi
 648:	74 1e                	je     668 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 64a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 64d:	8b 48 04             	mov    0x4(%eax),%ecx
 650:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 653:	39 f2                	cmp    %esi,%edx
 655:	74 28                	je     67f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 657:	89 10                	mov    %edx,(%eax)
  freep = p;
 659:	a3 6c 0a 00 00       	mov    %eax,0xa6c
}
 65e:	5b                   	pop    %ebx
 65f:	5e                   	pop    %esi
 660:	5f                   	pop    %edi
 661:	5d                   	pop    %ebp
 662:	c3                   	ret    
 663:	90                   	nop
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 668:	03 71 04             	add    0x4(%ecx),%esi
 66b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 66e:	8b 08                	mov    (%eax),%ecx
 670:	8b 09                	mov    (%ecx),%ecx
 672:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 675:	8b 48 04             	mov    0x4(%eax),%ecx
 678:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 67b:	39 f2                	cmp    %esi,%edx
 67d:	75 d8                	jne    657 <free+0x47>
    p->s.size += bp->s.size;
 67f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 682:	a3 6c 0a 00 00       	mov    %eax,0xa6c
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 687:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 68a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 68d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 68f:	5b                   	pop    %ebx
 690:	5e                   	pop    %esi
 691:	5f                   	pop    %edi
 692:	5d                   	pop    %ebp
 693:	c3                   	ret    
 694:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 69a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000006a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
 6a6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6ac:	8b 1d 6c 0a 00 00    	mov    0xa6c,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b2:	8d 48 07             	lea    0x7(%eax),%ecx
 6b5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 6b8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ba:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 6bd:	0f 84 9b 00 00 00    	je     75e <malloc+0xbe>
 6c3:	8b 13                	mov    (%ebx),%edx
 6c5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6c8:	39 fe                	cmp    %edi,%esi
 6ca:	76 64                	jbe    730 <malloc+0x90>
 6cc:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 6d3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 6d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 6db:	eb 0e                	jmp    6eb <malloc+0x4b>
 6dd:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6e2:	8b 78 04             	mov    0x4(%eax),%edi
 6e5:	39 fe                	cmp    %edi,%esi
 6e7:	76 4f                	jbe    738 <malloc+0x98>
 6e9:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6eb:	3b 15 6c 0a 00 00    	cmp    0xa6c,%edx
 6f1:	75 ed                	jne    6e0 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 6f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6fc:	bf 00 10 00 00       	mov    $0x1000,%edi
 701:	0f 43 fe             	cmovae %esi,%edi
 704:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 707:	89 04 24             	mov    %eax,(%esp)
 70a:	e8 3b fc ff ff       	call   34a <sbrk>
  if(p == (char*)-1)
 70f:	83 f8 ff             	cmp    $0xffffffff,%eax
 712:	74 18                	je     72c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 714:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 717:	83 c0 08             	add    $0x8,%eax
 71a:	89 04 24             	mov    %eax,(%esp)
 71d:	e8 ee fe ff ff       	call   610 <free>
  return freep;
 722:	8b 15 6c 0a 00 00    	mov    0xa6c,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 728:	85 d2                	test   %edx,%edx
 72a:	75 b4                	jne    6e0 <malloc+0x40>
        return 0;
 72c:	31 c0                	xor    %eax,%eax
 72e:	eb 20                	jmp    750 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 730:	89 d0                	mov    %edx,%eax
 732:	89 da                	mov    %ebx,%edx
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 738:	39 fe                	cmp    %edi,%esi
 73a:	74 1c                	je     758 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 73c:	29 f7                	sub    %esi,%edi
 73e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 741:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 744:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 747:	89 15 6c 0a 00 00    	mov    %edx,0xa6c
      return (void*)(p + 1);
 74d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 750:	83 c4 1c             	add    $0x1c,%esp
 753:	5b                   	pop    %ebx
 754:	5e                   	pop    %esi
 755:	5f                   	pop    %edi
 756:	5d                   	pop    %ebp
 757:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 758:	8b 08                	mov    (%eax),%ecx
 75a:	89 0a                	mov    %ecx,(%edx)
 75c:	eb e9                	jmp    747 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 75e:	c7 05 6c 0a 00 00 70 	movl   $0xa70,0xa6c
 765:	0a 00 00 
    base.s.size = 0;
 768:	ba 70 0a 00 00       	mov    $0xa70,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 76d:	c7 05 70 0a 00 00 70 	movl   $0xa70,0xa70
 774:	0a 00 00 
    base.s.size = 0;
 777:	c7 05 74 0a 00 00 00 	movl   $0x0,0xa74
 77e:	00 00 00 
 781:	e9 46 ff ff ff       	jmp    6cc <malloc+0x2c>
