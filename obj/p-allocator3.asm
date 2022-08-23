
obj/p-allocator3.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000180000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  180000:	55                   	push   %rbp
  180001:	48 89 e5             	mov    %rsp,%rbp
  180004:	53                   	push   %rbx
  180005:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  180009:	cd 31                	int    $0x31
  18000b:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  18000d:	89 c7                	mov    %eax,%edi
  18000f:	e8 82 02 00 00       	callq  180296 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  180014:	b8 17 20 18 00       	mov    $0x182017,%eax
  180019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  18001f:	48 89 05 e2 0f 00 00 	mov    %rax,0xfe2(%rip)        # 181008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  180026:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  180029:	48 83 e8 01          	sub    $0x1,%rax
  18002d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  180033:	48 89 05 c6 0f 00 00 	mov    %rax,0xfc6(%rip)        # 181000 <stack_bottom>
  18003a:	eb 02                	jmp    18003e <process_main+0x3e>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  18003c:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  18003e:	e8 19 02 00 00       	callq  18025c <rand>
  180043:	48 63 d0             	movslq %eax,%rdx
  180046:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  18004d:	48 c1 fa 25          	sar    $0x25,%rdx
  180051:	89 c1                	mov    %eax,%ecx
  180053:	c1 f9 1f             	sar    $0x1f,%ecx
  180056:	29 ca                	sub    %ecx,%edx
  180058:	6b d2 64             	imul   $0x64,%edx,%edx
  18005b:	29 d0                	sub    %edx,%eax
  18005d:	39 d8                	cmp    %ebx,%eax
  18005f:	7d db                	jge    18003c <process_main+0x3c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  180061:	48 8b 3d a0 0f 00 00 	mov    0xfa0(%rip),%rdi        # 181008 <heap_top>
  180068:	48 3b 3d 91 0f 00 00 	cmp    0xf91(%rip),%rdi        # 181000 <stack_bottom>
  18006f:	74 1c                	je     18008d <process_main+0x8d>
//    Allocate a page of memory at address `addr` and allow process to
//    write to it. `Addr` must be page-aligned (i.e., a multiple of
//    PAGESIZE == 4096). Returns 0 on success and -1 on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  180071:	cd 33                	int    $0x33
  180073:	85 c0                	test   %eax,%eax
  180075:	78 16                	js     18008d <process_main+0x8d>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  180077:	48 8b 05 8a 0f 00 00 	mov    0xf8a(%rip),%rax        # 181008 <heap_top>
  18007e:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  180080:	48 81 05 7d 0f 00 00 	addq   $0x1000,0xf7d(%rip)        # 181008 <heap_top>
  180087:	00 10 00 00 
  18008b:	eb af                	jmp    18003c <process_main+0x3c>
    asm volatile ("int %0" : /* no result */
  18008d:	cd 32                	int    $0x32
  18008f:	eb fc                	jmp    18008d <process_main+0x8d>

0000000000180091 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  180091:	48 89 f9             	mov    %rdi,%rcx
  180094:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  180096:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  18009d:	00 
  18009e:	72 08                	jb     1800a8 <console_putc+0x17>
        cp->cursor = console;
  1800a0:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  1800a7:	00 
    }
    if (c == '\n') {
  1800a8:	40 80 fe 0a          	cmp    $0xa,%sil
  1800ac:	74 16                	je     1800c4 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1800ae:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1800b2:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1800b6:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1800ba:	40 0f b6 f6          	movzbl %sil,%esi
  1800be:	09 fe                	or     %edi,%esi
  1800c0:	66 89 30             	mov    %si,(%rax)
    }
}
  1800c3:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1800c4:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1800c8:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  1800cf:	4c 89 c6             	mov    %r8,%rsi
  1800d2:	48 d1 fe             	sar    %rsi
  1800d5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1800dc:	66 66 66 
  1800df:	48 89 f0             	mov    %rsi,%rax
  1800e2:	48 f7 ea             	imul   %rdx
  1800e5:	48 c1 fa 05          	sar    $0x5,%rdx
  1800e9:	49 c1 f8 3f          	sar    $0x3f,%r8
  1800ed:	4c 29 c2             	sub    %r8,%rdx
  1800f0:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1800f4:	48 c1 e2 04          	shl    $0x4,%rdx
  1800f8:	89 f0                	mov    %esi,%eax
  1800fa:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1800fc:	83 cf 20             	or     $0x20,%edi
  1800ff:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  180103:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  180107:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  18010b:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  18010e:	83 c0 01             	add    $0x1,%eax
  180111:	83 f8 50             	cmp    $0x50,%eax
  180114:	75 e9                	jne    1800ff <console_putc+0x6e>
  180116:	c3                   	retq   

0000000000180117 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  180117:	48 8b 47 08          	mov    0x8(%rdi),%rax
  18011b:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  18011f:	73 0b                	jae    18012c <string_putc+0x15>
        *sp->s++ = c;
  180121:	48 8d 50 01          	lea    0x1(%rax),%rdx
  180125:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  180129:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  18012c:	c3                   	retq   

000000000018012d <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  18012d:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  180130:	48 85 d2             	test   %rdx,%rdx
  180133:	74 17                	je     18014c <memcpy+0x1f>
  180135:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  18013a:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  18013f:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  180143:	48 83 c1 01          	add    $0x1,%rcx
  180147:	48 39 d1             	cmp    %rdx,%rcx
  18014a:	75 ee                	jne    18013a <memcpy+0xd>
}
  18014c:	c3                   	retq   

