//
//  AppDelegate.m
//  OAuthDemoObjc
//
//  Created by Hanguang on 1/16/16.
//  Copyright © 2016 Hanguang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"

@interface AppDelegate ()
@property (nonatomic, strong) MainWindowController *mainWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    [[AFNetworkActivityLogger sharedLogger] startLogging];
    
    MainWindowController *main = [MainWindowController new];
    [main showWindow:self];
    
    self.mainWindowController = main;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
