
obj/kernel.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000040000 <entry_from_boot>:
# The entry_from_boot routine sets the stack pointer to the top of the
# OS kernel stack, then jumps to the `kernel` routine.

.globl entry_from_boot
entry_from_boot:
        movq $0x80000, %rsp
   40000:	48 c7 c4 00 00 08 00 	mov    $0x80000,%rsp
        movq %rsp, %rbp
   40007:	48 89 e5             	mov    %rsp,%rbp
        pushq $0
   4000a:	6a 00                	pushq  $0x0
        popfq
   4000c:	9d                   	popfq  
        // Check for multiboot command line; if found pass it along.
        cmpl $0x2BADB002, %eax
   4000d:	3d 02 b0 ad 2b       	cmp    $0x2badb002,%eax
        jne 1f
   40012:	75 0d                	jne    40021 <entry_from_boot+0x21>
        testl $4, (%rbx)
   40014:	f7 03 04 00 00 00    	testl  $0x4,(%rbx)
        je 1f
   4001a:	74 05                	je     40021 <entry_from_boot+0x21>
        movl 16(%rbx), %edi
   4001c:	8b 7b 10             	mov    0x10(%rbx),%edi
        jmp 2f
   4001f:	eb 07                	jmp    40028 <entry_from_boot+0x28>
1:      movq $0, %rdi
   40021:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
2:      jmp kernel
   40028:	e9 3a 01 00 00       	jmpq   40167 <kernel>
   4002d:	90                   	nop

000000000004002e <gpf_int_handler>:
# Interrupt handlers
.align 2

        .globl gpf_int_handler
gpf_int_handler:
        pushq $13               // trap number
   4002e:	6a 0d                	pushq  $0xd
        jmp generic_exception_handler
   40030:	eb 6e                	jmp    400a0 <generic_exception_handler>

0000000000040032 <pagefault_int_handler>:

        .globl pagefault_int_handler
pagefault_int_handler:
        pushq $14
   40032:	6a 0e                	pushq  $0xe
        jmp generic_exception_handler
   40034:	eb 6a                	jmp    400a0 <generic_exception_handler>

0000000000040036 <timer_int_handler>:

        .globl timer_int_handler
timer_int_handler:
        pushq $0                // error code
   40036:	6a 00                	pushq  $0x0
        pushq $32
   40038:	6a 20                	pushq  $0x20
        jmp generic_exception_handler
   4003a:	eb 64                	jmp    400a0 <generic_exception_handler>

000000000004003c <sys48_int_handler>:

sys48_int_handler:
        pushq $0
   4003c:	6a 00                	pushq  $0x0
        pushq $48
   4003e:	6a 30                	pushq  $0x30
        jmp generic_exception_handler
   40040:	eb 5e                	jmp    400a0 <generic_exception_handler>

0000000000040042 <sys49_int_handler>:

sys49_int_handler:
        pushq $0
   40042:	6a 00                	pushq  $0x0
        pushq $49
   40044:	6a 31                	pushq  $0x31
        jmp generic_exception_handler
   40046:	eb 58                	jmp    400a0 <generic_exception_handler>

0000000000040048 <sys50_int_handler>:

sys50_int_handler:
        pushq $0
   40048:	6a 00                	pushq  $0x0
        pushq $50
   4004a:	6a 32                	pushq  $0x32
        jmp generic_exception_handler
   4004c:	eb 52                	jmp    400a0 <generic_exception_handler>

000000000004004e <sys51_int_handler>:

sys51_int_handler:
        pushq $0
   4004e:	6a 00                	pushq  $0x0
        pushq $51
   40050:	6a 33                	pushq  $0x33
        jmp generic_exception_handler
   40052:	eb 4c                	jmp    400a0 <generic_exception_handler>

0000000000040054 <sys52_int_handler>:

sys52_int_handler:
        pushq $0
   40054:	6a 00                	pushq  $0x0
        pushq $52
   40056:	6a 34                	pushq  $0x34
        jmp generic_exception_handler
   40058:	eb 46                	jmp    400a0 <generic_exception_handler>

000000000004005a <sys53_int_handler>:

sys53_int_handler:
        pushq $0
   4005a:	6a 00                	pushq  $0x0
        pushq $53
   4005c:	6a 35                	pushq  $0x35
        jmp generic_exception_handler
   4005e:	eb 40                	jmp    400a0 <generic_exception_handler>

0000000000040060 <sys54_int_handler>:

sys54_int_handler:
        pushq $0
   40060:	6a 00                	pushq  $0x0
        pushq $54
   40062:	6a 36                	pushq  $0x36
        jmp generic_exception_handler
   40064:	eb 3a                	jmp    400a0 <generic_exception_handler>

0000000000040066 <sys55_int_handler>:

sys55_int_handler:
        pushq $0
   40066:	6a 00                	pushq  $0x0
        pushq $55
   40068:	6a 37                	pushq  $0x37
        jmp generic_exception_handler
   4006a:	eb 34                	jmp    400a0 <generic_exception_handler>

000000000004006c <sys56_int_handler>:

sys56_int_handler:
        pushq $0
   4006c:	6a 00                	pushq  $0x0
        pushq $56
   4006e:	6a 38                	pushq  $0x38
        jmp generic_exception_handler
   40070:	eb 2e                	jmp    400a0 <generic_exception_handler>

0000000000040072 <sys57_int_handler>:

sys57_int_handler:
        pushq $0
   40072:	6a 00                	pushq  $0x0
        pushq $57
   40074:	6a 39                	pushq  $0x39
        jmp generic_exception_handler
   40076:	eb 28                	jmp    400a0 <generic_exception_handler>

0000000000040078 <sys58_int_handler>:

sys58_int_handler:
        pushq $0
   40078:	6a 00                	pushq  $0x0
        pushq $58
   4007a:	6a 3a                	pushq  $0x3a
        jmp generic_exception_handler
   4007c:	eb 22                	jmp    400a0 <generic_exception_handler>

000000000004007e <sys59_int_handler>:

sys59_int_handler:
        pushq $0
   4007e:	6a 00                	pushq  $0x0
        pushq $59
   40080:	6a 3b                	pushq  $0x3b
        jmp generic_exception_handler
   40082:	eb 1c                	jmp    400a0 <generic_exception_handler>

0000000000040084 <sys60_int_handler>:

sys60_int_handler:
        pushq $0
   40084:	6a 00                	pushq  $0x0
        pushq $60
   40086:	6a 3c                	pushq  $0x3c
        jmp generic_exception_handler
   40088:	eb 16                	jmp    400a0 <generic_exception_handler>

000000000004008a <sys61_int_handler>:

sys61_int_handler:
        pushq $0
   4008a:	6a 00                	pushq  $0x0
        pushq $61
   4008c:	6a 3d                	pushq  $0x3d
        jmp generic_exception_handler
   4008e:	eb 10                	jmp    400a0 <generic_exception_handler>

0000000000040090 <sys62_int_handler>:

sys62_int_handler:
        pushq $0
   40090:	6a 00                	pushq  $0x0
        pushq $62
   40092:	6a 3e                	pushq  $0x3e
        jmp generic_exception_handler
   40094:	eb 0a                	jmp    400a0 <generic_exception_handler>

0000000000040096 <sys63_int_handler>:

sys63_int_handler:
        pushq $0
   40096:	6a 00                	pushq  $0x0
        pushq $63
   40098:	6a 3f                	pushq  $0x3f
        jmp generic_exception_handler
   4009a:	eb 04                	jmp    400a0 <generic_exception_handler>

000000000004009c <default_int_handler>:

        .globl default_int_handler
default_int_handler:
        pushq $0
   4009c:	6a 00                	pushq  $0x0
        jmp generic_exception_handler
   4009e:	eb 00                	jmp    400a0 <generic_exception_handler>

00000000000400a0 <generic_exception_handler>:


generic_exception_handler:
        pushq %gs
   400a0:	0f a8                	pushq  %gs
        pushq %fs
   400a2:	0f a0                	pushq  %fs
        pushq %r15
   400a4:	41 57                	push   %r15
        pushq %r14
   400a6:	41 56                	push   %r14
        pushq %r13
   400a8:	41 55                	push   %r13
        pushq %r12
   400aa:	41 54                	push   %r12
        pushq %r11
   400ac:	41 53                	push   %r11
        pushq %r10
   400ae:	41 52                	push   %r10
        pushq %r9
   400b0:	41 51                	push   %r9
        pushq %r8
   400b2:	41 50                	push   %r8
        pushq %rdi
   400b4:	57                   	push   %rdi
        pushq %rsi
   400b5:	56                   	push   %rsi
        pushq %rbp
   400b6:	55                   	push   %rbp
        pushq %rbx
   400b7:	53                   	push   %rbx
        pushq %rdx
   400b8:	52                   	push   %rdx
        pushq %rcx
   400b9:	51                   	push   %rcx
        pushq %rax
   400ba:	50                   	push   %rax
        movq %rsp, %rdi
   400bb:	48 89 e7             	mov    %rsp,%rdi
        call exception
   400be:	e8 2d 08 00 00       	callq  408f0 <exception>

00000000000400c3 <exception_return>:
        # `exception` should never return.


        .globl exception_return
exception_return:
        movq %rdi, %rsp
   400c3:	48 89 fc             	mov    %rdi,%rsp
        popq %rax
   400c6:	58                   	pop    %rax
        popq %rcx
   400c7:	59                   	pop    %rcx
        popq %rdx
   400c8:	5a                   	pop    %rdx
        popq %rbx
   400c9:	5b                   	pop    %rbx
        popq %rbp
   400ca:	5d                   	pop    %rbp
        popq %rsi
   400cb:	5e                   	pop    %rsi
        popq %rdi
   400cc:	5f                   	pop    %rdi
        popq %r8
   400cd:	41 58                	pop    %r8
        popq %r9
   400cf:	41 59                	pop    %r9
        popq %r10
   400d1:	41 5a                	pop    %r10
        popq %r11
   400d3:	41 5b                	pop    %r11
        popq %r12
   400d5:	41 5c                	pop    %r12
        popq %r13
   400d7:	41 5d                	pop    %r13
        popq %r14
   400d9:	41 5e                	pop    %r14
        popq %r15
   400db:	41 5f                	pop    %r15
        popq %fs
   400dd:	0f a1                	popq   %fs
        popq %gs
   400df:	0f a9                	popq   %gs
        addq $16, %rsp
   400e1:	48 83 c4 10          	add    $0x10,%rsp
        iretq
   400e5:	48 cf                	iretq  

00000000000400e7 <sys_int_handlers>:
   400e7:	3c 00                	cmp    $0x0,%al
   400e9:	04 00                	add    $0x0,%al
   400eb:	00 00                	add    %al,(%rax)
   400ed:	00 00                	add    %al,(%rax)
   400ef:	42 00 04 00          	add    %al,(%rax,%r8,1)
   400f3:	00 00                	add    %al,(%rax)
   400f5:	00 00                	add    %al,(%rax)
   400f7:	48 00 04 00          	rex.W add %al,(%rax,%rax,1)
   400fb:	00 00                	add    %al,(%rax)
   400fd:	00 00                	add    %al,(%rax)
   400ff:	4e 00 04 00          	rex.WRX add %r8b,(%rax,%r8,1)
   40103:	00 00                	add    %al,(%rax)
   40105:	00 00                	add    %al,(%rax)
   40107:	54                   	push   %rsp
   40108:	00 04 00             	add    %al,(%rax,%rax,1)
   4010b:	00 00                	add    %al,(%rax)
   4010d:	00 00                	add    %al,(%rax)
   4010f:	5a                   	pop    %rdx
   40110:	00 04 00             	add    %al,(%rax,%rax,1)
   40113:	00 00                	add    %al,(%rax)
   40115:	00 00                	add    %al,(%rax)
   40117:	60                   	(bad)  
   40118:	00 04 00             	add    %al,(%rax,%rax,1)
   4011b:	00 00                	add    %al,(%rax)
   4011d:	00 00                	add    %al,(%rax)
   4011f:	66 00 04 00          	data16 add %al,(%rax,%rax,1)
   40123:	00 00                	add    %al,(%rax)
   40125:	00 00                	add    %al,(%rax)
   40127:	6c                   	insb   (%dx),%es:(%rdi)
   40128:	00 04 00             	add    %al,(%rax,%rax,1)
   4012b:	00 00                	add    %al,(%rax)
   4012d:	00 00                	add    %al,(%rax)
   4012f:	72 00                	jb     40131 <sys_int_handlers+0x4a>
   40131:	04 00                	add    $0x0,%al
   40133:	00 00                	add    %al,(%rax)
   40135:	00 00                	add    %al,(%rax)
   40137:	78 00                	js     40139 <sys_int_handlers+0x52>
   40139:	04 00                	add    $0x0,%al
   4013b:	00 00                	add    %al,(%rax)
   4013d:	00 00                	add    %al,(%rax)
   4013f:	7e 00                	jle    40141 <sys_int_handlers+0x5a>
   40141:	04 00                	add    $0x0,%al
   40143:	00 00                	add    %al,(%rax)
   40145:	00 00                	add    %al,(%rax)
   40147:	84 00                	test   %al,(%rax)
   40149:	04 00                	add    $0x0,%al
   4014b:	00 00                	add    %al,(%rax)
   4014d:	00 00                	add    %al,(%rax)
   4014f:	8a 00                	mov    (%rax),%al
   40151:	04 00                	add    $0x0,%al
   40153:	00 00                	add    %al,(%rax)
   40155:	00 00                	add    %al,(%rax)
   40157:	90                   	nop
   40158:	00 04 00             	add    %al,(%rax,%rax,1)
   4015b:	00 00                	add    %al,(%rax)
   4015d:	00 00                	add    %al,(%rax)
   4015f:	96                   	xchg   %eax,%esi
   40160:	00 04 00             	add    %al,(%rax,%rax,1)
   40163:	00 00                	add    %al,(%rax)
	...

0000000000040167 <kernel>:

