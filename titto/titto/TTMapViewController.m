//
//  TTMapViewController.m
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTMapViewController.h"
#import "Reachability.h"

@interface TTMapViewController ()

@end

@implementation TTMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"Mappa";
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

    userLocalized=NO;

    mapView = [[MKMapView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [mapView setDelegate:self];
    [[self view] addSubview:mapView];
    [mapView setShowsUserLocation:YES];
    
    [[TTMapManager sharedInstance]loadShopsInformations];
    
}


-(void)viewWillAppear:(BOOL)animated{

    if (opaqueView){
        
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable){
            [opaqueView removeFromSuperview];
            opaqueView=nil;
            
            NSLog(@"RIAGGIORNO I DATI");
            
            [[TTMapManager sharedInstance]loadShopsInformations];
        
        }
    }
}

-(void)mapView:(MKMapView *)myMapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if (!userLocation) {
        return;
    }

    if (userLocalized) {
        return;
    }

    if (userLocation.coordinate.latitude==0 && userLocation.coordinate.longitude==0) {
        MKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(44.754535,10.513916);
        region.span = MKCoordinateSpanMake(4, 4);
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
    }else{
        MKCoordinateRegion region;
        region.center = userLocation.coordinate;
        region.span = MKCoordinateSpanMake(0.2, 0.2);
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
        
        userLocalized=YES;
    }
}

-(void)mapManagerDidLoadData:(NSArray *)infoList{

    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable){
        [self performSelectorInBackground:@selector(cacheShopInformations:) withObject:infoList];
    }
    if (shopArray) {
        shopArray=nil;
    }
    shopArray = [[NSMutableArray alloc] initWithArray:infoList];
    [self updatePinList];
}


-(void)mapManagerDidFailLoadData{

    opaqueView = [[UIView alloc]initWithFrame:self.view.frame];
    [opaqueView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75]];
    
    UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 180, 280, 80)];
    [messageLabel setText:@"Hai bisogno di una connessione ad internet per visualizzare gli aggiornamenti"];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setNumberOfLines:4];
    [messageLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
    [messageLabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [opaqueView addSubview:messageLabel];

    [[self view] addSubview:opaqueView];

}


-(void)cacheShopInformations:(id)shops{

    for (NSDictionary * dict in shops){
        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"img"]]];
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:[dict objectForKey:@"img"]];
        [[NSUserDefaults standardUserDefaults]synchronize];

        [[TTFoursquareManager sharedInstance]saveHoursInfoForIDVenue:[dict objectForKey:@"foursquare"]];
    }
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
