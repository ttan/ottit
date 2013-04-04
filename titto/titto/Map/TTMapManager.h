//
//  TTMapManager.h
//  Map
//
//  Created by Paolo Ladisa on 3/27/13.
//  Copyright (c) 2013 Titto. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTMapManagerDelegate <NSObject>

-(void)mapManagerDidLoadData:(NSArray *)infoList;
-(void)mapManagerDidFailLoadData;

@end

@interface TTMapManager : NSObject{

    id __unsafe_unretained delegate;

}

@property (unsafe_unretained) id delegate;

+ (TTMapManager *)sharedInstance;

-(void)loadShopsInformations;

@end