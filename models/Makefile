CC=gcc
OPTS=-g -Wall

all: main.o bpu.o
	$(CC) $(OPTS) -lm -o bpu main.o bpu.o

main.o: main.c bpu.h
	$(CC) $(OPTS) -c main.c

bpu.o: bpu.h bpu.c
	$(CC) $(OPTS) -c bpu.c

clean:
	rm -f *.o bpu;