static void process_setup(pid_t pid, int program_number);
x86_64_pagetable *duplicate_pagetable(x86_64_pagetable *pagetable, pid_t pid);
void *alloc_page_process(pid_t pid);
int sys_page_alloc_find_free(x86_64_pagetable *pagetable, pid_t pid, uintptr_t addr);
void kernel(const char* command) {
   40167:	55                   	push   %rbp
   40168:	48 89 e5             	mov    %rsp,%rbp
   4016b:	48 83 ec 20          	sub    $0x20,%rsp
   4016f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    hardware_init();
   40173:	e8 5e 1a 00 00       	callq  41bd6 <hardware_init>
    pageinfo_init();
   40178:	e8 06 11 00 00       	callq  41283 <pageinfo_init>
    console_clear();
   4017d:	e8 3e 3e 00 00       	callq  43fc0 <console_clear>
    timer_init(HZ);
   40182:	bf 64 00 00 00       	mov    $0x64,%edi
   40187:	e8 3a 1f 00 00       	callq  420c6 <timer_init>

    virtual_memory_map(kernel_pagetable, 0, 0, PROC_START_ADDR, PTE_P | PTE_W);
   4018c:	48 8b 05 6d 0e 01 00 	mov    0x10e6d(%rip),%rax        # 51000 <kernel_pagetable>
   40193:	41 b8 03 00 00 00    	mov    $0x3,%r8d
   40199:	b9 00 00 10 00       	mov    $0x100000,%ecx
   4019e:	ba 00 00 00 00       	mov    $0x0,%edx
   401a3:	be 00 00 00 00       	mov    $0x0,%esi
   401a8:	48 89 c7             	mov    %rax,%rdi
   401ab:	e8 64 2c 00 00       	callq  42e14 <virtual_memory_map>
    virtual_memory_map(kernel_pagetable, 0xB8000, 0xB8000, PAGESIZE, PTE_P | PTE_W | PTE_U);
   401b0:	48 8b 05 49 0e 01 00 	mov    0x10e49(%rip),%rax        # 51000 <kernel_pagetable>
   401b7:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   401bd:	b9 00 10 00 00       	mov    $0x1000,%ecx
   401c2:	ba 00 80 0b 00       	mov    $0xb8000,%edx
   401c7:	be 00 80 0b 00       	mov    $0xb8000,%esi
   401cc:	48 89 c7             	mov    %rax,%rdi
   401cf:	e8 40 2c 00 00       	callq  42e14 <virtual_memory_map>
    // Set up process descriptors
    memset(processes, 0, sizeof(processes));
   401d4:	ba 00 0e 00 00       	mov    $0xe00,%edx
   401d9:	be 00 00 00 00       	mov    $0x0,%esi
   401de:	bf 20 e0 04 00       	mov    $0x4e020,%edi
   401e3:	e8 ef 34 00 00       	callq  436d7 <memset>
    for (pid_t i = 0; i < NPROC; i++) {
   401e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   401ef:	eb 44                	jmp    40235 <kernel+0xce>
        processes[i].p_pid = i;
   401f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
   401f4:	48 63 d0             	movslq %eax,%rdx
   401f7:	48 89 d0             	mov    %rdx,%rax
   401fa:	48 c1 e0 03          	shl    $0x3,%rax
   401fe:	48 29 d0             	sub    %rdx,%rax
   40201:	48 c1 e0 05          	shl    $0x5,%rax
   40205:	48 8d 90 20 e0 04 00 	lea    0x4e020(%rax),%rdx
   4020c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4020f:	89 02                	mov    %eax,(%rdx)
        processes[i].p_state = P_FREE;
   40211:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40214:	48 63 d0             	movslq %eax,%rdx
   40217:	48 89 d0             	mov    %rdx,%rax
   4021a:	48 c1 e0 03          	shl    $0x3,%rax
   4021e:	48 29 d0             	sub    %rdx,%rax
   40221:	48 c1 e0 05          	shl    $0x5,%rax
   40225:	48 05 e8 e0 04 00    	add    $0x4e0e8,%rax
   4022b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    for (pid_t i = 0; i < NPROC; i++) {
   40231:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   40235:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   40239:	7e b6                	jle    401f1 <kernel+0x8a>
    }

    if (command && strcmp(command, "fork") == 0) {
   4023b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40240:	74 29                	je     4026b <kernel+0x104>
   40242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40246:	be 00 40 04 00       	mov    $0x44000,%esi
   4024b:	48 89 c7             	mov    %rax,%rdi
   4024e:	e8 f5 34 00 00       	callq  43748 <strcmp>
   40253:	85 c0                	test   %eax,%eax
   40255:	75 14                	jne    4026b <kernel+0x104>
        process_setup(1, 4);
   40257:	be 04 00 00 00       	mov    $0x4,%esi
   4025c:	bf 01 00 00 00       	mov    $0x1,%edi
   40261:	e8 d1 00 00 00       	callq  40337 <process_setup>
   40266:	e9 c2 00 00 00       	jmpq   4032d <kernel+0x1c6>
    } else if (command && strcmp(command, "forkexit") == 0) {
   4026b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40270:	74 29                	je     4029b <kernel+0x134>
   40272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40276:	be 05 40 04 00       	mov    $0x44005,%esi
   4027b:	48 89 c7             	mov    %rax,%rdi
   4027e:	e8 c5 34 00 00       	callq  43748 <strcmp>
   40283:	85 c0                	test   %eax,%eax
   40285:	75 14                	jne    4029b <kernel+0x134>
        process_setup(1, 5);
   40287:	be 05 00 00 00       	mov    $0x5,%esi
   4028c:	bf 01 00 00 00       	mov    $0x1,%edi
   40291:	e8 a1 00 00 00       	callq  40337 <process_setup>
   40296:	e9 92 00 00 00       	jmpq   4032d <kernel+0x1c6>
    } else if (command && strcmp(command, "test") == 0) {
   4029b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   402a0:	74 26                	je     402c8 <kernel+0x161>
   402a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   402a6:	be 0e 40 04 00       	mov    $0x4400e,%esi
   402ab:	48 89 c7             	mov    %rax,%rdi
   402ae:	e8 95 34 00 00       	callq  43748 <strcmp>
   402b3:	85 c0                	test   %eax,%eax
   402b5:	75 11                	jne    402c8 <kernel+0x161>
        process_setup(1, 6);
   402b7:	be 06 00 00 00       	mov    $0x6,%esi
   402bc:	bf 01 00 00 00       	mov    $0x1,%edi
   402c1:	e8 71 00 00 00       	callq  40337 <process_setup>
   402c6:	eb 65                	jmp    4032d <kernel+0x1c6>
    } else if (command && strcmp(command, "test2") == 0) {
   402c8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   402cd:	74 39                	je     40308 <kernel+0x1a1>
   402cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   402d3:	be 13 40 04 00       	mov    $0x44013,%esi
   402d8:	48 89 c7             	mov    %rax,%rdi
   402db:	e8 68 34 00 00       	callq  43748 <strcmp>
   402e0:	85 c0                	test   %eax,%eax
   402e2:	75 24                	jne    40308 <kernel+0x1a1>
        for (pid_t i = 1; i <= 2; ++i) {
   402e4:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
   402eb:	eb 13                	jmp    40300 <kernel+0x199>
            process_setup(i, 6);
   402ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
   402f0:	be 06 00 00 00       	mov    $0x6,%esi
   402f5:	89 c7                	mov    %eax,%edi
   402f7:	e8 3b 00 00 00       	callq  40337 <process_setup>
        for (pid_t i = 1; i <= 2; ++i) {
   402fc:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   40300:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
   40304:	7e e7                	jle    402ed <kernel+0x186>
   40306:	eb 25                	jmp    4032d <kernel+0x1c6>
        }
    } else {
        for (pid_t i = 1; i <= 4; ++i) {
   40308:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
   4030f:	eb 16                	jmp    40327 <kernel+0x1c0>
            process_setup(i, i - 1);
   40311:	8b 45 f4             	mov    -0xc(%rbp),%eax
   40314:	8d 50 ff             	lea    -0x1(%rax),%edx
   40317:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4031a:	89 d6                	mov    %edx,%esi
   4031c:	89 c7                	mov    %eax,%edi
   4031e:	e8 14 00 00 00       	callq  40337 <process_setup>
        for (pid_t i = 1; i <= 4; ++i) {
   40323:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   40327:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
   4032b:	7e e4                	jle    40311 <kernel+0x1aa>
        }
    }


    // Switch to the first process using run()
    run(&processes[1]);
   4032d:	bf 00 e1 04 00       	mov    $0x4e100,%edi
   40332:	e8 ef 0e 00 00       	callq  41226 <run>

0000000000040337 <process_setup>:
// process_setup(pid, program_number)
//    Load application program `program_number` as process number `pid`.
//    This loads the application's code and data into memory, sets its
//    %rip and %rsp, gives it a stack page, and marks it as runnable.

void process_setup(pid_t pid, int program_number) {   
   40337:	55                   	push   %rbp
   40338:	48 89 e5             	mov    %rsp,%rbp
   4033b:	48 83 ec 30          	sub    $0x30,%rsp
   4033f:	89 7d dc             	mov    %edi,-0x24(%rbp)
   40342:	89 75 d8             	mov    %esi,-0x28(%rbp)
    process_init(&processes[pid], 0);
   40345:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40348:	48 63 d0             	movslq %eax,%rdx
   4034b:	48 89 d0             	mov    %rdx,%rax
   4034e:	48 c1 e0 03          	shl    $0x3,%rax
   40352:	48 29 d0             	sub    %rdx,%rax
   40355:	48 c1 e0 05          	shl    $0x5,%rax
   40359:	48 05 20 e0 04 00    	add    $0x4e020,%rax
   4035f:	be 00 00 00 00       	mov    $0x0,%esi
   40364:	48 89 c7             	mov    %rax,%rdi
   40367:	e8 ec 1f 00 00       	callq  42358 <process_init>
    x86_64_pagetable *pagetable_copy = duplicate_pagetable(kernel_pagetable, pid);
   4036c:	48 8b 05 8d 0c 01 00 	mov    0x10c8d(%rip),%rax        # 51000 <kernel_pagetable>
   40373:	8b 55 dc             	mov    -0x24(%rbp),%edx
   40376:	89 d6                	mov    %edx,%esi
   40378:	48 89 c7             	mov    %rax,%rdi
   4037b:	e8 09 01 00 00       	callq  40489 <duplicate_pagetable>
   40380:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    processes[pid].p_pagetable = pagetable_copy;
   40384:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40387:	48 63 d0             	movslq %eax,%rdx
   4038a:	48 89 d0             	mov    %rdx,%rax
   4038d:	48 c1 e0 03          	shl    $0x3,%rax
   40391:	48 29 d0             	sub    %rdx,%rax
   40394:	48 c1 e0 05          	shl    $0x5,%rax
   40398:	48 8d 90 f0 e0 04 00 	lea    0x4e0f0(%rax),%rdx
   4039f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   403a3:	48 89 02             	mov    %rax,(%rdx)
    //++pageinfo[PAGENUMBER(kernel_pagetable)].refcount;
    int r = program_load(&processes[pid], program_number, NULL);
   403a6:	8b 45 dc             	mov    -0x24(%rbp),%eax
   403a9:	48 63 d0             	movslq %eax,%rdx
   403ac:	48 89 d0             	mov    %rdx,%rax
   403af:	48 c1 e0 03          	shl    $0x3,%rax
   403b3:	48 29 d0             	sub    %rdx,%rax
   403b6:	48 c1 e0 05          	shl    $0x5,%rax
   403ba:	48 8d 88 20 e0 04 00 	lea    0x4e020(%rax),%rcx
   403c1:	8b 45 d8             	mov    -0x28(%rbp),%eax
   403c4:	ba 00 00 00 00       	mov    $0x0,%edx
   403c9:	89 c6                	mov    %eax,%esi
   403cb:	48 89 cf             	mov    %rcx,%rdi
   403ce:	e8 f4 2e 00 00       	callq  432c7 <program_load>
   403d3:	89 45 f4             	mov    %eax,-0xc(%rbp)
    assert(r >= 0);
   403d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   403da:	79 14                	jns    403f0 <process_setup+0xb9>
   403dc:	ba 19 40 04 00       	mov    $0x44019,%edx
   403e1:	be 86 00 00 00       	mov    $0x86,%esi
   403e6:	bf 20 40 04 00       	mov    $0x44020,%edi
   403eb:	e8 25 27 00 00       	callq  42b15 <assert_fail>
    processes[pid].p_registers.reg_rsp = MEMSIZE_VIRTUAL; //PROC_START_ADDR + PROC_SIZE * pid;
   403f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
   403f3:	48 63 d0             	movslq %eax,%rdx
   403f6:	48 89 d0             	mov    %rdx,%rax
   403f9:	48 c1 e0 03          	shl    $0x3,%rax
   403fd:	48 29 d0             	sub    %rdx,%rax
   40400:	48 c1 e0 05          	shl    $0x5,%rax
   40404:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   4040a:	48 c7 00 00 00 30 00 	movq   $0x300000,(%rax)
    uintptr_t stack_page = processes[pid].p_registers.reg_rsp - PAGESIZE;
   40411:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40414:	48 63 d0             	movslq %eax,%rdx
   40417:	48 89 d0             	mov    %rdx,%rax
   4041a:	48 c1 e0 03          	shl    $0x3,%rax
   4041e:	48 29 d0             	sub    %rdx,%rax
   40421:	48 c1 e0 05          	shl    $0x5,%rax
   40425:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   4042b:	48 8b 00             	mov    (%rax),%rax
   4042e:	48 2d 00 10 00 00    	sub    $0x1000,%rax
   40434:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    sys_page_alloc_find_free(processes[pid].p_pagetable, pid, stack_page);    
   40438:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4043b:	48 63 d0             	movslq %eax,%rdx
   4043e:	48 89 d0             	mov    %rdx,%rax
   40441:	48 c1 e0 03          	shl    $0x3,%rax
   40445:	48 29 d0             	sub    %rdx,%rax
   40448:	48 c1 e0 05          	shl    $0x5,%rax
   4044c:	48 05 f0 e0 04 00    	add    $0x4e0f0,%rax
   40452:	48 8b 00             	mov    (%rax),%rax
   40455:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   40459:	8b 4d dc             	mov    -0x24(%rbp),%ecx
   4045c:	89 ce                	mov    %ecx,%esi
   4045e:	48 89 c7             	mov    %rax,%rdi
   40461:	e8 37 02 00 00       	callq  4069d <sys_page_alloc_find_free>
    processes[pid].p_state = P_RUNNABLE;
   40466:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40469:	48 63 d0             	movslq %eax,%rdx
   4046c:	48 89 d0             	mov    %rdx,%rax
   4046f:	48 c1 e0 03          	shl    $0x3,%rax
   40473:	48 29 d0             	sub    %rdx,%rax
   40476:	48 c1 e0 05          	shl    $0x5,%rax
   4047a:	48 05 e8 e0 04 00    	add    $0x4e0e8,%rax
   40480:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
}
   40486:	90                   	nop
   40487:	c9                   	leaveq 
   40488:	c3                   	retq   

0000000000040489 <duplicate_pagetable>:

x86_64_pagetable *duplicate_pagetable(x86_64_pagetable *pagetable, pid_t pid){
   40489:	55                   	push   %rbp
   4048a:	48 89 e5             	mov    %rsp,%rbp
   4048d:	48 83 ec 60          	sub    $0x60,%rsp
   40491:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   40495:	89 75 a4             	mov    %esi,-0x5c(%rbp)
    void *L1 = alloc_page_process(pid);
   40498:	8b 45 a4             	mov    -0x5c(%rbp),%eax
   4049b:	89 c7                	mov    %eax,%edi
   4049d:	e8 91 01 00 00       	callq  40633 <alloc_page_process>
   404a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    void *L2 = alloc_page_process(pid);
   404a6:	8b 45 a4             	mov    -0x5c(%rbp),%eax
   404a9:	89 c7                	mov    %eax,%edi
   404ab:	e8 83 01 00 00       	callq  40633 <alloc_page_process>
   404b0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    void *L3 = alloc_page_process(pid);
   404b4:	8b 45 a4             	mov    -0x5c(%rbp),%eax
   404b7:	89 c7                	mov    %eax,%edi
   404b9:	e8 75 01 00 00       	callq  40633 <alloc_page_process>
   404be:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    void *L4_1 = alloc_page_process(pid);
   404c2:	8b 45 a4             	mov    -0x5c(%rbp),%eax
   404c5:	89 c7                	mov    %eax,%edi
   404c7:	e8 67 01 00 00       	callq  40633 <alloc_page_process>
   404cc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    void *L4_2 = alloc_page_process(pid);
   404d0:	8b 45 a4             	mov    -0x5c(%rbp),%eax
   404d3:	89 c7                	mov    %eax,%edi
   404d5:	e8 59 01 00 00       	callq  40633 <alloc_page_process>
   404da:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    memset(L1, 0, PAGESIZE);
   404de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   404e2:	ba 00 10 00 00       	mov    $0x1000,%edx
   404e7:	be 00 00 00 00       	mov    $0x0,%esi
   404ec:	48 89 c7             	mov    %rax,%rdi
   404ef:	e8 e3 31 00 00       	callq  436d7 <memset>
    memset(L2, 0, PAGESIZE);
   404f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   404f8:	ba 00 10 00 00       	mov    $0x1000,%edx
   404fd:	be 00 00 00 00       	mov    $0x0,%esi
   40502:	48 89 c7             	mov    %rax,%rdi
   40505:	e8 cd 31 00 00       	callq  436d7 <memset>
    memset(L3, 0, PAGESIZE);
   4050a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4050e:	ba 00 10 00 00       	mov    $0x1000,%edx
   40513:	be 00 00 00 00       	mov    $0x0,%esi
   40518:	48 89 c7             	mov    %rax,%rdi
   4051b:	e8 b7 31 00 00       	callq  436d7 <memset>
    memset(L4_1, 0, PAGESIZE);
   40520:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40524:	ba 00 10 00 00       	mov    $0x1000,%edx
   40529:	be 00 00 00 00       	mov    $0x0,%esi
   4052e:	48 89 c7             	mov    %rax,%rdi
   40531:	e8 a1 31 00 00       	callq  436d7 <memset>
    memset(L4_2, 0, PAGESIZE);
   40536:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   4053a:	ba 00 10 00 00       	mov    $0x1000,%edx
   4053f:	be 00 00 00 00       	mov    $0x0,%esi
   40544:	48 89 c7             	mov    %rax,%rdi
   40547:	e8 8b 31 00 00       	callq  436d7 <memset>
    if(L1 && L2 && L3 && L4_1 && L4_2){
   4054c:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
   40551:	0f 84 d5 00 00 00    	je     4062c <duplicate_pagetable+0x1a3>
   40557:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   4055c:	0f 84 ca 00 00 00    	je     4062c <duplicate_pagetable+0x1a3>
   40562:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   40567:	0f 84 bf 00 00 00    	je     4062c <duplicate_pagetable+0x1a3>
   4056d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   40572:	0f 84 b4 00 00 00    	je     4062c <duplicate_pagetable+0x1a3>
   40578:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
   4057d:	0f 84 a9 00 00 00    	je     4062c <duplicate_pagetable+0x1a3>
        ((x86_64_pagetable *) L1)->entry[0] = (x86_64_pageentry_t) (uintptr_t) L2 | PTE_P | PTE_W | PTE_U;
   40583:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40587:	48 83 c8 07          	or     $0x7,%rax
   4058b:	48 89 c2             	mov    %rax,%rdx
   4058e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40592:	48 89 10             	mov    %rdx,(%rax)
        ((x86_64_pagetable *) L2)->entry[0] = (x86_64_pageentry_t) (uintptr_t) L3 | PTE_P | PTE_W | PTE_U;
   40595:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40599:	48 83 c8 07          	or     $0x7,%rax
   4059d:	48 89 c2             	mov    %rax,%rdx
   405a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   405a4:	48 89 10             	mov    %rdx,(%rax)
        ((x86_64_pagetable *) L3)->entry[0] = (x86_64_pageentry_t) (uintptr_t) L4_1 | PTE_P | PTE_W | PTE_U;
   405a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   405ab:	48 83 c8 07          	or     $0x7,%rax
   405af:	48 89 c2             	mov    %rax,%rdx
   405b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   405b6:	48 89 10             	mov    %rdx,(%rax)
        ((x86_64_pagetable *) L3)->entry[1] = (x86_64_pageentry_t) (uintptr_t) L4_2| PTE_P | PTE_W | PTE_U;
   405b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   405bd:	48 83 c8 07          	or     $0x7,%rax
   405c1:	48 89 c2             	mov    %rax,%rdx
   405c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   405c8:	48 89 50 08          	mov    %rdx,0x8(%rax)

        x86_64_pagetable *fill_pagetable = (x86_64_pagetable *) L1;
   405cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   405d0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)

        for (uintptr_t va = 0; va < PROC_START_ADDR; va += PAGESIZE)
   405d4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   405db:	00 
   405dc:	eb 3e                	jmp    4061c <duplicate_pagetable+0x193>
        {
            vamapping map = virtual_memory_lookup(pagetable, va);
   405de:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
   405e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   405e6:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
   405ea:	48 89 ce             	mov    %rcx,%rsi
   405ed:	48 89 c7             	mov    %rax,%rdi
   405f0:	e8 db 2b 00 00       	callq  431d0 <virtual_memory_lookup>
            virtual_memory_map(fill_pagetable, va, map.pa, PAGESIZE, map.perm);
   405f5:	8b 4d c0             	mov    -0x40(%rbp),%ecx
   405f8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   405fc:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   40600:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40604:	41 89 c8             	mov    %ecx,%r8d
   40607:	b9 00 10 00 00       	mov    $0x1000,%ecx
   4060c:	48 89 c7             	mov    %rax,%rdi
   4060f:	e8 00 28 00 00       	callq  42e14 <virtual_memory_map>
        for (uintptr_t va = 0; va < PROC_START_ADDR; va += PAGESIZE)
   40614:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   4061b:	00 
   4061c:	48 81 7d f8 ff ff 0f 	cmpq   $0xfffff,-0x8(%rbp)
   40623:	00 
   40624:	76 b8                	jbe    405de <duplicate_pagetable+0x155>
        }
        return fill_pagetable;
   40626:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4062a:	eb 05                	jmp    40631 <duplicate_pagetable+0x1a8>
    }
    return NULL;
   4062c:	b8 00 00 00 00       	mov    $0x0,%eax
}
   40631:	c9                   	leaveq 
   40632:	c3                   	retq   

0000000000040633 <alloc_page_process>:


void *alloc_page_process(pid_t pid){
   40633:	55                   	push   %rbp
   40634:	48 89 e5             	mov    %rsp,%rbp
   40637:	48 83 ec 20          	sub    $0x20,%rsp
   4063b:	89 7d ec             	mov    %edi,-0x14(%rbp)
    int p;
    for(p = 1; p < NPAGES; p++){
   4063e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
   40645:	eb 15                	jmp    4065c <alloc_page_process+0x29>
        if(pageinfo[p].refcount == 0)
   40647:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4064a:	48 98                	cltq   
   4064c:	0f b6 84 00 41 ee 04 	movzbl 0x4ee41(%rax,%rax,1),%eax
   40653:	00 
   40654:	84 c0                	test   %al,%al
   40656:	74 0f                	je     40667 <alloc_page_process+0x34>
    for(p = 1; p < NPAGES; p++){
   40658:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   4065c:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   40663:	7e e2                	jle    40647 <alloc_page_process+0x14>
   40665:	eb 01                	jmp    40668 <alloc_page_process+0x35>
        break;
   40667:	90                   	nop
    }
    int page = assign_physical_page(PAGEADDRESS(p), pid);
   40668:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4066b:	0f be c0             	movsbl %al,%eax
   4066e:	8b 55 fc             	mov    -0x4(%rbp),%edx
   40671:	48 63 d2             	movslq %edx,%rdx
   40674:	48 c1 e2 0c          	shl    $0xc,%rdx
   40678:	89 c6                	mov    %eax,%esi
   4067a:	48 89 d7             	mov    %rdx,%rdi
   4067d:	e8 c8 00 00 00       	callq  4074a <assign_physical_page>
   40682:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(page > -1)
   40685:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
   40689:	78 0b                	js     40696 <alloc_page_process+0x63>
        return (void *)PAGEADDRESS(p);
   4068b:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4068e:	48 98                	cltq   
   40690:	48 c1 e0 0c          	shl    $0xc,%rax
   40694:	eb 05                	jmp    4069b <alloc_page_process+0x68>
    return NULL;
   40696:	b8 00 00 00 00       	mov    $0x0,%eax
}
   4069b:	c9                   	leaveq 
   4069c:	c3                   	retq   

000000000004069d <sys_page_alloc_find_free>:

//Reuses INT_SYS_PAGE_ALLOC to find free pages
int sys_page_alloc_find_free(x86_64_pagetable *pagetable, pid_t pid, uintptr_t addr){
   4069d:	55                   	push   %rbp
   4069e:	48 89 e5             	mov    %rsp,%rbp
   406a1:	48 83 ec 30          	sub    $0x30,%rsp
   406a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   406a9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
   406ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    int p;
    for (p = 1; p < NPAGES; p++){
   406b0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
   406b7:	eb 25                	jmp    406de <sys_page_alloc_find_free+0x41>
        if (pageinfo[p].refcount == 0)
   406b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
   406bc:	48 98                	cltq   
   406be:	0f b6 84 00 41 ee 04 	movzbl 0x4ee41(%rax,%rax,1),%eax
   406c5:	00 
   406c6:	84 c0                	test   %al,%al
   406c8:	74 1f                	je     406e9 <sys_page_alloc_find_free+0x4c>
            break;
        else if (p  == NPAGES - 1)
   406ca:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   406d1:	75 07                	jne    406da <sys_page_alloc_find_free+0x3d>
            return -1;
   406d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   406d8:	eb 6e                	jmp    40748 <sys_page_alloc_find_free+0xab>
    for (p = 1; p < NPAGES; p++){
   406da:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   406de:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   406e5:	7e d2                	jle    406b9 <sys_page_alloc_find_free+0x1c>
   406e7:	eb 01                	jmp    406ea <sys_page_alloc_find_free+0x4d>
            break;
   406e9:	90                   	nop
    }
    int r = assign_physical_page(PAGEADDRESS(p), pid);
   406ea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   406ed:	0f be c0             	movsbl %al,%eax
   406f0:	8b 55 fc             	mov    -0x4(%rbp),%edx
   406f3:	48 63 d2             	movslq %edx,%rdx
   406f6:	48 c1 e2 0c          	shl    $0xc,%rdx
   406fa:	89 c6                	mov    %eax,%esi
   406fc:	48 89 d7             	mov    %rdx,%rdi
   406ff:	e8 46 00 00 00       	callq  4074a <assign_physical_page>
   40704:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if (addr < PROC_START_ADDR)
   40707:	48 81 7d d8 ff ff 0f 	cmpq   $0xfffff,-0x28(%rbp)
   4070e:	00 
   4070f:	77 07                	ja     40718 <sys_page_alloc_find_free+0x7b>
        r = -1;
   40711:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
    if (r >= 0) 
   40718:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
   4071c:	78 27                	js     40745 <sys_page_alloc_find_free+0xa8>
        virtual_memory_map(pagetable, addr, PAGEADDRESS(p),
   4071e:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40721:	48 98                	cltq   
   40723:	48 c1 e0 0c          	shl    $0xc,%rax
   40727:	48 89 c2             	mov    %rax,%rdx
   4072a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
   4072e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40732:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   40738:	b9 00 10 00 00       	mov    $0x1000,%ecx
   4073d:	48 89 c7             	mov    %rax,%rdi
   40740:	e8 cf 26 00 00       	callq  42e14 <virtual_memory_map>
                        PAGESIZE, PTE_P | PTE_W | PTE_U);
    return r;
   40745:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
   40748:	c9                   	leaveq 
   40749:	c3                   	retq   

000000000004074a <assign_physical_page>:
// assign_physical_page(addr, owner)
//    Allocates the page with physical address `addr` to the given owner.
//    Fails if physical page `addr` was already allocated. Returns 0 on
//    success and -1 on failure. Used by the program loader.

int assign_physical_page(uintptr_t addr, int8_t owner) {
   4074a:	55                   	push   %rbp
   4074b:	48 89 e5             	mov    %rsp,%rbp
   4074e:	48 83 ec 10          	sub    $0x10,%rsp
   40752:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   40756:	89 f0                	mov    %esi,%eax
   40758:	88 45 f4             	mov    %al,-0xc(%rbp)
    if ((addr & 0xFFF) != 0
   4075b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4075f:	25 ff 0f 00 00       	and    $0xfff,%eax
   40764:	48 85 c0             	test   %rax,%rax
   40767:	75 20                	jne    40789 <assign_physical_page+0x3f>
        || addr >= MEMSIZE_PHYSICAL
   40769:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   40770:	00 
   40771:	77 16                	ja     40789 <assign_physical_page+0x3f>
        || pageinfo[PAGENUMBER(addr)].refcount != 0) {
   40773:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40777:	48 c1 e8 0c          	shr    $0xc,%rax
   4077b:	48 98                	cltq   
   4077d:	0f b6 84 00 41 ee 04 	movzbl 0x4ee41(%rax,%rax,1),%eax
   40784:	00 
   40785:	84 c0                	test   %al,%al
   40787:	74 07                	je     40790 <assign_physical_page+0x46>
        return -1;
   40789:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   4078e:	eb 2c                	jmp    407bc <assign_physical_page+0x72>
    } else {
        pageinfo[PAGENUMBER(addr)].refcount = 1;
   40790:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40794:	48 c1 e8 0c          	shr    $0xc,%rax
   40798:	48 98                	cltq   
   4079a:	c6 84 00 41 ee 04 00 	movb   $0x1,0x4ee41(%rax,%rax,1)
   407a1:	01 
        pageinfo[PAGENUMBER(addr)].owner = owner;
   407a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   407a6:	48 c1 e8 0c          	shr    $0xc,%rax
   407aa:	48 98                	cltq   
   407ac:	0f b6 55 f4          	movzbl -0xc(%rbp),%edx
   407b0:	88 94 00 40 ee 04 00 	mov    %dl,0x4ee40(%rax,%rax,1)
        return 0;
   407b7:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
   407bc:	c9                   	leaveq 
   407bd:	c3                   	retq   

00000000000407be <syscall_mapping>:

void syscall_mapping(proc* p){
   407be:	55                   	push   %rbp
   407bf:	48 89 e5             	mov    %rsp,%rbp
   407c2:	48 83 ec 70          	sub    $0x70,%rsp
   407c6:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)

    uintptr_t mapping_ptr = p->p_registers.reg_rdi;
   407ca:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   407ce:	48 8b 40 38          	mov    0x38(%rax),%rax
   407d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    uintptr_t ptr = p->p_registers.reg_rsi;
   407d6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   407da:	48 8b 40 30          	mov    0x30(%rax),%rax
   407de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

    //convert to physical address so kernel can write to it
    vamapping map = virtual_memory_lookup(p->p_pagetable, mapping_ptr);
   407e2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   407e6:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   407ed:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   407f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   407f5:	48 89 ce             	mov    %rcx,%rsi
   407f8:	48 89 c7             	mov    %rax,%rdi
   407fb:	e8 d0 29 00 00       	callq  431d0 <virtual_memory_lookup>

    // check for write access
    if((map.perm & (PTE_W|PTE_U)) != (PTE_W|PTE_U))
   40800:	8b 45 e0             	mov    -0x20(%rbp),%eax
   40803:	48 98                	cltq   
   40805:	83 e0 06             	and    $0x6,%eax
   40808:	48 83 f8 06          	cmp    $0x6,%rax
   4080c:	75 73                	jne    40881 <syscall_mapping+0xc3>
	return;
    uintptr_t endaddr = map.pa + sizeof(vamapping) - 1;
   4080e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40812:	48 83 c0 17          	add    $0x17,%rax
   40816:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    // check for write access for end address
    vamapping end_map = virtual_memory_lookup(p->p_pagetable, endaddr);
   4081a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   4081e:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   40825:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
   40829:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   4082d:	48 89 ce             	mov    %rcx,%rsi
   40830:	48 89 c7             	mov    %rax,%rdi
   40833:	e8 98 29 00 00       	callq  431d0 <virtual_memory_lookup>
    if((end_map.perm & (PTE_W|PTE_P)) != (PTE_W|PTE_P))
   40838:	8b 45 c8             	mov    -0x38(%rbp),%eax
   4083b:	48 98                	cltq   
   4083d:	83 e0 03             	and    $0x3,%eax
   40840:	48 83 f8 03          	cmp    $0x3,%rax
   40844:	75 3e                	jne    40884 <syscall_mapping+0xc6>
	return;
    // find the actual mapping now
    vamapping ptr_lookup = virtual_memory_lookup(p->p_pagetable, ptr);
   40846:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   4084a:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   40851:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
   40855:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40859:	48 89 ce             	mov    %rcx,%rsi
   4085c:	48 89 c7             	mov    %rax,%rdi
   4085f:	e8 6c 29 00 00       	callq  431d0 <virtual_memory_lookup>
    memcpy((void *)map.pa, &ptr_lookup, sizeof(vamapping));
   40864:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40868:	48 89 c1             	mov    %rax,%rcx
   4086b:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
   4086f:	ba 18 00 00 00       	mov    $0x18,%edx
   40874:	48 89 c6             	mov    %rax,%rsi
   40877:	48 89 cf             	mov    %rcx,%rdi
   4087a:	e8 ef 2d 00 00       	callq  4366e <memcpy>
   4087f:	eb 04                	jmp    40885 <syscall_mapping+0xc7>
	return;
   40881:	90                   	nop
   40882:	eb 01                	jmp    40885 <syscall_mapping+0xc7>
	return;
   40884:	90                   	nop
}
   40885:	c9                   	leaveq 
   40886:	c3                   	retq   

0000000000040887 <syscall_mem_tog>:

void syscall_mem_tog(proc* process){
   40887:	55                   	push   %rbp
   40888:	48 89 e5             	mov    %rsp,%rbp
   4088b:	48 83 ec 18          	sub    $0x18,%rsp
   4088f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

    pid_t p = process->p_registers.reg_rdi;
   40893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40897:	48 8b 40 38          	mov    0x38(%rax),%rax
   4089b:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if(p == 0) {
   4089e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   408a2:	75 14                	jne    408b8 <syscall_mem_tog+0x31>
        disp_global = !disp_global;
   408a4:	0f b6 05 55 47 00 00 	movzbl 0x4755(%rip),%eax        # 45000 <disp_global>
   408ab:	84 c0                	test   %al,%al
   408ad:	0f 94 c0             	sete   %al
   408b0:	88 05 4a 47 00 00    	mov    %al,0x474a(%rip)        # 45000 <disp_global>
   408b6:	eb 36                	jmp    408ee <syscall_mem_tog+0x67>
    }
    else {
        if(p < 0 || p > NPROC || p != process->p_pid)
   408b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   408bc:	78 2f                	js     408ed <syscall_mem_tog+0x66>
   408be:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
   408c2:	7f 29                	jg     408ed <syscall_mem_tog+0x66>
   408c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   408c8:	8b 00                	mov    (%rax),%eax
   408ca:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   408cd:	75 1e                	jne    408ed <syscall_mem_tog+0x66>
            return;
        process->display_status = !(process->display_status);
   408cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   408d3:	0f b6 80 d8 00 00 00 	movzbl 0xd8(%rax),%eax
   408da:	84 c0                	test   %al,%al
   408dc:	0f 94 c0             	sete   %al
   408df:	89 c2                	mov    %eax,%edx
   408e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   408e5:	88 90 d8 00 00 00    	mov    %dl,0xd8(%rax)
   408eb:	eb 01                	jmp    408ee <syscall_mem_tog+0x67>
            return;
   408ed:	90                   	nop
    }
}
   408ee:	c9                   	leaveq 
   408ef:	c3                   	retq   

00000000000408f0 <exception>:
//    k-exception.S). That code saves more registers on the kernel's stack,
//    then calls exception().
//
//    Note that hardware interrupts are disabled whenever the kernel is running.

void exception(x86_64_registers* reg) {
   408f0:	55                   	push   %rbp
   408f1:	48 89 e5             	mov    %rsp,%rbp
   408f4:	48 81 ec 70 01 00 00 	sub    $0x170,%rsp
   408fb:	48 89 bd 98 fe ff ff 	mov    %rdi,-0x168(%rbp)
    // Copy the saved registers into the `current` process descriptor
    // and always use the kernel's page table.
    current->p_registers = *reg;
   40902:	48 8b 05 f7 d6 00 00 	mov    0xd6f7(%rip),%rax        # 4e000 <current>
   40909:	48 8b 95 98 fe ff ff 	mov    -0x168(%rbp),%rdx
   40910:	48 83 c0 08          	add    $0x8,%rax
   40914:	48 89 d6             	mov    %rdx,%rsi
   40917:	ba 18 00 00 00       	mov    $0x18,%edx
   4091c:	48 89 c7             	mov    %rax,%rdi
   4091f:	48 89 d1             	mov    %rdx,%rcx
   40922:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    set_pagetable(kernel_pagetable);
   40925:	48 8b 05 d4 06 01 00 	mov    0x106d4(%rip),%rax        # 51000 <kernel_pagetable>
   4092c:	48 89 c7             	mov    %rax,%rdi
   4092f:	e8 af 23 00 00       	callq  42ce3 <set_pagetable>
    // Events logged this way are stored in the host's `log.txt` file.
    /*log_printf("proc %d: exception %d\n", current->p_pid, reg->reg_intno);*/

    // Show the current cursor location and memory state
    // (unless this is a kernel fault).
    console_show_cursor(cursorpos);
   40934:	8b 05 c2 86 07 00    	mov    0x786c2(%rip),%eax        # b8ffc <cursorpos>
   4093a:	89 c7                	mov    %eax,%edi
   4093c:	e8 d6 1a 00 00       	callq  42417 <console_show_cursor>
    if ((reg->reg_intno != INT_PAGEFAULT && reg->reg_intno != INT_GPF) // no error due to pagefault or general fault
   40941:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40948:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   4094f:	48 83 f8 0e          	cmp    $0xe,%rax
   40953:	74 14                	je     40969 <exception+0x79>
   40955:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   4095c:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   40963:	48 83 f8 0d          	cmp    $0xd,%rax
   40967:	75 16                	jne    4097f <exception+0x8f>
            || (reg->reg_err & PFERR_USER)) // pagefault error in user mode 
   40969:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40970:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40977:	83 e0 04             	and    $0x4,%eax
   4097a:	48 85 c0             	test   %rax,%rax
   4097d:	74 1a                	je     40999 <exception+0xa9>
    {
        check_virtual_memory();
   4097f:	e8 96 0c 00 00       	callq  4161a <check_virtual_memory>
        if(disp_global){
   40984:	0f b6 05 75 46 00 00 	movzbl 0x4675(%rip),%eax        # 45000 <disp_global>
   4098b:	84 c0                	test   %al,%al
   4098d:	74 0a                	je     40999 <exception+0xa9>
            memshow_physical();
   4098f:	e8 fe 0d 00 00       	callq  41792 <memshow_physical>
            memshow_virtual_animate();
   40994:	e8 24 11 00 00       	callq  41abd <memshow_virtual_animate>
        }
    }

    // If Control-C was typed, exit the virtual machine.
    check_keyboard();
   40999:	e8 56 1f 00 00       	callq  428f4 <check_keyboard>


    // Actually handle the exception.
    switch (reg->reg_intno) {
   4099e:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   409a5:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   409ac:	48 83 e8 0e          	sub    $0xe,%rax
   409b0:	48 83 f8 2a          	cmp    $0x2a,%rax
   409b4:	0f 87 c2 07 00 00    	ja     4117c <exception+0x88c>
   409ba:	48 8b 04 c5 b8 40 04 	mov    0x440b8(,%rax,8),%rax
   409c1:	00 
   409c2:	ff e0                	jmpq   *%rax

    case INT_SYS_PANIC:
	    // rdi stores pointer for msg string
	    {
		char msg[160];
		uintptr_t addr = current->p_registers.reg_rdi;
   409c4:	48 8b 05 35 d6 00 00 	mov    0xd635(%rip),%rax        # 4e000 <current>
   409cb:	48 8b 40 38          	mov    0x38(%rax),%rax
   409cf:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
		if((void *)addr == NULL)
   409d3:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
   409d8:	75 0f                	jne    409e9 <exception+0xf9>
		    panic(NULL);
   409da:	bf 00 00 00 00       	mov    $0x0,%edi
   409df:	b8 00 00 00 00       	mov    $0x0,%eax
   409e4:	e8 4c 20 00 00       	callq  42a35 <panic>
		vamapping map = virtual_memory_lookup(current->p_pagetable, addr);
   409e9:	48 8b 05 10 d6 00 00 	mov    0xd610(%rip),%rax        # 4e000 <current>
   409f0:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   409f7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
   409fe:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
   40a02:	48 89 ce             	mov    %rcx,%rsi
   40a05:	48 89 c7             	mov    %rax,%rdi
   40a08:	e8 c3 27 00 00       	callq  431d0 <virtual_memory_lookup>
		memcpy(msg, (void *)map.pa, 160);
   40a0d:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   40a14:	48 89 c1             	mov    %rax,%rcx
   40a17:	48 8d 85 a0 fe ff ff 	lea    -0x160(%rbp),%rax
   40a1e:	ba a0 00 00 00       	mov    $0xa0,%edx
   40a23:	48 89 ce             	mov    %rcx,%rsi
   40a26:	48 89 c7             	mov    %rax,%rdi
   40a29:	e8 40 2c 00 00       	callq  4366e <memcpy>
		panic(msg);
   40a2e:	48 8d 85 a0 fe ff ff 	lea    -0x160(%rbp),%rax
   40a35:	48 89 c7             	mov    %rax,%rdi
   40a38:	b8 00 00 00 00       	mov    $0x0,%eax
   40a3d:	e8 f3 1f 00 00       	callq  42a35 <panic>
	    }
	    panic(NULL);
	    break;                  // will not be reached

    case INT_SYS_GETPID:
        current->p_registers.reg_rax = current->p_pid;
   40a42:	48 8b 05 b7 d5 00 00 	mov    0xd5b7(%rip),%rax        # 4e000 <current>
   40a49:	8b 10                	mov    (%rax),%edx
   40a4b:	48 8b 05 ae d5 00 00 	mov    0xd5ae(%rip),%rax        # 4e000 <current>
   40a52:	48 63 d2             	movslq %edx,%rdx
   40a55:	48 89 50 08          	mov    %rdx,0x8(%rax)
        break;
   40a59:	e9 2e 07 00 00       	jmpq   4118c <exception+0x89c>

    case INT_SYS_YIELD:
        schedule();
   40a5e:	e8 51 07 00 00       	callq  411b4 <schedule>
        break;                  /* will not be reached */
   40a63:	e9 24 07 00 00       	jmpq   4118c <exception+0x89c>

    case INT_SYS_PAGE_ALLOC: {
        uintptr_t addr = current->p_registers.reg_rdi;
   40a68:	48 8b 05 91 d5 00 00 	mov    0xd591(%rip),%rax        # 4e000 <current>
   40a6f:	48 8b 40 38          	mov    0x38(%rax),%rax
   40a73:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
        current->p_registers.reg_rax = sys_page_alloc_find_free(current->p_pagetable, current->p_pid, addr);
   40a77:	48 8b 05 82 d5 00 00 	mov    0xd582(%rip),%rax        # 4e000 <current>
   40a7e:	8b 08                	mov    (%rax),%ecx
   40a80:	48 8b 05 79 d5 00 00 	mov    0xd579(%rip),%rax        # 4e000 <current>
   40a87:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   40a8e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
   40a92:	89 ce                	mov    %ecx,%esi
   40a94:	48 89 c7             	mov    %rax,%rdi
   40a97:	e8 01 fc ff ff       	callq  4069d <sys_page_alloc_find_free>
   40a9c:	89 c2                	mov    %eax,%edx
   40a9e:	48 8b 05 5b d5 00 00 	mov    0xd55b(%rip),%rax        # 4e000 <current>
   40aa5:	48 63 d2             	movslq %edx,%rdx
   40aa8:	48 89 50 08          	mov    %rdx,0x8(%rax)
        break;
   40aac:	e9 db 06 00 00       	jmpq   4118c <exception+0x89c>
    }

    case INT_SYS_MAPPING:
    {
	    syscall_mapping(current);
   40ab1:	48 8b 05 48 d5 00 00 	mov    0xd548(%rip),%rax        # 4e000 <current>
   40ab8:	48 89 c7             	mov    %rax,%rdi
   40abb:	e8 fe fc ff ff       	callq  407be <syscall_mapping>
            break;
   40ac0:	e9 c7 06 00 00       	jmpq   4118c <exception+0x89c>
    }

    case INT_SYS_MEM_TOG:
	{
	    syscall_mem_tog(current);
   40ac5:	48 8b 05 34 d5 00 00 	mov    0xd534(%rip),%rax        # 4e000 <current>
   40acc:	48 89 c7             	mov    %rax,%rdi
   40acf:	e8 b3 fd ff ff       	callq  40887 <syscall_mem_tog>
	    break;
   40ad4:	e9 b3 06 00 00       	jmpq   4118c <exception+0x89c>
	}

    case INT_TIMER:
        ++ticks;
   40ad9:	8b 05 41 e3 00 00    	mov    0xe341(%rip),%eax        # 4ee20 <ticks>
   40adf:	83 c0 01             	add    $0x1,%eax
   40ae2:	89 05 38 e3 00 00    	mov    %eax,0xe338(%rip)        # 4ee20 <ticks>
        schedule();
   40ae8:	e8 c7 06 00 00       	callq  411b4 <schedule>
        break;                  /* will not be reached */
   40aed:	e9 9a 06 00 00       	jmpq   4118c <exception+0x89c>
    return val;
}

static inline uintptr_t rcr2(void) {
    uintptr_t val;
    asm volatile("movq %%cr2,%0" : "=r" (val));
   40af2:	0f 20 d0             	mov    %cr2,%rax
   40af5:	48 89 45 88          	mov    %rax,-0x78(%rbp)
    return val;
   40af9:	48 8b 45 88          	mov    -0x78(%rbp),%rax

    case INT_PAGEFAULT: {
        // Analyze faulting address and access type.
        uintptr_t addr = rcr2();
   40afd:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
        const char* operation = reg->reg_err & PFERR_WRITE
   40b01:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40b08:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40b0f:	83 e0 02             	and    $0x2,%eax
                ? "write" : "read";
   40b12:	48 85 c0             	test   %rax,%rax
   40b15:	74 07                	je     40b1e <exception+0x22e>
   40b17:	b8 29 40 04 00       	mov    $0x44029,%eax
   40b1c:	eb 05                	jmp    40b23 <exception+0x233>
   40b1e:	b8 2f 40 04 00       	mov    $0x4402f,%eax
        const char* operation = reg->reg_err & PFERR_WRITE
   40b23:	48 89 45 98          	mov    %rax,-0x68(%rbp)
        const char* problem = reg->reg_err & PFERR_PRESENT
   40b27:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40b2e:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40b35:	83 e0 01             	and    $0x1,%eax
                ? "protection problem" : "missing page";
   40b38:	48 85 c0             	test   %rax,%rax
   40b3b:	74 07                	je     40b44 <exception+0x254>
   40b3d:	b8 34 40 04 00       	mov    $0x44034,%eax
   40b42:	eb 05                	jmp    40b49 <exception+0x259>
   40b44:	b8 47 40 04 00       	mov    $0x44047,%eax
        const char* problem = reg->reg_err & PFERR_PRESENT
   40b49:	48 89 45 90          	mov    %rax,-0x70(%rbp)

        if (!(reg->reg_err & PFERR_USER)) {
   40b4d:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40b54:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40b5b:	83 e0 04             	and    $0x4,%eax
   40b5e:	48 85 c0             	test   %rax,%rax
   40b61:	75 2f                	jne    40b92 <exception+0x2a2>
            panic("Kernel page fault for %p (%s %s, rip=%p)!\n",
   40b63:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40b6a:	48 8b b0 98 00 00 00 	mov    0x98(%rax),%rsi
   40b71:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   40b75:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
   40b79:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   40b7d:	49 89 f0             	mov    %rsi,%r8
   40b80:	48 89 c6             	mov    %rax,%rsi
   40b83:	bf 58 40 04 00       	mov    $0x44058,%edi
   40b88:	b8 00 00 00 00       	mov    $0x0,%eax
   40b8d:	e8 a3 1e 00 00       	callq  42a35 <panic>
                  addr, operation, problem, reg->reg_rip);
        }
        console_printf(CPOS(24, 0), 0x0C00,
   40b92:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40b99:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
                       "Process %d page fault for %p (%s %s, rip=%p)!\n",
                       current->p_pid, addr, operation, problem, reg->reg_rip);
   40ba0:	48 8b 05 59 d4 00 00 	mov    0xd459(%rip),%rax        # 4e000 <current>
        console_printf(CPOS(24, 0), 0x0C00,
   40ba7:	8b 00                	mov    (%rax),%eax
   40ba9:	48 8b 75 98          	mov    -0x68(%rbp),%rsi
   40bad:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
   40bb1:	52                   	push   %rdx
   40bb2:	ff 75 90             	pushq  -0x70(%rbp)
   40bb5:	49 89 f1             	mov    %rsi,%r9
   40bb8:	49 89 c8             	mov    %rcx,%r8
   40bbb:	89 c1                	mov    %eax,%ecx
   40bbd:	ba 88 40 04 00       	mov    $0x44088,%edx
   40bc2:	be 00 0c 00 00       	mov    $0xc00,%esi
   40bc7:	bf 80 07 00 00       	mov    $0x780,%edi
   40bcc:	b8 00 00 00 00       	mov    $0x0,%eax
   40bd1:	e8 36 33 00 00       	callq  43f0c <console_printf>
   40bd6:	48 83 c4 10          	add    $0x10,%rsp
        current->p_state = P_BROKEN;
   40bda:	48 8b 05 1f d4 00 00 	mov    0xd41f(%rip),%rax        # 4e000 <current>
   40be1:	c7 80 c8 00 00 00 03 	movl   $0x3,0xc8(%rax)
   40be8:	00 00 00 
        break;
   40beb:	e9 9c 05 00 00       	jmpq   4118c <exception+0x89c>
    }

    case INT_SYS_FORK: {
        int free_pid = 1;
   40bf0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
        while(free_pid < NPROC){
   40bf7:	e9 ad 02 00 00       	jmpq   40ea9 <exception+0x5b9>
            if(processes[free_pid].p_state == P_FREE){
   40bfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40bff:	48 63 d0             	movslq %eax,%rdx
   40c02:	48 89 d0             	mov    %rdx,%rax
   40c05:	48 c1 e0 03          	shl    $0x3,%rax
   40c09:	48 29 d0             	sub    %rdx,%rax
   40c0c:	48 c1 e0 05          	shl    $0x5,%rax
   40c10:	48 05 e8 e0 04 00    	add    $0x4e0e8,%rax
   40c16:	8b 00                	mov    (%rax),%eax
   40c18:	85 c0                	test   %eax,%eax
   40c1a:	0f 85 70 02 00 00    	jne    40e90 <exception+0x5a0>
                processes[free_pid].p_pid = free_pid;
   40c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40c23:	48 63 d0             	movslq %eax,%rdx
   40c26:	48 89 d0             	mov    %rdx,%rax
   40c29:	48 c1 e0 03          	shl    $0x3,%rax
   40c2d:	48 29 d0             	sub    %rdx,%rax
   40c30:	48 c1 e0 05          	shl    $0x5,%rax
   40c34:	48 8d 90 20 e0 04 00 	lea    0x4e020(%rax),%rdx
   40c3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40c3e:	89 02                	mov    %eax,(%rdx)
                processes[free_pid].p_state = P_RUNNABLE;
   40c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40c43:	48 63 d0             	movslq %eax,%rdx
   40c46:	48 89 d0             	mov    %rdx,%rax
   40c49:	48 c1 e0 03          	shl    $0x3,%rax
   40c4d:	48 29 d0             	sub    %rdx,%rax
   40c50:	48 c1 e0 05          	shl    $0x5,%rax
   40c54:	48 05 e8 e0 04 00    	add    $0x4e0e8,%rax
   40c5a:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
                processes[free_pid].p_pagetable = duplicate_pagetable(current->p_pagetable, free_pid);
   40c60:	48 8b 05 99 d3 00 00 	mov    0xd399(%rip),%rax        # 4e000 <current>
   40c67:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   40c6e:	8b 55 fc             	mov    -0x4(%rbp),%edx
   40c71:	89 d6                	mov    %edx,%esi
   40c73:	48 89 c7             	mov    %rax,%rdi
   40c76:	e8 0e f8 ff ff       	callq  40489 <duplicate_pagetable>
   40c7b:	48 89 c2             	mov    %rax,%rdx
   40c7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40c81:	48 63 c8             	movslq %eax,%rcx
   40c84:	48 89 c8             	mov    %rcx,%rax
   40c87:	48 c1 e0 03          	shl    $0x3,%rax
   40c8b:	48 29 c8             	sub    %rcx,%rax
   40c8e:	48 c1 e0 05          	shl    $0x5,%rax
   40c92:	48 05 f0 e0 04 00    	add    $0x4e0f0,%rax
   40c98:	48 89 10             	mov    %rdx,(%rax)
                if(processes[free_pid].p_pagetable){
   40c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40c9e:	48 63 d0             	movslq %eax,%rdx
   40ca1:	48 89 d0             	mov    %rdx,%rax
   40ca4:	48 c1 e0 03          	shl    $0x3,%rax
   40ca8:	48 29 d0             	sub    %rdx,%rax
   40cab:	48 c1 e0 05          	shl    $0x5,%rax
   40caf:	48 05 f0 e0 04 00    	add    $0x4e0f0,%rax
   40cb5:	48 8b 00             	mov    (%rax),%rax
   40cb8:	48 85 c0             	test   %rax,%rax
   40cbb:	0f 84 9b 01 00 00    	je     40e5c <exception+0x56c>
                    vamapping map;
                    for(uintptr_t v = PROC_START_ADDR; v < MEMSIZE_VIRTUAL; v += PAGESIZE){
   40cc1:	48 c7 45 f0 00 00 10 	movq   $0x100000,-0x10(%rbp)
   40cc8:	00 
   40cc9:	e9 11 01 00 00       	jmpq   40ddf <exception+0x4ef>
                        map = virtual_memory_lookup(current->p_pagetable, v);
   40cce:	48 8b 05 2b d3 00 00 	mov    0xd32b(%rip),%rax        # 4e000 <current>
   40cd5:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   40cdc:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
   40ce3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40ce7:	48 89 ce             	mov    %rcx,%rsi
   40cea:	48 89 c7             	mov    %rax,%rdi
   40ced:	e8 de 24 00 00       	callq  431d0 <virtual_memory_lookup>
                        if(map.pa != CONSOLE_ADDR && (map.perm & PTE_W)){
   40cf2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   40cf9:	ba 00 80 0b 00       	mov    $0xb8000,%edx
   40cfe:	48 39 d0             	cmp    %rdx,%rax
   40d01:	74 79                	je     40d7c <exception+0x48c>
   40d03:	8b 85 68 ff ff ff    	mov    -0x98(%rbp),%eax
   40d09:	48 98                	cltq   
   40d0b:	83 e0 02             	and    $0x2,%eax
   40d0e:	48 85 c0             	test   %rax,%rax
   40d11:	74 69                	je     40d7c <exception+0x48c>
                            void *page = alloc_page_process(free_pid);
   40d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40d16:	89 c7                	mov    %eax,%edi
   40d18:	e8 16 f9 ff ff       	callq  40633 <alloc_page_process>
   40d1d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
                            memcpy(page, (void *)map.pa, PAGESIZE);
   40d21:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   40d28:	48 89 c1             	mov    %rax,%rcx
   40d2b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40d2f:	ba 00 10 00 00       	mov    $0x1000,%edx
   40d34:	48 89 ce             	mov    %rcx,%rsi
   40d37:	48 89 c7             	mov    %rax,%rdi
   40d3a:	e8 2f 29 00 00       	callq  4366e <memcpy>
                            virtual_memory_map(processes[free_pid].p_pagetable, v, (uintptr_t)page, PAGESIZE, map.perm);
   40d3f:	8b bd 68 ff ff ff    	mov    -0x98(%rbp),%edi
   40d45:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   40d49:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40d4c:	48 63 c8             	movslq %eax,%rcx
   40d4f:	48 89 c8             	mov    %rcx,%rax
   40d52:	48 c1 e0 03          	shl    $0x3,%rax
   40d56:	48 29 c8             	sub    %rcx,%rax
   40d59:	48 c1 e0 05          	shl    $0x5,%rax
   40d5d:	48 05 f0 e0 04 00    	add    $0x4e0f0,%rax
   40d63:	48 8b 00             	mov    (%rax),%rax
   40d66:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   40d6a:	41 89 f8             	mov    %edi,%r8d
   40d6d:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40d72:	48 89 c7             	mov    %rax,%rdi
   40d75:	e8 9a 20 00 00       	callq  42e14 <virtual_memory_map>
                        if(map.pa != CONSOLE_ADDR && (map.perm & PTE_W)){
   40d7a:	eb 5b                	jmp    40dd7 <exception+0x4e7>
                        }    
                        else{
                            
                            virtual_memory_map(processes[free_pid].p_pagetable, v, map.pa, PAGESIZE, map.perm);    
   40d7c:	8b bd 68 ff ff ff    	mov    -0x98(%rbp),%edi
   40d82:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   40d89:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40d8c:	48 63 c8             	movslq %eax,%rcx
   40d8f:	48 89 c8             	mov    %rcx,%rax
   40d92:	48 c1 e0 03          	shl    $0x3,%rax
   40d96:	48 29 c8             	sub    %rcx,%rax
   40d99:	48 c1 e0 05          	shl    $0x5,%rax
   40d9d:	48 05 f0 e0 04 00    	add    $0x4e0f0,%rax
   40da3:	48 8b 00             	mov    (%rax),%rax
   40da6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   40daa:	41 89 f8             	mov    %edi,%r8d
   40dad:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40db2:	48 89 c7             	mov    %rax,%rdi
   40db5:	e8 5a 20 00 00       	callq  42e14 <virtual_memory_map>
                        ++pageinfo[map.pn].refcount;
   40dba:	8b 85 58 ff ff ff    	mov    -0xa8(%rbp),%eax
   40dc0:	48 63 d0             	movslq %eax,%rdx
   40dc3:	0f b6 94 12 41 ee 04 	movzbl 0x4ee41(%rdx,%rdx,1),%edx
   40dca:	00 
   40dcb:	83 c2 01             	add    $0x1,%edx
   40dce:	48 98                	cltq   
   40dd0:	88 94 00 41 ee 04 00 	mov    %dl,0x4ee41(%rax,%rax,1)
                    for(uintptr_t v = PROC_START_ADDR; v < MEMSIZE_VIRTUAL; v += PAGESIZE){
   40dd7:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
   40dde:	00 
   40ddf:	48 81 7d f0 ff ff 2f 	cmpq   $0x2fffff,-0x10(%rbp)
   40de6:	00 
   40de7:	0f 86 e1 fe ff ff    	jbe    40cce <exception+0x3de>
                        }
                    }
                    processes[free_pid].p_registers = current->p_registers;
   40ded:	48 8b 0d 0c d2 00 00 	mov    0xd20c(%rip),%rcx        # 4e000 <current>
   40df4:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40df7:	48 63 d0             	movslq %eax,%rdx
   40dfa:	48 89 d0             	mov    %rdx,%rax
   40dfd:	48 c1 e0 03          	shl    $0x3,%rax
   40e01:	48 29 d0             	sub    %rdx,%rax
   40e04:	48 c1 e0 05          	shl    $0x5,%rax
   40e08:	48 05 20 e0 04 00    	add    $0x4e020,%rax
   40e0e:	48 83 c0 08          	add    $0x8,%rax
   40e12:	48 8d 51 08          	lea    0x8(%rcx),%rdx
   40e16:	b9 18 00 00 00       	mov    $0x18,%ecx
   40e1b:	48 89 c7             	mov    %rax,%rdi
   40e1e:	48 89 d6             	mov    %rdx,%rsi
   40e21:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
                    processes[free_pid].p_registers.reg_rax = 0;
   40e24:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40e27:	48 63 d0             	movslq %eax,%rdx
   40e2a:	48 89 d0             	mov    %rdx,%rax
   40e2d:	48 c1 e0 03          	shl    $0x3,%rax
   40e31:	48 29 d0             	sub    %rdx,%rax
   40e34:	48 c1 e0 05          	shl    $0x5,%rax
   40e38:	48 05 28 e0 04 00    	add    $0x4e028,%rax
   40e3e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
                    current->p_registers.reg_rax = free_pid;
   40e45:	48 8b 05 b4 d1 00 00 	mov    0xd1b4(%rip),%rax        # 4e000 <current>
   40e4c:	8b 55 fc             	mov    -0x4(%rbp),%edx
   40e4f:	48 63 d2             	movslq %edx,%rdx
   40e52:	48 89 50 08          	mov    %rdx,0x8(%rax)
                    break;
   40e56:	90                   	nop
            }
            else if(free_pid + 1 == NPROC)
                current->p_registers.reg_rax = -1;
            free_pid++;
        }
        break;
   40e57:	e9 30 03 00 00       	jmpq   4118c <exception+0x89c>
                    processes[free_pid].p_state = P_FREE;
   40e5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40e5f:	48 63 d0             	movslq %eax,%rdx
   40e62:	48 89 d0             	mov    %rdx,%rax
   40e65:	48 c1 e0 03          	shl    $0x3,%rax
   40e69:	48 29 d0             	sub    %rdx,%rax
   40e6c:	48 c1 e0 05          	shl    $0x5,%rax
   40e70:	48 05 e8 e0 04 00    	add    $0x4e0e8,%rax
   40e76:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                    current->p_registers.reg_rax = -1;
   40e7c:	48 8b 05 7d d1 00 00 	mov    0xd17d(%rip),%rax        # 4e000 <current>
   40e83:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40e8a:	ff 
                    return;
   40e8b:	e9 22 03 00 00       	jmpq   411b2 <exception+0x8c2>
            else if(free_pid + 1 == NPROC)
   40e90:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   40e94:	75 0f                	jne    40ea5 <exception+0x5b5>
                current->p_registers.reg_rax = -1;
   40e96:	48 8b 05 63 d1 00 00 	mov    0xd163(%rip),%rax        # 4e000 <current>
   40e9d:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40ea4:	ff 
            free_pid++;
   40ea5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
        while(free_pid < NPROC){
   40ea9:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   40ead:	0f 8e 49 fd ff ff    	jle    40bfc <exception+0x30c>
        break;
   40eb3:	e9 d4 02 00 00       	jmpq   4118c <exception+0x89c>
    }
    
    case INT_SYS_EXIT: {
        x86_64_pagetable *L1 = current->p_pagetable;
   40eb8:	48 8b 05 41 d1 00 00 	mov    0xd141(%rip),%rax        # 4e000 <current>
   40ebf:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   40ec6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
        x86_64_pagetable *L2 = (x86_64_pagetable *) PTE_ADDR(L1->entry[0]);
   40eca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40ece:	48 8b 00             	mov    (%rax),%rax
   40ed1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   40ed7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
        x86_64_pagetable *L3 = (x86_64_pagetable *) PTE_ADDR(L2->entry[0]);
   40edb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40edf:	48 8b 00             	mov    (%rax),%rax
   40ee2:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   40ee8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        x86_64_pagetable *L4_1 = (x86_64_pagetable *) PTE_ADDR(L3->entry[0]);
   40eec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40ef0:	48 8b 00             	mov    (%rax),%rax
   40ef3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   40ef9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        x86_64_pagetable *L4_2 = (x86_64_pagetable *) PTE_ADDR(L3->entry[1]);
   40efd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40f01:	48 8b 40 08          	mov    0x8(%rax),%rax
   40f05:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   40f0b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
        pageinfo[PAGENUMBER(L1)].owner = P_FREE;
   40f0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40f13:	48 c1 e8 0c          	shr    $0xc,%rax
   40f17:	48 98                	cltq   
   40f19:	c6 84 00 40 ee 04 00 	movb   $0x0,0x4ee40(%rax,%rax,1)
   40f20:	00 
        pageinfo[PAGENUMBER(L2)].owner = P_FREE;
   40f21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40f25:	48 c1 e8 0c          	shr    $0xc,%rax
   40f29:	48 98                	cltq   
   40f2b:	c6 84 00 40 ee 04 00 	movb   $0x0,0x4ee40(%rax,%rax,1)
   40f32:	00 
        pageinfo[PAGENUMBER(L3)].owner = P_FREE;
   40f33:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40f37:	48 c1 e8 0c          	shr    $0xc,%rax
   40f3b:	48 98                	cltq   
   40f3d:	c6 84 00 40 ee 04 00 	movb   $0x0,0x4ee40(%rax,%rax,1)
   40f44:	00 
        pageinfo[PAGENUMBER(L4_1)].owner = P_FREE;
   40f45:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40f49:	48 c1 e8 0c          	shr    $0xc,%rax
   40f4d:	48 98                	cltq   
   40f4f:	c6 84 00 40 ee 04 00 	movb   $0x0,0x4ee40(%rax,%rax,1)
   40f56:	00 
        pageinfo[PAGENUMBER(L4_2)].owner = P_FREE;
   40f57:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   40f5b:	48 c1 e8 0c          	shr    $0xc,%rax
   40f5f:	48 98                	cltq   
   40f61:	c6 84 00 40 ee 04 00 	movb   $0x0,0x4ee40(%rax,%rax,1)
   40f68:	00 
        pageinfo[PAGENUMBER(L1)].refcount = 0;
   40f69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40f6d:	48 c1 e8 0c          	shr    $0xc,%rax
   40f71:	48 98                	cltq   
   40f73:	c6 84 00 41 ee 04 00 	movb   $0x0,0x4ee41(%rax,%rax,1)
   40f7a:	00 
        pageinfo[PAGENUMBER(L2)].refcount = 0;
   40f7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40f7f:	48 c1 e8 0c          	shr    $0xc,%rax
   40f83:	48 98                	cltq   
   40f85:	c6 84 00 41 ee 04 00 	movb   $0x0,0x4ee41(%rax,%rax,1)
   40f8c:	00 
        pageinfo[PAGENUMBER(L3)].refcount = 0;
   40f8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40f91:	48 c1 e8 0c          	shr    $0xc,%rax
   40f95:	48 98                	cltq   
   40f97:	c6 84 00 41 ee 04 00 	movb   $0x0,0x4ee41(%rax,%rax,1)
   40f9e:	00 
        pageinfo[PAGENUMBER(L4_1)].refcount = 0;
   40f9f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40fa3:	48 c1 e8 0c          	shr    $0xc,%rax
   40fa7:	48 98                	cltq   
   40fa9:	c6 84 00 41 ee 04 00 	movb   $0x0,0x4ee41(%rax,%rax,1)
   40fb0:	00 
        pageinfo[PAGENUMBER(L4_2)].refcount = 0;
   40fb1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   40fb5:	48 c1 e8 0c          	shr    $0xc,%rax
   40fb9:	48 98                	cltq   
   40fbb:	c6 84 00 41 ee 04 00 	movb   $0x0,0x4ee41(%rax,%rax,1)
   40fc2:	00 
        current->p_state = P_FREE;
   40fc3:	48 8b 05 36 d0 00 00 	mov    0xd036(%rip),%rax        # 4e000 <current>
   40fca:	c7 80 c8 00 00 00 00 	movl   $0x0,0xc8(%rax)
   40fd1:	00 00 00 
        for (uintptr_t v = PROC_START_ADDR; v < MEMSIZE_VIRTUAL; v += PAGESIZE){
   40fd4:	48 c7 45 e8 00 00 10 	movq   $0x100000,-0x18(%rbp)
   40fdb:	00 
   40fdc:	e9 8b 01 00 00       	jmpq   4116c <exception+0x87c>
            if (current->p_pagetable){
   40fe1:	48 8b 05 18 d0 00 00 	mov    0xd018(%rip),%rax        # 4e000 <current>
   40fe8:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   40fef:	48 85 c0             	test   %rax,%rax
   40ff2:	0f 84 6c 01 00 00    	je     41164 <exception+0x874>
                vamapping map = virtual_memory_lookup(current->p_pagetable, v);
   40ff8:	48 8b 05 01 d0 00 00 	mov    0xd001(%rip),%rax        # 4e000 <current>
   40fff:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   41006:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
   4100d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   41011:	48 89 ce             	mov    %rcx,%rsi
   41014:	48 89 c7             	mov    %rax,%rdi
   41017:	e8 b4 21 00 00       	callq  431d0 <virtual_memory_lookup>
                if (!(map.perm & PTE_W) && (map.pn > 0) && pageinfo[map.pn].refcount){
   4101c:	8b 85 50 ff ff ff    	mov    -0xb0(%rbp),%eax
   41022:	48 98                	cltq   
   41024:	83 e0 02             	and    $0x2,%eax
   41027:	48 85 c0             	test   %rax,%rax
   4102a:	75 64                	jne    41090 <exception+0x7a0>
   4102c:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   41032:	85 c0                	test   %eax,%eax
   41034:	7e 5a                	jle    41090 <exception+0x7a0>
   41036:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   4103c:	48 98                	cltq   
   4103e:	0f b6 84 00 41 ee 04 	movzbl 0x4ee41(%rax,%rax,1),%eax
   41045:	00 
   41046:	84 c0                	test   %al,%al
   41048:	74 46                	je     41090 <exception+0x7a0>
                    if (pageinfo[map.pn].refcount == 0)
   4104a:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   41050:	48 98                	cltq   
   41052:	0f b6 84 00 41 ee 04 	movzbl 0x4ee41(%rax,%rax,1),%eax
   41059:	00 
   4105a:	84 c0                	test   %al,%al
   4105c:	75 10                	jne    4106e <exception+0x77e>
                        pageinfo[map.pn].owner = P_FREE;
   4105e:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   41064:	48 98                	cltq   
   41066:	c6 84 00 40 ee 04 00 	movb   $0x0,0x4ee40(%rax,%rax,1)
   4106d:	00 
                --pageinfo[map.pn].refcount;
   4106e:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   41074:	48 63 d0             	movslq %eax,%rdx
   41077:	0f b6 94 12 41 ee 04 	movzbl 0x4ee41(%rdx,%rdx,1),%edx
   4107e:	00 
   4107f:	83 ea 01             	sub    $0x1,%edx
   41082:	48 98                	cltq   
   41084:	88 94 00 41 ee 04 00 	mov    %dl,0x4ee41(%rax,%rax,1)
   4108b:	e9 d4 00 00 00       	jmpq   41164 <exception+0x874>
                } 
                else if ((map.pn > 0) && (map.perm & PTE_W) && (pageinfo[map.pn].owner == current->p_pid) && pageinfo[map.pn].refcount && (map.pn != PAGENUMBER(L1)) 
   41090:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   41096:	85 c0                	test   %eax,%eax
   41098:	0f 8e c6 00 00 00    	jle    41164 <exception+0x874>
   4109e:	8b 85 50 ff ff ff    	mov    -0xb0(%rbp),%eax
   410a4:	48 98                	cltq   
   410a6:	83 e0 02             	and    $0x2,%eax
   410a9:	48 85 c0             	test   %rax,%rax
   410ac:	0f 84 b2 00 00 00    	je     41164 <exception+0x874>
   410b2:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   410b8:	48 98                	cltq   
   410ba:	0f b6 84 00 40 ee 04 	movzbl 0x4ee40(%rax,%rax,1),%eax
   410c1:	00 
   410c2:	0f be d0             	movsbl %al,%edx
   410c5:	48 8b 05 34 cf 00 00 	mov    0xcf34(%rip),%rax        # 4e000 <current>
   410cc:	8b 00                	mov    (%rax),%eax
   410ce:	39 c2                	cmp    %eax,%edx
   410d0:	0f 85 8e 00 00 00    	jne    41164 <exception+0x874>
   410d6:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   410dc:	48 98                	cltq   
   410de:	0f b6 84 00 41 ee 04 	movzbl 0x4ee41(%rax,%rax,1),%eax
   410e5:	00 
   410e6:	84 c0                	test   %al,%al
   410e8:	74 7a                	je     41164 <exception+0x874>
   410ea:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   410f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   410f4:	48 c1 ea 0c          	shr    $0xc,%rdx
   410f8:	39 d0                	cmp    %edx,%eax
   410fa:	74 68                	je     41164 <exception+0x874>
                && (map.pn != PAGENUMBER(L2)) && (map.pn != PAGENUMBER(L3)) && (map.pn != PAGENUMBER(L4_1)) && (map.pn != PAGENUMBER(L4_2))){
   410fc:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   41102:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   41106:	48 c1 ea 0c          	shr    $0xc,%rdx
   4110a:	39 d0                	cmp    %edx,%eax
   4110c:	74 56                	je     41164 <exception+0x874>
   4110e:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   41114:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   41118:	48 c1 ea 0c          	shr    $0xc,%rdx
   4111c:	39 d0                	cmp    %edx,%eax
   4111e:	74 44                	je     41164 <exception+0x874>
   41120:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   41126:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   4112a:	48 c1 ea 0c          	shr    $0xc,%rdx
   4112e:	39 d0                	cmp    %edx,%eax
   41130:	74 32                	je     41164 <exception+0x874>
   41132:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   41138:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   4113c:	48 c1 ea 0c          	shr    $0xc,%rdx
   41140:	39 d0                	cmp    %edx,%eax
   41142:	74 20                	je     41164 <exception+0x874>
                    pageinfo[map.pn].owner = P_FREE;
   41144:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   4114a:	48 98                	cltq   
   4114c:	c6 84 00 40 ee 04 00 	movb   $0x0,0x4ee40(%rax,%rax,1)
   41153:	00 
                    pageinfo[map.pn].refcount = 0;
   41154:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   4115a:	48 98                	cltq   
   4115c:	c6 84 00 41 ee 04 00 	movb   $0x0,0x4ee41(%rax,%rax,1)
   41163:	00 
        for (uintptr_t v = PROC_START_ADDR; v < MEMSIZE_VIRTUAL; v += PAGESIZE){
   41164:	48 81 45 e8 00 10 00 	addq   $0x1000,-0x18(%rbp)
   4116b:	00 
   4116c:	48 81 7d e8 ff ff 2f 	cmpq   $0x2fffff,-0x18(%rbp)
   41173:	00 
   41174:	0f 86 67 fe ff ff    	jbe    40fe1 <exception+0x6f1>
                }
            }       
        }
        break;
   4117a:	eb 10                	jmp    4118c <exception+0x89c>
    }

    default:
        default_exception(current);
   4117c:	48 8b 05 7d ce 00 00 	mov    0xce7d(%rip),%rax        # 4e000 <current>
   41183:	48 89 c7             	mov    %rax,%rdi
   41186:	e8 ba 19 00 00       	callq  42b45 <default_exception>
        break;                  /* will not be reached */
   4118b:	90                   	nop

    }


    // Return to the current process (or run something else).
    if (current->p_state == P_RUNNABLE) {
   4118c:	48 8b 05 6d ce 00 00 	mov    0xce6d(%rip),%rax        # 4e000 <current>
   41193:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
   41199:	83 f8 01             	cmp    $0x1,%eax
   4119c:	75 0f                	jne    411ad <exception+0x8bd>
        run(current);
   4119e:	48 8b 05 5b ce 00 00 	mov    0xce5b(%rip),%rax        # 4e000 <current>
   411a5:	48 89 c7             	mov    %rax,%rdi
   411a8:	e8 79 00 00 00       	callq  41226 <run>
    } else {
        schedule();
   411ad:	e8 02 00 00 00       	callq  411b4 <schedule>
    }
}
   411b2:	c9                   	leaveq 
   411b3:	c3                   	retq   

00000000000411b4 <schedule>:

// schedule
//    Pick the next process to run and then run it.
//    If there are no runnable processes, spins forever.

void schedule(void) {
   411b4:	55                   	push   %rbp
   411b5:	48 89 e5             	mov    %rsp,%rbp
   411b8:	48 83 ec 10          	sub    $0x10,%rsp
    pid_t pid = current->p_pid;
   411bc:	48 8b 05 3d ce 00 00 	mov    0xce3d(%rip),%rax        # 4e000 <current>
   411c3:	8b 00                	mov    (%rax),%eax
   411c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
    while (1) {
        pid = (pid + 1) % NPROC;
   411c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
   411cb:	83 c0 01             	add    $0x1,%eax
   411ce:	99                   	cltd   
   411cf:	c1 ea 1c             	shr    $0x1c,%edx
   411d2:	01 d0                	add    %edx,%eax
   411d4:	83 e0 0f             	and    $0xf,%eax
   411d7:	29 d0                	sub    %edx,%eax
   411d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (processes[pid].p_state == P_RUNNABLE) {
   411dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
   411df:	48 63 d0             	movslq %eax,%rdx
   411e2:	48 89 d0             	mov    %rdx,%rax
   411e5:	48 c1 e0 03          	shl    $0x3,%rax
   411e9:	48 29 d0             	sub    %rdx,%rax
   411ec:	48 c1 e0 05          	shl    $0x5,%rax
   411f0:	48 05 e8 e0 04 00    	add    $0x4e0e8,%rax
   411f6:	8b 00                	mov    (%rax),%eax
   411f8:	83 f8 01             	cmp    $0x1,%eax
   411fb:	75 22                	jne    4121f <schedule+0x6b>
            run(&processes[pid]);
   411fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41200:	48 63 d0             	movslq %eax,%rdx
   41203:	48 89 d0             	mov    %rdx,%rax
   41206:	48 c1 e0 03          	shl    $0x3,%rax
   4120a:	48 29 d0             	sub    %rdx,%rax
   4120d:	48 c1 e0 05          	shl    $0x5,%rax
   41211:	48 05 20 e0 04 00    	add    $0x4e020,%rax
   41217:	48 89 c7             	mov    %rax,%rdi
   4121a:	e8 07 00 00 00       	callq  41226 <run>
        }
        // If Control-C was typed, exit the virtual machine.
        check_keyboard();
   4121f:	e8 d0 16 00 00       	callq  428f4 <check_keyboard>
        pid = (pid + 1) % NPROC;
   41224:	eb a2                	jmp    411c8 <schedule+0x14>

0000000000041226 <run>:
//    Run process `p`. This means reloading all the registers from
//    `p->p_registers` using the `popal`, `popl`, and `iret` instructions.
//
//    As a side effect, sets `current = p`.

void run(proc* p) {
   41226:	55                   	push   %rbp
   41227:	48 89 e5             	mov    %rsp,%rbp
   4122a:	48 83 ec 10          	sub    $0x10,%rsp
   4122e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    assert(p->p_state == P_RUNNABLE);
   41232:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41236:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
   4123c:	83 f8 01             	cmp    $0x1,%eax
   4123f:	74 14                	je     41255 <run+0x2f>
   41241:	ba 10 42 04 00       	mov    $0x44210,%edx
   41246:	be da 01 00 00       	mov    $0x1da,%esi
   4124b:	bf 20 40 04 00       	mov    $0x44020,%edi
   41250:	e8 c0 18 00 00       	callq  42b15 <assert_fail>
    current = p;
   41255:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41259:	48 89 05 a0 cd 00 00 	mov    %rax,0xcda0(%rip)        # 4e000 <current>

    // Load the process's current pagetable.
    set_pagetable(p->p_pagetable);
   41260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41264:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   4126b:	48 89 c7             	mov    %rax,%rdi
   4126e:	e8 70 1a 00 00       	callq  42ce3 <set_pagetable>

    // This function is defined in k-exception.S. It restores the process's
    // registers then jumps back to user mode.
    exception_return(&p->p_registers);
   41273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41277:	48 83 c0 08          	add    $0x8,%rax
   4127b:	48 89 c7             	mov    %rax,%rdi
   4127e:	e8 40 ee ff ff       	callq  400c3 <exception_return>

0000000000041283 <pageinfo_init>:


// pageinfo_init
//    Initialize the `pageinfo[]` array.

void pageinfo_init(void) {
   41283:	55                   	push   %rbp
   41284:	48 89 e5             	mov    %rsp,%rbp
   41287:	48 83 ec 10          	sub    $0x10,%rsp
    extern char end[];

    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
   4128b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   41292:	00 
   41293:	e9 81 00 00 00       	jmpq   41319 <pageinfo_init+0x96>
        int owner;
        if (physical_memory_isreserved(addr)) {
   41298:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4129c:	48 89 c7             	mov    %rax,%rdi
   4129f:	e8 ef 0e 00 00       	callq  42193 <physical_memory_isreserved>
   412a4:	85 c0                	test   %eax,%eax
   412a6:	74 09                	je     412b1 <pageinfo_init+0x2e>
            owner = PO_RESERVED;
   412a8:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%rbp)
   412af:	eb 2f                	jmp    412e0 <pageinfo_init+0x5d>
        } else if ((addr >= KERNEL_START_ADDR && addr < (uintptr_t) end)
   412b1:	48 81 7d f8 ff ff 03 	cmpq   $0x3ffff,-0x8(%rbp)
   412b8:	00 
   412b9:	76 0b                	jbe    412c6 <pageinfo_init+0x43>
   412bb:	b8 08 70 05 00       	mov    $0x57008,%eax
   412c0:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   412c4:	72 0a                	jb     412d0 <pageinfo_init+0x4d>
                   || addr == KERNEL_STACK_TOP - PAGESIZE) {
   412c6:	48 81 7d f8 00 f0 07 	cmpq   $0x7f000,-0x8(%rbp)
   412cd:	00 
   412ce:	75 09                	jne    412d9 <pageinfo_init+0x56>
            owner = PO_KERNEL;
   412d0:	c7 45 f4 fe ff ff ff 	movl   $0xfffffffe,-0xc(%rbp)
   412d7:	eb 07                	jmp    412e0 <pageinfo_init+0x5d>
        } else {
            owner = PO_FREE;
   412d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
        }
        pageinfo[PAGENUMBER(addr)].owner = owner;
   412e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   412e4:	48 c1 e8 0c          	shr    $0xc,%rax
   412e8:	89 c1                	mov    %eax,%ecx
   412ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
   412ed:	89 c2                	mov    %eax,%edx
   412ef:	48 63 c1             	movslq %ecx,%rax
   412f2:	88 94 00 40 ee 04 00 	mov    %dl,0x4ee40(%rax,%rax,1)
        pageinfo[PAGENUMBER(addr)].refcount = (owner != PO_FREE);
   412f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   412fd:	0f 95 c2             	setne  %dl
   41300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41304:	48 c1 e8 0c          	shr    $0xc,%rax
   41308:	48 98                	cltq   
   4130a:	88 94 00 41 ee 04 00 	mov    %dl,0x4ee41(%rax,%rax,1)
    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
   41311:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   41318:	00 
   41319:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   41320:	00 
   41321:	0f 86 71 ff ff ff    	jbe    41298 <pageinfo_init+0x15>
    }
}
   41327:	90                   	nop
   41328:	90                   	nop
   41329:	c9                   	leaveq 
   4132a:	c3                   	retq   

000000000004132b <check_page_table_mappings>:

// check_page_table_mappings
//    Check operating system invariants about kernel mappings for page
//    table `pt`. Panic if any of the invariants are false.

void check_page_table_mappings(x86_64_pagetable* pt) {
   4132b:	55                   	push   %rbp
   4132c:	48 89 e5             	mov    %rsp,%rbp
   4132f:	48 83 ec 50          	sub    $0x50,%rsp
   41333:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
    extern char start_data[], end[];
    assert(PTE_ADDR(pt) == (uintptr_t) pt);
   41337:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   4133b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   41341:	48 89 c2             	mov    %rax,%rdx
   41344:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   41348:	48 39 c2             	cmp    %rax,%rdx
   4134b:	74 14                	je     41361 <check_page_table_mappings+0x36>
   4134d:	ba 30 42 04 00       	mov    $0x44230,%edx
   41352:	be 04 02 00 00       	mov    $0x204,%esi
   41357:	bf 20 40 04 00       	mov    $0x44020,%edi
   4135c:	e8 b4 17 00 00       	callq  42b15 <assert_fail>

    // kernel memory is identity mapped; data is writable
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
   41361:	48 c7 45 f8 00 00 04 	movq   $0x40000,-0x8(%rbp)
   41368:	00 
   41369:	e9 9a 00 00 00       	jmpq   41408 <check_page_table_mappings+0xdd>
         va += PAGESIZE) {
        vamapping vam = virtual_memory_lookup(pt, va);
   4136e:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
   41372:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   41376:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
   4137a:	48 89 ce             	mov    %rcx,%rsi
   4137d:	48 89 c7             	mov    %rax,%rdi
   41380:	e8 4b 1e 00 00       	callq  431d0 <virtual_memory_lookup>
        if (vam.pa != va) {
   41385:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   41389:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   4138d:	74 27                	je     413b6 <check_page_table_mappings+0x8b>
            console_printf(CPOS(22, 0), 0xC000, "%p vs %p\n", va, vam.pa);
   4138f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   41393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41397:	49 89 d0             	mov    %rdx,%r8
   4139a:	48 89 c1             	mov    %rax,%rcx
   4139d:	ba 4f 42 04 00       	mov    $0x4424f,%edx
   413a2:	be 00 c0 00 00       	mov    $0xc000,%esi
   413a7:	bf e0 06 00 00       	mov    $0x6e0,%edi
   413ac:	b8 00 00 00 00       	mov    $0x0,%eax
   413b1:	e8 56 2b 00 00       	callq  43f0c <console_printf>
        }
        assert(vam.pa == va);
   413b6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   413ba:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   413be:	74 14                	je     413d4 <check_page_table_mappings+0xa9>
   413c0:	ba 59 42 04 00       	mov    $0x44259,%edx
   413c5:	be 0d 02 00 00       	mov    $0x20d,%esi
   413ca:	bf 20 40 04 00       	mov    $0x44020,%edi
   413cf:	e8 41 17 00 00       	callq  42b15 <assert_fail>
        if (va >= (uintptr_t) start_data) {
   413d4:	b8 00 50 04 00       	mov    $0x45000,%eax
   413d9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   413dd:	72 21                	jb     41400 <check_page_table_mappings+0xd5>
            assert(vam.perm & PTE_W);
   413df:	8b 45 d0             	mov    -0x30(%rbp),%eax
   413e2:	48 98                	cltq   
   413e4:	83 e0 02             	and    $0x2,%eax
   413e7:	48 85 c0             	test   %rax,%rax
   413ea:	75 14                	jne    41400 <check_page_table_mappings+0xd5>
   413ec:	ba 66 42 04 00       	mov    $0x44266,%edx
   413f1:	be 0f 02 00 00       	mov    $0x20f,%esi
   413f6:	bf 20 40 04 00       	mov    $0x44020,%edi
   413fb:	e8 15 17 00 00       	callq  42b15 <assert_fail>
         va += PAGESIZE) {
   41400:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   41407:	00 
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
   41408:	b8 08 70 05 00       	mov    $0x57008,%eax
   4140d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   41411:	0f 82 57 ff ff ff    	jb     4136e <check_page_table_mappings+0x43>
        }
    }

    // kernel stack is identity mapped and writable
    uintptr_t kstack = KERNEL_STACK_TOP - PAGESIZE;
   41417:	48 c7 45 f0 00 f0 07 	movq   $0x7f000,-0x10(%rbp)
   4141e:	00 
    vamapping vam = virtual_memory_lookup(pt, kstack);
   4141f:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
   41423:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   41427:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
   4142b:	48 89 ce             	mov    %rcx,%rsi
   4142e:	48 89 c7             	mov    %rax,%rdi
   41431:	e8 9a 1d 00 00       	callq  431d0 <virtual_memory_lookup>
    assert(vam.pa == kstack);
   41436:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4143a:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
   4143e:	74 14                	je     41454 <check_page_table_mappings+0x129>
   41440:	ba 77 42 04 00       	mov    $0x44277,%edx
   41445:	be 16 02 00 00       	mov    $0x216,%esi
   4144a:	bf 20 40 04 00       	mov    $0x44020,%edi
   4144f:	e8 c1 16 00 00       	callq  42b15 <assert_fail>
    assert(vam.perm & PTE_W);
   41454:	8b 45 e8             	mov    -0x18(%rbp),%eax
   41457:	48 98                	cltq   
   41459:	83 e0 02             	and    $0x2,%eax
   4145c:	48 85 c0             	test   %rax,%rax
   4145f:	75 14                	jne    41475 <check_page_table_mappings+0x14a>
   41461:	ba 66 42 04 00       	mov    $0x44266,%edx
   41466:	be 17 02 00 00       	mov    $0x217,%esi
   4146b:	bf 20 40 04 00       	mov    $0x44020,%edi
   41470:	e8 a0 16 00 00       	callq  42b15 <assert_fail>
}
   41475:	90                   	nop
   41476:	c9                   	leaveq 
   41477:	c3                   	retq   

0000000000041478 <check_page_table_ownership>:
//    counts for page table `pt`. Panic if any of the invariants are false.

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount);

void check_page_table_ownership(x86_64_pagetable* pt, pid_t pid) {
   41478:	55                   	push   %rbp
   41479:	48 89 e5             	mov    %rsp,%rbp
   4147c:	48 83 ec 20          	sub    $0x20,%rsp
   41480:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   41484:	89 75 e4             	mov    %esi,-0x1c(%rbp)
    // calculate expected reference count for page tables
    int owner = pid;
   41487:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   4148a:	89 45 fc             	mov    %eax,-0x4(%rbp)
    int expected_refcount = 1;
   4148d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
    if (pt == kernel_pagetable) {
   41494:	48 8b 05 65 fb 00 00 	mov    0xfb65(%rip),%rax        # 51000 <kernel_pagetable>
   4149b:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
   4149f:	75 67                	jne    41508 <check_page_table_ownership+0x90>
        owner = PO_KERNEL;
   414a1:	c7 45 fc fe ff ff ff 	movl   $0xfffffffe,-0x4(%rbp)
        for (int xpid = 0; xpid < NPROC; ++xpid) {
   414a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   414af:	eb 51                	jmp    41502 <check_page_table_ownership+0x8a>
            if (processes[xpid].p_state != P_FREE
   414b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
   414b4:	48 63 d0             	movslq %eax,%rdx
   414b7:	48 89 d0             	mov    %rdx,%rax
   414ba:	48 c1 e0 03          	shl    $0x3,%rax
   414be:	48 29 d0             	sub    %rdx,%rax
   414c1:	48 c1 e0 05          	shl    $0x5,%rax
   414c5:	48 05 e8 e0 04 00    	add    $0x4e0e8,%rax
   414cb:	8b 00                	mov    (%rax),%eax
   414cd:	85 c0                	test   %eax,%eax
   414cf:	74 2d                	je     414fe <check_page_table_ownership+0x86>
                && processes[xpid].p_pagetable == kernel_pagetable) {
   414d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
   414d4:	48 63 d0             	movslq %eax,%rdx
   414d7:	48 89 d0             	mov    %rdx,%rax
   414da:	48 c1 e0 03          	shl    $0x3,%rax
   414de:	48 29 d0             	sub    %rdx,%rax
   414e1:	48 c1 e0 05          	shl    $0x5,%rax
   414e5:	48 05 f0 e0 04 00    	add    $0x4e0f0,%rax
   414eb:	48 8b 10             	mov    (%rax),%rdx
   414ee:	48 8b 05 0b fb 00 00 	mov    0xfb0b(%rip),%rax        # 51000 <kernel_pagetable>
   414f5:	48 39 c2             	cmp    %rax,%rdx
   414f8:	75 04                	jne    414fe <check_page_table_ownership+0x86>
                ++expected_refcount;
   414fa:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
        for (int xpid = 0; xpid < NPROC; ++xpid) {
   414fe:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   41502:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
   41506:	7e a9                	jle    414b1 <check_page_table_ownership+0x39>
            }
        }
    }
    check_page_table_ownership_level(pt, 0, owner, expected_refcount);
   41508:	8b 4d f8             	mov    -0x8(%rbp),%ecx
   4150b:	8b 55 fc             	mov    -0x4(%rbp),%edx
   4150e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41512:	be 00 00 00 00       	mov    $0x0,%esi
   41517:	48 89 c7             	mov    %rax,%rdi
   4151a:	e8 03 00 00 00       	callq  41522 <check_page_table_ownership_level>
}
   4151f:	90                   	nop
   41520:	c9                   	leaveq 
   41521:	c3                   	retq   

0000000000041522 <check_page_table_ownership_level>:

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount) {
   41522:	55                   	push   %rbp
   41523:	48 89 e5             	mov    %rsp,%rbp
   41526:	48 83 ec 30          	sub    $0x30,%rsp
   4152a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   4152e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
   41531:	89 55 e0             	mov    %edx,-0x20(%rbp)
   41534:	89 4d dc             	mov    %ecx,-0x24(%rbp)
    assert(PAGENUMBER(pt) < NPAGES);
   41537:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4153b:	48 c1 e8 0c          	shr    $0xc,%rax
   4153f:	3d ff 01 00 00       	cmp    $0x1ff,%eax
   41544:	7e 14                	jle    4155a <check_page_table_ownership_level+0x38>
   41546:	ba 88 42 04 00       	mov    $0x44288,%edx
   4154b:	be 34 02 00 00       	mov    $0x234,%esi
   41550:	bf 20 40 04 00       	mov    $0x44020,%edi
   41555:	e8 bb 15 00 00       	callq  42b15 <assert_fail>
    assert(pageinfo[PAGENUMBER(pt)].owner == owner);
   4155a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4155e:	48 c1 e8 0c          	shr    $0xc,%rax
   41562:	48 98                	cltq   
   41564:	0f b6 84 00 40 ee 04 	movzbl 0x4ee40(%rax,%rax,1),%eax
   4156b:	00 
   4156c:	0f be c0             	movsbl %al,%eax
   4156f:	39 45 e0             	cmp    %eax,-0x20(%rbp)
   41572:	74 14                	je     41588 <check_page_table_ownership_level+0x66>
   41574:	ba a0 42 04 00       	mov    $0x442a0,%edx
   41579:	be 35 02 00 00       	mov    $0x235,%esi
   4157e:	bf 20 40 04 00       	mov    $0x44020,%edi
   41583:	e8 8d 15 00 00       	callq  42b15 <assert_fail>
    assert(pageinfo[PAGENUMBER(pt)].refcount == refcount);
   41588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4158c:	48 c1 e8 0c          	shr    $0xc,%rax
   41590:	48 98                	cltq   
   41592:	0f b6 84 00 41 ee 04 	movzbl 0x4ee41(%rax,%rax,1),%eax
   41599:	00 
   4159a:	0f be c0             	movsbl %al,%eax
   4159d:	39 45 dc             	cmp    %eax,-0x24(%rbp)
   415a0:	74 14                	je     415b6 <check_page_table_ownership_level+0x94>
   415a2:	ba c8 42 04 00       	mov    $0x442c8,%edx
   415a7:	be 36 02 00 00       	mov    $0x236,%esi
   415ac:	bf 20 40 04 00       	mov    $0x44020,%edi
   415b1:	e8 5f 15 00 00       	callq  42b15 <assert_fail>
    if (level < 3) {
   415b6:	83 7d e4 02          	cmpl   $0x2,-0x1c(%rbp)
   415ba:	7f 5b                	jg     41617 <check_page_table_ownership_level+0xf5>
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
   415bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   415c3:	eb 49                	jmp    4160e <check_page_table_ownership_level+0xec>
            if (pt->entry[index]) {
   415c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   415c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
   415cc:	48 63 d2             	movslq %edx,%rdx
   415cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   415d3:	48 85 c0             	test   %rax,%rax
   415d6:	74 32                	je     4160a <check_page_table_ownership_level+0xe8>
                x86_64_pagetable* nextpt =
                    (x86_64_pagetable*) PTE_ADDR(pt->entry[index]);
   415d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   415dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
   415df:	48 63 d2             	movslq %edx,%rdx
   415e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   415e6:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
                x86_64_pagetable* nextpt =
   415ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                check_page_table_ownership_level(nextpt, level + 1, owner, 1);
   415f0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   415f3:	8d 70 01             	lea    0x1(%rax),%esi
   415f6:	8b 55 e0             	mov    -0x20(%rbp),%edx
   415f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   415fd:	b9 01 00 00 00       	mov    $0x1,%ecx
   41602:	48 89 c7             	mov    %rax,%rdi
   41605:	e8 18 ff ff ff       	callq  41522 <check_page_table_ownership_level>
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
   4160a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   4160e:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   41615:	7e ae                	jle    415c5 <check_page_table_ownership_level+0xa3>
            }
        }
    }
}
   41617:	90                   	nop
   41618:	c9                   	leaveq 
   41619:	c3                   	retq   

000000000004161a <check_virtual_memory>:

// check_virtual_memory
//    Check operating system invariants about virtual memory. Panic if any
//    of the invariants are false.

void check_virtual_memory(void) {
   4161a:	55                   	push   %rbp
   4161b:	48 89 e5             	mov    %rsp,%rbp
   4161e:	48 83 ec 10          	sub    $0x10,%rsp
    // Process 0 must never be used.
    assert(processes[0].p_state == P_FREE);
   41622:	8b 05 c0 ca 00 00    	mov    0xcac0(%rip),%eax        # 4e0e8 <processes+0xc8>
   41628:	85 c0                	test   %eax,%eax
   4162a:	74 14                	je     41640 <check_virtual_memory+0x26>
   4162c:	ba f8 42 04 00       	mov    $0x442f8,%edx
   41631:	be 49 02 00 00       	mov    $0x249,%esi
   41636:	bf 20 40 04 00       	mov    $0x44020,%edi
   4163b:	e8 d5 14 00 00       	callq  42b15 <assert_fail>
    // that don't have their own page tables.
    // Active processes have their own page tables. A process page table
    // should be owned by that process and have reference count 1.
    // All level-2-4 page tables must have reference count 1.

    check_page_table_mappings(kernel_pagetable);
   41640:	48 8b 05 b9 f9 00 00 	mov    0xf9b9(%rip),%rax        # 51000 <kernel_pagetable>
   41647:	48 89 c7             	mov    %rax,%rdi
   4164a:	e8 dc fc ff ff       	callq  4132b <check_page_table_mappings>
    check_page_table_ownership(kernel_pagetable, -1);
   4164f:	48 8b 05 aa f9 00 00 	mov    0xf9aa(%rip),%rax        # 51000 <kernel_pagetable>
   41656:	be ff ff ff ff       	mov    $0xffffffff,%esi
   4165b:	48 89 c7             	mov    %rax,%rdi
   4165e:	e8 15 fe ff ff       	callq  41478 <check_page_table_ownership>

    for (int pid = 0; pid < NPROC; ++pid) {
   41663:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4166a:	e9 9c 00 00 00       	jmpq   4170b <check_virtual_memory+0xf1>
        if (processes[pid].p_state != P_FREE
   4166f:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41672:	48 63 d0             	movslq %eax,%rdx
   41675:	48 89 d0             	mov    %rdx,%rax
   41678:	48 c1 e0 03          	shl    $0x3,%rax
   4167c:	48 29 d0             	sub    %rdx,%rax
   4167f:	48 c1 e0 05          	shl    $0x5,%rax
   41683:	48 05 e8 e0 04 00    	add    $0x4e0e8,%rax
   41689:	8b 00                	mov    (%rax),%eax
   4168b:	85 c0                	test   %eax,%eax
   4168d:	74 78                	je     41707 <check_virtual_memory+0xed>
            && processes[pid].p_pagetable != kernel_pagetable) {
   4168f:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41692:	48 63 d0             	movslq %eax,%rdx
   41695:	48 89 d0             	mov    %rdx,%rax
   41698:	48 c1 e0 03          	shl    $0x3,%rax
   4169c:	48 29 d0             	sub    %rdx,%rax
   4169f:	48 c1 e0 05          	shl    $0x5,%rax
   416a3:	48 05 f0 e0 04 00    	add    $0x4e0f0,%rax
   416a9:	48 8b 10             	mov    (%rax),%rdx
   416ac:	48 8b 05 4d f9 00 00 	mov    0xf94d(%rip),%rax        # 51000 <kernel_pagetable>
   416b3:	48 39 c2             	cmp    %rax,%rdx
   416b6:	74 4f                	je     41707 <check_virtual_memory+0xed>
            check_page_table_mappings(processes[pid].p_pagetable);
   416b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
   416bb:	48 63 d0             	movslq %eax,%rdx
   416be:	48 89 d0             	mov    %rdx,%rax
   416c1:	48 c1 e0 03          	shl    $0x3,%rax
   416c5:	48 29 d0             	sub    %rdx,%rax
   416c8:	48 c1 e0 05          	shl    $0x5,%rax
   416cc:	48 05 f0 e0 04 00    	add    $0x4e0f0,%rax
   416d2:	48 8b 00             	mov    (%rax),%rax
   416d5:	48 89 c7             	mov    %rax,%rdi
   416d8:	e8 4e fc ff ff       	callq  4132b <check_page_table_mappings>
            check_page_table_ownership(processes[pid].p_pagetable, pid);
   416dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
   416e0:	48 63 d0             	movslq %eax,%rdx
   416e3:	48 89 d0             	mov    %rdx,%rax
   416e6:	48 c1 e0 03          	shl    $0x3,%rax
   416ea:	48 29 d0             	sub    %rdx,%rax
   416ed:	48 c1 e0 05          	shl    $0x5,%rax
   416f1:	48 05 f0 e0 04 00    	add    $0x4e0f0,%rax
   416f7:	48 8b 00             	mov    (%rax),%rax
   416fa:	8b 55 fc             	mov    -0x4(%rbp),%edx
   416fd:	89 d6                	mov    %edx,%esi
   416ff:	48 89 c7             	mov    %rax,%rdi
   41702:	e8 71 fd ff ff       	callq  41478 <check_page_table_ownership>
    for (int pid = 0; pid < NPROC; ++pid) {
   41707:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   4170b:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   4170f:	0f 8e 5a ff ff ff    	jle    4166f <check_virtual_memory+0x55>
        }
    }

    // Check that all referenced pages refer to active processes
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   41715:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   4171c:	eb 67                	jmp    41785 <check_virtual_memory+0x16b>
        if (pageinfo[pn].refcount > 0 && pageinfo[pn].owner >= 0) {
   4171e:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41721:	48 98                	cltq   
   41723:	0f b6 84 00 41 ee 04 	movzbl 0x4ee41(%rax,%rax,1),%eax
   4172a:	00 
   4172b:	84 c0                	test   %al,%al
   4172d:	7e 52                	jle    41781 <check_virtual_memory+0x167>
   4172f:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41732:	48 98                	cltq   
   41734:	0f b6 84 00 40 ee 04 	movzbl 0x4ee40(%rax,%rax,1),%eax
   4173b:	00 
   4173c:	84 c0                	test   %al,%al
   4173e:	78 41                	js     41781 <check_virtual_memory+0x167>
            assert(processes[pageinfo[pn].owner].p_state != P_FREE);
   41740:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41743:	48 98                	cltq   
   41745:	0f b6 84 00 40 ee 04 	movzbl 0x4ee40(%rax,%rax,1),%eax
   4174c:	00 
   4174d:	0f be c0             	movsbl %al,%eax
   41750:	48 63 d0             	movslq %eax,%rdx
   41753:	48 89 d0             	mov    %rdx,%rax
   41756:	48 c1 e0 03          	shl    $0x3,%rax
   4175a:	48 29 d0             	sub    %rdx,%rax
   4175d:	48 c1 e0 05          	shl    $0x5,%rax
   41761:	48 05 e8 e0 04 00    	add    $0x4e0e8,%rax
   41767:	8b 00                	mov    (%rax),%eax
   41769:	85 c0                	test   %eax,%eax
   4176b:	75 14                	jne    41781 <check_virtual_memory+0x167>
   4176d:	ba 18 43 04 00       	mov    $0x44318,%edx
   41772:	be 60 02 00 00       	mov    $0x260,%esi
   41777:	bf 20 40 04 00       	mov    $0x44020,%edi
   4177c:	e8 94 13 00 00       	callq  42b15 <assert_fail>
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   41781:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   41785:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
   4178c:	7e 90                	jle    4171e <check_virtual_memory+0x104>
        }
    }
}
   4178e:	90                   	nop
   4178f:	90                   	nop
   41790:	c9                   	leaveq 
   41791:	c3                   	retq   

0000000000041792 <memshow_physical>:
    'E' | 0x0E00, 'F' | 0x0F00, 'S'
};
#define SHARED_COLOR memstate_colors[18]
#define SHARED

void memshow_physical(void) {
   41792:	55                   	push   %rbp
   41793:	48 89 e5             	mov    %rsp,%rbp
   41796:	48 83 ec 10          	sub    $0x10,%rsp
    console_printf(CPOS(0, 32), 0x0F00, "PHYSICAL MEMORY");
   4179a:	ba 86 43 04 00       	mov    $0x44386,%edx
   4179f:	be 00 0f 00 00       	mov    $0xf00,%esi
   417a4:	bf 20 00 00 00       	mov    $0x20,%edi
   417a9:	b8 00 00 00 00       	mov    $0x0,%eax
   417ae:	e8 59 27 00 00       	callq  43f0c <console_printf>
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   417b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   417ba:	e9 f4 00 00 00       	jmpq   418b3 <memshow_physical+0x121>
        if (pn % 64 == 0) {
   417bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
   417c2:	83 e0 3f             	and    $0x3f,%eax
   417c5:	85 c0                	test   %eax,%eax
   417c7:	75 3e                	jne    41807 <memshow_physical+0x75>
            console_printf(CPOS(1 + pn / 64, 3), 0x0F00, "0x%06X ", pn << 12);
   417c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
   417cc:	c1 e0 0c             	shl    $0xc,%eax
   417cf:	89 c2                	mov    %eax,%edx
   417d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
   417d4:	8d 48 3f             	lea    0x3f(%rax),%ecx
   417d7:	85 c0                	test   %eax,%eax
   417d9:	0f 48 c1             	cmovs  %ecx,%eax
   417dc:	c1 f8 06             	sar    $0x6,%eax
   417df:	8d 48 01             	lea    0x1(%rax),%ecx
   417e2:	89 c8                	mov    %ecx,%eax
   417e4:	c1 e0 02             	shl    $0x2,%eax
   417e7:	01 c8                	add    %ecx,%eax
   417e9:	c1 e0 04             	shl    $0x4,%eax
   417ec:	83 c0 03             	add    $0x3,%eax
   417ef:	89 d1                	mov    %edx,%ecx
   417f1:	ba 96 43 04 00       	mov    $0x44396,%edx
   417f6:	be 00 0f 00 00       	mov    $0xf00,%esi
   417fb:	89 c7                	mov    %eax,%edi
   417fd:	b8 00 00 00 00       	mov    $0x0,%eax
   41802:	e8 05 27 00 00       	callq  43f0c <console_printf>
        }

        int owner = pageinfo[pn].owner;
   41807:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4180a:	48 98                	cltq   
   4180c:	0f b6 84 00 40 ee 04 	movzbl 0x4ee40(%rax,%rax,1),%eax
   41813:	00 
   41814:	0f be c0             	movsbl %al,%eax
   41817:	89 45 f8             	mov    %eax,-0x8(%rbp)
        if (pageinfo[pn].refcount == 0) {
   4181a:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4181d:	48 98                	cltq   
   4181f:	0f b6 84 00 41 ee 04 	movzbl 0x4ee41(%rax,%rax,1),%eax
   41826:	00 
   41827:	84 c0                	test   %al,%al
   41829:	75 07                	jne    41832 <memshow_physical+0xa0>
            owner = PO_FREE;
   4182b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
        }
        uint16_t color = memstate_colors[owner - PO_KERNEL];
   41832:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41835:	83 c0 02             	add    $0x2,%eax
   41838:	48 98                	cltq   
   4183a:	0f b7 84 00 60 43 04 	movzwl 0x44360(%rax,%rax,1),%eax
   41841:	00 
   41842:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
        // darker color for shared pages
        if (pageinfo[pn].refcount > 1 && pn != PAGENUMBER(CONSOLE_ADDR)){
   41846:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41849:	48 98                	cltq   
   4184b:	0f b6 84 00 41 ee 04 	movzbl 0x4ee41(%rax,%rax,1),%eax
   41852:	00 
   41853:	3c 01                	cmp    $0x1,%al
   41855:	7e 1a                	jle    41871 <memshow_physical+0xdf>
   41857:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   4185c:	48 c1 e8 0c          	shr    $0xc,%rax
   41860:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   41863:	74 0c                	je     41871 <memshow_physical+0xdf>
#ifdef SHARED
            color = SHARED_COLOR | 0x0F00;
   41865:	b8 53 00 00 00       	mov    $0x53,%eax
   4186a:	80 cc 0f             	or     $0xf,%ah
   4186d:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
#else
	    color &= 0x77FF;
#endif
        }

        console[CPOS(1 + pn / 64, 12 + pn % 64)] = color;
   41871:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41874:	8d 50 3f             	lea    0x3f(%rax),%edx
   41877:	85 c0                	test   %eax,%eax
   41879:	0f 48 c2             	cmovs  %edx,%eax
   4187c:	c1 f8 06             	sar    $0x6,%eax
   4187f:	8d 50 01             	lea    0x1(%rax),%edx
   41882:	89 d0                	mov    %edx,%eax
   41884:	c1 e0 02             	shl    $0x2,%eax
   41887:	01 d0                	add    %edx,%eax
   41889:	c1 e0 04             	shl    $0x4,%eax
   4188c:	89 c1                	mov    %eax,%ecx
   4188e:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41891:	99                   	cltd   
   41892:	c1 ea 1a             	shr    $0x1a,%edx
   41895:	01 d0                	add    %edx,%eax
   41897:	83 e0 3f             	and    $0x3f,%eax
   4189a:	29 d0                	sub    %edx,%eax
   4189c:	83 c0 0c             	add    $0xc,%eax
   4189f:	01 c8                	add    %ecx,%eax
   418a1:	48 98                	cltq   
   418a3:	0f b7 55 f6          	movzwl -0xa(%rbp),%edx
   418a7:	66 89 94 00 00 80 0b 	mov    %dx,0xb8000(%rax,%rax,1)
   418ae:	00 
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   418af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   418b3:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   418ba:	0f 8e ff fe ff ff    	jle    417bf <memshow_physical+0x2d>
    }
}
   418c0:	90                   	nop
   418c1:	90                   	nop
   418c2:	c9                   	leaveq 
   418c3:	c3                   	retq   

00000000000418c4 <memshow_virtual>:

// memshow_virtual(pagetable, name)
//    Draw a picture of the virtual memory map `pagetable` (named `name`) on
//    the CGA console.

void memshow_virtual(x86_64_pagetable* pagetable, const char* name) {
   418c4:	55                   	push   %rbp
   418c5:	48 89 e5             	mov    %rsp,%rbp
   418c8:	48 83 ec 40          	sub    $0x40,%rsp
   418cc:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   418d0:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
    assert((uintptr_t) pagetable == PTE_ADDR(pagetable));
   418d4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   418d8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   418de:	48 89 c2             	mov    %rax,%rdx
   418e1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   418e5:	48 39 c2             	cmp    %rax,%rdx
   418e8:	74 14                	je     418fe <memshow_virtual+0x3a>
   418ea:	ba a0 43 04 00       	mov    $0x443a0,%edx
   418ef:	be 91 02 00 00       	mov    $0x291,%esi
   418f4:	bf 20 40 04 00       	mov    $0x44020,%edi
   418f9:	e8 17 12 00 00       	callq  42b15 <assert_fail>

    console_printf(CPOS(10, 26), 0x0F00, "VIRTUAL ADDRESS SPACE FOR %s", name);
   418fe:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   41902:	48 89 c1             	mov    %rax,%rcx
   41905:	ba cd 43 04 00       	mov    $0x443cd,%edx
   4190a:	be 00 0f 00 00       	mov    $0xf00,%esi
   4190f:	bf 3a 03 00 00       	mov    $0x33a,%edi
   41914:	b8 00 00 00 00       	mov    $0x0,%eax
   41919:	e8 ee 25 00 00       	callq  43f0c <console_printf>
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   4191e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   41925:	00 
   41926:	e9 80 01 00 00       	jmpq   41aab <memshow_virtual+0x1e7>
        vamapping vam = virtual_memory_lookup(pagetable, va);
   4192b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   4192f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   41933:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   41937:	48 89 ce             	mov    %rcx,%rsi
   4193a:	48 89 c7             	mov    %rax,%rdi
   4193d:	e8 8e 18 00 00       	callq  431d0 <virtual_memory_lookup>
        uint16_t color;
        if (vam.pn < 0) {
   41942:	8b 45 d0             	mov    -0x30(%rbp),%eax
   41945:	85 c0                	test   %eax,%eax
   41947:	79 0b                	jns    41954 <memshow_virtual+0x90>
            color = ' ';
   41949:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%rbp)
   4194f:	e9 d7 00 00 00       	jmpq   41a2b <memshow_virtual+0x167>
        } else {
            assert(vam.pa < MEMSIZE_PHYSICAL);
   41954:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   41958:	48 3d ff ff 1f 00    	cmp    $0x1fffff,%rax
   4195e:	76 14                	jbe    41974 <memshow_virtual+0xb0>
   41960:	ba ea 43 04 00       	mov    $0x443ea,%edx
   41965:	be 9a 02 00 00       	mov    $0x29a,%esi
   4196a:	bf 20 40 04 00       	mov    $0x44020,%edi
   4196f:	e8 a1 11 00 00       	callq  42b15 <assert_fail>
            int owner = pageinfo[vam.pn].owner;
   41974:	8b 45 d0             	mov    -0x30(%rbp),%eax
   41977:	48 98                	cltq   
   41979:	0f b6 84 00 40 ee 04 	movzbl 0x4ee40(%rax,%rax,1),%eax
   41980:	00 
   41981:	0f be c0             	movsbl %al,%eax
   41984:	89 45 f0             	mov    %eax,-0x10(%rbp)
            if (pageinfo[vam.pn].refcount == 0) {
   41987:	8b 45 d0             	mov    -0x30(%rbp),%eax
   4198a:	48 98                	cltq   
   4198c:	0f b6 84 00 41 ee 04 	movzbl 0x4ee41(%rax,%rax,1),%eax
   41993:	00 
   41994:	84 c0                	test   %al,%al
   41996:	75 07                	jne    4199f <memshow_virtual+0xdb>
                owner = PO_FREE;
   41998:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
            }
            color = memstate_colors[owner - PO_KERNEL];
   4199f:	8b 45 f0             	mov    -0x10(%rbp),%eax
   419a2:	83 c0 02             	add    $0x2,%eax
   419a5:	48 98                	cltq   
   419a7:	0f b7 84 00 60 43 04 	movzwl 0x44360(%rax,%rax,1),%eax
   419ae:	00 
   419af:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
            // reverse video for user-accessible pages
            if (vam.perm & PTE_U) {
   419b3:	8b 45 e0             	mov    -0x20(%rbp),%eax
   419b6:	48 98                	cltq   
   419b8:	83 e0 04             	and    $0x4,%eax
   419bb:	48 85 c0             	test   %rax,%rax
   419be:	74 27                	je     419e7 <memshow_virtual+0x123>
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
   419c0:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   419c4:	c1 e0 04             	shl    $0x4,%eax
   419c7:	66 25 00 f0          	and    $0xf000,%ax
   419cb:	89 c2                	mov    %eax,%edx
   419cd:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   419d1:	c1 f8 04             	sar    $0x4,%eax
   419d4:	66 25 00 0f          	and    $0xf00,%ax
   419d8:	09 c2                	or     %eax,%edx
                    | (color & 0x00FF);
   419da:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   419de:	0f b6 c0             	movzbl %al,%eax
   419e1:	09 d0                	or     %edx,%eax
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
   419e3:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
            }
            // darker color for shared pages
            if (pageinfo[vam.pn].refcount > 1 && va != CONSOLE_ADDR) {
   419e7:	8b 45 d0             	mov    -0x30(%rbp),%eax
   419ea:	48 98                	cltq   
   419ec:	0f b6 84 00 41 ee 04 	movzbl 0x4ee41(%rax,%rax,1),%eax
   419f3:	00 
   419f4:	3c 01                	cmp    $0x1,%al
   419f6:	7e 33                	jle    41a2b <memshow_virtual+0x167>
   419f8:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   419fd:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   41a01:	74 28                	je     41a2b <memshow_virtual+0x167>
#ifdef SHARED
                color = (SHARED_COLOR | (color & 0xF000));
   41a03:	b8 53 00 00 00       	mov    $0x53,%eax
   41a08:	89 c2                	mov    %eax,%edx
   41a0a:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   41a0e:	66 25 00 f0          	and    $0xf000,%ax
   41a12:	09 d0                	or     %edx,%eax
   41a14:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
                if(! (vam.perm & PTE_U))
   41a18:	8b 45 e0             	mov    -0x20(%rbp),%eax
   41a1b:	48 98                	cltq   
   41a1d:	83 e0 04             	and    $0x4,%eax
   41a20:	48 85 c0             	test   %rax,%rax
   41a23:	75 06                	jne    41a2b <memshow_virtual+0x167>
                    color = color | 0x0F00;
   41a25:	66 81 4d f6 00 0f    	orw    $0xf00,-0xa(%rbp)
#else
		color &= 0x77FF;
#endif
            }
        }
        uint32_t pn = PAGENUMBER(va);
   41a2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41a2f:	48 c1 e8 0c          	shr    $0xc,%rax
   41a33:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (pn % 64 == 0) {
   41a36:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41a39:	83 e0 3f             	and    $0x3f,%eax
   41a3c:	85 c0                	test   %eax,%eax
   41a3e:	75 34                	jne    41a74 <memshow_virtual+0x1b0>
            console_printf(CPOS(11 + pn / 64, 3), 0x0F00, "0x%06X ", va);
   41a40:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41a43:	c1 e8 06             	shr    $0x6,%eax
   41a46:	89 c2                	mov    %eax,%edx
   41a48:	89 d0                	mov    %edx,%eax
   41a4a:	c1 e0 02             	shl    $0x2,%eax
   41a4d:	01 d0                	add    %edx,%eax
   41a4f:	c1 e0 04             	shl    $0x4,%eax
   41a52:	05 73 03 00 00       	add    $0x373,%eax
   41a57:	89 c7                	mov    %eax,%edi
   41a59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41a5d:	48 89 c1             	mov    %rax,%rcx
   41a60:	ba 96 43 04 00       	mov    $0x44396,%edx
   41a65:	be 00 0f 00 00       	mov    $0xf00,%esi
   41a6a:	b8 00 00 00 00       	mov    $0x0,%eax
   41a6f:	e8 98 24 00 00       	callq  43f0c <console_printf>
        }
        console[CPOS(11 + pn / 64, 12 + pn % 64)] = color;
   41a74:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41a77:	c1 e8 06             	shr    $0x6,%eax
   41a7a:	89 c2                	mov    %eax,%edx
   41a7c:	89 d0                	mov    %edx,%eax
   41a7e:	c1 e0 02             	shl    $0x2,%eax
   41a81:	01 d0                	add    %edx,%eax
   41a83:	c1 e0 04             	shl    $0x4,%eax
   41a86:	89 c2                	mov    %eax,%edx
   41a88:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41a8b:	83 e0 3f             	and    $0x3f,%eax
   41a8e:	01 d0                	add    %edx,%eax
   41a90:	05 7c 03 00 00       	add    $0x37c,%eax
   41a95:	89 c2                	mov    %eax,%edx
   41a97:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   41a9b:	66 89 84 12 00 80 0b 	mov    %ax,0xb8000(%rdx,%rdx,1)
   41aa2:	00 
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   41aa3:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   41aaa:	00 
   41aab:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   41ab2:	00 
   41ab3:	0f 86 72 fe ff ff    	jbe    4192b <memshow_virtual+0x67>
    }
}
   41ab9:	90                   	nop
   41aba:	90                   	nop
   41abb:	c9                   	leaveq 
   41abc:	c3                   	retq   

0000000000041abd <memshow_virtual_animate>:

// memshow_virtual_animate
//    Draw a picture of process virtual memory maps on the CGA console.
//    Starts with process 1, then switches to a new process every 0.25 sec.

void memshow_virtual_animate(void) {
   41abd:	55                   	push   %rbp
   41abe:	48 89 e5             	mov    %rsp,%rbp
   41ac1:	48 83 ec 10          	sub    $0x10,%rsp
    static unsigned last_ticks = 0;
    static int showing = 1;

    // switch to a new process every 0.25 sec
    if (last_ticks == 0 || ticks - last_ticks >= HZ / 2) {
   41ac5:	8b 05 75 d7 00 00    	mov    0xd775(%rip),%eax        # 4f240 <last_ticks.1>
   41acb:	85 c0                	test   %eax,%eax
   41acd:	74 13                	je     41ae2 <memshow_virtual_animate+0x25>
   41acf:	8b 05 4b d3 00 00    	mov    0xd34b(%rip),%eax        # 4ee20 <ticks>
   41ad5:	8b 15 65 d7 00 00    	mov    0xd765(%rip),%edx        # 4f240 <last_ticks.1>
   41adb:	29 d0                	sub    %edx,%eax
   41add:	83 f8 31             	cmp    $0x31,%eax
   41ae0:	76 2c                	jbe    41b0e <memshow_virtual_animate+0x51>
        last_ticks = ticks;
   41ae2:	8b 05 38 d3 00 00    	mov    0xd338(%rip),%eax        # 4ee20 <ticks>
   41ae8:	89 05 52 d7 00 00    	mov    %eax,0xd752(%rip)        # 4f240 <last_ticks.1>
        ++showing;
   41aee:	8b 05 10 35 00 00    	mov    0x3510(%rip),%eax        # 45004 <showing.0>
   41af4:	83 c0 01             	add    $0x1,%eax
   41af7:	89 05 07 35 00 00    	mov    %eax,0x3507(%rip)        # 45004 <showing.0>
    }

    // the current process may have died -- don't display it if so
    while (showing <= 2*NPROC
   41afd:	eb 0f                	jmp    41b0e <memshow_virtual_animate+0x51>
           && processes[showing % NPROC].p_state == P_FREE) {
        ++showing;
   41aff:	8b 05 ff 34 00 00    	mov    0x34ff(%rip),%eax        # 45004 <showing.0>
   41b05:	83 c0 01             	add    $0x1,%eax
   41b08:	89 05 f6 34 00 00    	mov    %eax,0x34f6(%rip)        # 45004 <showing.0>
    while (showing <= 2*NPROC
   41b0e:	8b 05 f0 34 00 00    	mov    0x34f0(%rip),%eax        # 45004 <showing.0>
           && processes[showing % NPROC].p_state == P_FREE) {
   41b14:	83 f8 20             	cmp    $0x20,%eax
   41b17:	7f 2e                	jg     41b47 <memshow_virtual_animate+0x8a>
   41b19:	8b 05 e5 34 00 00    	mov    0x34e5(%rip),%eax        # 45004 <showing.0>
   41b1f:	99                   	cltd   
   41b20:	c1 ea 1c             	shr    $0x1c,%edx
   41b23:	01 d0                	add    %edx,%eax
   41b25:	83 e0 0f             	and    $0xf,%eax
   41b28:	29 d0                	sub    %edx,%eax
   41b2a:	48 63 d0             	movslq %eax,%rdx
   41b2d:	48 89 d0             	mov    %rdx,%rax
   41b30:	48 c1 e0 03          	shl    $0x3,%rax
   41b34:	48 29 d0             	sub    %rdx,%rax
   41b37:	48 c1 e0 05          	shl    $0x5,%rax
   41b3b:	48 05 e8 e0 04 00    	add    $0x4e0e8,%rax
   41b41:	8b 00                	mov    (%rax),%eax
   41b43:	85 c0                	test   %eax,%eax
   41b45:	74 b8                	je     41aff <memshow_virtual_animate+0x42>
    }
    showing = showing % NPROC;
   41b47:	8b 05 b7 34 00 00    	mov    0x34b7(%rip),%eax        # 45004 <showing.0>
   41b4d:	99                   	cltd   
   41b4e:	c1 ea 1c             	shr    $0x1c,%edx
   41b51:	01 d0                	add    %edx,%eax
   41b53:	83 e0 0f             	and    $0xf,%eax
   41b56:	29 d0                	sub    %edx,%eax
   41b58:	89 05 a6 34 00 00    	mov    %eax,0x34a6(%rip)        # 45004 <showing.0>

    if (processes[showing].p_state != P_FREE) {
   41b5e:	8b 05 a0 34 00 00    	mov    0x34a0(%rip),%eax        # 45004 <showing.0>
   41b64:	48 63 d0             	movslq %eax,%rdx
   41b67:	48 89 d0             	mov    %rdx,%rax
   41b6a:	48 c1 e0 03          	shl    $0x3,%rax
   41b6e:	48 29 d0             	sub    %rdx,%rax
   41b71:	48 c1 e0 05          	shl    $0x5,%rax
   41b75:	48 05 e8 e0 04 00    	add    $0x4e0e8,%rax
   41b7b:	8b 00                	mov    (%rax),%eax
   41b7d:	85 c0                	test   %eax,%eax
   41b7f:	74 52                	je     41bd3 <memshow_virtual_animate+0x116>
        char s[4];
        snprintf(s, 4, "%d ", showing);
   41b81:	8b 15 7d 34 00 00    	mov    0x347d(%rip),%edx        # 45004 <showing.0>
   41b87:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
   41b8b:	89 d1                	mov    %edx,%ecx
   41b8d:	ba 04 44 04 00       	mov    $0x44404,%edx
   41b92:	be 04 00 00 00       	mov    $0x4,%esi
   41b97:	48 89 c7             	mov    %rax,%rdi
   41b9a:	b8 00 00 00 00       	mov    $0x0,%eax
   41b9f:	e8 e6 23 00 00       	callq  43f8a <snprintf>
        memshow_virtual(processes[showing].p_pagetable, s);
   41ba4:	8b 05 5a 34 00 00    	mov    0x345a(%rip),%eax        # 45004 <showing.0>
   41baa:	48 63 d0             	movslq %eax,%rdx
   41bad:	48 89 d0             	mov    %rdx,%rax
   41bb0:	48 c1 e0 03          	shl    $0x3,%rax
   41bb4:	48 29 d0             	sub    %rdx,%rax
   41bb7:	48 c1 e0 05          	shl    $0x5,%rax
   41bbb:	48 05 f0 e0 04 00    	add    $0x4e0f0,%rax
   41bc1:	48 8b 00             	mov    (%rax),%rax
   41bc4:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
   41bc8:	48 89 d6             	mov    %rdx,%rsi
   41bcb:	48 89 c7             	mov    %rax,%rdi
   41bce:	e8 f1 fc ff ff       	callq  418c4 <memshow_virtual>
    }
}
   41bd3:	90                   	nop
   41bd4:	c9                   	leaveq 
   41bd5:	c3                   	retq   

0000000000041bd6 <hardware_init>:

static void segments_init(void);
static void interrupt_init(void);
extern void virtual_memory_init(void);

void hardware_init(void) {
   41bd6:	55                   	push   %rbp
   41bd7:	48 89 e5             	mov    %rsp,%rbp
    segments_init();
   41bda:	e8 53 01 00 00       	callq  41d32 <segments_init>
    interrupt_init();
   41bdf:	e8 d4 03 00 00       	callq  41fb8 <interrupt_init>
    virtual_memory_init();
   41be4:	e8 e7 0f 00 00       	callq  42bd0 <virtual_memory_init>
}
   41be9:	90                   	nop
   41bea:	5d                   	pop    %rbp
   41beb:	c3                   	retq   

0000000000041bec <set_app_segment>:
#define SEGSEL_TASKSTATE        0x28            // task state segment

// Segments
static uint64_t segments[7];

static void set_app_segment(uint64_t* segment, uint64_t type, int dpl) {
   41bec:	55                   	push   %rbp
   41bed:	48 89 e5             	mov    %rsp,%rbp
   41bf0:	48 83 ec 18          	sub    $0x18,%rsp
   41bf4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41bf8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41bfc:	89 55 ec             	mov    %edx,-0x14(%rbp)
    *segment = type
        | X86SEG_S                    // code/data segment
        | ((uint64_t) dpl << 45)
   41bff:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41c02:	48 98                	cltq   
   41c04:	48 c1 e0 2d          	shl    $0x2d,%rax
   41c08:	48 0b 45 f0          	or     -0x10(%rbp),%rax
        | X86SEG_P;                   // segment present
   41c0c:	48 ba 00 00 00 00 00 	movabs $0x900000000000,%rdx
   41c13:	90 00 00 
   41c16:	48 09 c2             	or     %rax,%rdx
    *segment = type
   41c19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41c1d:	48 89 10             	mov    %rdx,(%rax)
}
   41c20:	90                   	nop
   41c21:	c9                   	leaveq 
   41c22:	c3                   	retq   

0000000000041c23 <set_sys_segment>:

static void set_sys_segment(uint64_t* segment, uint64_t type, int dpl,
                            uintptr_t addr, size_t size) {
   41c23:	55                   	push   %rbp
   41c24:	48 89 e5             	mov    %rsp,%rbp
   41c27:	48 83 ec 28          	sub    $0x28,%rsp
   41c2b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41c2f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41c33:	89 55 ec             	mov    %edx,-0x14(%rbp)
   41c36:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
   41c3a:	4c 89 45 d8          	mov    %r8,-0x28(%rbp)
    segment[0] = ((addr & 0x0000000000FFFFFFUL) << 16)
   41c3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41c42:	48 c1 e0 10          	shl    $0x10,%rax
   41c46:	48 89 c2             	mov    %rax,%rdx
   41c49:	48 b8 00 00 ff ff ff 	movabs $0xffffff0000,%rax
   41c50:	00 00 00 
   41c53:	48 21 c2             	and    %rax,%rdx
        | ((addr & 0x00000000FF000000UL) << 32)
   41c56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41c5a:	48 c1 e0 20          	shl    $0x20,%rax
   41c5e:	48 89 c1             	mov    %rax,%rcx
   41c61:	48 b8 00 00 00 00 00 	movabs $0xff00000000000000,%rax
   41c68:	00 00 ff 
   41c6b:	48 21 c8             	and    %rcx,%rax
   41c6e:	48 09 c2             	or     %rax,%rdx
        | ((size - 1) & 0x0FFFFUL)
   41c71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   41c75:	48 83 e8 01          	sub    $0x1,%rax
   41c79:	0f b7 c0             	movzwl %ax,%eax
        | (((size - 1) & 0xF0000UL) << 48)
   41c7c:	48 09 d0             	or     %rdx,%rax
        | type
   41c7f:	48 0b 45 f0          	or     -0x10(%rbp),%rax
   41c83:	48 89 c2             	mov    %rax,%rdx
        | ((uint64_t) dpl << 45)
   41c86:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41c89:	48 98                	cltq   
   41c8b:	48 c1 e0 2d          	shl    $0x2d,%rax
   41c8f:	48 09 c2             	or     %rax,%rdx
        | X86SEG_P;                   // segment present
   41c92:	48 b8 00 00 00 00 00 	movabs $0x800000000000,%rax
   41c99:	80 00 00 
   41c9c:	48 09 c2             	or     %rax,%rdx
    segment[0] = ((addr & 0x0000000000FFFFFFUL) << 16)
   41c9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41ca3:	48 89 10             	mov    %rdx,(%rax)
    segment[1] = addr >> 32;
   41ca6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41caa:	48 83 c0 08          	add    $0x8,%rax
   41cae:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   41cb2:	48 c1 ea 20          	shr    $0x20,%rdx
   41cb6:	48 89 10             	mov    %rdx,(%rax)
}
   41cb9:	90                   	nop
   41cba:	c9                   	leaveq 
   41cbb:	c3                   	retq   

0000000000041cbc <set_gate>:

// Processor state for taking an interrupt
static x86_64_taskstate kernel_task_descriptor;

static void set_gate(x86_64_gatedescriptor* gate, uint64_t type, int dpl,
                     uintptr_t function) {
   41cbc:	55                   	push   %rbp
   41cbd:	48 89 e5             	mov    %rsp,%rbp
   41cc0:	48 83 ec 20          	sub    $0x20,%rsp
   41cc4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41cc8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41ccc:	89 55 ec             	mov    %edx,-0x14(%rbp)
   41ccf:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
    gate->gd_low = (function & 0x000000000000FFFFUL)
   41cd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41cd7:	0f b7 c0             	movzwl %ax,%eax
        | (SEGSEL_KERN_CODE << 16)
        | type
   41cda:	48 0b 45 f0          	or     -0x10(%rbp),%rax
   41cde:	48 89 c2             	mov    %rax,%rdx
        | ((uint64_t) dpl << 45)
   41ce1:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41ce4:	48 98                	cltq   
   41ce6:	48 c1 e0 2d          	shl    $0x2d,%rax
   41cea:	48 09 c2             	or     %rax,%rdx
        | X86SEG_P
        | ((function & 0x00000000FFFF0000UL) << 32);
   41ced:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41cf1:	48 c1 e0 20          	shl    $0x20,%rax
   41cf5:	48 89 c1             	mov    %rax,%rcx
   41cf8:	48 b8 00 00 00 00 00 	movabs $0xffff000000000000,%rax
   41cff:	00 ff ff 
   41d02:	48 21 c8             	and    %rcx,%rax
   41d05:	48 09 c2             	or     %rax,%rdx
   41d08:	48 b8 00 00 08 00 00 	movabs $0x800000080000,%rax
   41d0f:	80 00 00 
   41d12:	48 09 c2             	or     %rax,%rdx
    gate->gd_low = (function & 0x000000000000FFFFUL)
   41d15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41d19:	48 89 10             	mov    %rdx,(%rax)
    gate->gd_high = function >> 32;
   41d1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41d20:	48 c1 e8 20          	shr    $0x20,%rax
   41d24:	48 89 c2             	mov    %rax,%rdx
   41d27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41d2b:	48 89 50 08          	mov    %rdx,0x8(%rax)
}
   41d2f:	90                   	nop
   41d30:	c9                   	leaveq 
   41d31:	c3                   	retq   

0000000000041d32 <segments_init>:
extern void default_int_handler(void);
extern void gpf_int_handler(void);
extern void pagefault_int_handler(void);
extern void timer_int_handler(void);

void segments_init(void) {
   41d32:	55                   	push   %rbp
   41d33:	48 89 e5             	mov    %rsp,%rbp
   41d36:	48 83 ec 40          	sub    $0x40,%rsp
    // Segments for kernel & user code & data
    // The privilege level, which can be 0 or 3, differentiates between
    // kernel and user code. (Data segments are unused in WeensyOS.)
    segments[0] = 0;
   41d3a:	48 c7 05 1b d5 00 00 	movq   $0x0,0xd51b(%rip)        # 4f260 <segments>
   41d41:	00 00 00 00 
    set_app_segment(&segments[SEGSEL_KERN_CODE >> 3], X86SEG_X | X86SEG_L, 0);
   41d45:	ba 00 00 00 00       	mov    $0x0,%edx
   41d4a:	48 b8 00 00 00 00 00 	movabs $0x20080000000000,%rax
   41d51:	08 20 00 
   41d54:	48 89 c6             	mov    %rax,%rsi
   41d57:	bf 68 f2 04 00       	mov    $0x4f268,%edi
   41d5c:	e8 8b fe ff ff       	callq  41bec <set_app_segment>
    set_app_segment(&segments[SEGSEL_APP_CODE >> 3], X86SEG_X | X86SEG_L, 3);
   41d61:	ba 03 00 00 00       	mov    $0x3,%edx
   41d66:	48 b8 00 00 00 00 00 	movabs $0x20080000000000,%rax
   41d6d:	08 20 00 
   41d70:	48 89 c6             	mov    %rax,%rsi
   41d73:	bf 70 f2 04 00       	mov    $0x4f270,%edi
   41d78:	e8 6f fe ff ff       	callq  41bec <set_app_segment>
    set_app_segment(&segments[SEGSEL_KERN_DATA >> 3], X86SEG_W, 0);
   41d7d:	ba 00 00 00 00       	mov    $0x0,%edx
   41d82:	48 b8 00 00 00 00 00 	movabs $0x20000000000,%rax
   41d89:	02 00 00 
   41d8c:	48 89 c6             	mov    %rax,%rsi
   41d8f:	bf 78 f2 04 00       	mov    $0x4f278,%edi
   41d94:	e8 53 fe ff ff       	callq  41bec <set_app_segment>
    set_app_segment(&segments[SEGSEL_APP_DATA >> 3], X86SEG_W, 3);
   41d99:	ba 03 00 00 00       	mov    $0x3,%edx
   41d9e:	48 b8 00 00 00 00 00 	movabs $0x20000000000,%rax
   41da5:	02 00 00 
   41da8:	48 89 c6             	mov    %rax,%rsi
   41dab:	bf 80 f2 04 00       	mov    $0x4f280,%edi
   41db0:	e8 37 fe ff ff       	callq  41bec <set_app_segment>
    set_sys_segment(&segments[SEGSEL_TASKSTATE >> 3], X86SEG_TSS, 0,
   41db5:	b8 a0 02 05 00       	mov    $0x502a0,%eax
   41dba:	41 b8 60 00 00 00    	mov    $0x60,%r8d
   41dc0:	48 89 c1             	mov    %rax,%rcx
   41dc3:	ba 00 00 00 00       	mov    $0x0,%edx
   41dc8:	48 b8 00 00 00 00 00 	movabs $0x90000000000,%rax
   41dcf:	09 00 00 
   41dd2:	48 89 c6             	mov    %rax,%rsi
   41dd5:	bf 88 f2 04 00       	mov    $0x4f288,%edi
   41dda:	e8 44 fe ff ff       	callq  41c23 <set_sys_segment>
                    (uintptr_t) &kernel_task_descriptor,
                    sizeof(kernel_task_descriptor));

    x86_64_pseudodescriptor gdt;
    gdt.pseudod_limit = sizeof(segments) - 1;
   41ddf:	66 c7 45 d6 37 00    	movw   $0x37,-0x2a(%rbp)
    gdt.pseudod_base = (uint64_t) segments;
   41de5:	b8 60 f2 04 00       	mov    $0x4f260,%eax
   41dea:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

    // Kernel task descriptor lets us receive interrupts
    memset(&kernel_task_descriptor, 0, sizeof(kernel_task_descriptor));
   41dee:	ba 60 00 00 00       	mov    $0x60,%edx
   41df3:	be 00 00 00 00       	mov    $0x0,%esi
   41df8:	bf a0 02 05 00       	mov    $0x502a0,%edi
   41dfd:	e8 d5 18 00 00       	callq  436d7 <memset>
    kernel_task_descriptor.ts_rsp[0] = KERNEL_STACK_TOP;
   41e02:	48 c7 05 97 e4 00 00 	movq   $0x80000,0xe497(%rip)        # 502a4 <kernel_task_descriptor+0x4>
   41e09:	00 00 08 00 

    // Interrupt handler; most interrupts are effectively ignored
    memset(interrupt_descriptors, 0, sizeof(interrupt_descriptors));
   41e0d:	ba 00 10 00 00       	mov    $0x1000,%edx
   41e12:	be 00 00 00 00       	mov    $0x0,%esi
   41e17:	bf a0 f2 04 00       	mov    $0x4f2a0,%edi
   41e1c:	e8 b6 18 00 00       	callq  436d7 <memset>
    for (unsigned i = 16; i < arraysize(interrupt_descriptors); ++i) {
   41e21:	c7 45 fc 10 00 00 00 	movl   $0x10,-0x4(%rbp)
   41e28:	eb 30                	jmp    41e5a <segments_init+0x128>
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 0,
   41e2a:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   41e2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41e32:	48 c1 e0 04          	shl    $0x4,%rax
   41e36:	48 05 a0 f2 04 00    	add    $0x4f2a0,%rax
   41e3c:	48 89 d1             	mov    %rdx,%rcx
   41e3f:	ba 00 00 00 00       	mov    $0x0,%edx
   41e44:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41e4b:	0e 00 00 
   41e4e:	48 89 c7             	mov    %rax,%rdi
   41e51:	e8 66 fe ff ff       	callq  41cbc <set_gate>
    for (unsigned i = 16; i < arraysize(interrupt_descriptors); ++i) {
   41e56:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41e5a:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
   41e61:	76 c7                	jbe    41e2a <segments_init+0xf8>
                 (uint64_t) default_int_handler);
    }

    // Timer interrupt
    set_gate(&interrupt_descriptors[INT_TIMER], X86GATE_INTERRUPT, 0,
   41e63:	b8 36 00 04 00       	mov    $0x40036,%eax
   41e68:	48 89 c1             	mov    %rax,%rcx
   41e6b:	ba 00 00 00 00       	mov    $0x0,%edx
   41e70:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   41e77:	0e 00 00 
   41e7a:	48 89 c6             	mov    %rax,%rsi
   41e7d:	bf a0 f4 04 00       	mov    $0x4f4a0,%edi
   41e82:	e8 35 fe ff ff       	callq  41cbc <set_gate>
             (uint64_t) timer_int_handler);

    // GPF and page fault
    set_gate(&interrupt_descriptors[INT_GPF], X86GATE_INTERRUPT, 0,
   41e87:	b8 2e 00 04 00       	mov    $0x4002e,%eax
   41e8c:	48 89 c1             	mov    %rax,%rcx
   41e8f:	ba 00 00 00 00       	mov    $0x0,%edx
   41e94:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   41e9b:	0e 00 00 
   41e9e:	48 89 c6             	mov    %rax,%rsi
   41ea1:	bf 70 f3 04 00       	mov    $0x4f370,%edi
   41ea6:	e8 11 fe ff ff       	callq  41cbc <set_gate>
             (uint64_t) gpf_int_handler);
    set_gate(&interrupt_descriptors[INT_PAGEFAULT], X86GATE_INTERRUPT, 0,
   41eab:	b8 32 00 04 00       	mov    $0x40032,%eax
   41eb0:	48 89 c1             	mov    %rax,%rcx
   41eb3:	ba 00 00 00 00       	mov    $0x0,%edx
   41eb8:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   41ebf:	0e 00 00 
   41ec2:	48 89 c6             	mov    %rax,%rsi
   41ec5:	bf 80 f3 04 00       	mov    $0x4f380,%edi
   41eca:	e8 ed fd ff ff       	callq  41cbc <set_gate>
             (uint64_t) pagefault_int_handler);

    // System calls get special handling.
    // Note that the last argument is '3'.  This means that unprivileged
    // (level-3) applications may generate these interrupts.
    for (unsigned i = INT_SYS; i < INT_SYS + 16; ++i) {
   41ecf:	c7 45 f8 30 00 00 00 	movl   $0x30,-0x8(%rbp)
   41ed6:	eb 3e                	jmp    41f16 <segments_init+0x1e4>
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 3,
                 (uint64_t) sys_int_handlers[i - INT_SYS]);
   41ed8:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41edb:	83 e8 30             	sub    $0x30,%eax
   41ede:	89 c0                	mov    %eax,%eax
   41ee0:	48 8b 04 c5 e7 00 04 	mov    0x400e7(,%rax,8),%rax
   41ee7:	00 
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 3,
   41ee8:	48 89 c2             	mov    %rax,%rdx
   41eeb:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41eee:	48 c1 e0 04          	shl    $0x4,%rax
   41ef2:	48 05 a0 f2 04 00    	add    $0x4f2a0,%rax
   41ef8:	48 89 d1             	mov    %rdx,%rcx
   41efb:	ba 03 00 00 00       	mov    $0x3,%edx
   41f00:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41f07:	0e 00 00 
   41f0a:	48 89 c7             	mov    %rax,%rdi
   41f0d:	e8 aa fd ff ff       	callq  41cbc <set_gate>
    for (unsigned i = INT_SYS; i < INT_SYS + 16; ++i) {
   41f12:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   41f16:	83 7d f8 3f          	cmpl   $0x3f,-0x8(%rbp)
   41f1a:	76 bc                	jbe    41ed8 <segments_init+0x1a6>
    }

    x86_64_pseudodescriptor idt;
    idt.pseudod_limit = sizeof(interrupt_descriptors) - 1;
   41f1c:	66 c7 45 cc ff 0f    	movw   $0xfff,-0x34(%rbp)
    idt.pseudod_base = (uint64_t) interrupt_descriptors;
   41f22:	b8 a0 f2 04 00       	mov    $0x4f2a0,%eax
   41f27:	48 89 45 ce          	mov    %rax,-0x32(%rbp)

    // Reload segment pointers
    asm volatile("lgdt %0\n\t"
   41f2b:	b8 28 00 00 00       	mov    $0x28,%eax
   41f30:	0f 01 55 d6          	lgdt   -0x2a(%rbp)
   41f34:	0f 00 d8             	ltr    %ax
   41f37:	0f 01 5d cc          	lidt   -0x34(%rbp)
    asm volatile("movq %%cr0,%0" : "=r" (val));
   41f3b:	0f 20 c0             	mov    %cr0,%rax
   41f3e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    return val;
   41f42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
                     "r" ((uint16_t) SEGSEL_TASKSTATE),
                     "m" (idt)
                 : "memory");

    // Set up control registers: check alignment
    uint32_t cr0 = rcr0();
   41f46:	89 45 f4             	mov    %eax,-0xc(%rbp)
    cr0 |= CR0_PE | CR0_PG | CR0_WP | CR0_AM | CR0_MP | CR0_NE;
   41f49:	81 4d f4 23 00 05 80 	orl    $0x80050023,-0xc(%rbp)
   41f50:	8b 45 f4             	mov    -0xc(%rbp),%eax
   41f53:	89 45 f0             	mov    %eax,-0x10(%rbp)
    uint64_t xval = val;
   41f56:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41f59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    asm volatile("movq %0,%%cr0" : : "r" (xval));
   41f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41f61:	0f 22 c0             	mov    %rax,%cr0
}
   41f64:	90                   	nop
    lcr0(cr0);
}
   41f65:	90                   	nop
   41f66:	c9                   	leaveq 
   41f67:	c3                   	retq   

0000000000041f68 <interrupt_mask>:
#define TIMER_FREQ      1193182
#define TIMER_DIV(x)    ((TIMER_FREQ+(x)/2)/(x))

static uint16_t interrupts_enabled;

static void interrupt_mask(void) {
   41f68:	55                   	push   %rbp
   41f69:	48 89 e5             	mov    %rsp,%rbp
   41f6c:	48 83 ec 20          	sub    $0x20,%rsp
    uint16_t masked = ~interrupts_enabled;
   41f70:	0f b7 05 89 e3 00 00 	movzwl 0xe389(%rip),%eax        # 50300 <interrupts_enabled>
   41f77:	f7 d0                	not    %eax
   41f79:	66 89 45 fe          	mov    %ax,-0x2(%rbp)
    outb(IO_PIC1+1, masked & 0xFF);
   41f7d:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
   41f81:	0f b6 c0             	movzbl %al,%eax
   41f84:	c7 45 f0 21 00 00 00 	movl   $0x21,-0x10(%rbp)
   41f8b:	88 45 ef             	mov    %al,-0x11(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41f8e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   41f92:	8b 55 f0             	mov    -0x10(%rbp),%edx
   41f95:	ee                   	out    %al,(%dx)
}
   41f96:	90                   	nop
    outb(IO_PIC2+1, (masked >> 8) & 0xFF);
   41f97:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
   41f9b:	66 c1 e8 08          	shr    $0x8,%ax
   41f9f:	0f b6 c0             	movzbl %al,%eax
   41fa2:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%rbp)
   41fa9:	88 45 f7             	mov    %al,-0x9(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41fac:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   41fb0:	8b 55 f8             	mov    -0x8(%rbp),%edx
   41fb3:	ee                   	out    %al,(%dx)
}
   41fb4:	90                   	nop
}
   41fb5:	90                   	nop
   41fb6:	c9                   	leaveq 
   41fb7:	c3                   	retq   

0000000000041fb8 <interrupt_init>:

void interrupt_init(void) {
   41fb8:	55                   	push   %rbp
   41fb9:	48 89 e5             	mov    %rsp,%rbp
   41fbc:	48 83 ec 60          	sub    $0x60,%rsp
    // mask all interrupts
    interrupts_enabled = 0;
   41fc0:	66 c7 05 37 e3 00 00 	movw   $0x0,0xe337(%rip)        # 50300 <interrupts_enabled>
   41fc7:	00 00 
    interrupt_mask();
   41fc9:	e8 9a ff ff ff       	callq  41f68 <interrupt_mask>
   41fce:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%rbp)
   41fd5:	c6 45 a3 11          	movb   $0x11,-0x5d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41fd9:	0f b6 45 a3          	movzbl -0x5d(%rbp),%eax
   41fdd:	8b 55 a4             	mov    -0x5c(%rbp),%edx
   41fe0:	ee                   	out    %al,(%dx)
}
   41fe1:	90                   	nop
   41fe2:	c7 45 ac 21 00 00 00 	movl   $0x21,-0x54(%rbp)
   41fe9:	c6 45 ab 20          	movb   $0x20,-0x55(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41fed:	0f b6 45 ab          	movzbl -0x55(%rbp),%eax
   41ff1:	8b 55 ac             	mov    -0x54(%rbp),%edx
   41ff4:	ee                   	out    %al,(%dx)
}
   41ff5:	90                   	nop
   41ff6:	c7 45 b4 21 00 00 00 	movl   $0x21,-0x4c(%rbp)
   41ffd:	c6 45 b3 04          	movb   $0x4,-0x4d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42001:	0f b6 45 b3          	movzbl -0x4d(%rbp),%eax
   42005:	8b 55 b4             	mov    -0x4c(%rbp),%edx
   42008:	ee                   	out    %al,(%dx)
}
   42009:	90                   	nop
   4200a:	c7 45 bc 21 00 00 00 	movl   $0x21,-0x44(%rbp)
   42011:	c6 45 bb 03          	movb   $0x3,-0x45(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42015:	0f b6 45 bb          	movzbl -0x45(%rbp),%eax
   42019:	8b 55 bc             	mov    -0x44(%rbp),%edx
   4201c:	ee                   	out    %al,(%dx)
}
   4201d:	90                   	nop
   4201e:	c7 45 c4 a0 00 00 00 	movl   $0xa0,-0x3c(%rbp)
   42025:	c6 45 c3 11          	movb   $0x11,-0x3d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42029:	0f b6 45 c3          	movzbl -0x3d(%rbp),%eax
   4202d:	8b 55 c4             	mov    -0x3c(%rbp),%edx
   42030:	ee                   	out    %al,(%dx)
}
   42031:	90                   	nop
   42032:	c7 45 cc a1 00 00 00 	movl   $0xa1,-0x34(%rbp)
   42039:	c6 45 cb 28          	movb   $0x28,-0x35(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4203d:	0f b6 45 cb          	movzbl -0x35(%rbp),%eax
   42041:	8b 55 cc             	mov    -0x34(%rbp),%edx
   42044:	ee                   	out    %al,(%dx)
}
   42045:	90                   	nop
   42046:	c7 45 d4 a1 00 00 00 	movl   $0xa1,-0x2c(%rbp)
   4204d:	c6 45 d3 02          	movb   $0x2,-0x2d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42051:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
   42055:	8b 55 d4             	mov    -0x2c(%rbp),%edx
   42058:	ee                   	out    %al,(%dx)
}
   42059:	90                   	nop
   4205a:	c7 45 dc a1 00 00 00 	movl   $0xa1,-0x24(%rbp)
   42061:	c6 45 db 01          	movb   $0x1,-0x25(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42065:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
   42069:	8b 55 dc             	mov    -0x24(%rbp),%edx
   4206c:	ee                   	out    %al,(%dx)
}
   4206d:	90                   	nop
   4206e:	c7 45 e4 20 00 00 00 	movl   $0x20,-0x1c(%rbp)
   42075:	c6 45 e3 68          	movb   $0x68,-0x1d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42079:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
   4207d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   42080:	ee                   	out    %al,(%dx)
}
   42081:	90                   	nop
   42082:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%rbp)
   42089:	c6 45 eb 0a          	movb   $0xa,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4208d:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   42091:	8b 55 ec             	mov    -0x14(%rbp),%edx
   42094:	ee                   	out    %al,(%dx)
}
   42095:	90                   	nop
   42096:	c7 45 f4 a0 00 00 00 	movl   $0xa0,-0xc(%rbp)
   4209d:	c6 45 f3 68          	movb   $0x68,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   420a1:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   420a5:	8b 55 f4             	mov    -0xc(%rbp),%edx
   420a8:	ee                   	out    %al,(%dx)
}
   420a9:	90                   	nop
   420aa:	c7 45 fc a0 00 00 00 	movl   $0xa0,-0x4(%rbp)
   420b1:	c6 45 fb 0a          	movb   $0xa,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   420b5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   420b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
   420bc:	ee                   	out    %al,(%dx)
}
   420bd:	90                   	nop

    outb(IO_PIC2, 0x68);               /* OCW3 */
    outb(IO_PIC2, 0x0a);               /* OCW3 */

    // re-disable interrupts
    interrupt_mask();
   420be:	e8 a5 fe ff ff       	callq  41f68 <interrupt_mask>
}
   420c3:	90                   	nop
   420c4:	c9                   	leaveq 
   420c5:	c3                   	retq   

