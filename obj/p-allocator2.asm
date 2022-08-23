
obj/p-allocator2.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000140000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  140000:	55                   	push   %rbp
  140001:	48 89 e5             	mov    %rsp,%rbp
  140004:	53                   	push   %rbx
  140005:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  140009:	cd 31                	int    $0x31
  14000b:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  14000d:	89 c7                	mov    %eax,%edi
  14000f:	e8 82 02 00 00       	callq  140296 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  140014:	b8 17 20 14 00       	mov    $0x142017,%eax
  140019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  14001f:	48 89 05 e2 0f 00 00 	mov    %rax,0xfe2(%rip)        # 141008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  140026:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  140029:	48 83 e8 01          	sub    $0x1,%rax
  14002d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  140033:	48 89 05 c6 0f 00 00 	mov    %rax,0xfc6(%rip)        # 141000 <stack_bottom>
  14003a:	eb 02                	jmp    14003e <process_main+0x3e>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  14003c:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  14003e:	e8 19 02 00 00       	callq  14025c <rand>
  140043:	48 63 d0             	movslq %eax,%rdx
  140046:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  14004d:	48 c1 fa 25          	sar    $0x25,%rdx
  140051:	89 c1                	mov    %eax,%ecx
  140053:	c1 f9 1f             	sar    $0x1f,%ecx
  140056:	29 ca                	sub    %ecx,%edx
  140058:	6b d2 64             	imul   $0x64,%edx,%edx
  14005b:	29 d0                	sub    %edx,%eax
  14005d:	39 d8                	cmp    %ebx,%eax
  14005f:	7d db                	jge    14003c <process_main+0x3c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  140061:	48 8b 3d a0 0f 00 00 	mov    0xfa0(%rip),%rdi        # 141008 <heap_top>
  140068:	48 3b 3d 91 0f 00 00 	cmp    0xf91(%rip),%rdi        # 141000 <stack_bottom>
  14006f:	74 1c                	je     14008d <process_main+0x8d>
//    Allocate a page of memory at address `addr` and allow process to
//    write to it. `Addr` must be page-aligned (i.e., a multiple of
//    PAGESIZE == 4096). Returns 0 on success and -1 on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  140071:	cd 33                	int    $0x33
  140073:	85 c0                	test   %eax,%eax
  140075:	78 16                	js     14008d <process_main+0x8d>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  140077:	48 8b 05 8a 0f 00 00 	mov    0xf8a(%rip),%rax        # 141008 <heap_top>
  14007e:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  140080:	48 81 05 7d 0f 00 00 	addq   $0x1000,0xf7d(%rip)        # 141008 <heap_top>
  140087:	00 10 00 00 
  14008b:	eb af                	jmp    14003c <process_main+0x3c>
    asm volatile ("int %0" : /* no result */
  14008d:	cd 32                	int    $0x32
  14008f:	eb fc                	jmp    14008d <process_main+0x8d>

0000000000140091 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  140091:	48 89 f9             	mov    %rdi,%rcx
  140094:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  140096:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  14009d:	00 
  14009e:	72 08                	jb     1400a8 <console_putc+0x17>
        cp->cursor = console;
  1400a0:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  1400a7:	00 
    }
    if (c == '\n') {
  1400a8:	40 80 fe 0a          	cmp    $0xa,%sil
  1400ac:	74 16                	je     1400c4 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1400ae:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1400b2:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1400b6:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1400ba:	40 0f b6 f6          	movzbl %sil,%esi
  1400be:	09 fe                	or     %edi,%esi
  1400c0:	66 89 30             	mov    %si,(%rax)
    }
}
  1400c3:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1400c4:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1400c8:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  1400cf:	4c 89 c6             	mov    %r8,%rsi
  1400d2:	48 d1 fe             	sar    %rsi
  1400d5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1400dc:	66 66 66 
  1400df:	48 89 f0             	mov    %rsi,%rax
  1400e2:	48 f7 ea             	imul   %rdx
  1400e5:	48 c1 fa 05          	sar    $0x5,%rdx
  1400e9:	49 c1 f8 3f          	sar    $0x3f,%r8
  1400ed:	4c 29 c2             	sub    %r8,%rdx
  1400f0:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1400f4:	48 c1 e2 04          	shl    $0x4,%rdx
  1400f8:	89 f0                	mov    %esi,%eax
  1400fa:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1400fc:	83 cf 20             	or     $0x20,%edi
  1400ff:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  140103:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  140107:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  14010b:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  14010e:	83 c0 01             	add    $0x1,%eax
  140111:	83 f8 50             	cmp    $0x50,%eax
  140114:	75 e9                	jne    1400ff <console_putc+0x6e>
  140116:	c3                   	retq   

0000000000140117 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  140117:	48 8b 47 08          	mov    0x8(%rdi),%rax
  14011b:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  14011f:	73 0b                	jae    14012c <string_putc+0x15>
        *sp->s++ = c;
  140121:	48 8d 50 01          	lea    0x1(%rax),%rdx
  140125:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  140129:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  14012c:	c3                   	retq   

000000000014012d <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  14012d:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  140130:	48 85 d2             	test   %rdx,%rdx
  140133:	74 17                	je     14014c <memcpy+0x1f>
  140135:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  14013a:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  14013f:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  140143:	48 83 c1 01          	add    $0x1,%rcx
  140147:	48 39 d1             	cmp    %rdx,%rcx
  14014a:	75 ee                	jne    14013a <memcpy+0xd>
}
  14014c:	c3                   	retq   

