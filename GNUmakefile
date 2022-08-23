IMAGE = weensyos.img
all: $(IMAGE)
-include build/rules.mk

# '$(TEST_FILE)' controls which of the default test cases will be replaced
# when running test-%
# By default this is p-test.c
# A backup exists in tests/bck
TEST_FILE ?= p-test.c
TEST_DIR = ./tests/

# '$(V)' controls whether the lab makefiles print verbose commands (the
# actual shell commands run by Make), as well as the "overview" commands
# (such as '+ cc lib/readline.c').
#
# For overview commands only, run 'make all'.
# For overview and verbose commands, run 'make V=1 all'.
V = 0

# 'HOST_FILE' will contain the hostname of the machine running $(QEMU)
# This allows us to kill process in remote machine if needed
# 'HOST_LOCK' is the name of the lockfile
HOST_FILE='.hosts.txt'
HOST_LOCK='.hosts.lock'

ifeq ($(V),1)
compile = $(CC) $(CPPFLAGS) $(CFLAGS) $(DEPCFLAGS) $(1)
link = $(LD) $(LDFLAGS) $(1)
run = $(1) $(3)
cpy = $(shell cat $(1) > ./$(TEST_FILE))
else
compile = @/bin/echo " " $(2) $< && $(CC) $(CPPFLAGS) $(CFLAGS) $(DEPCFLAGS) $(1)
link = @/bin/echo " " $(2) $(patsubst %.full,%,$@) && $(LD) $(LDFLAGS) $(1)
run = @$(if $(2),/bin/echo " " $(2) $(3) &&,) $(1) $(3)
cpy = @/bin/echo " " $(shell cat $(1) > ./$(TEST_FILE))
endif


# Object sets

BOOT_OBJS = $(OBJDIR)/bootstart.o $(OBJDIR)/boot.o

KERNEL_OBJS = $(OBJDIR)/k-exception.o $(OBJDIR)/kernel.o \
	$(OBJDIR)/k-hardware.o $(OBJDIR)/vm.o $(OBJDIR)/k-loader.o $(OBJDIR)/lib.o
KERNEL_LINKER_FILES = link/kernel.ld link/shared.ld

PROCESS_BINARIES = $(OBJDIR)/p-allocator $(OBJDIR)/p-allocator2 \
	$(OBJDIR)/p-allocator3 $(OBJDIR)/p-allocator4 \
	$(OBJDIR)/p-fork $(OBJDIR)/p-forkexit $(OBJDIR)/p-test
PROCESS_LIB_OBJS = $(OBJDIR)/lib.o $(OBJDIR)/process.o
ALLOCATOR_OBJS = $(OBJDIR)/p-allocator.o $(PROCESS_LIB_OBJS)
PROCESS_OBJS = $(OBJDIR)/p-allocator.o $(OBJDIR)/p-fork.o \
	$(OBJDIR)/p-forkexit.o $(PROCESS_LIB_OBJS) $(OBJDIR)/p-test.o
PROCESS_LINKER_FILES = link/process.ld link/shared.ld


# Generic rules for making object files

$(PROCESS_OBJS): $(OBJDIR)/%.o: %.c $(BUILDSTAMPS)
	$(call compile,-O1 -DWEENSYOS_PROCESS -c $< -o $@,COMPILE)

$(OBJDIR)/%.o: %.c $(BUILDSTAMPS)
	$(call compile,-DWEENSYOS_KERNEL -c $< -o $@,COMPILE)

$(OBJDIR)/boot.o: $(OBJDIR)/%.o: boot.c $(BUILDSTAMPS)
	$(call compile,-Os -fomit-frame-pointer -c $< -o $@,COMPILE)

$(OBJDIR)/%.o: %.S $(BUILDSTAMPS)
	$(call compile,-c $< -o $@,ASSEMBLE)


# Specific rules for WeensyOS

$(OBJDIR)/kernel.full: $(KERNEL_OBJS) $(PROCESS_BINARIES) $(KERNEL_LINKER_FILES)
	$(call link,-T $(KERNEL_LINKER_FILES) -o $@ $(KERNEL_OBJS) -b binary $(PROCESS_BINARIES),LINK)

$(OBJDIR)/p-%.full: $(OBJDIR)/p-%.o $(PROCESS_LIB_OBJS) $(PROCESS_LINKER_FILES)
	$(call link,-T $(PROCESS_LINKER_FILES) -o $@ $< $(PROCESS_LIB_OBJS),LINK)

$(OBJDIR)/p-allocator%.full: $(ALLOCATOR_OBJS) link/p-allocator%.ld link/shared.ld
	$(call link,-T link/p-allocator$*.ld link/shared.ld -o $@ $(ALLOCATOR_OBJS),LINK)

$(OBJDIR)/%: $(OBJDIR)/%.full
	$(call run,$(OBJDUMP) -S $< >$@.asm)
	$(call run,$(NM) -n $< >$@.sym)
	$(call run,$(OBJCOPY) -j .text -j .rodata -j .data -j .bss $<,STRIP,$@)

$(OBJDIR)/bootsector: $(BOOT_OBJS) link/boot.ld link/shared.ld
	$(call link,-T link/boot.ld link/shared.ld -o $@.full $(BOOT_OBJS),LINK)
	$(call run,$(OBJDUMP) -S $@.full >$@.asm)
	$(call run,$(NM) -n $@.full >$@.sym)
	$(call run,$(OBJCOPY) -S -O binary -j .text $@.full $@)