00000000000420c6 <timer_init>:

// timer_init(rate)
//    Set the timer interrupt to fire `rate` times a second. Disables the
//    timer interrupt if `rate <= 0`.

void timer_init(int rate) {
   420c6:	55                   	push   %rbp
   420c7:	48 89 e5             	mov    %rsp,%rbp
   420ca:	48 83 ec 28          	sub    $0x28,%rsp
   420ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
    if (rate > 0) {
   420d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   420d5:	0f 8e 9f 00 00 00    	jle    4217a <timer_init+0xb4>
   420db:	c7 45 ec 43 00 00 00 	movl   $0x43,-0x14(%rbp)
   420e2:	c6 45 eb 34          	movb   $0x34,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   420e6:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   420ea:	8b 55 ec             	mov    -0x14(%rbp),%edx
   420ed:	ee                   	out    %al,(%dx)
}
   420ee:	90                   	nop
        outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
        outb(IO_TIMER1, TIMER_DIV(rate) % 256);
   420ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
   420f2:	89 c2                	mov    %eax,%edx
   420f4:	c1 ea 1f             	shr    $0x1f,%edx
   420f7:	01 d0                	add    %edx,%eax
   420f9:	d1 f8                	sar    %eax
   420fb:	05 de 34 12 00       	add    $0x1234de,%eax
   42100:	99                   	cltd   
   42101:	f7 7d dc             	idivl  -0x24(%rbp)
   42104:	89 c2                	mov    %eax,%edx
   42106:	89 d0                	mov    %edx,%eax
   42108:	c1 f8 1f             	sar    $0x1f,%eax
   4210b:	c1 e8 18             	shr    $0x18,%eax
   4210e:	89 c1                	mov    %eax,%ecx
   42110:	8d 04 0a             	lea    (%rdx,%rcx,1),%eax
   42113:	0f b6 c0             	movzbl %al,%eax
   42116:	29 c8                	sub    %ecx,%eax
   42118:	0f b6 c0             	movzbl %al,%eax
   4211b:	c7 45 f4 40 00 00 00 	movl   $0x40,-0xc(%rbp)
   42122:	88 45 f3             	mov    %al,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42125:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   42129:	8b 55 f4             	mov    -0xc(%rbp),%edx
   4212c:	ee                   	out    %al,(%dx)
}
   4212d:	90                   	nop
        outb(IO_TIMER1, TIMER_DIV(rate) / 256);
   4212e:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42131:	89 c2                	mov    %eax,%edx
   42133:	c1 ea 1f             	shr    $0x1f,%edx
   42136:	01 d0                	add    %edx,%eax
   42138:	d1 f8                	sar    %eax
   4213a:	05 de 34 12 00       	add    $0x1234de,%eax
   4213f:	99                   	cltd   
   42140:	f7 7d dc             	idivl  -0x24(%rbp)
   42143:	8d 90 ff 00 00 00    	lea    0xff(%rax),%edx
   42149:	85 c0                	test   %eax,%eax
   4214b:	0f 48 c2             	cmovs  %edx,%eax
   4214e:	c1 f8 08             	sar    $0x8,%eax
   42151:	0f b6 c0             	movzbl %al,%eax
   42154:	c7 45 fc 40 00 00 00 	movl   $0x40,-0x4(%rbp)
   4215b:	88 45 fb             	mov    %al,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4215e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42162:	8b 55 fc             	mov    -0x4(%rbp),%edx
   42165:	ee                   	out    %al,(%dx)
}
   42166:	90                   	nop
        interrupts_enabled |= 1 << (INT_TIMER - INT_HARDWARE);
   42167:	0f b7 05 92 e1 00 00 	movzwl 0xe192(%rip),%eax        # 50300 <interrupts_enabled>
   4216e:	83 c8 01             	or     $0x1,%eax
   42171:	66 89 05 88 e1 00 00 	mov    %ax,0xe188(%rip)        # 50300 <interrupts_enabled>
   42178:	eb 11                	jmp    4218b <timer_init+0xc5>
    } else {
        interrupts_enabled &= ~(1 << (INT_TIMER - INT_HARDWARE));
   4217a:	0f b7 05 7f e1 00 00 	movzwl 0xe17f(%rip),%eax        # 50300 <interrupts_enabled>
   42181:	83 e0 fe             	and    $0xfffffffe,%eax
   42184:	66 89 05 75 e1 00 00 	mov    %ax,0xe175(%rip)        # 50300 <interrupts_enabled>
    }
    interrupt_mask();
   4218b:	e8 d8 fd ff ff       	callq  41f68 <interrupt_mask>
}
   42190:	90                   	nop
   42191:	c9                   	leaveq 
   42192:	c3                   	retq   

