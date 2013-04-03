//
//  TTShopDetailViewController.h
//  Map
//
//  Created by Paolo Ladisa on 3/28/13.
//  Copyright (c) 2013 Titto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFoursquareManager.h"
#import "TTHeaderImageView.h"

@interface TTShopDetailViewController : UIViewController<TTFoursquareManagerDelegate>
{
    NSDictionary * _infoDict;

    IBOutlet TTHeaderImageView * headerImageView;

    IBOutlet UIScrollView * scrollView;
    
    IBOutlet UILabel * shadowLabel;
    IBOutlet UIView * contentView;
    
    IBOutlet UILabel * indirizzoLabel;
    IBOutlet UILabel * cittaLabel;
    IBOutlet UILabel * orarioAperturaLabel;
    IBOutlet UILabel * lunediLabel;
    IBOutlet UILabel * martediLabel;
    IBOutlet UILabel * mercolediLabel;
    IBOutlet UILabel * giovediLabel;
    IBOutlet UILabel * venerdiLabel;
    IBOutlet UILabel * sabatoLabel;
    IBOutlet UILabel * domenicaLabel;
    IBOutlet UILabel * emailLabel;
    IBOutlet UILabel * emailContentLabel;

    IBOutlet UIButton * predefinedButton;
}

@property (nonatomic,strong)NSDictionary * infoDict;


@end
