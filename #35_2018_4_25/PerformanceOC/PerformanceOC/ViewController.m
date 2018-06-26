//
//  ViewController.m
//  PerformanceOC
//
//  Created by Phink on 4/24/18.
//  Copyright © 2018 Senten Sarl. All rights reserved.
//

#import "ViewController.h"
#include "poly.h"

@interface ViewController ()
@property (assign) NSMutableDictionary *zombie;
@end

#define POLY_COUNT (100 * 10000)

@implementation ViewController

- (IBAction) startPolyLazy:(id) sender
{
    double result = 0.0;
    for (NSUInteger i = 0; i < POLY_COUNT; i++) {
        for (double x = -8.0; x <= 8.0; x += 2.0) {
            result += PolyLazy(x);
        }
    }
    NSLog(@"%.2f", result);
}


- (void) setZombieName:(NSString *)name
{
    [self.zombie setObject:name forKey:@"name"];
}

#if 1
- (IBAction) zombie:(id) sender
{
    @autoreleasepool {
        self.zombie = [NSMutableDictionary dictionary];
    }
    [self setZombieName:@"Z"];
}
#else
- (IBAction) zombie:(id) sender
{
    self.zombie = [NSMutableDictionary dictionary];
    [self performSelector:@selector (setZombieName:) withObject:@"Z" afterDelay:0.0];
}
#endif

#if 0
- (IBAction) spike:(id) sender
{
    double start = CFAbsoluteTimeGetCurrent();
    
    @autoreleasepool {
        NSError *error = nil;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Big" ofType:@"tsv"];
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        
        NSArray *lines = [fileContent componentsSeparatedByString:@"\r"];
        NSLog(@"-- lines count: %@", @([lines count]));
        
        for (NSString *eachLine in lines) {
            NSArray *values = [eachLine componentsSeparatedByString:@"\t"];
            for (NSString *eachValue in values) {
                if ([eachValue length]> 1) {
                    
                }
            }
        }
    }
    double duration = CFAbsoluteTimeGetCurrent() - start;
    NSLog (@"%.3f", duration);
}
#else
- (IBAction) spike:(id) sender
{
    double start = CFAbsoluteTimeGetCurrent();
    @autoreleasepool {
        NSError *error = nil;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Big" ofType:@"tsv"];
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        
        NSArray *lines = [fileContent componentsSeparatedByString:@"\r"];
        NSLog(@"-- lines count: %@", @([lines count]));
        
        for (NSString *eachLine in lines) {
            @autoreleasepool {
                NSArray *values = [eachLine componentsSeparatedByString:@"\t"];
                for (NSString *eachValue in values) {
                    if ([eachValue length]> 1) {
                        
                    }
                }
            }
        }
    }
    double duration = CFAbsoluteTimeGetCurrent() - start;
    NSLog (@"%.3f", duration);
}
#endif


@end