0000000000042193 <physical_memory_isreserved>:
//    Returns non-zero iff `pa` is a reserved physical address.

#define IOPHYSMEM       0x000A0000
#define EXTPHYSMEM      0x00100000

int physical_memory_isreserved(uintptr_t pa) {
   42193:	55                   	push   %rbp
   42194:	48 89 e5             	mov    %rsp,%rbp
   42197:	48 83 ec 08          	sub    $0x8,%rsp
   4219b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    return pa == 0 || (pa >= IOPHYSMEM && pa < EXTPHYSMEM);
   4219f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   421a4:	74 14                	je     421ba <physical_memory_isreserved+0x27>
   421a6:	48 81 7d f8 ff ff 09 	cmpq   $0x9ffff,-0x8(%rbp)
   421ad:	00 
   421ae:	76 11                	jbe    421c1 <physical_memory_isreserved+0x2e>
   421b0:	48 81 7d f8 ff ff 0f 	cmpq   $0xfffff,-0x8(%rbp)
   421b7:	00 
   421b8:	77 07                	ja     421c1 <physical_memory_isreserved+0x2e>
   421ba:	b8 01 00 00 00       	mov    $0x1,%eax
   421bf:	eb 05                	jmp    421c6 <physical_memory_isreserved+0x33>
   421c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
   421c6:	c9                   	leaveq 
   421c7:	c3                   	retq   

00000000000421c8 <pci_make_configaddr>:


// pci_make_configaddr(bus, slot, func)
//    Construct a PCI configuration space address from parts.

static int pci_make_configaddr(int bus, int slot, int func) {
   421c8:	55                   	push   %rbp
   421c9:	48 89 e5             	mov    %rsp,%rbp
   421cc:	48 83 ec 10          	sub    $0x10,%rsp
   421d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
   421d3:	89 75 f8             	mov    %esi,-0x8(%rbp)
   421d6:	89 55 f4             	mov    %edx,-0xc(%rbp)
    return (bus << 16) | (slot << 11) | (func << 8);
   421d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
   421dc:	c1 e0 10             	shl    $0x10,%eax
   421df:	89 c2                	mov    %eax,%edx
   421e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
   421e4:	c1 e0 0b             	shl    $0xb,%eax
   421e7:	09 c2                	or     %eax,%edx
   421e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
   421ec:	c1 e0 08             	shl    $0x8,%eax
   421ef:	09 d0                	or     %edx,%eax
}
   421f1:	c9                   	leaveq 
   421f2:	c3                   	retq   

00000000000421f3 <pci_config_readl>:
//    Read a 32-bit word in PCI configuration space.

#define PCI_HOST_BRIDGE_CONFIG_ADDR 0xCF8
#define PCI_HOST_BRIDGE_CONFIG_DATA 0xCFC

static uint32_t pci_config_readl(int configaddr, int offset) {
   421f3:	55                   	push   %rbp
   421f4:	48 89 e5             	mov    %rsp,%rbp
   421f7:	48 83 ec 18          	sub    $0x18,%rsp
   421fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
   421fe:	89 75 e8             	mov    %esi,-0x18(%rbp)
    outl(PCI_HOST_BRIDGE_CONFIG_ADDR, 0x80000000 | configaddr | offset);
   42201:	8b 55 ec             	mov    -0x14(%rbp),%edx
   42204:	8b 45 e8             	mov    -0x18(%rbp),%eax
   42207:	09 d0                	or     %edx,%eax
   42209:	0d 00 00 00 80       	or     $0x80000000,%eax
   4220e:	c7 45 f4 f8 0c 00 00 	movl   $0xcf8,-0xc(%rbp)
   42215:	89 45 f0             	mov    %eax,-0x10(%rbp)
    asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
   42218:	8b 45 f0             	mov    -0x10(%rbp),%eax
   4221b:	8b 55 f4             	mov    -0xc(%rbp),%edx
   4221e:	ef                   	out    %eax,(%dx)
}
   4221f:	90                   	nop
   42220:	c7 45 fc fc 0c 00 00 	movl   $0xcfc,-0x4(%rbp)
    asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
   42227:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4222a:	89 c2                	mov    %eax,%edx
   4222c:	ed                   	in     (%dx),%eax
   4222d:	89 45 f8             	mov    %eax,-0x8(%rbp)
    return data;
   42230:	8b 45 f8             	mov    -0x8(%rbp),%eax
    return inl(PCI_HOST_BRIDGE_CONFIG_DATA);
}
   42233:	c9                   	leaveq 
   42234:	c3                   	retq   

