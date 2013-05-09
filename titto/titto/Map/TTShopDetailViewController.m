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

#import "UIBarButtonItem+StyledButton.h"

#define HEADER_IMAGE_HEIGHT 300

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
    
    [self performSelectorInBackground:@selector(getFourSquareData)
                           withObject:nil];

    [orarioAperturaLabel setText:@"ORARI DI \nAPERTURA"];
    [orarioAperturaLabel setNumberOfLines:2];
    [orarioAperturaLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

    [emailLabel setText:@"EMAIL"];
    [emailLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

    [scrollView setDelegate:self];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    
    [indirizzoLabel setText:[NSString stringWithFormat:@"%@",[_infoDict objectForKey:@"indirizzo"]]];
    [indirizzoLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:25]];
    [cittaLabel setText:[_infoDict objectForKey:@"citta"]];
    [cittaLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

    [contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];

    [self setTitle:[_infoDict objectForKey:@"citta"]];

    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBackBarButtonItemWithTarget:self selector:@selector(backToMap)];

    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 30, 40)];
    [backButton setImage:[UIImage imageNamed:@"backArrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:backButton];
    
    NSLog(@"%@",[_infoDict objectForKey:@"img"]);

    UIImage * img = [[UIImage alloc]initWithData:[[NSUserDefaults standardUserDefaults]objectForKey:[_infoDict objectForKey:@"img"]]];
    if (!img){
        img = [UIImage imageNamed:@"header.png"];
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable) {
            if ([[_infoDict objectForKey:@"img"] length]>0){
                NSString * stringURL = [[NSString alloc]initWithString:[_infoDict objectForKey:@"img"]];
                NSData * dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]];
                img = [[UIImage alloc]initWithData:dataImage];
                [[NSUserDefaults standardUserDefaults] setObject:dataImage forKey:[_infoDict objectForKey:@"img"]];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
    }
    
    [headerImageView setImage:img];

    
}

-(void)viewWillAppear:(BOOL)animated{
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];

}

-(void)viewDidAppear:(BOOL)animated{

    [scrollView setContentOffset:CGPointMake(0, 0)];

    [emailContentLabel setTitle:[_infoDict objectForKey:@"mail"] forState:UIControlStateNormal];
    [[emailContentLabel titleLabel] setFont:[UIFont fontWithName:@"Archer-Semibold" size:18]];
    [emailContentLabel setTitleColor:[UIColor colorWithRed:.41 green:.41 blue:.41 alpha:1] forState:UIControlStateNormal];

    [predefinedButton setBackgroundImage:[UIImage imageNamed:@"bottone.png"] forState:UIControlStateNormal];
    [[predefinedButton titleLabel]setFont:[UIFont fontWithName:@"Archer-Semibold" size:16]];
    [predefinedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [predefinedButton setTitle:@"Preferito" forState:UIControlStateNormal];

    [self updateStarStatus];
    
    if ([[TTFoursquareManager sharedInstance]isShopOpenWithIdVenue:[_infoDict objectForKey:@"foursquare"]]) {
        
        [nastrinoImageView setAlpha:1];
        [nastrinoImageView setImage:[UIImage imageNamed:@"ribbon.aperto.png"]];
    }else{
        [nastrinoImageView setAlpha:0];
    }
}

-(void)backAction{
    
    [[self navigationController] popViewControllerAnimated:YES];
    
}

-(void)getFourSquareData{

    [[TTFoursquareManager sharedInstance]setDelegate:self];
    [[TTFoursquareManager sharedInstance] requestHoursInfoForIDVenue:[_infoDict objectForKey:@"foursquare"]];

}

-(void)backToMap{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)updateStarStatus{
    if ([[_infoDict objectForKey:@"cod_fb"] isEqualToString:[[[NSUserDefaults standardUserDefaults]objectForKey:FAVORITE_SHOP] objectForKey:@"cod_fb"]]) {
        [starImageView setImage:[UIImage imageNamed:@"star.png"]];
    }else{
        [starImageView setImage:[UIImage imageNamed:@"star-vuota.png"]];
    }
}

-(void)foursquareManagerDidGetHour:(NSArray *)hours{

    dispatch_async(dispatch_get_main_queue(), ^{

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

    });

}


-(void)foursquareManagerGetHourDidFail{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
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
        
    });

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
    
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Negozio Preferito" message:@"Vuoi impostare questo negozio come preferito?" delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"Si", nil];
    
    [alertView show];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{

    if (buttonIndex==1) {
        [self confirmFavoriteShop];
    }
}

-(void)confirmFavoriteShop{

    NSArray *niftyTags = @[ [_infoDict objectForKey:@"cod_fb"]];
    [[UAPush shared] setTags:niftyTags];
    [[UAPush shared] updateRegistration];

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
        [headerImageView setFrame:CGRectMake(0, (-95)+(yOffest/2), self.view.frame.size.width, HEADER_IMAGE_HEIGHT)];
    }
}

@end