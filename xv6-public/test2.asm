
_test2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
        }
        i++;
    }
}

int main() {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
    int max_time = 1000;

    // Creating 3 children with same priority
    int p1 = fork();
   9:	e8 ec 02 00 00       	call   2fa <fork>
    if (p1 == 0) {
   e:	85 c0                	test   %eax,%eax
  10:	74 09                	je     1b <main+0x1b>
        find_primes(2, max_time); 
        exit();
    }

  
    int p2 = fork();
  12:	e8 e3 02 00 00       	call   2fa <fork>
    if (p2 == 0) {
  17:	85 c0                	test   %eax,%eax
  19:	75 14                	jne    2f <main+0x2f>
    int max_time = 1000;

    // Creating 3 children with same priority
    int p1 = fork();
    if (p1 == 0) {
        find_primes(2, max_time); 
  1b:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
  22:	00 
  23:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  2a:	e8 21 00 00 00       	call   50 <find_primes>
    if (p2 == 0) {
        find_primes(2, max_time);
        exit();
    }

    int p3 = fork();
  2f:	e8 c6 02 00 00       	call   2fa <fork>
    if (p3 == 0) {
  34:	85 c0                	test   %eax,%eax
  36:	74 e3                	je     1b <main+0x1b>
        find_primes(2, max_time);
        exit();
    }
    while(wait()!=-1);
  38:	e8 cd 02 00 00       	call   30a <wait>
  3d:	83 f8 ff             	cmp    $0xffffffff,%eax
  40:	75 f6                	jne    38 <main+0x38>
    exit();
  42:	e8 bb 02 00 00       	call   302 <exit>
  47:	66 90                	xchg   %ax,%ax
  49:	66 90                	xchg   %ax,%ax
  4b:	66 90                	xchg   %ax,%ax
  4d:	66 90                	xchg   %ax,%ax
  4f:	90                   	nop

00000050 <find_primes>:
#include "types.h"
#include "stat.h"
#include "user.h"

// Function to calculate and print prime numbers
void find_primes(int priority, int t) {
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	57                   	push   %edi
  54:	56                   	push   %esi
  55:	53                   	push   %ebx
  56:	83 ec 2c             	sub    $0x2c,%esp
  59:	8b 75 0c             	mov    0xc(%ebp),%esi
    int pid = getpid();
  5c:	e8 21 03 00 00       	call   382 <getpid>
  61:	89 c7                	mov    %eax,%edi
    // Set the process priority using the nice system call
    nice(pid, priority);
  63:	8b 45 08             	mov    0x8(%ebp),%eax
  66:	89 3c 24             	mov    %edi,(%esp)
  69:	89 44 24 04          	mov    %eax,0x4(%esp)
  6d:	e8 38 03 00 00       	call   3aa <nice>

    int start_time = uptime();
  72:	e8 23 03 00 00       	call   39a <uptime>
    int i = 1;

    printf(1, "Started Current PID: %d, Priority: %d\n", pid, priority);
  77:	89 7c 24 08          	mov    %edi,0x8(%esp)
  7b:	c7 44 24 04 c8 07 00 	movl   $0x7c8,0x4(%esp)
  82:	00 
  83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void find_primes(int priority, int t) {
    int pid = getpid();
    // Set the process priority using the nice system call
    nice(pid, priority);

    int start_time = uptime();
  8a:	89 c3                	mov    %eax,%ebx
    int i = 1;

    printf(1, "Started Current PID: %d, Priority: %d\n", pid, priority);
  8c:	8b 45 08             	mov    0x8(%ebp),%eax
  8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  93:	e8 c8 03 00 00       	call   460 <printf>
            if (i % j == 0) {
                break;
            }
        }

        int current_time = uptime();
  98:	e8 fd 02 00 00       	call   39a <uptime>
        if (current_time - start_time >= t) {
  9d:	29 d8                	sub    %ebx,%eax
  9f:	39 f0                	cmp    %esi,%eax
  a1:	7c f5                	jl     98 <find_primes+0x48>
            int end_time = uptime();
  a3:	e8 f2 02 00 00       	call   39a <uptime>
            int execution_time = end_time - start_time;
            printf(1, "Finished Current PID: %d, Priority: %d, Execution Time: %d\n", pid, priority, execution_time);
  a8:	89 7c 24 08          	mov    %edi,0x8(%esp)
  ac:	c7 44 24 04 f0 07 00 	movl   $0x7f0,0x4(%esp)
  b3:	00 
  b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
        }

        int current_time = uptime();
        if (current_time - start_time >= t) {
            int end_time = uptime();
            int execution_time = end_time - start_time;
  bb:	29 d8                	sub    %ebx,%eax
            printf(1, "Finished Current PID: %d, Priority: %d, Execution Time: %d\n", pid, priority, execution_time);
  bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  c8:	e8 93 03 00 00       	call   460 <printf>
            exit();
  cd:	e8 30 02 00 00       	call   302 <exit>
  d2:	66 90                	xchg   %ax,%ax
  d4:	66 90                	xchg   %ax,%ax
  d6:	66 90                	xchg   %ax,%ax
  d8:	66 90                	xchg   %ax,%ax
  da:	66 90                	xchg   %ax,%ax
  dc:	66 90                	xchg   %ax,%ax
  de:	66 90                	xchg   %ax,%ax

000000e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  e9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ea:	89 c2                	mov    %eax,%edx
  ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f0:	83 c1 01             	add    $0x1,%ecx
  f3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  f7:	83 c2 01             	add    $0x1,%edx
  fa:	84 db                	test   %bl,%bl
  fc:	88 5a ff             	mov    %bl,-0x1(%edx)
  ff:	75 ef                	jne    f0 <strcpy+0x10>
    ;
  return os;
}
 101:	5b                   	pop    %ebx
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    
 104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 10a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 55 08             	mov    0x8(%ebp),%edx
 116:	53                   	push   %ebx
 117:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 11a:	0f b6 02             	movzbl (%edx),%eax
 11d:	84 c0                	test   %al,%al
 11f:	74 2d                	je     14e <strcmp+0x3e>
 121:	0f b6 19             	movzbl (%ecx),%ebx
 124:	38 d8                	cmp    %bl,%al
 126:	74 0e                	je     136 <strcmp+0x26>
 128:	eb 2b                	jmp    155 <strcmp+0x45>
 12a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 130:	38 c8                	cmp    %cl,%al
 132:	75 15                	jne    149 <strcmp+0x39>
    p++, q++;
 134:	89 d9                	mov    %ebx,%ecx
 136:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 139:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 13c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 13f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 143:	84 c0                	test   %al,%al
 145:	75 e9                	jne    130 <strcmp+0x20>
 147:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 149:	29 c8                	sub    %ecx,%eax
}
 14b:	5b                   	pop    %ebx
 14c:	5d                   	pop    %ebp
 14d:	c3                   	ret    
 14e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 151:	31 c0                	xor    %eax,%eax
 153:	eb f4                	jmp    149 <strcmp+0x39>
 155:	0f b6 cb             	movzbl %bl,%ecx
 158:	eb ef                	jmp    149 <strcmp+0x39>
 15a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000160 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 166:	80 39 00             	cmpb   $0x0,(%ecx)
 169:	74 12                	je     17d <strlen+0x1d>
 16b:	31 d2                	xor    %edx,%edx
 16d:	8d 76 00             	lea    0x0(%esi),%esi
 170:	83 c2 01             	add    $0x1,%edx
 173:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 177:	89 d0                	mov    %edx,%eax
 179:	75 f5                	jne    170 <strlen+0x10>
    ;
  return n;
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 17d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 17f:	5d                   	pop    %ebp
 180:	c3                   	ret    
 181:	eb 0d                	jmp    190 <memset>
 183:	90                   	nop
 184:	90                   	nop
 185:	90                   	nop
 186:	90                   	nop
 187:	90                   	nop
 188:	90                   	nop
 189:	90                   	nop
 18a:	90                   	nop
 18b:	90                   	nop
 18c:	90                   	nop
 18d:	90                   	nop
 18e:	90                   	nop
 18f:	90                   	nop

00000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 55 08             	mov    0x8(%ebp),%edx
 196:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 197:	8b 4d 10             	mov    0x10(%ebp),%ecx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	89 d7                	mov    %edx,%edi
 19f:	fc                   	cld    
 1a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a2:	89 d0                	mov    %edx,%eax
 1a4:	5f                   	pop    %edi
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    
 1a7:	89 f6                	mov    %esi,%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	53                   	push   %ebx
 1b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 1ba:	0f b6 18             	movzbl (%eax),%ebx
 1bd:	84 db                	test   %bl,%bl
 1bf:	74 1d                	je     1de <strchr+0x2e>
    if(*s == c)
 1c1:	38 d3                	cmp    %dl,%bl
 1c3:	89 d1                	mov    %edx,%ecx
 1c5:	75 0d                	jne    1d4 <strchr+0x24>
 1c7:	eb 17                	jmp    1e0 <strchr+0x30>
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1d0:	38 ca                	cmp    %cl,%dl
 1d2:	74 0c                	je     1e0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1d4:	83 c0 01             	add    $0x1,%eax
 1d7:	0f b6 10             	movzbl (%eax),%edx
 1da:	84 d2                	test   %dl,%dl
 1dc:	75 f2                	jne    1d0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 1de:	31 c0                	xor    %eax,%eax
}
 1e0:	5b                   	pop    %ebx
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    
 1e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 1f7:	53                   	push   %ebx
 1f8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1fb:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fe:	eb 31                	jmp    231 <gets+0x41>
    cc = read(0, &c, 1);
 200:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 207:	00 
 208:	89 7c 24 04          	mov    %edi,0x4(%esp)
 20c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 213:	e8 02 01 00 00       	call   31a <read>
    if(cc < 1)
 218:	85 c0                	test   %eax,%eax
 21a:	7e 1d                	jle    239 <gets+0x49>
      break;
    buf[i++] = c;
 21c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 220:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 222:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 225:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 227:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 22b:	74 0c                	je     239 <gets+0x49>
 22d:	3c 0a                	cmp    $0xa,%al
 22f:	74 08                	je     239 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 231:	8d 5e 01             	lea    0x1(%esi),%ebx
 234:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 237:	7c c7                	jl     200 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 240:	83 c4 2c             	add    $0x2c,%esp
 243:	5b                   	pop    %ebx
 244:	5e                   	pop    %esi
 245:	5f                   	pop    %edi
 246:	5d                   	pop    %ebp
 247:	c3                   	ret    
 248:	90                   	nop
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000250 <stat>:

int
stat(char *n, struct stat *st)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	56                   	push   %esi
 254:	53                   	push   %ebx
 255:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 262:	00 
 263:	89 04 24             	mov    %eax,(%esp)
 266:	e8 d7 00 00 00       	call   342 <open>
  if(fd < 0)
 26b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 26f:	78 27                	js     298 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 271:	8b 45 0c             	mov    0xc(%ebp),%eax
 274:	89 1c 24             	mov    %ebx,(%esp)
 277:	89 44 24 04          	mov    %eax,0x4(%esp)
 27b:	e8 da 00 00 00       	call   35a <fstat>
  close(fd);
 280:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 283:	89 c6                	mov    %eax,%esi
  close(fd);
 285:	e8 a0 00 00 00       	call   32a <close>
  return r;
 28a:	89 f0                	mov    %esi,%eax
}
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	5b                   	pop    %ebx
 290:	5e                   	pop    %esi
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    
 293:	90                   	nop
 294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29d:	eb ed                	jmp    28c <stat+0x3c>
 29f:	90                   	nop

000002a0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2a6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a7:	0f be 11             	movsbl (%ecx),%edx
 2aa:	8d 42 d0             	lea    -0x30(%edx),%eax
 2ad:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 2af:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2b4:	77 17                	ja     2cd <atoi+0x2d>
 2b6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2b8:	83 c1 01             	add    $0x1,%ecx
 2bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2be:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c2:	0f be 11             	movsbl (%ecx),%edx
 2c5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2c8:	80 fb 09             	cmp    $0x9,%bl
 2cb:	76 eb                	jbe    2b8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 2cd:	5b                   	pop    %ebx
 2ce:	5d                   	pop    %ebp
 2cf:	c3                   	ret    

000002d0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	56                   	push   %esi
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	53                   	push   %ebx
 2da:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e0:	85 db                	test   %ebx,%ebx
 2e2:	7e 12                	jle    2f6 <memmove+0x26>
 2e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2ef:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f2:	39 da                	cmp    %ebx,%edx
 2f4:	75 f2                	jne    2e8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 2f6:	5b                   	pop    %ebx
 2f7:	5e                   	pop    %esi
 2f8:	5d                   	pop    %ebp
 2f9:	c3                   	ret    

000002fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2fa:	b8 01 00 00 00       	mov    $0x1,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <exit>:
SYSCALL(exit)
 302:	b8 02 00 00 00       	mov    $0x2,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <wait>:
SYSCALL(wait)
 30a:	b8 03 00 00 00       	mov    $0x3,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <pipe>:
SYSCALL(pipe)
 312:	b8 04 00 00 00       	mov    $0x4,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <read>:
SYSCALL(read)
 31a:	b8 05 00 00 00       	mov    $0x5,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <write>:
SYSCALL(write)
 322:	b8 10 00 00 00       	mov    $0x10,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <close>:
SYSCALL(close)
 32a:	b8 15 00 00 00       	mov    $0x15,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <kill>:
SYSCALL(kill)
 332:	b8 06 00 00 00       	mov    $0x6,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <exec>:
SYSCALL(exec)
 33a:	b8 07 00 00 00       	mov    $0x7,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <open>:
SYSCALL(open)
 342:	b8 0f 00 00 00       	mov    $0xf,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <mknod>:
SYSCALL(mknod)
 34a:	b8 11 00 00 00       	mov    $0x11,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <unlink>:
SYSCALL(unlink)
 352:	b8 12 00 00 00       	mov    $0x12,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <fstat>:
SYSCALL(fstat)
 35a:	b8 08 00 00 00       	mov    $0x8,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <link>:
SYSCALL(link)
 362:	b8 13 00 00 00       	mov    $0x13,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <mkdir>:
SYSCALL(mkdir)
 36a:	b8 14 00 00 00       	mov    $0x14,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <chdir>:
SYSCALL(chdir)
 372:	b8 09 00 00 00       	mov    $0x9,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <dup>:
SYSCALL(dup)
 37a:	b8 0a 00 00 00       	mov    $0xa,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <getpid>:
SYSCALL(getpid)
 382:	b8 0b 00 00 00       	mov    $0xb,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <sbrk>:
SYSCALL(sbrk)
 38a:	b8 0c 00 00 00       	mov    $0xc,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <sleep>:
SYSCALL(sleep)
 392:	b8 0d 00 00 00       	mov    $0xd,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <uptime>:
SYSCALL(uptime)
 39a:	b8 0e 00 00 00       	mov    $0xe,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <cps>:
SYSCALL(cps)
 3a2:	b8 16 00 00 00       	mov    $0x16,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <nice>:
SYSCALL(nice)
 3aa:	b8 17 00 00 00       	mov    $0x17,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    
 3b2:	66 90                	xchg   %ax,%ax
 3b4:	66 90                	xchg   %ax,%ax
 3b6:	66 90                	xchg   %ax,%ax
 3b8:	66 90                	xchg   %ax,%ax
 3ba:	66 90                	xchg   %ax,%ax
 3bc:	66 90                	xchg   %ax,%ax
 3be:	66 90                	xchg   %ax,%ax

000003c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	56                   	push   %esi
 3c5:	89 c6                	mov    %eax,%esi
 3c7:	53                   	push   %ebx
 3c8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3ce:	85 db                	test   %ebx,%ebx
 3d0:	74 09                	je     3db <printint+0x1b>
 3d2:	89 d0                	mov    %edx,%eax
 3d4:	c1 e8 1f             	shr    $0x1f,%eax
 3d7:	84 c0                	test   %al,%al
 3d9:	75 75                	jne    450 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3db:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3dd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3e4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3e7:	31 ff                	xor    %edi,%edi
 3e9:	89 ce                	mov    %ecx,%esi
 3eb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3ee:	eb 02                	jmp    3f2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 3f0:	89 cf                	mov    %ecx,%edi
 3f2:	31 d2                	xor    %edx,%edx
 3f4:	f7 f6                	div    %esi
 3f6:	8d 4f 01             	lea    0x1(%edi),%ecx
 3f9:	0f b6 92 33 08 00 00 	movzbl 0x833(%edx),%edx
  }while((x /= base) != 0);
 400:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 402:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 405:	75 e9                	jne    3f0 <printint+0x30>
  if(neg)
 407:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 40a:	89 c8                	mov    %ecx,%eax
 40c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 40f:	85 d2                	test   %edx,%edx
 411:	74 08                	je     41b <printint+0x5b>
    buf[i++] = '-';
 413:	8d 4f 02             	lea    0x2(%edi),%ecx
 416:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 41b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 41e:	66 90                	xchg   %ax,%ax
 420:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 425:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 428:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 42f:	00 
 430:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 434:	89 34 24             	mov    %esi,(%esp)
 437:	88 45 d7             	mov    %al,-0x29(%ebp)
 43a:	e8 e3 fe ff ff       	call   322 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 43f:	83 ff ff             	cmp    $0xffffffff,%edi
 442:	75 dc                	jne    420 <printint+0x60>
    putc(fd, buf[i]);
}
 444:	83 c4 4c             	add    $0x4c,%esp
 447:	5b                   	pop    %ebx
 448:	5e                   	pop    %esi
 449:	5f                   	pop    %edi
 44a:	5d                   	pop    %ebp
 44b:	c3                   	ret    
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 450:	89 d0                	mov    %edx,%eax
 452:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 454:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 45b:	eb 87                	jmp    3e4 <printint+0x24>
 45d:	8d 76 00             	lea    0x0(%esi),%esi

