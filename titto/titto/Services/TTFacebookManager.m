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

- (BOOL)isFacebookLoggedIn {
    return (FBSession.activeSession.state == FBSessionStateOpen);
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
        
    return [FBSession openActiveSessionWithReadPermissions:@[@"email", @"user_birthday", @"user_education_history"]
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             
                                             NSLog(@"STATE   %i", state);

//                                             if(allowLoginUI||error) {
                                                 [self sessionStateChanged:session
																	 state:state
																	 error:error];
//                                             }
                                             
                                         }];
}

- (void)login {
    
    [self openSessionWithAllowLoginUI:YES];
    
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

-(void)extendFacebook {
    
    if ([FBSession activeSession] && [FBSession activeSession].isOpen) {
        
        [self openSessionWithAllowLoginUI:NO];
        
    } else {
        
//        // Initialize a new blank session instance...
//        FBSession *newSession = [[FBSession alloc] initWithAppID:nil
//                                                     permissions:nil
//                                                 defaultAudience:FBSessionDefaultAudienceNone
//                                                 urlSchemeSuffix:nil
//                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance]];
//        
//        [FBSession setActiveSession:newSession];
        [self openSessionWithAllowLoginUI:NO];
    }
}

- (void)logout {
    [FBSession.activeSession closeAndClearTokenInformation];
    [[TTFacebookUser currentUser] clearAll];
}

- (void)loadUserInfos {
    
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable){
    
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 
                 NSLog(@"\n%@", [user allKeys]);
                 NSLog(@"%@", user);
                 
                 [[TTFacebookUser currentUser] setBirthday:[user objectForKey:@"birthday"]];
                 [[TTFacebookUser currentUser] setEmail:[user objectForKey:@"email"]];
                 [[TTFacebookUser currentUser] setName:[user objectForKey:@"first_name"]];
                 [[TTFacebookUser currentUser] setSurname:[user objectForKey:@"last_name"]];
                 [[TTFacebookUser currentUser] setGender:[user objectForKey:@"gender"]];
                 [[TTFacebookUser currentUser] setUserID:[user objectForKey:@"id"]];
                 [[TTFacebookUser currentUser] setUserLink:[user objectForKey:@"link"]];
                 [[TTFacebookUser currentUser] setUserName:[user objectForKey:@"username"]];
                 
                 if ([user objectForKey:@"education"]) {
                     NSArray *educationArray = [user objectForKey:@"education"];
                     
                     if (educationArray.count>0) {
                         
                         for (NSDictionary *educationDict in educationArray) {
                                                          
                             if ([educationDict objectForKey:@"type"] &&
                                 [[educationDict objectForKey:@"type"] isEqualToString:@"High School"]) {
                                 
                                 if ([educationDict objectForKey:@"school"]) {
                                     NSDictionary *schoolDict = [educationDict objectForKey:@"school"];
                                     
                                     if ([schoolDict objectForKey:@"name"]) {
                                         
                                         [[TTFacebookUser currentUser] setSchool:[schoolDict objectForKey:@"name"]];
                                         
                                     }
                                 }
                             }
                         }
                     }
                 }
                 
                 [[TTFacebookUser currentUser] saveUser];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:kTTFacebookManagerUserLoaded
                                                                     object:nil];
                 
             } else {
                 NSLog(@"error: %@", error);
             }
         }];
        
    }else {
        
        [[TTFacebookUser currentUser] loadUser];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kTTFacebookManagerUserLoaded
                                                            object:nil];
        
    }
}

@end
