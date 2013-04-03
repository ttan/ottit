//
//  TTFeedViewController.m
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTFeedViewController.h"
#import "TTConfigDefines.h"

@interface TTFeedViewController ()

@end

@implementation TTFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Feed";
        self.tabBarItem.image = [UIImage imageNamed:@"first.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{

    if ([[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP_ADDRESS]){
        [self loadWebView];
    }else{
        [self loadNoFavoriteShopView];
    }
}


-(void)loadWebView{
    
    NSString * pvString = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP_ADDRESS];
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BASE_FEED_URL,pvString];
    
    if (noFavoriteShopView) {
        [noFavoriteShopView removeFromSuperview];
        noFavoriteShopView=nil;
    }
    
    if (!favoriteWebView) {
        favoriteWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
        [[self view] addSubview:favoriteWebView];
    }
    
    [favoriteWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

    
}


-(void)loadNoFavoriteShopView{
    
    if (favoriteWebView){
        [favoriteWebView removeFromSuperview];
        favoriteWebView=nil;
    }

    if (!noFavoriteShopView){
        noFavoriteShopView = [[UIView alloc]initWithFrame:self.view.frame];
        [noFavoriteShopView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];
        [[self view] addSubview:noFavoriteShopView];

        if (!shopButton) {

            UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 120, 240, 100)];
            [messageLabel setText:@"Seleziona il tuo negozio preferito per ricevere tutti gli aggiornamenti"];
            [messageLabel setBackgroundColor:[UIColor clearColor]];
            [messageLabel setNumberOfLines:3];
            [messageLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
            [messageLabel setTextColor:[UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1.0]];
            [messageLabel setTextAlignment:NSTextAlignmentCenter];
            [[self view] addSubview:messageLabel];

            shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [shopButton setFrame:CGRectMake(82, 250, 158, 46)];
            [shopButton setBackgroundImage:[UIImage imageNamed:@"bottone"] forState:UIControlStateNormal];
            [shopButton setTitle:@"Scegli il tuo negozio" forState:UIControlStateNormal];
            [shopButton addTarget:self action:@selector(setShopAction) forControlEvents:UIControlEventTouchUpInside];
            [[shopButton titleLabel]setFont:[UIFont fontWithName:@"Archer-Semibold" size:16]];
            [[self view] addSubview:shopButton];

        }
    }

}

-(void)setShopAction{
    
    [[self tabBarController] setSelectedIndex:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
