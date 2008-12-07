
#include <stdio.h>
#include <getopt.h>

int req_arg;

int main(int argc, char **argv) {

    int ret;
    int longindex;

    static struct option long_options[] = {
        { "no-arg", no_argument, NULL, 1 },
        { "one-arg", required_argument, &req_arg, 10 },
        { "opt-arg", optional_argument, NULL, 2 },
        { 0 },
    };

    static const char *option_string = "01:O::";

    while (1) {
        ret = getopt_long(argc, argv, option_string, long_options, &longindex);

        if (-1 == ret) {
            printf("End of options\n");
            break;
        } else if ('?' == ret) {
            printf("An error occured!\n");
            break;
        }

        switch (ret) {
            case '0':
                printf("Option 0 found\n"); /* optarg, obviously, points to NULL */
                printf("optind is %d\n", optind);
                break;

            case '1':
                printf("Option 1 found; the argument is %s\n", optarg);
                printf("optind is %d\n", optind);
                break;

            case 'O':
                /* optarg may be NULL (-O xyz). -Oxyz is OK */
                printf("Option O found; the argument is %s\n", optarg);
                printf("optind is %d\n", optind);
                break;

            case 1:
                printf("Option --no-arg found; the argument is %s\n", optarg);
                printf("longindex is %d\n", longindex);
                break;

            case 2:
                /* optarg may be NULL (-O xyz). -Oxyz is OK */
                printf("Option --opt-arg found; the argument is %s\n", optarg);
                printf("longindex is %d\n", longindex);
                break;
        }
    }

    printf("req_arg is %d\n", req_arg);

    return 0;
}
