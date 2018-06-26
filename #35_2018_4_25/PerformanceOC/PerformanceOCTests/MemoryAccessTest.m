//

#import <XCTest/XCTest.h>
#include "memory.h"

@interface MemoryAccessTest : XCTestCase

@end

@implementation MemoryAccessTest

- (void) _testMemoryEqual
{
    XCTAssertEqual(loopCon(), loopDis());
}

- (void) testContiguousMemoryAccess {
    [self measureBlock:^{
        loopCon();
    }];
}

- (void) testDiscontuguousMemoryAccess {
    [self measureBlock:^{
        loopDis();
    }];
}
@end
