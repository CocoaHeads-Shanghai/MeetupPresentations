//
//  DotProductTest.m
//  PerformanceOCTests
//
//  Created by Phink on 4/24/18.
//  Copyright © 2018 Senten Sarl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Accelerate/Accelerate.h>

#define VECTOR_SIZE 1024

@interface DotProductTest : XCTestCase
{
    float a[VECTOR_SIZE];
    float b[VECTOR_SIZE];
}
@end

@implementation DotProductTest

- (void)setUp {
    [super setUp];
    float sum = 0.0;
    for (int i = 0; i < VECTOR_SIZE; i++) {
        a[i] = sqrt(i);
        b[i] = sqrt(i);
        sum += i;
    }
    fprintf (stderr, "Expected %f\n", sum);
}

#define DOT_COUNT (100 * 1000)

- (void) dotWithLoop
{
    float result = 0.0;
    for (int k = 0; k < DOT_COUNT; k++) {
        float dotProduct = 0.0;
        for (int i = 0; i < VECTOR_SIZE; i++) {
            dotProduct += a[i] * b[i];
        }
        result = dotProduct;
    }
    fprintf (stderr, "Result: %f\n", result);
}


- (void) dotWithAccelerate
{
    float result = 0.0;
    for (int k = 0; k < DOT_COUNT; k++) {
        float dotProduct = 0.0;
        vDSP_dotpr(a, 1, b, 1, &dotProduct, VECTOR_SIZE);
        result = dotProduct;
    }
    fprintf (stderr, "Result: %f\n", result);
}


- (void)testLoop {
    [self measureBlock:^{
        [self dotWithLoop];
    }];
}


- (void)testAccelerate {
    [self measureBlock:^{
        [self dotWithAccelerate];
    }];
}
@end
