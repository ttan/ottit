//
//  TTFacebookUser.m
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTFacebookUser.h"

@implementation TTFacebookUser
@synthesize birthday;
@synthesize email;
@synthesize gender;
@synthesize name;
@synthesize surname;
@synthesize userID;
@synthesize userLink;
@synthesize userName;

@synthesize cardID;
@synthesize shopID;

+(TTFacebookUser*)currentUser {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)clearAll {
    birthday = nil;
    email = nil;
    gender = nil;
    name = nil;
    surname = nil;
    userID = nil;
    userLink = nil;
    userName = nil;
}

@end
