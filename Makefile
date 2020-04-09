CC		= gcc
CFLAGS 	= -no-pie
OUT 	= 2Kp1

all: $(OUT) clean

2Kp1: 2Kp1.o 2Kp1c.c
	$(CC) $(CFLAGS) 2Kp1c.c 2Kp1.o -o $(OUT)

2Kp1.o: 2Kp1.asm
	yasm -felf64 -gdwarf2 2Kp1.asm


.PHONY: clean
clean:
	rm -f *.o

.PHONY: run
run:
	make
	./2Kp1