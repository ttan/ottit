//
//  TourTesseraViewController.h
//  titto
//
//  Created by Martino Bonfiglioli on 4/24/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "MCPagerView.h"

#define NUMBER_OF_PAGE 3

@interface TourTesseraViewController : UIViewController < UIScrollViewDelegate > {
    
    IBOutlet UIButton       *actionButton;
    IBOutlet UIScrollView   *scrollView;
    IBOutlet UIPageControl    *pageControl;
    
    NSUInteger currentIndex;
}

- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)pageControlValueChange:(id)sender;

@end
