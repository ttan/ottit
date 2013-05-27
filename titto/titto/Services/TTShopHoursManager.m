//
//  TTShopHoursManager.m
//  titto
//
//  Created by Paolo Ladisa on 5/22/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTShopHoursManager.h"
#import "TTConfigDefines.h"
#import "Reachability.h"

@implementation TTShopHoursManager


@synthesize delegate;

+ (TTShopHoursManager *)sharedInstance;
{
    static TTShopHoursManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TTShopHoursManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}



-(void)saveHoursInfoForIDVenue:(NSString *)idVenue;
{

    NSString * stringURL = [NSString stringWithFormat:@"http://backend.titto.it/app2013/hours.php?negozio=%@",idVenue];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
    
    NSLog(@"%@",stringURL);

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (!error && data) {
                                   NSDictionary * dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:NSJSONReadingAllowFragments
                                                                                               error:nil];

                                   [[NSUserDefaults standardUserDefaults]setObject:dataDict forKey:[NSString stringWithFormat:@"%@%@",FS_PREFIX_INFO,idVenue]];
                                   [[NSUserDefaults standardUserDefaults]synchronize];
                                   
                                   }
                           }];
}

-(void)requestHoursInfoForIDVenue:(NSString *)idVenue{
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",FS_PREFIX_INFO,idVenue]];

    if (dict){
        if ([[self delegate] respondsToSelector:@selector(shopHoursManagerDidGetHourWithDict:)]) {
            [[self delegate] shopHoursManagerDidGetHourWithDict:dict];
        }
    }

    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable){
        
        NSString * stringURL = [NSString stringWithFormat:@"http://backend.titto.it/app2013/hours.php?negozio=%@",idVenue];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   
                                   if (!error && data) {
                                       NSDictionary * dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                 options:NSJSONReadingAllowFragments
                                                                                                   error:nil];

                                           [[NSUserDefaults standardUserDefaults]setObject:dataDict forKey:[NSString stringWithFormat:@"%@%@",FS_PREFIX_INFO,idVenue]];
                                           [[NSUserDefaults standardUserDefaults]synchronize];

                                           dispatch_async(dispatch_get_main_queue(), ^{

                                       if ([[self delegate] respondsToSelector:@selector(shopHoursManagerDidGetHourWithDict:)]) {
                                           [[self delegate] shopHoursManagerDidGetHourWithDict:dataDict];
                                       }
                                           });                                       
                                   }
                               }];
        
    }else{
        
        NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",FS_PREFIX_INFO,idVenue]];
        
        if (dict){
            if ([[self delegate] respondsToSelector:@selector(shopHoursManagerDidGetHourWithDict:)]) {
                [[self delegate] shopHoursManagerDidGetHourWithDict:dict];
            }
        }else{
            if ([[self delegate] respondsToSelector:@selector(shopHoursManagerGetHourDidFail)]) {
                [[self delegate] shopHoursManagerGetHourDidFail];
            }
        }
    }
}


-(BOOL)isShopOpenWithIdVenue:(NSString *)idVenue{

    NSDictionary * info = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",FS_PREFIX_INFO,idVenue]];
    BOOL isOpen = NO;
    NSDateFormatter * dayDateFormatter = [[NSDateFormatter alloc] init];
    [dayDateFormatter setDateFormat:@"c"];
    NSInteger currentDay = [[dayDateFormatter stringFromDate:[NSDate date]] integerValue];
    NSDateFormatter * currentDateFormatter = [[NSDateFormatter alloc] init];
    [currentDateFormatter setDateFormat:@"HHMM"];
    NSInteger currentHour = [[currentDateFormatter stringFromDate:[NSDate date]] integerValue];
    NSInteger index=1;
    
    if ([info count]==0) {
        return NO;
    }

    for (index=1; index<8; index++){
        if (index==currentDay){

            NSInteger startHour = [[[info objectForKey:[NSString stringWithFormat:@"%i",index]] objectForKey:@"start"] intValue];
            NSInteger endHour = [[[info objectForKey:[NSString stringWithFormat:@"%i",index]] objectForKey:@"end"] intValue];

            if (currentHour>=startHour && currentHour<endHour){
                isOpen = YES;
            }

        }
    }
 
    return isOpen;
    
}



@end
