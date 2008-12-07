
CC := gcc

all: getopt

getopt: getopt.o
	$(CC) -o $@ $^

%.o: %.c
	$(CC) -g -c -o $@ $^

clean:
	-rm -f *.o getopt
