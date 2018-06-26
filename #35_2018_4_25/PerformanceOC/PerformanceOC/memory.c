//
//  memory.c
//  Performance
//
//  Created by Phink on 4/24/18.
//

#include "memory.h"

#define MATRIX_SIZE 5000
static double array[MATRIX_SIZE][MATRIX_SIZE];

double loopDis (void) {
    double sum = 0;
    for (int j = 0; j < MATRIX_SIZE; j++) {
        for (int i = 0; i < MATRIX_SIZE; i++) {
            array[i][j] = (double)i;
            sum += array[i][j];
        }
    }
    return sum;
}













double loopCon (void) {
    double sum = 0;
    for (int i = 0; i < MATRIX_SIZE; i++) {
        for (int j = 0; j < MATRIX_SIZE; j++) {
            array[i][j] = (double)i;
            sum += array[i][j];
        }
    }
    return sum;
}
