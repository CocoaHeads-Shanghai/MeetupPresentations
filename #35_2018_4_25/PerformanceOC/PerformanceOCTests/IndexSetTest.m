//
//  IndexSetTest.m
//  PerformanceOCTests
//
//  Created by Phink on 4/25/18.
//  Copyright © 2018 Senten Sarl. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface IndexSetTest : XCTestCase
{
    NSMutableArray *timeZoneNames;
}
@end

#define MIN_ARRAY_SIZE  (100 * 1000)

@implementation IndexSetTest

- (void) setUp {
    [super setUp];
    timeZoneNames = [[NSMutableArray alloc] init];
    
    NSArray *knownTimeZones = [NSTimeZone knownTimeZoneNames];
    int count = 1 + MIN_ARRAY_SIZE / [knownTimeZones count];
    
    for (int i = 0; i < count; i++) {
        [timeZoneNames addObjectsFromArray:knownTimeZones];
    }
    NSLog (@"Array size:%@", @([timeZoneNames count]));
}

- (void)tearDown {
    [super tearDown];
}

- (NSIndexSet *) filterWithBlock
{
    return [timeZoneNames indexesOfObjectsWithOptions:0
                                          passingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                                              return [obj hasPrefix:@"Europe"];
                                          }];
}

- (NSIndexSet *) filterWithBlockConcurrent
{
    return [timeZoneNames indexesOfObjectsWithOptions:NSEnumerationConcurrent
                                          passingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                                              return [obj hasPrefix:@"Europe"];
                                          }];
}


- (NSIndexSet *) filterWithIMPBlock
{
    SEL hasPrefixSelector = @selector(hasPrefix:);
    BOOL (*hasPrefixIMP) (id, SEL, id) = (BOOL (*) (id, SEL, id))[@"x" methodForSelector:hasPrefixSelector];
    
    return [timeZoneNames indexesOfObjectsWithOptions:NSEnumerationConcurrent
                                          passingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                                              return hasPrefixIMP (obj, hasPrefixSelector, @"Europe");
                                          }];
}


- (NSIndexSet *) filterWithObjectAtIndex
{
    NSMutableIndexSet *areaIndexes = [NSMutableIndexSet indexSet];
    NSUInteger count = [timeZoneNames count];
    for (NSUInteger i = 0; i < count; i++) {
        if ([[timeZoneNames objectAtIndex:i] hasPrefix:@"Europe"]) {
            [areaIndexes addIndex:i];
        }
    }
    return areaIndexes;
}


- (NSIndexSet *) filterWithEnumeration
{
    NSMutableIndexSet *areaIndexes = [NSMutableIndexSet indexSet];
    NSUInteger index = 0;
    
    for (NSString *each in timeZoneNames) {
        if ([each hasPrefix:@"Europe"]) {
            [areaIndexes addIndex:index];
        }
        index++;
    }
    return areaIndexes;
}


- (void)testEnumeration {
    [self measureBlock:^{
        NSIndexSet *s = [self filterWithEnumeration];
        NSLog (@"%@", @([s count]));
    }];
}

- (void)testObjectAtIndex {
    [self measureBlock:^{
        NSIndexSet *s = [self filterWithObjectAtIndex];
        NSLog (@"%@", @([s count]));
    }];
}

- (void)testBlock {
    [self measureBlock:^{
        NSIndexSet *s = [self filterWithBlock];
        NSLog (@"%@", @([s count]));
    }];
}

- (void)testBlockConcurrent {
    [self measureBlock:^{
        NSIndexSet *s = [self filterWithBlockConcurrent];
        NSLog (@"%@", @([s count]));
    }];
}

- (void)testBlockIMPConcurrent {
    [self measureBlock:^{
        NSIndexSet *s = [self filterWithIMPBlock];
        NSLog (@"%@", @([s count]));
    }];
}
@end
