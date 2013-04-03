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

static id ObjectOrNull(id object)
{
    return object ?: [NSNull null];
}

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
    
//    NSDictionary *dict = @{@"user_id" : ObjectOrNull([[TTFacebookUser currentUser] userID]),
//                           @"user_name" : ObjectOrNull([[TTFacebookUser currentUser] name]),
//                           @"user_surname" : ObjectOrNull([[TTFacebookUser currentUser] surname]),
//                           @"user_email" : ObjectOrNull([[TTFacebookUser currentUser] email]),
//                           @"user_gender" : ObjectOrNull([[TTFacebookUser currentUser] gender]),
//                           @"user_birthday" : ObjectOrNull([[TTFacebookUser currentUser] birthday]),
//                           @"user_link" : ObjectOrNull([[TTFacebookUser currentUser] userLink]),
//                           @"user_username" : ObjectOrNull([[TTFacebookUser currentUser] userName])};
//    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:@"negozzio"
//             forKey:@"pv"];
//    [dict setObject:[[TTFacebookUser currentUser] userID]
//             forKey:@"user_id"];
//    [dict setObject:[[TTFacebookUser currentUser] name]
//             forKey:@"user_name"];
//    [dict setObject:[[TTFacebookUser currentUser] surname]
//             forKey:@"user_surname"];
//    [dict setObject:[[TTFacebookUser currentUser] email]
//             forKey:@"user_email"];
//    [dict setObject:[[TTFacebookUser currentUser] gender]
//             forKey:@"user_gender"];
//    [dict setObject:[[TTFacebookUser currentUser] birthday]
//             forKey:@"user_birthday"];
//    [dict setObject:[[TTFacebookUser currentUser] userLink]
//             forKey:@"user_link"];
//    [dict setObject:[[TTFacebookUser currentUser] userName]
//             forKey:@"user_username"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://backend.titto.it/app2013/tessera.php?pv=%@&user_id=%@&user_name=%@&user_surname=%@&user_email=%@&user_gender=%@&user_birthday=%@&user_link=%@&user_username=%@", @"BOG", [[TTFacebookUser currentUser] userID], [[TTFacebookUser currentUser]name], [[TTFacebookUser currentUser] surname], [[TTFacebookUser currentUser] email], [[TTFacebookUser currentUser] gender], [[TTFacebookUser currentUser]  birthday], [[TTFacebookUser currentUser] userLink], [[TTFacebookUser currentUser] userName]];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSLog(@"%@", response);
                               
                               NSString *code = [[NSString alloc] initWithData:data
                                                                      encoding:NSUTF8StringEncoding];
                               
                               NSLog(@"%@", code);
                               
                               [tessera setText:[NSString stringWithFormat:@"Tessera:\n%@", code]];
                           }];
    
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
