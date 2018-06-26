//

#import <XCTest/XCTest.h>
#include "poly.h"

@interface PolynomialTest : XCTestCase
@end

#define POLY_COUNT (1000 * 1000)
#define ACCURACY   1e-6

@implementation PolynomialTest


- (void) testEqual
{
    for (double x = -8.0; x <= 8.0; x += 0.1) {
        XCTAssertEqualWithAccuracy(PolyAccelerate(x), PolyLazy(x), ACCURACY);
        XCTAssertEqualWithAccuracy(PolyNoPow(x), PolyLazy(x), ACCURACY);
    }
}

- (void)testPoly {
    [self measureBlock:^{
        double result = 0.0;
        for (double x = -8.0; x <= 8.0; x += 2.0) {
            for (NSUInteger i = 0; i < POLY_COUNT; i++) {
//                result += PolyLazy(x);
//                result += PolyNoPow(x);
                result += PolyAccelerate(x);
            }
        }
    }];
}

- (void)testScaffolding {
    [self measureBlock:^{
        double result = 0.0;
        for (double x = -8.0; x <= 8.0; x += 2.0) {
            for (NSUInteger i = 0; i < POLY_COUNT; i++) {
                result += x;
            }
        }
    }];
}
@end
