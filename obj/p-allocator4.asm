
obj/p-allocator4.full:     file format elf64-x86-64


Disassembly of section .text:

00000000001c0000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  1c0000:	55                   	push   %rbp
  1c0001:	48 89 e5             	mov    %rsp,%rbp
  1c0004:	53                   	push   %rbx
  1c0005:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  1c0009:	cd 31                	int    $0x31
  1c000b:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  1c000d:	89 c7                	mov    %eax,%edi
  1c000f:	e8 82 02 00 00       	callq  1c0296 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  1c0014:	b8 17 20 1c 00       	mov    $0x1c2017,%eax
  1c0019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  1c001f:	48 89 05 e2 0f 00 00 	mov    %rax,0xfe2(%rip)        # 1c1008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  1c0026:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  1c0029:	48 83 e8 01          	sub    $0x1,%rax
  1c002d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  1c0033:	48 89 05 c6 0f 00 00 	mov    %rax,0xfc6(%rip)        # 1c1000 <stack_bottom>
  1c003a:	eb 02                	jmp    1c003e <process_main+0x3e>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  1c003c:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  1c003e:	e8 19 02 00 00       	callq  1c025c <rand>
  1c0043:	48 63 d0             	movslq %eax,%rdx
  1c0046:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  1c004d:	48 c1 fa 25          	sar    $0x25,%rdx
  1c0051:	89 c1                	mov    %eax,%ecx
  1c0053:	c1 f9 1f             	sar    $0x1f,%ecx
  1c0056:	29 ca                	sub    %ecx,%edx
  1c0058:	6b d2 64             	imul   $0x64,%edx,%edx
  1c005b:	29 d0                	sub    %edx,%eax
  1c005d:	39 d8                	cmp    %ebx,%eax
  1c005f:	7d db                	jge    1c003c <process_main+0x3c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  1c0061:	48 8b 3d a0 0f 00 00 	mov    0xfa0(%rip),%rdi        # 1c1008 <heap_top>
  1c0068:	48 3b 3d 91 0f 00 00 	cmp    0xf91(%rip),%rdi        # 1c1000 <stack_bottom>
  1c006f:	74 1c                	je     1c008d <process_main+0x8d>
//    Allocate a page of memory at address `addr` and allow process to
//    write to it. `Addr` must be page-aligned (i.e., a multiple of
//    PAGESIZE == 4096). Returns 0 on success and -1 on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  1c0071:	cd 33                	int    $0x33
  1c0073:	85 c0                	test   %eax,%eax
  1c0075:	78 16                	js     1c008d <process_main+0x8d>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  1c0077:	48 8b 05 8a 0f 00 00 	mov    0xf8a(%rip),%rax        # 1c1008 <heap_top>
  1c007e:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  1c0080:	48 81 05 7d 0f 00 00 	addq   $0x1000,0xf7d(%rip)        # 1c1008 <heap_top>
  1c0087:	00 10 00 00 
  1c008b:	eb af                	jmp    1c003c <process_main+0x3c>
    asm volatile ("int %0" : /* no result */
  1c008d:	cd 32                	int    $0x32
  1c008f:	eb fc                	jmp    1c008d <process_main+0x8d>

00000000001c0091 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  1c0091:	48 89 f9             	mov    %rdi,%rcx
  1c0094:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1c0096:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  1c009d:	00 
  1c009e:	72 08                	jb     1c00a8 <console_putc+0x17>
        cp->cursor = console;
  1c00a0:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  1c00a7:	00 
    }
    if (c == '\n') {
  1c00a8:	40 80 fe 0a          	cmp    $0xa,%sil
  1c00ac:	74 16                	je     1c00c4 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1c00ae:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1c00b2:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1c00b6:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1c00ba:	40 0f b6 f6          	movzbl %sil,%esi
  1c00be:	09 fe                	or     %edi,%esi
  1c00c0:	66 89 30             	mov    %si,(%rax)
    }
}
  1c00c3:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1c00c4:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1c00c8:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  1c00cf:	4c 89 c6             	mov    %r8,%rsi
  1c00d2:	48 d1 fe             	sar    %rsi
  1c00d5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1c00dc:	66 66 66 
  1c00df:	48 89 f0             	mov    %rsi,%rax
  1c00e2:	48 f7 ea             	imul   %rdx
  1c00e5:	48 c1 fa 05          	sar    $0x5,%rdx
  1c00e9:	49 c1 f8 3f          	sar    $0x3f,%r8
  1c00ed:	4c 29 c2             	sub    %r8,%rdx
  1c00f0:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1c00f4:	48 c1 e2 04          	shl    $0x4,%rdx
  1c00f8:	89 f0                	mov    %esi,%eax
  1c00fa:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1c00fc:	83 cf 20             	or     $0x20,%edi
  1c00ff:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c0103:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  1c0107:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  1c010b:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  1c010e:	83 c0 01             	add    $0x1,%eax
  1c0111:	83 f8 50             	cmp    $0x50,%eax
  1c0114:	75 e9                	jne    1c00ff <console_putc+0x6e>
  1c0116:	c3                   	retq   

00000000001c0117 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  1c0117:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1c011b:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1c011f:	73 0b                	jae    1c012c <string_putc+0x15>
        *sp->s++ = c;
  1c0121:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1c0125:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1c0129:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  1c012c:	c3                   	retq   

00000000001c012d <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  1c012d:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1c0130:	48 85 d2             	test   %rdx,%rdx
  1c0133:	74 17                	je     1c014c <memcpy+0x1f>
  1c0135:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  1c013a:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  1c013f:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1c0143:	48 83 c1 01          	add    $0x1,%rcx
  1c0147:	48 39 d1             	cmp    %rdx,%rcx
  1c014a:	75 ee                	jne    1c013a <memcpy+0xd>
}
  1c014c:	c3                   	retq   