00000460 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 464:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 466:	56                   	push   %esi
 467:	53                   	push   %ebx
 468:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 46b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 46e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 471:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 474:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 477:	0f b6 13             	movzbl (%ebx),%edx
 47a:	83 c3 01             	add    $0x1,%ebx
 47d:	84 d2                	test   %dl,%dl
 47f:	75 39                	jne    4ba <printf+0x5a>
 481:	e9 c2 00 00 00       	jmp    548 <printf+0xe8>
 486:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 488:	83 fa 25             	cmp    $0x25,%edx
 48b:	0f 84 bf 00 00 00    	je     550 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 491:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 494:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 49b:	00 
 49c:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4a3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a6:	e8 77 fe ff ff       	call   322 <write>
 4ab:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4ae:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 4b2:	84 d2                	test   %dl,%dl
 4b4:	0f 84 8e 00 00 00    	je     548 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 4ba:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4bc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 4bf:	74 c7                	je     488 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c1:	83 ff 25             	cmp    $0x25,%edi
 4c4:	75 e5                	jne    4ab <printf+0x4b>
      if(c == 'd'){
 4c6:	83 fa 64             	cmp    $0x64,%edx
 4c9:	0f 84 31 01 00 00    	je     600 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4cf:	25 f7 00 00 00       	and    $0xf7,%eax
 4d4:	83 f8 70             	cmp    $0x70,%eax
 4d7:	0f 84 83 00 00 00    	je     560 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4dd:	83 fa 73             	cmp    $0x73,%edx
 4e0:	0f 84 a2 00 00 00    	je     588 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4e6:	83 fa 63             	cmp    $0x63,%edx
 4e9:	0f 84 35 01 00 00    	je     624 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4ef:	83 fa 25             	cmp    $0x25,%edx
 4f2:	0f 84 e0 00 00 00    	je     5d8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4fb:	83 c3 01             	add    $0x1,%ebx
 4fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 505:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 506:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 508:	89 44 24 04          	mov    %eax,0x4(%esp)
 50c:	89 34 24             	mov    %esi,(%esp)
 50f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 512:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 516:	e8 07 fe ff ff       	call   322 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 51b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 51e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 521:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 528:	00 
 529:	89 44 24 04          	mov    %eax,0x4(%esp)
 52d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 530:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 533:	e8 ea fd ff ff       	call   322 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 538:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 53c:	84 d2                	test   %dl,%dl
 53e:	0f 85 76 ff ff ff    	jne    4ba <printf+0x5a>
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 548:	83 c4 3c             	add    $0x3c,%esp
 54b:	5b                   	pop    %ebx
 54c:	5e                   	pop    %esi
 54d:	5f                   	pop    %edi
 54e:	5d                   	pop    %ebp
 54f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 550:	bf 25 00 00 00       	mov    $0x25,%edi
 555:	e9 51 ff ff ff       	jmp    4ab <printf+0x4b>
 55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 560:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 563:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 568:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 56a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 571:	8b 10                	mov    (%eax),%edx
 573:	89 f0                	mov    %esi,%eax
 575:	e8 46 fe ff ff       	call   3c0 <printint>
        ap++;
 57a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 57e:	e9 28 ff ff ff       	jmp    4ab <printf+0x4b>
 583:	90                   	nop
 584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 58b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 58f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 591:	b8 2c 08 00 00       	mov    $0x82c,%eax
 596:	85 ff                	test   %edi,%edi
 598:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 59b:	0f b6 07             	movzbl (%edi),%eax
 59e:	84 c0                	test   %al,%al
 5a0:	74 2a                	je     5cc <printf+0x16c>
 5a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5a8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ab:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 5ae:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5b8:	00 
 5b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bd:	89 34 24             	mov    %esi,(%esp)
 5c0:	e8 5d fd ff ff       	call   322 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5c5:	0f b6 07             	movzbl (%edi),%eax
 5c8:	84 c0                	test   %al,%al
 5ca:	75 dc                	jne    5a8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5cc:	31 ff                	xor    %edi,%edi
 5ce:	e9 d8 fe ff ff       	jmp    4ab <printf+0x4b>
 5d3:	90                   	nop
 5d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5db:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5dd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5e4:	00 
 5e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e9:	89 34 24             	mov    %esi,(%esp)
 5ec:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 5f0:	e8 2d fd ff ff       	call   322 <write>
 5f5:	e9 b1 fe ff ff       	jmp    4ab <printf+0x4b>
 5fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 600:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 603:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 608:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 60b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 612:	8b 10                	mov    (%eax),%edx
 614:	89 f0                	mov    %esi,%eax
 616:	e8 a5 fd ff ff       	call   3c0 <printint>
        ap++;
 61b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 61f:	e9 87 fe ff ff       	jmp    4ab <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 624:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 627:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 629:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 62b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 632:	00 
 633:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 636:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 639:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 63c:	89 44 24 04          	mov    %eax,0x4(%esp)
 640:	e8 dd fc ff ff       	call   322 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 645:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 649:	e9 5d fe ff ff       	jmp    4ab <printf+0x4b>
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
 651:	a1 c8 0a 00 00       	mov    0xac8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 656:	89 e5                	mov    %esp,%ebp
 658:	57                   	push   %edi
 659:	56                   	push   %esi
 65a:	53                   	push   %ebx
 65b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 660:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 663:	39 d0                	cmp    %edx,%eax
 665:	72 11                	jb     678 <free+0x28>
 667:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 668:	39 c8                	cmp    %ecx,%eax
 66a:	72 04                	jb     670 <free+0x20>
 66c:	39 ca                	cmp    %ecx,%edx
 66e:	72 10                	jb     680 <free+0x30>
 670:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 672:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 674:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 676:	73 f0                	jae    668 <free+0x18>
 678:	39 ca                	cmp    %ecx,%edx
 67a:	72 04                	jb     680 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67c:	39 c8                	cmp    %ecx,%eax
 67e:	72 f0                	jb     670 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 680:	8b 73 fc             	mov    -0x4(%ebx),%esi
 683:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 686:	39 cf                	cmp    %ecx,%edi
 688:	74 1e                	je     6a8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 68a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 68d:	8b 48 04             	mov    0x4(%eax),%ecx
 690:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 693:	39 f2                	cmp    %esi,%edx
 695:	74 28                	je     6bf <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 697:	89 10                	mov    %edx,(%eax)
  freep = p;
 699:	a3 c8 0a 00 00       	mov    %eax,0xac8
}
 69e:	5b                   	pop    %ebx
 69f:	5e                   	pop    %esi
 6a0:	5f                   	pop    %edi
 6a1:	5d                   	pop    %ebp
 6a2:	c3                   	ret    
 6a3:	90                   	nop
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6a8:	03 71 04             	add    0x4(%ecx),%esi
 6ab:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ae:	8b 08                	mov    (%eax),%ecx
 6b0:	8b 09                	mov    (%ecx),%ecx
 6b2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6b5:	8b 48 04             	mov    0x4(%eax),%ecx
 6b8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6bb:	39 f2                	cmp    %esi,%edx
 6bd:	75 d8                	jne    697 <free+0x47>
    p->s.size += bp->s.size;
 6bf:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6c2:	a3 c8 0a 00 00       	mov    %eax,0xac8
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ca:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6cd:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6cf:	5b                   	pop    %ebx
 6d0:	5e                   	pop    %esi
 6d1:	5f                   	pop    %edi
 6d2:	5d                   	pop    %ebp
 6d3:	c3                   	ret    
 6d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

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
 6e6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6ec:	8b 1d c8 0a 00 00    	mov    0xac8,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f2:	8d 48 07             	lea    0x7(%eax),%ecx
 6f5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 6f8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6fa:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 6fd:	0f 84 9b 00 00 00    	je     79e <malloc+0xbe>
 703:	8b 13                	mov    (%ebx),%edx
 705:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 708:	39 fe                	cmp    %edi,%esi
 70a:	76 64                	jbe    770 <malloc+0x90>
 70c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 713:	bb 00 80 00 00       	mov    $0x8000,%ebx
 718:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 71b:	eb 0e                	jmp    72b <malloc+0x4b>
 71d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 720:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 722:	8b 78 04             	mov    0x4(%eax),%edi
 725:	39 fe                	cmp    %edi,%esi
 727:	76 4f                	jbe    778 <malloc+0x98>
 729:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 72b:	3b 15 c8 0a 00 00    	cmp    0xac8,%edx
 731:	75 ed                	jne    720 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 736:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 73c:	bf 00 10 00 00       	mov    $0x1000,%edi
 741:	0f 43 fe             	cmovae %esi,%edi
 744:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 747:	89 04 24             	mov    %eax,(%esp)
 74a:	e8 3b fc ff ff       	call   38a <sbrk>
  if(p == (char*)-1)
 74f:	83 f8 ff             	cmp    $0xffffffff,%eax
 752:	74 18                	je     76c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 754:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 757:	83 c0 08             	add    $0x8,%eax
 75a:	89 04 24             	mov    %eax,(%esp)
 75d:	e8 ee fe ff ff       	call   650 <free>
  return freep;
 762:	8b 15 c8 0a 00 00    	mov    0xac8,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 768:	85 d2                	test   %edx,%edx
 76a:	75 b4                	jne    720 <malloc+0x40>
        return 0;
 76c:	31 c0                	xor    %eax,%eax
 76e:	eb 20                	jmp    790 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 770:	89 d0                	mov    %edx,%eax
 772:	89 da                	mov    %ebx,%edx
 774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 778:	39 fe                	cmp    %edi,%esi
 77a:	74 1c                	je     798 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 77c:	29 f7                	sub    %esi,%edi
 77e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 781:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 784:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 787:	89 15 c8 0a 00 00    	mov    %edx,0xac8
      return (void*)(p + 1);
 78d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 790:	83 c4 1c             	add    $0x1c,%esp
 793:	5b                   	pop    %ebx
 794:	5e                   	pop    %esi
 795:	5f                   	pop    %edi
 796:	5d                   	pop    %ebp
 797:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 798:	8b 08                	mov    (%eax),%ecx
 79a:	89 0a                	mov    %ecx,(%edx)
 79c:	eb e9                	jmp    787 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 79e:	c7 05 c8 0a 00 00 cc 	movl   $0xacc,0xac8
 7a5:	0a 00 00 
    base.s.size = 0;
 7a8:	ba cc 0a 00 00       	mov    $0xacc,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7ad:	c7 05 cc 0a 00 00 cc 	movl   $0xacc,0xacc
 7b4:	0a 00 00 
    base.s.size = 0;
 7b7:	c7 05 d0 0a 00 00 00 	movl   $0x0,0xad0
 7be:	00 00 00 
 7c1:	e9 46 ff ff ff       	jmp    70c <malloc+0x2c>
