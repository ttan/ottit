//
//  TTMapManager.m
//  Map
//
//  Created by Paolo Ladisa on 3/27/13.
//  Copyright (c) 2013 Titto. All rights reserved.
//

#import "TTMapManager.h"

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

    NSURL * url = [NSURL URLWithString:URL_REQUEST];

    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * response, NSData * data, NSError *error) {

        if (!error && data) {

            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self convertJSONInformation:data];
                
            });
        }
        
    }];
    
}


-(void)convertJSONInformation:(NSData *)jsonData
{
    
    NSError * jsonError;
    
    NSArray * jsonResult = [NSJSONSerialization JSONObjectWithData:jsonData
                                                           options:NSJSONReadingAllowFragments
                                                             error:&jsonError];
    
    if (!jsonError && jsonResult) {
        
        if ([[self delegate] respondsToSelector:@selector(mapManagerDidLoadData:)]) {
            [[self delegate] mapManagerDidLoadData:jsonResult];
        }

    }
}


@end
