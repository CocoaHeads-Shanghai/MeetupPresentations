//

#import <XCTest/XCTest.h>

@interface IMPCachingTest : XCTestCase

@end

@implementation IMPCachingTest

#define COUNT (100 * 1000 * 1000)

- (uint64_t) withMessageSend
{
    NSNumber *n = [NSNumber numberWithInt:42];
    uint64_t r = 0;
    for (int i = 0; i < COUNT; i++) {
        r += [n intValue];
    }
    return r;
}

- (uint64_t) withIMPCaching
{
    NSNumber *n = [NSNumber numberWithInt:42];
    SEL s = @selector(intValue);
    int (*f) (id, SEL, ...) = (int (*) (id, SEL, ...))[n methodForSelector:s];
    uint64_t r = 0;
    for (int i = 0; i < COUNT; i++) {
        r += (int)f(n, s);
    }
    return r;
}


- (uint64_t) base
{
    uint64_t r = 0;    
    for (int i = 0; i < COUNT; i++) {
        r += 42;
    }
    return r;
}

- (void)testBase {
    [self measureBlock:^{
        [self base];
    }];
}

- (void)testSend {
    [self measureBlock:^{
        [self withMessageSend];
    }];
}


- (void)testCaching {
    [self measureBlock:^{
        [self withIMPCaching];
    }];
}
@end
