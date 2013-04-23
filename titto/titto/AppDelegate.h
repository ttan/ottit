//
//  AppDelegate.h
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GAI.h"

#import "UAirship.h"
#import "UAPush.h"


@interface AppDelegate : UIResponder < UIApplicationDelegate, UITabBarControllerDelegate ,UAPushNotificationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, retain) id<GAITracker> tracker;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
