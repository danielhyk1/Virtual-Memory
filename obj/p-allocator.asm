
obj/p-allocator.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	53                   	push   %rbx
  100005:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100009:	cd 31                	int    $0x31
  10000b:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  10000d:	89 c7                	mov    %eax,%edi
  10000f:	e8 82 02 00 00       	callq  100296 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  100014:	b8 17 20 10 00       	mov    $0x102017,%eax
  100019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10001f:	48 89 05 e2 0f 00 00 	mov    %rax,0xfe2(%rip)        # 101008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  100026:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  100029:	48 83 e8 01          	sub    $0x1,%rax
  10002d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100033:	48 89 05 c6 0f 00 00 	mov    %rax,0xfc6(%rip)        # 101000 <stack_bottom>
  10003a:	eb 02                	jmp    10003e <process_main+0x3e>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  10003c:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  10003e:	e8 19 02 00 00       	callq  10025c <rand>
  100043:	48 63 d0             	movslq %eax,%rdx
  100046:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  10004d:	48 c1 fa 25          	sar    $0x25,%rdx
  100051:	89 c1                	mov    %eax,%ecx
  100053:	c1 f9 1f             	sar    $0x1f,%ecx
  100056:	29 ca                	sub    %ecx,%edx
  100058:	6b d2 64             	imul   $0x64,%edx,%edx
  10005b:	29 d0                	sub    %edx,%eax
  10005d:	39 d8                	cmp    %ebx,%eax
  10005f:	7d db                	jge    10003c <process_main+0x3c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  100061:	48 8b 3d a0 0f 00 00 	mov    0xfa0(%rip),%rdi        # 101008 <heap_top>
  100068:	48 3b 3d 91 0f 00 00 	cmp    0xf91(%rip),%rdi        # 101000 <stack_bottom>
  10006f:	74 1c                	je     10008d <process_main+0x8d>
//    Allocate a page of memory at address `addr` and allow process to
//    write to it. `Addr` must be page-aligned (i.e., a multiple of
//    PAGESIZE == 4096). Returns 0 on success and -1 on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  100071:	cd 33                	int    $0x33
  100073:	85 c0                	test   %eax,%eax
  100075:	78 16                	js     10008d <process_main+0x8d>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  100077:	48 8b 05 8a 0f 00 00 	mov    0xf8a(%rip),%rax        # 101008 <heap_top>
  10007e:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  100080:	48 81 05 7d 0f 00 00 	addq   $0x1000,0xf7d(%rip)        # 101008 <heap_top>
  100087:	00 10 00 00 
  10008b:	eb af                	jmp    10003c <process_main+0x3c>
    asm volatile ("int %0" : /* no result */
  10008d:	cd 32                	int    $0x32
  10008f:	eb fc                	jmp    10008d <process_main+0x8d>

0000000000100091 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100091:	48 89 f9             	mov    %rdi,%rcx
  100094:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  100096:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  10009d:	00 
  10009e:	72 08                	jb     1000a8 <console_putc+0x17>
        cp->cursor = console;
  1000a0:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  1000a7:	00 
    }
    if (c == '\n') {
  1000a8:	40 80 fe 0a          	cmp    $0xa,%sil
  1000ac:	74 16                	je     1000c4 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1000ae:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1000b2:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1000b6:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1000ba:	40 0f b6 f6          	movzbl %sil,%esi
  1000be:	09 fe                	or     %edi,%esi
  1000c0:	66 89 30             	mov    %si,(%rax)
    }
}
  1000c3:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1000c4:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1000c8:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  1000cf:	4c 89 c6             	mov    %r8,%rsi
  1000d2:	48 d1 fe             	sar    %rsi
  1000d5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1000dc:	66 66 66 
  1000df:	48 89 f0             	mov    %rsi,%rax
  1000e2:	48 f7 ea             	imul   %rdx
  1000e5:	48 c1 fa 05          	sar    $0x5,%rdx
  1000e9:	49 c1 f8 3f          	sar    $0x3f,%r8
  1000ed:	4c 29 c2             	sub    %r8,%rdx
  1000f0:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1000f4:	48 c1 e2 04          	shl    $0x4,%rdx
  1000f8:	89 f0                	mov    %esi,%eax
  1000fa:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1000fc:	83 cf 20             	or     $0x20,%edi
  1000ff:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100103:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  100107:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  10010b:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  10010e:	83 c0 01             	add    $0x1,%eax
  100111:	83 f8 50             	cmp    $0x50,%eax
  100114:	75 e9                	jne    1000ff <console_putc+0x6e>
  100116:	c3                   	retq   

0000000000100117 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  100117:	48 8b 47 08          	mov    0x8(%rdi),%rax
  10011b:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  10011f:	73 0b                	jae    10012c <string_putc+0x15>
        *sp->s++ = c;
  100121:	48 8d 50 01          	lea    0x1(%rax),%rdx
  100125:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  100129:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  10012c:	c3                   	retq   

000000000010012d <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  10012d:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  100130:	48 85 d2             	test   %rdx,%rdx
  100133:	74 17                	je     10014c <memcpy+0x1f>
  100135:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  10013a:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  10013f:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  100143:	48 83 c1 01          	add    $0x1,%rcx
  100147:	48 39 d1             	cmp    %rdx,%rcx
  10014a:	75 ee                	jne    10013a <memcpy+0xd>
}
  10014c:	c3                   	retq   

