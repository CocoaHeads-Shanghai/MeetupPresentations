//
//  MainWindowController.m
//  OAuthDemoObjc
//
//  Created by Hanguang on 1/16/16.
//  Copyright © 2016 Hanguang. All rights reserved.
//

#import "MainWindowController.h"
#import "AuthenticationManager.h"

@interface MainWindowController ()
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSTextField *usernameTextField;
@property (weak) IBOutlet NSTextField *passwordTextField;
@property (weak) IBOutlet NSButton *signinButton;
@property (weak) IBOutlet NSButton *myProfileButton;
@property (weak) IBOutlet NSButton *cleanButton;
@property (nonatomic, strong) AuthenticationManager *manager;

@end


@implementation MainWindowController

- (NSString *)windowNibName {
    return @"MainWindowController";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // init manager
    self.manager = [AuthenticationManager new];
    
    // observing log notification
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:AFNetworkActivityLoggerNotification object:nil]
      map:^id(NSNotification *notification) {
          return notification.object;
      }] subscribeNext:^(NSString *log) {
          #pragma mark - Exam: there's a better way to print log on text view
          if (log.length) {
              if (self.textView.textStorage.length) {
                  log = [NSString stringWithFormat:@"\n%@", log];
              }
              NSAttributedString *string = [[NSAttributedString alloc] initWithString:log];
              [self.textView.textStorage appendAttributedString:string];
          }
          self.cleanButton.enabled = self.textView.string.length;
      }];
    
    
    // text signal
    RACSignal *nameSignal = self.usernameTextField.rac_textSignal;
    RACSignal *passwordSignal = self.passwordTextField.rac_textSignal;
    
    RACSignal *enableSignal =
    [RACSignal combineLatest:@[nameSignal, passwordSignal]
                      reduce:^id(NSString *name, NSString *password) {
                          return @(name.length && password.length);
                      }];
    
    self.signinButton.rac_command =
    [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
        RACSignal *loginSignal = [[self.manager requestForAccessToken]
                                  concat:[self.manager requestForOAuthWithUsername:self.usernameTextField.stringValue
                                                                          password:self.passwordTextField.stringValue]];
        return loginSignal;
    }];
    
    self.myProfileButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self.manager getMyProfile];
    }];
    
    // Observing text field enable property, when sigh in signal is ongoing, returns NO
    RAC(self.usernameTextField, enabled) = [self.signinButton.rac_command.executing not];
    RAC(self.passwordTextField, enabled) = [self.signinButton.rac_command.executing not];
    
}

- (IBAction)cleanTextView:(NSButton *)sender {
    NSRange range = NSMakeRange(0, self.textView.textStorage.length);
    [self.textView.textStorage replaceCharactersInRange:range withString:@""];
}

@end
