//
//  TTFacebookManager.m
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTFacebookManager.h"

@implementation TTFacebookManager

+(TTFacebookManager*)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)login {
    
    [FBSession openActiveSessionWithReadPermissions:@[@"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    
    switch (state) {
        case FBSessionStateOpen:
            // logged in
            [[NSNotificationCenter defaultCenter] postNotificationName:kTTFacebookManagerSessionChange
                                                                object:nil];
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kTTFacebookManagerSessionChange
                                                                object:nil];
            
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (void)logout {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)loadUserInfos {
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             NSLog(@"\n%@", [user allKeys]);
             [[TTFacebookUser currentUser] setBirthday:[user objectForKey:@"birthday"]];
             [[TTFacebookUser currentUser] setEmail:[user objectForKey:@"email"]];
             [[TTFacebookUser currentUser] setName:[user objectForKey:@"first_name"]];
             [[TTFacebookUser currentUser] setSurname:[user objectForKey:@"last_name"]];
             [[TTFacebookUser currentUser] setGender:[user objectForKey:@"gender"]];
             [[TTFacebookUser currentUser] setUserID:[user objectForKey:@"id"]];
             [[TTFacebookUser currentUser] setUserLink:[user objectForKey:@"link"]];
             [[TTFacebookUser currentUser] setUserName:[user objectForKey:@"username"]];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kTTFacebookManagerUserLoaded
                                                                 object:nil];
         } else {
             NSLog(@"error: %@", error);
         }
     }];
    
}

@end
