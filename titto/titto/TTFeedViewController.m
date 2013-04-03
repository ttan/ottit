//
//  TTFeedViewController.m
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TTFeedViewController.h"
#import "TTConfigDefines.h"

#define BASE_URL @"http://www.titto.it/app/loadPage.php?pv="

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

    NSString * urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_SHOP_ADDRESS]];

    if (urlString){

        if (noFavoriteShopView) {
            [noFavoriteShopView removeFromSuperview];
            noFavoriteShopView=nil;
        }

        if (!favoriteWebView) {
            favoriteWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
            [favoriteWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
            [[self view] addSubview:favoriteWebView];
        }

    }else{

        if (favoriteWebView){
            [favoriteWebView removeFromSuperview];
            favoriteWebView=nil;
        }

        if (!noFavoriteShopView){
            noFavoriteShopView = [[UIView alloc]initWithFrame:self.view.frame];
            [noFavoriteShopView setBackgroundColor:[UIColor redColor]];
            [[self view] addSubview:noFavoriteShopView];

            
            if (!shopButton) {
                shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [shopButton setFrame:CGRectMake(110, 300, 100, 30)];
                [shopButton setTitle:@"Select your shop" forState:UIControlStateNormal];
                [shopButton addTarget:self action:@selector(setShopAction) forControlEvents:UIControlEventTouchUpInside];
                [[self view] addSubview:shopButton];
            }
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
