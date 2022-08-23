
obj/p-fork.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:
extern uint8_t end[];

uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	53                   	push   %rbx
  100005:	48 83 ec 08          	sub    $0x8,%rsp
// sys_fork()
//    Fork the current process. On success, return the child's process ID to
//    the parent, and return 0 to the child. On failure, return -1.
static inline pid_t sys_fork(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100009:	cd 34                	int    $0x34
    // Fork a total of three new copies.
    pid_t p1 = sys_fork();
    assert(p1 >= 0);
  10000b:	85 c0                	test   %eax,%eax
  10000d:	78 50                	js     10005f <process_main+0x5f>
  10000f:	89 c2                	mov    %eax,%edx
  100011:	cd 34                	int    $0x34
  100013:	89 c1                	mov    %eax,%ecx
    pid_t p2 = sys_fork();
    assert(p2 >= 0);
  100015:	85 c0                	test   %eax,%eax
  100017:	78 5a                	js     100073 <process_main+0x73>
    asm volatile ("int %1" : "=a" (result)
  100019:	cd 31                	int    $0x31

    // Check fork return values: fork should return 0 to child.
    if (sys_getpid() == 1) {
  10001b:	83 f8 01             	cmp    $0x1,%eax
  10001e:	74 67                	je     100087 <process_main+0x87>
        assert(p1 != 0 && p2 != 0 && p1 != p2);
    } else {
        assert(p1 == 0 || p2 == 0);
  100020:	85 d2                	test   %edx,%edx
  100022:	74 08                	je     10002c <process_main+0x2c>
  100024:	85 c9                	test   %ecx,%ecx
  100026:	0f 85 81 00 00 00    	jne    1000ad <process_main+0xad>
  10002c:	cd 31                	int    $0x31
  10002e:	89 c3                	mov    %eax,%ebx
    }

    // The rest of this code is like p-allocator.c.

    pid_t p = sys_getpid();
    srand(p);
  100030:	89 c7                	mov    %eax,%edi
  100032:	e8 e4 02 00 00       	callq  10031b <srand>

    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  100037:	b8 17 20 10 00       	mov    $0x102017,%eax
  10003c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100042:	48 89 05 bf 0f 00 00 	mov    %rax,0xfbf(%rip)        # 101008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  100049:	48 89 e0             	mov    %rsp,%rax
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  10004c:	48 83 e8 01          	sub    $0x1,%rax
  100050:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100056:	48 89 05 a3 0f 00 00 	mov    %rax,0xfa3(%rip)        # 101000 <stack_bottom>
  10005d:	eb 64                	jmp    1000c3 <process_main+0xc3>
    assert(p1 >= 0);
  10005f:	ba c0 0c 10 00       	mov    $0x100cc0,%edx
  100064:	be 0d 00 00 00       	mov    $0xd,%esi
  100069:	bf c8 0c 10 00       	mov    $0x100cc8,%edi
  10006e:	e8 11 0c 00 00       	callq  100c84 <assert_fail>
    assert(p2 >= 0);
  100073:	ba d1 0c 10 00       	mov    $0x100cd1,%edx
  100078:	be 0f 00 00 00       	mov    $0xf,%esi
  10007d:	bf c8 0c 10 00       	mov    $0x100cc8,%edi
  100082:	e8 fd 0b 00 00       	callq  100c84 <assert_fail>
        assert(p1 != 0 && p2 != 0 && p1 != p2);
  100087:	85 c9                	test   %ecx,%ecx
  100089:	0f 94 c0             	sete   %al
  10008c:	39 ca                	cmp    %ecx,%edx
  10008e:	0f 94 c1             	sete   %cl
  100091:	08 c8                	or     %cl,%al
  100093:	75 04                	jne    100099 <process_main+0x99>
  100095:	85 d2                	test   %edx,%edx
  100097:	75 93                	jne    10002c <process_main+0x2c>
  100099:	ba f0 0c 10 00       	mov    $0x100cf0,%edx
  10009e:	be 13 00 00 00       	mov    $0x13,%esi
  1000a3:	bf c8 0c 10 00       	mov    $0x100cc8,%edi
  1000a8:	e8 d7 0b 00 00       	callq  100c84 <assert_fail>
        assert(p1 == 0 || p2 == 0);
  1000ad:	ba d9 0c 10 00       	mov    $0x100cd9,%edx
  1000b2:	be 15 00 00 00       	mov    $0x15,%esi
  1000b7:	bf c8 0c 10 00       	mov    $0x100cc8,%edi
  1000bc:	e8 c3 0b 00 00       	callq  100c84 <assert_fail>
    asm volatile ("int %0" : /* no result */
  1000c1:	cd 32                	int    $0x32

    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  1000c3:	e8 19 02 00 00       	callq  1002e1 <rand>
  1000c8:	48 63 d0             	movslq %eax,%rdx
  1000cb:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  1000d2:	48 c1 fa 25          	sar    $0x25,%rdx
  1000d6:	89 c1                	mov    %eax,%ecx
  1000d8:	c1 f9 1f             	sar    $0x1f,%ecx
  1000db:	29 ca                	sub    %ecx,%edx
  1000dd:	6b d2 64             	imul   $0x64,%edx,%edx
  1000e0:	29 d0                	sub    %edx,%eax
  1000e2:	39 d8                	cmp    %ebx,%eax
  1000e4:	7d db                	jge    1000c1 <process_main+0xc1>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  1000e6:	48 8b 3d 1b 0f 00 00 	mov    0xf1b(%rip),%rdi        # 101008 <heap_top>
  1000ed:	48 3b 3d 0c 0f 00 00 	cmp    0xf0c(%rip),%rdi        # 101000 <stack_bottom>
  1000f4:	74 1c                	je     100112 <process_main+0x112>
    asm volatile ("int %1" : "=a" (result)
  1000f6:	cd 33                	int    $0x33
  1000f8:	85 c0                	test   %eax,%eax
  1000fa:	78 16                	js     100112 <process_main+0x112>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  1000fc:	48 8b 05 05 0f 00 00 	mov    0xf05(%rip),%rax        # 101008 <heap_top>
  100103:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  100105:	48 81 05 f8 0e 00 00 	addq   $0x1000,0xef8(%rip)        # 101008 <heap_top>
  10010c:	00 10 00 00 
  100110:	eb af                	jmp    1000c1 <process_main+0xc1>
    asm volatile ("int %0" : /* no result */
  100112:	cd 32                	int    $0x32
  100114:	eb fc                	jmp    100112 <process_main+0x112>

0000000000100116 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100116:	48 89 f9             	mov    %rdi,%rcx
  100119:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  10011b:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  100122:	00 
  100123:	72 08                	jb     10012d <console_putc+0x17>
        cp->cursor = console;
  100125:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  10012c:	00 
    }
    if (c == '\n') {
  10012d:	40 80 fe 0a          	cmp    $0xa,%sil
  100131:	74 16                	je     100149 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  100133:	48 8b 41 08          	mov    0x8(%rcx),%rax
  100137:	48 8d 50 02          	lea    0x2(%rax),%rdx
  10013b:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  10013f:	40 0f b6 f6          	movzbl %sil,%esi
  100143:	09 fe                	or     %edi,%esi
  100145:	66 89 30             	mov    %si,(%rax)
    }
}
  100148:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  100149:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  10014d:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  100154:	4c 89 c6             	mov    %r8,%rsi
  100157:	48 d1 fe             	sar    %rsi
  10015a:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  100161:	66 66 66 
  100164:	48 89 f0             	mov    %rsi,%rax
  100167:	48 f7 ea             	imul   %rdx
  10016a:	48 c1 fa 05          	sar    $0x5,%rdx
  10016e:	49 c1 f8 3f          	sar    $0x3f,%r8
  100172:	4c 29 c2             	sub    %r8,%rdx
  100175:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  100179:	48 c1 e2 04          	shl    $0x4,%rdx
  10017d:	89 f0                	mov    %esi,%eax
  10017f:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  100181:	83 cf 20             	or     $0x20,%edi
  100184:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100188:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  10018c:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  100190:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  100193:	83 c0 01             	add    $0x1,%eax
  100196:	83 f8 50             	cmp    $0x50,%eax
  100199:	75 e9                	jne    100184 <console_putc+0x6e>
  10019b:	c3                   	retq   

000000000010019c <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  10019c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1001a0:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1001a4:	73 0b                	jae    1001b1 <string_putc+0x15>
        *sp->s++ = c;
  1001a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1001aa:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1001ae:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  1001b1:	c3                   	retq   

00000000001001b2 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  1001b2:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1001b5:	48 85 d2             	test   %rdx,%rdx
  1001b8:	74 17                	je     1001d1 <memcpy+0x1f>
  1001ba:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  1001bf:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  1001c4:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1001c8:	48 83 c1 01          	add    $0x1,%rcx
  1001cc:	48 39 d1             	cmp    %rdx,%rcx
  1001cf:	75 ee                	jne    1001bf <memcpy+0xd>
}
  1001d1:	c3                   	retq   

00000000001001d2 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  1001d2:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  1001d5:	48 39 fe             	cmp    %rdi,%rsi
  1001d8:	72 1d                	jb     1001f7 <memmove+0x25>
        while (n-- > 0) {
  1001da:	b9 00 00 00 00       	mov    $0x0,%ecx
  1001df:	48 85 d2             	test   %rdx,%rdx
  1001e2:	74 12                	je     1001f6 <memmove+0x24>
            *d++ = *s++;
  1001e4:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  1001e8:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  1001ec:	48 83 c1 01          	add    $0x1,%rcx
  1001f0:	48 39 ca             	cmp    %rcx,%rdx
  1001f3:	75 ef                	jne    1001e4 <memmove+0x12>
}
  1001f5:	c3                   	retq   
  1001f6:	c3                   	retq   
    if (s < d && s + n > d) {
  1001f7:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  1001fb:	48 39 cf             	cmp    %rcx,%rdi
  1001fe:	73 da                	jae    1001da <memmove+0x8>
        while (n-- > 0) {
  100200:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  100204:	48 85 d2             	test   %rdx,%rdx
  100207:	74 ec                	je     1001f5 <memmove+0x23>
            *--d = *--s;
  100209:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  10020d:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  100210:	48 83 e9 01          	sub    $0x1,%rcx
  100214:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  100218:	75 ef                	jne    100209 <memmove+0x37>
  10021a:	c3                   	retq   

000000000010021b <memset>:
void* memset(void* v, int c, size_t n) {
  10021b:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  10021e:	48 85 d2             	test   %rdx,%rdx
  100221:	74 12                	je     100235 <memset+0x1a>
  100223:	48 01 fa             	add    %rdi,%rdx
  100226:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  100229:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  10022c:	48 83 c1 01          	add    $0x1,%rcx
  100230:	48 39 ca             	cmp    %rcx,%rdx
  100233:	75 f4                	jne    100229 <memset+0xe>
}
  100235:	c3                   	retq   

0000000000100236 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  100236:	80 3f 00             	cmpb   $0x0,(%rdi)
  100239:	74 10                	je     10024b <strlen+0x15>
  10023b:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  100240:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  100244:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  100248:	75 f6                	jne    100240 <strlen+0xa>
  10024a:	c3                   	retq   
  10024b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100250:	c3                   	retq   

0000000000100251 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  100251:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  100254:	ba 00 00 00 00       	mov    $0x0,%edx
  100259:	48 85 f6             	test   %rsi,%rsi
  10025c:	74 11                	je     10026f <strnlen+0x1e>
  10025e:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  100262:	74 0c                	je     100270 <strnlen+0x1f>
        ++n;
  100264:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  100268:	48 39 d0             	cmp    %rdx,%rax
  10026b:	75 f1                	jne    10025e <strnlen+0xd>
  10026d:	eb 04                	jmp    100273 <strnlen+0x22>
  10026f:	c3                   	retq   
  100270:	48 89 d0             	mov    %rdx,%rax
}
  100273:	c3                   	retq   

0000000000100274 <strcpy>:
char* strcpy(char* dst, const char* src) {
  100274:	48 89 f8             	mov    %rdi,%rax
  100277:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  10027c:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  100280:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  100283:	48 83 c2 01          	add    $0x1,%rdx
  100287:	84 c9                	test   %cl,%cl
  100289:	75 f1                	jne    10027c <strcpy+0x8>
}
  10028b:	c3                   	retq   

000000000010028c <strcmp>:
    while (*a && *b && *a == *b) {
  10028c:	0f b6 07             	movzbl (%rdi),%eax
  10028f:	84 c0                	test   %al,%al
  100291:	74 1a                	je     1002ad <strcmp+0x21>
  100293:	0f b6 16             	movzbl (%rsi),%edx
  100296:	38 c2                	cmp    %al,%dl
  100298:	75 13                	jne    1002ad <strcmp+0x21>
  10029a:	84 d2                	test   %dl,%dl
  10029c:	74 0f                	je     1002ad <strcmp+0x21>
        ++a, ++b;
  10029e:	48 83 c7 01          	add    $0x1,%rdi
  1002a2:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  1002a6:	0f b6 07             	movzbl (%rdi),%eax
  1002a9:	84 c0                	test   %al,%al
  1002ab:	75 e6                	jne    100293 <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  1002ad:	3a 06                	cmp    (%rsi),%al
  1002af:	0f 97 c0             	seta   %al
  1002b2:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  1002b5:	83 d8 00             	sbb    $0x0,%eax
}
  1002b8:	c3                   	retq   

00000000001002b9 <strchr>:
    while (*s && *s != (char) c) {
  1002b9:	0f b6 07             	movzbl (%rdi),%eax
  1002bc:	84 c0                	test   %al,%al
  1002be:	74 10                	je     1002d0 <strchr+0x17>
  1002c0:	40 38 f0             	cmp    %sil,%al
  1002c3:	74 18                	je     1002dd <strchr+0x24>
        ++s;
  1002c5:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  1002c9:	0f b6 07             	movzbl (%rdi),%eax
  1002cc:	84 c0                	test   %al,%al
  1002ce:	75 f0                	jne    1002c0 <strchr+0x7>
        return NULL;
  1002d0:	40 84 f6             	test   %sil,%sil
  1002d3:	b8 00 00 00 00       	mov    $0x0,%eax
  1002d8:	48 0f 44 c7          	cmove  %rdi,%rax
}
  1002dc:	c3                   	retq   
  1002dd:	48 89 f8             	mov    %rdi,%rax
  1002e0:	c3                   	retq   

00000000001002e1 <rand>:
    if (!rand_seed_set) {
  1002e1:	83 3d 2c 0d 00 00 00 	cmpl   $0x0,0xd2c(%rip)        # 101014 <rand_seed_set>
  1002e8:	74 1b                	je     100305 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1002ea:	69 05 1c 0d 00 00 0d 	imul   $0x19660d,0xd1c(%rip),%eax        # 101010 <rand_seed>
  1002f1:	66 19 00 
  1002f4:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1002f9:	89 05 11 0d 00 00    	mov    %eax,0xd11(%rip)        # 101010 <rand_seed>
    return rand_seed & RAND_MAX;
  1002ff:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  100304:	c3                   	retq   
    rand_seed = seed;
  100305:	c7 05 01 0d 00 00 9e 	movl   $0x30d4879e,0xd01(%rip)        # 101010 <rand_seed>
  10030c:	87 d4 30 
    rand_seed_set = 1;
  10030f:	c7 05 fb 0c 00 00 01 	movl   $0x1,0xcfb(%rip)        # 101014 <rand_seed_set>
  100316:	00 00 00 
}
  100319:	eb cf                	jmp    1002ea <rand+0x9>

000000000010031b <srand>:
    rand_seed = seed;
  10031b:	89 3d ef 0c 00 00    	mov    %edi,0xcef(%rip)        # 101010 <rand_seed>
    rand_seed_set = 1;
  100321:	c7 05 e9 0c 00 00 01 	movl   $0x1,0xce9(%rip)        # 101014 <rand_seed_set>
  100328:	00 00 00 
}
  10032b:	c3                   	retq   

000000000010032c <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  10032c:	55                   	push   %rbp
  10032d:	48 89 e5             	mov    %rsp,%rbp
  100330:	41 57                	push   %r15
  100332:	41 56                	push   %r14
  100334:	41 55                	push   %r13
  100336:	41 54                	push   %r12
  100338:	53                   	push   %rbx
  100339:	48 83 ec 58          	sub    $0x58,%rsp
  10033d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  100341:	0f b6 02             	movzbl (%rdx),%eax
  100344:	84 c0                	test   %al,%al
  100346:	0f 84 b0 06 00 00    	je     1009fc <printer_vprintf+0x6d0>
  10034c:	49 89 fe             	mov    %rdi,%r14
  10034f:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  100352:	41 89 f7             	mov    %esi,%r15d
  100355:	e9 a4 04 00 00       	jmpq   1007fe <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  10035a:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  10035f:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  100365:	45 84 e4             	test   %r12b,%r12b
  100368:	0f 84 82 06 00 00    	je     1009f0 <printer_vprintf+0x6c4>
        int flags = 0;
  10036e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  100374:	41 0f be f4          	movsbl %r12b,%esi
  100378:	bf 11 0f 10 00       	mov    $0x100f11,%edi
  10037d:	e8 37 ff ff ff       	callq  1002b9 <strchr>
  100382:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  100385:	48 85 c0             	test   %rax,%rax
  100388:	74 55                	je     1003df <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  10038a:	48 81 e9 11 0f 10 00 	sub    $0x100f11,%rcx
  100391:	b8 01 00 00 00       	mov    $0x1,%eax
  100396:	d3 e0                	shl    %cl,%eax
  100398:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  10039b:	48 83 c3 01          	add    $0x1,%rbx
  10039f:	44 0f b6 23          	movzbl (%rbx),%r12d
  1003a3:	45 84 e4             	test   %r12b,%r12b
  1003a6:	75 cc                	jne    100374 <printer_vprintf+0x48>
  1003a8:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  1003ac:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  1003b2:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  1003b9:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  1003bc:	0f 84 a9 00 00 00    	je     10046b <printer_vprintf+0x13f>
        int length = 0;
  1003c2:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  1003c7:	0f b6 13             	movzbl (%rbx),%edx
  1003ca:	8d 42 bd             	lea    -0x43(%rdx),%eax
  1003cd:	3c 37                	cmp    $0x37,%al
  1003cf:	0f 87 c4 04 00 00    	ja     100899 <printer_vprintf+0x56d>
  1003d5:	0f b6 c0             	movzbl %al,%eax
  1003d8:	ff 24 c5 20 0d 10 00 	jmpq   *0x100d20(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  1003df:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  1003e3:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  1003e8:	3c 08                	cmp    $0x8,%al
  1003ea:	77 2f                	ja     10041b <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1003ec:	0f b6 03             	movzbl (%rbx),%eax
  1003ef:	8d 50 d0             	lea    -0x30(%rax),%edx
  1003f2:	80 fa 09             	cmp    $0x9,%dl
  1003f5:	77 5e                	ja     100455 <printer_vprintf+0x129>
  1003f7:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  1003fd:	48 83 c3 01          	add    $0x1,%rbx
  100401:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  100406:	0f be c0             	movsbl %al,%eax
  100409:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  10040e:	0f b6 03             	movzbl (%rbx),%eax
  100411:	8d 50 d0             	lea    -0x30(%rax),%edx
  100414:	80 fa 09             	cmp    $0x9,%dl
  100417:	76 e4                	jbe    1003fd <printer_vprintf+0xd1>
  100419:	eb 97                	jmp    1003b2 <printer_vprintf+0x86>
        } else if (*format == '*') {
  10041b:	41 80 fc 2a          	cmp    $0x2a,%r12b
  10041f:	75 3f                	jne    100460 <printer_vprintf+0x134>
            width = va_arg(val, int);
  100421:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100425:	8b 07                	mov    (%rdi),%eax
  100427:	83 f8 2f             	cmp    $0x2f,%eax
  10042a:	77 17                	ja     100443 <printer_vprintf+0x117>
  10042c:	89 c2                	mov    %eax,%edx
  10042e:	48 03 57 10          	add    0x10(%rdi),%rdx
  100432:	83 c0 08             	add    $0x8,%eax
  100435:	89 07                	mov    %eax,(%rdi)
  100437:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  10043a:	48 83 c3 01          	add    $0x1,%rbx
  10043e:	e9 6f ff ff ff       	jmpq   1003b2 <printer_vprintf+0x86>
            width = va_arg(val, int);
  100443:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100447:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10044b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10044f:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100453:	eb e2                	jmp    100437 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100455:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  10045b:	e9 52 ff ff ff       	jmpq   1003b2 <printer_vprintf+0x86>
        int width = -1;
  100460:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  100466:	e9 47 ff ff ff       	jmpq   1003b2 <printer_vprintf+0x86>
            ++format;
  10046b:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  10046f:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  100473:	8d 48 d0             	lea    -0x30(%rax),%ecx
  100476:	80 f9 09             	cmp    $0x9,%cl
  100479:	76 13                	jbe    10048e <printer_vprintf+0x162>
            } else if (*format == '*') {
  10047b:	3c 2a                	cmp    $0x2a,%al
  10047d:	74 33                	je     1004b2 <printer_vprintf+0x186>
            ++format;
  10047f:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  100482:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  100489:	e9 34 ff ff ff       	jmpq   1003c2 <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  10048e:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  100493:	48 83 c2 01          	add    $0x1,%rdx
  100497:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  10049a:	0f be c0             	movsbl %al,%eax
  10049d:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1004a1:	0f b6 02             	movzbl (%rdx),%eax
  1004a4:	8d 70 d0             	lea    -0x30(%rax),%esi
  1004a7:	40 80 fe 09          	cmp    $0x9,%sil
  1004ab:	76 e6                	jbe    100493 <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  1004ad:	48 89 d3             	mov    %rdx,%rbx
  1004b0:	eb 1c                	jmp    1004ce <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  1004b2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004b6:	8b 07                	mov    (%rdi),%eax
  1004b8:	83 f8 2f             	cmp    $0x2f,%eax
  1004bb:	77 23                	ja     1004e0 <printer_vprintf+0x1b4>
  1004bd:	89 c2                	mov    %eax,%edx
  1004bf:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004c3:	83 c0 08             	add    $0x8,%eax
  1004c6:	89 07                	mov    %eax,(%rdi)
  1004c8:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  1004ca:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  1004ce:	85 c9                	test   %ecx,%ecx
  1004d0:	b8 00 00 00 00       	mov    $0x0,%eax
  1004d5:	0f 49 c1             	cmovns %ecx,%eax
  1004d8:	89 45 9c             	mov    %eax,-0x64(%rbp)
  1004db:	e9 e2 fe ff ff       	jmpq   1003c2 <printer_vprintf+0x96>
                precision = va_arg(val, int);
  1004e0:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1004e4:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1004e8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004ec:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1004f0:	eb d6                	jmp    1004c8 <printer_vprintf+0x19c>
        switch (*format) {
  1004f2:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1004f7:	e9 f3 00 00 00       	jmpq   1005ef <printer_vprintf+0x2c3>
            ++format;
  1004fc:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  100500:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  100505:	e9 bd fe ff ff       	jmpq   1003c7 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  10050a:	85 c9                	test   %ecx,%ecx
  10050c:	74 55                	je     100563 <printer_vprintf+0x237>
  10050e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100512:	8b 07                	mov    (%rdi),%eax
  100514:	83 f8 2f             	cmp    $0x2f,%eax
  100517:	77 38                	ja     100551 <printer_vprintf+0x225>
  100519:	89 c2                	mov    %eax,%edx
  10051b:	48 03 57 10          	add    0x10(%rdi),%rdx
  10051f:	83 c0 08             	add    $0x8,%eax
  100522:	89 07                	mov    %eax,(%rdi)
  100524:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  100527:	48 89 d0             	mov    %rdx,%rax
  10052a:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  10052e:	49 89 d0             	mov    %rdx,%r8
  100531:	49 f7 d8             	neg    %r8
  100534:	25 80 00 00 00       	and    $0x80,%eax
  100539:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  10053d:	0b 45 a8             	or     -0x58(%rbp),%eax
  100540:	83 c8 60             	or     $0x60,%eax
  100543:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  100546:	41 bc 20 0f 10 00    	mov    $0x100f20,%r12d
            break;
  10054c:	e9 35 01 00 00       	jmpq   100686 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100551:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100555:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100559:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10055d:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100561:	eb c1                	jmp    100524 <printer_vprintf+0x1f8>
  100563:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100567:	8b 07                	mov    (%rdi),%eax
  100569:	83 f8 2f             	cmp    $0x2f,%eax
  10056c:	77 10                	ja     10057e <printer_vprintf+0x252>
  10056e:	89 c2                	mov    %eax,%edx
  100570:	48 03 57 10          	add    0x10(%rdi),%rdx
  100574:	83 c0 08             	add    $0x8,%eax
  100577:	89 07                	mov    %eax,(%rdi)
  100579:	48 63 12             	movslq (%rdx),%rdx
  10057c:	eb a9                	jmp    100527 <printer_vprintf+0x1fb>
  10057e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100582:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100586:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10058a:	48 89 47 08          	mov    %rax,0x8(%rdi)
  10058e:	eb e9                	jmp    100579 <printer_vprintf+0x24d>
        int base = 10;
  100590:	be 0a 00 00 00       	mov    $0xa,%esi
  100595:	eb 58                	jmp    1005ef <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100597:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10059b:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10059f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005a3:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005a7:	eb 60                	jmp    100609 <printer_vprintf+0x2dd>
  1005a9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1005ad:	8b 07                	mov    (%rdi),%eax
  1005af:	83 f8 2f             	cmp    $0x2f,%eax
  1005b2:	77 10                	ja     1005c4 <printer_vprintf+0x298>
  1005b4:	89 c2                	mov    %eax,%edx
  1005b6:	48 03 57 10          	add    0x10(%rdi),%rdx
  1005ba:	83 c0 08             	add    $0x8,%eax
  1005bd:	89 07                	mov    %eax,(%rdi)
  1005bf:	44 8b 02             	mov    (%rdx),%r8d
  1005c2:	eb 48                	jmp    10060c <printer_vprintf+0x2e0>
  1005c4:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005c8:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005cc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005d0:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005d4:	eb e9                	jmp    1005bf <printer_vprintf+0x293>
  1005d6:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  1005d9:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  1005e0:	bf 00 0f 10 00       	mov    $0x100f00,%edi
  1005e5:	e9 e2 02 00 00       	jmpq   1008cc <printer_vprintf+0x5a0>
            base = 16;
  1005ea:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1005ef:	85 c9                	test   %ecx,%ecx
  1005f1:	74 b6                	je     1005a9 <printer_vprintf+0x27d>
  1005f3:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005f7:	8b 01                	mov    (%rcx),%eax
  1005f9:	83 f8 2f             	cmp    $0x2f,%eax
  1005fc:	77 99                	ja     100597 <printer_vprintf+0x26b>
  1005fe:	89 c2                	mov    %eax,%edx
  100600:	48 03 51 10          	add    0x10(%rcx),%rdx
  100604:	83 c0 08             	add    $0x8,%eax
  100607:	89 01                	mov    %eax,(%rcx)
  100609:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  10060c:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  100610:	85 f6                	test   %esi,%esi
  100612:	79 c2                	jns    1005d6 <printer_vprintf+0x2aa>
        base = -base;
  100614:	41 89 f1             	mov    %esi,%r9d
  100617:	f7 de                	neg    %esi
  100619:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  100620:	bf e0 0e 10 00       	mov    $0x100ee0,%edi
  100625:	e9 a2 02 00 00       	jmpq   1008cc <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  10062a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10062e:	8b 07                	mov    (%rdi),%eax
  100630:	83 f8 2f             	cmp    $0x2f,%eax
  100633:	77 1c                	ja     100651 <printer_vprintf+0x325>
  100635:	89 c2                	mov    %eax,%edx
  100637:	48 03 57 10          	add    0x10(%rdi),%rdx
  10063b:	83 c0 08             	add    $0x8,%eax
  10063e:	89 07                	mov    %eax,(%rdi)
  100640:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  100643:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  10064a:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  10064f:	eb c3                	jmp    100614 <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  100651:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100655:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100659:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10065d:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100661:	eb dd                	jmp    100640 <printer_vprintf+0x314>
            data = va_arg(val, char*);
  100663:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100667:	8b 01                	mov    (%rcx),%eax
  100669:	83 f8 2f             	cmp    $0x2f,%eax
  10066c:	0f 87 a5 01 00 00    	ja     100817 <printer_vprintf+0x4eb>
  100672:	89 c2                	mov    %eax,%edx
  100674:	48 03 51 10          	add    0x10(%rcx),%rdx
  100678:	83 c0 08             	add    $0x8,%eax
  10067b:	89 01                	mov    %eax,(%rcx)
  10067d:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  100680:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  100686:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100689:	83 e0 20             	and    $0x20,%eax
  10068c:	89 45 8c             	mov    %eax,-0x74(%rbp)
  10068f:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  100695:	0f 85 21 02 00 00    	jne    1008bc <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  10069b:	8b 45 a8             	mov    -0x58(%rbp),%eax
  10069e:	89 45 88             	mov    %eax,-0x78(%rbp)
  1006a1:	83 e0 60             	and    $0x60,%eax
  1006a4:	83 f8 60             	cmp    $0x60,%eax
  1006a7:	0f 84 54 02 00 00    	je     100901 <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1006ad:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1006b0:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  1006b3:	48 c7 45 a0 20 0f 10 	movq   $0x100f20,-0x60(%rbp)
  1006ba:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1006bb:	83 f8 21             	cmp    $0x21,%eax
  1006be:	0f 84 79 02 00 00    	je     10093d <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  1006c4:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  1006c7:	89 f8                	mov    %edi,%eax
  1006c9:	f7 d0                	not    %eax
  1006cb:	c1 e8 1f             	shr    $0x1f,%eax
  1006ce:	89 45 84             	mov    %eax,-0x7c(%rbp)
  1006d1:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  1006d5:	0f 85 9e 02 00 00    	jne    100979 <printer_vprintf+0x64d>
  1006db:	84 c0                	test   %al,%al
  1006dd:	0f 84 96 02 00 00    	je     100979 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  1006e3:	48 63 f7             	movslq %edi,%rsi
  1006e6:	4c 89 e7             	mov    %r12,%rdi
  1006e9:	e8 63 fb ff ff       	callq  100251 <strnlen>
  1006ee:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  1006f1:	8b 45 88             	mov    -0x78(%rbp),%eax
  1006f4:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  1006f7:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  1006fe:	83 f8 22             	cmp    $0x22,%eax
  100701:	0f 84 aa 02 00 00    	je     1009b1 <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  100707:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  10070b:	e8 26 fb ff ff       	callq  100236 <strlen>
  100710:	8b 55 9c             	mov    -0x64(%rbp),%edx
  100713:	03 55 98             	add    -0x68(%rbp),%edx
  100716:	44 89 e9             	mov    %r13d,%ecx
  100719:	29 d1                	sub    %edx,%ecx
  10071b:	29 c1                	sub    %eax,%ecx
  10071d:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  100720:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100723:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  100727:	75 2d                	jne    100756 <printer_vprintf+0x42a>
  100729:	85 c9                	test   %ecx,%ecx
  10072b:	7e 29                	jle    100756 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  10072d:	44 89 fa             	mov    %r15d,%edx
  100730:	be 20 00 00 00       	mov    $0x20,%esi
  100735:	4c 89 f7             	mov    %r14,%rdi
  100738:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  10073b:	41 83 ed 01          	sub    $0x1,%r13d
  10073f:	45 85 ed             	test   %r13d,%r13d
  100742:	7f e9                	jg     10072d <printer_vprintf+0x401>
  100744:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  100747:	85 ff                	test   %edi,%edi
  100749:	b8 01 00 00 00       	mov    $0x1,%eax
  10074e:	0f 4f c7             	cmovg  %edi,%eax
  100751:	29 c7                	sub    %eax,%edi
  100753:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  100756:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  10075a:	0f b6 07             	movzbl (%rdi),%eax
  10075d:	84 c0                	test   %al,%al
  10075f:	74 22                	je     100783 <printer_vprintf+0x457>
  100761:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100765:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  100768:	0f b6 f0             	movzbl %al,%esi
  10076b:	44 89 fa             	mov    %r15d,%edx
  10076e:	4c 89 f7             	mov    %r14,%rdi
  100771:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  100774:	48 83 c3 01          	add    $0x1,%rbx
  100778:	0f b6 03             	movzbl (%rbx),%eax
  10077b:	84 c0                	test   %al,%al
  10077d:	75 e9                	jne    100768 <printer_vprintf+0x43c>
  10077f:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  100783:	8b 45 9c             	mov    -0x64(%rbp),%eax
  100786:	85 c0                	test   %eax,%eax
  100788:	7e 1d                	jle    1007a7 <printer_vprintf+0x47b>
  10078a:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  10078e:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  100790:	44 89 fa             	mov    %r15d,%edx
  100793:	be 30 00 00 00       	mov    $0x30,%esi
  100798:	4c 89 f7             	mov    %r14,%rdi
  10079b:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  10079e:	83 eb 01             	sub    $0x1,%ebx
  1007a1:	75 ed                	jne    100790 <printer_vprintf+0x464>
  1007a3:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  1007a7:	8b 45 98             	mov    -0x68(%rbp),%eax
  1007aa:	85 c0                	test   %eax,%eax
  1007ac:	7e 27                	jle    1007d5 <printer_vprintf+0x4a9>
  1007ae:	89 c0                	mov    %eax,%eax
  1007b0:	4c 01 e0             	add    %r12,%rax
  1007b3:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1007b7:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  1007ba:	41 0f b6 34 24       	movzbl (%r12),%esi
  1007bf:	44 89 fa             	mov    %r15d,%edx
  1007c2:	4c 89 f7             	mov    %r14,%rdi
  1007c5:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  1007c8:	49 83 c4 01          	add    $0x1,%r12
  1007cc:	49 39 dc             	cmp    %rbx,%r12
  1007cf:	75 e9                	jne    1007ba <printer_vprintf+0x48e>
  1007d1:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  1007d5:	45 85 ed             	test   %r13d,%r13d
  1007d8:	7e 14                	jle    1007ee <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  1007da:	44 89 fa             	mov    %r15d,%edx
  1007dd:	be 20 00 00 00       	mov    $0x20,%esi
  1007e2:	4c 89 f7             	mov    %r14,%rdi
  1007e5:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  1007e8:	41 83 ed 01          	sub    $0x1,%r13d
  1007ec:	75 ec                	jne    1007da <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  1007ee:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  1007f2:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1007f6:	84 c0                	test   %al,%al
  1007f8:	0f 84 fe 01 00 00    	je     1009fc <printer_vprintf+0x6d0>
        if (*format != '%') {
  1007fe:	3c 25                	cmp    $0x25,%al
  100800:	0f 84 54 fb ff ff    	je     10035a <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  100806:	0f b6 f0             	movzbl %al,%esi
  100809:	44 89 fa             	mov    %r15d,%edx
  10080c:	4c 89 f7             	mov    %r14,%rdi
  10080f:	41 ff 16             	callq  *(%r14)
            continue;
  100812:	4c 89 e3             	mov    %r12,%rbx
  100815:	eb d7                	jmp    1007ee <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  100817:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10081b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10081f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100823:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100827:	e9 51 fe ff ff       	jmpq   10067d <printer_vprintf+0x351>
            color = va_arg(val, int);
  10082c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100830:	8b 07                	mov    (%rdi),%eax
  100832:	83 f8 2f             	cmp    $0x2f,%eax
  100835:	77 10                	ja     100847 <printer_vprintf+0x51b>
  100837:	89 c2                	mov    %eax,%edx
  100839:	48 03 57 10          	add    0x10(%rdi),%rdx
  10083d:	83 c0 08             	add    $0x8,%eax
  100840:	89 07                	mov    %eax,(%rdi)
  100842:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  100845:	eb a7                	jmp    1007ee <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  100847:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10084b:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10084f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100853:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100857:	eb e9                	jmp    100842 <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  100859:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10085d:	8b 01                	mov    (%rcx),%eax
  10085f:	83 f8 2f             	cmp    $0x2f,%eax
  100862:	77 23                	ja     100887 <printer_vprintf+0x55b>
  100864:	89 c2                	mov    %eax,%edx
  100866:	48 03 51 10          	add    0x10(%rcx),%rdx
  10086a:	83 c0 08             	add    $0x8,%eax
  10086d:	89 01                	mov    %eax,(%rcx)
  10086f:	8b 02                	mov    (%rdx),%eax
  100871:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  100874:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  100878:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  10087c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  100882:	e9 ff fd ff ff       	jmpq   100686 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  100887:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10088b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10088f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100893:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100897:	eb d6                	jmp    10086f <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  100899:	84 d2                	test   %dl,%dl
  10089b:	0f 85 39 01 00 00    	jne    1009da <printer_vprintf+0x6ae>
  1008a1:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  1008a5:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  1008a9:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  1008ad:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1008b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1008b7:	e9 ca fd ff ff       	jmpq   100686 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  1008bc:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  1008c2:	bf 00 0f 10 00       	mov    $0x100f00,%edi
        if (flags & FLAG_NUMERIC) {
  1008c7:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  1008cc:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  1008d0:	4c 89 c1             	mov    %r8,%rcx
  1008d3:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  1008d7:	48 63 f6             	movslq %esi,%rsi
  1008da:	49 83 ec 01          	sub    $0x1,%r12
  1008de:	48 89 c8             	mov    %rcx,%rax
  1008e1:	ba 00 00 00 00       	mov    $0x0,%edx
  1008e6:	48 f7 f6             	div    %rsi
  1008e9:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  1008ed:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  1008f1:	48 89 ca             	mov    %rcx,%rdx
  1008f4:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  1008f7:	48 39 d6             	cmp    %rdx,%rsi
  1008fa:	76 de                	jbe    1008da <printer_vprintf+0x5ae>
  1008fc:	e9 9a fd ff ff       	jmpq   10069b <printer_vprintf+0x36f>
                prefix = "-";
  100901:	48 c7 45 a0 14 0d 10 	movq   $0x100d14,-0x60(%rbp)
  100908:	00 
            if (flags & FLAG_NEGATIVE) {
  100909:	8b 45 a8             	mov    -0x58(%rbp),%eax
  10090c:	a8 80                	test   $0x80,%al
  10090e:	0f 85 b0 fd ff ff    	jne    1006c4 <printer_vprintf+0x398>
                prefix = "+";
  100914:	48 c7 45 a0 0f 0d 10 	movq   $0x100d0f,-0x60(%rbp)
  10091b:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  10091c:	a8 10                	test   $0x10,%al
  10091e:	0f 85 a0 fd ff ff    	jne    1006c4 <printer_vprintf+0x398>
                prefix = " ";
  100924:	a8 08                	test   $0x8,%al
  100926:	ba 20 0f 10 00       	mov    $0x100f20,%edx
  10092b:	b8 1d 0f 10 00       	mov    $0x100f1d,%eax
  100930:	48 0f 44 c2          	cmove  %rdx,%rax
  100934:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  100938:	e9 87 fd ff ff       	jmpq   1006c4 <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  10093d:	41 8d 41 10          	lea    0x10(%r9),%eax
  100941:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  100946:	0f 85 78 fd ff ff    	jne    1006c4 <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  10094c:	4d 85 c0             	test   %r8,%r8
  10094f:	75 0d                	jne    10095e <printer_vprintf+0x632>
  100951:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  100958:	0f 84 66 fd ff ff    	je     1006c4 <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  10095e:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  100962:	ba 16 0d 10 00       	mov    $0x100d16,%edx
  100967:	b8 11 0d 10 00       	mov    $0x100d11,%eax
  10096c:	48 0f 44 c2          	cmove  %rdx,%rax
  100970:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  100974:	e9 4b fd ff ff       	jmpq   1006c4 <printer_vprintf+0x398>
            len = strlen(data);
  100979:	4c 89 e7             	mov    %r12,%rdi
  10097c:	e8 b5 f8 ff ff       	callq  100236 <strlen>
  100981:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100984:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  100988:	0f 84 63 fd ff ff    	je     1006f1 <printer_vprintf+0x3c5>
  10098e:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  100992:	0f 84 59 fd ff ff    	je     1006f1 <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  100998:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  10099b:	89 ca                	mov    %ecx,%edx
  10099d:	29 c2                	sub    %eax,%edx
  10099f:	39 c1                	cmp    %eax,%ecx
  1009a1:	b8 00 00 00 00       	mov    $0x0,%eax
  1009a6:	0f 4e d0             	cmovle %eax,%edx
  1009a9:	89 55 9c             	mov    %edx,-0x64(%rbp)
  1009ac:	e9 56 fd ff ff       	jmpq   100707 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  1009b1:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1009b5:	e8 7c f8 ff ff       	callq  100236 <strlen>
  1009ba:	8b 7d 98             	mov    -0x68(%rbp),%edi
  1009bd:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  1009c0:	44 89 e9             	mov    %r13d,%ecx
  1009c3:	29 f9                	sub    %edi,%ecx
  1009c5:	29 c1                	sub    %eax,%ecx
  1009c7:	44 39 ea             	cmp    %r13d,%edx
  1009ca:	b8 00 00 00 00       	mov    $0x0,%eax
  1009cf:	0f 4d c8             	cmovge %eax,%ecx
  1009d2:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  1009d5:	e9 2d fd ff ff       	jmpq   100707 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  1009da:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  1009dd:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1009e1:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1009e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1009eb:	e9 96 fc ff ff       	jmpq   100686 <printer_vprintf+0x35a>
        int flags = 0;
  1009f0:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  1009f7:	e9 b0 f9 ff ff       	jmpq   1003ac <printer_vprintf+0x80>
}
  1009fc:	48 83 c4 58          	add    $0x58,%rsp
  100a00:	5b                   	pop    %rbx
  100a01:	41 5c                	pop    %r12
  100a03:	41 5d                	pop    %r13
  100a05:	41 5e                	pop    %r14
  100a07:	41 5f                	pop    %r15
  100a09:	5d                   	pop    %rbp
  100a0a:	c3                   	retq   

0000000000100a0b <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100a0b:	55                   	push   %rbp
  100a0c:	48 89 e5             	mov    %rsp,%rbp
  100a0f:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  100a13:	48 c7 45 f0 16 01 10 	movq   $0x100116,-0x10(%rbp)
  100a1a:	00 
        cpos = 0;
  100a1b:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  100a21:	b8 00 00 00 00       	mov    $0x0,%eax
  100a26:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  100a29:	48 63 ff             	movslq %edi,%rdi
  100a2c:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  100a33:	00 
  100a34:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  100a38:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  100a3c:	e8 eb f8 ff ff       	callq  10032c <printer_vprintf>
    return cp.cursor - console;
  100a41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100a45:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  100a4b:	48 d1 f8             	sar    %rax
}
  100a4e:	c9                   	leaveq 
  100a4f:	c3                   	retq   

0000000000100a50 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  100a50:	55                   	push   %rbp
  100a51:	48 89 e5             	mov    %rsp,%rbp
  100a54:	48 83 ec 50          	sub    $0x50,%rsp
  100a58:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100a5c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100a60:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  100a64:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100a6b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100a6f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100a73:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100a77:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  100a7b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100a7f:	e8 87 ff ff ff       	callq  100a0b <console_vprintf>
}
  100a84:	c9                   	leaveq 
  100a85:	c3                   	retq   

0000000000100a86 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100a86:	55                   	push   %rbp
  100a87:	48 89 e5             	mov    %rsp,%rbp
  100a8a:	53                   	push   %rbx
  100a8b:	48 83 ec 28          	sub    $0x28,%rsp
  100a8f:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  100a92:	48 c7 45 d8 9c 01 10 	movq   $0x10019c,-0x28(%rbp)
  100a99:	00 
    sp.s = s;
  100a9a:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  100a9e:	48 85 f6             	test   %rsi,%rsi
  100aa1:	75 0b                	jne    100aae <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  100aa3:	8b 45 e0             	mov    -0x20(%rbp),%eax
  100aa6:	29 d8                	sub    %ebx,%eax
}
  100aa8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100aac:	c9                   	leaveq 
  100aad:	c3                   	retq   
        sp.end = s + size - 1;
  100aae:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100ab3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100ab7:	be 00 00 00 00       	mov    $0x0,%esi
  100abc:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100ac0:	e8 67 f8 ff ff       	callq  10032c <printer_vprintf>
        *sp.s = 0;
  100ac5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100ac9:	c6 00 00             	movb   $0x0,(%rax)
  100acc:	eb d5                	jmp    100aa3 <vsnprintf+0x1d>

0000000000100ace <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100ace:	55                   	push   %rbp
  100acf:	48 89 e5             	mov    %rsp,%rbp
  100ad2:	48 83 ec 50          	sub    $0x50,%rsp
  100ad6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100ada:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100ade:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100ae2:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100ae9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100aed:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100af1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100af5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100af9:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100afd:	e8 84 ff ff ff       	callq  100a86 <vsnprintf>
    va_end(val);
    return n;
}
  100b02:	c9                   	leaveq 
  100b03:	c3                   	retq   

0000000000100b04 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b04:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  100b09:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  100b0e:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b13:	48 83 c0 02          	add    $0x2,%rax
  100b17:	48 39 d0             	cmp    %rdx,%rax
  100b1a:	75 f2                	jne    100b0e <console_clear+0xa>
    }
    cursorpos = 0;
  100b1c:	c7 05 d6 84 fb ff 00 	movl   $0x0,-0x47b2a(%rip)        # b8ffc <cursorpos>
  100b23:	00 00 00 
}
  100b26:	c3                   	retq   