$(OBJDIR)/mkbootdisk: build/mkbootdisk.c $(BUILDSTAMPS)
	$(call run,$(HOSTCC) -I. -o $(OBJDIR)/mkbootdisk,HOSTCOMPILE,build/mkbootdisk.c)

weensyos.img: $(OBJDIR)/mkbootdisk $(OBJDIR)/bootsector $(OBJDIR)/kernel
	$(call run,$(OBJDIR)/mkbootdisk $(OBJDIR)/bootsector $(OBJDIR)/kernel > $@,CREATE $@)


run-%: run-qemu-%
	@:

run-qemu-%: run-$(QEMUDISPLAY)-%
	@:

run-graphic-%: %.img check-qemu
	@lockfile -r 0 ./$(HOST_LOCK) || (printf "Error, could not obtain lock. Are you running a session in - " && cat $(HOST_FILE); printf "if so try running make kill-lock, otherwise ssh in manually and run make kill" ; exit 1)
	@hostname > $(HOST_FILE) 
	$(call run,$(QEMU_PRELOAD) $(QEMU) $(QEMUOPT) $(QEMUIMG),QEMU $<)
	@rm -f ./$(HOST_FILE)
	@rm -f ./$(HOST_LOCK)

run-console-%: %.img check-qemu
	@lockfile -r 0 ./$(HOST_LOCK) || (printf "Error, could not obtain lock. Are you running a session in - " && cat $(HOST_FILE); printf "if so try running make kill-lock, otherwise ssh in manually and run make kill" ; exit 1)
	@hostname > $(HOST_FILE) 
	$(call run,$(QEMU_PRELOAD) $(QEMU) $(QEMUOPT) -curses $(QEMUIMG),QEMU $<)
	@rm -f ./$(HOST_FILE)
	@rm -f ./$(HOST_LOCK)

run-monitor-%: %.img check-qemu
	@lockfile -r 0 ./$(HOST_LOCK) || (printf "Error, could not obtain lock. Are you running a session in - " && cat $(HOST_FILE); printf "if so try running make kill-lock, otherwise ssh in manually and run make kill" ; exit 1)
	@hostname > $(HOST_FILE) 
	$(call run,$(QEMU_PRELOAD) $(QEMU) $(QEMUOPT) -monitor stdio $(QEMUIMG),QEMU $<)
	@rm -f ./$(HOST_FILE)
	@rm -f ./$(HOST_LOCK)

run-gdb-%: run-gdb-$(QEMUDISPLAY)-%
	@:

run-gdb-graphic-%: %.img check-qemu
	@lockfile -r 0 ./$(HOST_LOCK) || (printf "Error, could not obtain lock. Are you running a session in - " && cat $(HOST_FILE); printf "if so try running make kill-lock, otherwise ssh in manually and run make kill" ; exit 1)
	@hostname > $(HOST_FILE) 
	$(call run,$(QEMU_PRELOAD) $(QEMU) $(QEMUOPT) -gdb tcp::1234 $(QEMUIMG) &,QEMU $<)
	$(call run,sleep 0.5; gdb -x .gdbinit,GDB)
	@rm -f ./$(HOST_FILE)
	@rm -f ./$(HOST_LOCK)

run-gdb-console-%: %.img check-qemu
	@lockfile -r 0 ./$(HOST_LOCK) || (printf "Error, could not obtain lock. Are you running a session in - " && cat $(HOST_FILE); printf "if so try running make kill-lock, otherwise ssh in manually and run make kill" ; exit 1)
	@hostname > $(HOST_FILE) 
	$(call run,$(QEMU_PRELOAD) $(QEMU) $(QEMUOPT) -curses -gdb tcp::1234 $(QEMUIMG),QEMU $<)
	@rm -f ./$(HOST_FILE)
	@rm -f ./$(HOST_LOCK)

run: run-qemu-$(basename $(IMAGE))
run-qemu: run-qemu-$(basename $(IMAGE))
run-graphic: run-graphic-$(basename $(IMAGE))
run-console: run-console-$(basename $(IMAGE))
run-monitor: run-monitor-$(basename $(IMAGE))
run-quit: run-quit-$(basename $(IMAGE))
run-gdb: run-gdb-$(basename $(IMAGE))
run-gdb-graphic: run-gdb-graphic-$(basename $(IMAGE))
run-gdb-console: run-gdb-console-$(basename $(IMAGE))
run-graphic-gdb: run-gdb-graphic-$(basename $(IMAGE))
run-console-gdb: run-gdb-console-$(basename $(IMAGE))

test-%: $(TEST_DIR)/p-%.c
	$(call cpy, $<)

restore:
	$(shell cp $(TEST_DIR)/bck/*.c ./)

# Kill all my qemus
kill:
	-killall -u $$(whoami) $(QEMU)
	@sleep 0.2; if ps -U $$(whoami) | grep $(QEMU) >/dev/null; then killall -9 -u $$(whoami) $(QEMU); fi

kill-lock:
	HOST=$$(cat $(HOST_FILE));HOST_CMD=hostname; if [ "$$HOST" == "$$HOST_CMD" ]; then  make kill; else echo $$HOST;CWD=$$(pwd);ssh $$HOST "cd $$CWD;make kill;" && make clean-secret;fi


.PHONY:
clean-secret:
	rm -f $(HOST_LOCK) $(HOST_FILE)
