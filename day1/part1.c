#include <stdio.h>

int getLineTotal(int a);

int main() {
    //FILE *fptr;

    // Open a file in read mode
    //fptr = fopen("input.txt", "r");

    //char buf[200];
    //int firstDigit = -1;
    //int lastDigit = -1;
    int total = 0;
    //while (fgets(buf, sizeof buf, fptr) != NULL) {
    //    total += getLineTotal(buf);
    //}

    int i = 0;
    while (i < 6) {
        total = getLineTotal(i);
        i++;
    }
          
    printf("Total %i\n", total);

    //if (feof(fptr)) {
    //    printf("Total %i", total);
    //}

    // Close the file
    //fclose(fptr);

    return 0;
}

int getLineTotal(int a) {
    return a + 1;
}

/* int getLineTotal(char *buf) {
    int firstDigit = -1;
    int lastDigit = -1;
    int lineTotal = 0;
    //printf("%s", buf);
    int i = 0;
    while (buf[i] != 0) {
        char c = buf[i];
        if (c >= 48 && c <= 57) {
            if (firstDigit == -1) {
                firstDigit = c - 48;
                //printf("FD: %i - ", firstDigit);
            } else {
                lastDigit = c - 48;
                //printf("LD: %i - ", lastDigit);
            }
        }
        i++;
    }
    if (lastDigit == -1) {
        lineTotal = 11 * firstDigit;
    } else {
        lineTotal += firstDigit * 10;
        lineTotal += lastDigit;
    }
    return lineTotal;
} */