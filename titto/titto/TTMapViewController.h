//
//  TTMapViewController.h
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TTMapManager.h"
#import "PinAnnotation.h"
#import "TTFoursquareManager.h"

#import "TTShopDetailViewController.h"

@interface TTMapViewController : UIViewController <MKMapViewDelegate,TTMapManagerDelegate>{

    MKMapView * mapView;
    NSMutableArray * shopArray;
    TTShopDetailViewController * shopViewController;

}

@end