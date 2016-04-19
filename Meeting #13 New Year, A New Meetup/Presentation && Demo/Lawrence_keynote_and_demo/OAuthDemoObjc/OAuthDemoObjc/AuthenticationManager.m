//
//  AuthenticationManager.m
//  OAuthDemoObjc
//
//  Created by Hanguang on 1/16/16.
//  Copyright © 2016 Hanguang. All rights reserved.
//

#import "AuthenticationManager.h"


NSString * const baseURL = @"YOUR_BASE_URL";
NSString * const oauthURL = @"YOUR_AUTH_URL"; // e.g: auth/access_token
NSString * const clientID = @"YOUR_CLIENT_ID";
NSString * const secret = @"YOUR_SECRET";
NSString * const scope = @"YOUR_SCOPE";
NSString * const serviceProviderIdentifier = @"YOUR_SERVICE_PROVIDER";

NSString * const YOUR_API_PATH = @"YOUR_API_PATH";// e.g: account/me

@interface AuthenticationManager ()
@property (nonatomic, strong) AFOAuth2Manager *oauthManager;
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;
@property (nonatomic, strong) AFOAuthCredential *credential;

@end

@implementation AuthenticationManager

- (instancetype)init {
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    _requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    if (self.credential) {
        [_requestManager.requestSerializer setAuthorizationHeaderFieldWithCredential:self.credential];
    }
    _oauthManager = [[AFOAuth2Manager alloc] initWithBaseURL:[NSURL URLWithString:baseURL] clientID:clientID secret:secret];
    
    return self;
}

#pragma mark - Credential

- (AFOAuthCredential *)credential {
    return [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
}

- (void)updateCredential:(AFOAuthCredential *)cred {
    [self logWithString:[NSString stringWithFormat:@"Credential: %@", cred]];
    [AFOAuthCredential storeCredential:cred withIdentifier:serviceProviderIdentifier];
    [self.requestManager.requestSerializer setAuthorizationHeaderFieldWithCredential:cred];
}

#pragma mark - Request helper

- (RACSignal *)getSignalWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op =
        [self.requestManager GET:path
                      parameters:parameters
                         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                             [self logWithString:[NSString stringWithFormat:@"Response object: %@", responseObject]];
                             [subscriber sendNext:responseObject];
                             [subscriber sendCompleted];
                         } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                             [self logWithString:[NSString stringWithFormat:@"Error: %@", error]];
                             [subscriber sendError:error];
                         }];
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}

- (RACSignal *)postSignalWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op =
        [self.requestManager POST:path
                       parameters:parameters
                          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                              [self logWithString:[NSString stringWithFormat:@"Response object: %@", responseObject]];
                              [subscriber sendNext:responseObject];
                              [subscriber sendCompleted];
                          } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                              [self logWithString:[NSString stringWithFormat:@"Error: %@", error]];
                              [subscriber sendError:error];
                          }];
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}

#pragma mark - Refresh token
- (RACSignal *)refreshTokenIfNeededWithSignal:(RACSignal *)requestSignal {
    return [requestSignal catch:^RACSignal *(NSError *error) {
        if (error) {
            BOOL hasRefreshToken = self.credential.refreshToken != nil;
            BOOL httpCode401AccessDenied = error.code == -1011;
            if (hasRefreshToken && httpCode401AccessDenied) {
                return [[[self refreshToken] ignoreValues] concat:requestSignal];
            }
            return [RACSignal error:error];
        } else {
            return requestSignal;
        }
    }];
}

- (RACSignal *)refreshToken {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [self.oauthManager
                                      authenticateUsingOAuthWithURLString:oauthURL
                                      refreshToken:self.credential.refreshToken
                                      success:^(AFOAuthCredential *credential) {
                                          [self updateCredential:credential];
                                          [subscriber sendNext:credential];
                                          [subscriber sendCompleted];
                                      } failure:^(NSError *error) {
                                          [self logWithString:[NSString stringWithFormat:@"Error: %@", error]];
                                          [subscriber sendError:error];
                                      }];
        
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}

#pragma mark - Request API

- (RACSignal *)requestForAccessToken {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [self.oauthManager
                                      authenticateUsingOAuthWithURLString:oauthURL
                                      scope:@""
                                      success:^(AFOAuthCredential *credential) {
                                          [self updateCredential:credential];
                                          [subscriber sendNext:credential];
                                          [subscriber sendCompleted];
                                      }
                                      failure:^(NSError *error) {
                                          [self logWithString:[NSString
                                                               stringWithFormat:@"Error: %@",
                                                               error.localizedDescription]];
                                          [subscriber sendError:error];
                                      }];
        
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
        
    }];
    
}

- (RACSignal *)requestForOAuthWithUsername:(NSString *)username password:(NSString *)password {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *parameters = @{@"client_id" : clientID,
                                     @"client_secret" : secret,
                                     @"grant_type" : kAFOAuthPasswordCredentialsGrantType,
                                     @"username" : username,
                                     @"password" : password};
        
        AFHTTPRequestOperation *op =
        [self.requestManager POST:oauthURL
                       parameters:parameters
                          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                              if (responseObject) {
                                  NSString *accessToken = responseObject[@"access_token"];
                                  NSString *refreshToken = responseObject[@"refresh_token"];
                                  NSString *tokenType = responseObject[@"token_type"];
                                  NSNumber *expiresIn = responseObject[@"expires_in"];
                                  NSDate *expireDate = [NSDate distantFuture];
                                  
                                  if (expiresIn) {
                                      expireDate = [NSDate dateWithTimeIntervalSinceNow:expiresIn.doubleValue];
                                  }
                                  
                                  AFOAuthCredential *cred = [AFOAuthCredential credentialWithOAuthToken:accessToken tokenType:tokenType];
                                  [cred setExpiration:expireDate];
                                  [cred setRefreshToken:refreshToken];
                                  [self updateCredential:cred];
                                  
                                  [self logWithString:[NSString stringWithFormat:@"Response object: %@", responseObject]];
                                  [subscriber sendNext:responseObject];
                                  [subscriber sendCompleted];
                              }
                          } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                              [self logWithString:[NSString stringWithFormat:@"Error: %@", error]];
                              [subscriber sendError:error];
                          }];
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}

- (RACSignal *)getMyProfile {
    RACSignal *requestSignal =
    [[self getSignalWithPath:YOUR_API_PATH parameters:nil]
     map:^id(NSDictionary *responseObject) {
         [self logWithString:[NSString stringWithFormat:@"%@", responseObject]];
         return responseObject;
     }];
    
    return [self refreshTokenIfNeededWithSignal:requestSignal];
}

#pragma mark - Log
- (void)logWithString:(NSString *)log {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNotification *noti = [NSNotification notificationWithName:AFNetworkActivityLoggerNotification object:log];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    });
}

@end
