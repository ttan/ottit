//
//  TTFacebookUser.h
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTConfigDefines.h"

@interface TTFacebookUser : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *userLink;
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *cardID;
@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *shopCity;
@property (nonatomic, strong) NSString *shopAddress;

+(TTFacebookUser*)currentUser;

- (void)clearAll;

- (void)saveUser;
- (void)loadUser;

@end