000000000010014d <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  10014d:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  100150:	48 39 fe             	cmp    %rdi,%rsi
  100153:	72 1d                	jb     100172 <memmove+0x25>
        while (n-- > 0) {
  100155:	b9 00 00 00 00       	mov    $0x0,%ecx
  10015a:	48 85 d2             	test   %rdx,%rdx
  10015d:	74 12                	je     100171 <memmove+0x24>
            *d++ = *s++;
  10015f:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  100163:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  100167:	48 83 c1 01          	add    $0x1,%rcx
  10016b:	48 39 ca             	cmp    %rcx,%rdx
  10016e:	75 ef                	jne    10015f <memmove+0x12>
}
  100170:	c3                   	retq   
  100171:	c3                   	retq   
    if (s < d && s + n > d) {
  100172:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  100176:	48 39 cf             	cmp    %rcx,%rdi
  100179:	73 da                	jae    100155 <memmove+0x8>
        while (n-- > 0) {
  10017b:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  10017f:	48 85 d2             	test   %rdx,%rdx
  100182:	74 ec                	je     100170 <memmove+0x23>
            *--d = *--s;
  100184:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  100188:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  10018b:	48 83 e9 01          	sub    $0x1,%rcx
  10018f:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  100193:	75 ef                	jne    100184 <memmove+0x37>
  100195:	c3                   	retq   

0000000000100196 <memset>:
void* memset(void* v, int c, size_t n) {
  100196:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100199:	48 85 d2             	test   %rdx,%rdx
  10019c:	74 12                	je     1001b0 <memset+0x1a>
  10019e:	48 01 fa             	add    %rdi,%rdx
  1001a1:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1001a4:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1001a7:	48 83 c1 01          	add    $0x1,%rcx
  1001ab:	48 39 ca             	cmp    %rcx,%rdx
  1001ae:	75 f4                	jne    1001a4 <memset+0xe>
}
  1001b0:	c3                   	retq   

00000000001001b1 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1001b1:	80 3f 00             	cmpb   $0x0,(%rdi)
  1001b4:	74 10                	je     1001c6 <strlen+0x15>
  1001b6:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1001bb:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1001bf:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1001c3:	75 f6                	jne    1001bb <strlen+0xa>
  1001c5:	c3                   	retq   
  1001c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1001cb:	c3                   	retq   

00000000001001cc <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1001cc:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1001cf:	ba 00 00 00 00       	mov    $0x0,%edx
  1001d4:	48 85 f6             	test   %rsi,%rsi
  1001d7:	74 11                	je     1001ea <strnlen+0x1e>
  1001d9:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  1001dd:	74 0c                	je     1001eb <strnlen+0x1f>
        ++n;
  1001df:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1001e3:	48 39 d0             	cmp    %rdx,%rax
  1001e6:	75 f1                	jne    1001d9 <strnlen+0xd>
  1001e8:	eb 04                	jmp    1001ee <strnlen+0x22>
  1001ea:	c3                   	retq   
  1001eb:	48 89 d0             	mov    %rdx,%rax
}
  1001ee:	c3                   	retq   

00000000001001ef <strcpy>:
char* strcpy(char* dst, const char* src) {
  1001ef:	48 89 f8             	mov    %rdi,%rax
  1001f2:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1001f7:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1001fb:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1001fe:	48 83 c2 01          	add    $0x1,%rdx
  100202:	84 c9                	test   %cl,%cl
  100204:	75 f1                	jne    1001f7 <strcpy+0x8>
}
  100206:	c3                   	retq   

0000000000100207 <strcmp>:
    while (*a && *b && *a == *b) {
  100207:	0f b6 07             	movzbl (%rdi),%eax
  10020a:	84 c0                	test   %al,%al
  10020c:	74 1a                	je     100228 <strcmp+0x21>
  10020e:	0f b6 16             	movzbl (%rsi),%edx
  100211:	38 c2                	cmp    %al,%dl
  100213:	75 13                	jne    100228 <strcmp+0x21>
  100215:	84 d2                	test   %dl,%dl
  100217:	74 0f                	je     100228 <strcmp+0x21>
        ++a, ++b;
  100219:	48 83 c7 01          	add    $0x1,%rdi
  10021d:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  100221:	0f b6 07             	movzbl (%rdi),%eax
  100224:	84 c0                	test   %al,%al
  100226:	75 e6                	jne    10020e <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  100228:	3a 06                	cmp    (%rsi),%al
  10022a:	0f 97 c0             	seta   %al
  10022d:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  100230:	83 d8 00             	sbb    $0x0,%eax
}
  100233:	c3                   	retq   

0000000000100234 <strchr>:
    while (*s && *s != (char) c) {
  100234:	0f b6 07             	movzbl (%rdi),%eax
  100237:	84 c0                	test   %al,%al
  100239:	74 10                	je     10024b <strchr+0x17>
  10023b:	40 38 f0             	cmp    %sil,%al
  10023e:	74 18                	je     100258 <strchr+0x24>
        ++s;
  100240:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  100244:	0f b6 07             	movzbl (%rdi),%eax
  100247:	84 c0                	test   %al,%al
  100249:	75 f0                	jne    10023b <strchr+0x7>
        return NULL;
  10024b:	40 84 f6             	test   %sil,%sil
  10024e:	b8 00 00 00 00       	mov    $0x0,%eax
  100253:	48 0f 44 c7          	cmove  %rdi,%rax
}
  100257:	c3                   	retq   
  100258:	48 89 f8             	mov    %rdi,%rax
  10025b:	c3                   	retq   

000000000010025c <rand>:
    if (!rand_seed_set) {
  10025c:	83 3d b1 0d 00 00 00 	cmpl   $0x0,0xdb1(%rip)        # 101014 <rand_seed_set>
  100263:	74 1b                	je     100280 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  100265:	69 05 a1 0d 00 00 0d 	imul   $0x19660d,0xda1(%rip),%eax        # 101010 <rand_seed>
  10026c:	66 19 00 
  10026f:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  100274:	89 05 96 0d 00 00    	mov    %eax,0xd96(%rip)        # 101010 <rand_seed>
    return rand_seed & RAND_MAX;
  10027a:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  10027f:	c3                   	retq   
    rand_seed = seed;
  100280:	c7 05 86 0d 00 00 9e 	movl   $0x30d4879e,0xd86(%rip)        # 101010 <rand_seed>
  100287:	87 d4 30 
    rand_seed_set = 1;
  10028a:	c7 05 80 0d 00 00 01 	movl   $0x1,0xd80(%rip)        # 101014 <rand_seed_set>
  100291:	00 00 00 
}
  100294:	eb cf                	jmp    100265 <rand+0x9>

0000000000100296 <srand>:
    rand_seed = seed;
  100296:	89 3d 74 0d 00 00    	mov    %edi,0xd74(%rip)        # 101010 <rand_seed>
    rand_seed_set = 1;
  10029c:	c7 05 6e 0d 00 00 01 	movl   $0x1,0xd6e(%rip)        # 101014 <rand_seed_set>
  1002a3:	00 00 00 
}
  1002a6:	c3                   	retq   