000000000014014d <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  14014d:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  140150:	48 39 fe             	cmp    %rdi,%rsi
  140153:	72 1d                	jb     140172 <memmove+0x25>
        while (n-- > 0) {
  140155:	b9 00 00 00 00       	mov    $0x0,%ecx
  14015a:	48 85 d2             	test   %rdx,%rdx
  14015d:	74 12                	je     140171 <memmove+0x24>
            *d++ = *s++;
  14015f:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  140163:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  140167:	48 83 c1 01          	add    $0x1,%rcx
  14016b:	48 39 ca             	cmp    %rcx,%rdx
  14016e:	75 ef                	jne    14015f <memmove+0x12>
}
  140170:	c3                   	retq   
  140171:	c3                   	retq   
    if (s < d && s + n > d) {
  140172:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  140176:	48 39 cf             	cmp    %rcx,%rdi
  140179:	73 da                	jae    140155 <memmove+0x8>
        while (n-- > 0) {
  14017b:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  14017f:	48 85 d2             	test   %rdx,%rdx
  140182:	74 ec                	je     140170 <memmove+0x23>
            *--d = *--s;
  140184:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  140188:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  14018b:	48 83 e9 01          	sub    $0x1,%rcx
  14018f:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  140193:	75 ef                	jne    140184 <memmove+0x37>
  140195:	c3                   	retq   

0000000000140196 <memset>:
void* memset(void* v, int c, size_t n) {
  140196:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  140199:	48 85 d2             	test   %rdx,%rdx
  14019c:	74 12                	je     1401b0 <memset+0x1a>
  14019e:	48 01 fa             	add    %rdi,%rdx
  1401a1:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1401a4:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1401a7:	48 83 c1 01          	add    $0x1,%rcx
  1401ab:	48 39 ca             	cmp    %rcx,%rdx
  1401ae:	75 f4                	jne    1401a4 <memset+0xe>
}
  1401b0:	c3                   	retq   

00000000001401b1 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1401b1:	80 3f 00             	cmpb   $0x0,(%rdi)
  1401b4:	74 10                	je     1401c6 <strlen+0x15>
  1401b6:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1401bb:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1401bf:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1401c3:	75 f6                	jne    1401bb <strlen+0xa>
  1401c5:	c3                   	retq   
  1401c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1401cb:	c3                   	retq   

00000000001401cc <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1401cc:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1401cf:	ba 00 00 00 00       	mov    $0x0,%edx
  1401d4:	48 85 f6             	test   %rsi,%rsi
  1401d7:	74 11                	je     1401ea <strnlen+0x1e>
  1401d9:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  1401dd:	74 0c                	je     1401eb <strnlen+0x1f>
        ++n;
  1401df:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1401e3:	48 39 d0             	cmp    %rdx,%rax
  1401e6:	75 f1                	jne    1401d9 <strnlen+0xd>
  1401e8:	eb 04                	jmp    1401ee <strnlen+0x22>
  1401ea:	c3                   	retq   
  1401eb:	48 89 d0             	mov    %rdx,%rax
}
  1401ee:	c3                   	retq   

00000000001401ef <strcpy>:
char* strcpy(char* dst, const char* src) {
  1401ef:	48 89 f8             	mov    %rdi,%rax
  1401f2:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1401f7:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1401fb:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1401fe:	48 83 c2 01          	add    $0x1,%rdx
  140202:	84 c9                	test   %cl,%cl
  140204:	75 f1                	jne    1401f7 <strcpy+0x8>
}
  140206:	c3                   	retq   

0000000000140207 <strcmp>:
    while (*a && *b && *a == *b) {
  140207:	0f b6 07             	movzbl (%rdi),%eax
  14020a:	84 c0                	test   %al,%al
  14020c:	74 1a                	je     140228 <strcmp+0x21>
  14020e:	0f b6 16             	movzbl (%rsi),%edx
  140211:	38 c2                	cmp    %al,%dl
  140213:	75 13                	jne    140228 <strcmp+0x21>
  140215:	84 d2                	test   %dl,%dl
  140217:	74 0f                	je     140228 <strcmp+0x21>
        ++a, ++b;
  140219:	48 83 c7 01          	add    $0x1,%rdi
  14021d:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  140221:	0f b6 07             	movzbl (%rdi),%eax
  140224:	84 c0                	test   %al,%al
  140226:	75 e6                	jne    14020e <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  140228:	3a 06                	cmp    (%rsi),%al
  14022a:	0f 97 c0             	seta   %al
  14022d:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  140230:	83 d8 00             	sbb    $0x0,%eax
}
  140233:	c3                   	retq   

0000000000140234 <strchr>:
    while (*s && *s != (char) c) {
  140234:	0f b6 07             	movzbl (%rdi),%eax
  140237:	84 c0                	test   %al,%al
  140239:	74 10                	je     14024b <strchr+0x17>
  14023b:	40 38 f0             	cmp    %sil,%al
  14023e:	74 18                	je     140258 <strchr+0x24>
        ++s;
  140240:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  140244:	0f b6 07             	movzbl (%rdi),%eax
  140247:	84 c0                	test   %al,%al
  140249:	75 f0                	jne    14023b <strchr+0x7>
        return NULL;
  14024b:	40 84 f6             	test   %sil,%sil
  14024e:	b8 00 00 00 00       	mov    $0x0,%eax
  140253:	48 0f 44 c7          	cmove  %rdi,%rax
}
  140257:	c3                   	retq   
  140258:	48 89 f8             	mov    %rdi,%rax
  14025b:	c3                   	retq   

000000000014025c <rand>:
    if (!rand_seed_set) {
  14025c:	83 3d b1 0d 00 00 00 	cmpl   $0x0,0xdb1(%rip)        # 141014 <rand_seed_set>
  140263:	74 1b                	je     140280 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  140265:	69 05 a1 0d 00 00 0d 	imul   $0x19660d,0xda1(%rip),%eax        # 141010 <rand_seed>
  14026c:	66 19 00 
  14026f:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  140274:	89 05 96 0d 00 00    	mov    %eax,0xd96(%rip)        # 141010 <rand_seed>
    return rand_seed & RAND_MAX;
  14027a:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  14027f:	c3                   	retq   
    rand_seed = seed;
  140280:	c7 05 86 0d 00 00 9e 	movl   $0x30d4879e,0xd86(%rip)        # 141010 <rand_seed>
  140287:	87 d4 30 
    rand_seed_set = 1;
  14028a:	c7 05 80 0d 00 00 01 	movl   $0x1,0xd80(%rip)        # 141014 <rand_seed_set>
  140291:	00 00 00 
}
  140294:	eb cf                	jmp    140265 <rand+0x9>

0000000000140296 <srand>:
    rand_seed = seed;
  140296:	89 3d 74 0d 00 00    	mov    %edi,0xd74(%rip)        # 141010 <rand_seed>
    rand_seed_set = 1;
  14029c:	c7 05 6e 0d 00 00 01 	movl   $0x1,0xd6e(%rip)        # 141014 <rand_seed_set>
  1402a3:	00 00 00 
}
  1402a6:	c3                   	retq   

