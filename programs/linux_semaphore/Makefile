
CC := gcc

semaphore: semaphore.o
	$(CC) -o $@ $^ -lpthread

clean:
	-rm -f semaphore semaphore.o

%.o: %.c
	$(CC) -c -g -o $@ $^
