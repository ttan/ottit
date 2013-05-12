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
        self.title = @"Tessera";
                
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
    
    if ([[UIScreen mainScreen] applicationFrame].size.height>480.0f) {
        
        scrollView.contentInset = UIEdgeInsetsMake(88.0f,
                                                   0.0f,
                                                   0.0f,
                                                   0.0f);
    }

    CGRect rect = CGRectMake(0.0f,
                             -2.0f,
                             containerView.frame.size.width,
                             10.0f);
    
    [containerView.layer setShadowPath:[UIBezierPath bezierPathWithRect:rect].CGPath];
    [containerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [containerView.layer setShadowOpacity:0.2f];
    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    [loginView setBackgroundColor:[UIColor whiteColor]];
    [cardView setBackgroundColor:[UIColor whiteColor]];
    [containerView setBackgroundColor:[UIColor whiteColor]];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    name.font = negozio.font = tessera.font = [UIFont fontWithName:@"Archer-Semibold" size:20];
    titlename.font = titlenegozio.font = titletessera.font = [UIFont fontWithName:@"Archer-Semibold" size:16];
    
    imageView.layer.shadowColor = [UIColor colorWithWhite:0.0f
                                                    alpha:0.5f].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    imageView.layer.shadowOpacity = 0.5f;
    imageView.layer.shadowRadius = 2.0f;
    [imageView setClipsToBounds:NO];
    
    [actionButton setBackgroundImage:[UIImage imageNamed:@"bottone"] forState:UIControlStateNormal];
    [[actionButton titleLabel]setFont:[UIFont fontWithName:@"Archer-Semibold" size:16]];
    
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"login-button-small.png"] stretchableImageWithLeftCapWidth:143.0f
                                                                                                        topCapHeight:0.0f]
                           forState:UIControlStateNormal];
    [facebookLoginMessage setFont:[UIFont fontWithName:@"Archer-Semibold" size:22]];
    
    loginView.alpha = cardView.alpha = 0.0f;
    
    nuvole = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nuvole.png"]];
    [nuvole setFrame:CGRectMake(0, 0, 640, 250)];
    [headerImage addSubview:nuvole];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self startAnimation];
    
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame),
                                          CGRectGetHeight(scrollView.frame)+1)];
    
    if ([[TTFacebookManager sharedInstance] isFacebookLoggedIn]) {
        
        [self hideFacebookView];
        
        if (!facebookInfoLoaded) {
            
            activity.alpha = 1.0f;
            [activity startAnimating];
            
            [[TTFacebookManager sharedInstance] loadUserInfos];
            
        }else {

            [self esiteTessera];
            [self checkTesseraStatus];
            
        }
        
    }else {
        
        facebookInfoLoaded = NO;
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
    
    if ([[TTFacebookUser currentUser] userID]) {
        facebookInfoLoaded = YES;
    }
    
    if ([self canGenerateCard]) {
        
        [self esiteTessera];
        
    }else {
        
        [self showCardView];
        
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
        
        if (!facebookInfoLoaded) {
            
            [[TTFacebookManager sharedInstance] loadUserInfos];
            
        }else {
            
            [self showCardView];
            
        }
        
    } else {
        
        [self showFacebookView];
        [[TTFacebookUser currentUser] clearAll];
        [self updateProfileInfo];
        facebookInfoLoaded = NO;
        
    }
}

- (IBAction)loginPressed:(id)sender {
    
    // See if we have a valid token for the current state.
    if ([[TTFacebookManager sharedInstance] isFacebookLoggedIn]) {
        [[TTFacebookManager sharedInstance] logout];
    } else {
        [[TTFacebookManager sharedInstance] login];
        
        [activity startAnimating];
        activity.alpha = 1.0f;
        
        [self hideFacebookView];
    }
    
}