000000000018014d <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  18014d:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  180150:	48 39 fe             	cmp    %rdi,%rsi
  180153:	72 1d                	jb     180172 <memmove+0x25>
        while (n-- > 0) {
  180155:	b9 00 00 00 00       	mov    $0x0,%ecx
  18015a:	48 85 d2             	test   %rdx,%rdx
  18015d:	74 12                	je     180171 <memmove+0x24>
            *d++ = *s++;
  18015f:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  180163:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  180167:	48 83 c1 01          	add    $0x1,%rcx
  18016b:	48 39 ca             	cmp    %rcx,%rdx
  18016e:	75 ef                	jne    18015f <memmove+0x12>
}
  180170:	c3                   	retq   
  180171:	c3                   	retq   
    if (s < d && s + n > d) {
  180172:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  180176:	48 39 cf             	cmp    %rcx,%rdi
  180179:	73 da                	jae    180155 <memmove+0x8>
        while (n-- > 0) {
  18017b:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  18017f:	48 85 d2             	test   %rdx,%rdx
  180182:	74 ec                	je     180170 <memmove+0x23>
            *--d = *--s;
  180184:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  180188:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  18018b:	48 83 e9 01          	sub    $0x1,%rcx
  18018f:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  180193:	75 ef                	jne    180184 <memmove+0x37>
  180195:	c3                   	retq   

0000000000180196 <memset>:
void* memset(void* v, int c, size_t n) {
  180196:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  180199:	48 85 d2             	test   %rdx,%rdx
  18019c:	74 12                	je     1801b0 <memset+0x1a>
  18019e:	48 01 fa             	add    %rdi,%rdx
  1801a1:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1801a4:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1801a7:	48 83 c1 01          	add    $0x1,%rcx
  1801ab:	48 39 ca             	cmp    %rcx,%rdx
  1801ae:	75 f4                	jne    1801a4 <memset+0xe>
}
  1801b0:	c3                   	retq   

00000000001801b1 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1801b1:	80 3f 00             	cmpb   $0x0,(%rdi)
  1801b4:	74 10                	je     1801c6 <strlen+0x15>
  1801b6:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1801bb:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1801bf:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1801c3:	75 f6                	jne    1801bb <strlen+0xa>
  1801c5:	c3                   	retq   
  1801c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1801cb:	c3                   	retq   

00000000001801cc <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1801cc:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1801cf:	ba 00 00 00 00       	mov    $0x0,%edx
  1801d4:	48 85 f6             	test   %rsi,%rsi
  1801d7:	74 11                	je     1801ea <strnlen+0x1e>
  1801d9:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  1801dd:	74 0c                	je     1801eb <strnlen+0x1f>
        ++n;
  1801df:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1801e3:	48 39 d0             	cmp    %rdx,%rax
  1801e6:	75 f1                	jne    1801d9 <strnlen+0xd>
  1801e8:	eb 04                	jmp    1801ee <strnlen+0x22>
  1801ea:	c3                   	retq   
  1801eb:	48 89 d0             	mov    %rdx,%rax
}
  1801ee:	c3                   	retq   

00000000001801ef <strcpy>:
char* strcpy(char* dst, const char* src) {
  1801ef:	48 89 f8             	mov    %rdi,%rax
  1801f2:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1801f7:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1801fb:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1801fe:	48 83 c2 01          	add    $0x1,%rdx
  180202:	84 c9                	test   %cl,%cl
  180204:	75 f1                	jne    1801f7 <strcpy+0x8>
}
  180206:	c3                   	retq   

0000000000180207 <strcmp>:
    while (*a && *b && *a == *b) {
  180207:	0f b6 07             	movzbl (%rdi),%eax
  18020a:	84 c0                	test   %al,%al
  18020c:	74 1a                	je     180228 <strcmp+0x21>
  18020e:	0f b6 16             	movzbl (%rsi),%edx
  180211:	38 c2                	cmp    %al,%dl
  180213:	75 13                	jne    180228 <strcmp+0x21>
  180215:	84 d2                	test   %dl,%dl
  180217:	74 0f                	je     180228 <strcmp+0x21>
        ++a, ++b;
  180219:	48 83 c7 01          	add    $0x1,%rdi
  18021d:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  180221:	0f b6 07             	movzbl (%rdi),%eax
  180224:	84 c0                	test   %al,%al
  180226:	75 e6                	jne    18020e <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  180228:	3a 06                	cmp    (%rsi),%al
  18022a:	0f 97 c0             	seta   %al
  18022d:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  180230:	83 d8 00             	sbb    $0x0,%eax
}
  180233:	c3                   	retq   

0000000000180234 <strchr>:
    while (*s && *s != (char) c) {
  180234:	0f b6 07             	movzbl (%rdi),%eax
  180237:	84 c0                	test   %al,%al
  180239:	74 10                	je     18024b <strchr+0x17>
  18023b:	40 38 f0             	cmp    %sil,%al
  18023e:	74 18                	je     180258 <strchr+0x24>
        ++s;
  180240:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  180244:	0f b6 07             	movzbl (%rdi),%eax
  180247:	84 c0                	test   %al,%al
  180249:	75 f0                	jne    18023b <strchr+0x7>
        return NULL;
  18024b:	40 84 f6             	test   %sil,%sil
  18024e:	b8 00 00 00 00       	mov    $0x0,%eax
  180253:	48 0f 44 c7          	cmove  %rdi,%rax
}
  180257:	c3                   	retq   
  180258:	48 89 f8             	mov    %rdi,%rax
  18025b:	c3                   	retq   

000000000018025c <rand>:
    if (!rand_seed_set) {
  18025c:	83 3d b1 0d 00 00 00 	cmpl   $0x0,0xdb1(%rip)        # 181014 <rand_seed_set>
  180263:	74 1b                	je     180280 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  180265:	69 05 a1 0d 00 00 0d 	imul   $0x19660d,0xda1(%rip),%eax        # 181010 <rand_seed>
  18026c:	66 19 00 
  18026f:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  180274:	89 05 96 0d 00 00    	mov    %eax,0xd96(%rip)        # 181010 <rand_seed>
    return rand_seed & RAND_MAX;
  18027a:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  18027f:	c3                   	retq   
    rand_seed = seed;
  180280:	c7 05 86 0d 00 00 9e 	movl   $0x30d4879e,0xd86(%rip)        # 181010 <rand_seed>
  180287:	87 d4 30 
    rand_seed_set = 1;
  18028a:	c7 05 80 0d 00 00 01 	movl   $0x1,0xd80(%rip)        # 181014 <rand_seed_set>
  180291:	00 00 00 
}
  180294:	eb cf                	jmp    180265 <rand+0x9>

0000000000180296 <srand>:
    rand_seed = seed;
  180296:	89 3d 74 0d 00 00    	mov    %edi,0xd74(%rip)        # 181010 <rand_seed>
    rand_seed_set = 1;
  18029c:	c7 05 6e 0d 00 00 01 	movl   $0x1,0xd6e(%rip)        # 181014 <rand_seed_set>
  1802a3:	00 00 00 
}
  1802a6:	c3                   	retq   

