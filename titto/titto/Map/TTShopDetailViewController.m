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

#define HEADER_IMAGE_HEIGHT 310

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
    
    [self performSelectorInBackground:@selector(getShopHoursData)
                           withObject:nil];

    [emailLabel setText:@"EMAIL"];
    [emailLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

    [scrollView setDelegate:self];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setShowsVerticalScrollIndicator:NO];

    [indirizzoLabel setText:[NSString stringWithFormat:@"%@",[_infoDict objectForKey:@"indirizzo"]]];
    [indirizzoLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:25]];
    [cittaLabel setText:[_infoDict objectForKey:@"citta"]];
    [cittaLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

    [contentView setBackgroundColor:[UIColor colorWithRed:((float)248/255) green:((float)248/255) blue:((float)248/255) alpha:1]];
    [[self view] setBackgroundColor:[UIColor colorWithRed:((float)248/255) green:((float)248/255) blue:((float)248/255) alpha:1]];

    [[contentView layer] setCornerRadius:4];
    [contentView.layer setShadowPath:[UIBezierPath bezierPathWithRect:CGRectMake(0, -2, contentView.frame.size.width, contentView.frame.size.height/2)].CGPath];
    [[contentView layer]setShadowColor:[UIColor blackColor].CGColor];
    [[contentView layer] setShadowOpacity:0.3];
    [[contentView layer] setShadowRadius:5];

    [self setTitle:[_infoDict objectForKey:@"citta"]];

//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBackBarButtonItemWithTarget:self selector:@selector(backToMap)];

    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(9, 5, 30, 32)];
    [backButton setImage:[UIImage imageNamed:@"frecciabig"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:backButton];
    
    UIColor *startColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.85];
    UIColor *endColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    UIImage * img = [[UIImage alloc]initWithData:[[NSUserDefaults standardUserDefaults]objectForKey:[_infoDict objectForKey:@"img"]]];
    if (!img){
        img = [UIImage imageNamed:@"header"];
        startColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.65];
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

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[headerImageView layer] bounds];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)startColor.CGColor,
                       (id)endColor.CGColor,
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.5],
                          nil];
    
    [[headerImageView layer] insertSublayer:gradient atIndex:0];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [scrollView setContentOffset:CGPointMake(0, 0)];
    
}

