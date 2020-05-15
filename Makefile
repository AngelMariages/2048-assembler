CC		= gcc
CFLAGS 	= -no-pie
OUT 	= 2Kp1
OUT2	= 2Kp2

all: $(OUT) clean
all2: $(OUT2) clean

2Kp1: 2Kp1.o 2Kp1c.c
	$(CC) $(CFLAGS) 2Kp1c.c 2Kp1.o -o $(OUT)

2Kp1.o: 2Kp1.asm
	yasm -felf64 -gdwarf2 2Kp1.asm

2Kp2: 2Kp2.o 2Kp2c.c
	$(CC) $(CFLAGS) 2Kp2c.c 2Kp2.o -o $(OUT2)

2Kp2.o: 2Kp2.asm
	yasm -felf64 -gdwarf2 2Kp2.asm


.PHONY: clean
clean:
	rm -f *.o

.PHONY: run
run:
	make
	./2Kp1

.PHONY: run2
run2:
	make all2
	./2Kp2