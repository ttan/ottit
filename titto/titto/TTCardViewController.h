//
//  TTCardViewController.h
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TTConfigDefines.h"
#import "TTFacebookManager.h"

#define CARD_MIN_AGE 26
//#define FORCE_TOUR NO
#define TEMPO_SCADENZA_TESSERA_IN_SECONDI 300

#define OVER21_MESSAGE @"Non hai i giusti requisiti ottenre la tessera!"
#define OVER21_WEB_URL @"http://titto.it"

@interface TTCardViewController : UIViewController < UIScrollViewDelegate > {
    
    // Corpo
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView  *headerImage;
    IBOutlet UIImageView  *headerLogo;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UIView *containerView;
    
    // LogIn
    IBOutlet UIView *loginView;
    IBOutlet UIButton *loginButton;
    IBOutlet UILabel *facebookLoginMessage;
    
    // Tessera
    IBOutlet UIView  *cardView;
    IBOutlet UILabel *titlename;
    IBOutlet UILabel *titletessera;
    IBOutlet UILabel *titlenegozio;
    
    // Tessera
    IBOutlet UILabel *name;
    IBOutlet UILabel *tessera;
    IBOutlet UILabel *negozio;
    IBOutlet UILabel *coppettaOriginal;
    IBOutlet UIButton *actionButton;
    
    // Vecchi sfigati
    IBOutlet UIView     *over21View;
    IBOutlet UILabel    *over21Title;
    IBOutlet UIWebView  *over21WebView;
    
    IBOutlet FBProfilePictureView *imageView;
    NSDateFormatter *dateFormatter;
    
    UIImageView *nuvole;
    NSDate *scadenzaTessera;
    
    BOOL facebookInfoLoaded;
    BOOL needShowTour;
}

- (IBAction)loginPressed:(id)sender;
- (IBAction)actionPressed:(id)sender;

@end
