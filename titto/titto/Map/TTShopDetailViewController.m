//
//  TTShopDetailViewController.m
//  Map
//
//  Created by Paolo Ladisa on 3/28/13.
//  Copyright (c) 2013 Titto. All rights reserved.
//

#import "TTShopDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

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

    [scrollView setBackgroundColor:[UIColor clearColor]];

    [contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
    [[TTFoursquareManager sharedInstance]setDelegate:self];
    [[TTFoursquareManager sharedInstance] requestHoursInfoForIDVenue:[_infoDict objectForKey:@"foursquare"]];
    
    [[shadowLabel layer] setShadowColor:[UIColor blackColor].CGColor];
    [[shadowLabel layer] setShadowOffset:CGSizeMake(0, -3)];
    [[shadowLabel layer] setShadowOpacity:0.5];
    [[shadowLabel layer] setMasksToBounds:NO];

    [self setTitle:[_infoDict objectForKey:@"citta"]];

    NSString * stringURL;
    if ([[_infoDict objectForKey:@"img"] length]>0) {
        stringURL = [[NSString alloc]initWithString:[_infoDict objectForKey:@"img"]];
    }else{
        stringURL=[[NSString alloc] initWithFormat:@"https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-snc6/6641_450731964983584_410827480_n.jpg"];
    }

    NSData * dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]];
    UIImage *img = [[UIImage alloc]initWithData:dataImage];
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
    [emailContentLabel setText:[_infoDict objectForKey:@"mail"]];
    [emailContentLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

    
    [predefinedButton setTitle:@"Preferito" forState:UIControlStateNormal];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}

-(void)foursquareManagerDidGetHour:(NSArray *)hours{
    
    for (NSDictionary * info in hours) {
    
        NSDictionary * hours = [[info objectForKey:@"open"] objectAtIndex:0];
                
        for (id days in [info objectForKey:@"days"]) {
            
            NSString * startHour = [hours objectForKey:@"start"];
            NSString * endHour = [hours objectForKey:@"end"];
            
            
            startHour = [NSString stringWithFormat:@"%@:%@",[startHour substringToIndex:2],[startHour substringFromIndex:2]];
            
            endHour = [NSString stringWithFormat:@"%@:%@",[endHour substringToIndex:2],[endHour substringFromIndex:2]];
            
    
            switch ([days intValue]){
                case 1:
                    [lunediLabel setText:[NSString stringWithFormat:@"lun %@-%@",startHour,endHour]];
                    
                    [lunediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
                    break;
                case 2:
                    [martediLabel setText:[NSString stringWithFormat:@"mar %@-%@",startHour,endHour]];
                    [martediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 3:
                    [mercolediLabel setText:[NSString stringWithFormat:@"mer %@-%@",startHour,endHour]];
                    [mercolediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 4:
                    [giovediLabel setText:[NSString stringWithFormat:@"gio %@-%@",startHour,endHour]];
                    [giovediLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 5:
                    [venerdiLabel setText:[NSString stringWithFormat:@"ven %@-%@",startHour,endHour]];
                    [venerdiLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 6:
                    [sabatoLabel setText:[NSString stringWithFormat:@"sab %@-%@",startHour,endHour]];
                    [sabatoLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                case 7:
                    [domenicaLabel setText:[NSString stringWithFormat:@"dom %@-%@",startHour,endHour]];
                    [domenicaLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];

                    break;
                default:
                    break;
            }
        }
    }
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
