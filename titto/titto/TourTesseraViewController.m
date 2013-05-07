//
//  TourTesseraViewController.m
//  titto
//
//  Created by Martino Bonfiglioli on 4/24/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import "TourTesseraViewController.h"

@interface TourTesseraViewController ()

@end

@implementation TourTesseraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        self.title = @"Come funziona?";
        
    }
    return self;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    scrollView.delegate = self;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionButtonPressed:)];
    
    [self.navigationController.topViewController.navigationItem setLeftBarButtonItem:item];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*NUMBER_OF_PAGE,
                                        scrollView.frame.size.height);
    
    for (int i = 0; i<NUMBER_OF_PAGE; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10.0f + (scrollView.frame.size.width)*i,
                                                                10.0f,
                                                                scrollView.frame.size.width - 20.0f,
                                                                scrollView.frame.size.height - 20.0f)];
        [view setBackgroundColor:[UIColor colorWithRed:0.0*i
                                                 green:0.0*i
                                                  blue:(0.2)+0.2*i
                                                 alpha:1.0f]];
        
        [view.layer setCornerRadius:8.0f];
        
        [scrollView addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2-150.0f/2,
                                                                   30.0f,
                                                                   150.0f,
                                                                   50.0f)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:30.0f]];
        [label setText:[NSString stringWithFormat:@"Pagina %i", i]];
        
        [view addSubview:label];
    }
    
    currentIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button

- (IBAction)actionButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 
                             }];
    
}

#pragma mark - PageControl

- (IBAction)pgValueChange:(id)sender {
    
    [scrollView scrollRectToVisible:CGRectMake(pageControl.currentPage*scrollView.frame.size.width,
                                               0.0f,
                                               scrollView.frame.size.width,
                                               scrollView.frame.size.height)
                           animated:YES];
    
}

#pragma mark - UIScrolView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView {
    
    if ( _scrollView.contentOffset.x/NUMBER_OF_PAGE != currentIndex ) {
        
        currentIndex = ((_scrollView.contentOffset.x+_scrollView.frame.size.width/2)/_scrollView.frame.size.width);
        [pageControl setCurrentPage:currentIndex];
        
    }
    
    NSLog(@"%f  %i", (_scrollView.contentOffset.x/_scrollView.frame.size.width), currentIndex  );
}

@end
