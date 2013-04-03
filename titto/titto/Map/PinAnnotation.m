//
//  PinAnnotation.m
//  WhereIsMyBus
//
//  Created by Paolo Ladisa on 09/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PinAnnotation.h"

@implementation PinAnnotation 
@synthesize titoloPin;
- (CLLocationCoordinate2D)coordinate;
{
	return coordinate;
}

- (NSString *)title{
    return titoloPin;
}

- (NSString *)subtitle
{
    return sottoTitoloPin;
}

- (void)setTitle:(NSString *)titolo{
	if (!titoloPin) {
		titoloPin = [[NSString alloc] initWithString:titolo];
	}
}

- (void)setSubtitle:(NSString *)titolo{
	if (!sottoTitoloPin) {
		sottoTitoloPin = [[NSString alloc] initWithString:titolo];
	}
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
	coordinate = newCoordinate;
}

@end