0000000000100b27 <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  100b27:	55                   	push   %rbp
  100b28:	48 89 e5             	mov    %rsp,%rbp
  100b2b:	48 83 ec 50          	sub    $0x50,%rsp
  100b2f:	49 89 f2             	mov    %rsi,%r10
  100b32:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  100b36:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100b3a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100b3e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  100b42:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  100b47:	85 ff                	test   %edi,%edi
  100b49:	78 2e                	js     100b79 <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  100b4b:	48 63 ff             	movslq %edi,%rdi
  100b4e:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  100b55:	cc cc cc 
  100b58:	48 89 f8             	mov    %rdi,%rax
  100b5b:	48 f7 e2             	mul    %rdx
  100b5e:	48 89 d0             	mov    %rdx,%rax
  100b61:	48 c1 e8 02          	shr    $0x2,%rax
  100b65:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  100b69:	48 01 c2             	add    %rax,%rdx
  100b6c:	48 29 d7             	sub    %rdx,%rdi
  100b6f:	0f b6 b7 4d 0f 10 00 	movzbl 0x100f4d(%rdi),%esi
  100b76:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  100b79:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  100b80:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100b84:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100b88:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100b8c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  100b90:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100b94:	4c 89 d2             	mov    %r10,%rdx
  100b97:	8b 3d 5f 84 fb ff    	mov    -0x47ba1(%rip),%edi        # b8ffc <cursorpos>
  100b9d:	e8 69 fe ff ff       	callq  100a0b <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  100ba2:	3d 30 07 00 00       	cmp    $0x730,%eax
  100ba7:	ba 00 00 00 00       	mov    $0x0,%edx
  100bac:	0f 4d c2             	cmovge %edx,%eax
  100baf:	89 05 47 84 fb ff    	mov    %eax,-0x47bb9(%rip)        # b8ffc <cursorpos>
    }
}
  100bb5:	c9                   	leaveq 
  100bb6:	c3                   	retq   

