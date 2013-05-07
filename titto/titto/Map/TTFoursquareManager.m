//
//  TTFoursquareManager.m
//  Map
//
//  Created by Paolo Ladisa on 3/28/13.
//  Copyright (c) 2013 Titto. All rights reserved.
//

#import "TTFoursquareManager.h"
#import "TTConfigDefines.h"
#import "Reachability.h"

#define CLIENT_ID @"WYPZONHB2WDWWL05LABGI0O4XSEZMJ2GCGUVZJIDULULDADZ"
#define CLIENT_SECRET @"CADNRRT125NR4M4SAM2YDRMLO1IWNYL2A0FWK0UP32ANQ1OG"

@implementation TTFoursquareManager

@synthesize delegate;

+ (TTFoursquareManager *)sharedInstance;
{
    static TTFoursquareManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TTFoursquareManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}


-(void)requestHoursInfoForIDVenue:(NSString *)idVenue{
    
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable){
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"YYYYMMdd"];
        
        NSString * stringURL = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/4d5006e0253d6a310c6b5e29/hours?client_id=%@&client_secret=%@&v=%@",CLIENT_ID,CLIENT_SECRET,[dateFormatter stringFromDate:[NSDate date]]];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   
                                   if (!error) {
                                       NSDictionary * dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                 options:NSJSONReadingAllowFragments
                                                                                                   error:nil];
                                       
                                       if ([[[dataDict objectForKey:@"meta"] objectForKey:@"code"] integerValue]==200){
                                           
                                           NSArray * array = [[[dataDict objectForKey:@"response"] objectForKey:@"hours"] objectForKey:@"timeframes"];
                                           
                                           [[NSUserDefaults standardUserDefaults]setObject:array forKey:[NSString stringWithFormat:@"%@%@",FS_PREFIX_INFO,idVenue]];
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               if ([[self delegate] respondsToSelector:@selector(foursquareManagerDidGetHour:)]) {
                                                   [[self delegate] foursquareManagerDidGetHour:array];
                                               }
                                           });
                                       }
                                   }
                               }];

    }else{

        NSArray * array = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",FS_PREFIX_INFO,idVenue]];

        if (array){
            if ([[self delegate] respondsToSelector:@selector(foursquareManagerDidGetHour:)]) {
                [[self delegate] foursquareManagerDidGetHour:array];
            }
        }else{
            if ([[self delegate] respondsToSelector:@selector(foursquareManagerGetHourDidFail)]) {
                [[self delegate] foursquareManagerGetHourDidFail];
            }
            
        }
    }

}


-(BOOL)isShopOpenWithIdVenue:(NSString *)idVenue{

    NSArray * info = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",FS_PREFIX_INFO,idVenue]];

    BOOL isOpen = NO;
    
    NSDateFormatter * dayDateFormatter = [[NSDateFormatter alloc] init];
    [dayDateFormatter setDateFormat:@"c"];
    NSInteger currentDay = [[dayDateFormatter stringFromDate:[NSDate date]] integerValue];
    
    NSDateFormatter * currentDateFormatter = [[NSDateFormatter alloc] init];
    [currentDateFormatter setDateFormat:@"HHMM"];
    
    NSInteger currentHour = [[currentDateFormatter stringFromDate:[NSDate date]] integerValue];
    
    for (NSDictionary * hour in info) {
        NSArray * days = [hour objectForKey:@"days"];
        
        for (id day in days){
            
            if ([day integerValue]==currentDay){
                
                if ([hour objectForKey:@"includesToday"]){
                    
                    NSDictionary * hours = [[hour objectForKey:@"open"] objectAtIndex:0];
                    
                    NSInteger openHour = [[hours objectForKey:@"start"] integerValue];
                    NSInteger closeHour = [[hours objectForKey:@"end"] integerValue];
                    
                    if (currentHour>=openHour && currentHour<closeHour) {
                        
                        isOpen = YES;
                        
                    }
                }
            }
        }
    }
    
    return isOpen;
    
}

@end
