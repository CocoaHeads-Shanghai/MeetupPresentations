//
//  AuthenticationManager.h
//  OAuthDemoObjc
//
//  Created by Hanguang on 1/16/16.
//  Copyright © 2016 Hanguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationManager : NSObject

- (RACSignal *)requestForAccessToken;
- (RACSignal *)requestForOAuthWithUsername:(NSString *)username password:(NSString *)password;
- (RACSignal *)getMyProfile;

@end