0000000000042235 <pci_find_device>:

// pci_find_device
//    Search for a PCI device matching `vendor` and `device`. Return
//    the config base address or -1 if no device was found.

static int pci_find_device(int vendor, int device) {
   42235:	55                   	push   %rbp
   42236:	48 89 e5             	mov    %rsp,%rbp
   42239:	48 83 ec 28          	sub    $0x28,%rsp
   4223d:	89 7d dc             	mov    %edi,-0x24(%rbp)
   42240:	89 75 d8             	mov    %esi,-0x28(%rbp)
    for (int bus = 0; bus != 256; ++bus) {
   42243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4224a:	eb 73                	jmp    422bf <pci_find_device+0x8a>
        for (int slot = 0; slot != 32; ++slot) {
   4224c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   42253:	eb 60                	jmp    422b5 <pci_find_device+0x80>
            for (int func = 0; func != 8; ++func) {
   42255:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   4225c:	eb 4a                	jmp    422a8 <pci_find_device+0x73>
                int configaddr = pci_make_configaddr(bus, slot, func);
   4225e:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42261:	8b 4d f8             	mov    -0x8(%rbp),%ecx
   42264:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42267:	89 ce                	mov    %ecx,%esi
   42269:	89 c7                	mov    %eax,%edi
   4226b:	e8 58 ff ff ff       	callq  421c8 <pci_make_configaddr>
   42270:	89 45 f0             	mov    %eax,-0x10(%rbp)
                uint32_t vendor_device = pci_config_readl(configaddr, 0);
   42273:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42276:	be 00 00 00 00       	mov    $0x0,%esi
   4227b:	89 c7                	mov    %eax,%edi
   4227d:	e8 71 ff ff ff       	callq  421f3 <pci_config_readl>
   42282:	89 45 ec             	mov    %eax,-0x14(%rbp)
                if (vendor_device == (uint32_t) (vendor | (device << 16))) {
   42285:	8b 45 d8             	mov    -0x28(%rbp),%eax
   42288:	c1 e0 10             	shl    $0x10,%eax
   4228b:	0b 45 dc             	or     -0x24(%rbp),%eax
   4228e:	39 45 ec             	cmp    %eax,-0x14(%rbp)
   42291:	75 05                	jne    42298 <pci_find_device+0x63>
                    return configaddr;
   42293:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42296:	eb 35                	jmp    422cd <pci_find_device+0x98>
                } else if (vendor_device == (uint32_t) -1 && func == 0) {
   42298:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%rbp)
   4229c:	75 06                	jne    422a4 <pci_find_device+0x6f>
   4229e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   422a2:	74 0c                	je     422b0 <pci_find_device+0x7b>
            for (int func = 0; func != 8; ++func) {
   422a4:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   422a8:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
   422ac:	75 b0                	jne    4225e <pci_find_device+0x29>
   422ae:	eb 01                	jmp    422b1 <pci_find_device+0x7c>
                    break;
   422b0:	90                   	nop
        for (int slot = 0; slot != 32; ++slot) {
   422b1:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   422b5:	83 7d f8 20          	cmpl   $0x20,-0x8(%rbp)
   422b9:	75 9a                	jne    42255 <pci_find_device+0x20>
    for (int bus = 0; bus != 256; ++bus) {
   422bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   422bf:	81 7d fc 00 01 00 00 	cmpl   $0x100,-0x4(%rbp)
   422c6:	75 84                	jne    4224c <pci_find_device+0x17>
                }
            }
        }
    }
    return -1;
   422c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
   422cd:	c9                   	leaveq 
   422ce:	c3                   	retq   

00000000000422cf <poweroff>:
//    that speaks ACPI; QEMU emulates a PIIX4 Power Management Controller.

#define PCI_VENDOR_ID_INTEL     0x8086
#define PCI_DEVICE_ID_PIIX4     0x7113

void poweroff(void) {
   422cf:	55                   	push   %rbp
   422d0:	48 89 e5             	mov    %rsp,%rbp
   422d3:	48 83 ec 10          	sub    $0x10,%rsp
    int configaddr = pci_find_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PIIX4);
   422d7:	be 13 71 00 00       	mov    $0x7113,%esi
   422dc:	bf 86 80 00 00       	mov    $0x8086,%edi
   422e1:	e8 4f ff ff ff       	callq  42235 <pci_find_device>
   422e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if (configaddr >= 0) {
   422e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   422ed:	78 30                	js     4231f <poweroff+0x50>
        // Read I/O base register from controller's PCI configuration space.
        int pm_io_base = pci_config_readl(configaddr, 0x40) & 0xFFC0;
   422ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
   422f2:	be 40 00 00 00       	mov    $0x40,%esi
   422f7:	89 c7                	mov    %eax,%edi
   422f9:	e8 f5 fe ff ff       	callq  421f3 <pci_config_readl>
   422fe:	25 c0 ff 00 00       	and    $0xffc0,%eax
   42303:	89 45 f8             	mov    %eax,-0x8(%rbp)
        // Write `suspend enable` to the power management control register.
        outw(pm_io_base + 4, 0x2000);
   42306:	8b 45 f8             	mov    -0x8(%rbp),%eax
   42309:	83 c0 04             	add    $0x4,%eax
   4230c:	89 45 f4             	mov    %eax,-0xc(%rbp)
   4230f:	66 c7 45 f2 00 20    	movw   $0x2000,-0xe(%rbp)
    asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
   42315:	0f b7 45 f2          	movzwl -0xe(%rbp),%eax
   42319:	8b 55 f4             	mov    -0xc(%rbp),%edx
   4231c:	66 ef                	out    %ax,(%dx)
}
   4231e:	90                   	nop
    }
    // No PIIX4; spin.
    console_printf(CPOS(24, 0), 0xC000, "Cannot power off!\n");
   4231f:	ba 20 44 04 00       	mov    $0x44420,%edx
   42324:	be 00 c0 00 00       	mov    $0xc000,%esi
   42329:	bf 80 07 00 00       	mov    $0x780,%edi
   4232e:	b8 00 00 00 00       	mov    $0x0,%eax
   42333:	e8 d4 1b 00 00       	callq  43f0c <console_printf>
 spinloop: goto spinloop;
   42338:	eb fe                	jmp    42338 <poweroff+0x69>

000000000004233a <reboot>:


// reboot
//    Reboot the virtual machine.

void reboot(void) {
   4233a:	55                   	push   %rbp
   4233b:	48 89 e5             	mov    %rsp,%rbp
   4233e:	48 83 ec 10          	sub    $0x10,%rsp
   42342:	c7 45 fc 92 00 00 00 	movl   $0x92,-0x4(%rbp)
   42349:	c6 45 fb 03          	movb   $0x3,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4234d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42351:	8b 55 fc             	mov    -0x4(%rbp),%edx
   42354:	ee                   	out    %al,(%dx)
}
   42355:	90                   	nop
    outb(0x92, 3);
 spinloop: goto spinloop;
   42356:	eb fe                	jmp    42356 <reboot+0x1c>

0000000000042358 <process_init>:


// process_init(p, flags)
//    Initialize special-purpose registers for process `p`.

void process_init(proc* p, int flags) {
   42358:	55                   	push   %rbp
   42359:	48 89 e5             	mov    %rsp,%rbp
   4235c:	48 83 ec 10          	sub    $0x10,%rsp
   42360:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   42364:	89 75 f4             	mov    %esi,-0xc(%rbp)
    memset(&p->p_registers, 0, sizeof(p->p_registers));
   42367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4236b:	48 83 c0 08          	add    $0x8,%rax
   4236f:	ba c0 00 00 00       	mov    $0xc0,%edx
   42374:	be 00 00 00 00       	mov    $0x0,%esi
   42379:	48 89 c7             	mov    %rax,%rdi
   4237c:	e8 56 13 00 00       	callq  436d7 <memset>
    p->p_registers.reg_cs = SEGSEL_APP_CODE | 3;
   42381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42385:	66 c7 80 a8 00 00 00 	movw   $0x13,0xa8(%rax)
   4238c:	13 00 
    p->p_registers.reg_fs = SEGSEL_APP_DATA | 3;
   4238e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42392:	48 c7 80 80 00 00 00 	movq   $0x23,0x80(%rax)
   42399:	23 00 00 00 
    p->p_registers.reg_gs = SEGSEL_APP_DATA | 3;
   4239d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   423a1:	48 c7 80 88 00 00 00 	movq   $0x23,0x88(%rax)
   423a8:	23 00 00 00 
    p->p_registers.reg_ss = SEGSEL_APP_DATA | 3;
   423ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   423b0:	66 c7 80 c0 00 00 00 	movw   $0x23,0xc0(%rax)
   423b7:	23 00 
    p->p_registers.reg_rflags = EFLAGS_IF;
   423b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   423bd:	48 c7 80 b0 00 00 00 	movq   $0x200,0xb0(%rax)
   423c4:	00 02 00 00 

    if (flags & PROCINIT_ALLOW_PROGRAMMED_IO) {
   423c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
   423cb:	83 e0 01             	and    $0x1,%eax
   423ce:	85 c0                	test   %eax,%eax
   423d0:	74 1c                	je     423ee <process_init+0x96>
        p->p_registers.reg_rflags |= EFLAGS_IOPL_3;
   423d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   423d6:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
   423dd:	80 cc 30             	or     $0x30,%ah
   423e0:	48 89 c2             	mov    %rax,%rdx
   423e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   423e7:	48 89 90 b0 00 00 00 	mov    %rdx,0xb0(%rax)
    }
    if (flags & PROCINIT_DISABLE_INTERRUPTS) {
   423ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
   423f1:	83 e0 02             	and    $0x2,%eax
   423f4:	85 c0                	test   %eax,%eax
   423f6:	74 1c                	je     42414 <process_init+0xbc>
        p->p_registers.reg_rflags &= ~EFLAGS_IF;
   423f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   423fc:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
   42403:	80 e4 fd             	and    $0xfd,%ah
   42406:	48 89 c2             	mov    %rax,%rdx
   42409:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4240d:	48 89 90 b0 00 00 00 	mov    %rdx,0xb0(%rax)
    }
}
   42414:	90                   	nop
   42415:	c9                   	leaveq 
   42416:	c3                   	retq   

0000000000042417 <console_show_cursor>:

// console_show_cursor(cpos)
//    Move the console cursor to position `cpos`, which should be between 0
//    and 80 * 25.

void console_show_cursor(int cpos) {
   42417:	55                   	push   %rbp
   42418:	48 89 e5             	mov    %rsp,%rbp
   4241b:	48 83 ec 28          	sub    $0x28,%rsp
   4241f:	89 7d dc             	mov    %edi,-0x24(%rbp)
    if (cpos < 0 || cpos > CONSOLE_ROWS * CONSOLE_COLUMNS) {
   42422:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   42426:	78 09                	js     42431 <console_show_cursor+0x1a>
   42428:	81 7d dc d0 07 00 00 	cmpl   $0x7d0,-0x24(%rbp)
   4242f:	7e 07                	jle    42438 <console_show_cursor+0x21>
        cpos = 0;
   42431:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
   42438:	c7 45 e4 d4 03 00 00 	movl   $0x3d4,-0x1c(%rbp)
   4243f:	c6 45 e3 0e          	movb   $0xe,-0x1d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42443:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
   42447:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   4244a:	ee                   	out    %al,(%dx)
}
   4244b:	90                   	nop
    }
    outb(0x3D4, 14);
    outb(0x3D5, cpos / 256);
   4244c:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4244f:	8d 90 ff 00 00 00    	lea    0xff(%rax),%edx
   42455:	85 c0                	test   %eax,%eax
   42457:	0f 48 c2             	cmovs  %edx,%eax
   4245a:	c1 f8 08             	sar    $0x8,%eax
   4245d:	0f b6 c0             	movzbl %al,%eax
   42460:	c7 45 ec d5 03 00 00 	movl   $0x3d5,-0x14(%rbp)
   42467:	88 45 eb             	mov    %al,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4246a:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   4246e:	8b 55 ec             	mov    -0x14(%rbp),%edx
   42471:	ee                   	out    %al,(%dx)
}
   42472:	90                   	nop
   42473:	c7 45 f4 d4 03 00 00 	movl   $0x3d4,-0xc(%rbp)
   4247a:	c6 45 f3 0f          	movb   $0xf,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4247e:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   42482:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42485:	ee                   	out    %al,(%dx)
}
   42486:	90                   	nop
    outb(0x3D4, 15);
    outb(0x3D5, cpos % 256);
   42487:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4248a:	99                   	cltd   
   4248b:	c1 ea 18             	shr    $0x18,%edx
   4248e:	01 d0                	add    %edx,%eax
   42490:	0f b6 c0             	movzbl %al,%eax
   42493:	29 d0                	sub    %edx,%eax
   42495:	0f b6 c0             	movzbl %al,%eax
   42498:	c7 45 fc d5 03 00 00 	movl   $0x3d5,-0x4(%rbp)
   4249f:	88 45 fb             	mov    %al,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   424a2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   424a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
   424a9:	ee                   	out    %al,(%dx)
}
   424aa:	90                   	nop
}
   424ab:	90                   	nop
   424ac:	c9                   	leaveq 
   424ad:	c3                   	retq   

00000000000424ae <keyboard_readc>:
    /*CKEY(16)*/ {{'\'', '"', 0, 0}},  /*CKEY(17)*/ {{'`', '~', 0, 0}},
    /*CKEY(18)*/ {{'\\', '|', 034, 0}},  /*CKEY(19)*/ {{',', '<', 0, 0}},
    /*CKEY(20)*/ {{'.', '>', 0, 0}},  /*CKEY(21)*/ {{'/', '?', 0, 0}}
};

