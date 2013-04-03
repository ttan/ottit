//
//  PinAnnotation.h
//  WhereIsMyBus
//
//  Created by Paolo Ladisa on 09/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PinAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString * titoloPin;
	NSString * sottoTitoloPin;
}

@property (nonatomic) 	CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) NSString * titoloPin;

-(void)setTitle:(NSString *)title;
-(void)setSubtitle:(NSString *)subtitle;

@end