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

@interface TTCardViewController : UIViewController < UIScrollViewDelegate > {
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView  *headerImage;
    IBOutlet UIImageView  *headerLogo;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UIView *containerView;
    
    IBOutlet UIView *loginView;
    IBOutlet UIButton *loginButton;
    IBOutlet UILabel *facebookLoginMessage;
    
    IBOutlet UIView  *cardView;
    IBOutlet UILabel *titlename;
    IBOutlet UILabel *titletessera;
    IBOutlet UILabel *titlenegozio;
    
    IBOutlet UILabel *name;
    IBOutlet UILabel *tessera;
    IBOutlet UILabel *negozio;
    IBOutlet UILabel *coppettaOriginal;
    IBOutlet UIButton *actionButton;
    
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
