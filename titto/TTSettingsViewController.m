//
//  TTSettingsViewController.m
//  titto
//
//  Created by Paolo Ladisa on 4/6/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTSettingsViewController.h"
#import "TTConfigDefines.h"
#import "TTFacebookManager.h"
#import "TTFacebookUser.h"

@interface TTSettingsViewController ()

@end

@implementation TTSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization

        self.title = @"Settings";
        self.tabBarItem.image = [UIImage imageNamed:@"second.png"];

    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
    
    [impostazioniLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
    [negozioLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
    [negozioPreferitoLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
    [[cambiaNegozioButton titleLabel] setFont:[UIFont fontWithName:@"Archer-Semibold" size:16]];
    [accessoFacebookLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
    [[logoutButton titleLabel] setFont:[UIFont fontWithName:@"Archer-Semibold" size:16]];

    [copyLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:13]];
    [srlLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:13]];
    [viaLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:13]];
    [cittaLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:13]];
    [piLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:13]];
    [telLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:13]];
    [[sitoButton titleLabel] setFont:[UIFont fontWithName:@"Archer-Semibold" size:13]];
    [[emailButton titleLabel] setFont:[UIFont fontWithName:@"Archer-Semibold" size:13]];

}

-(void)viewWillAppear:(BOOL)animated{

    NSString * indirizzo = [[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP] objectForKey:@"indirizzo"];
    [negozioPreferitoLabel setText:indirizzo];

    
    if (1){
        [accessoUserLabel setAlpha:1];
        
        NSString * name = [NSString stringWithFormat:@"%@ %@",[TTFacebookUser currentUser].name,[TTFacebookUser currentUser].surname];
        [accessoUserLabel setText:name];
        [accessoUserLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

    }else{

        [accessoUserLabel setAlpha:0];
        [logoutButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

-(IBAction)cambiaNegozio:(id)sender;
{
    [[self tabBarController] setSelectedIndex:0];
}

-(IBAction)fbLogout:(id)sender;
{

    if ([[[logoutButton titleLabel] text] isEqualToString:@"Login"]) {
        [[self tabBarController] setSelectedIndex:1];
    }else{
        [[TTFacebookManager sharedInstance]logout];
        [accessoUserLabel setText:@""];
        [accessoUserLabel setAlpha:0];
        [logoutButton setTitle:@"Login" forState:UIControlStateNormal];

    }
}

-(IBAction)openSite:(id)sender;
{
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.titto.it"]];
    
}

-(IBAction)openMail:(id)sender;
{
        if ([MFMailComposeViewController canSendMail])
        {
            mailer = [[MFMailComposeViewController alloc] init];
            [mailer setSubject:@"Info"];
            [mailer setMailComposeDelegate:self];
            NSArray *toRecipients = [NSArray arrayWithObjects:@"info@titto.it", nil];
            [mailer setToRecipients:toRecipients];
            [self presentViewController:mailer animated:YES completion:^{

            }];
        }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [mailer dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
