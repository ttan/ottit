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
@synthesize school;

@synthesize cardID;
@synthesize shopID;
@synthesize shopName;
@synthesize shopAddress;
@synthesize shopCity;

+(TTFacebookUser*)currentUser {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        [self loadUser];
    }
    
    return self;
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
    cardID = nil;
    shopID = nil;
    shopName = nil;
    shopAddress = nil;
    shopCity = nil;
    [self saveUser];
}

- (void)saveUser {
        
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.birthday) {
        [dict setObject:self.birthday
                 forKey:FACEBOOK_DICTIONARY_BIRTHDAY];
    }
    
    if (self.email) {
        [dict setObject:self.email
                 forKey:FACEBOOK_DICTIONARY_EMAIL];
    }
    
    if (self.gender) {
        [dict setObject:self.gender
                 forKey:FACEBOOK_DICTIONARY_GENDER];
    }
    
    if (self.name) {
        [dict setObject:self.name
                 forKey:FACEBOOK_DICTIONARY_NAME];
    }
    
    if (self.surname) {
        [dict setObject:self.surname
                 forKey:FACEBOOK_DICTIONARY_SURNAME];
    }
    
    if (self.userID) {
        [dict setObject:self.userID
                 forKey:FACEBOOK_DICTIONARY_USERID];
    }
    
    if (self.userLink) {
        [dict setObject:self.userLink
                 forKey:FACEBOOK_DICTIONARY_USERLINK];
    }
    
    if (self.userName) {
        [dict setObject:self.userName
                 forKey:FACEBOOK_DICTIONARY_USERNAME];
    }
    
    if (self.cardID) {
        [dict setObject:self.cardID
                 forKey:FACEBOOK_DICTIONARY_CARDID];
    }
    
    if (self.shopID) {
        [dict setObject:self.shopID
                 forKey:FACEBOOK_DICTIONARY_SHOPID];
    }

    if (self.shopName) {
        [dict setObject:self.shopName
                 forKey:FACEBOOK_DICTIONARY_SHOPNAME];
    }
    
    if (self.shopAddress) {
        [dict setObject:self.shopAddress
                 forKey:FACEBOOK_DICTIONARY_SHOPADDRESS];
    }
    
    if (self.shopCity) {
        [dict setObject:self.shopCity
                 forKey:FACEBOOK_DICTIONARY_SHOPCITY];
    }

    if (self.school) {
        [dict setObject:self.school
                 forKey:FACEBOOK_DICTIONARY_SCHOOL];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:dict
                                              forKey:FACEBOOK_DICTIONARY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)loadUser {
    
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:FACEBOOK_DICTIONARY_KEY];
    
    self.birthday = [dict objectForKey:FACEBOOK_DICTIONARY_BIRTHDAY];
    self.email = [dict objectForKey:FACEBOOK_DICTIONARY_EMAIL];
    self.gender = [dict objectForKey:FACEBOOK_DICTIONARY_GENDER];
    self.name = [dict objectForKey:FACEBOOK_DICTIONARY_NAME];
    self.surname = [dict objectForKey:FACEBOOK_DICTIONARY_SURNAME];
    self.userID = [dict objectForKey:FACEBOOK_DICTIONARY_USERID];
    self.userLink = [dict objectForKey:FACEBOOK_DICTIONARY_USERLINK];
    self.userName = [dict objectForKey:FACEBOOK_DICTIONARY_USERNAME];
    self.cardID = [dict objectForKey:FACEBOOK_DICTIONARY_CARDID];
    self.shopName = [dict objectForKey:FACEBOOK_DICTIONARY_SHOPNAME];
    self.shopID = [dict objectForKey:FACEBOOK_DICTIONARY_SHOPID];
    self.shopAddress = [dict objectForKey:FACEBOOK_DICTIONARY_SHOPADDRESS];
    self.shopCity = [dict objectForKey:FACEBOOK_DICTIONARY_SHOPCITY];
    self.school = [dict objectForKey:FACEBOOK_DICTIONARY_SCHOOL];
    
}

@end
