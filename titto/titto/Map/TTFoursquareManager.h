//
//  TTFoursquareManager.h
//  Map
//
//  Created by Paolo Ladisa on 3/28/13.
//  Copyright (c) 2013 Titto. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTFoursquareManagerDelegate <NSObject>

-(void)foursquareManagerDidGetHour:(NSArray *)hours;
-(void)foursquareManagerGetHourDidFail;

@end

@interface TTFoursquareManager : NSObject{
    
    id __unsafe_unretained delegate;

}

@property (unsafe_unretained) id delegate;

+ (TTFoursquareManager *)sharedInstance;

-(void)requestHoursInfoForIDVenue:(NSString *)idVenue;

@end