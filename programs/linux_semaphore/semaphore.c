
#include <semaphore.h>
#include <pthread.h>
#include <stdio.h>
/* A simple program on how to use semaphores in Linux */

sem_t semaphore;
int   count;            /* All of the threads print and increment this value */

#define NTHREADS        5
#define THREAD_ITER     10

void* my_thread(void *p) {
    int my_id = (int)p;
    int local_count = THREAD_ITER;

    while (local_count > 0) {
        /* Wait for the semaphore */
        if (0 != sem_wait(&semaphore)) {
            printf("Error capturing semaphore\n");
            pthread_exit(NULL);
        }

        /* Increment the count */
        printf("Thread %d: %d\n", my_id, count);
        count++;

        /* Relase semaphore */
        if (0 != sem_post(&semaphore)) {
            printf("Error releasing semaphore\n");
            pthread_exit(NULL);
        }

        usleep(100000);
        local_count--;
    }

    return NULL;
}

int main() {
    pthread_t thread[NTHREADS];

    int index;
    int rel_fail = 0;

    /* Initialize semaphore; initial value is 0 so that all threads will keep waiting for it until
     * the main thread does a sem_post()
     */
    if (0 != sem_init(&semaphore, 0, 0)) {
        printf("Error initializing semaphore\n");
        return 1;
    }

    /* Create all threads */
    for (index = 0; index < NTHREADS; index++) {
        if (0 != pthread_create(&thread[index], NULL, my_thread, (void*)index)) {
            printf("Error creating threads\n");
            return 2;
        }
    }

    if (0 != sem_post(&semaphore)) {
        printf("Error releasing semaphore\n");
        rel_fail = 1;
    }

    /* If release fails, then kill all the threads and then exit */
    for (index = 0; index < NTHREADS; index++) {
        if (rel_fail) {
            pthread_cancel(thread[index]);
        }
        pthread_join(thread[index], NULL);
    }

    return 0;
}