-(void)viewDidAppear:(BOOL)animated{

    [emailContentLabel setTitle:[_infoDict objectForKey:@"mail"] forState:UIControlStateNormal];
    [[emailContentLabel titleLabel] setFont:[UIFont fontWithName:@"Archer-Semibold" size:18]];
    [emailContentLabel setTitleColor:[UIColor colorWithRed:((float)100/255) green:((float)100/255) blue:((float)100/255) alpha:1] forState:UIControlStateNormal];
    [emailContentLabel setTitleColor:[UIColor colorWithRed:((float)50/255) green:((float)50/255) blue:((float)50/255) alpha:1] forState:UIControlStateHighlighted];
    [predefinedButton setBackgroundImage:[UIImage imageNamed:@"bottone.png"] forState:UIControlStateNormal];
    [[predefinedButton titleLabel]setFont:[UIFont fontWithName:@"Archer-Semibold" size:16]];
    [predefinedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [predefinedButton setTitle:@"Preferito" forState:UIControlStateNormal];

    [self updateStarStatus];

    if ([[TTShopHoursManager sharedInstance]isShopOpenWithIdVenue:[_infoDict objectForKey:@"cod_fb"]]) {

        [nastrinoImageView setAlpha:1];
        [nastrinoImageView setImage:[UIImage imageNamed:@"ribbon.aperto.png"]];
    }else{
        [nastrinoImageView setAlpha:0];
    }
}

-(void)backAction{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)getShopHoursData{
    [[TTShopHoursManager sharedInstance]setDelegate:self];
    [[TTShopHoursManager sharedInstance] requestHoursInfoForIDVenue:[_infoDict objectForKey:@"cod_fb"]];
}

-(void)backToMap{
    [[self navigationController] popViewControllerAnimated:YES];
}


-(void)updateStarStatus{
    if ([[_infoDict objectForKey:@"cod_fb"] isEqualToString:[[[NSUserDefaults standardUserDefaults]objectForKey:FAVORITE_SHOP] objectForKey:@"cod_fb"]]) {
        [starButton setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    }else{
        [starButton setImage:[UIImage imageNamed:@"star-vuota.png"]forState:UIControlStateNormal];
    }
}

-(IBAction)changeButtonStatus:(id)sender;
{
    [self predefinedButtonAction:sender];
}


-(void)shopHoursManagerDidGetHourWithDict:(NSDictionary *)hours{

        [noConnectionLabel setAlpha:0];
        NSInteger index=1;
    
    if ([hours count]==0) {
        [self shopHoursAreNotAvailable];
        return;
    }

        for (index=1; index<8; index++){
            NSString * startHour = [[hours objectForKey:[NSString stringWithFormat:@"%i",index]] objectForKey:@"start"];
            NSString * endHour = [[hours objectForKey:[NSString stringWithFormat:@"%i",index]] objectForKey:@"end"];

            NSMutableString * mutableStart = [NSMutableString stringWithString:startHour];
            [mutableStart insertString:@":" atIndex:2];
            NSMutableString * mutableEnd = [NSMutableString stringWithString:endHour];
            [mutableEnd insertString:@":" atIndex:2];

            switch (index){
                case 1:
                    [orarioLunediLabel setText:[NSString stringWithFormat:@"%@-%@",mutableStart,mutableEnd]];
                    [orarioLunediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:22]];
                    [lunediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    break;
                case 2:
                    [orarioMartediLabel setText:[NSString stringWithFormat:@"%@-%@",mutableStart,mutableEnd]];
                    [orarioMartediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:22]];
                    [martediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    break;
                case 3:
                    [orarioMercolediLabel setText:[NSString stringWithFormat:@"%@-%@",mutableStart,mutableEnd]];
                    [orarioMercolediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:22]];
                    [mercolediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 4:
                    [orarioGiovediLabel setText:[NSString stringWithFormat:@"%@-%@",mutableStart,mutableEnd]];
                    [orarioGiovediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:22]];
                    [giovediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 5:
                    [orarioVenerdiLabel setText:[NSString stringWithFormat:@"%@-%@",mutableStart,mutableEnd]];
                    [orarioVenerdiLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:22]];
                    [venerdiLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 6:
                    [orarioSabatoLabel setText:[NSString stringWithFormat:@"%@-%@",mutableStart,mutableEnd]];
                    [orarioSabatoLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:22]];
                    [sabatoLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 7:
                    [orarioDomenicaLabel setText:[NSString stringWithFormat:@"%@-%@",mutableStart,mutableEnd]];
                    [orarioDomenicaLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:22]];
                    [domenicaLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    
                    break;
                default:
                    break;
            }
        }

        [containerView setAlpha:1];
    
}


-(void)shopHoursAreNotAvailable{
    
    [containerView setAlpha:0];
    
    [noConnectionLabel setAlpha:1];
    
    [noConnectionLabel setText:@"Non sono ancora disponibili gli orari di questo negozio."];
    [noConnectionLabel setNumberOfLines:3];
    [noConnectionLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

    
}

-(void)shopHoursManagerGetHourDidFail{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [containerView setAlpha:0];
        
        [noConnectionLabel setAlpha:1];
        
        [noConnectionLabel setText:@"Hai bisogno di una connessione ad internet per visualizzare gli orari."];
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
    [[NSUserDefaults standardUserDefaults]synchronize];
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

    }else{

        CGFloat alpha = 1-(((CGFloat)(yOffest-60)/100)*2);
        [backButton setAlpha:alpha];
        
        if (alpha<0.25) {
            [backButton setEnabled:NO];
        }else{
            [backButton setEnabled:YES];

        }

    }
}

@end