00000000001402a7 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1402a7:	55                   	push   %rbp
  1402a8:	48 89 e5             	mov    %rsp,%rbp
  1402ab:	41 57                	push   %r15
  1402ad:	41 56                	push   %r14
  1402af:	41 55                	push   %r13
  1402b1:	41 54                	push   %r12
  1402b3:	53                   	push   %rbx
  1402b4:	48 83 ec 58          	sub    $0x58,%rsp
  1402b8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1402bc:	0f b6 02             	movzbl (%rdx),%eax
  1402bf:	84 c0                	test   %al,%al
  1402c1:	0f 84 b0 06 00 00    	je     140977 <printer_vprintf+0x6d0>
  1402c7:	49 89 fe             	mov    %rdi,%r14
  1402ca:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1402cd:	41 89 f7             	mov    %esi,%r15d
  1402d0:	e9 a4 04 00 00       	jmpq   140779 <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  1402d5:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1402da:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1402e0:	45 84 e4             	test   %r12b,%r12b
  1402e3:	0f 84 82 06 00 00    	je     14096b <printer_vprintf+0x6c4>
        int flags = 0;
  1402e9:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1402ef:	41 0f be f4          	movsbl %r12b,%esi
  1402f3:	bf b1 0c 14 00       	mov    $0x140cb1,%edi
  1402f8:	e8 37 ff ff ff       	callq  140234 <strchr>
  1402fd:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  140300:	48 85 c0             	test   %rax,%rax
  140303:	74 55                	je     14035a <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  140305:	48 81 e9 b1 0c 14 00 	sub    $0x140cb1,%rcx
  14030c:	b8 01 00 00 00       	mov    $0x1,%eax
  140311:	d3 e0                	shl    %cl,%eax
  140313:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  140316:	48 83 c3 01          	add    $0x1,%rbx
  14031a:	44 0f b6 23          	movzbl (%rbx),%r12d
  14031e:	45 84 e4             	test   %r12b,%r12b
  140321:	75 cc                	jne    1402ef <printer_vprintf+0x48>
  140323:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  140327:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  14032d:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  140334:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  140337:	0f 84 a9 00 00 00    	je     1403e6 <printer_vprintf+0x13f>
        int length = 0;
  14033d:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  140342:	0f b6 13             	movzbl (%rbx),%edx
  140345:	8d 42 bd             	lea    -0x43(%rdx),%eax
  140348:	3c 37                	cmp    $0x37,%al
  14034a:	0f 87 c4 04 00 00    	ja     140814 <printer_vprintf+0x56d>
  140350:	0f b6 c0             	movzbl %al,%eax
  140353:	ff 24 c5 c0 0a 14 00 	jmpq   *0x140ac0(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  14035a:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  14035e:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  140363:	3c 08                	cmp    $0x8,%al
  140365:	77 2f                	ja     140396 <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  140367:	0f b6 03             	movzbl (%rbx),%eax
  14036a:	8d 50 d0             	lea    -0x30(%rax),%edx
  14036d:	80 fa 09             	cmp    $0x9,%dl
  140370:	77 5e                	ja     1403d0 <printer_vprintf+0x129>
  140372:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  140378:	48 83 c3 01          	add    $0x1,%rbx
  14037c:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  140381:	0f be c0             	movsbl %al,%eax
  140384:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  140389:	0f b6 03             	movzbl (%rbx),%eax
  14038c:	8d 50 d0             	lea    -0x30(%rax),%edx
  14038f:	80 fa 09             	cmp    $0x9,%dl
  140392:	76 e4                	jbe    140378 <printer_vprintf+0xd1>
  140394:	eb 97                	jmp    14032d <printer_vprintf+0x86>
        } else if (*format == '*') {
  140396:	41 80 fc 2a          	cmp    $0x2a,%r12b
  14039a:	75 3f                	jne    1403db <printer_vprintf+0x134>
            width = va_arg(val, int);
  14039c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1403a0:	8b 07                	mov    (%rdi),%eax
  1403a2:	83 f8 2f             	cmp    $0x2f,%eax
  1403a5:	77 17                	ja     1403be <printer_vprintf+0x117>
  1403a7:	89 c2                	mov    %eax,%edx
  1403a9:	48 03 57 10          	add    0x10(%rdi),%rdx
  1403ad:	83 c0 08             	add    $0x8,%eax
  1403b0:	89 07                	mov    %eax,(%rdi)
  1403b2:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1403b5:	48 83 c3 01          	add    $0x1,%rbx
  1403b9:	e9 6f ff ff ff       	jmpq   14032d <printer_vprintf+0x86>
            width = va_arg(val, int);
  1403be:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1403c2:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1403c6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1403ca:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1403ce:	eb e2                	jmp    1403b2 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1403d0:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1403d6:	e9 52 ff ff ff       	jmpq   14032d <printer_vprintf+0x86>
        int width = -1;
  1403db:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1403e1:	e9 47 ff ff ff       	jmpq   14032d <printer_vprintf+0x86>
            ++format;
  1403e6:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1403ea:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1403ee:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1403f1:	80 f9 09             	cmp    $0x9,%cl
  1403f4:	76 13                	jbe    140409 <printer_vprintf+0x162>
            } else if (*format == '*') {
  1403f6:	3c 2a                	cmp    $0x2a,%al
  1403f8:	74 33                	je     14042d <printer_vprintf+0x186>
            ++format;
  1403fa:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  1403fd:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  140404:	e9 34 ff ff ff       	jmpq   14033d <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  140409:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  14040e:	48 83 c2 01          	add    $0x1,%rdx
  140412:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  140415:	0f be c0             	movsbl %al,%eax
  140418:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  14041c:	0f b6 02             	movzbl (%rdx),%eax
  14041f:	8d 70 d0             	lea    -0x30(%rax),%esi
  140422:	40 80 fe 09          	cmp    $0x9,%sil
  140426:	76 e6                	jbe    14040e <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  140428:	48 89 d3             	mov    %rdx,%rbx
  14042b:	eb 1c                	jmp    140449 <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  14042d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  140431:	8b 07                	mov    (%rdi),%eax
  140433:	83 f8 2f             	cmp    $0x2f,%eax
  140436:	77 23                	ja     14045b <printer_vprintf+0x1b4>
  140438:	89 c2                	mov    %eax,%edx
  14043a:	48 03 57 10          	add    0x10(%rdi),%rdx
  14043e:	83 c0 08             	add    $0x8,%eax
  140441:	89 07                	mov    %eax,(%rdi)
  140443:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  140445:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  140449:	85 c9                	test   %ecx,%ecx
  14044b:	b8 00 00 00 00       	mov    $0x0,%eax
  140450:	0f 49 c1             	cmovns %ecx,%eax
  140453:	89 45 9c             	mov    %eax,-0x64(%rbp)
  140456:	e9 e2 fe ff ff       	jmpq   14033d <printer_vprintf+0x96>
                precision = va_arg(val, int);
  14045b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  14045f:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  140463:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140467:	48 89 41 08          	mov    %rax,0x8(%rcx)
  14046b:	eb d6                	jmp    140443 <printer_vprintf+0x19c>
        switch (*format) {
  14046d:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  140472:	e9 f3 00 00 00       	jmpq   14056a <printer_vprintf+0x2c3>
            ++format;
  140477:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  14047b:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  140480:	e9 bd fe ff ff       	jmpq   140342 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  140485:	85 c9                	test   %ecx,%ecx
  140487:	74 55                	je     1404de <printer_vprintf+0x237>
  140489:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  14048d:	8b 07                	mov    (%rdi),%eax
  14048f:	83 f8 2f             	cmp    $0x2f,%eax
  140492:	77 38                	ja     1404cc <printer_vprintf+0x225>
  140494:	89 c2                	mov    %eax,%edx
  140496:	48 03 57 10          	add    0x10(%rdi),%rdx
  14049a:	83 c0 08             	add    $0x8,%eax
  14049d:	89 07                	mov    %eax,(%rdi)
  14049f:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1404a2:	48 89 d0             	mov    %rdx,%rax
  1404a5:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1404a9:	49 89 d0             	mov    %rdx,%r8
  1404ac:	49 f7 d8             	neg    %r8
  1404af:	25 80 00 00 00       	and    $0x80,%eax
  1404b4:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1404b8:	0b 45 a8             	or     -0x58(%rbp),%eax
  1404bb:	83 c8 60             	or     $0x60,%eax
  1404be:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1404c1:	41 bc b8 0a 14 00    	mov    $0x140ab8,%r12d
            break;
  1404c7:	e9 35 01 00 00       	jmpq   140601 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1404cc:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1404d0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1404d4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1404d8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1404dc:	eb c1                	jmp    14049f <printer_vprintf+0x1f8>
  1404de:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1404e2:	8b 07                	mov    (%rdi),%eax
  1404e4:	83 f8 2f             	cmp    $0x2f,%eax
  1404e7:	77 10                	ja     1404f9 <printer_vprintf+0x252>
  1404e9:	89 c2                	mov    %eax,%edx
  1404eb:	48 03 57 10          	add    0x10(%rdi),%rdx
  1404ef:	83 c0 08             	add    $0x8,%eax
  1404f2:	89 07                	mov    %eax,(%rdi)
  1404f4:	48 63 12             	movslq (%rdx),%rdx
  1404f7:	eb a9                	jmp    1404a2 <printer_vprintf+0x1fb>
  1404f9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1404fd:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  140501:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140505:	48 89 47 08          	mov    %rax,0x8(%rdi)
  140509:	eb e9                	jmp    1404f4 <printer_vprintf+0x24d>
        int base = 10;
  14050b:	be 0a 00 00 00       	mov    $0xa,%esi
  140510:	eb 58                	jmp    14056a <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  140512:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140516:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  14051a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  14051e:	48 89 41 08          	mov    %rax,0x8(%rcx)
  140522:	eb 60                	jmp    140584 <printer_vprintf+0x2dd>
  140524:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  140528:	8b 07                	mov    (%rdi),%eax
  14052a:	83 f8 2f             	cmp    $0x2f,%eax
  14052d:	77 10                	ja     14053f <printer_vprintf+0x298>
  14052f:	89 c2                	mov    %eax,%edx
  140531:	48 03 57 10          	add    0x10(%rdi),%rdx
  140535:	83 c0 08             	add    $0x8,%eax
  140538:	89 07                	mov    %eax,(%rdi)
  14053a:	44 8b 02             	mov    (%rdx),%r8d
  14053d:	eb 48                	jmp    140587 <printer_vprintf+0x2e0>
  14053f:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140543:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  140547:	48 8d 42 08          	lea    0x8(%rdx),%rax
  14054b:	48 89 41 08          	mov    %rax,0x8(%rcx)
  14054f:	eb e9                	jmp    14053a <printer_vprintf+0x293>
  140551:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  140554:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  14055b:	bf a0 0c 14 00       	mov    $0x140ca0,%edi
  140560:	e9 e2 02 00 00       	jmpq   140847 <printer_vprintf+0x5a0>
            base = 16;
  140565:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  14056a:	85 c9                	test   %ecx,%ecx
  14056c:	74 b6                	je     140524 <printer_vprintf+0x27d>
  14056e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140572:	8b 01                	mov    (%rcx),%eax
  140574:	83 f8 2f             	cmp    $0x2f,%eax
  140577:	77 99                	ja     140512 <printer_vprintf+0x26b>
  140579:	89 c2                	mov    %eax,%edx
  14057b:	48 03 51 10          	add    0x10(%rcx),%rdx
  14057f:	83 c0 08             	add    $0x8,%eax
  140582:	89 01                	mov    %eax,(%rcx)
  140584:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  140587:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  14058b:	85 f6                	test   %esi,%esi
  14058d:	79 c2                	jns    140551 <printer_vprintf+0x2aa>
        base = -base;
  14058f:	41 89 f1             	mov    %esi,%r9d
  140592:	f7 de                	neg    %esi
  140594:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  14059b:	bf 80 0c 14 00       	mov    $0x140c80,%edi
  1405a0:	e9 a2 02 00 00       	jmpq   140847 <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  1405a5:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1405a9:	8b 07                	mov    (%rdi),%eax
  1405ab:	83 f8 2f             	cmp    $0x2f,%eax
  1405ae:	77 1c                	ja     1405cc <printer_vprintf+0x325>
  1405b0:	89 c2                	mov    %eax,%edx
  1405b2:	48 03 57 10          	add    0x10(%rdi),%rdx
  1405b6:	83 c0 08             	add    $0x8,%eax
  1405b9:	89 07                	mov    %eax,(%rdi)
  1405bb:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1405be:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1405c5:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1405ca:	eb c3                	jmp    14058f <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  1405cc:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1405d0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1405d4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1405d8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1405dc:	eb dd                	jmp    1405bb <printer_vprintf+0x314>
            data = va_arg(val, char*);
  1405de:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1405e2:	8b 01                	mov    (%rcx),%eax
  1405e4:	83 f8 2f             	cmp    $0x2f,%eax
  1405e7:	0f 87 a5 01 00 00    	ja     140792 <printer_vprintf+0x4eb>
  1405ed:	89 c2                	mov    %eax,%edx
  1405ef:	48 03 51 10          	add    0x10(%rcx),%rdx
  1405f3:	83 c0 08             	add    $0x8,%eax
  1405f6:	89 01                	mov    %eax,(%rcx)
  1405f8:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  1405fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  140601:	8b 45 a8             	mov    -0x58(%rbp),%eax
  140604:	83 e0 20             	and    $0x20,%eax
  140607:	89 45 8c             	mov    %eax,-0x74(%rbp)
  14060a:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  140610:	0f 85 21 02 00 00    	jne    140837 <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  140616:	8b 45 a8             	mov    -0x58(%rbp),%eax
  140619:	89 45 88             	mov    %eax,-0x78(%rbp)
  14061c:	83 e0 60             	and    $0x60,%eax
  14061f:	83 f8 60             	cmp    $0x60,%eax
  140622:	0f 84 54 02 00 00    	je     14087c <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  140628:	8b 45 a8             	mov    -0x58(%rbp),%eax
  14062b:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  14062e:	48 c7 45 a0 b8 0a 14 	movq   $0x140ab8,-0x60(%rbp)
  140635:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  140636:	83 f8 21             	cmp    $0x21,%eax
  140639:	0f 84 79 02 00 00    	je     1408b8 <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  14063f:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  140642:	89 f8                	mov    %edi,%eax
  140644:	f7 d0                	not    %eax
  140646:	c1 e8 1f             	shr    $0x1f,%eax
  140649:	89 45 84             	mov    %eax,-0x7c(%rbp)
  14064c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  140650:	0f 85 9e 02 00 00    	jne    1408f4 <printer_vprintf+0x64d>
  140656:	84 c0                	test   %al,%al
  140658:	0f 84 96 02 00 00    	je     1408f4 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  14065e:	48 63 f7             	movslq %edi,%rsi
  140661:	4c 89 e7             	mov    %r12,%rdi
  140664:	e8 63 fb ff ff       	callq  1401cc <strnlen>
  140669:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  14066c:	8b 45 88             	mov    -0x78(%rbp),%eax
  14066f:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  140672:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  140679:	83 f8 22             	cmp    $0x22,%eax
  14067c:	0f 84 aa 02 00 00    	je     14092c <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  140682:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  140686:	e8 26 fb ff ff       	callq  1401b1 <strlen>
  14068b:	8b 55 9c             	mov    -0x64(%rbp),%edx
  14068e:	03 55 98             	add    -0x68(%rbp),%edx
  140691:	44 89 e9             	mov    %r13d,%ecx
  140694:	29 d1                	sub    %edx,%ecx
  140696:	29 c1                	sub    %eax,%ecx
  140698:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  14069b:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  14069e:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1406a2:	75 2d                	jne    1406d1 <printer_vprintf+0x42a>
  1406a4:	85 c9                	test   %ecx,%ecx
  1406a6:	7e 29                	jle    1406d1 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  1406a8:	44 89 fa             	mov    %r15d,%edx
  1406ab:	be 20 00 00 00       	mov    $0x20,%esi
  1406b0:	4c 89 f7             	mov    %r14,%rdi
  1406b3:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1406b6:	41 83 ed 01          	sub    $0x1,%r13d
  1406ba:	45 85 ed             	test   %r13d,%r13d
  1406bd:	7f e9                	jg     1406a8 <printer_vprintf+0x401>
  1406bf:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1406c2:	85 ff                	test   %edi,%edi
  1406c4:	b8 01 00 00 00       	mov    $0x1,%eax
  1406c9:	0f 4f c7             	cmovg  %edi,%eax
  1406cc:	29 c7                	sub    %eax,%edi
  1406ce:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1406d1:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1406d5:	0f b6 07             	movzbl (%rdi),%eax
  1406d8:	84 c0                	test   %al,%al
  1406da:	74 22                	je     1406fe <printer_vprintf+0x457>
  1406dc:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1406e0:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  1406e3:	0f b6 f0             	movzbl %al,%esi
  1406e6:	44 89 fa             	mov    %r15d,%edx
  1406e9:	4c 89 f7             	mov    %r14,%rdi
  1406ec:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1406ef:	48 83 c3 01          	add    $0x1,%rbx
  1406f3:	0f b6 03             	movzbl (%rbx),%eax
  1406f6:	84 c0                	test   %al,%al
  1406f8:	75 e9                	jne    1406e3 <printer_vprintf+0x43c>
  1406fa:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  1406fe:	8b 45 9c             	mov    -0x64(%rbp),%eax
  140701:	85 c0                	test   %eax,%eax
  140703:	7e 1d                	jle    140722 <printer_vprintf+0x47b>
  140705:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  140709:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  14070b:	44 89 fa             	mov    %r15d,%edx
  14070e:	be 30 00 00 00       	mov    $0x30,%esi
  140713:	4c 89 f7             	mov    %r14,%rdi
  140716:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  140719:	83 eb 01             	sub    $0x1,%ebx
  14071c:	75 ed                	jne    14070b <printer_vprintf+0x464>
  14071e:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  140722:	8b 45 98             	mov    -0x68(%rbp),%eax
  140725:	85 c0                	test   %eax,%eax
  140727:	7e 27                	jle    140750 <printer_vprintf+0x4a9>
  140729:	89 c0                	mov    %eax,%eax
  14072b:	4c 01 e0             	add    %r12,%rax
  14072e:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  140732:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  140735:	41 0f b6 34 24       	movzbl (%r12),%esi
  14073a:	44 89 fa             	mov    %r15d,%edx
  14073d:	4c 89 f7             	mov    %r14,%rdi
  140740:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  140743:	49 83 c4 01          	add    $0x1,%r12
  140747:	49 39 dc             	cmp    %rbx,%r12
  14074a:	75 e9                	jne    140735 <printer_vprintf+0x48e>
  14074c:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  140750:	45 85 ed             	test   %r13d,%r13d
  140753:	7e 14                	jle    140769 <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  140755:	44 89 fa             	mov    %r15d,%edx
  140758:	be 20 00 00 00       	mov    $0x20,%esi
  14075d:	4c 89 f7             	mov    %r14,%rdi
  140760:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  140763:	41 83 ed 01          	sub    $0x1,%r13d
  140767:	75 ec                	jne    140755 <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  140769:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  14076d:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  140771:	84 c0                	test   %al,%al
  140773:	0f 84 fe 01 00 00    	je     140977 <printer_vprintf+0x6d0>
        if (*format != '%') {
  140779:	3c 25                	cmp    $0x25,%al
  14077b:	0f 84 54 fb ff ff    	je     1402d5 <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  140781:	0f b6 f0             	movzbl %al,%esi
  140784:	44 89 fa             	mov    %r15d,%edx
  140787:	4c 89 f7             	mov    %r14,%rdi
  14078a:	41 ff 16             	callq  *(%r14)
            continue;
  14078d:	4c 89 e3             	mov    %r12,%rbx
  140790:	eb d7                	jmp    140769 <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  140792:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  140796:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  14079a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  14079e:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1407a2:	e9 51 fe ff ff       	jmpq   1405f8 <printer_vprintf+0x351>
            color = va_arg(val, int);
  1407a7:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1407ab:	8b 07                	mov    (%rdi),%eax
  1407ad:	83 f8 2f             	cmp    $0x2f,%eax
  1407b0:	77 10                	ja     1407c2 <printer_vprintf+0x51b>
  1407b2:	89 c2                	mov    %eax,%edx
  1407b4:	48 03 57 10          	add    0x10(%rdi),%rdx
  1407b8:	83 c0 08             	add    $0x8,%eax
  1407bb:	89 07                	mov    %eax,(%rdi)
  1407bd:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1407c0:	eb a7                	jmp    140769 <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  1407c2:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1407c6:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1407ca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1407ce:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1407d2:	eb e9                	jmp    1407bd <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  1407d4:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1407d8:	8b 01                	mov    (%rcx),%eax
  1407da:	83 f8 2f             	cmp    $0x2f,%eax
  1407dd:	77 23                	ja     140802 <printer_vprintf+0x55b>
  1407df:	89 c2                	mov    %eax,%edx
  1407e1:	48 03 51 10          	add    0x10(%rcx),%rdx
  1407e5:	83 c0 08             	add    $0x8,%eax
  1407e8:	89 01                	mov    %eax,(%rcx)
  1407ea:	8b 02                	mov    (%rdx),%eax
  1407ec:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1407ef:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1407f3:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1407f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  1407fd:	e9 ff fd ff ff       	jmpq   140601 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  140802:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  140806:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  14080a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  14080e:	48 89 47 08          	mov    %rax,0x8(%rdi)
  140812:	eb d6                	jmp    1407ea <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  140814:	84 d2                	test   %dl,%dl
  140816:	0f 85 39 01 00 00    	jne    140955 <printer_vprintf+0x6ae>
  14081c:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  140820:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  140824:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  140828:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  14082c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  140832:	e9 ca fd ff ff       	jmpq   140601 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  140837:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  14083d:	bf a0 0c 14 00       	mov    $0x140ca0,%edi
        if (flags & FLAG_NUMERIC) {
  140842:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  140847:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  14084b:	4c 89 c1             	mov    %r8,%rcx
  14084e:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  140852:	48 63 f6             	movslq %esi,%rsi
  140855:	49 83 ec 01          	sub    $0x1,%r12
  140859:	48 89 c8             	mov    %rcx,%rax
  14085c:	ba 00 00 00 00       	mov    $0x0,%edx
  140861:	48 f7 f6             	div    %rsi
  140864:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  140868:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  14086c:	48 89 ca             	mov    %rcx,%rdx
  14086f:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  140872:	48 39 d6             	cmp    %rdx,%rsi
  140875:	76 de                	jbe    140855 <printer_vprintf+0x5ae>
  140877:	e9 9a fd ff ff       	jmpq   140616 <printer_vprintf+0x36f>
                prefix = "-";
  14087c:	48 c7 45 a0 b5 0a 14 	movq   $0x140ab5,-0x60(%rbp)
  140883:	00 
            if (flags & FLAG_NEGATIVE) {
  140884:	8b 45 a8             	mov    -0x58(%rbp),%eax
  140887:	a8 80                	test   $0x80,%al
  140889:	0f 85 b0 fd ff ff    	jne    14063f <printer_vprintf+0x398>
                prefix = "+";
  14088f:	48 c7 45 a0 b0 0a 14 	movq   $0x140ab0,-0x60(%rbp)
  140896:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  140897:	a8 10                	test   $0x10,%al
  140899:	0f 85 a0 fd ff ff    	jne    14063f <printer_vprintf+0x398>
                prefix = " ";
  14089f:	a8 08                	test   $0x8,%al
  1408a1:	ba b8 0a 14 00       	mov    $0x140ab8,%edx
  1408a6:	b8 b7 0a 14 00       	mov    $0x140ab7,%eax
  1408ab:	48 0f 44 c2          	cmove  %rdx,%rax
  1408af:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1408b3:	e9 87 fd ff ff       	jmpq   14063f <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  1408b8:	41 8d 41 10          	lea    0x10(%r9),%eax
  1408bc:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1408c1:	0f 85 78 fd ff ff    	jne    14063f <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  1408c7:	4d 85 c0             	test   %r8,%r8
  1408ca:	75 0d                	jne    1408d9 <printer_vprintf+0x632>
  1408cc:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1408d3:	0f 84 66 fd ff ff    	je     14063f <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  1408d9:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1408dd:	ba b9 0a 14 00       	mov    $0x140ab9,%edx
  1408e2:	b8 b2 0a 14 00       	mov    $0x140ab2,%eax
  1408e7:	48 0f 44 c2          	cmove  %rdx,%rax
  1408eb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1408ef:	e9 4b fd ff ff       	jmpq   14063f <printer_vprintf+0x398>
            len = strlen(data);
  1408f4:	4c 89 e7             	mov    %r12,%rdi
  1408f7:	e8 b5 f8 ff ff       	callq  1401b1 <strlen>
  1408fc:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1408ff:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  140903:	0f 84 63 fd ff ff    	je     14066c <printer_vprintf+0x3c5>
  140909:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  14090d:	0f 84 59 fd ff ff    	je     14066c <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  140913:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  140916:	89 ca                	mov    %ecx,%edx
  140918:	29 c2                	sub    %eax,%edx
  14091a:	39 c1                	cmp    %eax,%ecx
  14091c:	b8 00 00 00 00       	mov    $0x0,%eax
  140921:	0f 4e d0             	cmovle %eax,%edx
  140924:	89 55 9c             	mov    %edx,-0x64(%rbp)
  140927:	e9 56 fd ff ff       	jmpq   140682 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  14092c:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  140930:	e8 7c f8 ff ff       	callq  1401b1 <strlen>
  140935:	8b 7d 98             	mov    -0x68(%rbp),%edi
  140938:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  14093b:	44 89 e9             	mov    %r13d,%ecx
  14093e:	29 f9                	sub    %edi,%ecx
  140940:	29 c1                	sub    %eax,%ecx
  140942:	44 39 ea             	cmp    %r13d,%edx
  140945:	b8 00 00 00 00       	mov    $0x0,%eax
  14094a:	0f 4d c8             	cmovge %eax,%ecx
  14094d:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  140950:	e9 2d fd ff ff       	jmpq   140682 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  140955:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  140958:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  14095c:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  140960:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  140966:	e9 96 fc ff ff       	jmpq   140601 <printer_vprintf+0x35a>
        int flags = 0;
  14096b:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  140972:	e9 b0 f9 ff ff       	jmpq   140327 <printer_vprintf+0x80>
}
  140977:	48 83 c4 58          	add    $0x58,%rsp
  14097b:	5b                   	pop    %rbx
  14097c:	41 5c                	pop    %r12
  14097e:	41 5d                	pop    %r13
  140980:	41 5e                	pop    %r14
  140982:	41 5f                	pop    %r15
  140984:	5d                   	pop    %rbp
  140985:	c3                   	retq   

0000000000140986 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  140986:	55                   	push   %rbp
  140987:	48 89 e5             	mov    %rsp,%rbp
  14098a:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  14098e:	48 c7 45 f0 91 00 14 	movq   $0x140091,-0x10(%rbp)
  140995:	00 
        cpos = 0;
  140996:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  14099c:	b8 00 00 00 00       	mov    $0x0,%eax
  1409a1:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1409a4:	48 63 ff             	movslq %edi,%rdi
  1409a7:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  1409ae:	00 
  1409af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1409b3:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  1409b7:	e8 eb f8 ff ff       	callq  1402a7 <printer_vprintf>
    return cp.cursor - console;
  1409bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1409c0:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1409c6:	48 d1 f8             	sar    %rax
}
  1409c9:	c9                   	leaveq 
  1409ca:	c3                   	retq   

00000000001409cb <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1409cb:	55                   	push   %rbp
  1409cc:	48 89 e5             	mov    %rsp,%rbp
  1409cf:	48 83 ec 50          	sub    $0x50,%rsp
  1409d3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1409d7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1409db:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1409df:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1409e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1409ea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1409ee:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1409f2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1409f6:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1409fa:	e8 87 ff ff ff       	callq  140986 <console_vprintf>
}
  1409ff:	c9                   	leaveq 
  140a00:	c3                   	retq   

0000000000140a01 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  140a01:	55                   	push   %rbp
  140a02:	48 89 e5             	mov    %rsp,%rbp
  140a05:	53                   	push   %rbx
  140a06:	48 83 ec 28          	sub    $0x28,%rsp
  140a0a:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  140a0d:	48 c7 45 d8 17 01 14 	movq   $0x140117,-0x28(%rbp)
  140a14:	00 
    sp.s = s;
  140a15:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  140a19:	48 85 f6             	test   %rsi,%rsi
  140a1c:	75 0b                	jne    140a29 <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  140a1e:	8b 45 e0             	mov    -0x20(%rbp),%eax
  140a21:	29 d8                	sub    %ebx,%eax
}
  140a23:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  140a27:	c9                   	leaveq 
  140a28:	c3                   	retq   
        sp.end = s + size - 1;
  140a29:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  140a2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  140a32:	be 00 00 00 00       	mov    $0x0,%esi
  140a37:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  140a3b:	e8 67 f8 ff ff       	callq  1402a7 <printer_vprintf>
        *sp.s = 0;
  140a40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  140a44:	c6 00 00             	movb   $0x0,(%rax)
  140a47:	eb d5                	jmp    140a1e <vsnprintf+0x1d>

0000000000140a49 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  140a49:	55                   	push   %rbp
  140a4a:	48 89 e5             	mov    %rsp,%rbp
  140a4d:	48 83 ec 50          	sub    $0x50,%rsp
  140a51:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  140a55:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  140a59:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  140a5d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  140a64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  140a68:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  140a6c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  140a70:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  140a74:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  140a78:	e8 84 ff ff ff       	callq  140a01 <vsnprintf>
    va_end(val);
    return n;
}
  140a7d:	c9                   	leaveq 
  140a7e:	c3                   	retq   

0000000000140a7f <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  140a7f:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  140a84:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  140a89:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  140a8e:	48 83 c0 02          	add    $0x2,%rax
  140a92:	48 39 d0             	cmp    %rdx,%rax
  140a95:	75 f2                	jne    140a89 <console_clear+0xa>
    }
    cursorpos = 0;
  140a97:	c7 05 5b 85 f7 ff 00 	movl   $0x0,-0x87aa5(%rip)        # b8ffc <cursorpos>
  140a9e:	00 00 00 
}
  140aa1:	c3                   	retq   
