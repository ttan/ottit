//
//  TTMapManager.m
//  Map
//
//  Created by Paolo Ladisa on 3/27/13.
//  Copyright (c) 2013 Titto. All rights reserved.
//

#import "TTMapManager.h"
#import "Reachability.h"
#import "TTConfigDefines.h"

#define URL_REQUEST @"http://backend.titto.it/app2013/index.php"

@implementation TTMapManager

@synthesize delegate;

+ (TTMapManager *)sharedInstance
{
    static TTMapManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TTMapManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;

}

-(void)loadShopsInformations;
{
//    [NSThread detachNewThreadSelector:@selector(loadShopsInformationsInBackground) toTarget:self withObject:nil];
    
    [self loadShopsInformationsInBackground];

}

-(void)loadShopsInformationsInBackground{
    
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:MAP_PINS_CACHE];

    if (data) {
        [self convertJSONInformation:data fromCache:YES];
        [self performSelector:@selector(loadData) withObject:nil afterDelay:3];

    }else{
        
        [self loadData];
    }
    
    
}

-(void)loadData{
    
    [NSThread detachNewThreadSelector:@selector(loadDataInBackground) toTarget:self withObject:nil];
    
}

-(void)loadDataInBackground{

    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable){
        
        NSURL * url = [NSURL URLWithString:URL_REQUEST];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse * response, NSData * data, NSError *error) {
                                   
                                   if (!error && data){
                                       
                                       //                                       dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       [[NSUserDefaults standardUserDefaults]setObject:data forKey:MAP_PINS_CACHE];
                                       [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"LAST_UPDATE"];
                                       [[NSUserDefaults standardUserDefaults]synchronize];
                                       [self convertJSONInformation:data fromCache:NO];
                                       
                                       //                                       });
                                   }else{
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           if ([[self delegate] respondsToSelector:@selector(mapManagerDidFailLoadData)]) {
                                               [[self delegate] mapManagerDidFailLoadData];
                                           }
                                       });
                                   }
                               }];
    }else{
        
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:MAP_PINS_CACHE]) {
            [self convertJSONInformation:[[NSUserDefaults standardUserDefaults]objectForKey:MAP_PINS_CACHE] fromCache:YES];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[self delegate] respondsToSelector:@selector(mapManagerDidFailLoadData)]) {
                    [[self delegate] mapManagerDidFailLoadData];
                }
            });
            
            
        }
        
        
    }

    
}


-(void)convertJSONInformation:(NSData *)jsonData fromCache:(BOOL)cache
{

    NSError * jsonError;
    NSArray * jsonResult = [NSJSONSerialization JSONObjectWithData:jsonData
                                                           options:NSJSONReadingAllowFragments
                                                             error:&jsonError];

    if (!jsonError && jsonResult){
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[self delegate] respondsToSelector:@selector(mapManagerDidLoadData:fromCache:)]) {
                [[self delegate] mapManagerDidLoadData:jsonResult fromCache:cache];
            }

        });
    }
}


@end
