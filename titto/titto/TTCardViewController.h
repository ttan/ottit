//
//  TTCardViewController.h
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFacebookManager.h"

@interface TTCardViewController : UIViewController {
    IBOutlet UILabel *facebookStatus;
    IBOutlet UIButton *loginButton;
    
    IBOutlet UILabel *name;
    IBOutlet UILabel *surname;
    IBOutlet UILabel *email;
    IBOutlet FBProfilePictureView *imageView;
    
}

- (IBAction)loginPressed:(id)sender;

@end
