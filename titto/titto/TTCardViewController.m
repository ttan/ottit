//
//  TTCardViewController.m
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTCardViewController.h"

@interface TTCardViewController ()

@end

@implementation TTCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Card";
        self.tabBarItem.image = [UIImage imageNamed:@"second.png"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(facebookChanged)
                                                     name:kTTFacebookManagerSessionChange
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(facebookUserLoaded)
                                                     name:kTTFacebookManagerUserLoaded
                                                   object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    imageView = [[FBProfilePictureView alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateProfileInfo {
        
    imageView.profileID = [[TTFacebookUser currentUser] userID];
    [name setText:[[TTFacebookUser currentUser] name]];
    [surname setText:[[TTFacebookUser currentUser] surname]];
    [email setText:[[TTFacebookUser currentUser] email]];
    
}

- (void)facebookUserLoaded {
    [self updateProfileInfo];
}

- (void)facebookChanged {
    
    // See if we have a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateOpen) {
        [facebookStatus setText:@"Logged In"];
        [loginButton setTitle:@"LogOut"
                     forState:UIControlStateNormal];
        [[TTFacebookManager sharedInstance] loadUserInfos];
    } else {
        [facebookStatus setText:@"Logged Out"];
        [loginButton setTitle:@"LogIn"
                     forState:UIControlStateNormal];
        [[TTFacebookUser currentUser] clearAll];
        [self updateProfileInfo];
    }
}

- (IBAction)loginPressed:(id)sender {
    
    // See if we have a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateOpen) {
        [[TTFacebookManager sharedInstance] logout];
    } else {
        [[TTFacebookManager sharedInstance] login];
    }
    
}

@end
