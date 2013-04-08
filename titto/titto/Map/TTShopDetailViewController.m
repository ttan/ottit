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

#define HEADER_IMAGE_HEIGHT 278

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

    [scrollView setDelegate:self];
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

    [self updateStarStatus];
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [[self navigationController] setNavigationBarHidden:YES animated:YES];

}

-(void)updateStarStatus{

    if ([[_infoDict objectForKey:@"cod_fb"] isEqualToString:[[[NSUserDefaults standardUserDefaults]objectForKey:FAVORITE_SHOP] objectForKey:@"cod_fb"]]) {

        [starImageView setImage:[UIImage imageNamed:@"first.png"]];

    }else{

        [starImageView setImage:[UIImage imageNamed:@"second.png"]];

    }
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
    
    if ([self isShopOpenWithInfo:hours]) {
        
    }else{
        
    }

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


-(BOOL)isShopOpenWithInfo:(NSArray *)info{

    BOOL isOpen = NO;
    
    NSDateFormatter * dayDateFormatter = [[NSDateFormatter alloc] init];
    [dayDateFormatter setDateFormat:@"c"];
    NSInteger currentDay = [[dayDateFormatter stringFromDate:[NSDate date]] integerValue];

    NSDateFormatter * currentDateFormatter = [[NSDateFormatter alloc] init];
    [currentDateFormatter setDateFormat:@"HHMM"];

    NSInteger currentHour = [[currentDateFormatter stringFromDate:[NSDate date]] integerValue];

    for (NSDictionary * hour in info) {
        NSArray * days = [hour objectForKey:@"days"];

        for (id day in days){

            if ([day integerValue]==currentDay){

                if ([hour objectForKey:@"includesToday"]){

                    NSDictionary * hours = [[hour objectForKey:@"open"] objectAtIndex:0];

                    NSInteger openHour = [[hours objectForKey:@"start"] integerValue];
                    NSInteger closeHour = [[hours objectForKey:@"end"] integerValue];
                    
                    if (currentHour>=openHour && currentHour<closeHour) {
                        
                        isOpen = YES;
                        
                    }

                }
            }
        }
    }

    return isOpen;

}


-(IBAction)openMail:(id)sender;
{        
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

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{

        [mailer dismissViewControllerAnimated:YES completion:^{

    }];
}


-(IBAction)predefinedButtonAction:(id)sender;
{

    [[NSUserDefaults standardUserDefaults] setObject:_infoDict forKey:FAVORITE_SHOP];

    [self updateStarStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)scrollViewDidScroll:(UIScrollView *)aScrollView{

    NSInteger yOffest = aScrollView.contentOffset.y;

    if (yOffest<0) {
        yOffest=yOffest*(-1);
        [headerImageView setFrame:CGRectMake(0, (-75)+(yOffest/2), self.view.frame.size.width, HEADER_IMAGE_HEIGHT)];
    }
}

@end