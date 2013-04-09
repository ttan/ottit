//
//  TTFacebookManager.h
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import "TTFacebookUser.h"
#import "Reachability.h"

#define kTTFacebookManagerSessionChange @"kTTFacebookManagerSessionChange"
#define kTTFacebookManagerUserLoaded @"kTTFacebookManagerUserLoaded"

@interface TTFacebookManager : NSObject

+(TTFacebookManager*)sharedInstance;

- (BOOL)isFacebookLoggedIn;
- (void)extendFacebook;

- (void)login;
- (void)logout;
- (void)loadUserInfos;

@end
