#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define BUFSIZE 1024
#define HASHSETMAX 128
#define MAXCARDS 6

#ifndef max
#define max(a,b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a > _b ? _a : _b; })
#endif

int char_to_digit(char c);
int pow_ten(int pow);
int parse_winning_nums(char *buf, bool *set);
int total_card_value(const char *path);
void test_total_card_value(void);

// PART 2
int win_count(char *buf, bool *set);
int total_cards(const char *path);

//int main(int argc, char *argv[]) {
int main(void) {
    const char *path = "data/input.dat";

    // PART 1
    //test_total_card_value();
    //printf("Card Value: %d\n", total_card_value(path));
    
    // PART 2
    printf("Card Count: %d\n", total_cards("data/calibration.dat"));
 
    return 0;
}

int char_to_digit(char c) {
    return ((int)c - (int)'0');
}

int pow_ten(int pow) {
    switch (pow) {
        case 0:
            return 1;
        case 1:
            return 1E1;
        case 2:
            return 1E2;
        case 3:
            return 1E3;
        case 4:
            return 1E4;
        case 5:
            return 1E5;
        case 6:
            return 1E6;
        default:
            return INT_MAX;
    }
}

int parse_winning_nums(char *buf, bool *set) {
    char *p = buf;

    //if (buf == NULL || set == NULL)
    //    return -1;

    // Find delimiter for winning numbers.
    while (*p && *p != '|')
        ++p;

    if (*p != '|')
        return -1;

    --p;

    // Parse all the winning numbers
    int num = 0;
    int pow = 0;
    while (true) {

        // Find next number
        while (*p == ' ')
            --p;

        if (*p == ':')
            break;

        // Number found, begin parse
        num = 0;
        pow = 0;
        while (*p != ' ') {
            num += char_to_digit(*p) * pow_ten(pow);
            --p;
            pow += 1;
        }

        //printf("SET: %d\n", num);
        // Store number in hash set (n = i)
        set[num] = true;
    }

    return 0;
}

int card_value(char *buf, bool *set) {
    char *p = buf;
    int count = 0;

    // Go to end of string
    while (*(++p) != '\n');

    --p;

    // Parse all numbers you have
    int num = 0;
    int pow = 0;
    while (true) {

        if (*p == '|')
            break;

        // Number found, begin parse
        num = 0;
        pow = 0;
        while (*p != ' ') {
            num += char_to_digit(*p) * pow_ten(pow);
            --p;
            pow += 1;
        }

        if (set[num])
            ++count;

        // Find next number
        while (*p == ' ')
            --p;
    }


    if (!count) {
        return 0;
    }

    //printf("Card Value: %d\n", (1 << (count - 1)));

    return (1 << (count - 1));
}

// PART 1
int total_card_value(const char *path) {
    FILE *infile = fopen(path, "r");
    if (infile == NULL) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    char buffer[BUFSIZE] = {0};
    bool num_set[HASHSETMAX] = {false};
    int total = 0;

    printf("\n");
    while (fgets(buffer, BUFSIZE, infile)) {
        parse_winning_nums(buffer, num_set);
        total += card_value(buffer, num_set);
        memset(num_set, false, HASHSETMAX);
        //fprintf(stdout, "%s", buffer);
    }

    fclose(infile);
    return total;
}

void test_total_card_value(void) {
    assert(total_card_value("data/calibration.dat") == 13);
}

// PART 2
int win_count(char *buf, bool *set) {
    char *p = buf;
    int count = 0;

    // Go to end of string
    while (*(++p) != '\n');

    --p;

    // Parse all numbers you have
    int num = 0;
    int pow = 0;
    while (true) {

        if (*p == '|')
            break;

        // Number found, begin parse
        num = 0;
        pow = 0;
        while (*p != ' ') {
            num += char_to_digit(*p) * pow_ten(pow);
            --p;
            pow += 1;
        }

        if (set[num])
            ++count;

        // Find next number
        while (*p == ' ')
            --p;
    }

    return count;
}

int total_cards(const char *path) {
    FILE *infile = fopen(path, "r");
    if (infile == NULL) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    char buffer[BUFSIZE] = {0};
    bool num_set[HASHSETMAX] = {false};
    int card_counts[MAXCARDS] = {0};
    int card = 1;
    int i = 0;
    int count = 0;

    printf("\n");
    while (fgets(buffer, BUFSIZE, infile)) {
        parse_winning_nums(buffer, num_set);
        count = win_count(buffer, num_set);
        printf("COUNT: %d\n", count);

        i = 0;
        while (i < count && (card + i) < MAXCARDS) {
            card_counts[card + i] += card_counts[card];
            ++i;
        }
        
        memset(num_set, false, HASHSETMAX);
        card += 1;
    }

    int total = 0;
    for (i = 0; i < MAXCARDS; ++i) {
        total += card_counts[i];
    }

    fclose(infile);
    return total;
}