- (IBAction)actionPressed:(id)sender {
    
    if ([[TTFacebookUser currentUser] cardID] && [[[TTFacebookUser currentUser] cardID] length]>0) {
        
//        NSLog(@"%@", [[TTFacebookUser currentUser] cardID]);
        [self showCard];
        
    }else if ([[TTFacebookManager sharedInstance] isFacebookLoggedIn] && [self canGenerateCard]) {
        if (![self negoziopreferitoImpostato]) {
            [[self tabBarController] setSelectedIndex:0];
        }else {
            [self generateCard];
        }
    }
    
}

- (void)esiteTessera {
    
    if([self isNetworkConnected]){
    
        NSString *urlString = [NSString stringWithFormat:@"http://backend.titto.it/app2013/esisteTessera.php?user_id=%@", [[TTFacebookUser currentUser] userID]];
        
        urlString = [urlString
                     stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        NSLog(@"%@", urlString);
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   
                                   if (!data) {
                                       return;
                                   }
                                   
                                   NSLog(@"%@", response);
                                   
                                   NSError * jsonError;
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&jsonError];
                                   
                                   BOOL esisteTessera = NO;
                                   
                                   if (dict && dict.count>0) {
                                       
                                       NSLog(@"%@  %@", dict, [dict allKeys]);
                                       
                                       /*
                                        
                                        citta = Bologna;
                                        indirizzo = Via Goito;
                                        store = BOG;
                                        tessera = G1003;
                                        
                                        */
                                       
                                       if ([dict objectForKey:@"codice"] && [dict objectForKey:@"tessera"]) {
                                           [[TTFacebookUser currentUser] setShopID:[dict objectForKey:@"store"]];
                                           [[TTFacebookUser currentUser] setCardID:[dict objectForKey:@"tessera"]];
                                           [[TTFacebookUser currentUser] setShopAddress:[dict objectForKey:@"indirizzo"]];
                                           [[TTFacebookUser currentUser] setShopCity:[dict objectForKey:@"citta"]];
                                           
                                           [[TTFacebookUser currentUser] saveUser];
                                           
//                                           tessera.alpha = 0.0f;
                                           [self checkTesseraStatus];
                                           
                                           [negozio setText:[NSString stringWithFormat:@"%@, %@", [self cittaNegozio], [self indirizzoNegozio]]];
                                           [tessera setText:[NSString stringWithFormat:@"%@", [[TTFacebookUser currentUser] cardID]]];
                                           [actionButton setTitle:@"Utilizza tessera"
                                                         forState:UIControlStateNormal];
                                           
                                           esisteTessera = YES;
                                           
                                       }
                                   }

                                   if (!esisteTessera) {
                                       
                                        if ([self negoziopreferitoImpostato]) {
                                            
                                            [actionButton setTitle:@"Utilizza tessera"
                                                          forState:UIControlStateNormal];

                                        }else {
                                            
                                            [actionButton setTitle:@"Scegli il tuo negozio"
                                                          forState:UIControlStateNormal];

                                        }
                                       
                                   }
                                   
                                   if (FORCE_TOUR) {
                                       
                                       TourTesseraViewController *tourViewController =
                                       [[TourTesseraViewController alloc] initWithNibName:@"TourTesseraViewController" bundle:nil];
                                       
                                       UINavigationController *navController =
                                       [[UINavigationController alloc] initWithRootViewController:tourViewController];
                                       
                                       [navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                                       
                                       [self presentViewController:navController
                                                          animated:YES
                                                        completion:^{
                                                            
                                                        }];
                                       
                                   }
                                       
                                   [self showCardView];
                                   
                                   // show loading card
                                   [UIView animateWithDuration:0.4f
                                                    animations:^{
                                                        
                                                        actionButton.alpha = 1.0f;
                                                        
                                                    }];
                                   
                               }];
            
    }else {
        
        [[TTFacebookUser currentUser] loadUser];
        
        if ([[TTFacebookUser currentUser] cardID]) {
            
            [negozio setText:[NSString stringWithFormat:@"%@, %@", [self cittaNegozio], [self indirizzoNegozio]]];
            [tessera setText:[NSString stringWithFormat:@"%@", [[TTFacebookUser currentUser] cardID]]];
            
            [actionButton setTitle:@"Utilizza tessera"
                          forState:UIControlStateNormal];

            [self showCardView];

//            [self hideCard];
            
        }else {
        
            if ([self negoziopreferitoImpostato]) {
                
                [actionButton setTitle:@"Utilizza tessera"
                              forState:UIControlStateNormal];
                
            }else {
                
                [actionButton setTitle:@"Scegli il tuo negozio"
                              forState:UIControlStateNormal];
                
            }
        }
        
        // show loading card
        [UIView animateWithDuration:0.4f
                         animations:^{
                             
                             actionButton.alpha = 1.0f;
                             
                         }];
        
    }
    
}

