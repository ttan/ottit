//
//  AppDelegate.m
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "AppDelegate.h"

#import "TTMapViewController.h"
#import "TTCardViewController.h"
#import "TTFeedViewController.h"
#import "TTSettingsViewController.h"
#import "TTConfigDefines.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    NSMutableDictionary *takeOffOptions = [NSMutableDictionary dictionary];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    // Call takeOff (which creates the UAirship singleton), passing in the launch options so the
    // library can properly record when the app is launched from a push notification. This call is
    // required.
    //
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    [UAirship takeOff:takeOffOptions];
        
    [[UAPush shared] resetBadge];
    
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeSound |
                                                         UIRemoteNotificationTypeAlert)];
    
    [[UAPush shared] handleNotification:[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]
                       applicationState:application.applicationState];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    TTMapViewController * mapVC = [[TTMapViewController alloc]init];
    [[mapVC view] setFrame:[self window].frame];
    
    [GAI sharedInstance].debug = NO;
    [GAI sharedInstance].dispatchInterval = 5;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:ANAL_KEY];
    
    UINavigationController * navController = [[UINavigationController alloc]initWithRootViewController:mapVC];
    [navController setNavigationBarHidden:YES];
    [[navController navigationBar] setBackgroundImage:[UIImage imageNamed:@"barbg.png"] forBarMetrics:UIBarMetricsDefault];
        
    UIViewController *viewController2 = [[TTCardViewController alloc] initWithNibName:@"TTCardViewController"
                                                                               bundle:nil];
    UIViewController *viewController3 = [[TTFeedViewController alloc] initWithNibName:@"TTFeedViewController"
                                                                            bundle:nil];

    UIViewController *viewController4 = [[TTSettingsViewController alloc] initWithNibName:@"TTSettingsViewController"
                                                                               bundle:nil];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[navController, viewController2, viewController3,viewController4];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    [GAI sharedInstance].defaultTracker.useHttps = ![GAI sharedInstance].defaultTracker.useHttps;
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"1 TOM GAY"
                                                    withAction:@"2 TOM GAY"
                                                     withLabel:@"3 TOM GAY"
                                                     withValue:nil];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
    [[TTFacebookManager sharedInstance] performSelector:@selector(extendFacebook)
                                             withObject:nil
                                             afterDelay:1.0f];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [UAirship land];

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA.
    [[UAPush shared] registerDeviceToken:deviceToken];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
