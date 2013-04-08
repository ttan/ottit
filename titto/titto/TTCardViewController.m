//
//  TTCardViewController.m
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTCardViewController.h"

#define HEADER_IMAGE_HEIGHT 278

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
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    [loginView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
    [cardView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
    
    name.font = negozio.font = tessera.font = [UIFont fontWithName:@"Archer-Semibold" size:25];

}

- (void)viewWillAppear:(BOOL)animated {
    
    if ([[TTFacebookManager sharedInstance] isFacebookLoggedIn]) {
        [self hideFacebookView];
    }else {
        [self showFacebookView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateProfileInfo {
    
    imageView.profileID = [[TTFacebookUser currentUser] userID];
    [name setText:[[TTFacebookUser currentUser] name]];
//    [surname setText:[[TTFacebookUser currentUser] surname]];
//    [email setText:[[TTFacebookUser currentUser] email]];
    
}

- (BOOL)canGenerateCard {
    
    NSInteger age = 0;

    if ([[TTFacebookUser currentUser] birthday]) {
        
        NSDate *birthday = [dateFormatter dateFromString:[[TTFacebookUser currentUser] birthday]];
        
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSYearCalendarUnit
                                           fromDate:birthday
                                           toDate:[NSDate date]
                                           options:0];
        age = [ageComponents year];
        
        NSLog(@"AGE %i", age);
        
    }
    if (age>=13 && age<=21) {
        return YES;
    }
    return NO;
}

- (void)facebookUserLoaded {
    
    [self updateProfileInfo];
    
    if ([self canGenerateCard]) {
        // show loading card
//        [self generateCard];
        
    }else {
        
        // show can't use card
        [tessera setText:@"Nooooooo sei old!"];
    }

}

- (void)facebookChanged {
    
    // See if we have a valid token for the current state.
    if ([[TTFacebookManager sharedInstance] isFacebookLoggedIn]) {
        [self hideFacebookView];
        [[TTFacebookManager sharedInstance] loadUserInfos];
    } else {
        [self showFacebookView];
        [[TTFacebookUser currentUser] clearAll];
        [self updateProfileInfo];
        
    }
}

- (IBAction)loginPressed:(id)sender {
    
    // See if we have a valid token for the current state.
    if ([[TTFacebookManager sharedInstance] isFacebookLoggedIn]) {
        [[TTFacebookManager sharedInstance] logout];
    } else {
        [[TTFacebookManager sharedInstance] login];
    }
    
}

- (void)showFacebookView {
    [UIView animateWithDuration:0.4f
                     animations:^{
                         loginView.alpha = 1.0f;
                     }];
}

- (void)hideFacebookView {
    [UIView animateWithDuration:0.4f
                     animations:^{
                         loginView.alpha = 0.0f;
                     }];
}

- (IBAction)actionPressed:(id)sender {
    
    if ([[TTFacebookManager sharedInstance] isFacebookLoggedIn] && [self canGenerateCard]) {
        [self generateCard];
    }
    
}

- (void)generateCard {
    
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
                               
                               [negozio setText:@"Via Goito"];
                               [tessera setText:[NSString stringWithFormat:@"Tessera:\n%@", code]];
                               
                           }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)aScrollView{
    
    NSInteger yOffest = aScrollView.contentOffset.y;
    
    if (yOffest<0) {
        yOffest=yOffest*(-1);
        [headerImage setFrame:CGRectMake(0, (-75)+(yOffest/2), self.view.frame.size.width, HEADER_IMAGE_HEIGHT)];
    }
}


@end