00000000001002a7 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1002a7:	55                   	push   %rbp
  1002a8:	48 89 e5             	mov    %rsp,%rbp
  1002ab:	41 57                	push   %r15
  1002ad:	41 56                	push   %r14
  1002af:	41 55                	push   %r13
  1002b1:	41 54                	push   %r12
  1002b3:	53                   	push   %rbx
  1002b4:	48 83 ec 58          	sub    $0x58,%rsp
  1002b8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1002bc:	0f b6 02             	movzbl (%rdx),%eax
  1002bf:	84 c0                	test   %al,%al
  1002c1:	0f 84 b0 06 00 00    	je     100977 <printer_vprintf+0x6d0>
  1002c7:	49 89 fe             	mov    %rdi,%r14
  1002ca:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1002cd:	41 89 f7             	mov    %esi,%r15d
  1002d0:	e9 a4 04 00 00       	jmpq   100779 <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  1002d5:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1002da:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1002e0:	45 84 e4             	test   %r12b,%r12b
  1002e3:	0f 84 82 06 00 00    	je     10096b <printer_vprintf+0x6c4>
        int flags = 0;
  1002e9:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1002ef:	41 0f be f4          	movsbl %r12b,%esi
  1002f3:	bf b1 0c 10 00       	mov    $0x100cb1,%edi
  1002f8:	e8 37 ff ff ff       	callq  100234 <strchr>
  1002fd:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  100300:	48 85 c0             	test   %rax,%rax
  100303:	74 55                	je     10035a <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  100305:	48 81 e9 b1 0c 10 00 	sub    $0x100cb1,%rcx
  10030c:	b8 01 00 00 00       	mov    $0x1,%eax
  100311:	d3 e0                	shl    %cl,%eax
  100313:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  100316:	48 83 c3 01          	add    $0x1,%rbx
  10031a:	44 0f b6 23          	movzbl (%rbx),%r12d
  10031e:	45 84 e4             	test   %r12b,%r12b
  100321:	75 cc                	jne    1002ef <printer_vprintf+0x48>
  100323:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  100327:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  10032d:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  100334:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  100337:	0f 84 a9 00 00 00    	je     1003e6 <printer_vprintf+0x13f>
        int length = 0;
  10033d:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  100342:	0f b6 13             	movzbl (%rbx),%edx
  100345:	8d 42 bd             	lea    -0x43(%rdx),%eax
  100348:	3c 37                	cmp    $0x37,%al
  10034a:	0f 87 c4 04 00 00    	ja     100814 <printer_vprintf+0x56d>
  100350:	0f b6 c0             	movzbl %al,%eax
  100353:	ff 24 c5 c0 0a 10 00 	jmpq   *0x100ac0(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  10035a:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  10035e:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  100363:	3c 08                	cmp    $0x8,%al
  100365:	77 2f                	ja     100396 <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100367:	0f b6 03             	movzbl (%rbx),%eax
  10036a:	8d 50 d0             	lea    -0x30(%rax),%edx
  10036d:	80 fa 09             	cmp    $0x9,%dl
  100370:	77 5e                	ja     1003d0 <printer_vprintf+0x129>
  100372:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  100378:	48 83 c3 01          	add    $0x1,%rbx
  10037c:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  100381:	0f be c0             	movsbl %al,%eax
  100384:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100389:	0f b6 03             	movzbl (%rbx),%eax
  10038c:	8d 50 d0             	lea    -0x30(%rax),%edx
  10038f:	80 fa 09             	cmp    $0x9,%dl
  100392:	76 e4                	jbe    100378 <printer_vprintf+0xd1>
  100394:	eb 97                	jmp    10032d <printer_vprintf+0x86>
        } else if (*format == '*') {
  100396:	41 80 fc 2a          	cmp    $0x2a,%r12b
  10039a:	75 3f                	jne    1003db <printer_vprintf+0x134>
            width = va_arg(val, int);
  10039c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1003a0:	8b 07                	mov    (%rdi),%eax
  1003a2:	83 f8 2f             	cmp    $0x2f,%eax
  1003a5:	77 17                	ja     1003be <printer_vprintf+0x117>
  1003a7:	89 c2                	mov    %eax,%edx
  1003a9:	48 03 57 10          	add    0x10(%rdi),%rdx
  1003ad:	83 c0 08             	add    $0x8,%eax
  1003b0:	89 07                	mov    %eax,(%rdi)
  1003b2:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1003b5:	48 83 c3 01          	add    $0x1,%rbx
  1003b9:	e9 6f ff ff ff       	jmpq   10032d <printer_vprintf+0x86>
            width = va_arg(val, int);
  1003be:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1003c2:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1003c6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1003ca:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1003ce:	eb e2                	jmp    1003b2 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1003d0:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1003d6:	e9 52 ff ff ff       	jmpq   10032d <printer_vprintf+0x86>
        int width = -1;
  1003db:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1003e1:	e9 47 ff ff ff       	jmpq   10032d <printer_vprintf+0x86>
            ++format;
  1003e6:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1003ea:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1003ee:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1003f1:	80 f9 09             	cmp    $0x9,%cl
  1003f4:	76 13                	jbe    100409 <printer_vprintf+0x162>
            } else if (*format == '*') {
  1003f6:	3c 2a                	cmp    $0x2a,%al
  1003f8:	74 33                	je     10042d <printer_vprintf+0x186>
            ++format;
  1003fa:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  1003fd:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  100404:	e9 34 ff ff ff       	jmpq   10033d <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100409:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  10040e:	48 83 c2 01          	add    $0x1,%rdx
  100412:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  100415:	0f be c0             	movsbl %al,%eax
  100418:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  10041c:	0f b6 02             	movzbl (%rdx),%eax
  10041f:	8d 70 d0             	lea    -0x30(%rax),%esi
  100422:	40 80 fe 09          	cmp    $0x9,%sil
  100426:	76 e6                	jbe    10040e <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  100428:	48 89 d3             	mov    %rdx,%rbx
  10042b:	eb 1c                	jmp    100449 <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  10042d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100431:	8b 07                	mov    (%rdi),%eax
  100433:	83 f8 2f             	cmp    $0x2f,%eax
  100436:	77 23                	ja     10045b <printer_vprintf+0x1b4>
  100438:	89 c2                	mov    %eax,%edx
  10043a:	48 03 57 10          	add    0x10(%rdi),%rdx
  10043e:	83 c0 08             	add    $0x8,%eax
  100441:	89 07                	mov    %eax,(%rdi)
  100443:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  100445:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  100449:	85 c9                	test   %ecx,%ecx
  10044b:	b8 00 00 00 00       	mov    $0x0,%eax
  100450:	0f 49 c1             	cmovns %ecx,%eax
  100453:	89 45 9c             	mov    %eax,-0x64(%rbp)
  100456:	e9 e2 fe ff ff       	jmpq   10033d <printer_vprintf+0x96>
                precision = va_arg(val, int);
  10045b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10045f:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100463:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100467:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10046b:	eb d6                	jmp    100443 <printer_vprintf+0x19c>
        switch (*format) {
  10046d:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  100472:	e9 f3 00 00 00       	jmpq   10056a <printer_vprintf+0x2c3>
            ++format;
  100477:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  10047b:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  100480:	e9 bd fe ff ff       	jmpq   100342 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100485:	85 c9                	test   %ecx,%ecx
  100487:	74 55                	je     1004de <printer_vprintf+0x237>
  100489:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10048d:	8b 07                	mov    (%rdi),%eax
  10048f:	83 f8 2f             	cmp    $0x2f,%eax
  100492:	77 38                	ja     1004cc <printer_vprintf+0x225>
  100494:	89 c2                	mov    %eax,%edx
  100496:	48 03 57 10          	add    0x10(%rdi),%rdx
  10049a:	83 c0 08             	add    $0x8,%eax
  10049d:	89 07                	mov    %eax,(%rdi)
  10049f:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1004a2:	48 89 d0             	mov    %rdx,%rax
  1004a5:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1004a9:	49 89 d0             	mov    %rdx,%r8
  1004ac:	49 f7 d8             	neg    %r8
  1004af:	25 80 00 00 00       	and    $0x80,%eax
  1004b4:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1004b8:	0b 45 a8             	or     -0x58(%rbp),%eax
  1004bb:	83 c8 60             	or     $0x60,%eax
  1004be:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1004c1:	41 bc b8 0a 10 00    	mov    $0x100ab8,%r12d
            break;
  1004c7:	e9 35 01 00 00       	jmpq   100601 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1004cc:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1004d0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1004d4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004d8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1004dc:	eb c1                	jmp    10049f <printer_vprintf+0x1f8>
  1004de:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004e2:	8b 07                	mov    (%rdi),%eax
  1004e4:	83 f8 2f             	cmp    $0x2f,%eax
  1004e7:	77 10                	ja     1004f9 <printer_vprintf+0x252>
  1004e9:	89 c2                	mov    %eax,%edx
  1004eb:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004ef:	83 c0 08             	add    $0x8,%eax
  1004f2:	89 07                	mov    %eax,(%rdi)
  1004f4:	48 63 12             	movslq (%rdx),%rdx
  1004f7:	eb a9                	jmp    1004a2 <printer_vprintf+0x1fb>
  1004f9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004fd:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100501:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100505:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100509:	eb e9                	jmp    1004f4 <printer_vprintf+0x24d>
        int base = 10;
  10050b:	be 0a 00 00 00       	mov    $0xa,%esi
  100510:	eb 58                	jmp    10056a <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100512:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100516:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10051a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10051e:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100522:	eb 60                	jmp    100584 <printer_vprintf+0x2dd>
  100524:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100528:	8b 07                	mov    (%rdi),%eax
  10052a:	83 f8 2f             	cmp    $0x2f,%eax
  10052d:	77 10                	ja     10053f <printer_vprintf+0x298>
  10052f:	89 c2                	mov    %eax,%edx
  100531:	48 03 57 10          	add    0x10(%rdi),%rdx
  100535:	83 c0 08             	add    $0x8,%eax
  100538:	89 07                	mov    %eax,(%rdi)
  10053a:	44 8b 02             	mov    (%rdx),%r8d
  10053d:	eb 48                	jmp    100587 <printer_vprintf+0x2e0>
  10053f:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100543:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100547:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10054b:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10054f:	eb e9                	jmp    10053a <printer_vprintf+0x293>
  100551:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  100554:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  10055b:	bf a0 0c 10 00       	mov    $0x100ca0,%edi
  100560:	e9 e2 02 00 00       	jmpq   100847 <printer_vprintf+0x5a0>
            base = 16;
  100565:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  10056a:	85 c9                	test   %ecx,%ecx
  10056c:	74 b6                	je     100524 <printer_vprintf+0x27d>
  10056e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100572:	8b 01                	mov    (%rcx),%eax
  100574:	83 f8 2f             	cmp    $0x2f,%eax
  100577:	77 99                	ja     100512 <printer_vprintf+0x26b>
  100579:	89 c2                	mov    %eax,%edx
  10057b:	48 03 51 10          	add    0x10(%rcx),%rdx
  10057f:	83 c0 08             	add    $0x8,%eax
  100582:	89 01                	mov    %eax,(%rcx)
  100584:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  100587:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  10058b:	85 f6                	test   %esi,%esi
  10058d:	79 c2                	jns    100551 <printer_vprintf+0x2aa>
        base = -base;
  10058f:	41 89 f1             	mov    %esi,%r9d
  100592:	f7 de                	neg    %esi
  100594:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  10059b:	bf 80 0c 10 00       	mov    $0x100c80,%edi
  1005a0:	e9 a2 02 00 00       	jmpq   100847 <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  1005a5:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1005a9:	8b 07                	mov    (%rdi),%eax
  1005ab:	83 f8 2f             	cmp    $0x2f,%eax
  1005ae:	77 1c                	ja     1005cc <printer_vprintf+0x325>
  1005b0:	89 c2                	mov    %eax,%edx
  1005b2:	48 03 57 10          	add    0x10(%rdi),%rdx
  1005b6:	83 c0 08             	add    $0x8,%eax
  1005b9:	89 07                	mov    %eax,(%rdi)
  1005bb:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1005be:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1005c5:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1005ca:	eb c3                	jmp    10058f <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  1005cc:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005d0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005d4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005d8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005dc:	eb dd                	jmp    1005bb <printer_vprintf+0x314>
            data = va_arg(val, char*);
  1005de:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005e2:	8b 01                	mov    (%rcx),%eax
  1005e4:	83 f8 2f             	cmp    $0x2f,%eax
  1005e7:	0f 87 a5 01 00 00    	ja     100792 <printer_vprintf+0x4eb>
  1005ed:	89 c2                	mov    %eax,%edx
  1005ef:	48 03 51 10          	add    0x10(%rcx),%rdx
  1005f3:	83 c0 08             	add    $0x8,%eax
  1005f6:	89 01                	mov    %eax,(%rcx)
  1005f8:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  1005fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  100601:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100604:	83 e0 20             	and    $0x20,%eax
  100607:	89 45 8c             	mov    %eax,-0x74(%rbp)
  10060a:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  100610:	0f 85 21 02 00 00    	jne    100837 <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  100616:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100619:	89 45 88             	mov    %eax,-0x78(%rbp)
  10061c:	83 e0 60             	and    $0x60,%eax
  10061f:	83 f8 60             	cmp    $0x60,%eax
  100622:	0f 84 54 02 00 00    	je     10087c <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100628:	8b 45 a8             	mov    -0x58(%rbp),%eax
  10062b:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  10062e:	48 c7 45 a0 b8 0a 10 	movq   $0x100ab8,-0x60(%rbp)
  100635:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100636:	83 f8 21             	cmp    $0x21,%eax
  100639:	0f 84 79 02 00 00    	je     1008b8 <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  10063f:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  100642:	89 f8                	mov    %edi,%eax
  100644:	f7 d0                	not    %eax
  100646:	c1 e8 1f             	shr    $0x1f,%eax
  100649:	89 45 84             	mov    %eax,-0x7c(%rbp)
  10064c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  100650:	0f 85 9e 02 00 00    	jne    1008f4 <printer_vprintf+0x64d>
  100656:	84 c0                	test   %al,%al
  100658:	0f 84 96 02 00 00    	je     1008f4 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  10065e:	48 63 f7             	movslq %edi,%rsi
  100661:	4c 89 e7             	mov    %r12,%rdi
  100664:	e8 63 fb ff ff       	callq  1001cc <strnlen>
  100669:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  10066c:	8b 45 88             	mov    -0x78(%rbp),%eax
  10066f:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  100672:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100679:	83 f8 22             	cmp    $0x22,%eax
  10067c:	0f 84 aa 02 00 00    	je     10092c <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  100682:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100686:	e8 26 fb ff ff       	callq  1001b1 <strlen>
  10068b:	8b 55 9c             	mov    -0x64(%rbp),%edx
  10068e:	03 55 98             	add    -0x68(%rbp),%edx
  100691:	44 89 e9             	mov    %r13d,%ecx
  100694:	29 d1                	sub    %edx,%ecx
  100696:	29 c1                	sub    %eax,%ecx
  100698:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  10069b:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  10069e:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1006a2:	75 2d                	jne    1006d1 <printer_vprintf+0x42a>
  1006a4:	85 c9                	test   %ecx,%ecx
  1006a6:	7e 29                	jle    1006d1 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  1006a8:	44 89 fa             	mov    %r15d,%edx
  1006ab:	be 20 00 00 00       	mov    $0x20,%esi
  1006b0:	4c 89 f7             	mov    %r14,%rdi
  1006b3:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1006b6:	41 83 ed 01          	sub    $0x1,%r13d
  1006ba:	45 85 ed             	test   %r13d,%r13d
  1006bd:	7f e9                	jg     1006a8 <printer_vprintf+0x401>
  1006bf:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1006c2:	85 ff                	test   %edi,%edi
  1006c4:	b8 01 00 00 00       	mov    $0x1,%eax
  1006c9:	0f 4f c7             	cmovg  %edi,%eax
  1006cc:	29 c7                	sub    %eax,%edi
  1006ce:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1006d1:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1006d5:	0f b6 07             	movzbl (%rdi),%eax
  1006d8:	84 c0                	test   %al,%al
  1006da:	74 22                	je     1006fe <printer_vprintf+0x457>
  1006dc:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1006e0:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  1006e3:	0f b6 f0             	movzbl %al,%esi
  1006e6:	44 89 fa             	mov    %r15d,%edx
  1006e9:	4c 89 f7             	mov    %r14,%rdi
  1006ec:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1006ef:	48 83 c3 01          	add    $0x1,%rbx
  1006f3:	0f b6 03             	movzbl (%rbx),%eax
  1006f6:	84 c0                	test   %al,%al
  1006f8:	75 e9                	jne    1006e3 <printer_vprintf+0x43c>
  1006fa:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  1006fe:	8b 45 9c             	mov    -0x64(%rbp),%eax
  100701:	85 c0                	test   %eax,%eax
  100703:	7e 1d                	jle    100722 <printer_vprintf+0x47b>
  100705:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100709:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  10070b:	44 89 fa             	mov    %r15d,%edx
  10070e:	be 30 00 00 00       	mov    $0x30,%esi
  100713:	4c 89 f7             	mov    %r14,%rdi
  100716:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  100719:	83 eb 01             	sub    $0x1,%ebx
  10071c:	75 ed                	jne    10070b <printer_vprintf+0x464>
  10071e:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  100722:	8b 45 98             	mov    -0x68(%rbp),%eax
  100725:	85 c0                	test   %eax,%eax
  100727:	7e 27                	jle    100750 <printer_vprintf+0x4a9>
  100729:	89 c0                	mov    %eax,%eax
  10072b:	4c 01 e0             	add    %r12,%rax
  10072e:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100732:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  100735:	41 0f b6 34 24       	movzbl (%r12),%esi
  10073a:	44 89 fa             	mov    %r15d,%edx
  10073d:	4c 89 f7             	mov    %r14,%rdi
  100740:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  100743:	49 83 c4 01          	add    $0x1,%r12
  100747:	49 39 dc             	cmp    %rbx,%r12
  10074a:	75 e9                	jne    100735 <printer_vprintf+0x48e>
  10074c:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  100750:	45 85 ed             	test   %r13d,%r13d
  100753:	7e 14                	jle    100769 <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  100755:	44 89 fa             	mov    %r15d,%edx
  100758:	be 20 00 00 00       	mov    $0x20,%esi
  10075d:	4c 89 f7             	mov    %r14,%rdi
  100760:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  100763:	41 83 ed 01          	sub    $0x1,%r13d
  100767:	75 ec                	jne    100755 <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  100769:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  10076d:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  100771:	84 c0                	test   %al,%al
  100773:	0f 84 fe 01 00 00    	je     100977 <printer_vprintf+0x6d0>
        if (*format != '%') {
  100779:	3c 25                	cmp    $0x25,%al
  10077b:	0f 84 54 fb ff ff    	je     1002d5 <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  100781:	0f b6 f0             	movzbl %al,%esi
  100784:	44 89 fa             	mov    %r15d,%edx
  100787:	4c 89 f7             	mov    %r14,%rdi
  10078a:	41 ff 16             	callq  *(%r14)
            continue;
  10078d:	4c 89 e3             	mov    %r12,%rbx
  100790:	eb d7                	jmp    100769 <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  100792:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100796:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10079a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10079e:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1007a2:	e9 51 fe ff ff       	jmpq   1005f8 <printer_vprintf+0x351>
            color = va_arg(val, int);
  1007a7:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1007ab:	8b 07                	mov    (%rdi),%eax
  1007ad:	83 f8 2f             	cmp    $0x2f,%eax
  1007b0:	77 10                	ja     1007c2 <printer_vprintf+0x51b>
  1007b2:	89 c2                	mov    %eax,%edx
  1007b4:	48 03 57 10          	add    0x10(%rdi),%rdx
  1007b8:	83 c0 08             	add    $0x8,%eax
  1007bb:	89 07                	mov    %eax,(%rdi)
  1007bd:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1007c0:	eb a7                	jmp    100769 <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  1007c2:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1007c6:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1007ca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1007ce:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1007d2:	eb e9                	jmp    1007bd <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  1007d4:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1007d8:	8b 01                	mov    (%rcx),%eax
  1007da:	83 f8 2f             	cmp    $0x2f,%eax
  1007dd:	77 23                	ja     100802 <printer_vprintf+0x55b>
  1007df:	89 c2                	mov    %eax,%edx
  1007e1:	48 03 51 10          	add    0x10(%rcx),%rdx
  1007e5:	83 c0 08             	add    $0x8,%eax
  1007e8:	89 01                	mov    %eax,(%rcx)
  1007ea:	8b 02                	mov    (%rdx),%eax
  1007ec:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1007ef:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1007f3:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1007f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  1007fd:	e9 ff fd ff ff       	jmpq   100601 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  100802:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100806:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10080a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10080e:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100812:	eb d6                	jmp    1007ea <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  100814:	84 d2                	test   %dl,%dl
  100816:	0f 85 39 01 00 00    	jne    100955 <printer_vprintf+0x6ae>
  10081c:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  100820:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  100824:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  100828:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  10082c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100832:	e9 ca fd ff ff       	jmpq   100601 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  100837:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  10083d:	bf a0 0c 10 00       	mov    $0x100ca0,%edi
        if (flags & FLAG_NUMERIC) {
  100842:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  100847:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  10084b:	4c 89 c1             	mov    %r8,%rcx
  10084e:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  100852:	48 63 f6             	movslq %esi,%rsi
  100855:	49 83 ec 01          	sub    $0x1,%r12
  100859:	48 89 c8             	mov    %rcx,%rax
  10085c:	ba 00 00 00 00       	mov    $0x0,%edx
  100861:	48 f7 f6             	div    %rsi
  100864:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  100868:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  10086c:	48 89 ca             	mov    %rcx,%rdx
  10086f:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  100872:	48 39 d6             	cmp    %rdx,%rsi
  100875:	76 de                	jbe    100855 <printer_vprintf+0x5ae>
  100877:	e9 9a fd ff ff       	jmpq   100616 <printer_vprintf+0x36f>
                prefix = "-";
  10087c:	48 c7 45 a0 b5 0a 10 	movq   $0x100ab5,-0x60(%rbp)
  100883:	00 
            if (flags & FLAG_NEGATIVE) {
  100884:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100887:	a8 80                	test   $0x80,%al
  100889:	0f 85 b0 fd ff ff    	jne    10063f <printer_vprintf+0x398>
                prefix = "+";
  10088f:	48 c7 45 a0 b0 0a 10 	movq   $0x100ab0,-0x60(%rbp)
  100896:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100897:	a8 10                	test   $0x10,%al
  100899:	0f 85 a0 fd ff ff    	jne    10063f <printer_vprintf+0x398>
                prefix = " ";
  10089f:	a8 08                	test   $0x8,%al
  1008a1:	ba b8 0a 10 00       	mov    $0x100ab8,%edx
  1008a6:	b8 b7 0a 10 00       	mov    $0x100ab7,%eax
  1008ab:	48 0f 44 c2          	cmove  %rdx,%rax
  1008af:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1008b3:	e9 87 fd ff ff       	jmpq   10063f <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  1008b8:	41 8d 41 10          	lea    0x10(%r9),%eax
  1008bc:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1008c1:	0f 85 78 fd ff ff    	jne    10063f <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  1008c7:	4d 85 c0             	test   %r8,%r8
  1008ca:	75 0d                	jne    1008d9 <printer_vprintf+0x632>
  1008cc:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1008d3:	0f 84 66 fd ff ff    	je     10063f <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  1008d9:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1008dd:	ba b9 0a 10 00       	mov    $0x100ab9,%edx
  1008e2:	b8 b2 0a 10 00       	mov    $0x100ab2,%eax
  1008e7:	48 0f 44 c2          	cmove  %rdx,%rax
  1008eb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1008ef:	e9 4b fd ff ff       	jmpq   10063f <printer_vprintf+0x398>
            len = strlen(data);
  1008f4:	4c 89 e7             	mov    %r12,%rdi
  1008f7:	e8 b5 f8 ff ff       	callq  1001b1 <strlen>
  1008fc:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1008ff:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  100903:	0f 84 63 fd ff ff    	je     10066c <printer_vprintf+0x3c5>
  100909:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  10090d:	0f 84 59 fd ff ff    	je     10066c <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  100913:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  100916:	89 ca                	mov    %ecx,%edx
  100918:	29 c2                	sub    %eax,%edx
  10091a:	39 c1                	cmp    %eax,%ecx
  10091c:	b8 00 00 00 00       	mov    $0x0,%eax
  100921:	0f 4e d0             	cmovle %eax,%edx
  100924:	89 55 9c             	mov    %edx,-0x64(%rbp)
  100927:	e9 56 fd ff ff       	jmpq   100682 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  10092c:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100930:	e8 7c f8 ff ff       	callq  1001b1 <strlen>
  100935:	8b 7d 98             	mov    -0x68(%rbp),%edi
  100938:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  10093b:	44 89 e9             	mov    %r13d,%ecx
  10093e:	29 f9                	sub    %edi,%ecx
  100940:	29 c1                	sub    %eax,%ecx
  100942:	44 39 ea             	cmp    %r13d,%edx
  100945:	b8 00 00 00 00       	mov    $0x0,%eax
  10094a:	0f 4d c8             	cmovge %eax,%ecx
  10094d:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  100950:	e9 2d fd ff ff       	jmpq   100682 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  100955:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  100958:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  10095c:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100960:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100966:	e9 96 fc ff ff       	jmpq   100601 <printer_vprintf+0x35a>
        int flags = 0;
  10096b:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  100972:	e9 b0 f9 ff ff       	jmpq   100327 <printer_vprintf+0x80>
}
  100977:	48 83 c4 58          	add    $0x58,%rsp
  10097b:	5b                   	pop    %rbx
  10097c:	41 5c                	pop    %r12
  10097e:	41 5d                	pop    %r13
  100980:	41 5e                	pop    %r14
  100982:	41 5f                	pop    %r15
  100984:	5d                   	pop    %rbp
  100985:	c3                   	retq   

0000000000100986 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100986:	55                   	push   %rbp
  100987:	48 89 e5             	mov    %rsp,%rbp
  10098a:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  10098e:	48 c7 45 f0 91 00 10 	movq   $0x100091,-0x10(%rbp)
  100995:	00 
        cpos = 0;
  100996:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  10099c:	b8 00 00 00 00       	mov    $0x0,%eax
  1009a1:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1009a4:	48 63 ff             	movslq %edi,%rdi
  1009a7:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  1009ae:	00 
  1009af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1009b3:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  1009b7:	e8 eb f8 ff ff       	callq  1002a7 <printer_vprintf>
    return cp.cursor - console;
  1009bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1009c0:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1009c6:	48 d1 f8             	sar    %rax
}
  1009c9:	c9                   	leaveq 
  1009ca:	c3                   	retq   

00000000001009cb <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1009cb:	55                   	push   %rbp
  1009cc:	48 89 e5             	mov    %rsp,%rbp
  1009cf:	48 83 ec 50          	sub    $0x50,%rsp
  1009d3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1009d7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1009db:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1009df:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1009e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1009ea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1009ee:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1009f2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1009f6:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1009fa:	e8 87 ff ff ff       	callq  100986 <console_vprintf>
}
  1009ff:	c9                   	leaveq 
  100a00:	c3                   	retq   

0000000000100a01 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100a01:	55                   	push   %rbp
  100a02:	48 89 e5             	mov    %rsp,%rbp
  100a05:	53                   	push   %rbx
  100a06:	48 83 ec 28          	sub    $0x28,%rsp
  100a0a:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  100a0d:	48 c7 45 d8 17 01 10 	movq   $0x100117,-0x28(%rbp)
  100a14:	00 
    sp.s = s;
  100a15:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  100a19:	48 85 f6             	test   %rsi,%rsi
  100a1c:	75 0b                	jne    100a29 <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  100a1e:	8b 45 e0             	mov    -0x20(%rbp),%eax
  100a21:	29 d8                	sub    %ebx,%eax
}
  100a23:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100a27:	c9                   	leaveq 
  100a28:	c3                   	retq   
        sp.end = s + size - 1;
  100a29:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100a2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100a32:	be 00 00 00 00       	mov    $0x0,%esi
  100a37:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100a3b:	e8 67 f8 ff ff       	callq  1002a7 <printer_vprintf>
        *sp.s = 0;
  100a40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100a44:	c6 00 00             	movb   $0x0,(%rax)
  100a47:	eb d5                	jmp    100a1e <vsnprintf+0x1d>

0000000000100a49 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100a49:	55                   	push   %rbp
  100a4a:	48 89 e5             	mov    %rsp,%rbp
  100a4d:	48 83 ec 50          	sub    $0x50,%rsp
  100a51:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100a55:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100a59:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100a5d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100a64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100a68:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100a6c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100a70:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100a74:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100a78:	e8 84 ff ff ff       	callq  100a01 <vsnprintf>
    va_end(val);
    return n;
}
  100a7d:	c9                   	leaveq 
  100a7e:	c3                   	retq   

0000000000100a7f <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100a7f:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  100a84:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  100a89:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100a8e:	48 83 c0 02          	add    $0x2,%rax
  100a92:	48 39 d0             	cmp    %rdx,%rax
  100a95:	75 f2                	jne    100a89 <console_clear+0xa>
    }
    cursorpos = 0;
  100a97:	c7 05 5b 85 fb ff 00 	movl   $0x0,-0x47aa5(%rip)        # b8ffc <cursorpos>
  100a9e:	00 00 00 
}
  100aa1:	c3                   	retq   
