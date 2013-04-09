//
//  TTCardViewController.m
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTCardViewController.h"

#define HEADER_IMAGE_HEIGHT headerImage.frame.size.height

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
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    [loginView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
    [cardView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
    
    name.font = negozio.font = tessera.font = [UIFont fontWithName:@"Archer-Semibold" size:20];
    titlename.font = titlenegozio.font = titletessera.font = [UIFont fontWithName:@"Archer-Semibold" size:16];
    
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    imageView.layer.shadowOpacity = 0.3f;
    imageView.layer.shadowRadius = 5.0f;
    imageView.layer.cornerRadius = 2.0f;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame),
                                          CGRectGetHeight(scrollView.frame)+1)];
    
    if ([[TTFacebookManager sharedInstance] isFacebookLoggedIn]) {
        
        [self hideFacebookView];
        
        if (!facebookInfoLoaded) {
            [[TTFacebookManager sharedInstance] loadUserInfos];
        }
        
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
    
}

- (BOOL)canGenerateCard {
    
    NSInteger age = 0;

    if ([[TTFacebookUser currentUser] birthday]) {
        
        NSDate *birthday = [dateFormatter dateFromString:[[TTFacebookUser currentUser] birthday]];
        
        if (birthday) {
            NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                               components:NSYearCalendarUnit
                                               fromDate:birthday
                                               toDate:[NSDate date]
                                               options:0];
            age = [ageComponents year];
            
            NSLog(@"AGE %i", age);
        }
   
        
    }
    if (age>=13 && age<=CARD_MIN_AGE) {
        return YES;
    }
    return NO;
}

- (void)facebookUserLoaded {
    
    [self updateProfileInfo];
    
//    [self esiteTessera];
    
    if ([self canGenerateCard]) {
        
        if ([self negoziopreferitoImpostato]) {
            [actionButton setTitle:@"Genera tessera"
                          forState:UIControlStateNormal];
            
        }else {
            [actionButton setTitle:@"Scegli il tuo negozio"
                          forState:UIControlStateNormal];

        }
        
        // show loading card
        [UIView animateWithDuration:0.4f
                         animations:^{
                             
                             actionButton.alpha = 1.0f;
                             
                         }];
        
    }else {
        // show can't use card
        [tessera setText:@"Nooooooo sei old!"];
        
        // show webview
        [UIView animateWithDuration:0.4f
                         animations:^{
                             
                             titletessera.alpha = titlenegozio.alpha = 0.0f;
                             
                         }];
    }

}

- (void)facebookChanged {
    
    // See if we have a valid token for the current state.
    if ([[TTFacebookManager sharedInstance] isFacebookLoggedIn]) {
        [self hideFacebookView];
        
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
        if (![self negoziopreferitoImpostato]) {
            [[self tabBarController] setSelectedIndex:0];
        }else {
            [self generateCard];
        }
    }
    
}

- (void)esiteTessera {
    
    NSString *urlString = [NSString stringWithFormat:@"http://backend.titto.it/app2013/esisteTessera.php?user_id=%@", [[TTFacebookUser currentUser] userID]];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSLog(@"%@", response);
                               
                               NSError * jsonError;
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingAllowFragments
                                                                                      error:&jsonError];
                               
                               NSLog(@"%@  %@", dict, [dict allKeys]);
                               
                               /*
                            
                                citta = Bologna;
                                indirizzo = Via Goito;
                                store = BOG;
                                tessera = G1003;
                                
                                */
                               
                               if ([dict objectForKey:@"store"]) {
                                   [[TTFacebookUser currentUser] setShopID:[dict objectForKey:@"store"]];
                               }
                               
                               if ([dict objectForKey:@"tessera"]) {
                                   [[TTFacebookUser currentUser] setCardID:[dict objectForKey:@"tessera"]];
                               }
                               
                               [negozio setText:[NSString stringWithFormat:@"%@, %@", [self cittaNegozio], [self indirizzoNegozio]]];
                               [tessera setText:[NSString stringWithFormat:@"%@", [[TTFacebookUser currentUser] cardID]]];
                               
                               [[TTFacebookUser currentUser] saveUser];
                           }];
    
}

- (void)generateCard {
    
    NSString *urlString = [NSString stringWithFormat:@"http://backend.titto.it/app2013/tessera.php?pv=%@&user_id=%@&user_name=%@&user_surname=%@&user_email=%@&user_gender=%@&user_birthday=%@&user_link=%@&user_username=%@", [self idNegozio], [[TTFacebookUser currentUser] userID], [[TTFacebookUser currentUser]name], [[TTFacebookUser currentUser] surname], [[TTFacebookUser currentUser] email], [[TTFacebookUser currentUser] gender], [[TTFacebookUser currentUser]  birthday], [[TTFacebookUser currentUser] userLink], [[TTFacebookUser currentUser] userName]];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSLog(@"%@", response);

                               NSError * jsonError;
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingAllowFragments
                                                                                      error:&jsonError];
                               
                               NSLog(@"%@  %@", dict, [dict allKeys]);
                               
                               /*
                                
                                nuova = no;
                                store = BOG;
                                tessera = G1003;
                                
                                */
                               
                               if ([[dict objectForKey:@"nuova"] boolValue]) {
                                   needShowTour = YES;
                               }else {
                                   needShowTour = NO;
                               }
                               
                               if ([dict objectForKey:@"store"]) {
                                   [[TTFacebookUser currentUser] setShopID:[dict objectForKey:@"store"]];
                               }
                               
                               if ([dict objectForKey:@"tessera"]) {
                                   [[TTFacebookUser currentUser] setCardID:[dict objectForKey:@"tessera"]];
                               }
                               
                               [negozio setText:[NSString stringWithFormat:@"%@, %@", [self cittaNegozio], [self indirizzoNegozio]]];
                               [tessera setText:[NSString stringWithFormat:@"%@", [[TTFacebookUser currentUser] cardID]]];
                               
                               [[TTFacebookUser currentUser] saveUser];
                           }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)aScrollView{
    
    NSInteger yOffest = aScrollView.contentOffset.y;
    
    if (yOffest<0) {
        yOffest=yOffest*(-1);
        [headerImage setFrame:CGRectMake(0, (-75)+(yOffest/2), self.view.frame.size.width, HEADER_IMAGE_HEIGHT)];
    }
}

#pragma mark - Negozio Preferito

- (NSString*)indirizzoNegozio {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP];
        return [dict objectForKey:FAVORITE_SHOP_INDIRIZZO];
        
    }
    
    return nil;
    
}

- (NSString*)cittaNegozio {
   
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP];
        return [dict objectForKey:FAVORITE_SHOP_CITTA];
        
    }
    
    return nil;
    
}

- (NSString*)idNegozio {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP];
        return [dict objectForKey:FAVORITE_SHOP_ID];

    }
    
    return nil;
}

- (BOOL)negoziopreferitoImpostato {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP];
        if ([dict objectForKey:FAVORITE_SHOP_ID]) {
            
            NSString *idNegozio = [dict objectForKey:FAVORITE_SHOP_ID];
            if (idNegozio && [idNegozio length]>0) {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark - View State

- (void)showNoFacebookLogged {
    
}

- (void)showUserInfoLoaded {
    
}

@end
