//
//  TTCardViewController.h
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TTFacebookManager.h"
#import "TTConfigDefines.h"

#define CARD_MIN_AGE 26

@interface TTCardViewController : UIViewController < UIScrollViewDelegate > {
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView  *headerImage;
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
    IBOutlet UIButton *actionButton;
    
    IBOutlet FBProfilePictureView *imageView;
    NSDateFormatter *dateFormatter;
    
    BOOL facebookInfoLoaded;
    BOOL needShowTour;
}

- (IBAction)loginPressed:(id)sender;
- (IBAction)actionPressed:(id)sender;

@end