00000000001c014d <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  1c014d:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  1c0150:	48 39 fe             	cmp    %rdi,%rsi
  1c0153:	72 1d                	jb     1c0172 <memmove+0x25>
        while (n-- > 0) {
  1c0155:	b9 00 00 00 00       	mov    $0x0,%ecx
  1c015a:	48 85 d2             	test   %rdx,%rdx
  1c015d:	74 12                	je     1c0171 <memmove+0x24>
            *d++ = *s++;
  1c015f:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  1c0163:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  1c0167:	48 83 c1 01          	add    $0x1,%rcx
  1c016b:	48 39 ca             	cmp    %rcx,%rdx
  1c016e:	75 ef                	jne    1c015f <memmove+0x12>
}
  1c0170:	c3                   	retq   
  1c0171:	c3                   	retq   
    if (s < d && s + n > d) {
  1c0172:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  1c0176:	48 39 cf             	cmp    %rcx,%rdi
  1c0179:	73 da                	jae    1c0155 <memmove+0x8>
        while (n-- > 0) {
  1c017b:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  1c017f:	48 85 d2             	test   %rdx,%rdx
  1c0182:	74 ec                	je     1c0170 <memmove+0x23>
            *--d = *--s;
  1c0184:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  1c0188:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  1c018b:	48 83 e9 01          	sub    $0x1,%rcx
  1c018f:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  1c0193:	75 ef                	jne    1c0184 <memmove+0x37>
  1c0195:	c3                   	retq   

00000000001c0196 <memset>:
void* memset(void* v, int c, size_t n) {
  1c0196:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1c0199:	48 85 d2             	test   %rdx,%rdx
  1c019c:	74 12                	je     1c01b0 <memset+0x1a>
  1c019e:	48 01 fa             	add    %rdi,%rdx
  1c01a1:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1c01a4:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1c01a7:	48 83 c1 01          	add    $0x1,%rcx
  1c01ab:	48 39 ca             	cmp    %rcx,%rdx
  1c01ae:	75 f4                	jne    1c01a4 <memset+0xe>
}
  1c01b0:	c3                   	retq   

00000000001c01b1 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1c01b1:	80 3f 00             	cmpb   $0x0,(%rdi)
  1c01b4:	74 10                	je     1c01c6 <strlen+0x15>
  1c01b6:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1c01bb:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1c01bf:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1c01c3:	75 f6                	jne    1c01bb <strlen+0xa>
  1c01c5:	c3                   	retq   
  1c01c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1c01cb:	c3                   	retq   

00000000001c01cc <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1c01cc:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c01cf:	ba 00 00 00 00       	mov    $0x0,%edx
  1c01d4:	48 85 f6             	test   %rsi,%rsi
  1c01d7:	74 11                	je     1c01ea <strnlen+0x1e>
  1c01d9:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  1c01dd:	74 0c                	je     1c01eb <strnlen+0x1f>
        ++n;
  1c01df:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c01e3:	48 39 d0             	cmp    %rdx,%rax
  1c01e6:	75 f1                	jne    1c01d9 <strnlen+0xd>
  1c01e8:	eb 04                	jmp    1c01ee <strnlen+0x22>
  1c01ea:	c3                   	retq   
  1c01eb:	48 89 d0             	mov    %rdx,%rax
}
  1c01ee:	c3                   	retq   

00000000001c01ef <strcpy>:
char* strcpy(char* dst, const char* src) {
  1c01ef:	48 89 f8             	mov    %rdi,%rax
  1c01f2:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1c01f7:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1c01fb:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1c01fe:	48 83 c2 01          	add    $0x1,%rdx
  1c0202:	84 c9                	test   %cl,%cl
  1c0204:	75 f1                	jne    1c01f7 <strcpy+0x8>
}
  1c0206:	c3                   	retq   

00000000001c0207 <strcmp>:
    while (*a && *b && *a == *b) {
  1c0207:	0f b6 07             	movzbl (%rdi),%eax
  1c020a:	84 c0                	test   %al,%al
  1c020c:	74 1a                	je     1c0228 <strcmp+0x21>
  1c020e:	0f b6 16             	movzbl (%rsi),%edx
  1c0211:	38 c2                	cmp    %al,%dl
  1c0213:	75 13                	jne    1c0228 <strcmp+0x21>
  1c0215:	84 d2                	test   %dl,%dl
  1c0217:	74 0f                	je     1c0228 <strcmp+0x21>
        ++a, ++b;
  1c0219:	48 83 c7 01          	add    $0x1,%rdi
  1c021d:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  1c0221:	0f b6 07             	movzbl (%rdi),%eax
  1c0224:	84 c0                	test   %al,%al
  1c0226:	75 e6                	jne    1c020e <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  1c0228:	3a 06                	cmp    (%rsi),%al
  1c022a:	0f 97 c0             	seta   %al
  1c022d:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  1c0230:	83 d8 00             	sbb    $0x0,%eax
}
  1c0233:	c3                   	retq   

00000000001c0234 <strchr>:
    while (*s && *s != (char) c) {
  1c0234:	0f b6 07             	movzbl (%rdi),%eax
  1c0237:	84 c0                	test   %al,%al
  1c0239:	74 10                	je     1c024b <strchr+0x17>
  1c023b:	40 38 f0             	cmp    %sil,%al
  1c023e:	74 18                	je     1c0258 <strchr+0x24>
        ++s;
  1c0240:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  1c0244:	0f b6 07             	movzbl (%rdi),%eax
  1c0247:	84 c0                	test   %al,%al
  1c0249:	75 f0                	jne    1c023b <strchr+0x7>
        return NULL;
  1c024b:	40 84 f6             	test   %sil,%sil
  1c024e:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0253:	48 0f 44 c7          	cmove  %rdi,%rax
}
  1c0257:	c3                   	retq   
  1c0258:	48 89 f8             	mov    %rdi,%rax
  1c025b:	c3                   	retq   

00000000001c025c <rand>:
    if (!rand_seed_set) {
  1c025c:	83 3d b1 0d 00 00 00 	cmpl   $0x0,0xdb1(%rip)        # 1c1014 <rand_seed_set>
  1c0263:	74 1b                	je     1c0280 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1c0265:	69 05 a1 0d 00 00 0d 	imul   $0x19660d,0xda1(%rip),%eax        # 1c1010 <rand_seed>
  1c026c:	66 19 00 
  1c026f:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1c0274:	89 05 96 0d 00 00    	mov    %eax,0xd96(%rip)        # 1c1010 <rand_seed>
    return rand_seed & RAND_MAX;
  1c027a:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  1c027f:	c3                   	retq   
    rand_seed = seed;
  1c0280:	c7 05 86 0d 00 00 9e 	movl   $0x30d4879e,0xd86(%rip)        # 1c1010 <rand_seed>
  1c0287:	87 d4 30 
    rand_seed_set = 1;
  1c028a:	c7 05 80 0d 00 00 01 	movl   $0x1,0xd80(%rip)        # 1c1014 <rand_seed_set>
  1c0291:	00 00 00 
}
  1c0294:	eb cf                	jmp    1c0265 <rand+0x9>

00000000001c0296 <srand>:
    rand_seed = seed;
  1c0296:	89 3d 74 0d 00 00    	mov    %edi,0xd74(%rip)        # 1c1010 <rand_seed>
    rand_seed_set = 1;
  1c029c:	c7 05 6e 0d 00 00 01 	movl   $0x1,0xd6e(%rip)        # 1c1014 <rand_seed_set>
  1c02a3:	00 00 00 
}
  1c02a6:	c3                   	retq   

