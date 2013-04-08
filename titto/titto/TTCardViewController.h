//
//  TTCardViewController.h
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFacebookManager.h"

@interface TTCardViewController : UIViewController < UIScrollViewDelegate > {
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView  *headerImage;
    
    IBOutlet UIView *loginView;
    IBOutlet UIButton *loginButton;
    IBOutlet UILabel *facebookLoginMessage;
    
    IBOutlet UIView  *cardView;
    IBOutlet UILabel *name;
    IBOutlet UILabel *tessera;
    IBOutlet UILabel *negozio;
    IBOutlet UIButton *actionButton;
    
    IBOutlet FBProfilePictureView *imageView;
    NSDateFormatter *dateFormatter;
}

- (IBAction)loginPressed:(id)sender;
- (IBAction)actionPressed:(id)sender;

@end