0000000000100bb7 <panic>:


// panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void panic(const char* format, ...) {
  100bb7:	55                   	push   %rbp
  100bb8:	48 89 e5             	mov    %rsp,%rbp
  100bbb:	53                   	push   %rbx
  100bbc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  100bc3:	48 89 fb             	mov    %rdi,%rbx
  100bc6:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  100bca:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  100bce:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  100bd2:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  100bd6:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  100bda:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  100be1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100be5:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  100be9:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  100bed:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  100bf1:	ba 07 00 00 00       	mov    $0x7,%edx
  100bf6:	be 17 0f 10 00       	mov    $0x100f17,%esi
  100bfb:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  100c02:	e8 ab f5 ff ff       	callq  1001b2 <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  100c07:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  100c0b:	48 89 da             	mov    %rbx,%rdx
  100c0e:	be 99 00 00 00       	mov    $0x99,%esi
  100c13:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  100c1a:	e8 67 fe ff ff       	callq  100a86 <vsnprintf>
  100c1f:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  100c22:	85 d2                	test   %edx,%edx
  100c24:	7e 0f                	jle    100c35 <panic+0x7e>
  100c26:	83 c0 06             	add    $0x6,%eax
  100c29:	48 98                	cltq   
  100c2b:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  100c32:	0a 
  100c33:	75 29                	jne    100c5e <panic+0xa7>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  100c35:	48 8d 8d 08 ff ff ff 	lea    -0xf8(%rbp),%rcx
  100c3c:	ba 21 0f 10 00       	mov    $0x100f21,%edx
  100c41:	be 00 c0 00 00       	mov    $0xc000,%esi
  100c46:	bf 30 07 00 00       	mov    $0x730,%edi
  100c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  100c50:	e8 fb fd ff ff       	callq  100a50 <console_printf>
}