- (void)generateCard {
    
    NSString *urlString = [NSString stringWithFormat:@"http://backend.titto.it/app2013/tessera.php?pv=%@&user_id=%@&user_name=%@&user_surname=%@&user_email=%@&user_gender=%@&user_birthday=%@&user_link=%@&user_username=%@&school=%@", [self idNegozio], [[TTFacebookUser currentUser] userID], [[TTFacebookUser currentUser]name], [[TTFacebookUser currentUser] surname], [[TTFacebookUser currentUser] email], [[TTFacebookUser currentUser] gender], [[TTFacebookUser currentUser]  birthday], [[TTFacebookUser currentUser] userLink], [[TTFacebookUser currentUser] userName], [[TTFacebookUser currentUser] school]];
    
    urlString = [urlString
                 stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (!data) {
                                   return;
                               }
                               
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
                               
                               if (needShowTour || FORCE_TOUR) {
                                   
                                   TourTesseraViewController *tourViewController =
                                   [[TourTesseraViewController alloc] initWithNibName:@"TourTesseraViewController" bundle:nil];
                                   
                                   UINavigationController *navController =
                                   [[UINavigationController alloc] initWithRootViewController:tourViewController];
                                   
                                   [navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                                   
                                   [self presentViewController:navController
                                                      animated:YES
                                                    completion:^{
                                                        
                                                    }];
                                   
                               }
                                                              
                               [negozio setText:[NSString stringWithFormat:@"%@, %@", [self cittaNegozio], [self indirizzoNegozio]]];
                               [tessera setText:[NSString stringWithFormat:@"%@", [[TTFacebookUser currentUser] cardID]]];
                               
                               [[TTFacebookUser currentUser] setShopAddress:[self indirizzoNegozio]];
                               [[TTFacebookUser currentUser] setShopCity:[self cittaNegozio]];
                               
                               [[TTFacebookUser currentUser] saveUser];
                               
                               [actionButton setTitle:@"Utilizza tessera"
                                             forState:UIControlStateNormal];
                               
//                               [self hideCard];
                               
                               // show loading card
                               [UIView animateWithDuration:0.4f
                                                animations:^{
                                                    
                                                    actionButton.alpha = 1.0f;
                                                    
                                                }];
                               
                           }];
    
}

- (void)pingTessera {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dataOggi = [formatter stringFromDate:[NSDate date]];
    
    NSLog(@"%@", dataOggi);
    
    NSString *urlString = [NSString stringWithFormat:@"http://backend.titto.it/app2013/pingTessera.php?tessera=%@&data=%@", [[TTFacebookUser currentUser] cardID], dataOggi];
    
    urlString = [urlString
                 stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSLog(@"%@ %@", response, data);
                               
                           }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)aScrollView{
    
    NSInteger yOffest = aScrollView.contentOffset.y;
    
    if (yOffest<0&&yOffest>-150) {
        
        yOffest=yOffest*(-1);
        
        [headerImage setFrame:CGRectMake(0, (-75)+(yOffest/2), self.view.frame.size.width, HEADER_IMAGE_HEIGHT)];
        [headerLogo setFrame:CGRectMake(0, (-70)+(yOffest/2), self.view.frame.size.width, HEADER_IMAGE_HEIGHT)];

    }else if (yOffest>=0) {
        [headerImage setFrame:CGRectMake(0, -75, self.view.frame.size.width, HEADER_IMAGE_HEIGHT)];
        [headerLogo setFrame:CGRectMake(0, -70, self.view.frame.size.width, HEADER_IMAGE_HEIGHT)];
    }
}

