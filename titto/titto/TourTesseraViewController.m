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
    [pageControl setPattern:@"aaa"];
    [pageControl setImage:[UIImage imageNamed:@"dot-not.png"]
         highlightedImage:[UIImage imageNamed:@"dot-sel.png"]
                   forKey:@"a"];
    
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
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f + (scrollView.frame.size.width)*i,
                                                                          0.0f,
                                                                          scrollView.frame.size.width - 20.0f,
                                                                          scrollView.frame.size.height - 40.0f)];
        
        [view setImage:[UIImage imageNamed:[NSString stringWithFormat:@"testo%i.png",i+1]]];
        
        [view setContentMode:UIViewContentModeCenter];
        [view setBackgroundColor:[UIColor clearColor]];
        
        [scrollView addSubview:view];

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
    
    [scrollView scrollRectToVisible:CGRectMake(pageControl.page*scrollView.frame.size.width,
                                               0.0f,
                                               scrollView.frame.size.width,
                                               scrollView.frame.size.height)
                           animated:YES];
    
}

#pragma mark - UIScrolView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView {
    
    if ( _scrollView.contentOffset.x/NUMBER_OF_PAGE != currentIndex ) {
        
        currentIndex = ((_scrollView.contentOffset.x+_scrollView.frame.size.width/2)/_scrollView.frame.size.width);
        [pageControl setPage:currentIndex];
        
        [UIView animateWithDuration:0.4f
                         animations:^{
                                 if (currentIndex==2) {
                                     actionButton.alpha = 1.0f;
                                 }else {
                                     actionButton.alpha = 0.0f;
                                 }
                         }];

    }
    
    NSLog(@"%f  %i", (_scrollView.contentOffset.x/_scrollView.frame.size.width), currentIndex  );
}

@end