int keyboard_readc(void) {
   424ae:	55                   	push   %rbp
   424af:	48 89 e5             	mov    %rsp,%rbp
   424b2:	48 83 ec 20          	sub    $0x20,%rsp
   424b6:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   424bd:	8b 45 f0             	mov    -0x10(%rbp),%eax
   424c0:	89 c2                	mov    %eax,%edx
   424c2:	ec                   	in     (%dx),%al
   424c3:	88 45 ef             	mov    %al,-0x11(%rbp)
    return data;
   424c6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
    static uint8_t modifiers;
    static uint8_t last_escape;

    if ((inb(KEYBOARD_STATUSREG) & KEYBOARD_STATUS_READY) == 0) {
   424ca:	0f b6 c0             	movzbl %al,%eax
   424cd:	83 e0 01             	and    $0x1,%eax
   424d0:	85 c0                	test   %eax,%eax
   424d2:	75 0a                	jne    424de <keyboard_readc+0x30>
        return -1;
   424d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   424d9:	e9 e7 01 00 00       	jmpq   426c5 <keyboard_readc+0x217>
   424de:	c7 45 e8 60 00 00 00 	movl   $0x60,-0x18(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   424e5:	8b 45 e8             	mov    -0x18(%rbp),%eax
   424e8:	89 c2                	mov    %eax,%edx
   424ea:	ec                   	in     (%dx),%al
   424eb:	88 45 e7             	mov    %al,-0x19(%rbp)
    return data;
   424ee:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
    }

    uint8_t data = inb(KEYBOARD_DATAREG);
   424f2:	88 45 fb             	mov    %al,-0x5(%rbp)
    uint8_t escape = last_escape;
   424f5:	0f b6 05 06 de 00 00 	movzbl 0xde06(%rip),%eax        # 50302 <last_escape.2>
   424fc:	88 45 fa             	mov    %al,-0x6(%rbp)
    last_escape = 0;
   424ff:	c6 05 fc dd 00 00 00 	movb   $0x0,0xddfc(%rip)        # 50302 <last_escape.2>

    if (data == 0xE0) {         // mode shift
   42506:	80 7d fb e0          	cmpb   $0xe0,-0x5(%rbp)
   4250a:	75 11                	jne    4251d <keyboard_readc+0x6f>
        last_escape = 0x80;
   4250c:	c6 05 ef dd 00 00 80 	movb   $0x80,0xddef(%rip)        # 50302 <last_escape.2>
        return 0;
   42513:	b8 00 00 00 00       	mov    $0x0,%eax
   42518:	e9 a8 01 00 00       	jmpq   426c5 <keyboard_readc+0x217>
    } else if (data & 0x80) {   // key release: matters only for modifier keys
   4251d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42521:	84 c0                	test   %al,%al
   42523:	79 60                	jns    42585 <keyboard_readc+0xd7>
        int ch = keymap[(data & 0x7F) | escape];
   42525:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42529:	83 e0 7f             	and    $0x7f,%eax
   4252c:	89 c2                	mov    %eax,%edx
   4252e:	0f b6 45 fa          	movzbl -0x6(%rbp),%eax
   42532:	09 d0                	or     %edx,%eax
   42534:	48 98                	cltq   
   42536:	0f b6 80 40 44 04 00 	movzbl 0x44440(%rax),%eax
   4253d:	0f b6 c0             	movzbl %al,%eax
   42540:	89 45 f4             	mov    %eax,-0xc(%rbp)
        if (ch >= KEY_SHIFT && ch < KEY_CAPSLOCK) {
   42543:	81 7d f4 f9 00 00 00 	cmpl   $0xf9,-0xc(%rbp)
   4254a:	7e 2f                	jle    4257b <keyboard_readc+0xcd>
   4254c:	81 7d f4 fc 00 00 00 	cmpl   $0xfc,-0xc(%rbp)
   42553:	7f 26                	jg     4257b <keyboard_readc+0xcd>
            modifiers &= ~(1 << (ch - KEY_SHIFT));
   42555:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42558:	2d fa 00 00 00       	sub    $0xfa,%eax
   4255d:	ba 01 00 00 00       	mov    $0x1,%edx
   42562:	89 c1                	mov    %eax,%ecx
   42564:	d3 e2                	shl    %cl,%edx
   42566:	89 d0                	mov    %edx,%eax
   42568:	f7 d0                	not    %eax
   4256a:	89 c2                	mov    %eax,%edx
   4256c:	0f b6 05 90 dd 00 00 	movzbl 0xdd90(%rip),%eax        # 50303 <modifiers.1>
   42573:	21 d0                	and    %edx,%eax
   42575:	88 05 88 dd 00 00    	mov    %al,0xdd88(%rip)        # 50303 <modifiers.1>
        }
        return 0;
   4257b:	b8 00 00 00 00       	mov    $0x0,%eax
   42580:	e9 40 01 00 00       	jmpq   426c5 <keyboard_readc+0x217>
    }

    int ch = (unsigned char) keymap[data | escape];
   42585:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42589:	0a 45 fa             	or     -0x6(%rbp),%al
   4258c:	0f b6 c0             	movzbl %al,%eax
   4258f:	48 98                	cltq   
   42591:	0f b6 80 40 44 04 00 	movzbl 0x44440(%rax),%eax
   42598:	0f b6 c0             	movzbl %al,%eax
   4259b:	89 45 fc             	mov    %eax,-0x4(%rbp)

    if (ch >= 'a' && ch <= 'z') {
   4259e:	83 7d fc 60          	cmpl   $0x60,-0x4(%rbp)
   425a2:	7e 57                	jle    425fb <keyboard_readc+0x14d>
   425a4:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%rbp)
   425a8:	7f 51                	jg     425fb <keyboard_readc+0x14d>
        if (modifiers & MOD_CONTROL) {
   425aa:	0f b6 05 52 dd 00 00 	movzbl 0xdd52(%rip),%eax        # 50303 <modifiers.1>
   425b1:	0f b6 c0             	movzbl %al,%eax
   425b4:	83 e0 02             	and    $0x2,%eax
   425b7:	85 c0                	test   %eax,%eax
   425b9:	74 09                	je     425c4 <keyboard_readc+0x116>
            ch -= 0x60;
   425bb:	83 6d fc 60          	subl   $0x60,-0x4(%rbp)
        if (modifiers & MOD_CONTROL) {
   425bf:	e9 fd 00 00 00       	jmpq   426c1 <keyboard_readc+0x213>
        } else if (!(modifiers & MOD_SHIFT) != !(modifiers & MOD_CAPSLOCK)) {
   425c4:	0f b6 05 38 dd 00 00 	movzbl 0xdd38(%rip),%eax        # 50303 <modifiers.1>
   425cb:	0f b6 c0             	movzbl %al,%eax
   425ce:	83 e0 01             	and    $0x1,%eax
   425d1:	85 c0                	test   %eax,%eax
   425d3:	0f 94 c2             	sete   %dl
   425d6:	0f b6 05 26 dd 00 00 	movzbl 0xdd26(%rip),%eax        # 50303 <modifiers.1>
   425dd:	0f b6 c0             	movzbl %al,%eax
   425e0:	83 e0 08             	and    $0x8,%eax
   425e3:	85 c0                	test   %eax,%eax
   425e5:	0f 94 c0             	sete   %al
   425e8:	31 d0                	xor    %edx,%eax
   425ea:	84 c0                	test   %al,%al
   425ec:	0f 84 cf 00 00 00    	je     426c1 <keyboard_readc+0x213>
            ch -= 0x20;
   425f2:	83 6d fc 20          	subl   $0x20,-0x4(%rbp)
        if (modifiers & MOD_CONTROL) {
   425f6:	e9 c6 00 00 00       	jmpq   426c1 <keyboard_readc+0x213>
        }
    } else if (ch >= KEY_CAPSLOCK) {
   425fb:	81 7d fc fc 00 00 00 	cmpl   $0xfc,-0x4(%rbp)
   42602:	7e 30                	jle    42634 <keyboard_readc+0x186>
        modifiers ^= 1 << (ch - KEY_SHIFT);
   42604:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42607:	2d fa 00 00 00       	sub    $0xfa,%eax
   4260c:	ba 01 00 00 00       	mov    $0x1,%edx
   42611:	89 c1                	mov    %eax,%ecx
   42613:	d3 e2                	shl    %cl,%edx
   42615:	89 d0                	mov    %edx,%eax
   42617:	89 c2                	mov    %eax,%edx
   42619:	0f b6 05 e3 dc 00 00 	movzbl 0xdce3(%rip),%eax        # 50303 <modifiers.1>
   42620:	31 d0                	xor    %edx,%eax
   42622:	88 05 db dc 00 00    	mov    %al,0xdcdb(%rip)        # 50303 <modifiers.1>
        ch = 0;
   42628:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4262f:	e9 8e 00 00 00       	jmpq   426c2 <keyboard_readc+0x214>
    } else if (ch >= KEY_SHIFT) {
   42634:	81 7d fc f9 00 00 00 	cmpl   $0xf9,-0x4(%rbp)
   4263b:	7e 2d                	jle    4266a <keyboard_readc+0x1bc>
        modifiers |= 1 << (ch - KEY_SHIFT);
   4263d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42640:	2d fa 00 00 00       	sub    $0xfa,%eax
   42645:	ba 01 00 00 00       	mov    $0x1,%edx
   4264a:	89 c1                	mov    %eax,%ecx
   4264c:	d3 e2                	shl    %cl,%edx
   4264e:	89 d0                	mov    %edx,%eax
   42650:	89 c2                	mov    %eax,%edx
   42652:	0f b6 05 aa dc 00 00 	movzbl 0xdcaa(%rip),%eax        # 50303 <modifiers.1>
   42659:	09 d0                	or     %edx,%eax
   4265b:	88 05 a2 dc 00 00    	mov    %al,0xdca2(%rip)        # 50303 <modifiers.1>
        ch = 0;
   42661:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42668:	eb 58                	jmp    426c2 <keyboard_readc+0x214>
    } else if (ch >= CKEY(0) && ch <= CKEY(21)) {
   4266a:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
   4266e:	7e 31                	jle    426a1 <keyboard_readc+0x1f3>
   42670:	81 7d fc 95 00 00 00 	cmpl   $0x95,-0x4(%rbp)
   42677:	7f 28                	jg     426a1 <keyboard_readc+0x1f3>
        ch = complex_keymap[ch - CKEY(0)].map[modifiers & 3];
   42679:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4267c:	8d 50 80             	lea    -0x80(%rax),%edx
   4267f:	0f b6 05 7d dc 00 00 	movzbl 0xdc7d(%rip),%eax        # 50303 <modifiers.1>
   42686:	0f b6 c0             	movzbl %al,%eax
   42689:	83 e0 03             	and    $0x3,%eax
   4268c:	48 98                	cltq   
   4268e:	48 63 d2             	movslq %edx,%rdx
   42691:	0f b6 84 90 40 45 04 	movzbl 0x44540(%rax,%rdx,4),%eax
   42698:	00 
   42699:	0f b6 c0             	movzbl %al,%eax
   4269c:	89 45 fc             	mov    %eax,-0x4(%rbp)
   4269f:	eb 21                	jmp    426c2 <keyboard_readc+0x214>
    } else if (ch < 0x80 && (modifiers & MOD_CONTROL)) {
   426a1:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
   426a5:	7f 1b                	jg     426c2 <keyboard_readc+0x214>
   426a7:	0f b6 05 55 dc 00 00 	movzbl 0xdc55(%rip),%eax        # 50303 <modifiers.1>
   426ae:	0f b6 c0             	movzbl %al,%eax
   426b1:	83 e0 02             	and    $0x2,%eax
   426b4:	85 c0                	test   %eax,%eax
   426b6:	74 0a                	je     426c2 <keyboard_readc+0x214>
        ch = 0;
   426b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   426bf:	eb 01                	jmp    426c2 <keyboard_readc+0x214>
        if (modifiers & MOD_CONTROL) {
   426c1:	90                   	nop
    }

    return ch;
   426c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
   426c5:	c9                   	leaveq 
   426c6:	c3                   	retq   

00000000000426c7 <delay>:
#define IO_PARALLEL1_CONTROL    0x37A
# define IO_PARALLEL_CONTROL_SELECT     0x08
# define IO_PARALLEL_CONTROL_INIT       0x04
# define IO_PARALLEL_CONTROL_STROBE     0x01

static void delay(void) {
   426c7:	55                   	push   %rbp
   426c8:	48 89 e5             	mov    %rsp,%rbp
   426cb:	48 83 ec 20          	sub    $0x20,%rsp
   426cf:	c7 45 e4 84 00 00 00 	movl   $0x84,-0x1c(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   426d6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   426d9:	89 c2                	mov    %eax,%edx
   426db:	ec                   	in     (%dx),%al
   426dc:	88 45 e3             	mov    %al,-0x1d(%rbp)
   426df:	c7 45 ec 84 00 00 00 	movl   $0x84,-0x14(%rbp)
   426e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
   426e9:	89 c2                	mov    %eax,%edx
   426eb:	ec                   	in     (%dx),%al
   426ec:	88 45 eb             	mov    %al,-0x15(%rbp)
   426ef:	c7 45 f4 84 00 00 00 	movl   $0x84,-0xc(%rbp)
   426f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
   426f9:	89 c2                	mov    %eax,%edx
   426fb:	ec                   	in     (%dx),%al
   426fc:	88 45 f3             	mov    %al,-0xd(%rbp)
   426ff:	c7 45 fc 84 00 00 00 	movl   $0x84,-0x4(%rbp)
   42706:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42709:	89 c2                	mov    %eax,%edx
   4270b:	ec                   	in     (%dx),%al
   4270c:	88 45 fb             	mov    %al,-0x5(%rbp)
    (void) inb(0x84);
    (void) inb(0x84);
    (void) inb(0x84);
    (void) inb(0x84);
}
   4270f:	90                   	nop
   42710:	c9                   	leaveq 
   42711:	c3                   	retq   

0000000000042712 <parallel_port_putc>:

static void parallel_port_putc(printer* p, unsigned char c, int color) {
   42712:	55                   	push   %rbp
   42713:	48 89 e5             	mov    %rsp,%rbp
   42716:	48 83 ec 40          	sub    $0x40,%rsp
   4271a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   4271e:	89 f0                	mov    %esi,%eax
   42720:	89 55 c0             	mov    %edx,-0x40(%rbp)
   42723:	88 45 c4             	mov    %al,-0x3c(%rbp)
    static int initialized;
    (void) p, (void) color;
    if (!initialized) {
   42726:	8b 05 d8 db 00 00    	mov    0xdbd8(%rip),%eax        # 50304 <initialized.0>
   4272c:	85 c0                	test   %eax,%eax
   4272e:	75 1e                	jne    4274e <parallel_port_putc+0x3c>
   42730:	c7 45 f8 7a 03 00 00 	movl   $0x37a,-0x8(%rbp)
   42737:	c6 45 f7 00          	movb   $0x0,-0x9(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4273b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   4273f:	8b 55 f8             	mov    -0x8(%rbp),%edx
   42742:	ee                   	out    %al,(%dx)
}
   42743:	90                   	nop
        outb(IO_PARALLEL1_CONTROL, 0);
        initialized = 1;
   42744:	c7 05 b6 db 00 00 01 	movl   $0x1,0xdbb6(%rip)        # 50304 <initialized.0>
   4274b:	00 00 00 
    }

    for (int i = 0;
   4274e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42755:	eb 09                	jmp    42760 <parallel_port_putc+0x4e>
         i < 12800 && (inb(IO_PARALLEL1_STATUS) & IO_PARALLEL_STATUS_BUSY) == 0;
         ++i) {
        delay();
   42757:	e8 6b ff ff ff       	callq  426c7 <delay>
         ++i) {
   4275c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
         i < 12800 && (inb(IO_PARALLEL1_STATUS) & IO_PARALLEL_STATUS_BUSY) == 0;
   42760:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%rbp)
   42767:	7f 18                	jg     42781 <parallel_port_putc+0x6f>
   42769:	c7 45 f0 79 03 00 00 	movl   $0x379,-0x10(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   42770:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42773:	89 c2                	mov    %eax,%edx
   42775:	ec                   	in     (%dx),%al
   42776:	88 45 ef             	mov    %al,-0x11(%rbp)
    return data;
   42779:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   4277d:	84 c0                	test   %al,%al
   4277f:	79 d6                	jns    42757 <parallel_port_putc+0x45>
    }
    outb(IO_PARALLEL1_DATA, c);
   42781:	0f b6 45 c4          	movzbl -0x3c(%rbp),%eax
   42785:	c7 45 d8 78 03 00 00 	movl   $0x378,-0x28(%rbp)
   4278c:	88 45 d7             	mov    %al,-0x29(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4278f:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
   42793:	8b 55 d8             	mov    -0x28(%rbp),%edx
   42796:	ee                   	out    %al,(%dx)
}
   42797:	90                   	nop
   42798:	c7 45 e0 7a 03 00 00 	movl   $0x37a,-0x20(%rbp)
   4279f:	c6 45 df 0d          	movb   $0xd,-0x21(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   427a3:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
   427a7:	8b 55 e0             	mov    -0x20(%rbp),%edx
   427aa:	ee                   	out    %al,(%dx)
}
   427ab:	90                   	nop
   427ac:	c7 45 e8 7a 03 00 00 	movl   $0x37a,-0x18(%rbp)
   427b3:	c6 45 e7 0c          	movb   $0xc,-0x19(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   427b7:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
   427bb:	8b 55 e8             	mov    -0x18(%rbp),%edx
   427be:	ee                   	out    %al,(%dx)
}
   427bf:	90                   	nop
    outb(IO_PARALLEL1_CONTROL, IO_PARALLEL_CONTROL_SELECT
         | IO_PARALLEL_CONTROL_INIT | IO_PARALLEL_CONTROL_STROBE);
    outb(IO_PARALLEL1_CONTROL, IO_PARALLEL_CONTROL_SELECT
         | IO_PARALLEL_CONTROL_INIT);
}
   427c0:	90                   	nop
   427c1:	c9                   	leaveq 
   427c2:	c3                   	retq   

00000000000427c3 <log_vprintf>:

void log_vprintf(const char* format, va_list val) {
   427c3:	55                   	push   %rbp
   427c4:	48 89 e5             	mov    %rsp,%rbp
   427c7:	48 83 ec 20          	sub    $0x20,%rsp
   427cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   427cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    printer p;
    p.putc = parallel_port_putc;
   427d3:	48 c7 45 f8 12 27 04 	movq   $0x42712,-0x8(%rbp)
   427da:	00 
    printer_vprintf(&p, 0, format, val);
   427db:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
   427df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   427e3:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
   427e7:	be 00 00 00 00       	mov    $0x0,%esi
   427ec:	48 89 c7             	mov    %rax,%rdi
   427ef:	e8 f4 0f 00 00       	callq  437e8 <printer_vprintf>
}
   427f4:	90                   	nop
   427f5:	c9                   	leaveq 
   427f6:	c3                   	retq   

00000000000427f7 <log_printf>:

void log_printf(const char* format, ...) {
   427f7:	55                   	push   %rbp
   427f8:	48 89 e5             	mov    %rsp,%rbp
   427fb:	48 83 ec 60          	sub    $0x60,%rsp
   427ff:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   42803:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
   42807:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   4280b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   4280f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   42813:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   42817:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
   4281e:	48 8d 45 10          	lea    0x10(%rbp),%rax
   42822:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   42826:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   4282a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    log_vprintf(format, val);
   4282e:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
   42832:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   42836:	48 89 d6             	mov    %rdx,%rsi
   42839:	48 89 c7             	mov    %rax,%rdi
   4283c:	e8 82 ff ff ff       	callq  427c3 <log_vprintf>
    va_end(val);
}
   42841:	90                   	nop
   42842:	c9                   	leaveq 
   42843:	c3                   	retq   

0000000000042844 <error_vprintf>:

// error_printf, error_vprintf
//    Print debugging messages to the console and to the host's
//    `log.txt` file via `log_printf`.

int error_vprintf(int cpos, int color, const char* format, va_list val) {
   42844:	55                   	push   %rbp
   42845:	48 89 e5             	mov    %rsp,%rbp
   42848:	48 83 ec 40          	sub    $0x40,%rsp
   4284c:	89 7d dc             	mov    %edi,-0x24(%rbp)
   4284f:	89 75 d8             	mov    %esi,-0x28(%rbp)
   42852:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
   42856:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
    va_list val2;
    __builtin_va_copy(val2, val);
   4285a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
   4285e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   42862:	48 8b 0a             	mov    (%rdx),%rcx
   42865:	48 89 08             	mov    %rcx,(%rax)
   42868:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
   4286c:	48 89 48 08          	mov    %rcx,0x8(%rax)
   42870:	48 8b 52 10          	mov    0x10(%rdx),%rdx
   42874:	48 89 50 10          	mov    %rdx,0x10(%rax)
    log_vprintf(format, val2);
   42878:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
   4287c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42880:	48 89 d6             	mov    %rdx,%rsi
   42883:	48 89 c7             	mov    %rax,%rdi
   42886:	e8 38 ff ff ff       	callq  427c3 <log_vprintf>
    va_end(val2);
    return console_vprintf(cpos, color, format, val);
   4288b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   4288f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   42893:	8b 75 d8             	mov    -0x28(%rbp),%esi
   42896:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42899:	89 c7                	mov    %eax,%edi
   4289b:	e8 27 16 00 00       	callq  43ec7 <console_vprintf>
}
   428a0:	c9                   	leaveq 
   428a1:	c3                   	retq   

00000000000428a2 <error_printf>:

int error_printf(int cpos, int color, const char* format, ...) {
   428a2:	55                   	push   %rbp
   428a3:	48 89 e5             	mov    %rsp,%rbp
   428a6:	48 83 ec 60          	sub    $0x60,%rsp
   428aa:	89 7d ac             	mov    %edi,-0x54(%rbp)
   428ad:	89 75 a8             	mov    %esi,-0x58(%rbp)
   428b0:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
   428b4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   428b8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   428bc:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   428c0:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   428c7:	48 8d 45 10          	lea    0x10(%rbp),%rax
   428cb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   428cf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   428d3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = error_vprintf(cpos, color, format, val);
   428d7:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   428db:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
   428df:	8b 75 a8             	mov    -0x58(%rbp),%esi
   428e2:	8b 45 ac             	mov    -0x54(%rbp),%eax
   428e5:	89 c7                	mov    %eax,%edi
   428e7:	e8 58 ff ff ff       	callq  42844 <error_vprintf>
   428ec:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
   428ef:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
   428f2:	c9                   	leaveq 
   428f3:	c3                   	retq   

00000000000428f4 <check_keyboard>:
//    Check for the user typing a control key. 'a', 'f', and 'e' cause a soft
//    reboot where the kernel runs the allocator programs, "fork", or
//    "forkexit", respectively. Control-C or 'q' exit the virtual machine.
//    Returns key typed or -1 for no key.

int check_keyboard(void) {
   428f4:	55                   	push   %rbp
   428f5:	48 89 e5             	mov    %rsp,%rbp
   428f8:	53                   	push   %rbx
   428f9:	48 83 ec 48          	sub    $0x48,%rsp
    int c = keyboard_readc();
   428fd:	e8 ac fb ff ff       	callq  424ae <keyboard_readc>
   42902:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    if (c == 'a' || c == 'f' || c == 'e' || c == 't' || c =='2') {
   42905:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
   42909:	74 1c                	je     42927 <check_keyboard+0x33>
   4290b:	83 7d e4 66          	cmpl   $0x66,-0x1c(%rbp)
   4290f:	74 16                	je     42927 <check_keyboard+0x33>
   42911:	83 7d e4 65          	cmpl   $0x65,-0x1c(%rbp)
   42915:	74 10                	je     42927 <check_keyboard+0x33>
   42917:	83 7d e4 74          	cmpl   $0x74,-0x1c(%rbp)
   4291b:	74 0a                	je     42927 <check_keyboard+0x33>
   4291d:	83 7d e4 32          	cmpl   $0x32,-0x1c(%rbp)
   42921:	0f 85 e9 00 00 00    	jne    42a10 <check_keyboard+0x11c>
        // Install a temporary page table to carry us through the
        // process of reinitializing memory. This replicates work the
        // bootloader does.
        x86_64_pagetable* pt = (x86_64_pagetable*) 0x8000;
   42927:	48 c7 45 d8 00 80 00 	movq   $0x8000,-0x28(%rbp)
   4292e:	00 
        memset(pt, 0, PAGESIZE * 3);
   4292f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42933:	ba 00 30 00 00       	mov    $0x3000,%edx
   42938:	be 00 00 00 00       	mov    $0x0,%esi
   4293d:	48 89 c7             	mov    %rax,%rdi
   42940:	e8 92 0d 00 00       	callq  436d7 <memset>
        pt[0].entry[0] = 0x9000 | PTE_P | PTE_W | PTE_U;
   42945:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42949:	48 c7 00 07 90 00 00 	movq   $0x9007,(%rax)
        pt[1].entry[0] = 0xA000 | PTE_P | PTE_W | PTE_U;
   42950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42954:	48 05 00 10 00 00    	add    $0x1000,%rax
   4295a:	48 c7 00 07 a0 00 00 	movq   $0xa007,(%rax)
        pt[2].entry[0] = PTE_P | PTE_W | PTE_U | PTE_PS;
   42961:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42965:	48 05 00 20 00 00    	add    $0x2000,%rax
   4296b:	48 c7 00 87 00 00 00 	movq   $0x87,(%rax)
        lcr3((uintptr_t) pt);
   42972:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42976:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
}

static inline void lcr3(uintptr_t val) {
    asm volatile("" : : : "memory");
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   4297a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4297e:	0f 22 d8             	mov    %rax,%cr3
}
   42981:	90                   	nop
        // The soft reboot process doesn't modify memory, so it's
        // safe to pass `multiboot_info` on the kernel stack, even
        // though it will get overwritten as the kernel runs.
        uint32_t multiboot_info[5];
        multiboot_info[0] = 4;
   42982:	c7 45 b4 04 00 00 00 	movl   $0x4,-0x4c(%rbp)
        const char* argument = "fork";
   42989:	48 c7 45 e8 98 45 04 	movq   $0x44598,-0x18(%rbp)
   42990:	00 
        if (c == 'a') {
   42991:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
   42995:	75 0a                	jne    429a1 <check_keyboard+0xad>
            argument = "allocator";
   42997:	48 c7 45 e8 9d 45 04 	movq   $0x4459d,-0x18(%rbp)
   4299e:	00 
   4299f:	eb 2e                	jmp    429cf <check_keyboard+0xdb>
        } else if (c == 'e') {
   429a1:	83 7d e4 65          	cmpl   $0x65,-0x1c(%rbp)
   429a5:	75 0a                	jne    429b1 <check_keyboard+0xbd>
            argument = "forkexit";
   429a7:	48 c7 45 e8 a7 45 04 	movq   $0x445a7,-0x18(%rbp)
   429ae:	00 
   429af:	eb 1e                	jmp    429cf <check_keyboard+0xdb>
        }
        else if (c == 't'){
   429b1:	83 7d e4 74          	cmpl   $0x74,-0x1c(%rbp)
   429b5:	75 0a                	jne    429c1 <check_keyboard+0xcd>
            argument = "test";
   429b7:	48 c7 45 e8 b0 45 04 	movq   $0x445b0,-0x18(%rbp)
   429be:	00 
   429bf:	eb 0e                	jmp    429cf <check_keyboard+0xdb>
        }
        else if(c == '2'){
   429c1:	83 7d e4 32          	cmpl   $0x32,-0x1c(%rbp)
   429c5:	75 08                	jne    429cf <check_keyboard+0xdb>
            argument = "test2";
   429c7:	48 c7 45 e8 b5 45 04 	movq   $0x445b5,-0x18(%rbp)
   429ce:	00 
        }
        uintptr_t argument_ptr = (uintptr_t) argument;
   429cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   429d3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        assert(argument_ptr < 0x100000000L);
   429d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   429dc:	48 39 45 d0          	cmp    %rax,-0x30(%rbp)
   429e0:	76 14                	jbe    429f6 <check_keyboard+0x102>
   429e2:	ba bb 45 04 00       	mov    $0x445bb,%edx
   429e7:	be 5c 02 00 00       	mov    $0x25c,%esi
   429ec:	bf d7 45 04 00       	mov    $0x445d7,%edi
   429f1:	e8 1f 01 00 00       	callq  42b15 <assert_fail>
        multiboot_info[4] = (uint32_t) argument_ptr;
   429f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   429fa:	89 45 c4             	mov    %eax,-0x3c(%rbp)
        asm volatile("movl $0x2BADB002, %%eax; jmp entry_from_boot"
   429fd:	48 8d 45 b4          	lea    -0x4c(%rbp),%rax
   42a01:	48 89 c3             	mov    %rax,%rbx
   42a04:	b8 02 b0 ad 2b       	mov    $0x2badb002,%eax
   42a09:	e9 f2 d5 ff ff       	jmpq   40000 <entry_from_boot>
    if (c == 'a' || c == 'f' || c == 'e' || c == 't' || c =='2') {
   42a0e:	eb 11                	jmp    42a21 <check_keyboard+0x12d>
                     : : "b" (multiboot_info) : "memory");
    } else if (c == 0x03 || c == 'q') {
   42a10:	83 7d e4 03          	cmpl   $0x3,-0x1c(%rbp)
   42a14:	74 06                	je     42a1c <check_keyboard+0x128>
   42a16:	83 7d e4 71          	cmpl   $0x71,-0x1c(%rbp)
   42a1a:	75 05                	jne    42a21 <check_keyboard+0x12d>
        poweroff();
   42a1c:	e8 ae f8 ff ff       	callq  422cf <poweroff>
    }
    return c;
   42a21:	8b 45 e4             	mov    -0x1c(%rbp),%eax
}
   42a24:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   42a28:	c9                   	leaveq 
   42a29:	c3                   	retq   

0000000000042a2a <fail>:

// fail
//    Loop until user presses Control-C, then poweroff.

static void fail(void) __attribute__((noreturn));
static void fail(void) {
   42a2a:	55                   	push   %rbp
   42a2b:	48 89 e5             	mov    %rsp,%rbp
    while (1) {
        check_keyboard();
   42a2e:	e8 c1 fe ff ff       	callq  428f4 <check_keyboard>
   42a33:	eb f9                	jmp    42a2e <fail+0x4>

0000000000042a35 <panic>:

// panic, assert_fail
//    Use console_printf() to print a failure message and then wait for
//    control-C. Also write the failure message to the log.

void panic(const char* format, ...) {
   42a35:	55                   	push   %rbp
   42a36:	48 89 e5             	mov    %rsp,%rbp
   42a39:	48 83 ec 60          	sub    $0x60,%rsp
   42a3d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   42a41:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
   42a45:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   42a49:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   42a4d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   42a51:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   42a55:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%rbp)
   42a5c:	48 8d 45 10          	lea    0x10(%rbp),%rax
   42a60:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
   42a64:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   42a68:	48 89 45 c0          	mov    %rax,-0x40(%rbp)

    if (format) {
   42a6c:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
   42a71:	0f 84 80 00 00 00    	je     42af7 <panic+0xc2>
        // Print panic message to both the screen and the log
        int cpos = error_printf(CPOS(23, 0), 0xC000, "PANIC: ");
   42a77:	ba e4 45 04 00       	mov    $0x445e4,%edx
   42a7c:	be 00 c0 00 00       	mov    $0xc000,%esi
   42a81:	bf 30 07 00 00       	mov    $0x730,%edi
   42a86:	b8 00 00 00 00       	mov    $0x0,%eax
   42a8b:	e8 12 fe ff ff       	callq  428a2 <error_printf>
   42a90:	89 45 cc             	mov    %eax,-0x34(%rbp)
        cpos = error_vprintf(cpos, 0xC000, format, val);
   42a93:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
   42a97:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
   42a9b:	8b 45 cc             	mov    -0x34(%rbp),%eax
   42a9e:	be 00 c0 00 00       	mov    $0xc000,%esi
   42aa3:	89 c7                	mov    %eax,%edi
   42aa5:	e8 9a fd ff ff       	callq  42844 <error_vprintf>
   42aaa:	89 45 cc             	mov    %eax,-0x34(%rbp)
        if (CCOL(cpos)) {
   42aad:	8b 4d cc             	mov    -0x34(%rbp),%ecx
   42ab0:	48 63 c1             	movslq %ecx,%rax
   42ab3:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
   42aba:	48 c1 e8 20          	shr    $0x20,%rax
   42abe:	c1 f8 05             	sar    $0x5,%eax
   42ac1:	89 ce                	mov    %ecx,%esi
   42ac3:	c1 fe 1f             	sar    $0x1f,%esi
   42ac6:	29 f0                	sub    %esi,%eax
   42ac8:	89 c2                	mov    %eax,%edx
   42aca:	89 d0                	mov    %edx,%eax
   42acc:	c1 e0 02             	shl    $0x2,%eax
   42acf:	01 d0                	add    %edx,%eax
   42ad1:	c1 e0 04             	shl    $0x4,%eax
   42ad4:	29 c1                	sub    %eax,%ecx
   42ad6:	89 ca                	mov    %ecx,%edx
   42ad8:	85 d2                	test   %edx,%edx
   42ada:	74 34                	je     42b10 <panic+0xdb>
            error_printf(cpos, 0xC000, "\n");
   42adc:	8b 45 cc             	mov    -0x34(%rbp),%eax
   42adf:	ba ec 45 04 00       	mov    $0x445ec,%edx
   42ae4:	be 00 c0 00 00       	mov    $0xc000,%esi
   42ae9:	89 c7                	mov    %eax,%edi
   42aeb:	b8 00 00 00 00       	mov    $0x0,%eax
   42af0:	e8 ad fd ff ff       	callq  428a2 <error_printf>
   42af5:	eb 19                	jmp    42b10 <panic+0xdb>
        }
    } else {
        error_printf(CPOS(23, 0), 0xC000, "PANIC");
   42af7:	ba ee 45 04 00       	mov    $0x445ee,%edx
   42afc:	be 00 c0 00 00       	mov    $0xc000,%esi
   42b01:	bf 30 07 00 00       	mov    $0x730,%edi
   42b06:	b8 00 00 00 00       	mov    $0x0,%eax
   42b0b:	e8 92 fd ff ff       	callq  428a2 <error_printf>
    }

    va_end(val);
    fail();
   42b10:	e8 15 ff ff ff       	callq  42a2a <fail>

0000000000042b15 <assert_fail>:
}

void assert_fail(const char* file, int line, const char* msg) {
   42b15:	55                   	push   %rbp
   42b16:	48 89 e5             	mov    %rsp,%rbp
   42b19:	48 83 ec 20          	sub    $0x20,%rsp
   42b1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   42b21:	89 75 f4             	mov    %esi,-0xc(%rbp)
   42b24:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    panic("%s:%d: assertion '%s' failed\n", file, line, msg);
   42b28:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
   42b2c:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42b2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42b33:	48 89 c6             	mov    %rax,%rsi
   42b36:	bf f4 45 04 00       	mov    $0x445f4,%edi
   42b3b:	b8 00 00 00 00       	mov    $0x0,%eax
   42b40:	e8 f0 fe ff ff       	callq  42a35 <panic>

0000000000042b45 <default_exception>:
}

void default_exception(proc* p){
   42b45:	55                   	push   %rbp
   42b46:	48 89 e5             	mov    %rsp,%rbp
   42b49:	48 83 ec 20          	sub    $0x20,%rsp
   42b4d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    x86_64_registers * reg = &(p->p_registers);
   42b51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42b55:	48 83 c0 08          	add    $0x8,%rax
   42b59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    panic("Unexpected exception %d!\n", reg->reg_intno);
   42b5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42b61:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   42b68:	48 89 c6             	mov    %rax,%rsi
   42b6b:	bf 12 46 04 00       	mov    $0x44612,%edi
   42b70:	b8 00 00 00 00       	mov    $0x0,%eax
   42b75:	e8 bb fe ff ff       	callq  42a35 <panic>

0000000000042b7a <pageindex>:
static inline int pageindex(uintptr_t addr, int level) {
   42b7a:	55                   	push   %rbp
   42b7b:	48 89 e5             	mov    %rsp,%rbp
   42b7e:	48 83 ec 10          	sub    $0x10,%rsp
   42b82:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   42b86:	89 75 f4             	mov    %esi,-0xc(%rbp)
    assert(level >= 0 && level <= 3);
   42b89:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   42b8d:	78 06                	js     42b95 <pageindex+0x1b>
   42b8f:	83 7d f4 03          	cmpl   $0x3,-0xc(%rbp)
   42b93:	7e 14                	jle    42ba9 <pageindex+0x2f>
   42b95:	ba 30 46 04 00       	mov    $0x44630,%edx
   42b9a:	be 1e 00 00 00       	mov    $0x1e,%esi
   42b9f:	bf 49 46 04 00       	mov    $0x44649,%edi
   42ba4:	e8 6c ff ff ff       	callq  42b15 <assert_fail>
    return (int) (addr >> (PAGEOFFBITS + (3 - level) * PAGEINDEXBITS)) & 0x1FF;
   42ba9:	b8 03 00 00 00       	mov    $0x3,%eax
   42bae:	2b 45 f4             	sub    -0xc(%rbp),%eax
   42bb1:	89 c2                	mov    %eax,%edx
   42bb3:	89 d0                	mov    %edx,%eax
   42bb5:	c1 e0 03             	shl    $0x3,%eax
   42bb8:	01 d0                	add    %edx,%eax
   42bba:	83 c0 0c             	add    $0xc,%eax
   42bbd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   42bc1:	89 c1                	mov    %eax,%ecx
   42bc3:	48 d3 ea             	shr    %cl,%rdx
   42bc6:	48 89 d0             	mov    %rdx,%rax
   42bc9:	25 ff 01 00 00       	and    $0x1ff,%eax
}
   42bce:	c9                   	leaveq 
   42bcf:	c3                   	retq   

0000000000042bd0 <virtual_memory_init>:

static x86_64_pagetable kernel_pagetables[5];
x86_64_pagetable* kernel_pagetable;


void virtual_memory_init(void) {
   42bd0:	55                   	push   %rbp
   42bd1:	48 89 e5             	mov    %rsp,%rbp
   42bd4:	48 83 ec 20          	sub    $0x20,%rsp
    kernel_pagetable = &kernel_pagetables[0];
   42bd8:	48 c7 05 1d e4 00 00 	movq   $0x52000,0xe41d(%rip)        # 51000 <kernel_pagetable>
   42bdf:	00 20 05 00 
    memset(kernel_pagetables, 0, sizeof(kernel_pagetables));
   42be3:	ba 00 50 00 00       	mov    $0x5000,%edx
   42be8:	be 00 00 00 00       	mov    $0x0,%esi
   42bed:	bf 00 20 05 00       	mov    $0x52000,%edi
   42bf2:	e8 e0 0a 00 00       	callq  436d7 <memset>

    // connect the pagetable pages
    kernel_pagetables[0].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[1] | PTE_P | PTE_W | PTE_U;
   42bf7:	b8 00 30 05 00       	mov    $0x53000,%eax
   42bfc:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[0].entry[0] =
   42c00:	48 89 05 f9 f3 00 00 	mov    %rax,0xf3f9(%rip)        # 52000 <kernel_pagetables>
    kernel_pagetables[1].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[2] | PTE_P | PTE_W | PTE_U;
   42c07:	b8 00 40 05 00       	mov    $0x54000,%eax
   42c0c:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[1].entry[0] =
   42c10:	48 89 05 e9 03 01 00 	mov    %rax,0x103e9(%rip)        # 53000 <kernel_pagetables+0x1000>
    kernel_pagetables[2].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[3] | PTE_P | PTE_W | PTE_U;
   42c17:	b8 00 50 05 00       	mov    $0x55000,%eax
   42c1c:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[2].entry[0] =
   42c20:	48 89 05 d9 13 01 00 	mov    %rax,0x113d9(%rip)        # 54000 <kernel_pagetables+0x2000>
    kernel_pagetables[2].entry[1] =
        (x86_64_pageentry_t) &kernel_pagetables[4] | PTE_P | PTE_W | PTE_U;
   42c27:	b8 00 60 05 00       	mov    $0x56000,%eax
   42c2c:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[2].entry[1] =
   42c30:	48 89 05 d1 13 01 00 	mov    %rax,0x113d1(%rip)        # 54008 <kernel_pagetables+0x2008>

    // identity map the page table
    virtual_memory_map(kernel_pagetable, (uintptr_t) 0, (uintptr_t) 0,
   42c37:	48 8b 05 c2 e3 00 00 	mov    0xe3c2(%rip),%rax        # 51000 <kernel_pagetable>
   42c3e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   42c44:	b9 00 00 20 00       	mov    $0x200000,%ecx
   42c49:	ba 00 00 00 00       	mov    $0x0,%edx
   42c4e:	be 00 00 00 00       	mov    $0x0,%esi
   42c53:	48 89 c7             	mov    %rax,%rdi
   42c56:	e8 b9 01 00 00       	callq  42e14 <virtual_memory_map>
                       MEMSIZE_PHYSICAL, PTE_P | PTE_W | PTE_U);

    // check if kernel is identity mapped
    for(uintptr_t addr = 0 ; addr < MEMSIZE_PHYSICAL ; addr += PAGESIZE){
   42c5b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   42c62:	00 
   42c63:	eb 62                	jmp    42cc7 <virtual_memory_init+0xf7>
        vamapping vmap = virtual_memory_lookup(kernel_pagetable, addr);
   42c65:	48 8b 0d 94 e3 00 00 	mov    0xe394(%rip),%rcx        # 51000 <kernel_pagetable>
   42c6c:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
   42c70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   42c74:	48 89 ce             	mov    %rcx,%rsi
   42c77:	48 89 c7             	mov    %rax,%rdi
   42c7a:	e8 51 05 00 00       	callq  431d0 <virtual_memory_lookup>
        // this assert will probably fail initially!
        // have you implemented virtual_memory_map and lookup_l4pagetable ?
        assert(vmap.pa == addr);
   42c7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42c83:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   42c87:	74 14                	je     42c9d <virtual_memory_init+0xcd>
   42c89:	ba 52 46 04 00       	mov    $0x44652,%edx
   42c8e:	be 2d 00 00 00       	mov    $0x2d,%esi
   42c93:	bf 62 46 04 00       	mov    $0x44662,%edi
   42c98:	e8 78 fe ff ff       	callq  42b15 <assert_fail>
        assert((vmap.perm & (PTE_P|PTE_W)) == (PTE_P|PTE_W));
   42c9d:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42ca0:	48 98                	cltq   
   42ca2:	83 e0 03             	and    $0x3,%eax
   42ca5:	48 83 f8 03          	cmp    $0x3,%rax
   42ca9:	74 14                	je     42cbf <virtual_memory_init+0xef>
   42cab:	ba 68 46 04 00       	mov    $0x44668,%edx
   42cb0:	be 2e 00 00 00       	mov    $0x2e,%esi
   42cb5:	bf 62 46 04 00       	mov    $0x44662,%edi
   42cba:	e8 56 fe ff ff       	callq  42b15 <assert_fail>
    for(uintptr_t addr = 0 ; addr < MEMSIZE_PHYSICAL ; addr += PAGESIZE){
   42cbf:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   42cc6:	00 
   42cc7:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   42cce:	00 
   42ccf:	76 94                	jbe    42c65 <virtual_memory_init+0x95>
    }

    // set pointer to this pagetable in the CR3 register
    // set_pagetable also does several checks for a valid pagetable
    set_pagetable(kernel_pagetable);
   42cd1:	48 8b 05 28 e3 00 00 	mov    0xe328(%rip),%rax        # 51000 <kernel_pagetable>
   42cd8:	48 89 c7             	mov    %rax,%rdi
   42cdb:	e8 03 00 00 00       	callq  42ce3 <set_pagetable>
}
   42ce0:	90                   	nop
   42ce1:	c9                   	leaveq 
   42ce2:	c3                   	retq   

0000000000042ce3 <set_pagetable>:
// set_pagetable
//    Change page directory. lcr3() is the hardware instruction;
//    set_pagetable() additionally checks that important kernel procedures are
//    mappable in `pagetable`, and calls panic() if they aren't.

void set_pagetable(x86_64_pagetable* pagetable) {
   42ce3:	55                   	push   %rbp
   42ce4:	48 89 e5             	mov    %rsp,%rbp
   42ce7:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
   42ceb:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
    assert(PAGEOFFSET(pagetable) == 0); // must be page aligned
   42cef:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   42cf3:	25 ff 0f 00 00       	and    $0xfff,%eax
   42cf8:	48 85 c0             	test   %rax,%rax
   42cfb:	74 14                	je     42d11 <set_pagetable+0x2e>
   42cfd:	ba 95 46 04 00       	mov    $0x44695,%edx
   42d02:	be 3d 00 00 00       	mov    $0x3d,%esi
   42d07:	bf 62 46 04 00       	mov    $0x44662,%edi
   42d0c:	e8 04 fe ff ff       	callq  42b15 <assert_fail>
    // check for kernel space being mapped in pagetable
    assert(virtual_memory_lookup(pagetable, (uintptr_t) default_int_handler).pa
   42d11:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   42d16:	48 8d 45 98          	lea    -0x68(%rbp),%rax
   42d1a:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42d1e:	48 89 ce             	mov    %rcx,%rsi
   42d21:	48 89 c7             	mov    %rax,%rdi
   42d24:	e8 a7 04 00 00       	callq  431d0 <virtual_memory_lookup>
   42d29:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   42d2d:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   42d32:	48 39 d0             	cmp    %rdx,%rax
   42d35:	74 14                	je     42d4b <set_pagetable+0x68>
   42d37:	ba b0 46 04 00       	mov    $0x446b0,%edx
   42d3c:	be 3f 00 00 00       	mov    $0x3f,%esi
   42d41:	bf 62 46 04 00       	mov    $0x44662,%edi
   42d46:	e8 ca fd ff ff       	callq  42b15 <assert_fail>
           == (uintptr_t) default_int_handler);
    assert(virtual_memory_lookup(kernel_pagetable, (uintptr_t) pagetable).pa
   42d4b:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
   42d4f:	48 8b 0d aa e2 00 00 	mov    0xe2aa(%rip),%rcx        # 51000 <kernel_pagetable>
   42d56:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
   42d5a:	48 89 ce             	mov    %rcx,%rsi
   42d5d:	48 89 c7             	mov    %rax,%rdi
   42d60:	e8 6b 04 00 00       	callq  431d0 <virtual_memory_lookup>
   42d65:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   42d69:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   42d6d:	48 39 c2             	cmp    %rax,%rdx
   42d70:	74 14                	je     42d86 <set_pagetable+0xa3>
   42d72:	ba 18 47 04 00       	mov    $0x44718,%edx
   42d77:	be 41 00 00 00       	mov    $0x41,%esi
   42d7c:	bf 62 46 04 00       	mov    $0x44662,%edi
   42d81:	e8 8f fd ff ff       	callq  42b15 <assert_fail>
           == (uintptr_t) pagetable);
    assert(virtual_memory_lookup(pagetable, (uintptr_t) kernel_pagetable).pa
   42d86:	48 8b 05 73 e2 00 00 	mov    0xe273(%rip),%rax        # 51000 <kernel_pagetable>
   42d8d:	48 89 c2             	mov    %rax,%rdx
   42d90:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
   42d94:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42d98:	48 89 ce             	mov    %rcx,%rsi
   42d9b:	48 89 c7             	mov    %rax,%rdi
   42d9e:	e8 2d 04 00 00       	callq  431d0 <virtual_memory_lookup>
   42da3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42da7:	48 8b 15 52 e2 00 00 	mov    0xe252(%rip),%rdx        # 51000 <kernel_pagetable>
   42dae:	48 39 d0             	cmp    %rdx,%rax
   42db1:	74 14                	je     42dc7 <set_pagetable+0xe4>
   42db3:	ba 78 47 04 00       	mov    $0x44778,%edx
   42db8:	be 43 00 00 00       	mov    $0x43,%esi
   42dbd:	bf 62 46 04 00       	mov    $0x44662,%edi
   42dc2:	e8 4e fd ff ff       	callq  42b15 <assert_fail>
           == (uintptr_t) kernel_pagetable);
    assert(virtual_memory_lookup(pagetable, (uintptr_t) virtual_memory_map).pa
   42dc7:	ba 14 2e 04 00       	mov    $0x42e14,%edx
   42dcc:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
   42dd0:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42dd4:	48 89 ce             	mov    %rcx,%rsi
   42dd7:	48 89 c7             	mov    %rax,%rdi
   42dda:	e8 f1 03 00 00       	callq  431d0 <virtual_memory_lookup>
   42ddf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42de3:	ba 14 2e 04 00       	mov    $0x42e14,%edx
   42de8:	48 39 d0             	cmp    %rdx,%rax
   42deb:	74 14                	je     42e01 <set_pagetable+0x11e>
   42ded:	ba e0 47 04 00       	mov    $0x447e0,%edx
   42df2:	be 45 00 00 00       	mov    $0x45,%esi
   42df7:	bf 62 46 04 00       	mov    $0x44662,%edi
   42dfc:	e8 14 fd ff ff       	callq  42b15 <assert_fail>
           == (uintptr_t) virtual_memory_map);
    lcr3((uintptr_t) pagetable);
   42e01:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   42e05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   42e09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42e0d:	0f 22 d8             	mov    %rax,%cr3
}
   42e10:	90                   	nop
}
   42e11:	90                   	nop
   42e12:	c9                   	leaveq 
   42e13:	c3                   	retq   

0000000000042e14 <virtual_memory_map>:
//    Returns NULL otherwise
static x86_64_pagetable* lookup_l4pagetable(x86_64_pagetable* pagetable,
                 uintptr_t va, int perm);

int virtual_memory_map(x86_64_pagetable* pagetable, uintptr_t va,
                       uintptr_t pa, size_t sz, int perm) {
   42e14:	55                   	push   %rbp
   42e15:	48 89 e5             	mov    %rsp,%rbp
   42e18:	53                   	push   %rbx
   42e19:	48 83 ec 58          	sub    $0x58,%rsp
   42e1d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   42e21:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
   42e25:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
   42e29:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
   42e2d:	44 89 45 ac          	mov    %r8d,-0x54(%rbp)

    // sanity checks for virtual address, size, and permisions
    assert(va % PAGESIZE == 0); // virtual address is page-aligned
   42e31:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42e35:	25 ff 0f 00 00       	and    $0xfff,%eax
   42e3a:	48 85 c0             	test   %rax,%rax
   42e3d:	74 14                	je     42e53 <virtual_memory_map+0x3f>
   42e3f:	ba 46 48 04 00       	mov    $0x44846,%edx
   42e44:	be 66 00 00 00       	mov    $0x66,%esi
   42e49:	bf 62 46 04 00       	mov    $0x44662,%edi
   42e4e:	e8 c2 fc ff ff       	callq  42b15 <assert_fail>
    assert(sz % PAGESIZE == 0); // size is a multip le of PAGESIZE
   42e53:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   42e57:	25 ff 0f 00 00       	and    $0xfff,%eax
   42e5c:	48 85 c0             	test   %rax,%rax
   42e5f:	74 14                	je     42e75 <virtual_memory_map+0x61>
   42e61:	ba 59 48 04 00       	mov    $0x44859,%edx
   42e66:	be 67 00 00 00       	mov    $0x67,%esi
   42e6b:	bf 62 46 04 00       	mov    $0x44662,%edi
   42e70:	e8 a0 fc ff ff       	callq  42b15 <assert_fail>
    assert(va + sz >= va || va + sz == 0); // va range does not wrap
   42e75:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   42e79:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   42e7d:	48 01 d0             	add    %rdx,%rax
   42e80:	48 39 45 c0          	cmp    %rax,-0x40(%rbp)
   42e84:	76 24                	jbe    42eaa <virtual_memory_map+0x96>
   42e86:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   42e8a:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   42e8e:	48 01 d0             	add    %rdx,%rax
   42e91:	48 85 c0             	test   %rax,%rax
   42e94:	74 14                	je     42eaa <virtual_memory_map+0x96>
   42e96:	ba 6c 48 04 00       	mov    $0x4486c,%edx
   42e9b:	be 68 00 00 00       	mov    $0x68,%esi
   42ea0:	bf 62 46 04 00       	mov    $0x44662,%edi
   42ea5:	e8 6b fc ff ff       	callq  42b15 <assert_fail>
    if (perm & PTE_P) {
   42eaa:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42ead:	48 98                	cltq   
   42eaf:	83 e0 01             	and    $0x1,%eax
   42eb2:	48 85 c0             	test   %rax,%rax
   42eb5:	74 6e                	je     42f25 <virtual_memory_map+0x111>
        assert(pa % PAGESIZE == 0); // physical addr is page-aligned
   42eb7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   42ebb:	25 ff 0f 00 00       	and    $0xfff,%eax
   42ec0:	48 85 c0             	test   %rax,%rax
   42ec3:	74 14                	je     42ed9 <virtual_memory_map+0xc5>
   42ec5:	ba 8a 48 04 00       	mov    $0x4488a,%edx
   42eca:	be 6a 00 00 00       	mov    $0x6a,%esi
   42ecf:	bf 62 46 04 00       	mov    $0x44662,%edi
   42ed4:	e8 3c fc ff ff       	callq  42b15 <assert_fail>
        assert(pa + sz >= pa);      // physical address range does not wrap
   42ed9:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   42edd:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   42ee1:	48 01 d0             	add    %rdx,%rax
   42ee4:	48 39 45 b8          	cmp    %rax,-0x48(%rbp)
   42ee8:	76 14                	jbe    42efe <virtual_memory_map+0xea>
   42eea:	ba 9d 48 04 00       	mov    $0x4489d,%edx
   42eef:	be 6b 00 00 00       	mov    $0x6b,%esi
   42ef4:	bf 62 46 04 00       	mov    $0x44662,%edi
   42ef9:	e8 17 fc ff ff       	callq  42b15 <assert_fail>
        assert(pa + sz <= MEMSIZE_PHYSICAL); // physical addresses exist
   42efe:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   42f02:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   42f06:	48 01 d0             	add    %rdx,%rax
   42f09:	48 3d 00 00 20 00    	cmp    $0x200000,%rax
   42f0f:	76 14                	jbe    42f25 <virtual_memory_map+0x111>
   42f11:	ba ab 48 04 00       	mov    $0x448ab,%edx
   42f16:	be 6c 00 00 00       	mov    $0x6c,%esi
   42f1b:	bf 62 46 04 00       	mov    $0x44662,%edi
   42f20:	e8 f0 fb ff ff       	callq  42b15 <assert_fail>
    }
    assert(perm >= 0 && perm < 0x1000); // `perm` makes sense (perm can only be 12 bits)
   42f25:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
   42f29:	78 09                	js     42f34 <virtual_memory_map+0x120>
   42f2b:	81 7d ac ff 0f 00 00 	cmpl   $0xfff,-0x54(%rbp)
   42f32:	7e 14                	jle    42f48 <virtual_memory_map+0x134>
   42f34:	ba c7 48 04 00       	mov    $0x448c7,%edx
   42f39:	be 6e 00 00 00       	mov    $0x6e,%esi
   42f3e:	bf 62 46 04 00       	mov    $0x44662,%edi
   42f43:	e8 cd fb ff ff       	callq  42b15 <assert_fail>
    assert((uintptr_t) pagetable % PAGESIZE == 0); // `pagetable` page-aligned
   42f48:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   42f4c:	25 ff 0f 00 00       	and    $0xfff,%eax
   42f51:	48 85 c0             	test   %rax,%rax
   42f54:	74 14                	je     42f6a <virtual_memory_map+0x156>
   42f56:	ba e8 48 04 00       	mov    $0x448e8,%edx
   42f5b:	be 6f 00 00 00       	mov    $0x6f,%esi
   42f60:	bf 62 46 04 00       	mov    $0x44662,%edi
   42f65:	e8 ab fb ff ff       	callq  42b15 <assert_fail>

    int last_index123 = -1;
   42f6a:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%rbp)
    x86_64_pagetable* l4pagetable = NULL;
   42f71:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
   42f78:	00 

    // for each page-aligned address, set the appropriate page entry
    for (; sz != 0; va += PAGESIZE, pa += PAGESIZE, sz -= PAGESIZE) {
   42f79:	e9 e2 00 00 00       	jmpq   43060 <virtual_memory_map+0x24c>
        int cur_index123 = (va >> (PAGEOFFBITS + PAGEINDEXBITS));
   42f7e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42f82:	48 c1 e8 15          	shr    $0x15,%rax
   42f86:	89 45 dc             	mov    %eax,-0x24(%rbp)
        if (cur_index123 != last_index123) {
   42f89:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42f8c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
   42f8f:	74 20                	je     42fb1 <virtual_memory_map+0x19d>
            // TODO
            // find pointer to last level pagetable for current va
            l4pagetable = lookup_l4pagetable(pagetable, va, perm);
   42f91:	8b 55 ac             	mov    -0x54(%rbp),%edx
   42f94:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
   42f98:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   42f9c:	48 89 ce             	mov    %rcx,%rsi
   42f9f:	48 89 c7             	mov    %rax,%rdi
   42fa2:	e8 cf 00 00 00       	callq  43076 <lookup_l4pagetable>
   42fa7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            last_index123 = cur_index123;
   42fab:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42fae:	89 45 ec             	mov    %eax,-0x14(%rbp)
        }
        if ((perm & PTE_P) && l4pagetable) { // if page is marked present
   42fb1:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42fb4:	48 98                	cltq   
   42fb6:	83 e0 01             	and    $0x1,%eax
   42fb9:	48 85 c0             	test   %rax,%rax
   42fbc:	74 35                	je     42ff3 <virtual_memory_map+0x1df>
   42fbe:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   42fc3:	74 2e                	je     42ff3 <virtual_memory_map+0x1df>
            // TODO
            // map `pa` at appropriate entry with permissions `perm`
            l4pagetable->entry[L4PAGEINDEX(va)] = pa + perm;
   42fc5:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42fc8:	48 63 d8             	movslq %eax,%rbx
   42fcb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42fcf:	be 03 00 00 00       	mov    $0x3,%esi
   42fd4:	48 89 c7             	mov    %rax,%rdi
   42fd7:	e8 9e fb ff ff       	callq  42b7a <pageindex>
   42fdc:	89 c2                	mov    %eax,%edx
   42fde:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   42fe2:	48 8d 0c 03          	lea    (%rbx,%rax,1),%rcx
   42fe6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42fea:	48 63 d2             	movslq %edx,%rdx
   42fed:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
   42ff1:	eb 55                	jmp    43048 <virtual_memory_map+0x234>
        } else if (l4pagetable) { // if page is NOT marked present
   42ff3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   42ff8:	74 26                	je     43020 <virtual_memory_map+0x20c>
            // TODO
            // map to address 0 with `perm` 
            l4pagetable->entry[L4PAGEINDEX(va)] = perm;
   42ffa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42ffe:	be 03 00 00 00       	mov    $0x3,%esi
   43003:	48 89 c7             	mov    %rax,%rdi
   43006:	e8 6f fb ff ff       	callq  42b7a <pageindex>
   4300b:	89 c2                	mov    %eax,%edx
   4300d:	8b 45 ac             	mov    -0x54(%rbp),%eax
   43010:	48 63 c8             	movslq %eax,%rcx
   43013:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43017:	48 63 d2             	movslq %edx,%rdx
   4301a:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
   4301e:	eb 28                	jmp    43048 <virtual_memory_map+0x234>
        } else if (perm & PTE_P) {
   43020:	8b 45 ac             	mov    -0x54(%rbp),%eax
   43023:	48 98                	cltq   
   43025:	83 e0 01             	and    $0x1,%eax
   43028:	48 85 c0             	test   %rax,%rax
   4302b:	74 1b                	je     43048 <virtual_memory_map+0x234>
            // error, no allocated l4 page found for va
            log_printf("[Kern Info] failed to find l4pagetable address at " __FILE__ ": %d\n", __LINE__);
   4302d:	be 87 00 00 00       	mov    $0x87,%esi
   43032:	bf 10 49 04 00       	mov    $0x44910,%edi
   43037:	b8 00 00 00 00       	mov    $0x0,%eax
   4303c:	e8 b6 f7 ff ff       	callq  427f7 <log_printf>
            return -1;
   43041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   43046:	eb 28                	jmp    43070 <virtual_memory_map+0x25c>
    for (; sz != 0; va += PAGESIZE, pa += PAGESIZE, sz -= PAGESIZE) {
   43048:	48 81 45 c0 00 10 00 	addq   $0x1000,-0x40(%rbp)
   4304f:	00 
   43050:	48 81 45 b8 00 10 00 	addq   $0x1000,-0x48(%rbp)
   43057:	00 
   43058:	48 81 6d b0 00 10 00 	subq   $0x1000,-0x50(%rbp)
   4305f:	00 
   43060:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
   43065:	0f 85 13 ff ff ff    	jne    42f7e <virtual_memory_map+0x16a>
        }
    }
    return 0;
   4306b:	b8 00 00 00 00       	mov    $0x0,%eax
}
   43070:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   43074:	c9                   	leaveq 
   43075:	c3                   	retq   

0000000000043076 <lookup_l4pagetable>:
//
//    Returns an x86_64_pagetable pointer to the last level pagetable
//    if it exists and can be accessed with the given permissions
//    Returns NULL otherwise
static x86_64_pagetable* lookup_l4pagetable(x86_64_pagetable* pagetable,
                 uintptr_t va, int perm) {
   43076:	55                   	push   %rbp
   43077:	48 89 e5             	mov    %rsp,%rbp
   4307a:	48 83 ec 40          	sub    $0x40,%rsp
   4307e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   43082:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
   43086:	89 55 cc             	mov    %edx,-0x34(%rbp)
    x86_64_pagetable* pt = pagetable;
   43089:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4308d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    // we find the l4 pagetable by doing the following three steps for each level
    // 1. Find index to the next pagetable entry using the `va`
    // 2. Check if this entry has the appropriate requested permissions
    // 3. Repeat the steps till you reach the l4 pagetable (i.e thrice)
    // 4. return the pagetable address
    for (int i = 0; i <= 2; ++i) {
   43091:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   43098:	e9 23 01 00 00       	jmpq   431c0 <lookup_l4pagetable+0x14a>
        // TODO
        // find page entry by finding `ith` level index of va to index pagetable entries of `pt`
        // you should read x86-64.h to understand relevant structs and macros to make this part easier 
        x86_64_pageentry_t pe = pt->entry[PAGEINDEX(va, i)];
   4309d:	8b 55 f4             	mov    -0xc(%rbp),%edx
   430a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   430a4:	89 d6                	mov    %edx,%esi
   430a6:	48 89 c7             	mov    %rax,%rdi
   430a9:	e8 cc fa ff ff       	callq  42b7a <pageindex>
   430ae:	89 c2                	mov    %eax,%edx
   430b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   430b4:	48 63 d2             	movslq %edx,%rdx
   430b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   430bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        if (!(pe & PTE_P)) { // address of next level should be present AND PTE_P should be set, error otherwise
   430bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   430c3:	83 e0 01             	and    $0x1,%eax
   430c6:	48 85 c0             	test   %rax,%rax
   430c9:	75 63                	jne    4312e <lookup_l4pagetable+0xb8>
            log_printf("[Kern Info] Error looking up l4pagetable: Pagetable address: 0x%x perm: 0x%x."
   430cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
   430ce:	8d 48 02             	lea    0x2(%rax),%ecx
   430d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   430d5:	25 ff 0f 00 00       	and    $0xfff,%eax
   430da:	48 89 c2             	mov    %rax,%rdx
   430dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   430e1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   430e7:	48 89 c6             	mov    %rax,%rsi
   430ea:	bf 50 49 04 00       	mov    $0x44950,%edi
   430ef:	b8 00 00 00 00       	mov    $0x0,%eax
   430f4:	e8 fe f6 ff ff       	callq  427f7 <log_printf>
                    " Failed to get level (%d)\n",
                    PTE_ADDR(pe), PTE_FLAGS(pe), (i+2));
            if (!(perm & PTE_P)) {
   430f9:	8b 45 cc             	mov    -0x34(%rbp),%eax
   430fc:	48 98                	cltq   
   430fe:	83 e0 01             	and    $0x1,%eax
   43101:	48 85 c0             	test   %rax,%rax
   43104:	75 0a                	jne    43110 <lookup_l4pagetable+0x9a>
                return NULL;
   43106:	b8 00 00 00 00       	mov    $0x0,%eax
   4310b:	e9 be 00 00 00       	jmpq   431ce <lookup_l4pagetable+0x158>
            }
            log_printf("[Kern Info] failed to find pagetable address at " __FILE__ ": %d\n", __LINE__);
   43110:	be a9 00 00 00       	mov    $0xa9,%esi
   43115:	bf b8 49 04 00       	mov    $0x449b8,%edi
   4311a:	b8 00 00 00 00       	mov    $0x0,%eax
   4311f:	e8 d3 f6 ff ff       	callq  427f7 <log_printf>
            return NULL;
   43124:	b8 00 00 00 00       	mov    $0x0,%eax
   43129:	e9 a0 00 00 00       	jmpq   431ce <lookup_l4pagetable+0x158>
        }

        // sanity-check page entry and permissions
        assert(PTE_ADDR(pe) < MEMSIZE_PHYSICAL); // at sensible address
   4312e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43132:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   43138:	48 3d ff ff 1f 00    	cmp    $0x1fffff,%rax
   4313e:	76 14                	jbe    43154 <lookup_l4pagetable+0xde>
   43140:	ba f8 49 04 00       	mov    $0x449f8,%edx
   43145:	be ae 00 00 00       	mov    $0xae,%esi
   4314a:	bf 62 46 04 00       	mov    $0x44662,%edi
   4314f:	e8 c1 f9 ff ff       	callq  42b15 <assert_fail>
        if (perm & PTE_W) {       // if requester wants PTE_W,
   43154:	8b 45 cc             	mov    -0x34(%rbp),%eax
   43157:	48 98                	cltq   
   43159:	83 e0 02             	and    $0x2,%eax
   4315c:	48 85 c0             	test   %rax,%rax
   4315f:	74 20                	je     43181 <lookup_l4pagetable+0x10b>
            assert(pe & PTE_W);   //   entry must allow PTE_W
   43161:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43165:	83 e0 02             	and    $0x2,%eax
   43168:	48 85 c0             	test   %rax,%rax
   4316b:	75 14                	jne    43181 <lookup_l4pagetable+0x10b>
   4316d:	ba 18 4a 04 00       	mov    $0x44a18,%edx
   43172:	be b0 00 00 00       	mov    $0xb0,%esi
   43177:	bf 62 46 04 00       	mov    $0x44662,%edi
   4317c:	e8 94 f9 ff ff       	callq  42b15 <assert_fail>
        }
        if (perm & PTE_U) {       // if requester wants PTE_U,
   43181:	8b 45 cc             	mov    -0x34(%rbp),%eax
   43184:	48 98                	cltq   
   43186:	83 e0 04             	and    $0x4,%eax
   43189:	48 85 c0             	test   %rax,%rax
   4318c:	74 20                	je     431ae <lookup_l4pagetable+0x138>
            assert(pe & PTE_U);   //   entry must allow PTE_U
   4318e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43192:	83 e0 04             	and    $0x4,%eax
   43195:	48 85 c0             	test   %rax,%rax
   43198:	75 14                	jne    431ae <lookup_l4pagetable+0x138>
   4319a:	ba 23 4a 04 00       	mov    $0x44a23,%edx
   4319f:	be b3 00 00 00       	mov    $0xb3,%esi
   431a4:	bf 62 46 04 00       	mov    $0x44662,%edi
   431a9:	e8 67 f9 ff ff       	callq  42b15 <assert_fail>
        }

        // TODO
        // set pt to physical address to next pagetable using `pe`
        pt = (x86_64_pagetable *)PTE_ADDR(pe); // replace this
   431ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   431b2:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   431b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 2; ++i) {
   431bc:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   431c0:	83 7d f4 02          	cmpl   $0x2,-0xc(%rbp)
   431c4:	0f 8e d3 fe ff ff    	jle    4309d <lookup_l4pagetable+0x27>
    }
    return pt;
   431ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
   431ce:	c9                   	leaveq 
   431cf:	c3                   	retq   

00000000000431d0 <virtual_memory_lookup>:

// virtual_memory_lookup(pagetable, va)
//    Returns information about the mapping of the virtual address `va` in
//    `pagetable`. The information is returned as a `vamapping` object.

vamapping virtual_memory_lookup(x86_64_pagetable* pagetable, uintptr_t va) {
   431d0:	55                   	push   %rbp
   431d1:	48 89 e5             	mov    %rsp,%rbp
   431d4:	48 83 ec 50          	sub    $0x50,%rsp
   431d8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   431dc:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
   431e0:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
    x86_64_pagetable* pt = pagetable;
   431e4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   431e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    x86_64_pageentry_t pe = PTE_W | PTE_U | PTE_P;
   431ec:	48 c7 45 f0 07 00 00 	movq   $0x7,-0x10(%rbp)
   431f3:	00 
    for (int i = 0; i <= 3 && (pe & PTE_P); ++i) {
   431f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
   431fb:	eb 41                	jmp    4323e <virtual_memory_lookup+0x6e>
        pe = pt->entry[PAGEINDEX(va, i)] & ~(pe & (PTE_W | PTE_U));
   431fd:	8b 55 ec             	mov    -0x14(%rbp),%edx
   43200:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   43204:	89 d6                	mov    %edx,%esi
   43206:	48 89 c7             	mov    %rax,%rdi
   43209:	e8 6c f9 ff ff       	callq  42b7a <pageindex>
   4320e:	89 c2                	mov    %eax,%edx
   43210:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43214:	48 63 d2             	movslq %edx,%rdx
   43217:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
   4321b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4321f:	83 e0 06             	and    $0x6,%eax
   43222:	48 f7 d0             	not    %rax
   43225:	48 21 d0             	and    %rdx,%rax
   43228:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
        pt = (x86_64_pagetable*) PTE_ADDR(pe);
   4322c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43230:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   43236:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 3 && (pe & PTE_P); ++i) {
   4323a:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
   4323e:	83 7d ec 03          	cmpl   $0x3,-0x14(%rbp)
   43242:	7f 0c                	jg     43250 <virtual_memory_lookup+0x80>
   43244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43248:	83 e0 01             	and    $0x1,%eax
   4324b:	48 85 c0             	test   %rax,%rax
   4324e:	75 ad                	jne    431fd <virtual_memory_lookup+0x2d>
    }
    vamapping vam = { -1, (uintptr_t) -1, 0 };
   43250:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%rbp)
   43257:	48 c7 45 d8 ff ff ff 	movq   $0xffffffffffffffff,-0x28(%rbp)
   4325e:	ff 
   4325f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
    if (pe & PTE_P) {
   43266:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4326a:	83 e0 01             	and    $0x1,%eax
   4326d:	48 85 c0             	test   %rax,%rax
   43270:	74 34                	je     432a6 <virtual_memory_lookup+0xd6>
        vam.pn = PAGENUMBER(pe);
   43272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43276:	48 c1 e8 0c          	shr    $0xc,%rax
   4327a:	89 45 d0             	mov    %eax,-0x30(%rbp)
        vam.pa = PTE_ADDR(pe) + PAGEOFFSET(va);
   4327d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43281:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   43287:	48 89 c2             	mov    %rax,%rdx
   4328a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   4328e:	25 ff 0f 00 00       	and    $0xfff,%eax
   43293:	48 09 d0             	or     %rdx,%rax
   43296:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
        vam.perm = PTE_FLAGS(pe);
   4329a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4329e:	25 ff 0f 00 00       	and    $0xfff,%eax
   432a3:	89 45 e0             	mov    %eax,-0x20(%rbp)
    }
    return vam;
   432a6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   432aa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   432ae:	48 89 10             	mov    %rdx,(%rax)
   432b1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   432b5:	48 89 50 08          	mov    %rdx,0x8(%rax)
   432b9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   432bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
}
   432c1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   432c5:	c9                   	leaveq 
   432c6:	c3                   	retq   

00000000000432c7 <program_load>:
//    `assign_physical_page` to as required. Returns 0 on success and
//    -1 on failure (e.g. out-of-memory). `allocator` is passed to
//    `virtual_memory_map`.

int program_load(proc* p, int programnumber,
                 x86_64_pagetable* (*allocator)(void)) {
   432c7:	55                   	push   %rbp
   432c8:	48 89 e5             	mov    %rsp,%rbp
   432cb:	48 83 ec 40          	sub    $0x40,%rsp
   432cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   432d3:	89 75 d4             	mov    %esi,-0x2c(%rbp)
   432d6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    // is this a valid program?
    int nprograms = sizeof(ramimages) / sizeof(ramimages[0]);
   432da:	c7 45 f8 07 00 00 00 	movl   $0x7,-0x8(%rbp)
    assert(programnumber >= 0 && programnumber < nprograms);
   432e1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
   432e5:	78 08                	js     432ef <program_load+0x28>
   432e7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   432ea:	3b 45 f8             	cmp    -0x8(%rbp),%eax
   432ed:	7c 14                	jl     43303 <program_load+0x3c>
   432ef:	ba 30 4a 04 00       	mov    $0x44a30,%edx
   432f4:	be 37 00 00 00       	mov    $0x37,%esi
   432f9:	bf 60 4a 04 00       	mov    $0x44a60,%edi
   432fe:	e8 12 f8 ff ff       	callq  42b15 <assert_fail>
    elf_header* eh = (elf_header*) ramimages[programnumber].begin;
   43303:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   43306:	48 98                	cltq   
   43308:	48 c1 e0 04          	shl    $0x4,%rax
   4330c:	48 05 20 50 04 00    	add    $0x45020,%rax
   43312:	48 8b 00             	mov    (%rax),%rax
   43315:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    assert(eh->e_magic == ELF_MAGIC);
   43319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4331d:	8b 00                	mov    (%rax),%eax
   4331f:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
   43324:	74 14                	je     4333a <program_load+0x73>
   43326:	ba 6b 4a 04 00       	mov    $0x44a6b,%edx
   4332b:	be 39 00 00 00       	mov    $0x39,%esi
   43330:	bf 60 4a 04 00       	mov    $0x44a60,%edi
   43335:	e8 db f7 ff ff       	callq  42b15 <assert_fail>

    // load each loadable program segment into memory
    elf_program* ph = (elf_program*) ((const uint8_t*) eh + eh->e_phoff);
   4333a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4333e:	48 8b 50 20          	mov    0x20(%rax),%rdx
   43342:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43346:	48 01 d0             	add    %rdx,%rax
   43349:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    for (int i = 0; i < eh->e_phnum; ++i) {
   4334d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   43354:	e9 94 00 00 00       	jmpq   433ed <program_load+0x126>
        if (ph[i].p_type == ELF_PTYPE_LOAD) {
   43359:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4335c:	48 63 d0             	movslq %eax,%rdx
   4335f:	48 89 d0             	mov    %rdx,%rax
   43362:	48 c1 e0 03          	shl    $0x3,%rax
   43366:	48 29 d0             	sub    %rdx,%rax
   43369:	48 c1 e0 03          	shl    $0x3,%rax
   4336d:	48 89 c2             	mov    %rax,%rdx
   43370:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43374:	48 01 d0             	add    %rdx,%rax
   43377:	8b 00                	mov    (%rax),%eax
   43379:	83 f8 01             	cmp    $0x1,%eax
   4337c:	75 6b                	jne    433e9 <program_load+0x122>
            const uint8_t* pdata = (const uint8_t*) eh + ph[i].p_offset;
   4337e:	8b 45 fc             	mov    -0x4(%rbp),%eax
   43381:	48 63 d0             	movslq %eax,%rdx
   43384:	48 89 d0             	mov    %rdx,%rax
   43387:	48 c1 e0 03          	shl    $0x3,%rax
   4338b:	48 29 d0             	sub    %rdx,%rax
   4338e:	48 c1 e0 03          	shl    $0x3,%rax
   43392:	48 89 c2             	mov    %rax,%rdx
   43395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43399:	48 01 d0             	add    %rdx,%rax
   4339c:	48 8b 50 08          	mov    0x8(%rax),%rdx
   433a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   433a4:	48 01 d0             	add    %rdx,%rax
   433a7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            if (program_load_segment(p, &ph[i], pdata, allocator) < 0) {
   433ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
   433ae:	48 63 d0             	movslq %eax,%rdx
   433b1:	48 89 d0             	mov    %rdx,%rax
   433b4:	48 c1 e0 03          	shl    $0x3,%rax
   433b8:	48 29 d0             	sub    %rdx,%rax
   433bb:	48 c1 e0 03          	shl    $0x3,%rax
   433bf:	48 89 c2             	mov    %rax,%rdx
   433c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   433c6:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
   433ca:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   433ce:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   433d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   433d6:	48 89 c7             	mov    %rax,%rdi
   433d9:	e8 3d 00 00 00       	callq  4341b <program_load_segment>
   433de:	85 c0                	test   %eax,%eax
   433e0:	79 07                	jns    433e9 <program_load+0x122>
                return -1;
   433e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   433e7:	eb 30                	jmp    43419 <program_load+0x152>
    for (int i = 0; i < eh->e_phnum; ++i) {
   433e9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   433ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   433f1:	0f b7 40 38          	movzwl 0x38(%rax),%eax
   433f5:	0f b7 c0             	movzwl %ax,%eax
   433f8:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   433fb:	0f 8c 58 ff ff ff    	jl     43359 <program_load+0x92>
            }
        }
    }

    // set the entry point from the ELF header
    p->p_registers.reg_rip = eh->e_entry;
   43401:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43405:	48 8b 50 18          	mov    0x18(%rax),%rdx
   43409:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4340d:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    return 0;
   43414:	b8 00 00 00 00       	mov    $0x0,%eax
}
   43419:	c9                   	leaveq 
   4341a:	c3                   	retq   

000000000004341b <program_load_segment>:
//    Calls `assign_physical_page` to allocate pages and `virtual_memory_map`
//    to map them in `p->p_pagetable`. Returns 0 on success and -1 on failure.

static int program_load_segment(proc* p, const elf_program* ph,
                                const uint8_t* src,
                                x86_64_pagetable* (*allocator)(void)) {
   4341b:	55                   	push   %rbp
   4341c:	48 89 e5             	mov    %rsp,%rbp
   4341f:	48 83 ec 70          	sub    $0x70,%rsp
   43423:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   43427:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
   4342b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
   4342f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    uintptr_t va = (uintptr_t) ph->p_va;
   43433:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   43437:	48 8b 40 10          	mov    0x10(%rax),%rax
   4343b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    uintptr_t end_file = va + ph->p_filesz, end_mem = va + ph->p_memsz;
   4343f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   43443:	48 8b 50 20          	mov    0x20(%rax),%rdx
   43447:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4344b:	48 01 d0             	add    %rdx,%rax
   4344e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
   43452:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   43456:	48 8b 50 28          	mov    0x28(%rax),%rdx
   4345a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4345e:	48 01 d0             	add    %rdx,%rax
   43461:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    va &= ~(PAGESIZE - 1);                // round to page boundary
   43465:	48 81 65 e8 00 f0 ff 	andq   $0xfffffffffffff000,-0x18(%rbp)
   4346c:	ff 

    // allocate memory
    void *p_addr;
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   4346d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43471:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   43475:	eb 7c                	jmp    434f3 <program_load_segment+0xd8>
        p_addr = alloc_page_process(p->p_pid);
   43477:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   4347b:	8b 00                	mov    (%rax),%eax
   4347d:	89 c7                	mov    %eax,%edi
   4347f:	e8 af d1 ff ff       	callq  40633 <alloc_page_process>
   43484:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        if (p_addr == NULL
   43488:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
   4348d:	74 2a                	je     434b9 <program_load_segment+0x9e>
            || virtual_memory_map(p->p_pagetable, addr, (uintptr_t)p_addr, PAGESIZE,
   4348f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   43493:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   43497:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   4349e:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   434a2:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   434a8:	b9 00 10 00 00       	mov    $0x1000,%ecx
   434ad:	48 89 c7             	mov    %rax,%rdi
   434b0:	e8 5f f9 ff ff       	callq  42e14 <virtual_memory_map>
   434b5:	85 c0                	test   %eax,%eax
   434b7:	79 32                	jns    434eb <program_load_segment+0xd0>
                                  PTE_P | PTE_W | PTE_U) < 0) {
            console_printf(CPOS(22, 0), 0xC000, "program_load_segment(pid %d): can't assign address %p\n", p->p_pid, addr);
   434b9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   434bd:	8b 00                	mov    (%rax),%eax
   434bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   434c3:	49 89 d0             	mov    %rdx,%r8
   434c6:	89 c1                	mov    %eax,%ecx
   434c8:	ba 88 4a 04 00       	mov    $0x44a88,%edx
   434cd:	be 00 c0 00 00       	mov    $0xc000,%esi
   434d2:	bf e0 06 00 00       	mov    $0x6e0,%edi
   434d7:	b8 00 00 00 00       	mov    $0x0,%eax
   434dc:	e8 2b 0a 00 00       	callq  43f0c <console_printf>
            return -1;
   434e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   434e6:	e9 e5 00 00 00       	jmpq   435d0 <program_load_segment+0x1b5>
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   434eb:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   434f2:	00 
   434f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   434f7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
   434fb:	0f 82 76 ff ff ff    	jb     43477 <program_load_segment+0x5c>
        }
    }

    // ensure new memory mappings are active
    set_pagetable(p->p_pagetable);
   43501:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   43505:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   4350c:	48 89 c7             	mov    %rax,%rdi
   4350f:	e8 cf f7 ff ff       	callq  42ce3 <set_pagetable>

    // copy data from executable image into process memory
    memcpy((uint8_t*) va, src, end_file - va);
   43514:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43518:	48 2b 45 e8          	sub    -0x18(%rbp),%rax
   4351c:	48 89 c2             	mov    %rax,%rdx
   4351f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43523:	48 8b 4d 98          	mov    -0x68(%rbp),%rcx
   43527:	48 89 ce             	mov    %rcx,%rsi
   4352a:	48 89 c7             	mov    %rax,%rdi
   4352d:	e8 3c 01 00 00       	callq  4366e <memcpy>
    memset((uint8_t*) end_file, 0, end_mem - end_file);
   43532:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43536:	48 2b 45 e0          	sub    -0x20(%rbp),%rax
   4353a:	48 89 c2             	mov    %rax,%rdx
   4353d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43541:	be 00 00 00 00       	mov    $0x0,%esi
   43546:	48 89 c7             	mov    %rax,%rdi
   43549:	e8 89 01 00 00       	callq  436d7 <memset>
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE){   
   4354e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43552:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   43556:	eb 5a                	jmp    435b2 <program_load_segment+0x197>
        if (!(ph->p_flags & ELF_PFLAG_WRITE))
   43558:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   4355c:	8b 40 04             	mov    0x4(%rax),%eax
   4355f:	83 e0 02             	and    $0x2,%eax
   43562:	85 c0                	test   %eax,%eax
   43564:	75 44                	jne    435aa <program_load_segment+0x18f>
            virtual_memory_map(p->p_pagetable, addr, virtual_memory_lookup(p->p_pagetable, addr).pa, PAGESIZE, PTE_P | PTE_U);
   43566:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   4356a:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   43571:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
   43575:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   43579:	48 89 ce             	mov    %rcx,%rsi
   4357c:	48 89 c7             	mov    %rax,%rdi
   4357f:	e8 4c fc ff ff       	callq  431d0 <virtual_memory_lookup>
   43584:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   43588:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   4358c:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   43593:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   43597:	41 b8 05 00 00 00    	mov    $0x5,%r8d
   4359d:	b9 00 10 00 00       	mov    $0x1000,%ecx
   435a2:	48 89 c7             	mov    %rax,%rdi
   435a5:	e8 6a f8 ff ff       	callq  42e14 <virtual_memory_map>
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE){   
   435aa:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
   435b1:	00 
   435b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   435b6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
   435ba:	72 9c                	jb     43558 <program_load_segment+0x13d>
    }

    // restore kernel pagetable
    set_pagetable(kernel_pagetable);
   435bc:	48 8b 05 3d da 00 00 	mov    0xda3d(%rip),%rax        # 51000 <kernel_pagetable>
   435c3:	48 89 c7             	mov    %rax,%rdi
   435c6:	e8 18 f7 ff ff       	callq  42ce3 <set_pagetable>
    return 0;
   435cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
   435d0:	c9                   	leaveq 
   435d1:	c3                   	retq   

00000000000435d2 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
   435d2:	48 89 f9             	mov    %rdi,%rcx
   435d5:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
   435d7:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
   435de:	00 
   435df:	72 08                	jb     435e9 <console_putc+0x17>
        cp->cursor = console;
   435e1:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
   435e8:	00 
    }
    if (c == '\n') {
   435e9:	40 80 fe 0a          	cmp    $0xa,%sil
   435ed:	74 16                	je     43605 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
   435ef:	48 8b 41 08          	mov    0x8(%rcx),%rax
   435f3:	48 8d 50 02          	lea    0x2(%rax),%rdx
   435f7:	48 89 51 08          	mov    %rdx,0x8(%rcx)
   435fb:	40 0f b6 f6          	movzbl %sil,%esi
   435ff:	09 fe                	or     %edi,%esi
   43601:	66 89 30             	mov    %si,(%rax)
    }
}
   43604:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
   43605:	4c 8b 41 08          	mov    0x8(%rcx),%r8
   43609:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
   43610:	4c 89 c6             	mov    %r8,%rsi
   43613:	48 d1 fe             	sar    %rsi
   43616:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
   4361d:	66 66 66 
   43620:	48 89 f0             	mov    %rsi,%rax
   43623:	48 f7 ea             	imul   %rdx
   43626:	48 c1 fa 05          	sar    $0x5,%rdx
   4362a:	49 c1 f8 3f          	sar    $0x3f,%r8
   4362e:	4c 29 c2             	sub    %r8,%rdx
   43631:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
   43635:	48 c1 e2 04          	shl    $0x4,%rdx
   43639:	89 f0                	mov    %esi,%eax
   4363b:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
   4363d:	83 cf 20             	or     $0x20,%edi
   43640:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43644:	48 8d 72 02          	lea    0x2(%rdx),%rsi
   43648:	48 89 71 08          	mov    %rsi,0x8(%rcx)
   4364c:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
   4364f:	83 c0 01             	add    $0x1,%eax
   43652:	83 f8 50             	cmp    $0x50,%eax
   43655:	75 e9                	jne    43640 <console_putc+0x6e>
   43657:	c3                   	retq   

0000000000043658 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
   43658:	48 8b 47 08          	mov    0x8(%rdi),%rax
   4365c:	48 3b 47 10          	cmp    0x10(%rdi),%rax
   43660:	73 0b                	jae    4366d <string_putc+0x15>
        *sp->s++ = c;
   43662:	48 8d 50 01          	lea    0x1(%rax),%rdx
   43666:	48 89 57 08          	mov    %rdx,0x8(%rdi)
   4366a:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
   4366d:	c3                   	retq   

000000000004366e <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
   4366e:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
   43671:	48 85 d2             	test   %rdx,%rdx
   43674:	74 17                	je     4368d <memcpy+0x1f>
   43676:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
   4367b:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
   43680:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
   43684:	48 83 c1 01          	add    $0x1,%rcx
   43688:	48 39 d1             	cmp    %rdx,%rcx
   4368b:	75 ee                	jne    4367b <memcpy+0xd>
}
   4368d:	c3                   	retq   

000000000004368e <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
   4368e:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
   43691:	48 39 fe             	cmp    %rdi,%rsi
   43694:	72 1d                	jb     436b3 <memmove+0x25>
        while (n-- > 0) {
   43696:	b9 00 00 00 00       	mov    $0x0,%ecx
   4369b:	48 85 d2             	test   %rdx,%rdx
   4369e:	74 12                	je     436b2 <memmove+0x24>
            *d++ = *s++;
   436a0:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
   436a4:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
   436a8:	48 83 c1 01          	add    $0x1,%rcx
   436ac:	48 39 ca             	cmp    %rcx,%rdx
   436af:	75 ef                	jne    436a0 <memmove+0x12>
}
   436b1:	c3                   	retq   
   436b2:	c3                   	retq   
    if (s < d && s + n > d) {
   436b3:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
   436b7:	48 39 cf             	cmp    %rcx,%rdi
   436ba:	73 da                	jae    43696 <memmove+0x8>
        while (n-- > 0) {
   436bc:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
   436c0:	48 85 d2             	test   %rdx,%rdx
   436c3:	74 ec                	je     436b1 <memmove+0x23>
            *--d = *--s;
   436c5:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
   436c9:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
   436cc:	48 83 e9 01          	sub    $0x1,%rcx
   436d0:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
   436d4:	75 ef                	jne    436c5 <memmove+0x37>
   436d6:	c3                   	retq   

00000000000436d7 <memset>:
void* memset(void* v, int c, size_t n) {
   436d7:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
   436da:	48 85 d2             	test   %rdx,%rdx
   436dd:	74 12                	je     436f1 <memset+0x1a>
   436df:	48 01 fa             	add    %rdi,%rdx
   436e2:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
   436e5:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
   436e8:	48 83 c1 01          	add    $0x1,%rcx
   436ec:	48 39 ca             	cmp    %rcx,%rdx
   436ef:	75 f4                	jne    436e5 <memset+0xe>
}
   436f1:	c3                   	retq   

00000000000436f2 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
   436f2:	80 3f 00             	cmpb   $0x0,(%rdi)
   436f5:	74 10                	je     43707 <strlen+0x15>
   436f7:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
   436fc:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
   43700:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
   43704:	75 f6                	jne    436fc <strlen+0xa>
   43706:	c3                   	retq   
   43707:	b8 00 00 00 00       	mov    $0x0,%eax
}
   4370c:	c3                   	retq   

000000000004370d <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
   4370d:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   43710:	ba 00 00 00 00       	mov    $0x0,%edx
   43715:	48 85 f6             	test   %rsi,%rsi
   43718:	74 11                	je     4372b <strnlen+0x1e>
   4371a:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
   4371e:	74 0c                	je     4372c <strnlen+0x1f>
        ++n;
   43720:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   43724:	48 39 d0             	cmp    %rdx,%rax
   43727:	75 f1                	jne    4371a <strnlen+0xd>
   43729:	eb 04                	jmp    4372f <strnlen+0x22>
   4372b:	c3                   	retq   
   4372c:	48 89 d0             	mov    %rdx,%rax
}
   4372f:	c3                   	retq   

0000000000043730 <strcpy>:
char* strcpy(char* dst, const char* src) {
   43730:	48 89 f8             	mov    %rdi,%rax
   43733:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
   43738:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
   4373c:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
   4373f:	48 83 c2 01          	add    $0x1,%rdx
   43743:	84 c9                	test   %cl,%cl
   43745:	75 f1                	jne    43738 <strcpy+0x8>
}
   43747:	c3                   	retq   

0000000000043748 <strcmp>:
    while (*a && *b && *a == *b) {
   43748:	0f b6 07             	movzbl (%rdi),%eax
   4374b:	84 c0                	test   %al,%al
   4374d:	74 1a                	je     43769 <strcmp+0x21>
   4374f:	0f b6 16             	movzbl (%rsi),%edx
   43752:	38 c2                	cmp    %al,%dl
   43754:	75 13                	jne    43769 <strcmp+0x21>
   43756:	84 d2                	test   %dl,%dl
   43758:	74 0f                	je     43769 <strcmp+0x21>
        ++a, ++b;
   4375a:	48 83 c7 01          	add    $0x1,%rdi
   4375e:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
   43762:	0f b6 07             	movzbl (%rdi),%eax
   43765:	84 c0                	test   %al,%al
   43767:	75 e6                	jne    4374f <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
   43769:	3a 06                	cmp    (%rsi),%al
   4376b:	0f 97 c0             	seta   %al
   4376e:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
   43771:	83 d8 00             	sbb    $0x0,%eax
}
   43774:	c3                   	retq   

0000000000043775 <strchr>:
    while (*s && *s != (char) c) {
   43775:	0f b6 07             	movzbl (%rdi),%eax
   43778:	84 c0                	test   %al,%al
   4377a:	74 10                	je     4378c <strchr+0x17>
   4377c:	40 38 f0             	cmp    %sil,%al
   4377f:	74 18                	je     43799 <strchr+0x24>
        ++s;
   43781:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
   43785:	0f b6 07             	movzbl (%rdi),%eax
   43788:	84 c0                	test   %al,%al
   4378a:	75 f0                	jne    4377c <strchr+0x7>
        return NULL;
   4378c:	40 84 f6             	test   %sil,%sil
   4378f:	b8 00 00 00 00       	mov    $0x0,%eax
   43794:	48 0f 44 c7          	cmove  %rdi,%rax
}
   43798:	c3                   	retq   
   43799:	48 89 f8             	mov    %rdi,%rax
   4379c:	c3                   	retq   

000000000004379d <rand>:
    if (!rand_seed_set) {
   4379d:	83 3d 60 38 01 00 00 	cmpl   $0x0,0x13860(%rip)        # 57004 <rand_seed_set>
   437a4:	74 1b                	je     437c1 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
   437a6:	69 05 50 38 01 00 0d 	imul   $0x19660d,0x13850(%rip),%eax        # 57000 <rand_seed>
   437ad:	66 19 00 
   437b0:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
   437b5:	89 05 45 38 01 00    	mov    %eax,0x13845(%rip)        # 57000 <rand_seed>
    return rand_seed & RAND_MAX;
   437bb:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
   437c0:	c3                   	retq   
    rand_seed = seed;
   437c1:	c7 05 35 38 01 00 9e 	movl   $0x30d4879e,0x13835(%rip)        # 57000 <rand_seed>
   437c8:	87 d4 30 
    rand_seed_set = 1;
   437cb:	c7 05 2f 38 01 00 01 	movl   $0x1,0x1382f(%rip)        # 57004 <rand_seed_set>
   437d2:	00 00 00 
}
   437d5:	eb cf                	jmp    437a6 <rand+0x9>

00000000000437d7 <srand>:
    rand_seed = seed;
   437d7:	89 3d 23 38 01 00    	mov    %edi,0x13823(%rip)        # 57000 <rand_seed>
    rand_seed_set = 1;
   437dd:	c7 05 1d 38 01 00 01 	movl   $0x1,0x1381d(%rip)        # 57004 <rand_seed_set>
   437e4:	00 00 00 
}
   437e7:	c3                   	retq   

00000000000437e8 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
   437e8:	55                   	push   %rbp
   437e9:	48 89 e5             	mov    %rsp,%rbp
   437ec:	41 57                	push   %r15
   437ee:	41 56                	push   %r14
   437f0:	41 55                	push   %r13
   437f2:	41 54                	push   %r12
   437f4:	53                   	push   %rbx
   437f5:	48 83 ec 58          	sub    $0x58,%rsp
   437f9:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
   437fd:	0f b6 02             	movzbl (%rdx),%eax
   43800:	84 c0                	test   %al,%al
   43802:	0f 84 b0 06 00 00    	je     43eb8 <printer_vprintf+0x6d0>
   43808:	49 89 fe             	mov    %rdi,%r14
   4380b:	49 89 d4             	mov    %rdx,%r12
            length = 1;
   4380e:	41 89 f7             	mov    %esi,%r15d
   43811:	e9 a4 04 00 00       	jmpq   43cba <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
   43816:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
   4381b:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
   43821:	45 84 e4             	test   %r12b,%r12b
   43824:	0f 84 82 06 00 00    	je     43eac <printer_vprintf+0x6c4>
        int flags = 0;
   4382a:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
   43830:	41 0f be f4          	movsbl %r12b,%esi
   43834:	bf c1 4c 04 00       	mov    $0x44cc1,%edi
   43839:	e8 37 ff ff ff       	callq  43775 <strchr>
   4383e:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
   43841:	48 85 c0             	test   %rax,%rax
   43844:	74 55                	je     4389b <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
   43846:	48 81 e9 c1 4c 04 00 	sub    $0x44cc1,%rcx
   4384d:	b8 01 00 00 00       	mov    $0x1,%eax
   43852:	d3 e0                	shl    %cl,%eax
   43854:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
   43857:	48 83 c3 01          	add    $0x1,%rbx
   4385b:	44 0f b6 23          	movzbl (%rbx),%r12d
   4385f:	45 84 e4             	test   %r12b,%r12b
   43862:	75 cc                	jne    43830 <printer_vprintf+0x48>
   43864:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
   43868:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
   4386e:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
   43875:	80 3b 2e             	cmpb   $0x2e,(%rbx)
   43878:	0f 84 a9 00 00 00    	je     43927 <printer_vprintf+0x13f>
        int length = 0;
   4387e:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
   43883:	0f b6 13             	movzbl (%rbx),%edx
   43886:	8d 42 bd             	lea    -0x43(%rdx),%eax
   43889:	3c 37                	cmp    $0x37,%al
   4388b:	0f 87 c4 04 00 00    	ja     43d55 <printer_vprintf+0x56d>
   43891:	0f b6 c0             	movzbl %al,%eax
   43894:	ff 24 c5 d0 4a 04 00 	jmpq   *0x44ad0(,%rax,8)
        if (*format >= '1' && *format <= '9') {
   4389b:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
   4389f:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
   438a4:	3c 08                	cmp    $0x8,%al
   438a6:	77 2f                	ja     438d7 <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   438a8:	0f b6 03             	movzbl (%rbx),%eax
   438ab:	8d 50 d0             	lea    -0x30(%rax),%edx
   438ae:	80 fa 09             	cmp    $0x9,%dl
   438b1:	77 5e                	ja     43911 <printer_vprintf+0x129>
   438b3:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
   438b9:	48 83 c3 01          	add    $0x1,%rbx
   438bd:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
   438c2:	0f be c0             	movsbl %al,%eax
   438c5:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   438ca:	0f b6 03             	movzbl (%rbx),%eax
   438cd:	8d 50 d0             	lea    -0x30(%rax),%edx
   438d0:	80 fa 09             	cmp    $0x9,%dl
   438d3:	76 e4                	jbe    438b9 <printer_vprintf+0xd1>
   438d5:	eb 97                	jmp    4386e <printer_vprintf+0x86>
        } else if (*format == '*') {
   438d7:	41 80 fc 2a          	cmp    $0x2a,%r12b
   438db:	75 3f                	jne    4391c <printer_vprintf+0x134>
            width = va_arg(val, int);
   438dd:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   438e1:	8b 07                	mov    (%rdi),%eax
   438e3:	83 f8 2f             	cmp    $0x2f,%eax
   438e6:	77 17                	ja     438ff <printer_vprintf+0x117>
   438e8:	89 c2                	mov    %eax,%edx
   438ea:	48 03 57 10          	add    0x10(%rdi),%rdx
   438ee:	83 c0 08             	add    $0x8,%eax
   438f1:	89 07                	mov    %eax,(%rdi)
   438f3:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
   438f6:	48 83 c3 01          	add    $0x1,%rbx
   438fa:	e9 6f ff ff ff       	jmpq   4386e <printer_vprintf+0x86>
            width = va_arg(val, int);
   438ff:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43903:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43907:	48 8d 42 08          	lea    0x8(%rdx),%rax
   4390b:	48 89 41 08          	mov    %rax,0x8(%rcx)
   4390f:	eb e2                	jmp    438f3 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   43911:	41 bd 00 00 00 00    	mov    $0x0,%r13d
   43917:	e9 52 ff ff ff       	jmpq   4386e <printer_vprintf+0x86>
        int width = -1;
   4391c:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
   43922:	e9 47 ff ff ff       	jmpq   4386e <printer_vprintf+0x86>
            ++format;
   43927:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
   4392b:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
   4392f:	8d 48 d0             	lea    -0x30(%rax),%ecx
   43932:	80 f9 09             	cmp    $0x9,%cl
   43935:	76 13                	jbe    4394a <printer_vprintf+0x162>
            } else if (*format == '*') {
   43937:	3c 2a                	cmp    $0x2a,%al
   43939:	74 33                	je     4396e <printer_vprintf+0x186>
            ++format;
   4393b:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
   4393e:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
   43945:	e9 34 ff ff ff       	jmpq   4387e <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
   4394a:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
   4394f:	48 83 c2 01          	add    $0x1,%rdx
   43953:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
   43956:	0f be c0             	movsbl %al,%eax
   43959:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
   4395d:	0f b6 02             	movzbl (%rdx),%eax
   43960:	8d 70 d0             	lea    -0x30(%rax),%esi
   43963:	40 80 fe 09          	cmp    $0x9,%sil
   43967:	76 e6                	jbe    4394f <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
   43969:	48 89 d3             	mov    %rdx,%rbx
   4396c:	eb 1c                	jmp    4398a <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
   4396e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43972:	8b 07                	mov    (%rdi),%eax
   43974:	83 f8 2f             	cmp    $0x2f,%eax
   43977:	77 23                	ja     4399c <printer_vprintf+0x1b4>
   43979:	89 c2                	mov    %eax,%edx
   4397b:	48 03 57 10          	add    0x10(%rdi),%rdx
   4397f:	83 c0 08             	add    $0x8,%eax
   43982:	89 07                	mov    %eax,(%rdi)
   43984:	8b 0a                	mov    (%rdx),%ecx
                ++format;
   43986:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
   4398a:	85 c9                	test   %ecx,%ecx
   4398c:	b8 00 00 00 00       	mov    $0x0,%eax
   43991:	0f 49 c1             	cmovns %ecx,%eax
   43994:	89 45 9c             	mov    %eax,-0x64(%rbp)
   43997:	e9 e2 fe ff ff       	jmpq   4387e <printer_vprintf+0x96>
                precision = va_arg(val, int);
   4399c:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   439a0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   439a4:	48 8d 42 08          	lea    0x8(%rdx),%rax
   439a8:	48 89 41 08          	mov    %rax,0x8(%rcx)
   439ac:	eb d6                	jmp    43984 <printer_vprintf+0x19c>
        switch (*format) {
   439ae:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
   439b3:	e9 f3 00 00 00       	jmpq   43aab <printer_vprintf+0x2c3>
            ++format;
   439b8:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
   439bc:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
   439c1:	e9 bd fe ff ff       	jmpq   43883 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
   439c6:	85 c9                	test   %ecx,%ecx
   439c8:	74 55                	je     43a1f <printer_vprintf+0x237>
   439ca:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   439ce:	8b 07                	mov    (%rdi),%eax
   439d0:	83 f8 2f             	cmp    $0x2f,%eax
   439d3:	77 38                	ja     43a0d <printer_vprintf+0x225>
   439d5:	89 c2                	mov    %eax,%edx
   439d7:	48 03 57 10          	add    0x10(%rdi),%rdx
   439db:	83 c0 08             	add    $0x8,%eax
   439de:	89 07                	mov    %eax,(%rdi)
   439e0:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
   439e3:	48 89 d0             	mov    %rdx,%rax
   439e6:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
   439ea:	49 89 d0             	mov    %rdx,%r8
   439ed:	49 f7 d8             	neg    %r8
   439f0:	25 80 00 00 00       	and    $0x80,%eax
   439f5:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
   439f9:	0b 45 a8             	or     -0x58(%rbp),%eax
   439fc:	83 c8 60             	or     $0x60,%eax
   439ff:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
   43a02:	41 bc c7 4a 04 00    	mov    $0x44ac7,%r12d
            break;
   43a08:	e9 35 01 00 00       	jmpq   43b42 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
   43a0d:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43a11:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43a15:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43a19:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43a1d:	eb c1                	jmp    439e0 <printer_vprintf+0x1f8>
   43a1f:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43a23:	8b 07                	mov    (%rdi),%eax
   43a25:	83 f8 2f             	cmp    $0x2f,%eax
   43a28:	77 10                	ja     43a3a <printer_vprintf+0x252>
   43a2a:	89 c2                	mov    %eax,%edx
   43a2c:	48 03 57 10          	add    0x10(%rdi),%rdx
   43a30:	83 c0 08             	add    $0x8,%eax
   43a33:	89 07                	mov    %eax,(%rdi)
   43a35:	48 63 12             	movslq (%rdx),%rdx
   43a38:	eb a9                	jmp    439e3 <printer_vprintf+0x1fb>
   43a3a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43a3e:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   43a42:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43a46:	48 89 47 08          	mov    %rax,0x8(%rdi)
   43a4a:	eb e9                	jmp    43a35 <printer_vprintf+0x24d>
        int base = 10;
   43a4c:	be 0a 00 00 00       	mov    $0xa,%esi
   43a51:	eb 58                	jmp    43aab <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
   43a53:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43a57:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43a5b:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43a5f:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43a63:	eb 60                	jmp    43ac5 <printer_vprintf+0x2dd>
   43a65:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43a69:	8b 07                	mov    (%rdi),%eax
   43a6b:	83 f8 2f             	cmp    $0x2f,%eax
   43a6e:	77 10                	ja     43a80 <printer_vprintf+0x298>
   43a70:	89 c2                	mov    %eax,%edx
   43a72:	48 03 57 10          	add    0x10(%rdi),%rdx
   43a76:	83 c0 08             	add    $0x8,%eax
   43a79:	89 07                	mov    %eax,(%rdi)
   43a7b:	44 8b 02             	mov    (%rdx),%r8d
   43a7e:	eb 48                	jmp    43ac8 <printer_vprintf+0x2e0>
   43a80:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43a84:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43a88:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43a8c:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43a90:	eb e9                	jmp    43a7b <printer_vprintf+0x293>
   43a92:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
   43a95:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
   43a9c:	bf b0 4c 04 00       	mov    $0x44cb0,%edi
   43aa1:	e9 e2 02 00 00       	jmpq   43d88 <printer_vprintf+0x5a0>
            base = 16;
   43aa6:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
   43aab:	85 c9                	test   %ecx,%ecx
   43aad:	74 b6                	je     43a65 <printer_vprintf+0x27d>
   43aaf:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43ab3:	8b 01                	mov    (%rcx),%eax
   43ab5:	83 f8 2f             	cmp    $0x2f,%eax
   43ab8:	77 99                	ja     43a53 <printer_vprintf+0x26b>
   43aba:	89 c2                	mov    %eax,%edx
   43abc:	48 03 51 10          	add    0x10(%rcx),%rdx
   43ac0:	83 c0 08             	add    $0x8,%eax
   43ac3:	89 01                	mov    %eax,(%rcx)
   43ac5:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
   43ac8:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
   43acc:	85 f6                	test   %esi,%esi
   43ace:	79 c2                	jns    43a92 <printer_vprintf+0x2aa>
        base = -base;
   43ad0:	41 89 f1             	mov    %esi,%r9d
   43ad3:	f7 de                	neg    %esi
   43ad5:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
   43adc:	bf 90 4c 04 00       	mov    $0x44c90,%edi
   43ae1:	e9 a2 02 00 00       	jmpq   43d88 <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
   43ae6:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43aea:	8b 07                	mov    (%rdi),%eax
   43aec:	83 f8 2f             	cmp    $0x2f,%eax
   43aef:	77 1c                	ja     43b0d <printer_vprintf+0x325>
   43af1:	89 c2                	mov    %eax,%edx
   43af3:	48 03 57 10          	add    0x10(%rdi),%rdx
   43af7:	83 c0 08             	add    $0x8,%eax
   43afa:	89 07                	mov    %eax,(%rdi)
   43afc:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
   43aff:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
   43b06:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
   43b0b:	eb c3                	jmp    43ad0 <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
   43b0d:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43b11:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43b15:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43b19:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43b1d:	eb dd                	jmp    43afc <printer_vprintf+0x314>
            data = va_arg(val, char*);
   43b1f:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43b23:	8b 01                	mov    (%rcx),%eax
   43b25:	83 f8 2f             	cmp    $0x2f,%eax
   43b28:	0f 87 a5 01 00 00    	ja     43cd3 <printer_vprintf+0x4eb>
   43b2e:	89 c2                	mov    %eax,%edx
   43b30:	48 03 51 10          	add    0x10(%rcx),%rdx
   43b34:	83 c0 08             	add    $0x8,%eax
   43b37:	89 01                	mov    %eax,(%rcx)
   43b39:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
   43b3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
   43b42:	8b 45 a8             	mov    -0x58(%rbp),%eax
   43b45:	83 e0 20             	and    $0x20,%eax
   43b48:	89 45 8c             	mov    %eax,-0x74(%rbp)
   43b4b:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
   43b51:	0f 85 21 02 00 00    	jne    43d78 <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
   43b57:	8b 45 a8             	mov    -0x58(%rbp),%eax
   43b5a:	89 45 88             	mov    %eax,-0x78(%rbp)
   43b5d:	83 e0 60             	and    $0x60,%eax
   43b60:	83 f8 60             	cmp    $0x60,%eax
   43b63:	0f 84 54 02 00 00    	je     43dbd <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
   43b69:	8b 45 a8             	mov    -0x58(%rbp),%eax
   43b6c:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
   43b6f:	48 c7 45 a0 c7 4a 04 	movq   $0x44ac7,-0x60(%rbp)
   43b76:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
   43b77:	83 f8 21             	cmp    $0x21,%eax
   43b7a:	0f 84 79 02 00 00    	je     43df9 <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
   43b80:	8b 7d 9c             	mov    -0x64(%rbp),%edi
   43b83:	89 f8                	mov    %edi,%eax
   43b85:	f7 d0                	not    %eax
   43b87:	c1 e8 1f             	shr    $0x1f,%eax
   43b8a:	89 45 84             	mov    %eax,-0x7c(%rbp)
   43b8d:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
   43b91:	0f 85 9e 02 00 00    	jne    43e35 <printer_vprintf+0x64d>
   43b97:	84 c0                	test   %al,%al
   43b99:	0f 84 96 02 00 00    	je     43e35 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
   43b9f:	48 63 f7             	movslq %edi,%rsi
   43ba2:	4c 89 e7             	mov    %r12,%rdi
   43ba5:	e8 63 fb ff ff       	callq  4370d <strnlen>
   43baa:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
   43bad:	8b 45 88             	mov    -0x78(%rbp),%eax
   43bb0:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
   43bb3:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
   43bba:	83 f8 22             	cmp    $0x22,%eax
   43bbd:	0f 84 aa 02 00 00    	je     43e6d <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
   43bc3:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
   43bc7:	e8 26 fb ff ff       	callq  436f2 <strlen>
   43bcc:	8b 55 9c             	mov    -0x64(%rbp),%edx
   43bcf:	03 55 98             	add    -0x68(%rbp),%edx
   43bd2:	44 89 e9             	mov    %r13d,%ecx
   43bd5:	29 d1                	sub    %edx,%ecx
   43bd7:	29 c1                	sub    %eax,%ecx
   43bd9:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
   43bdc:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
   43bdf:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
   43be3:	75 2d                	jne    43c12 <printer_vprintf+0x42a>
   43be5:	85 c9                	test   %ecx,%ecx
   43be7:	7e 29                	jle    43c12 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
   43be9:	44 89 fa             	mov    %r15d,%edx
   43bec:	be 20 00 00 00       	mov    $0x20,%esi
   43bf1:	4c 89 f7             	mov    %r14,%rdi
   43bf4:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
   43bf7:	41 83 ed 01          	sub    $0x1,%r13d
   43bfb:	45 85 ed             	test   %r13d,%r13d
   43bfe:	7f e9                	jg     43be9 <printer_vprintf+0x401>
   43c00:	8b 7d 8c             	mov    -0x74(%rbp),%edi
   43c03:	85 ff                	test   %edi,%edi
   43c05:	b8 01 00 00 00       	mov    $0x1,%eax
   43c0a:	0f 4f c7             	cmovg  %edi,%eax
   43c0d:	29 c7                	sub    %eax,%edi
   43c0f:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
   43c12:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
   43c16:	0f b6 07             	movzbl (%rdi),%eax
   43c19:	84 c0                	test   %al,%al
   43c1b:	74 22                	je     43c3f <printer_vprintf+0x457>
   43c1d:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
   43c21:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
   43c24:	0f b6 f0             	movzbl %al,%esi
   43c27:	44 89 fa             	mov    %r15d,%edx
   43c2a:	4c 89 f7             	mov    %r14,%rdi
   43c2d:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
   43c30:	48 83 c3 01          	add    $0x1,%rbx
   43c34:	0f b6 03             	movzbl (%rbx),%eax
   43c37:	84 c0                	test   %al,%al
   43c39:	75 e9                	jne    43c24 <printer_vprintf+0x43c>
   43c3b:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
   43c3f:	8b 45 9c             	mov    -0x64(%rbp),%eax
   43c42:	85 c0                	test   %eax,%eax
   43c44:	7e 1d                	jle    43c63 <printer_vprintf+0x47b>
   43c46:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
   43c4a:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
   43c4c:	44 89 fa             	mov    %r15d,%edx
   43c4f:	be 30 00 00 00       	mov    $0x30,%esi
   43c54:	4c 89 f7             	mov    %r14,%rdi
   43c57:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
   43c5a:	83 eb 01             	sub    $0x1,%ebx
   43c5d:	75 ed                	jne    43c4c <printer_vprintf+0x464>
   43c5f:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
   43c63:	8b 45 98             	mov    -0x68(%rbp),%eax
   43c66:	85 c0                	test   %eax,%eax
   43c68:	7e 27                	jle    43c91 <printer_vprintf+0x4a9>
   43c6a:	89 c0                	mov    %eax,%eax
   43c6c:	4c 01 e0             	add    %r12,%rax
   43c6f:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
   43c73:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
   43c76:	41 0f b6 34 24       	movzbl (%r12),%esi
   43c7b:	44 89 fa             	mov    %r15d,%edx
   43c7e:	4c 89 f7             	mov    %r14,%rdi
   43c81:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
   43c84:	49 83 c4 01          	add    $0x1,%r12
   43c88:	49 39 dc             	cmp    %rbx,%r12
   43c8b:	75 e9                	jne    43c76 <printer_vprintf+0x48e>
   43c8d:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
   43c91:	45 85 ed             	test   %r13d,%r13d
   43c94:	7e 14                	jle    43caa <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
   43c96:	44 89 fa             	mov    %r15d,%edx
   43c99:	be 20 00 00 00       	mov    $0x20,%esi
   43c9e:	4c 89 f7             	mov    %r14,%rdi
   43ca1:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
   43ca4:	41 83 ed 01          	sub    $0x1,%r13d
   43ca8:	75 ec                	jne    43c96 <printer_vprintf+0x4ae>
    for (; *format; ++format) {
   43caa:	4c 8d 63 01          	lea    0x1(%rbx),%r12
   43cae:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
   43cb2:	84 c0                	test   %al,%al
   43cb4:	0f 84 fe 01 00 00    	je     43eb8 <printer_vprintf+0x6d0>
        if (*format != '%') {
   43cba:	3c 25                	cmp    $0x25,%al
   43cbc:	0f 84 54 fb ff ff    	je     43816 <printer_vprintf+0x2e>
            p->putc(p, *format, color);
   43cc2:	0f b6 f0             	movzbl %al,%esi
   43cc5:	44 89 fa             	mov    %r15d,%edx
   43cc8:	4c 89 f7             	mov    %r14,%rdi
   43ccb:	41 ff 16             	callq  *(%r14)
            continue;
   43cce:	4c 89 e3             	mov    %r12,%rbx
   43cd1:	eb d7                	jmp    43caa <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
   43cd3:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43cd7:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   43cdb:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43cdf:	48 89 47 08          	mov    %rax,0x8(%rdi)
   43ce3:	e9 51 fe ff ff       	jmpq   43b39 <printer_vprintf+0x351>
            color = va_arg(val, int);
   43ce8:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43cec:	8b 07                	mov    (%rdi),%eax
   43cee:	83 f8 2f             	cmp    $0x2f,%eax
   43cf1:	77 10                	ja     43d03 <printer_vprintf+0x51b>
   43cf3:	89 c2                	mov    %eax,%edx
   43cf5:	48 03 57 10          	add    0x10(%rdi),%rdx
   43cf9:	83 c0 08             	add    $0x8,%eax
   43cfc:	89 07                	mov    %eax,(%rdi)
   43cfe:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
   43d01:	eb a7                	jmp    43caa <printer_vprintf+0x4c2>
            color = va_arg(val, int);
   43d03:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43d07:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43d0b:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43d0f:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43d13:	eb e9                	jmp    43cfe <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
   43d15:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43d19:	8b 01                	mov    (%rcx),%eax
   43d1b:	83 f8 2f             	cmp    $0x2f,%eax
   43d1e:	77 23                	ja     43d43 <printer_vprintf+0x55b>
   43d20:	89 c2                	mov    %eax,%edx
   43d22:	48 03 51 10          	add    0x10(%rcx),%rdx
   43d26:	83 c0 08             	add    $0x8,%eax
   43d29:	89 01                	mov    %eax,(%rcx)
   43d2b:	8b 02                	mov    (%rdx),%eax
   43d2d:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
   43d30:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
   43d34:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
   43d38:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
   43d3e:	e9 ff fd ff ff       	jmpq   43b42 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
   43d43:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43d47:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   43d4b:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43d4f:	48 89 47 08          	mov    %rax,0x8(%rdi)
   43d53:	eb d6                	jmp    43d2b <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
   43d55:	84 d2                	test   %dl,%dl
   43d57:	0f 85 39 01 00 00    	jne    43e96 <printer_vprintf+0x6ae>
   43d5d:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
   43d61:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
   43d65:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
   43d69:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
   43d6d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
   43d73:	e9 ca fd ff ff       	jmpq   43b42 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
   43d78:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
   43d7e:	bf b0 4c 04 00       	mov    $0x44cb0,%edi
        if (flags & FLAG_NUMERIC) {
   43d83:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
   43d88:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
   43d8c:	4c 89 c1             	mov    %r8,%rcx
   43d8f:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
   43d93:	48 63 f6             	movslq %esi,%rsi
   43d96:	49 83 ec 01          	sub    $0x1,%r12
   43d9a:	48 89 c8             	mov    %rcx,%rax
   43d9d:	ba 00 00 00 00       	mov    $0x0,%edx
   43da2:	48 f7 f6             	div    %rsi
   43da5:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
   43da9:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
   43dad:	48 89 ca             	mov    %rcx,%rdx
   43db0:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
   43db3:	48 39 d6             	cmp    %rdx,%rsi
   43db6:	76 de                	jbe    43d96 <printer_vprintf+0x5ae>
   43db8:	e9 9a fd ff ff       	jmpq   43b57 <printer_vprintf+0x36f>
                prefix = "-";
   43dbd:	48 c7 45 a0 c4 4a 04 	movq   $0x44ac4,-0x60(%rbp)
   43dc4:	00 
            if (flags & FLAG_NEGATIVE) {
   43dc5:	8b 45 a8             	mov    -0x58(%rbp),%eax
   43dc8:	a8 80                	test   $0x80,%al
   43dca:	0f 85 b0 fd ff ff    	jne    43b80 <printer_vprintf+0x398>
                prefix = "+";
   43dd0:	48 c7 45 a0 bf 4a 04 	movq   $0x44abf,-0x60(%rbp)
   43dd7:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
   43dd8:	a8 10                	test   $0x10,%al
   43dda:	0f 85 a0 fd ff ff    	jne    43b80 <printer_vprintf+0x398>
                prefix = " ";
   43de0:	a8 08                	test   $0x8,%al
   43de2:	ba c7 4a 04 00       	mov    $0x44ac7,%edx
   43de7:	b8 c6 4a 04 00       	mov    $0x44ac6,%eax
   43dec:	48 0f 44 c2          	cmove  %rdx,%rax
   43df0:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
   43df4:	e9 87 fd ff ff       	jmpq   43b80 <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
   43df9:	41 8d 41 10          	lea    0x10(%r9),%eax
   43dfd:	a9 df ff ff ff       	test   $0xffffffdf,%eax
   43e02:	0f 85 78 fd ff ff    	jne    43b80 <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
   43e08:	4d 85 c0             	test   %r8,%r8
   43e0b:	75 0d                	jne    43e1a <printer_vprintf+0x632>
   43e0d:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
   43e14:	0f 84 66 fd ff ff    	je     43b80 <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
   43e1a:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
   43e1e:	ba c8 4a 04 00       	mov    $0x44ac8,%edx
   43e23:	b8 c1 4a 04 00       	mov    $0x44ac1,%eax
   43e28:	48 0f 44 c2          	cmove  %rdx,%rax
   43e2c:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
   43e30:	e9 4b fd ff ff       	jmpq   43b80 <printer_vprintf+0x398>
            len = strlen(data);
   43e35:	4c 89 e7             	mov    %r12,%rdi
   43e38:	e8 b5 f8 ff ff       	callq  436f2 <strlen>
   43e3d:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
   43e40:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
   43e44:	0f 84 63 fd ff ff    	je     43bad <printer_vprintf+0x3c5>
   43e4a:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
   43e4e:	0f 84 59 fd ff ff    	je     43bad <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
   43e54:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
   43e57:	89 ca                	mov    %ecx,%edx
   43e59:	29 c2                	sub    %eax,%edx
   43e5b:	39 c1                	cmp    %eax,%ecx
   43e5d:	b8 00 00 00 00       	mov    $0x0,%eax
   43e62:	0f 4e d0             	cmovle %eax,%edx
   43e65:	89 55 9c             	mov    %edx,-0x64(%rbp)
   43e68:	e9 56 fd ff ff       	jmpq   43bc3 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
   43e6d:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
   43e71:	e8 7c f8 ff ff       	callq  436f2 <strlen>
   43e76:	8b 7d 98             	mov    -0x68(%rbp),%edi
   43e79:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
   43e7c:	44 89 e9             	mov    %r13d,%ecx
   43e7f:	29 f9                	sub    %edi,%ecx
   43e81:	29 c1                	sub    %eax,%ecx
   43e83:	44 39 ea             	cmp    %r13d,%edx
   43e86:	b8 00 00 00 00       	mov    $0x0,%eax
   43e8b:	0f 4d c8             	cmovge %eax,%ecx
   43e8e:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
   43e91:	e9 2d fd ff ff       	jmpq   43bc3 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
   43e96:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
   43e99:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
   43e9d:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
   43ea1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
   43ea7:	e9 96 fc ff ff       	jmpq   43b42 <printer_vprintf+0x35a>
        int flags = 0;
   43eac:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
   43eb3:	e9 b0 f9 ff ff       	jmpq   43868 <printer_vprintf+0x80>
}
   43eb8:	48 83 c4 58          	add    $0x58,%rsp
   43ebc:	5b                   	pop    %rbx
   43ebd:	41 5c                	pop    %r12
   43ebf:	41 5d                	pop    %r13
   43ec1:	41 5e                	pop    %r14
   43ec3:	41 5f                	pop    %r15
   43ec5:	5d                   	pop    %rbp
   43ec6:	c3                   	retq   

0000000000043ec7 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
   43ec7:	55                   	push   %rbp
   43ec8:	48 89 e5             	mov    %rsp,%rbp
   43ecb:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
   43ecf:	48 c7 45 f0 d2 35 04 	movq   $0x435d2,-0x10(%rbp)
   43ed6:	00 
        cpos = 0;
   43ed7:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
   43edd:	b8 00 00 00 00       	mov    $0x0,%eax
   43ee2:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
   43ee5:	48 63 ff             	movslq %edi,%rdi
   43ee8:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
   43eef:	00 
   43ef0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
   43ef4:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
   43ef8:	e8 eb f8 ff ff       	callq  437e8 <printer_vprintf>
    return cp.cursor - console;
   43efd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43f01:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
   43f07:	48 d1 f8             	sar    %rax
}
   43f0a:	c9                   	leaveq 
   43f0b:	c3                   	retq   

0000000000043f0c <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
   43f0c:	55                   	push   %rbp
   43f0d:	48 89 e5             	mov    %rsp,%rbp
   43f10:	48 83 ec 50          	sub    $0x50,%rsp
   43f14:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   43f18:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   43f1c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
   43f20:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   43f27:	48 8d 45 10          	lea    0x10(%rbp),%rax
   43f2b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   43f2f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   43f33:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
   43f37:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   43f3b:	e8 87 ff ff ff       	callq  43ec7 <console_vprintf>
}
   43f40:	c9                   	leaveq 
   43f41:	c3                   	retq   

0000000000043f42 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
   43f42:	55                   	push   %rbp
   43f43:	48 89 e5             	mov    %rsp,%rbp
   43f46:	53                   	push   %rbx
   43f47:	48 83 ec 28          	sub    $0x28,%rsp
   43f4b:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
   43f4e:	48 c7 45 d8 58 36 04 	movq   $0x43658,-0x28(%rbp)
   43f55:	00 
    sp.s = s;
   43f56:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
   43f5a:	48 85 f6             	test   %rsi,%rsi
   43f5d:	75 0b                	jne    43f6a <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
   43f5f:	8b 45 e0             	mov    -0x20(%rbp),%eax
   43f62:	29 d8                	sub    %ebx,%eax
}
   43f64:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   43f68:	c9                   	leaveq 
   43f69:	c3                   	retq   
        sp.end = s + size - 1;
   43f6a:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
   43f6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
   43f73:	be 00 00 00 00       	mov    $0x0,%esi
   43f78:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
   43f7c:	e8 67 f8 ff ff       	callq  437e8 <printer_vprintf>
        *sp.s = 0;
   43f81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43f85:	c6 00 00             	movb   $0x0,(%rax)
   43f88:	eb d5                	jmp    43f5f <vsnprintf+0x1d>

0000000000043f8a <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
   43f8a:	55                   	push   %rbp
   43f8b:	48 89 e5             	mov    %rsp,%rbp
   43f8e:	48 83 ec 50          	sub    $0x50,%rsp
   43f92:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   43f96:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   43f9a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   43f9e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   43fa5:	48 8d 45 10          	lea    0x10(%rbp),%rax
   43fa9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   43fad:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   43fb1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
   43fb5:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   43fb9:	e8 84 ff ff ff       	callq  43f42 <vsnprintf>
    va_end(val);
    return n;
}
   43fbe:	c9                   	leaveq 
   43fbf:	c3                   	retq   

0000000000043fc0 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
   43fc0:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   43fc5:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
   43fca:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
   43fcf:	48 83 c0 02          	add    $0x2,%rax
   43fd3:	48 39 d0             	cmp    %rdx,%rax
   43fd6:	75 f2                	jne    43fca <console_clear+0xa>
    }
    cursorpos = 0;
   43fd8:	c7 05 1a 50 07 00 00 	movl   $0x0,0x7501a(%rip)        # b8ffc <cursorpos>
   43fdf:	00 00 00 
}
   43fe2:	c3                   	retq   