00000000001802a7 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1802a7:	55                   	push   %rbp
  1802a8:	48 89 e5             	mov    %rsp,%rbp
  1802ab:	41 57                	push   %r15
  1802ad:	41 56                	push   %r14
  1802af:	41 55                	push   %r13
  1802b1:	41 54                	push   %r12
  1802b3:	53                   	push   %rbx
  1802b4:	48 83 ec 58          	sub    $0x58,%rsp
  1802b8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1802bc:	0f b6 02             	movzbl (%rdx),%eax
  1802bf:	84 c0                	test   %al,%al
  1802c1:	0f 84 b0 06 00 00    	je     180977 <printer_vprintf+0x6d0>
  1802c7:	49 89 fe             	mov    %rdi,%r14
  1802ca:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1802cd:	41 89 f7             	mov    %esi,%r15d
  1802d0:	e9 a4 04 00 00       	jmpq   180779 <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  1802d5:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1802da:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1802e0:	45 84 e4             	test   %r12b,%r12b
  1802e3:	0f 84 82 06 00 00    	je     18096b <printer_vprintf+0x6c4>
        int flags = 0;
  1802e9:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1802ef:	41 0f be f4          	movsbl %r12b,%esi
  1802f3:	bf b1 0c 18 00       	mov    $0x180cb1,%edi
  1802f8:	e8 37 ff ff ff       	callq  180234 <strchr>
  1802fd:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  180300:	48 85 c0             	test   %rax,%rax
  180303:	74 55                	je     18035a <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  180305:	48 81 e9 b1 0c 18 00 	sub    $0x180cb1,%rcx
  18030c:	b8 01 00 00 00       	mov    $0x1,%eax
  180311:	d3 e0                	shl    %cl,%eax
  180313:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  180316:	48 83 c3 01          	add    $0x1,%rbx
  18031a:	44 0f b6 23          	movzbl (%rbx),%r12d
  18031e:	45 84 e4             	test   %r12b,%r12b
  180321:	75 cc                	jne    1802ef <printer_vprintf+0x48>
  180323:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  180327:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  18032d:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  180334:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  180337:	0f 84 a9 00 00 00    	je     1803e6 <printer_vprintf+0x13f>
        int length = 0;
  18033d:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  180342:	0f b6 13             	movzbl (%rbx),%edx
  180345:	8d 42 bd             	lea    -0x43(%rdx),%eax
  180348:	3c 37                	cmp    $0x37,%al
  18034a:	0f 87 c4 04 00 00    	ja     180814 <printer_vprintf+0x56d>
  180350:	0f b6 c0             	movzbl %al,%eax
  180353:	ff 24 c5 c0 0a 18 00 	jmpq   *0x180ac0(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  18035a:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  18035e:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  180363:	3c 08                	cmp    $0x8,%al
  180365:	77 2f                	ja     180396 <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  180367:	0f b6 03             	movzbl (%rbx),%eax
  18036a:	8d 50 d0             	lea    -0x30(%rax),%edx
  18036d:	80 fa 09             	cmp    $0x9,%dl
  180370:	77 5e                	ja     1803d0 <printer_vprintf+0x129>
  180372:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  180378:	48 83 c3 01          	add    $0x1,%rbx
  18037c:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  180381:	0f be c0             	movsbl %al,%eax
  180384:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  180389:	0f b6 03             	movzbl (%rbx),%eax
  18038c:	8d 50 d0             	lea    -0x30(%rax),%edx
  18038f:	80 fa 09             	cmp    $0x9,%dl
  180392:	76 e4                	jbe    180378 <printer_vprintf+0xd1>
  180394:	eb 97                	jmp    18032d <printer_vprintf+0x86>
        } else if (*format == '*') {
  180396:	41 80 fc 2a          	cmp    $0x2a,%r12b
  18039a:	75 3f                	jne    1803db <printer_vprintf+0x134>
            width = va_arg(val, int);
  18039c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1803a0:	8b 07                	mov    (%rdi),%eax
  1803a2:	83 f8 2f             	cmp    $0x2f,%eax
  1803a5:	77 17                	ja     1803be <printer_vprintf+0x117>
  1803a7:	89 c2                	mov    %eax,%edx
  1803a9:	48 03 57 10          	add    0x10(%rdi),%rdx
  1803ad:	83 c0 08             	add    $0x8,%eax
  1803b0:	89 07                	mov    %eax,(%rdi)
  1803b2:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1803b5:	48 83 c3 01          	add    $0x1,%rbx
  1803b9:	e9 6f ff ff ff       	jmpq   18032d <printer_vprintf+0x86>
            width = va_arg(val, int);
  1803be:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1803c2:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1803c6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1803ca:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1803ce:	eb e2                	jmp    1803b2 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1803d0:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1803d6:	e9 52 ff ff ff       	jmpq   18032d <printer_vprintf+0x86>
        int width = -1;
  1803db:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1803e1:	e9 47 ff ff ff       	jmpq   18032d <printer_vprintf+0x86>
            ++format;
  1803e6:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1803ea:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1803ee:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1803f1:	80 f9 09             	cmp    $0x9,%cl
  1803f4:	76 13                	jbe    180409 <printer_vprintf+0x162>
            } else if (*format == '*') {
  1803f6:	3c 2a                	cmp    $0x2a,%al
  1803f8:	74 33                	je     18042d <printer_vprintf+0x186>
            ++format;
  1803fa:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  1803fd:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  180404:	e9 34 ff ff ff       	jmpq   18033d <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  180409:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  18040e:	48 83 c2 01          	add    $0x1,%rdx
  180412:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  180415:	0f be c0             	movsbl %al,%eax
  180418:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  18041c:	0f b6 02             	movzbl (%rdx),%eax
  18041f:	8d 70 d0             	lea    -0x30(%rax),%esi
  180422:	40 80 fe 09          	cmp    $0x9,%sil
  180426:	76 e6                	jbe    18040e <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  180428:	48 89 d3             	mov    %rdx,%rbx
  18042b:	eb 1c                	jmp    180449 <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  18042d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  180431:	8b 07                	mov    (%rdi),%eax
  180433:	83 f8 2f             	cmp    $0x2f,%eax
  180436:	77 23                	ja     18045b <printer_vprintf+0x1b4>
  180438:	89 c2                	mov    %eax,%edx
  18043a:	48 03 57 10          	add    0x10(%rdi),%rdx
  18043e:	83 c0 08             	add    $0x8,%eax
  180441:	89 07                	mov    %eax,(%rdi)
  180443:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  180445:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  180449:	85 c9                	test   %ecx,%ecx
  18044b:	b8 00 00 00 00       	mov    $0x0,%eax
  180450:	0f 49 c1             	cmovns %ecx,%eax
  180453:	89 45 9c             	mov    %eax,-0x64(%rbp)
  180456:	e9 e2 fe ff ff       	jmpq   18033d <printer_vprintf+0x96>
                precision = va_arg(val, int);
  18045b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  18045f:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  180463:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180467:	48 89 41 08          	mov    %rax,0x8(%rcx)
  18046b:	eb d6                	jmp    180443 <printer_vprintf+0x19c>
        switch (*format) {
  18046d:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  180472:	e9 f3 00 00 00       	jmpq   18056a <printer_vprintf+0x2c3>
            ++format;
  180477:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  18047b:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  180480:	e9 bd fe ff ff       	jmpq   180342 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  180485:	85 c9                	test   %ecx,%ecx
  180487:	74 55                	je     1804de <printer_vprintf+0x237>
  180489:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  18048d:	8b 07                	mov    (%rdi),%eax
  18048f:	83 f8 2f             	cmp    $0x2f,%eax
  180492:	77 38                	ja     1804cc <printer_vprintf+0x225>
  180494:	89 c2                	mov    %eax,%edx
  180496:	48 03 57 10          	add    0x10(%rdi),%rdx
  18049a:	83 c0 08             	add    $0x8,%eax
  18049d:	89 07                	mov    %eax,(%rdi)
  18049f:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1804a2:	48 89 d0             	mov    %rdx,%rax
  1804a5:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1804a9:	49 89 d0             	mov    %rdx,%r8
  1804ac:	49 f7 d8             	neg    %r8
  1804af:	25 80 00 00 00       	and    $0x80,%eax
  1804b4:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1804b8:	0b 45 a8             	or     -0x58(%rbp),%eax
  1804bb:	83 c8 60             	or     $0x60,%eax
  1804be:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1804c1:	41 bc b8 0a 18 00    	mov    $0x180ab8,%r12d
            break;
  1804c7:	e9 35 01 00 00       	jmpq   180601 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1804cc:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1804d0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1804d4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1804d8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1804dc:	eb c1                	jmp    18049f <printer_vprintf+0x1f8>
  1804de:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1804e2:	8b 07                	mov    (%rdi),%eax
  1804e4:	83 f8 2f             	cmp    $0x2f,%eax
  1804e7:	77 10                	ja     1804f9 <printer_vprintf+0x252>
  1804e9:	89 c2                	mov    %eax,%edx
  1804eb:	48 03 57 10          	add    0x10(%rdi),%rdx
  1804ef:	83 c0 08             	add    $0x8,%eax
  1804f2:	89 07                	mov    %eax,(%rdi)
  1804f4:	48 63 12             	movslq (%rdx),%rdx
  1804f7:	eb a9                	jmp    1804a2 <printer_vprintf+0x1fb>
  1804f9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1804fd:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  180501:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180505:	48 89 47 08          	mov    %rax,0x8(%rdi)
  180509:	eb e9                	jmp    1804f4 <printer_vprintf+0x24d>
        int base = 10;
  18050b:	be 0a 00 00 00       	mov    $0xa,%esi
  180510:	eb 58                	jmp    18056a <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  180512:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180516:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  18051a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  18051e:	48 89 41 08          	mov    %rax,0x8(%rcx)
  180522:	eb 60                	jmp    180584 <printer_vprintf+0x2dd>
  180524:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  180528:	8b 07                	mov    (%rdi),%eax
  18052a:	83 f8 2f             	cmp    $0x2f,%eax
  18052d:	77 10                	ja     18053f <printer_vprintf+0x298>
  18052f:	89 c2                	mov    %eax,%edx
  180531:	48 03 57 10          	add    0x10(%rdi),%rdx
  180535:	83 c0 08             	add    $0x8,%eax
  180538:	89 07                	mov    %eax,(%rdi)
  18053a:	44 8b 02             	mov    (%rdx),%r8d
  18053d:	eb 48                	jmp    180587 <printer_vprintf+0x2e0>
  18053f:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180543:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  180547:	48 8d 42 08          	lea    0x8(%rdx),%rax
  18054b:	48 89 41 08          	mov    %rax,0x8(%rcx)
  18054f:	eb e9                	jmp    18053a <printer_vprintf+0x293>
  180551:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  180554:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  18055b:	bf a0 0c 18 00       	mov    $0x180ca0,%edi
  180560:	e9 e2 02 00 00       	jmpq   180847 <printer_vprintf+0x5a0>
            base = 16;
  180565:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  18056a:	85 c9                	test   %ecx,%ecx
  18056c:	74 b6                	je     180524 <printer_vprintf+0x27d>
  18056e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180572:	8b 01                	mov    (%rcx),%eax
  180574:	83 f8 2f             	cmp    $0x2f,%eax
  180577:	77 99                	ja     180512 <printer_vprintf+0x26b>
  180579:	89 c2                	mov    %eax,%edx
  18057b:	48 03 51 10          	add    0x10(%rcx),%rdx
  18057f:	83 c0 08             	add    $0x8,%eax
  180582:	89 01                	mov    %eax,(%rcx)
  180584:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  180587:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  18058b:	85 f6                	test   %esi,%esi
  18058d:	79 c2                	jns    180551 <printer_vprintf+0x2aa>
        base = -base;
  18058f:	41 89 f1             	mov    %esi,%r9d
  180592:	f7 de                	neg    %esi
  180594:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  18059b:	bf 80 0c 18 00       	mov    $0x180c80,%edi
  1805a0:	e9 a2 02 00 00       	jmpq   180847 <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  1805a5:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1805a9:	8b 07                	mov    (%rdi),%eax
  1805ab:	83 f8 2f             	cmp    $0x2f,%eax
  1805ae:	77 1c                	ja     1805cc <printer_vprintf+0x325>
  1805b0:	89 c2                	mov    %eax,%edx
  1805b2:	48 03 57 10          	add    0x10(%rdi),%rdx
  1805b6:	83 c0 08             	add    $0x8,%eax
  1805b9:	89 07                	mov    %eax,(%rdi)
  1805bb:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1805be:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1805c5:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1805ca:	eb c3                	jmp    18058f <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  1805cc:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1805d0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1805d4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1805d8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1805dc:	eb dd                	jmp    1805bb <printer_vprintf+0x314>
            data = va_arg(val, char*);
  1805de:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1805e2:	8b 01                	mov    (%rcx),%eax
  1805e4:	83 f8 2f             	cmp    $0x2f,%eax
  1805e7:	0f 87 a5 01 00 00    	ja     180792 <printer_vprintf+0x4eb>
  1805ed:	89 c2                	mov    %eax,%edx
  1805ef:	48 03 51 10          	add    0x10(%rcx),%rdx
  1805f3:	83 c0 08             	add    $0x8,%eax
  1805f6:	89 01                	mov    %eax,(%rcx)
  1805f8:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  1805fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  180601:	8b 45 a8             	mov    -0x58(%rbp),%eax
  180604:	83 e0 20             	and    $0x20,%eax
  180607:	89 45 8c             	mov    %eax,-0x74(%rbp)
  18060a:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  180610:	0f 85 21 02 00 00    	jne    180837 <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  180616:	8b 45 a8             	mov    -0x58(%rbp),%eax
  180619:	89 45 88             	mov    %eax,-0x78(%rbp)
  18061c:	83 e0 60             	and    $0x60,%eax
  18061f:	83 f8 60             	cmp    $0x60,%eax
  180622:	0f 84 54 02 00 00    	je     18087c <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  180628:	8b 45 a8             	mov    -0x58(%rbp),%eax
  18062b:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  18062e:	48 c7 45 a0 b8 0a 18 	movq   $0x180ab8,-0x60(%rbp)
  180635:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  180636:	83 f8 21             	cmp    $0x21,%eax
  180639:	0f 84 79 02 00 00    	je     1808b8 <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  18063f:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  180642:	89 f8                	mov    %edi,%eax
  180644:	f7 d0                	not    %eax
  180646:	c1 e8 1f             	shr    $0x1f,%eax
  180649:	89 45 84             	mov    %eax,-0x7c(%rbp)
  18064c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  180650:	0f 85 9e 02 00 00    	jne    1808f4 <printer_vprintf+0x64d>
  180656:	84 c0                	test   %al,%al
  180658:	0f 84 96 02 00 00    	je     1808f4 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  18065e:	48 63 f7             	movslq %edi,%rsi
  180661:	4c 89 e7             	mov    %r12,%rdi
  180664:	e8 63 fb ff ff       	callq  1801cc <strnlen>
  180669:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  18066c:	8b 45 88             	mov    -0x78(%rbp),%eax
  18066f:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  180672:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  180679:	83 f8 22             	cmp    $0x22,%eax
  18067c:	0f 84 aa 02 00 00    	je     18092c <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  180682:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  180686:	e8 26 fb ff ff       	callq  1801b1 <strlen>
  18068b:	8b 55 9c             	mov    -0x64(%rbp),%edx
  18068e:	03 55 98             	add    -0x68(%rbp),%edx
  180691:	44 89 e9             	mov    %r13d,%ecx
  180694:	29 d1                	sub    %edx,%ecx
  180696:	29 c1                	sub    %eax,%ecx
  180698:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  18069b:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  18069e:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1806a2:	75 2d                	jne    1806d1 <printer_vprintf+0x42a>
  1806a4:	85 c9                	test   %ecx,%ecx
  1806a6:	7e 29                	jle    1806d1 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  1806a8:	44 89 fa             	mov    %r15d,%edx
  1806ab:	be 20 00 00 00       	mov    $0x20,%esi
  1806b0:	4c 89 f7             	mov    %r14,%rdi
  1806b3:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1806b6:	41 83 ed 01          	sub    $0x1,%r13d
  1806ba:	45 85 ed             	test   %r13d,%r13d
  1806bd:	7f e9                	jg     1806a8 <printer_vprintf+0x401>
  1806bf:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1806c2:	85 ff                	test   %edi,%edi
  1806c4:	b8 01 00 00 00       	mov    $0x1,%eax
  1806c9:	0f 4f c7             	cmovg  %edi,%eax
  1806cc:	29 c7                	sub    %eax,%edi
  1806ce:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1806d1:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1806d5:	0f b6 07             	movzbl (%rdi),%eax
  1806d8:	84 c0                	test   %al,%al
  1806da:	74 22                	je     1806fe <printer_vprintf+0x457>
  1806dc:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1806e0:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  1806e3:	0f b6 f0             	movzbl %al,%esi
  1806e6:	44 89 fa             	mov    %r15d,%edx
  1806e9:	4c 89 f7             	mov    %r14,%rdi
  1806ec:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1806ef:	48 83 c3 01          	add    $0x1,%rbx
  1806f3:	0f b6 03             	movzbl (%rbx),%eax
  1806f6:	84 c0                	test   %al,%al
  1806f8:	75 e9                	jne    1806e3 <printer_vprintf+0x43c>
  1806fa:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  1806fe:	8b 45 9c             	mov    -0x64(%rbp),%eax
  180701:	85 c0                	test   %eax,%eax
  180703:	7e 1d                	jle    180722 <printer_vprintf+0x47b>
  180705:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  180709:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  18070b:	44 89 fa             	mov    %r15d,%edx
  18070e:	be 30 00 00 00       	mov    $0x30,%esi
  180713:	4c 89 f7             	mov    %r14,%rdi
  180716:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  180719:	83 eb 01             	sub    $0x1,%ebx
  18071c:	75 ed                	jne    18070b <printer_vprintf+0x464>
  18071e:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  180722:	8b 45 98             	mov    -0x68(%rbp),%eax
  180725:	85 c0                	test   %eax,%eax
  180727:	7e 27                	jle    180750 <printer_vprintf+0x4a9>
  180729:	89 c0                	mov    %eax,%eax
  18072b:	4c 01 e0             	add    %r12,%rax
  18072e:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  180732:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  180735:	41 0f b6 34 24       	movzbl (%r12),%esi
  18073a:	44 89 fa             	mov    %r15d,%edx
  18073d:	4c 89 f7             	mov    %r14,%rdi
  180740:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  180743:	49 83 c4 01          	add    $0x1,%r12
  180747:	49 39 dc             	cmp    %rbx,%r12
  18074a:	75 e9                	jne    180735 <printer_vprintf+0x48e>
  18074c:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  180750:	45 85 ed             	test   %r13d,%r13d
  180753:	7e 14                	jle    180769 <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  180755:	44 89 fa             	mov    %r15d,%edx
  180758:	be 20 00 00 00       	mov    $0x20,%esi
  18075d:	4c 89 f7             	mov    %r14,%rdi
  180760:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  180763:	41 83 ed 01          	sub    $0x1,%r13d
  180767:	75 ec                	jne    180755 <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  180769:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  18076d:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  180771:	84 c0                	test   %al,%al
  180773:	0f 84 fe 01 00 00    	je     180977 <printer_vprintf+0x6d0>
        if (*format != '%') {
  180779:	3c 25                	cmp    $0x25,%al
  18077b:	0f 84 54 fb ff ff    	je     1802d5 <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  180781:	0f b6 f0             	movzbl %al,%esi
  180784:	44 89 fa             	mov    %r15d,%edx
  180787:	4c 89 f7             	mov    %r14,%rdi
  18078a:	41 ff 16             	callq  *(%r14)
            continue;
  18078d:	4c 89 e3             	mov    %r12,%rbx
  180790:	eb d7                	jmp    180769 <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  180792:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  180796:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  18079a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  18079e:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1807a2:	e9 51 fe ff ff       	jmpq   1805f8 <printer_vprintf+0x351>
            color = va_arg(val, int);
  1807a7:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1807ab:	8b 07                	mov    (%rdi),%eax
  1807ad:	83 f8 2f             	cmp    $0x2f,%eax
  1807b0:	77 10                	ja     1807c2 <printer_vprintf+0x51b>
  1807b2:	89 c2                	mov    %eax,%edx
  1807b4:	48 03 57 10          	add    0x10(%rdi),%rdx
  1807b8:	83 c0 08             	add    $0x8,%eax
  1807bb:	89 07                	mov    %eax,(%rdi)
  1807bd:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1807c0:	eb a7                	jmp    180769 <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  1807c2:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1807c6:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1807ca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1807ce:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1807d2:	eb e9                	jmp    1807bd <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  1807d4:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1807d8:	8b 01                	mov    (%rcx),%eax
  1807da:	83 f8 2f             	cmp    $0x2f,%eax
  1807dd:	77 23                	ja     180802 <printer_vprintf+0x55b>
  1807df:	89 c2                	mov    %eax,%edx
  1807e1:	48 03 51 10          	add    0x10(%rcx),%rdx
  1807e5:	83 c0 08             	add    $0x8,%eax
  1807e8:	89 01                	mov    %eax,(%rcx)
  1807ea:	8b 02                	mov    (%rdx),%eax
  1807ec:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1807ef:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1807f3:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1807f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  1807fd:	e9 ff fd ff ff       	jmpq   180601 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  180802:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  180806:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  18080a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  18080e:	48 89 47 08          	mov    %rax,0x8(%rdi)
  180812:	eb d6                	jmp    1807ea <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  180814:	84 d2                	test   %dl,%dl
  180816:	0f 85 39 01 00 00    	jne    180955 <printer_vprintf+0x6ae>
  18081c:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  180820:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  180824:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  180828:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  18082c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  180832:	e9 ca fd ff ff       	jmpq   180601 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  180837:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  18083d:	bf a0 0c 18 00       	mov    $0x180ca0,%edi
        if (flags & FLAG_NUMERIC) {
  180842:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  180847:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  18084b:	4c 89 c1             	mov    %r8,%rcx
  18084e:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  180852:	48 63 f6             	movslq %esi,%rsi
  180855:	49 83 ec 01          	sub    $0x1,%r12
  180859:	48 89 c8             	mov    %rcx,%rax
  18085c:	ba 00 00 00 00       	mov    $0x0,%edx
  180861:	48 f7 f6             	div    %rsi
  180864:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  180868:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  18086c:	48 89 ca             	mov    %rcx,%rdx
  18086f:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  180872:	48 39 d6             	cmp    %rdx,%rsi
  180875:	76 de                	jbe    180855 <printer_vprintf+0x5ae>
  180877:	e9 9a fd ff ff       	jmpq   180616 <printer_vprintf+0x36f>
                prefix = "-";
  18087c:	48 c7 45 a0 b5 0a 18 	movq   $0x180ab5,-0x60(%rbp)
  180883:	00 
            if (flags & FLAG_NEGATIVE) {
  180884:	8b 45 a8             	mov    -0x58(%rbp),%eax
  180887:	a8 80                	test   $0x80,%al
  180889:	0f 85 b0 fd ff ff    	jne    18063f <printer_vprintf+0x398>
                prefix = "+";
  18088f:	48 c7 45 a0 b0 0a 18 	movq   $0x180ab0,-0x60(%rbp)
  180896:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  180897:	a8 10                	test   $0x10,%al
  180899:	0f 85 a0 fd ff ff    	jne    18063f <printer_vprintf+0x398>
                prefix = " ";
  18089f:	a8 08                	test   $0x8,%al
  1808a1:	ba b8 0a 18 00       	mov    $0x180ab8,%edx
  1808a6:	b8 b7 0a 18 00       	mov    $0x180ab7,%eax
  1808ab:	48 0f 44 c2          	cmove  %rdx,%rax
  1808af:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1808b3:	e9 87 fd ff ff       	jmpq   18063f <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  1808b8:	41 8d 41 10          	lea    0x10(%r9),%eax
  1808bc:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1808c1:	0f 85 78 fd ff ff    	jne    18063f <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  1808c7:	4d 85 c0             	test   %r8,%r8
  1808ca:	75 0d                	jne    1808d9 <printer_vprintf+0x632>
  1808cc:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1808d3:	0f 84 66 fd ff ff    	je     18063f <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  1808d9:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1808dd:	ba b9 0a 18 00       	mov    $0x180ab9,%edx
  1808e2:	b8 b2 0a 18 00       	mov    $0x180ab2,%eax
  1808e7:	48 0f 44 c2          	cmove  %rdx,%rax
  1808eb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1808ef:	e9 4b fd ff ff       	jmpq   18063f <printer_vprintf+0x398>
            len = strlen(data);
  1808f4:	4c 89 e7             	mov    %r12,%rdi
  1808f7:	e8 b5 f8 ff ff       	callq  1801b1 <strlen>
  1808fc:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1808ff:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  180903:	0f 84 63 fd ff ff    	je     18066c <printer_vprintf+0x3c5>
  180909:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  18090d:	0f 84 59 fd ff ff    	je     18066c <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  180913:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  180916:	89 ca                	mov    %ecx,%edx
  180918:	29 c2                	sub    %eax,%edx
  18091a:	39 c1                	cmp    %eax,%ecx
  18091c:	b8 00 00 00 00       	mov    $0x0,%eax
  180921:	0f 4e d0             	cmovle %eax,%edx
  180924:	89 55 9c             	mov    %edx,-0x64(%rbp)
  180927:	e9 56 fd ff ff       	jmpq   180682 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  18092c:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  180930:	e8 7c f8 ff ff       	callq  1801b1 <strlen>
  180935:	8b 7d 98             	mov    -0x68(%rbp),%edi
  180938:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  18093b:	44 89 e9             	mov    %r13d,%ecx
  18093e:	29 f9                	sub    %edi,%ecx
  180940:	29 c1                	sub    %eax,%ecx
  180942:	44 39 ea             	cmp    %r13d,%edx
  180945:	b8 00 00 00 00       	mov    $0x0,%eax
  18094a:	0f 4d c8             	cmovge %eax,%ecx
  18094d:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  180950:	e9 2d fd ff ff       	jmpq   180682 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  180955:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  180958:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  18095c:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  180960:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  180966:	e9 96 fc ff ff       	jmpq   180601 <printer_vprintf+0x35a>
        int flags = 0;
  18096b:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  180972:	e9 b0 f9 ff ff       	jmpq   180327 <printer_vprintf+0x80>
}
  180977:	48 83 c4 58          	add    $0x58,%rsp
  18097b:	5b                   	pop    %rbx
  18097c:	41 5c                	pop    %r12
  18097e:	41 5d                	pop    %r13
  180980:	41 5e                	pop    %r14
  180982:	41 5f                	pop    %r15
  180984:	5d                   	pop    %rbp
  180985:	c3                   	retq   

0000000000180986 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  180986:	55                   	push   %rbp
  180987:	48 89 e5             	mov    %rsp,%rbp
  18098a:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  18098e:	48 c7 45 f0 91 00 18 	movq   $0x180091,-0x10(%rbp)
  180995:	00 
        cpos = 0;
  180996:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  18099c:	b8 00 00 00 00       	mov    $0x0,%eax
  1809a1:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1809a4:	48 63 ff             	movslq %edi,%rdi
  1809a7:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  1809ae:	00 
  1809af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1809b3:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  1809b7:	e8 eb f8 ff ff       	callq  1802a7 <printer_vprintf>
    return cp.cursor - console;
  1809bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1809c0:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1809c6:	48 d1 f8             	sar    %rax
}
  1809c9:	c9                   	leaveq 
  1809ca:	c3                   	retq   

00000000001809cb <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1809cb:	55                   	push   %rbp
  1809cc:	48 89 e5             	mov    %rsp,%rbp
  1809cf:	48 83 ec 50          	sub    $0x50,%rsp
  1809d3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1809d7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1809db:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1809df:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1809e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1809ea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1809ee:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1809f2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1809f6:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1809fa:	e8 87 ff ff ff       	callq  180986 <console_vprintf>
}
  1809ff:	c9                   	leaveq 
  180a00:	c3                   	retq   

0000000000180a01 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  180a01:	55                   	push   %rbp
  180a02:	48 89 e5             	mov    %rsp,%rbp
  180a05:	53                   	push   %rbx
  180a06:	48 83 ec 28          	sub    $0x28,%rsp
  180a0a:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  180a0d:	48 c7 45 d8 17 01 18 	movq   $0x180117,-0x28(%rbp)
  180a14:	00 
    sp.s = s;
  180a15:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  180a19:	48 85 f6             	test   %rsi,%rsi
  180a1c:	75 0b                	jne    180a29 <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  180a1e:	8b 45 e0             	mov    -0x20(%rbp),%eax
  180a21:	29 d8                	sub    %ebx,%eax
}
  180a23:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  180a27:	c9                   	leaveq 
  180a28:	c3                   	retq   
        sp.end = s + size - 1;
  180a29:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  180a2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  180a32:	be 00 00 00 00       	mov    $0x0,%esi
  180a37:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  180a3b:	e8 67 f8 ff ff       	callq  1802a7 <printer_vprintf>
        *sp.s = 0;
  180a40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  180a44:	c6 00 00             	movb   $0x0,(%rax)
  180a47:	eb d5                	jmp    180a1e <vsnprintf+0x1d>

0000000000180a49 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  180a49:	55                   	push   %rbp
  180a4a:	48 89 e5             	mov    %rsp,%rbp
  180a4d:	48 83 ec 50          	sub    $0x50,%rsp
  180a51:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  180a55:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  180a59:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  180a5d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  180a64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  180a68:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  180a6c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  180a70:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  180a74:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  180a78:	e8 84 ff ff ff       	callq  180a01 <vsnprintf>
    va_end(val);
    return n;
}
  180a7d:	c9                   	leaveq 
  180a7e:	c3                   	retq   

0000000000180a7f <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  180a7f:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  180a84:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  180a89:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  180a8e:	48 83 c0 02          	add    $0x2,%rax
  180a92:	48 39 d0             	cmp    %rdx,%rax
  180a95:	75 f2                	jne    180a89 <console_clear+0xa>
    }
    cursorpos = 0;
  180a97:	c7 05 5b 85 f3 ff 00 	movl   $0x0,-0xc7aa5(%rip)        # b8ffc <cursorpos>
  180a9e:	00 00 00 
}
  180aa1:	c3                   	retq   
