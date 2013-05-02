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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionButtonPressed:)];
    
    [self.navigationController.topViewController.navigationItem setLeftBarButtonItem:item];
    
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

@end
