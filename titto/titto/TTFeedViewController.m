//
//  TTFeedViewController.m
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTFeedViewController.h"
#import "TTConfigDefines.h"
#import "Reachability.h"


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
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];

}

-(void)viewWillAppear:(BOOL)animated{

    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable){
        
        [activityIndicator startAnimating];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP]){

            [self loadWebView];
        }else{
            [self loadNoFavoriteShopView];
        }
    }else{
        [self loadNoConnectionView];
    }
}


-(void)loadWebView{
    
    NSString * pvString = [[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP] objectForKey:@"cod_fb"];
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BASE_FEED_URL,pvString];
    
    if (noFavoriteShopView) {
        [noFavoriteShopView removeFromSuperview];
        noFavoriteShopView=nil;
    }
    
    if (noConnectionView) {
        [noConnectionView removeFromSuperview];
        noConnectionView=nil;
    }
    
    if (!favoriteWebView) {
        favoriteWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
        [favoriteWebView setDelegate:self];
    }
    
    [favoriteWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [activityIndicator stopAnimating];
    [[self view] addSubview:favoriteWebView];

}

-(void)loadNoConnectionView{
    
    if (favoriteWebView){
        [favoriteWebView removeFromSuperview];
        favoriteWebView=nil;
    }

    if (noFavoriteShopView) {
        [noFavoriteShopView removeFromSuperview];
        noFavoriteShopView=nil;
    }

    if (!noConnectionView) {
        noConnectionView = [[UIView alloc]initWithFrame:self.view.frame];
        [noConnectionView setBackgroundColor:[UIColor clearColor]];
        [[self view] addSubview:noConnectionView];

        UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 280, 100)];
        [messageLabel setText:@"Hai bisogno di una connessione ad internet per visualizzare gli aggiornamenti"];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [messageLabel setNumberOfLines:4];
        [messageLabel setFont:[UIFont fontWithName:@"Archer-Semibold" size:20]];
        [messageLabel setTextColor:[UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1.0]];
        [messageLabel setTextAlignment:NSTextAlignmentCenter];
        [[self view] addSubview:messageLabel];

    }
}

-(void)loadNoFavoriteShopView{

    if (favoriteWebView){
        [favoriteWebView removeFromSuperview];
        favoriteWebView=nil;
    }

    if (noConnectionView) {
        [noConnectionView removeFromSuperview];
        noConnectionView=nil;
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
