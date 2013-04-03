//
//  TTFoursquareManager.m
//  Map
//
//  Created by Paolo Ladisa on 3/28/13.
//  Copyright (c) 2013 Titto. All rights reserved.
//

#import "TTFoursquareManager.h"


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

                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       if ([[self delegate] respondsToSelector:@selector(foursquareManagerDidGetHour:)]) {
                           [[self delegate] foursquareManagerDidGetHour:array];
                       }
                   });
               }
           }
       }];
}

@end
