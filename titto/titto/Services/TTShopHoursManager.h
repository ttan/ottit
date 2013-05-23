//
//  TTShopHoursManager.h
//  titto
//
//  Created by Paolo Ladisa on 5/22/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTShopHoursManagerDelegate <NSObject>

-(void)shopHoursManagerDidGetHourWithDict:(NSDictionary *)hours;

-(void)shopHoursManagerGetHourDidFail;

@end

@interface TTShopHoursManager : NSObject{
    id __unsafe_unretained delegate;
}

@property (unsafe_unretained) id delegate;

+ (TTShopHoursManager *)sharedInstance;

-(void)saveHoursInfoForIDVenue:(NSString *)idVenue;

-(void)requestHoursInfoForIDVenue:(NSString *)idVenue;
-(BOOL)isShopOpenWithIdVenue:(NSString *)idVenue;

@end