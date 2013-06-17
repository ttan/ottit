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

#import "Appirater.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSMutableDictionary *takeOffOptions = [NSMutableDictionary dictionary];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];

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
    
    [Appirater setAppId:@"647736605"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];

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

    
    // For iOS 5 only - custom tabs
    if ([self.tabBarController.tabBar respondsToSelector:@selector(selectedImageTintColor)])
    {
        
        // Set the background images
        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg.png"]];

        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"bg-hover.png"]];

        [[UITabBar appearance] setTintColor:[UIColor clearColor]];

        [navController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"mappaON.png"]
                               withFinishedUnselectedImage:[UIImage imageNamed:@"mappa.png"]];
        [viewController2.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"cardON.png"]
                                 withFinishedUnselectedImage:[UIImage imageNamed:@"card.png"]];
        [viewController3.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"newsON.png"]
                                 withFinishedUnselectedImage:[UIImage imageNamed:@"news.png"]];
        [viewController4.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"opzioniON.png"]
                                 withFinishedUnselectedImage:[UIImage imageNamed:@"opzioni.png"]];
     
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIFont fontWithName:@"HelveticaNeue-Bold"
                                                                           size:9.0f], UITextAttributeFont,
                                                           [UIColor colorWithRed:(138.0f/255.0f)
                                                                           green:(202.0f/255.0f)
                                                                            blue:(253.0f/255.0f)
                                                                           alpha:1.0f], UITextAttributeTextColor,
                                                           //                                                           [UIColor blackColor], UITextAttributeTextShadowColor,
                                                           //                                                           [NSValue valueWithCGSize:CGSizeMake(0.0f,
                                                           //                                                                                               1.0f)], UITextAttributeTextShadowOffset,
                                                           nil]
                                                 forState:UIControlStateSelected];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:(119.0f/255.0f)
                                                                           green:(119.0f/255.0f)
                                                                            blue:(119.0f/255.0f)
                                                                           alpha:1.0f], UITextAttributeTextColor, nil]
                                                 forState:UIControlStateNormal];

    }

    if (![[NSUserDefaults standardUserDefaults] boolForKey:FIRST_EVER_LAUNCH] || FORCE_TOUR) {
        
        TourTesseraViewController *tourViewController =
        [[TourTesseraViewController alloc] initWithNibName:@"TourTesseraViewController" bundle:nil];
        
        [tourViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        
        [self.tabBarController presentViewController:tourViewController
                                            animated:NO
                                          completion:^{
                                              [[NSUserDefaults standardUserDefaults] setBool:YES
                                                                                      forKey:FIRST_EVER_LAUNCH];
                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                          }];
        
    }
    
    [GAI sharedInstance].defaultTracker.useHttps = ![GAI sharedInstance].defaultTracker.useHttps;
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"TOM GAY"
                                                    withAction:@"TOM GAY"
                                                     withLabel:@"TOM GAY"
                                                     withValue:nil];

    [Appirater appLaunched:YES];
    
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
    [Appirater appEnteredForeground:YES];
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