#pragma mark - Negozio Preferito

- (NSString*)indirizzoNegozio {
    
    if ([[TTFacebookUser currentUser] shopCity]) {
        return [[TTFacebookUser currentUser] shopCity];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP];
        return [dict objectForKey:FAVORITE_SHOP_INDIRIZZO];
        
    }
    
    return nil;
    
}

- (NSString*)cittaNegozio {
   
    if ([[TTFacebookUser currentUser] shopAddress]) {
        return [[TTFacebookUser currentUser] shopAddress];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP];
        return [dict objectForKey:FAVORITE_SHOP_CITTA];
        
    }
    
    return nil;
    
}

- (NSString*)idNegozio {
    
    if ([[TTFacebookUser currentUser] shopID]) {
        return [[TTFacebookUser currentUser] shopID];
    }
    
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

- (void)showFacebookView {
    
    [activity stopAnimating];
    
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

- (void)hideCard {
    
    [UIView animateWithDuration:1.0f
                     animations:^{
                        
                         tessera.alpha = 0.0f;
                         
                     }];
    
}

- (void)showCard {
    
    if (tessera.alpha==0.0f) {
        
        [UIView animateWithDuration:0.4f
                         animations:^{
                             
                             tessera.alpha = 1.0f;
                             [self pingTessera];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [[NSUserDefaults standardUserDefaults] setObject:[NSDate date]
                                                                       forKey:TITTO_CARD_LAST_DATE_USED];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             
//                             [NSTimer scheduledTimerWithTimeInterval:TEMPO_SCADENZA_TESSERA_IN_SECONDI
//                                                              target:self
//                                                            selector:@selector(hideCard)
//                                                            userInfo:nil
//                                                             repeats:NO];
                             
                         }];
        
    }
    
}

- (void)checkTesseraStatus {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TITTO_CARD_LAST_DATE_USED]) {
        
        NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:TITTO_CARD_LAST_DATE_USED];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd"];
    
        NSLog(@"%i   %i", [[formatter stringFromDate:date] intValue], [[formatter stringFromDate:[NSDate date]] intValue]);
        
        if ([[formatter stringFromDate:date] intValue]!=[[formatter stringFromDate:[NSDate date]] intValue]) {
            
            // sblocca
            tessera.alpha = 0.0f;

            
        }else {
            
            if ([date timeIntervalSinceNow]>(60*60*24)) {
                
                // sblocca
                tessera.alpha = 0.0f;
   
            }else {
                
                tessera.alpha = 1.0f;

            }
        }
    }
}

- (void)hideCardView {
    [UIView animateWithDuration:0.4f
                     animations:^{
                         cardView.alpha = 0.0f;
                     }];
}

- (void)showCardView {

    [self updateProfileInfo];
    [activity stopAnimating];
    
    [UIView animateWithDuration:0.4f
                     animations:^{
                         cardView.alpha = 1.0f;
                         actionButton.alpha = 1.0f;
                     }];
}

#pragma mark - Util

- (BOOL)isNetworkConnected {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable);
}

#pragma mark - Animation 

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self startAnimation];
}

- (void)startAnimation {
    
    if (!nuvole.layer.animationKeys || nuvole.layer.animationKeys.count==0) {
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        
        [animation setDelegate:self];
        [animation setRepeatCount:HUGE_VALF];
        [animation setFromValue:[NSValue valueWithCGPoint:CGPointMake(0.0f, 125.0f)]];
        [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(headerImage.frame.size.width+10.0f, 125.0f)]];
        [animation setDuration:15.0f];
        
        [animation setValue:@"primary_on"
                     forKey:@"animation_key"];
        
        [nuvole.layer addAnimation:animation
                            forKey:@"primary_on"];
        
    }
    
}

@end