00000000001c02a7 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1c02a7:	55                   	push   %rbp
  1c02a8:	48 89 e5             	mov    %rsp,%rbp
  1c02ab:	41 57                	push   %r15
  1c02ad:	41 56                	push   %r14
  1c02af:	41 55                	push   %r13
  1c02b1:	41 54                	push   %r12
  1c02b3:	53                   	push   %rbx
  1c02b4:	48 83 ec 58          	sub    $0x58,%rsp
  1c02b8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1c02bc:	0f b6 02             	movzbl (%rdx),%eax
  1c02bf:	84 c0                	test   %al,%al
  1c02c1:	0f 84 b0 06 00 00    	je     1c0977 <printer_vprintf+0x6d0>
  1c02c7:	49 89 fe             	mov    %rdi,%r14
  1c02ca:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1c02cd:	41 89 f7             	mov    %esi,%r15d
  1c02d0:	e9 a4 04 00 00       	jmpq   1c0779 <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  1c02d5:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1c02da:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1c02e0:	45 84 e4             	test   %r12b,%r12b
  1c02e3:	0f 84 82 06 00 00    	je     1c096b <printer_vprintf+0x6c4>
        int flags = 0;
  1c02e9:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1c02ef:	41 0f be f4          	movsbl %r12b,%esi
  1c02f3:	bf b1 0c 1c 00       	mov    $0x1c0cb1,%edi
  1c02f8:	e8 37 ff ff ff       	callq  1c0234 <strchr>
  1c02fd:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  1c0300:	48 85 c0             	test   %rax,%rax
  1c0303:	74 55                	je     1c035a <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  1c0305:	48 81 e9 b1 0c 1c 00 	sub    $0x1c0cb1,%rcx
  1c030c:	b8 01 00 00 00       	mov    $0x1,%eax
  1c0311:	d3 e0                	shl    %cl,%eax
  1c0313:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  1c0316:	48 83 c3 01          	add    $0x1,%rbx
  1c031a:	44 0f b6 23          	movzbl (%rbx),%r12d
  1c031e:	45 84 e4             	test   %r12b,%r12b
  1c0321:	75 cc                	jne    1c02ef <printer_vprintf+0x48>
  1c0323:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  1c0327:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  1c032d:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  1c0334:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  1c0337:	0f 84 a9 00 00 00    	je     1c03e6 <printer_vprintf+0x13f>
        int length = 0;
  1c033d:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  1c0342:	0f b6 13             	movzbl (%rbx),%edx
  1c0345:	8d 42 bd             	lea    -0x43(%rdx),%eax
  1c0348:	3c 37                	cmp    $0x37,%al
  1c034a:	0f 87 c4 04 00 00    	ja     1c0814 <printer_vprintf+0x56d>
  1c0350:	0f b6 c0             	movzbl %al,%eax
  1c0353:	ff 24 c5 c0 0a 1c 00 	jmpq   *0x1c0ac0(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  1c035a:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  1c035e:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  1c0363:	3c 08                	cmp    $0x8,%al
  1c0365:	77 2f                	ja     1c0396 <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c0367:	0f b6 03             	movzbl (%rbx),%eax
  1c036a:	8d 50 d0             	lea    -0x30(%rax),%edx
  1c036d:	80 fa 09             	cmp    $0x9,%dl
  1c0370:	77 5e                	ja     1c03d0 <printer_vprintf+0x129>
  1c0372:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  1c0378:	48 83 c3 01          	add    $0x1,%rbx
  1c037c:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  1c0381:	0f be c0             	movsbl %al,%eax
  1c0384:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c0389:	0f b6 03             	movzbl (%rbx),%eax
  1c038c:	8d 50 d0             	lea    -0x30(%rax),%edx
  1c038f:	80 fa 09             	cmp    $0x9,%dl
  1c0392:	76 e4                	jbe    1c0378 <printer_vprintf+0xd1>
  1c0394:	eb 97                	jmp    1c032d <printer_vprintf+0x86>
        } else if (*format == '*') {
  1c0396:	41 80 fc 2a          	cmp    $0x2a,%r12b
  1c039a:	75 3f                	jne    1c03db <printer_vprintf+0x134>
            width = va_arg(val, int);
  1c039c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c03a0:	8b 07                	mov    (%rdi),%eax
  1c03a2:	83 f8 2f             	cmp    $0x2f,%eax
  1c03a5:	77 17                	ja     1c03be <printer_vprintf+0x117>
  1c03a7:	89 c2                	mov    %eax,%edx
  1c03a9:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c03ad:	83 c0 08             	add    $0x8,%eax
  1c03b0:	89 07                	mov    %eax,(%rdi)
  1c03b2:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1c03b5:	48 83 c3 01          	add    $0x1,%rbx
  1c03b9:	e9 6f ff ff ff       	jmpq   1c032d <printer_vprintf+0x86>
            width = va_arg(val, int);
  1c03be:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c03c2:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c03c6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c03ca:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c03ce:	eb e2                	jmp    1c03b2 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c03d0:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1c03d6:	e9 52 ff ff ff       	jmpq   1c032d <printer_vprintf+0x86>
        int width = -1;
  1c03db:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1c03e1:	e9 47 ff ff ff       	jmpq   1c032d <printer_vprintf+0x86>
            ++format;
  1c03e6:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1c03ea:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1c03ee:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1c03f1:	80 f9 09             	cmp    $0x9,%cl
  1c03f4:	76 13                	jbe    1c0409 <printer_vprintf+0x162>
            } else if (*format == '*') {
  1c03f6:	3c 2a                	cmp    $0x2a,%al
  1c03f8:	74 33                	je     1c042d <printer_vprintf+0x186>
            ++format;
  1c03fa:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  1c03fd:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  1c0404:	e9 34 ff ff ff       	jmpq   1c033d <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1c0409:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  1c040e:	48 83 c2 01          	add    $0x1,%rdx
  1c0412:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  1c0415:	0f be c0             	movsbl %al,%eax
  1c0418:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1c041c:	0f b6 02             	movzbl (%rdx),%eax
  1c041f:	8d 70 d0             	lea    -0x30(%rax),%esi
  1c0422:	40 80 fe 09          	cmp    $0x9,%sil
  1c0426:	76 e6                	jbe    1c040e <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  1c0428:	48 89 d3             	mov    %rdx,%rbx
  1c042b:	eb 1c                	jmp    1c0449 <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  1c042d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c0431:	8b 07                	mov    (%rdi),%eax
  1c0433:	83 f8 2f             	cmp    $0x2f,%eax
  1c0436:	77 23                	ja     1c045b <printer_vprintf+0x1b4>
  1c0438:	89 c2                	mov    %eax,%edx
  1c043a:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c043e:	83 c0 08             	add    $0x8,%eax
  1c0441:	89 07                	mov    %eax,(%rdi)
  1c0443:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  1c0445:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  1c0449:	85 c9                	test   %ecx,%ecx
  1c044b:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0450:	0f 49 c1             	cmovns %ecx,%eax
  1c0453:	89 45 9c             	mov    %eax,-0x64(%rbp)
  1c0456:	e9 e2 fe ff ff       	jmpq   1c033d <printer_vprintf+0x96>
                precision = va_arg(val, int);
  1c045b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c045f:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c0463:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0467:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c046b:	eb d6                	jmp    1c0443 <printer_vprintf+0x19c>
        switch (*format) {
  1c046d:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1c0472:	e9 f3 00 00 00       	jmpq   1c056a <printer_vprintf+0x2c3>
            ++format;
  1c0477:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  1c047b:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  1c0480:	e9 bd fe ff ff       	jmpq   1c0342 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1c0485:	85 c9                	test   %ecx,%ecx
  1c0487:	74 55                	je     1c04de <printer_vprintf+0x237>
  1c0489:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c048d:	8b 07                	mov    (%rdi),%eax
  1c048f:	83 f8 2f             	cmp    $0x2f,%eax
  1c0492:	77 38                	ja     1c04cc <printer_vprintf+0x225>
  1c0494:	89 c2                	mov    %eax,%edx
  1c0496:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c049a:	83 c0 08             	add    $0x8,%eax
  1c049d:	89 07                	mov    %eax,(%rdi)
  1c049f:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1c04a2:	48 89 d0             	mov    %rdx,%rax
  1c04a5:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1c04a9:	49 89 d0             	mov    %rdx,%r8
  1c04ac:	49 f7 d8             	neg    %r8
  1c04af:	25 80 00 00 00       	and    $0x80,%eax
  1c04b4:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1c04b8:	0b 45 a8             	or     -0x58(%rbp),%eax
  1c04bb:	83 c8 60             	or     $0x60,%eax
  1c04be:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1c04c1:	41 bc b8 0a 1c 00    	mov    $0x1c0ab8,%r12d
            break;
  1c04c7:	e9 35 01 00 00       	jmpq   1c0601 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1c04cc:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c04d0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c04d4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c04d8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c04dc:	eb c1                	jmp    1c049f <printer_vprintf+0x1f8>
  1c04de:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c04e2:	8b 07                	mov    (%rdi),%eax
  1c04e4:	83 f8 2f             	cmp    $0x2f,%eax
  1c04e7:	77 10                	ja     1c04f9 <printer_vprintf+0x252>
  1c04e9:	89 c2                	mov    %eax,%edx
  1c04eb:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c04ef:	83 c0 08             	add    $0x8,%eax
  1c04f2:	89 07                	mov    %eax,(%rdi)
  1c04f4:	48 63 12             	movslq (%rdx),%rdx
  1c04f7:	eb a9                	jmp    1c04a2 <printer_vprintf+0x1fb>
  1c04f9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c04fd:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c0501:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0505:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c0509:	eb e9                	jmp    1c04f4 <printer_vprintf+0x24d>
        int base = 10;
  1c050b:	be 0a 00 00 00       	mov    $0xa,%esi
  1c0510:	eb 58                	jmp    1c056a <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1c0512:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0516:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c051a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c051e:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c0522:	eb 60                	jmp    1c0584 <printer_vprintf+0x2dd>
  1c0524:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c0528:	8b 07                	mov    (%rdi),%eax
  1c052a:	83 f8 2f             	cmp    $0x2f,%eax
  1c052d:	77 10                	ja     1c053f <printer_vprintf+0x298>
  1c052f:	89 c2                	mov    %eax,%edx
  1c0531:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c0535:	83 c0 08             	add    $0x8,%eax
  1c0538:	89 07                	mov    %eax,(%rdi)
  1c053a:	44 8b 02             	mov    (%rdx),%r8d
  1c053d:	eb 48                	jmp    1c0587 <printer_vprintf+0x2e0>
  1c053f:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0543:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c0547:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c054b:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c054f:	eb e9                	jmp    1c053a <printer_vprintf+0x293>
  1c0551:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  1c0554:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  1c055b:	bf a0 0c 1c 00       	mov    $0x1c0ca0,%edi
  1c0560:	e9 e2 02 00 00       	jmpq   1c0847 <printer_vprintf+0x5a0>
            base = 16;
  1c0565:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1c056a:	85 c9                	test   %ecx,%ecx
  1c056c:	74 b6                	je     1c0524 <printer_vprintf+0x27d>
  1c056e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0572:	8b 01                	mov    (%rcx),%eax
  1c0574:	83 f8 2f             	cmp    $0x2f,%eax
  1c0577:	77 99                	ja     1c0512 <printer_vprintf+0x26b>
  1c0579:	89 c2                	mov    %eax,%edx
  1c057b:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c057f:	83 c0 08             	add    $0x8,%eax
  1c0582:	89 01                	mov    %eax,(%rcx)
  1c0584:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  1c0587:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  1c058b:	85 f6                	test   %esi,%esi
  1c058d:	79 c2                	jns    1c0551 <printer_vprintf+0x2aa>
        base = -base;
  1c058f:	41 89 f1             	mov    %esi,%r9d
  1c0592:	f7 de                	neg    %esi
  1c0594:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  1c059b:	bf 80 0c 1c 00       	mov    $0x1c0c80,%edi
  1c05a0:	e9 a2 02 00 00       	jmpq   1c0847 <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  1c05a5:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c05a9:	8b 07                	mov    (%rdi),%eax
  1c05ab:	83 f8 2f             	cmp    $0x2f,%eax
  1c05ae:	77 1c                	ja     1c05cc <printer_vprintf+0x325>
  1c05b0:	89 c2                	mov    %eax,%edx
  1c05b2:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c05b6:	83 c0 08             	add    $0x8,%eax
  1c05b9:	89 07                	mov    %eax,(%rdi)
  1c05bb:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1c05be:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1c05c5:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1c05ca:	eb c3                	jmp    1c058f <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  1c05cc:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c05d0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c05d4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c05d8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c05dc:	eb dd                	jmp    1c05bb <printer_vprintf+0x314>
            data = va_arg(val, char*);
  1c05de:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c05e2:	8b 01                	mov    (%rcx),%eax
  1c05e4:	83 f8 2f             	cmp    $0x2f,%eax
  1c05e7:	0f 87 a5 01 00 00    	ja     1c0792 <printer_vprintf+0x4eb>
  1c05ed:	89 c2                	mov    %eax,%edx
  1c05ef:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c05f3:	83 c0 08             	add    $0x8,%eax
  1c05f6:	89 01                	mov    %eax,(%rcx)
  1c05f8:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  1c05fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  1c0601:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1c0604:	83 e0 20             	and    $0x20,%eax
  1c0607:	89 45 8c             	mov    %eax,-0x74(%rbp)
  1c060a:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  1c0610:	0f 85 21 02 00 00    	jne    1c0837 <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  1c0616:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1c0619:	89 45 88             	mov    %eax,-0x78(%rbp)
  1c061c:	83 e0 60             	and    $0x60,%eax
  1c061f:	83 f8 60             	cmp    $0x60,%eax
  1c0622:	0f 84 54 02 00 00    	je     1c087c <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1c0628:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1c062b:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  1c062e:	48 c7 45 a0 b8 0a 1c 	movq   $0x1c0ab8,-0x60(%rbp)
  1c0635:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1c0636:	83 f8 21             	cmp    $0x21,%eax
  1c0639:	0f 84 79 02 00 00    	je     1c08b8 <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  1c063f:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  1c0642:	89 f8                	mov    %edi,%eax
  1c0644:	f7 d0                	not    %eax
  1c0646:	c1 e8 1f             	shr    $0x1f,%eax
  1c0649:	89 45 84             	mov    %eax,-0x7c(%rbp)
  1c064c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  1c0650:	0f 85 9e 02 00 00    	jne    1c08f4 <printer_vprintf+0x64d>
  1c0656:	84 c0                	test   %al,%al
  1c0658:	0f 84 96 02 00 00    	je     1c08f4 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  1c065e:	48 63 f7             	movslq %edi,%rsi
  1c0661:	4c 89 e7             	mov    %r12,%rdi
  1c0664:	e8 63 fb ff ff       	callq  1c01cc <strnlen>
  1c0669:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  1c066c:	8b 45 88             	mov    -0x78(%rbp),%eax
  1c066f:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  1c0672:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  1c0679:	83 f8 22             	cmp    $0x22,%eax
  1c067c:	0f 84 aa 02 00 00    	je     1c092c <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  1c0682:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1c0686:	e8 26 fb ff ff       	callq  1c01b1 <strlen>
  1c068b:	8b 55 9c             	mov    -0x64(%rbp),%edx
  1c068e:	03 55 98             	add    -0x68(%rbp),%edx
  1c0691:	44 89 e9             	mov    %r13d,%ecx
  1c0694:	29 d1                	sub    %edx,%ecx
  1c0696:	29 c1                	sub    %eax,%ecx
  1c0698:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  1c069b:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1c069e:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1c06a2:	75 2d                	jne    1c06d1 <printer_vprintf+0x42a>
  1c06a4:	85 c9                	test   %ecx,%ecx
  1c06a6:	7e 29                	jle    1c06d1 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  1c06a8:	44 89 fa             	mov    %r15d,%edx
  1c06ab:	be 20 00 00 00       	mov    $0x20,%esi
  1c06b0:	4c 89 f7             	mov    %r14,%rdi
  1c06b3:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1c06b6:	41 83 ed 01          	sub    $0x1,%r13d
  1c06ba:	45 85 ed             	test   %r13d,%r13d
  1c06bd:	7f e9                	jg     1c06a8 <printer_vprintf+0x401>
  1c06bf:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1c06c2:	85 ff                	test   %edi,%edi
  1c06c4:	b8 01 00 00 00       	mov    $0x1,%eax
  1c06c9:	0f 4f c7             	cmovg  %edi,%eax
  1c06cc:	29 c7                	sub    %eax,%edi
  1c06ce:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1c06d1:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1c06d5:	0f b6 07             	movzbl (%rdi),%eax
  1c06d8:	84 c0                	test   %al,%al
  1c06da:	74 22                	je     1c06fe <printer_vprintf+0x457>
  1c06dc:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1c06e0:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  1c06e3:	0f b6 f0             	movzbl %al,%esi
  1c06e6:	44 89 fa             	mov    %r15d,%edx
  1c06e9:	4c 89 f7             	mov    %r14,%rdi
  1c06ec:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1c06ef:	48 83 c3 01          	add    $0x1,%rbx
  1c06f3:	0f b6 03             	movzbl (%rbx),%eax
  1c06f6:	84 c0                	test   %al,%al
  1c06f8:	75 e9                	jne    1c06e3 <printer_vprintf+0x43c>
  1c06fa:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  1c06fe:	8b 45 9c             	mov    -0x64(%rbp),%eax
  1c0701:	85 c0                	test   %eax,%eax
  1c0703:	7e 1d                	jle    1c0722 <printer_vprintf+0x47b>
  1c0705:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1c0709:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  1c070b:	44 89 fa             	mov    %r15d,%edx
  1c070e:	be 30 00 00 00       	mov    $0x30,%esi
  1c0713:	4c 89 f7             	mov    %r14,%rdi
  1c0716:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  1c0719:	83 eb 01             	sub    $0x1,%ebx
  1c071c:	75 ed                	jne    1c070b <printer_vprintf+0x464>
  1c071e:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  1c0722:	8b 45 98             	mov    -0x68(%rbp),%eax
  1c0725:	85 c0                	test   %eax,%eax
  1c0727:	7e 27                	jle    1c0750 <printer_vprintf+0x4a9>
  1c0729:	89 c0                	mov    %eax,%eax
  1c072b:	4c 01 e0             	add    %r12,%rax
  1c072e:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1c0732:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  1c0735:	41 0f b6 34 24       	movzbl (%r12),%esi
  1c073a:	44 89 fa             	mov    %r15d,%edx
  1c073d:	4c 89 f7             	mov    %r14,%rdi
  1c0740:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  1c0743:	49 83 c4 01          	add    $0x1,%r12
  1c0747:	49 39 dc             	cmp    %rbx,%r12
  1c074a:	75 e9                	jne    1c0735 <printer_vprintf+0x48e>
  1c074c:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  1c0750:	45 85 ed             	test   %r13d,%r13d
  1c0753:	7e 14                	jle    1c0769 <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  1c0755:	44 89 fa             	mov    %r15d,%edx
  1c0758:	be 20 00 00 00       	mov    $0x20,%esi
  1c075d:	4c 89 f7             	mov    %r14,%rdi
  1c0760:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  1c0763:	41 83 ed 01          	sub    $0x1,%r13d
  1c0767:	75 ec                	jne    1c0755 <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  1c0769:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  1c076d:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1c0771:	84 c0                	test   %al,%al
  1c0773:	0f 84 fe 01 00 00    	je     1c0977 <printer_vprintf+0x6d0>
        if (*format != '%') {
  1c0779:	3c 25                	cmp    $0x25,%al
  1c077b:	0f 84 54 fb ff ff    	je     1c02d5 <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  1c0781:	0f b6 f0             	movzbl %al,%esi
  1c0784:	44 89 fa             	mov    %r15d,%edx
  1c0787:	4c 89 f7             	mov    %r14,%rdi
  1c078a:	41 ff 16             	callq  *(%r14)
            continue;
  1c078d:	4c 89 e3             	mov    %r12,%rbx
  1c0790:	eb d7                	jmp    1c0769 <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  1c0792:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c0796:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c079a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c079e:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c07a2:	e9 51 fe ff ff       	jmpq   1c05f8 <printer_vprintf+0x351>
            color = va_arg(val, int);
  1c07a7:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c07ab:	8b 07                	mov    (%rdi),%eax
  1c07ad:	83 f8 2f             	cmp    $0x2f,%eax
  1c07b0:	77 10                	ja     1c07c2 <printer_vprintf+0x51b>
  1c07b2:	89 c2                	mov    %eax,%edx
  1c07b4:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c07b8:	83 c0 08             	add    $0x8,%eax
  1c07bb:	89 07                	mov    %eax,(%rdi)
  1c07bd:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1c07c0:	eb a7                	jmp    1c0769 <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  1c07c2:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c07c6:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c07ca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c07ce:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c07d2:	eb e9                	jmp    1c07bd <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  1c07d4:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c07d8:	8b 01                	mov    (%rcx),%eax
  1c07da:	83 f8 2f             	cmp    $0x2f,%eax
  1c07dd:	77 23                	ja     1c0802 <printer_vprintf+0x55b>
  1c07df:	89 c2                	mov    %eax,%edx
  1c07e1:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c07e5:	83 c0 08             	add    $0x8,%eax
  1c07e8:	89 01                	mov    %eax,(%rcx)
  1c07ea:	8b 02                	mov    (%rdx),%eax
  1c07ec:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1c07ef:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1c07f3:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1c07f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  1c07fd:	e9 ff fd ff ff       	jmpq   1c0601 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  1c0802:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c0806:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c080a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c080e:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c0812:	eb d6                	jmp    1c07ea <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  1c0814:	84 d2                	test   %dl,%dl
  1c0816:	0f 85 39 01 00 00    	jne    1c0955 <printer_vprintf+0x6ae>
  1c081c:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  1c0820:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  1c0824:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  1c0828:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1c082c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1c0832:	e9 ca fd ff ff       	jmpq   1c0601 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  1c0837:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  1c083d:	bf a0 0c 1c 00       	mov    $0x1c0ca0,%edi
        if (flags & FLAG_NUMERIC) {
  1c0842:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  1c0847:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  1c084b:	4c 89 c1             	mov    %r8,%rcx
  1c084e:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  1c0852:	48 63 f6             	movslq %esi,%rsi
  1c0855:	49 83 ec 01          	sub    $0x1,%r12
  1c0859:	48 89 c8             	mov    %rcx,%rax
  1c085c:	ba 00 00 00 00       	mov    $0x0,%edx
  1c0861:	48 f7 f6             	div    %rsi
  1c0864:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  1c0868:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  1c086c:	48 89 ca             	mov    %rcx,%rdx
  1c086f:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  1c0872:	48 39 d6             	cmp    %rdx,%rsi
  1c0875:	76 de                	jbe    1c0855 <printer_vprintf+0x5ae>
  1c0877:	e9 9a fd ff ff       	jmpq   1c0616 <printer_vprintf+0x36f>
                prefix = "-";
  1c087c:	48 c7 45 a0 b5 0a 1c 	movq   $0x1c0ab5,-0x60(%rbp)
  1c0883:	00 
            if (flags & FLAG_NEGATIVE) {
  1c0884:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1c0887:	a8 80                	test   $0x80,%al
  1c0889:	0f 85 b0 fd ff ff    	jne    1c063f <printer_vprintf+0x398>
                prefix = "+";
  1c088f:	48 c7 45 a0 b0 0a 1c 	movq   $0x1c0ab0,-0x60(%rbp)
  1c0896:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  1c0897:	a8 10                	test   $0x10,%al
  1c0899:	0f 85 a0 fd ff ff    	jne    1c063f <printer_vprintf+0x398>
                prefix = " ";
  1c089f:	a8 08                	test   $0x8,%al
  1c08a1:	ba b8 0a 1c 00       	mov    $0x1c0ab8,%edx
  1c08a6:	b8 b7 0a 1c 00       	mov    $0x1c0ab7,%eax
  1c08ab:	48 0f 44 c2          	cmove  %rdx,%rax
  1c08af:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1c08b3:	e9 87 fd ff ff       	jmpq   1c063f <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  1c08b8:	41 8d 41 10          	lea    0x10(%r9),%eax
  1c08bc:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1c08c1:	0f 85 78 fd ff ff    	jne    1c063f <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  1c08c7:	4d 85 c0             	test   %r8,%r8
  1c08ca:	75 0d                	jne    1c08d9 <printer_vprintf+0x632>
  1c08cc:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1c08d3:	0f 84 66 fd ff ff    	je     1c063f <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  1c08d9:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1c08dd:	ba b9 0a 1c 00       	mov    $0x1c0ab9,%edx
  1c08e2:	b8 b2 0a 1c 00       	mov    $0x1c0ab2,%eax
  1c08e7:	48 0f 44 c2          	cmove  %rdx,%rax
  1c08eb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1c08ef:	e9 4b fd ff ff       	jmpq   1c063f <printer_vprintf+0x398>
            len = strlen(data);
  1c08f4:	4c 89 e7             	mov    %r12,%rdi
  1c08f7:	e8 b5 f8 ff ff       	callq  1c01b1 <strlen>
  1c08fc:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1c08ff:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  1c0903:	0f 84 63 fd ff ff    	je     1c066c <printer_vprintf+0x3c5>
  1c0909:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  1c090d:	0f 84 59 fd ff ff    	je     1c066c <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  1c0913:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  1c0916:	89 ca                	mov    %ecx,%edx
  1c0918:	29 c2                	sub    %eax,%edx
  1c091a:	39 c1                	cmp    %eax,%ecx
  1c091c:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0921:	0f 4e d0             	cmovle %eax,%edx
  1c0924:	89 55 9c             	mov    %edx,-0x64(%rbp)
  1c0927:	e9 56 fd ff ff       	jmpq   1c0682 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  1c092c:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1c0930:	e8 7c f8 ff ff       	callq  1c01b1 <strlen>
  1c0935:	8b 7d 98             	mov    -0x68(%rbp),%edi
  1c0938:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  1c093b:	44 89 e9             	mov    %r13d,%ecx
  1c093e:	29 f9                	sub    %edi,%ecx
  1c0940:	29 c1                	sub    %eax,%ecx
  1c0942:	44 39 ea             	cmp    %r13d,%edx
  1c0945:	b8 00 00 00 00       	mov    $0x0,%eax
  1c094a:	0f 4d c8             	cmovge %eax,%ecx
  1c094d:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  1c0950:	e9 2d fd ff ff       	jmpq   1c0682 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  1c0955:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  1c0958:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1c095c:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1c0960:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1c0966:	e9 96 fc ff ff       	jmpq   1c0601 <printer_vprintf+0x35a>
        int flags = 0;
  1c096b:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  1c0972:	e9 b0 f9 ff ff       	jmpq   1c0327 <printer_vprintf+0x80>
}
  1c0977:	48 83 c4 58          	add    $0x58,%rsp
  1c097b:	5b                   	pop    %rbx
  1c097c:	41 5c                	pop    %r12
  1c097e:	41 5d                	pop    %r13
  1c0980:	41 5e                	pop    %r14
  1c0982:	41 5f                	pop    %r15
  1c0984:	5d                   	pop    %rbp
  1c0985:	c3                   	retq   

00000000001c0986 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  1c0986:	55                   	push   %rbp
  1c0987:	48 89 e5             	mov    %rsp,%rbp
  1c098a:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  1c098e:	48 c7 45 f0 91 00 1c 	movq   $0x1c0091,-0x10(%rbp)
  1c0995:	00 
        cpos = 0;
  1c0996:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  1c099c:	b8 00 00 00 00       	mov    $0x0,%eax
  1c09a1:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1c09a4:	48 63 ff             	movslq %edi,%rdi
  1c09a7:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  1c09ae:	00 
  1c09af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1c09b3:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  1c09b7:	e8 eb f8 ff ff       	callq  1c02a7 <printer_vprintf>
    return cp.cursor - console;
  1c09bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c09c0:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1c09c6:	48 d1 f8             	sar    %rax
}
  1c09c9:	c9                   	leaveq 
  1c09ca:	c3                   	retq   

00000000001c09cb <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1c09cb:	55                   	push   %rbp
  1c09cc:	48 89 e5             	mov    %rsp,%rbp
  1c09cf:	48 83 ec 50          	sub    $0x50,%rsp
  1c09d3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c09d7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c09db:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1c09df:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1c09e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c09ea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c09ee:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c09f2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1c09f6:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1c09fa:	e8 87 ff ff ff       	callq  1c0986 <console_vprintf>
}
  1c09ff:	c9                   	leaveq 
  1c0a00:	c3                   	retq   

00000000001c0a01 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  1c0a01:	55                   	push   %rbp
  1c0a02:	48 89 e5             	mov    %rsp,%rbp
  1c0a05:	53                   	push   %rbx
  1c0a06:	48 83 ec 28          	sub    $0x28,%rsp
  1c0a0a:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  1c0a0d:	48 c7 45 d8 17 01 1c 	movq   $0x1c0117,-0x28(%rbp)
  1c0a14:	00 
    sp.s = s;
  1c0a15:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  1c0a19:	48 85 f6             	test   %rsi,%rsi
  1c0a1c:	75 0b                	jne    1c0a29 <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  1c0a1e:	8b 45 e0             	mov    -0x20(%rbp),%eax
  1c0a21:	29 d8                	sub    %ebx,%eax
}
  1c0a23:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  1c0a27:	c9                   	leaveq 
  1c0a28:	c3                   	retq   
        sp.end = s + size - 1;
  1c0a29:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  1c0a2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  1c0a32:	be 00 00 00 00       	mov    $0x0,%esi
  1c0a37:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  1c0a3b:	e8 67 f8 ff ff       	callq  1c02a7 <printer_vprintf>
        *sp.s = 0;
  1c0a40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c0a44:	c6 00 00             	movb   $0x0,(%rax)
  1c0a47:	eb d5                	jmp    1c0a1e <vsnprintf+0x1d>

00000000001c0a49 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  1c0a49:	55                   	push   %rbp
  1c0a4a:	48 89 e5             	mov    %rsp,%rbp
  1c0a4d:	48 83 ec 50          	sub    $0x50,%rsp
  1c0a51:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c0a55:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c0a59:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  1c0a5d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1c0a64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c0a68:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c0a6c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c0a70:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  1c0a74:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1c0a78:	e8 84 ff ff ff       	callq  1c0a01 <vsnprintf>
    va_end(val);
    return n;
}
  1c0a7d:	c9                   	leaveq 
  1c0a7e:	c3                   	retq   

00000000001c0a7f <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1c0a7f:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  1c0a84:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  1c0a89:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1c0a8e:	48 83 c0 02          	add    $0x2,%rax
  1c0a92:	48 39 d0             	cmp    %rdx,%rax
  1c0a95:	75 f2                	jne    1c0a89 <console_clear+0xa>
    }
    cursorpos = 0;
  1c0a97:	c7 05 5b 85 ef ff 00 	movl   $0x0,-0x107aa5(%rip)        # b8ffc <cursorpos>
  1c0a9e:	00 00 00 
}
  1c0aa1:	c3                   	retq   
