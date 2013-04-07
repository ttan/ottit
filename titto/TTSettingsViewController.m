//
//  TTSettingsViewController.m
//  titto
//
//  Created by Paolo Ladisa on 4/6/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTSettingsViewController.h"

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
    [[cambiaNegozioButton titleLabel] setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
    [accessoFacebookLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
    [accessoUserLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
    [[logoutButton titleLabel] setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

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


}


-(IBAction)cambiaNegozio:(id)sender;
{
    
    [[self tabBarController] setSelectedIndex:0];
    
}

-(IBAction)fbLogout:(id)sender;{
    
    
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
