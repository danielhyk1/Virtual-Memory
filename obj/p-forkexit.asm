
obj/p-forkexit.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	41 54                	push   %r12
  100006:	53                   	push   %rbx
  100007:	eb 02                	jmp    10000b <process_main+0xb>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  100009:	cd 32                	int    $0x32
    while (1) {
        if (rand() % ALLOC_SLOWDOWN == 0) {
  10000b:	e8 fc 02 00 00       	callq  10030c <rand>
  100010:	48 63 d0             	movslq %eax,%rdx
  100013:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  10001a:	48 c1 fa 25          	sar    $0x25,%rdx
  10001e:	89 c1                	mov    %eax,%ecx
  100020:	c1 f9 1f             	sar    $0x1f,%ecx
  100023:	29 ca                	sub    %ecx,%edx
  100025:	6b d2 64             	imul   $0x64,%edx,%edx
  100028:	39 d0                	cmp    %edx,%eax
  10002a:	75 dd                	jne    100009 <process_main+0x9>
// sys_fork()
//    Fork the current process. On success, return the child's process ID to
//    the parent, and return 0 to the child. On failure, return -1.
static inline pid_t sys_fork(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  10002c:	cd 34                	int    $0x34
            if (sys_fork() == 0) {
  10002e:	85 c0                	test   %eax,%eax
  100030:	75 d9                	jne    10000b <process_main+0xb>
    asm volatile ("int %1" : "=a" (result)
  100032:	cd 31                	int    $0x31
  100034:	89 c7                	mov    %eax,%edi
  100036:	89 c3                	mov    %eax,%ebx
            sys_yield();
        }
    }

    pid_t p = sys_getpid();
    srand(p);
  100038:	e8 09 03 00 00       	callq  100346 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  10003d:	b8 17 20 10 00       	mov    $0x102017,%eax
  100042:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100048:	48 89 05 b9 0f 00 00 	mov    %rax,0xfb9(%rip)        # 101008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  10004f:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  100052:	48 83 e8 01          	sub    $0x1,%rax
  100056:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10005c:	48 89 05 9d 0f 00 00 	mov    %rax,0xf9d(%rip)        # 101000 <stack_bottom>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
            heap_top += PAGESIZE;
            if (console[CPOS(24, 0)]) {
  100063:	41 bc 00 80 0b 00    	mov    $0xb8000,%r12d
  100069:	eb 13                	jmp    10007e <process_main+0x7e>
                /* clear "Out of physical memory" msg */
                console_printf(CPOS(24, 0), 0, "\n");
            }
        } else if (x == 8 * p) {
  10006b:	0f 84 8d 00 00 00    	je     1000fe <process_main+0xfe>
            if (sys_fork() == 0) {
                p = sys_getpid();
            }
        } else if (x == 8 * p + 1) {
  100071:	83 c0 01             	add    $0x1,%eax
  100074:	39 d0                	cmp    %edx,%eax
  100076:	0f 84 95 00 00 00    	je     100111 <process_main+0x111>
    asm volatile ("int %0" : /* no result */
  10007c:	cd 32                	int    $0x32
        int x = rand() % (8 * ALLOC_SLOWDOWN);
  10007e:	e8 89 02 00 00       	callq  10030c <rand>
  100083:	48 63 d0             	movslq %eax,%rdx
  100086:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  10008d:	48 c1 fa 28          	sar    $0x28,%rdx
  100091:	89 c1                	mov    %eax,%ecx
  100093:	c1 f9 1f             	sar    $0x1f,%ecx
  100096:	29 ca                	sub    %ecx,%edx
  100098:	69 ca 20 03 00 00    	imul   $0x320,%edx,%ecx
  10009e:	29 c8                	sub    %ecx,%eax
  1000a0:	89 c2                	mov    %eax,%edx
        if (x < 8 * p) {
  1000a2:	8d 04 dd 00 00 00 00 	lea    0x0(,%rbx,8),%eax
  1000a9:	39 d0                	cmp    %edx,%eax
  1000ab:	7e be                	jle    10006b <process_main+0x6b>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  1000ad:	48 8b 3d 54 0f 00 00 	mov    0xf54(%rip),%rdi        # 101008 <heap_top>
  1000b4:	48 3b 3d 45 0f 00 00 	cmp    0xf45(%rip),%rdi        # 101000 <stack_bottom>
  1000bb:	74 58                	je     100115 <process_main+0x115>
    asm volatile ("int %1" : "=a" (result)
  1000bd:	cd 33                	int    $0x33
  1000bf:	85 c0                	test   %eax,%eax
  1000c1:	78 52                	js     100115 <process_main+0x115>
            *heap_top = p;      /* check we have write access to new page */
  1000c3:	48 8b 05 3e 0f 00 00 	mov    0xf3e(%rip),%rax        # 101008 <heap_top>
  1000ca:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  1000cc:	48 81 05 31 0f 00 00 	addq   $0x1000,0xf31(%rip)        # 101008 <heap_top>
  1000d3:	00 10 00 00 
            if (console[CPOS(24, 0)]) {
  1000d7:	66 41 83 bc 24 00 0f 	cmpw   $0x0,0xf00(%r12)
  1000de:	00 00 00 
  1000e1:	74 9b                	je     10007e <process_main+0x7e>
                console_printf(CPOS(24, 0), 0, "\n");
  1000e3:	ba 60 0b 10 00       	mov    $0x100b60,%edx
  1000e8:	be 00 00 00 00       	mov    $0x0,%esi
  1000ed:	bf 80 07 00 00       	mov    $0x780,%edi
  1000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  1000f7:	e8 7f 09 00 00       	callq  100a7b <console_printf>
  1000fc:	eb 80                	jmp    10007e <process_main+0x7e>
    asm volatile ("int %1" : "=a" (result)
  1000fe:	cd 34                	int    $0x34
            if (sys_fork() == 0) {
  100100:	85 c0                	test   %eax,%eax
  100102:	0f 85 76 ff ff ff    	jne    10007e <process_main+0x7e>
    asm volatile ("int %1" : "=a" (result)
  100108:	cd 31                	int    $0x31
  10010a:	89 c3                	mov    %eax,%ebx
    return result;
  10010c:	e9 6d ff ff ff       	jmpq   10007e <process_main+0x7e>

// sys_exit()
//    Exit this process. Does not return.
static inline void sys_exit(void) __attribute__((noreturn));
static inline void sys_exit(void) {
    asm volatile ("int %0" : /* no result */
  100111:	cd 35                	int    $0x35
                  : "i" (INT_SYS_EXIT)
                  : "cc", "memory");
 spinloop: goto spinloop;       // should never get here
  100113:	eb fe                	jmp    100113 <process_main+0x113>
        }
    }

    // After running out of memory
    while (1) {
        if (rand() % (2 * ALLOC_SLOWDOWN) == 0) {
  100115:	e8 f2 01 00 00       	callq  10030c <rand>
  10011a:	48 63 d0             	movslq %eax,%rdx
  10011d:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  100124:	48 c1 fa 26          	sar    $0x26,%rdx
  100128:	89 c1                	mov    %eax,%ecx
  10012a:	c1 f9 1f             	sar    $0x1f,%ecx
  10012d:	29 ca                	sub    %ecx,%edx
  10012f:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
  100135:	39 d0                	cmp    %edx,%eax
  100137:	74 04                	je     10013d <process_main+0x13d>
    asm volatile ("int %0" : /* no result */
  100139:	cd 32                	int    $0x32
}
  10013b:	eb d8                	jmp    100115 <process_main+0x115>
    asm volatile ("int %0" : /* no result */
  10013d:	cd 35                	int    $0x35
 spinloop: goto spinloop;       // should never get here
  10013f:	eb fe                	jmp    10013f <process_main+0x13f>

0000000000100141 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100141:	48 89 f9             	mov    %rdi,%rcx
  100144:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  100146:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  10014d:	00 
  10014e:	72 08                	jb     100158 <console_putc+0x17>
        cp->cursor = console;
  100150:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  100157:	00 
    }
    if (c == '\n') {
  100158:	40 80 fe 0a          	cmp    $0xa,%sil
  10015c:	74 16                	je     100174 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  10015e:	48 8b 41 08          	mov    0x8(%rcx),%rax
  100162:	48 8d 50 02          	lea    0x2(%rax),%rdx
  100166:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  10016a:	40 0f b6 f6          	movzbl %sil,%esi
  10016e:	09 fe                	or     %edi,%esi
  100170:	66 89 30             	mov    %si,(%rax)
    }
}
  100173:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  100174:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  100178:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  10017f:	4c 89 c6             	mov    %r8,%rsi
  100182:	48 d1 fe             	sar    %rsi
  100185:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  10018c:	66 66 66 
  10018f:	48 89 f0             	mov    %rsi,%rax
  100192:	48 f7 ea             	imul   %rdx
  100195:	48 c1 fa 05          	sar    $0x5,%rdx
  100199:	49 c1 f8 3f          	sar    $0x3f,%r8
  10019d:	4c 29 c2             	sub    %r8,%rdx
  1001a0:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1001a4:	48 c1 e2 04          	shl    $0x4,%rdx
  1001a8:	89 f0                	mov    %esi,%eax
  1001aa:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1001ac:	83 cf 20             	or     $0x20,%edi
  1001af:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1001b3:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  1001b7:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  1001bb:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  1001be:	83 c0 01             	add    $0x1,%eax
  1001c1:	83 f8 50             	cmp    $0x50,%eax
  1001c4:	75 e9                	jne    1001af <console_putc+0x6e>
  1001c6:	c3                   	retq   

00000000001001c7 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  1001c7:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1001cb:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1001cf:	73 0b                	jae    1001dc <string_putc+0x15>
        *sp->s++ = c;
  1001d1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1001d5:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1001d9:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  1001dc:	c3                   	retq   

00000000001001dd <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  1001dd:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1001e0:	48 85 d2             	test   %rdx,%rdx
  1001e3:	74 17                	je     1001fc <memcpy+0x1f>
  1001e5:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  1001ea:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  1001ef:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1001f3:	48 83 c1 01          	add    $0x1,%rcx
  1001f7:	48 39 d1             	cmp    %rdx,%rcx
  1001fa:	75 ee                	jne    1001ea <memcpy+0xd>
}
  1001fc:	c3                   	retq   

00000000001001fd <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  1001fd:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  100200:	48 39 fe             	cmp    %rdi,%rsi
  100203:	72 1d                	jb     100222 <memmove+0x25>
        while (n-- > 0) {
  100205:	b9 00 00 00 00       	mov    $0x0,%ecx
  10020a:	48 85 d2             	test   %rdx,%rdx
  10020d:	74 12                	je     100221 <memmove+0x24>
            *d++ = *s++;
  10020f:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  100213:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  100217:	48 83 c1 01          	add    $0x1,%rcx
  10021b:	48 39 ca             	cmp    %rcx,%rdx
  10021e:	75 ef                	jne    10020f <memmove+0x12>
}
  100220:	c3                   	retq   
  100221:	c3                   	retq   
    if (s < d && s + n > d) {
  100222:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  100226:	48 39 cf             	cmp    %rcx,%rdi
  100229:	73 da                	jae    100205 <memmove+0x8>
        while (n-- > 0) {
  10022b:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  10022f:	48 85 d2             	test   %rdx,%rdx
  100232:	74 ec                	je     100220 <memmove+0x23>
            *--d = *--s;
  100234:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  100238:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  10023b:	48 83 e9 01          	sub    $0x1,%rcx
  10023f:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  100243:	75 ef                	jne    100234 <memmove+0x37>
  100245:	c3                   	retq   

0000000000100246 <memset>:
void* memset(void* v, int c, size_t n) {
  100246:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100249:	48 85 d2             	test   %rdx,%rdx
  10024c:	74 12                	je     100260 <memset+0x1a>
  10024e:	48 01 fa             	add    %rdi,%rdx
  100251:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  100254:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100257:	48 83 c1 01          	add    $0x1,%rcx
  10025b:	48 39 ca             	cmp    %rcx,%rdx
  10025e:	75 f4                	jne    100254 <memset+0xe>
}
  100260:	c3                   	retq   

0000000000100261 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  100261:	80 3f 00             	cmpb   $0x0,(%rdi)
  100264:	74 10                	je     100276 <strlen+0x15>
  100266:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  10026b:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  10026f:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  100273:	75 f6                	jne    10026b <strlen+0xa>
  100275:	c3                   	retq   
  100276:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10027b:	c3                   	retq   

000000000010027c <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  10027c:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10027f:	ba 00 00 00 00       	mov    $0x0,%edx
  100284:	48 85 f6             	test   %rsi,%rsi
  100287:	74 11                	je     10029a <strnlen+0x1e>
  100289:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  10028d:	74 0c                	je     10029b <strnlen+0x1f>
        ++n;
  10028f:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  100293:	48 39 d0             	cmp    %rdx,%rax
  100296:	75 f1                	jne    100289 <strnlen+0xd>
  100298:	eb 04                	jmp    10029e <strnlen+0x22>
  10029a:	c3                   	retq   
  10029b:	48 89 d0             	mov    %rdx,%rax
}
  10029e:	c3                   	retq   

000000000010029f <strcpy>:
char* strcpy(char* dst, const char* src) {
  10029f:	48 89 f8             	mov    %rdi,%rax
  1002a2:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1002a7:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1002ab:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1002ae:	48 83 c2 01          	add    $0x1,%rdx
  1002b2:	84 c9                	test   %cl,%cl
  1002b4:	75 f1                	jne    1002a7 <strcpy+0x8>
}
  1002b6:	c3                   	retq   

00000000001002b7 <strcmp>:
    while (*a && *b && *a == *b) {
  1002b7:	0f b6 07             	movzbl (%rdi),%eax
  1002ba:	84 c0                	test   %al,%al
  1002bc:	74 1a                	je     1002d8 <strcmp+0x21>
  1002be:	0f b6 16             	movzbl (%rsi),%edx
  1002c1:	38 c2                	cmp    %al,%dl
  1002c3:	75 13                	jne    1002d8 <strcmp+0x21>
  1002c5:	84 d2                	test   %dl,%dl
  1002c7:	74 0f                	je     1002d8 <strcmp+0x21>
        ++a, ++b;
  1002c9:	48 83 c7 01          	add    $0x1,%rdi
  1002cd:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  1002d1:	0f b6 07             	movzbl (%rdi),%eax
  1002d4:	84 c0                	test   %al,%al
  1002d6:	75 e6                	jne    1002be <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  1002d8:	3a 06                	cmp    (%rsi),%al
  1002da:	0f 97 c0             	seta   %al
  1002dd:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  1002e0:	83 d8 00             	sbb    $0x0,%eax
}
  1002e3:	c3                   	retq   

00000000001002e4 <strchr>:
    while (*s && *s != (char) c) {
  1002e4:	0f b6 07             	movzbl (%rdi),%eax
  1002e7:	84 c0                	test   %al,%al
  1002e9:	74 10                	je     1002fb <strchr+0x17>
  1002eb:	40 38 f0             	cmp    %sil,%al
  1002ee:	74 18                	je     100308 <strchr+0x24>
        ++s;
  1002f0:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  1002f4:	0f b6 07             	movzbl (%rdi),%eax
  1002f7:	84 c0                	test   %al,%al
  1002f9:	75 f0                	jne    1002eb <strchr+0x7>
        return NULL;
  1002fb:	40 84 f6             	test   %sil,%sil
  1002fe:	b8 00 00 00 00       	mov    $0x0,%eax
  100303:	48 0f 44 c7          	cmove  %rdi,%rax
}
  100307:	c3                   	retq   
  100308:	48 89 f8             	mov    %rdi,%rax
  10030b:	c3                   	retq   

000000000010030c <rand>:
    if (!rand_seed_set) {
  10030c:	83 3d 01 0d 00 00 00 	cmpl   $0x0,0xd01(%rip)        # 101014 <rand_seed_set>
  100313:	74 1b                	je     100330 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  100315:	69 05 f1 0c 00 00 0d 	imul   $0x19660d,0xcf1(%rip),%eax        # 101010 <rand_seed>
  10031c:	66 19 00 
  10031f:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  100324:	89 05 e6 0c 00 00    	mov    %eax,0xce6(%rip)        # 101010 <rand_seed>
    return rand_seed & RAND_MAX;
  10032a:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  10032f:	c3                   	retq   
    rand_seed = seed;
  100330:	c7 05 d6 0c 00 00 9e 	movl   $0x30d4879e,0xcd6(%rip)        # 101010 <rand_seed>
  100337:	87 d4 30 
    rand_seed_set = 1;
  10033a:	c7 05 d0 0c 00 00 01 	movl   $0x1,0xcd0(%rip)        # 101014 <rand_seed_set>
  100341:	00 00 00 
}
  100344:	eb cf                	jmp    100315 <rand+0x9>

0000000000100346 <srand>:
    rand_seed = seed;
  100346:	89 3d c4 0c 00 00    	mov    %edi,0xcc4(%rip)        # 101010 <rand_seed>
    rand_seed_set = 1;
  10034c:	c7 05 be 0c 00 00 01 	movl   $0x1,0xcbe(%rip)        # 101014 <rand_seed_set>
  100353:	00 00 00 
}
  100356:	c3                   	retq   

0000000000100357 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  100357:	55                   	push   %rbp
  100358:	48 89 e5             	mov    %rsp,%rbp
  10035b:	41 57                	push   %r15
  10035d:	41 56                	push   %r14
  10035f:	41 55                	push   %r13
  100361:	41 54                	push   %r12
  100363:	53                   	push   %rbx
  100364:	48 83 ec 58          	sub    $0x58,%rsp
  100368:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  10036c:	0f b6 02             	movzbl (%rdx),%eax
  10036f:	84 c0                	test   %al,%al
  100371:	0f 84 b0 06 00 00    	je     100a27 <printer_vprintf+0x6d0>
  100377:	49 89 fe             	mov    %rdi,%r14
  10037a:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  10037d:	41 89 f7             	mov    %esi,%r15d
  100380:	e9 a4 04 00 00       	jmpq   100829 <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  100385:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  10038a:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  100390:	45 84 e4             	test   %r12b,%r12b
  100393:	0f 84 82 06 00 00    	je     100a1b <printer_vprintf+0x6c4>
        int flags = 0;
  100399:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  10039f:	41 0f be f4          	movsbl %r12b,%esi
  1003a3:	bf 61 0d 10 00       	mov    $0x100d61,%edi
  1003a8:	e8 37 ff ff ff       	callq  1002e4 <strchr>
  1003ad:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  1003b0:	48 85 c0             	test   %rax,%rax
  1003b3:	74 55                	je     10040a <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  1003b5:	48 81 e9 61 0d 10 00 	sub    $0x100d61,%rcx
  1003bc:	b8 01 00 00 00       	mov    $0x1,%eax
  1003c1:	d3 e0                	shl    %cl,%eax
  1003c3:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  1003c6:	48 83 c3 01          	add    $0x1,%rbx
  1003ca:	44 0f b6 23          	movzbl (%rbx),%r12d
  1003ce:	45 84 e4             	test   %r12b,%r12b
  1003d1:	75 cc                	jne    10039f <printer_vprintf+0x48>
  1003d3:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  1003d7:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  1003dd:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  1003e4:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  1003e7:	0f 84 a9 00 00 00    	je     100496 <printer_vprintf+0x13f>
        int length = 0;
  1003ed:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  1003f2:	0f b6 13             	movzbl (%rbx),%edx
  1003f5:	8d 42 bd             	lea    -0x43(%rdx),%eax
  1003f8:	3c 37                	cmp    $0x37,%al
  1003fa:	0f 87 c4 04 00 00    	ja     1008c4 <printer_vprintf+0x56d>
  100400:	0f b6 c0             	movzbl %al,%eax
  100403:	ff 24 c5 70 0b 10 00 	jmpq   *0x100b70(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  10040a:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  10040e:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  100413:	3c 08                	cmp    $0x8,%al
  100415:	77 2f                	ja     100446 <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100417:	0f b6 03             	movzbl (%rbx),%eax
  10041a:	8d 50 d0             	lea    -0x30(%rax),%edx
  10041d:	80 fa 09             	cmp    $0x9,%dl
  100420:	77 5e                	ja     100480 <printer_vprintf+0x129>
  100422:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  100428:	48 83 c3 01          	add    $0x1,%rbx
  10042c:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  100431:	0f be c0             	movsbl %al,%eax
  100434:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100439:	0f b6 03             	movzbl (%rbx),%eax
  10043c:	8d 50 d0             	lea    -0x30(%rax),%edx
  10043f:	80 fa 09             	cmp    $0x9,%dl
  100442:	76 e4                	jbe    100428 <printer_vprintf+0xd1>
  100444:	eb 97                	jmp    1003dd <printer_vprintf+0x86>
        } else if (*format == '*') {
  100446:	41 80 fc 2a          	cmp    $0x2a,%r12b
  10044a:	75 3f                	jne    10048b <printer_vprintf+0x134>
            width = va_arg(val, int);
  10044c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100450:	8b 07                	mov    (%rdi),%eax
  100452:	83 f8 2f             	cmp    $0x2f,%eax
  100455:	77 17                	ja     10046e <printer_vprintf+0x117>
  100457:	89 c2                	mov    %eax,%edx
  100459:	48 03 57 10          	add    0x10(%rdi),%rdx
  10045d:	83 c0 08             	add    $0x8,%eax
  100460:	89 07                	mov    %eax,(%rdi)
  100462:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  100465:	48 83 c3 01          	add    $0x1,%rbx
  100469:	e9 6f ff ff ff       	jmpq   1003dd <printer_vprintf+0x86>
            width = va_arg(val, int);
  10046e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100472:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100476:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10047a:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10047e:	eb e2                	jmp    100462 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100480:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  100486:	e9 52 ff ff ff       	jmpq   1003dd <printer_vprintf+0x86>
        int width = -1;
  10048b:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  100491:	e9 47 ff ff ff       	jmpq   1003dd <printer_vprintf+0x86>
            ++format;
  100496:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  10049a:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  10049e:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1004a1:	80 f9 09             	cmp    $0x9,%cl
  1004a4:	76 13                	jbe    1004b9 <printer_vprintf+0x162>
            } else if (*format == '*') {
  1004a6:	3c 2a                	cmp    $0x2a,%al
  1004a8:	74 33                	je     1004dd <printer_vprintf+0x186>
            ++format;
  1004aa:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  1004ad:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  1004b4:	e9 34 ff ff ff       	jmpq   1003ed <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1004b9:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  1004be:	48 83 c2 01          	add    $0x1,%rdx
  1004c2:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  1004c5:	0f be c0             	movsbl %al,%eax
  1004c8:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1004cc:	0f b6 02             	movzbl (%rdx),%eax
  1004cf:	8d 70 d0             	lea    -0x30(%rax),%esi
  1004d2:	40 80 fe 09          	cmp    $0x9,%sil
  1004d6:	76 e6                	jbe    1004be <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  1004d8:	48 89 d3             	mov    %rdx,%rbx
  1004db:	eb 1c                	jmp    1004f9 <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  1004dd:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004e1:	8b 07                	mov    (%rdi),%eax
  1004e3:	83 f8 2f             	cmp    $0x2f,%eax
  1004e6:	77 23                	ja     10050b <printer_vprintf+0x1b4>
  1004e8:	89 c2                	mov    %eax,%edx
  1004ea:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004ee:	83 c0 08             	add    $0x8,%eax
  1004f1:	89 07                	mov    %eax,(%rdi)
  1004f3:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  1004f5:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  1004f9:	85 c9                	test   %ecx,%ecx
  1004fb:	b8 00 00 00 00       	mov    $0x0,%eax
  100500:	0f 49 c1             	cmovns %ecx,%eax
  100503:	89 45 9c             	mov    %eax,-0x64(%rbp)
  100506:	e9 e2 fe ff ff       	jmpq   1003ed <printer_vprintf+0x96>
                precision = va_arg(val, int);
  10050b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10050f:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100513:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100517:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10051b:	eb d6                	jmp    1004f3 <printer_vprintf+0x19c>
        switch (*format) {
  10051d:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  100522:	e9 f3 00 00 00       	jmpq   10061a <printer_vprintf+0x2c3>
            ++format;
  100527:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  10052b:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  100530:	e9 bd fe ff ff       	jmpq   1003f2 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100535:	85 c9                	test   %ecx,%ecx
  100537:	74 55                	je     10058e <printer_vprintf+0x237>
  100539:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10053d:	8b 07                	mov    (%rdi),%eax
  10053f:	83 f8 2f             	cmp    $0x2f,%eax
  100542:	77 38                	ja     10057c <printer_vprintf+0x225>
  100544:	89 c2                	mov    %eax,%edx
  100546:	48 03 57 10          	add    0x10(%rdi),%rdx
  10054a:	83 c0 08             	add    $0x8,%eax
  10054d:	89 07                	mov    %eax,(%rdi)
  10054f:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  100552:	48 89 d0             	mov    %rdx,%rax
  100555:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  100559:	49 89 d0             	mov    %rdx,%r8
  10055c:	49 f7 d8             	neg    %r8
  10055f:	25 80 00 00 00       	and    $0x80,%eax
  100564:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  100568:	0b 45 a8             	or     -0x58(%rbp),%eax
  10056b:	83 c8 60             	or     $0x60,%eax
  10056e:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  100571:	41 bc 61 0b 10 00    	mov    $0x100b61,%r12d
            break;
  100577:	e9 35 01 00 00       	jmpq   1006b1 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  10057c:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100580:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100584:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100588:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10058c:	eb c1                	jmp    10054f <printer_vprintf+0x1f8>
  10058e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100592:	8b 07                	mov    (%rdi),%eax
  100594:	83 f8 2f             	cmp    $0x2f,%eax
  100597:	77 10                	ja     1005a9 <printer_vprintf+0x252>
  100599:	89 c2                	mov    %eax,%edx
  10059b:	48 03 57 10          	add    0x10(%rdi),%rdx
  10059f:	83 c0 08             	add    $0x8,%eax
  1005a2:	89 07                	mov    %eax,(%rdi)
  1005a4:	48 63 12             	movslq (%rdx),%rdx
  1005a7:	eb a9                	jmp    100552 <printer_vprintf+0x1fb>
  1005a9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1005ad:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1005b1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005b5:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1005b9:	eb e9                	jmp    1005a4 <printer_vprintf+0x24d>
        int base = 10;
  1005bb:	be 0a 00 00 00       	mov    $0xa,%esi
  1005c0:	eb 58                	jmp    10061a <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1005c2:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005c6:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005ca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005ce:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005d2:	eb 60                	jmp    100634 <printer_vprintf+0x2dd>
  1005d4:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1005d8:	8b 07                	mov    (%rdi),%eax
  1005da:	83 f8 2f             	cmp    $0x2f,%eax
  1005dd:	77 10                	ja     1005ef <printer_vprintf+0x298>
  1005df:	89 c2                	mov    %eax,%edx
  1005e1:	48 03 57 10          	add    0x10(%rdi),%rdx
  1005e5:	83 c0 08             	add    $0x8,%eax
  1005e8:	89 07                	mov    %eax,(%rdi)
  1005ea:	44 8b 02             	mov    (%rdx),%r8d
  1005ed:	eb 48                	jmp    100637 <printer_vprintf+0x2e0>
  1005ef:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005f3:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005f7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005fb:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005ff:	eb e9                	jmp    1005ea <printer_vprintf+0x293>
  100601:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  100604:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  10060b:	bf 50 0d 10 00       	mov    $0x100d50,%edi
  100610:	e9 e2 02 00 00       	jmpq   1008f7 <printer_vprintf+0x5a0>
            base = 16;
  100615:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  10061a:	85 c9                	test   %ecx,%ecx
  10061c:	74 b6                	je     1005d4 <printer_vprintf+0x27d>
  10061e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100622:	8b 01                	mov    (%rcx),%eax
  100624:	83 f8 2f             	cmp    $0x2f,%eax
  100627:	77 99                	ja     1005c2 <printer_vprintf+0x26b>
  100629:	89 c2                	mov    %eax,%edx
  10062b:	48 03 51 10          	add    0x10(%rcx),%rdx
  10062f:	83 c0 08             	add    $0x8,%eax
  100632:	89 01                	mov    %eax,(%rcx)
  100634:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  100637:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  10063b:	85 f6                	test   %esi,%esi
  10063d:	79 c2                	jns    100601 <printer_vprintf+0x2aa>
        base = -base;
  10063f:	41 89 f1             	mov    %esi,%r9d
  100642:	f7 de                	neg    %esi
  100644:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  10064b:	bf 30 0d 10 00       	mov    $0x100d30,%edi
  100650:	e9 a2 02 00 00       	jmpq   1008f7 <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  100655:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100659:	8b 07                	mov    (%rdi),%eax
  10065b:	83 f8 2f             	cmp    $0x2f,%eax
  10065e:	77 1c                	ja     10067c <printer_vprintf+0x325>
  100660:	89 c2                	mov    %eax,%edx
  100662:	48 03 57 10          	add    0x10(%rdi),%rdx
  100666:	83 c0 08             	add    $0x8,%eax
  100669:	89 07                	mov    %eax,(%rdi)
  10066b:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  10066e:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  100675:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  10067a:	eb c3                	jmp    10063f <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  10067c:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100680:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100684:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100688:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10068c:	eb dd                	jmp    10066b <printer_vprintf+0x314>
            data = va_arg(val, char*);
  10068e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100692:	8b 01                	mov    (%rcx),%eax
  100694:	83 f8 2f             	cmp    $0x2f,%eax
  100697:	0f 87 a5 01 00 00    	ja     100842 <printer_vprintf+0x4eb>
  10069d:	89 c2                	mov    %eax,%edx
  10069f:	48 03 51 10          	add    0x10(%rcx),%rdx
  1006a3:	83 c0 08             	add    $0x8,%eax
  1006a6:	89 01                	mov    %eax,(%rcx)
  1006a8:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  1006ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  1006b1:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1006b4:	83 e0 20             	and    $0x20,%eax
  1006b7:	89 45 8c             	mov    %eax,-0x74(%rbp)
  1006ba:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  1006c0:	0f 85 21 02 00 00    	jne    1008e7 <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  1006c6:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1006c9:	89 45 88             	mov    %eax,-0x78(%rbp)
  1006cc:	83 e0 60             	and    $0x60,%eax
  1006cf:	83 f8 60             	cmp    $0x60,%eax
  1006d2:	0f 84 54 02 00 00    	je     10092c <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1006d8:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1006db:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  1006de:	48 c7 45 a0 61 0b 10 	movq   $0x100b61,-0x60(%rbp)
  1006e5:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1006e6:	83 f8 21             	cmp    $0x21,%eax
  1006e9:	0f 84 79 02 00 00    	je     100968 <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  1006ef:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  1006f2:	89 f8                	mov    %edi,%eax
  1006f4:	f7 d0                	not    %eax
  1006f6:	c1 e8 1f             	shr    $0x1f,%eax
  1006f9:	89 45 84             	mov    %eax,-0x7c(%rbp)
  1006fc:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  100700:	0f 85 9e 02 00 00    	jne    1009a4 <printer_vprintf+0x64d>
  100706:	84 c0                	test   %al,%al
  100708:	0f 84 96 02 00 00    	je     1009a4 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  10070e:	48 63 f7             	movslq %edi,%rsi
  100711:	4c 89 e7             	mov    %r12,%rdi
  100714:	e8 63 fb ff ff       	callq  10027c <strnlen>
  100719:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  10071c:	8b 45 88             	mov    -0x78(%rbp),%eax
  10071f:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  100722:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100729:	83 f8 22             	cmp    $0x22,%eax
  10072c:	0f 84 aa 02 00 00    	je     1009dc <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  100732:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100736:	e8 26 fb ff ff       	callq  100261 <strlen>
  10073b:	8b 55 9c             	mov    -0x64(%rbp),%edx
  10073e:	03 55 98             	add    -0x68(%rbp),%edx
  100741:	44 89 e9             	mov    %r13d,%ecx
  100744:	29 d1                	sub    %edx,%ecx
  100746:	29 c1                	sub    %eax,%ecx
  100748:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  10074b:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  10074e:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  100752:	75 2d                	jne    100781 <printer_vprintf+0x42a>
  100754:	85 c9                	test   %ecx,%ecx
  100756:	7e 29                	jle    100781 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  100758:	44 89 fa             	mov    %r15d,%edx
  10075b:	be 20 00 00 00       	mov    $0x20,%esi
  100760:	4c 89 f7             	mov    %r14,%rdi
  100763:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100766:	41 83 ed 01          	sub    $0x1,%r13d
  10076a:	45 85 ed             	test   %r13d,%r13d
  10076d:	7f e9                	jg     100758 <printer_vprintf+0x401>
  10076f:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  100772:	85 ff                	test   %edi,%edi
  100774:	b8 01 00 00 00       	mov    $0x1,%eax
  100779:	0f 4f c7             	cmovg  %edi,%eax
  10077c:	29 c7                	sub    %eax,%edi
  10077e:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  100781:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100785:	0f b6 07             	movzbl (%rdi),%eax
  100788:	84 c0                	test   %al,%al
  10078a:	74 22                	je     1007ae <printer_vprintf+0x457>
  10078c:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100790:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  100793:	0f b6 f0             	movzbl %al,%esi
  100796:	44 89 fa             	mov    %r15d,%edx
  100799:	4c 89 f7             	mov    %r14,%rdi
  10079c:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  10079f:	48 83 c3 01          	add    $0x1,%rbx
  1007a3:	0f b6 03             	movzbl (%rbx),%eax
  1007a6:	84 c0                	test   %al,%al
  1007a8:	75 e9                	jne    100793 <printer_vprintf+0x43c>
  1007aa:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  1007ae:	8b 45 9c             	mov    -0x64(%rbp),%eax
  1007b1:	85 c0                	test   %eax,%eax
  1007b3:	7e 1d                	jle    1007d2 <printer_vprintf+0x47b>
  1007b5:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1007b9:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  1007bb:	44 89 fa             	mov    %r15d,%edx
  1007be:	be 30 00 00 00       	mov    $0x30,%esi
  1007c3:	4c 89 f7             	mov    %r14,%rdi
  1007c6:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  1007c9:	83 eb 01             	sub    $0x1,%ebx
  1007cc:	75 ed                	jne    1007bb <printer_vprintf+0x464>
  1007ce:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  1007d2:	8b 45 98             	mov    -0x68(%rbp),%eax
  1007d5:	85 c0                	test   %eax,%eax
  1007d7:	7e 27                	jle    100800 <printer_vprintf+0x4a9>
  1007d9:	89 c0                	mov    %eax,%eax
  1007db:	4c 01 e0             	add    %r12,%rax
  1007de:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1007e2:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  1007e5:	41 0f b6 34 24       	movzbl (%r12),%esi
  1007ea:	44 89 fa             	mov    %r15d,%edx
  1007ed:	4c 89 f7             	mov    %r14,%rdi
  1007f0:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  1007f3:	49 83 c4 01          	add    $0x1,%r12
  1007f7:	49 39 dc             	cmp    %rbx,%r12
  1007fa:	75 e9                	jne    1007e5 <printer_vprintf+0x48e>
  1007fc:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  100800:	45 85 ed             	test   %r13d,%r13d
  100803:	7e 14                	jle    100819 <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  100805:	44 89 fa             	mov    %r15d,%edx
  100808:	be 20 00 00 00       	mov    $0x20,%esi
  10080d:	4c 89 f7             	mov    %r14,%rdi
  100810:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  100813:	41 83 ed 01          	sub    $0x1,%r13d
  100817:	75 ec                	jne    100805 <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  100819:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  10081d:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  100821:	84 c0                	test   %al,%al
  100823:	0f 84 fe 01 00 00    	je     100a27 <printer_vprintf+0x6d0>
        if (*format != '%') {
  100829:	3c 25                	cmp    $0x25,%al
  10082b:	0f 84 54 fb ff ff    	je     100385 <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  100831:	0f b6 f0             	movzbl %al,%esi
  100834:	44 89 fa             	mov    %r15d,%edx
  100837:	4c 89 f7             	mov    %r14,%rdi
  10083a:	41 ff 16             	callq  *(%r14)
            continue;
  10083d:	4c 89 e3             	mov    %r12,%rbx
  100840:	eb d7                	jmp    100819 <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  100842:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100846:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10084a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10084e:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100852:	e9 51 fe ff ff       	jmpq   1006a8 <printer_vprintf+0x351>
            color = va_arg(val, int);
  100857:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10085b:	8b 07                	mov    (%rdi),%eax
  10085d:	83 f8 2f             	cmp    $0x2f,%eax
  100860:	77 10                	ja     100872 <printer_vprintf+0x51b>
  100862:	89 c2                	mov    %eax,%edx
  100864:	48 03 57 10          	add    0x10(%rdi),%rdx
  100868:	83 c0 08             	add    $0x8,%eax
  10086b:	89 07                	mov    %eax,(%rdi)
  10086d:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  100870:	eb a7                	jmp    100819 <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  100872:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100876:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10087a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10087e:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100882:	eb e9                	jmp    10086d <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  100884:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100888:	8b 01                	mov    (%rcx),%eax
  10088a:	83 f8 2f             	cmp    $0x2f,%eax
  10088d:	77 23                	ja     1008b2 <printer_vprintf+0x55b>
  10088f:	89 c2                	mov    %eax,%edx
  100891:	48 03 51 10          	add    0x10(%rcx),%rdx
  100895:	83 c0 08             	add    $0x8,%eax
  100898:	89 01                	mov    %eax,(%rcx)
  10089a:	8b 02                	mov    (%rdx),%eax
  10089c:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  10089f:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1008a3:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1008a7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  1008ad:	e9 ff fd ff ff       	jmpq   1006b1 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  1008b2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1008b6:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1008ba:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1008be:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1008c2:	eb d6                	jmp    10089a <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  1008c4:	84 d2                	test   %dl,%dl
  1008c6:	0f 85 39 01 00 00    	jne    100a05 <printer_vprintf+0x6ae>
  1008cc:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  1008d0:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  1008d4:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  1008d8:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1008dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1008e2:	e9 ca fd ff ff       	jmpq   1006b1 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  1008e7:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  1008ed:	bf 50 0d 10 00       	mov    $0x100d50,%edi
        if (flags & FLAG_NUMERIC) {
  1008f2:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  1008f7:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  1008fb:	4c 89 c1             	mov    %r8,%rcx
  1008fe:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  100902:	48 63 f6             	movslq %esi,%rsi
  100905:	49 83 ec 01          	sub    $0x1,%r12
  100909:	48 89 c8             	mov    %rcx,%rax
  10090c:	ba 00 00 00 00       	mov    $0x0,%edx
  100911:	48 f7 f6             	div    %rsi
  100914:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  100918:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  10091c:	48 89 ca             	mov    %rcx,%rdx
  10091f:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  100922:	48 39 d6             	cmp    %rdx,%rsi
  100925:	76 de                	jbe    100905 <printer_vprintf+0x5ae>
  100927:	e9 9a fd ff ff       	jmpq   1006c6 <printer_vprintf+0x36f>
                prefix = "-";
  10092c:	48 c7 45 a0 67 0b 10 	movq   $0x100b67,-0x60(%rbp)
  100933:	00 
            if (flags & FLAG_NEGATIVE) {
  100934:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100937:	a8 80                	test   $0x80,%al
  100939:	0f 85 b0 fd ff ff    	jne    1006ef <printer_vprintf+0x398>
                prefix = "+";
  10093f:	48 c7 45 a0 62 0b 10 	movq   $0x100b62,-0x60(%rbp)
  100946:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100947:	a8 10                	test   $0x10,%al
  100949:	0f 85 a0 fd ff ff    	jne    1006ef <printer_vprintf+0x398>
                prefix = " ";
  10094f:	a8 08                	test   $0x8,%al
  100951:	ba 61 0b 10 00       	mov    $0x100b61,%edx
  100956:	b8 69 0b 10 00       	mov    $0x100b69,%eax
  10095b:	48 0f 44 c2          	cmove  %rdx,%rax
  10095f:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  100963:	e9 87 fd ff ff       	jmpq   1006ef <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  100968:	41 8d 41 10          	lea    0x10(%r9),%eax
  10096c:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  100971:	0f 85 78 fd ff ff    	jne    1006ef <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  100977:	4d 85 c0             	test   %r8,%r8
  10097a:	75 0d                	jne    100989 <printer_vprintf+0x632>
  10097c:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  100983:	0f 84 66 fd ff ff    	je     1006ef <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  100989:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  10098d:	ba 6b 0b 10 00       	mov    $0x100b6b,%edx
  100992:	b8 64 0b 10 00       	mov    $0x100b64,%eax
  100997:	48 0f 44 c2          	cmove  %rdx,%rax
  10099b:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  10099f:	e9 4b fd ff ff       	jmpq   1006ef <printer_vprintf+0x398>
            len = strlen(data);
  1009a4:	4c 89 e7             	mov    %r12,%rdi
  1009a7:	e8 b5 f8 ff ff       	callq  100261 <strlen>
  1009ac:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1009af:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  1009b3:	0f 84 63 fd ff ff    	je     10071c <printer_vprintf+0x3c5>
  1009b9:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  1009bd:	0f 84 59 fd ff ff    	je     10071c <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  1009c3:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  1009c6:	89 ca                	mov    %ecx,%edx
  1009c8:	29 c2                	sub    %eax,%edx
  1009ca:	39 c1                	cmp    %eax,%ecx
  1009cc:	b8 00 00 00 00       	mov    $0x0,%eax
  1009d1:	0f 4e d0             	cmovle %eax,%edx
  1009d4:	89 55 9c             	mov    %edx,-0x64(%rbp)
  1009d7:	e9 56 fd ff ff       	jmpq   100732 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  1009dc:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1009e0:	e8 7c f8 ff ff       	callq  100261 <strlen>
  1009e5:	8b 7d 98             	mov    -0x68(%rbp),%edi
  1009e8:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  1009eb:	44 89 e9             	mov    %r13d,%ecx
  1009ee:	29 f9                	sub    %edi,%ecx
  1009f0:	29 c1                	sub    %eax,%ecx
  1009f2:	44 39 ea             	cmp    %r13d,%edx
  1009f5:	b8 00 00 00 00       	mov    $0x0,%eax
  1009fa:	0f 4d c8             	cmovge %eax,%ecx
  1009fd:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  100a00:	e9 2d fd ff ff       	jmpq   100732 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  100a05:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  100a08:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  100a0c:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100a10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100a16:	e9 96 fc ff ff       	jmpq   1006b1 <printer_vprintf+0x35a>
        int flags = 0;
  100a1b:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  100a22:	e9 b0 f9 ff ff       	jmpq   1003d7 <printer_vprintf+0x80>
}
  100a27:	48 83 c4 58          	add    $0x58,%rsp
  100a2b:	5b                   	pop    %rbx
  100a2c:	41 5c                	pop    %r12
  100a2e:	41 5d                	pop    %r13
  100a30:	41 5e                	pop    %r14
  100a32:	41 5f                	pop    %r15
  100a34:	5d                   	pop    %rbp
  100a35:	c3                   	retq   

0000000000100a36 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100a36:	55                   	push   %rbp
  100a37:	48 89 e5             	mov    %rsp,%rbp
  100a3a:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  100a3e:	48 c7 45 f0 41 01 10 	movq   $0x100141,-0x10(%rbp)
  100a45:	00 
        cpos = 0;
  100a46:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  100a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  100a51:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  100a54:	48 63 ff             	movslq %edi,%rdi
  100a57:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  100a5e:	00 
  100a5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  100a63:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  100a67:	e8 eb f8 ff ff       	callq  100357 <printer_vprintf>
    return cp.cursor - console;
  100a6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100a70:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  100a76:	48 d1 f8             	sar    %rax
}
  100a79:	c9                   	leaveq 
  100a7a:	c3                   	retq   

0000000000100a7b <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  100a7b:	55                   	push   %rbp
  100a7c:	48 89 e5             	mov    %rsp,%rbp
  100a7f:	48 83 ec 50          	sub    $0x50,%rsp
  100a83:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100a87:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100a8b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  100a8f:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100a96:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100a9a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100a9e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100aa2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  100aa6:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100aaa:	e8 87 ff ff ff       	callq  100a36 <console_vprintf>
}
  100aaf:	c9                   	leaveq 
  100ab0:	c3                   	retq   

0000000000100ab1 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100ab1:	55                   	push   %rbp
  100ab2:	48 89 e5             	mov    %rsp,%rbp
  100ab5:	53                   	push   %rbx
  100ab6:	48 83 ec 28          	sub    $0x28,%rsp
  100aba:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  100abd:	48 c7 45 d8 c7 01 10 	movq   $0x1001c7,-0x28(%rbp)
  100ac4:	00 
    sp.s = s;
  100ac5:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  100ac9:	48 85 f6             	test   %rsi,%rsi
  100acc:	75 0b                	jne    100ad9 <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  100ace:	8b 45 e0             	mov    -0x20(%rbp),%eax
  100ad1:	29 d8                	sub    %ebx,%eax
}
  100ad3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100ad7:	c9                   	leaveq 
  100ad8:	c3                   	retq   
        sp.end = s + size - 1;
  100ad9:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100ade:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100ae2:	be 00 00 00 00       	mov    $0x0,%esi
  100ae7:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100aeb:	e8 67 f8 ff ff       	callq  100357 <printer_vprintf>
        *sp.s = 0;
  100af0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100af4:	c6 00 00             	movb   $0x0,(%rax)
  100af7:	eb d5                	jmp    100ace <vsnprintf+0x1d>

0000000000100af9 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100af9:	55                   	push   %rbp
  100afa:	48 89 e5             	mov    %rsp,%rbp
  100afd:	48 83 ec 50          	sub    $0x50,%rsp
  100b01:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100b05:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100b09:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100b0d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100b14:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100b18:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100b1c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100b20:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100b24:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100b28:	e8 84 ff ff ff       	callq  100ab1 <vsnprintf>
    va_end(val);
    return n;
}
  100b2d:	c9                   	leaveq 
  100b2e:	c3                   	retq   

0000000000100b2f <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b2f:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  100b34:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  100b39:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b3e:	48 83 c0 02          	add    $0x2,%rax
  100b42:	48 39 d0             	cmp    %rdx,%rax
  100b45:	75 f2                	jne    100b39 <console_clear+0xa>
    }
    cursorpos = 0;
  100b47:	c7 05 ab 84 fb ff 00 	movl   $0x0,-0x47b55(%rip)        # b8ffc <cursorpos>
  100b4e:	00 00 00 
}
  100b51:	c3                   	retq   
