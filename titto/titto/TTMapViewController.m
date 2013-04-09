//
//  TTMapViewController.m
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTMapViewController.h"

@interface TTMapViewController ()

@end

@implementation TTMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"Mappa";
        self.tabBarItem.image = [UIImage imageNamed:@"first.png"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[TTMapManager sharedInstance] setDelegate:self];

    mapView = [[MKMapView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [mapView setDelegate:self];
    [mapView setShowsUserLocation:YES];
    [[self view] addSubview:mapView];

    [[TTMapManager sharedInstance]loadShopsInformations];
    
    [self performSelector:@selector(updateMapPosition) withObject:nil afterDelay:2];
    
//    
    
}


-(void)updateMapPosition{

    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    [mapView setRegion:mapRegion animated: YES];

}

-(void)mapManagerDidLoadData:(NSArray *)infoList{

    if (shopArray) {
        shopArray=nil;
    }

    shopArray = [[NSMutableArray alloc] initWithArray:infoList];
    [self updatePinList];

}


-(void)mapManagerDidFailLoadData{

    

}


-(void)updatePinList{

    NSMutableArray * pinArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dict in shopArray) {

        PinAnnotation * pin = [[PinAnnotation alloc]init];
        [pin setTitle:[dict objectForKey:@"indirizzo"]];

        CGFloat latitude = [[dict objectForKey:@"coordinate_x"]floatValue];
        CGFloat longitude = [[dict objectForKey:@"coordinate_y"]floatValue];

        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude , longitude);
        [pin setCoordinate:coordinate];
        
        [pinArray addObject:pin];
    }

    [mapView addAnnotations:pinArray];

}

#pragma mark - MAP METHODS

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *const kAnnotationReuseIdentifier = @"CPAnnotationView";

    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    MKAnnotationView *annotationView = [aMapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationReuseIdentifier];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:kAnnotationReuseIdentifier];

        [annotationView setImage:[UIImage imageNamed:@"pin.png"]];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:shopArray];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"indirizzo contains[cd] %@", view.annotation.title];

    [array filterUsingPredicate:predicate];

    if (shopViewController) {
        shopViewController=nil;
    }

    if ([array objectAtIndex:0]){
        shopViewController=[[TTShopDetailViewController alloc]initWithNibName:@"TTShopDetailViewController"
                                                                       bundle:nil];

        [shopViewController setInfoDict:[array objectAtIndex:0]];
        [[self navigationController] pushViewController:shopViewController animated:YES];
    }
}


@end
