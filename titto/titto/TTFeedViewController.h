//
//  TTFeedViewController.h
//  titto
//
//  Created by Martino Bonfiglioli on 3/28/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTFeedViewController : UIViewController <UIWebViewDelegate>{
    
    UIView * noFavoriteShopView;
    UIView * noConnectionView;
    UIWebView * favoriteWebView;
    UIButton * shopButton;

    IBOutlet UIActivityIndicatorView * activityIndicator;

}

@end
