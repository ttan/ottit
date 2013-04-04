//
//  TTShopDetailViewController.m
//  Map
//
//  Created by Paolo Ladisa on 3/28/13.
//  Copyright (c) 2013 Titto. All rights reserved.
//

#import "TTShopDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "TTConfigDefines.h"

@interface TTShopDetailViewController ()

@end

@implementation TTShopDetailViewController

@synthesize infoDict=_infoDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [lunediLabel setAlpha:0];
    [martediLabel setAlpha:0];
    [mercolediLabel setAlpha:0];
    [giovediLabel setAlpha:0];
    [venerdiLabel setAlpha:0];
    [sabatoLabel setAlpha:0];
    [domenicaLabel setAlpha:0];

    [scrollView setBackgroundColor:[UIColor clearColor]];

    [contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
    [[TTFoursquareManager sharedInstance]setDelegate:self];
    [[TTFoursquareManager sharedInstance] requestHoursInfoForIDVenue:[_infoDict objectForKey:@"foursquare"]];

    [[contentView layer] setShadowColor:[UIColor blackColor].CGColor];
    [[contentView layer] setShadowOffset:CGSizeMake(0, -1)];
    [[contentView layer] setShadowOpacity:0.5];
    [[contentView layer] setMasksToBounds:NO];

    [self setTitle:[_infoDict objectForKey:@"citta"]];
    
    
    UIImage *img;
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable) {

        NSString * stringURL;
        if ([[_infoDict objectForKey:@"img"] length]>0){

            stringURL = [[NSString alloc]initWithString:[_infoDict objectForKey:@"img"]];

            NSData * dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]];
            img = [[UIImage alloc]initWithData:dataImage];

        }else{

            img = [UIImage imageNamed:@"header.png"];

        }

    }else{
        img = [UIImage imageNamed:@"header.png"];
    }

    [headerImageView setImage:img];
    [indirizzoLabel setText:[NSString stringWithFormat:@"%@",[_infoDict objectForKey:@"indirizzo"]]];
    [indirizzoLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:25]];
    [cittaLabel setText:[_infoDict objectForKey:@"citta"]];
    [cittaLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
    [orarioAperturaLabel setText:@"ORARI DI \nAPERTURA"];
    [orarioAperturaLabel setNumberOfLines:2];
    [orarioAperturaLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

    [emailLabel setText:@"EMAIL"];
    [emailLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

    [emailContentLabel setTitle:[_infoDict objectForKey:@"mail"] forState:UIControlStateNormal];
    [[emailContentLabel titleLabel] setFont:[UIFont fontWithName:@"Archer-Semibold" size:18]];
    [emailContentLabel setTitleColor:[UIColor colorWithRed:.41 green:.41 blue:.41 alpha:1] forState:UIControlStateNormal];

    [predefinedButton setBackgroundImage:[UIImage imageNamed:@"bottone.png"] forState:UIControlStateNormal];
    [[predefinedButton titleLabel]setFont:[UIFont fontWithName:@"Archer-Semibold" size:16]];
    [predefinedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [predefinedButton setTitle:@"Preferito" forState:UIControlStateNormal];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [scrollView setContentOffset:CGPointMake(0, 0)];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}

-(void)foursquareManagerDidGetHour:(NSArray *)hours{

    [noConnectionLabel setAlpha:0];
    [orarioAperturaLabel setAlpha:1];

    for (NSDictionary * info in hours) {
        NSDictionary * hours = [[info objectForKey:@"open"] objectAtIndex:0];
        for (id days in [info objectForKey:@"days"]) {
            
            NSString * startHour = [hours objectForKey:@"start"];
            NSString * endHour = [hours objectForKey:@"end"];

            startHour = [NSString stringWithFormat:@"%@:%@",[startHour substringToIndex:2],[startHour substringFromIndex:2]];
            endHour = [NSString stringWithFormat:@"%@:%@",[endHour substringToIndex:2],[endHour substringFromIndex:2]];
    
            switch ([days intValue]){
                case 1:
                    [orarioLunediLabel setText:[NSString stringWithFormat:@"%@-%@",startHour,endHour]];
                    [orarioLunediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    [lunediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    break;
                case 2:
                    [orarioMartediLabel setText:[NSString stringWithFormat:@"%@-%@",startHour,endHour]];
                    [orarioMartediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    [martediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    break;
                case 3:
                    [orarioMercolediLabel setText:[NSString stringWithFormat:@"%@-%@",startHour,endHour]];
                    [orarioMercolediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    [mercolediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 4:
                    [orarioGiovediLabel setText:[NSString stringWithFormat:@"%@-%@",startHour,endHour]];
                    [orarioGiovediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    [giovediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 5:
                    [orarioVenerdiLabel setText:[NSString stringWithFormat:@"%@-%@",startHour,endHour]];
                    [orarioVenerdiLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    [venerdiLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 6:
                    [orarioSabatoLabel setText:[NSString stringWithFormat:@"%@-%@",startHour,endHour]];
                    [orarioSabatoLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    [sabatoLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 7:
                    [orarioDomenicaLabel setText:[NSString stringWithFormat:@"%@-%@",startHour,endHour]];
                    [orarioDomenicaLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    [domenicaLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                default:
                    break;
            }
        }
    }
    
    [lunediLabel setAlpha:1];
    [martediLabel setAlpha:1];
    [mercolediLabel setAlpha:1];
    [giovediLabel setAlpha:1];
    [venerdiLabel setAlpha:1];
    [sabatoLabel setAlpha:1];
    [domenicaLabel setAlpha:1];

}


-(void)foursquareManagerGetHourDidFail{

    [orarioAperturaLabel setAlpha:0];

    [lunediLabel setAlpha:0];
    [martediLabel setAlpha:0];
    [mercolediLabel setAlpha:0];
    [giovediLabel setAlpha:0];
    [venerdiLabel setAlpha:0];
    [sabatoLabel setAlpha:0];
    [domenicaLabel setAlpha:0];

    [noConnectionLabel setAlpha:1];

    [noConnectionLabel setText:@"Hai bisogno di una connessione ad internet per visualizzare gli orari"];
    [noConnectionLabel setNumberOfLines:3];
    [noConnectionLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

}



-(IBAction)openMail:(id)sender;
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable) {
        
        if ([MFMailComposeViewController canSendMail])
        {
            mailer = [[MFMailComposeViewController alloc] init];
            [mailer setSubject:@"Info"];
            [mailer setMailComposeDelegate:self];
            NSArray *toRecipients = [NSArray arrayWithObjects:[[emailContentLabel titleLabel] text], nil];
            [mailer setToRecipients:toRecipients];
            [self presentViewController:mailer animated:YES completion:^{

            }];
        }
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
        [mailer dismissViewControllerAnimated:YES completion:^{
        
    }];

}


-(IBAction)predefinedButtonAction:(id)sender;
{

    [[NSUserDefaults standardUserDefaults] setObject:[_infoDict objectForKey:@"cod_fb"] forKey:FAVORITE_SHOP_ADDRESS];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