// sys_panic(msg)
//    Panic.
static inline pid_t __attribute__((noreturn)) sys_panic(const char* msg) {
    asm volatile ("int %0" : /* no result */
  100c55:	bf 00 00 00 00       	mov    $0x0,%edi
  100c5a:	cd 30                	int    $0x30
                  : "i" (INT_SYS_PANIC), "D" (msg)
                  : "cc", "memory");
 loop: goto loop;
  100c5c:	eb fe                	jmp    100c5c <panic+0xa5>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  100c5e:	48 63 c2             	movslq %edx,%rax
  100c61:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  100c67:	0f 94 c2             	sete   %dl
  100c6a:	0f b6 d2             	movzbl %dl,%edx
  100c6d:	48 29 d0             	sub    %rdx,%rax
  100c70:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  100c77:	ff 
  100c78:	be 1f 0f 10 00       	mov    $0x100f1f,%esi
  100c7d:	e8 f2 f5 ff ff       	callq  100274 <strcpy>
  100c82:	eb b1                	jmp    100c35 <panic+0x7e>

0000000000100c84 <assert_fail>:
    sys_panic(NULL);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  100c84:	55                   	push   %rbp
  100c85:	48 89 e5             	mov    %rsp,%rbp
  100c88:	48 89 f9             	mov    %rdi,%rcx
  100c8b:	41 89 f0             	mov    %esi,%r8d
  100c8e:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  100c91:	ba 28 0f 10 00       	mov    $0x100f28,%edx
  100c96:	be 00 c0 00 00       	mov    $0xc000,%esi
  100c9b:	bf 30 07 00 00       	mov    $0x730,%edi
  100ca0:	b8 00 00 00 00       	mov    $0x0,%eax
  100ca5:	e8 a6 fd ff ff       	callq  100a50 <console_printf>
    asm volatile ("int %0" : /* no result */
  100caa:	bf 00 00 00 00       	mov    $0x0,%edi
  100caf:	cd 30                	int    $0x30
 loop: goto loop;
  100cb1:	eb fe                	jmp    100cb1 <assert_fail+0x2d>
